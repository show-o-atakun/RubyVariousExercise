require 'rom-repository'
require 'rom-sql'
require 'sqlite3'

rom = ROM.container(:sql, 'sqlite::memory') do |conf|

    # とりあえずテーブルができるらしい=========
    conf.default.create_table(:users) do
      primary_key :id
      column :name , String, null: false
      column :email, String, null: false
    end
  
    # Relation = 「低レベルなCRUDを実現するところ」
    # schemaではデータアイテムの定義をしている
    # infer:trueというのは、一つ一つのアイテムの定義を省略する記法
    # この時点ではconf.register_relationで登録されるにとどまっているが
    # 地味にこの中にメソッドを書いていろいろできる。
    class Users < ROM::Relation[:sql]
      schema(infer: true)
    end

    conf.register_relation(Users)
    # =========================================

    # ROMで扱うクラスの例
    class RomTreated
      attr_reader :id, :name, :email
      
      def initialize(attributes)
        @id, @name, @email = attributes.values_at(:id, :name, :email)
      end

      def to_s
        "id: #{@id}\nname: #{@name}\nemail: #{@email}"
      end
    end

    # DB操作のためのメソッドを定義するところ
    # < ROM::Repository 継承クラスを用いる
    class UserRepo < ROM::Repository[:users]
      # CRUD のうちCUDコマンドの定義
      # というか、updateやdeleteメソッドが外部呼出しされたら
      # これらのメソッドで代替しろってことなんだと思う
      # by_pkについては後述。
      commands :create,  update: :by_pk, delete: :by_pk
    
      # Read用コマンドの定義==========
      def query(conditions)
        # 最初は受け取ったデータをStruct配列に変換する例
        # whereはRelationを条件で絞り込む
        # usersはRelation…らしい。
        # 定義らしきものは上の:usersぐらいし見当たらないが、
        # それか？後述に期待
        ## users.where(conditions).to_a

        # #to_aではなく#map_toで自分で定義したクラスに変換可能
        users.where(conditions).map_to(RomTreated)
      end

      def by_id(id)
        users.by_pk(id).one! #by_pkはRelationを主キーで絞り込む
        # one!はRelationをStructに変換する。
        # ただし結果が1件の時だけ通る。0 or 複数件ではエラー。
      end
      # =============================

    end
  
end


# UserRepoをインスタンス定義して
user_repo = UserRepo.new(rom)

# createでレコードの保存とuserインスタンスの生成が行われる
## 「DB操作(UserRepo)と、
## 　レコードをマップしたインスタンス(user_repo.createのreturn)が
## 　別のオブジェクトである」(これは次のupdateでよくわかる)
user = user_repo.create(name: "Jane", email: "jane@doe.org")

# このマップされたインスタンスを表示してみよう
puts user.id
puts user.name

# データのアップデート
updated_user = user_repo.update(user.id, name: "Jane Doe")

## 次のようにはできない
# user.name = "Jane Doe"
## これは、マップしたインスタンスがDB操作と別である
## (DB操作を負わない)ことをよく表している

# 削除は次の通り
# 当然、DB操作を負うオブジェクト user_repoのほうで行う。
# user_repo.delete(user_id)

# 次は、ユーザー定義クラスをmap_toメソッドで変換して受け取る例
mapped_user = user_repo.query(name: "Jane Doe").first
puts mapped_user.class
print mapped_user
