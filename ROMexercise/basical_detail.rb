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
  
    class Users < ROM::Relation[:sql]
      schema(infer: true)
    end

    conf.register_relation(Users)
    # =========================================

    # DB操作のためのメソッドを定義するところ
    # < ROM::Repository 継承クラスを用いる
    class UserRepo < ROM::Repository[:users]
        # コマンドの定義
        commands :create, update: :by_pk, delete: :by_pk
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


