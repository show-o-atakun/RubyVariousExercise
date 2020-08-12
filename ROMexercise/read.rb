require 'rom-repository'
require 'rom-sql'
require 'sqlite3'

class UserRepo < ROM::Repository[:users]
    commands :create
  
    def query(conditions)
      users.where(conditions).to_a
    end
  
    def by_id(id)
      users.by_pk(id).one!
    end
end


rom = ROM.container(:sql, 'sqlite://test_db.sqlite') do |conf|
    conf.default.create_table(:users) do
      primary_key :id
      column :name , String, null: false
      column :email, String, null: false
    end
  
    class Users < ROM::Relation[:sql]
        schema(infer: true)
    end
    
    conf.register_relation(Users)
end

user_repo = UserRepo.new(rom)

user = user_repo.create(name: "Jane", email: "jane@doe.org")
user = user_repo.create(name: "Jane", email: "jane@example.com")

p user_repo.query(name: "Jane")
# => [#<ROM::Struct::User id=1 name="Jane" email="jane@doe.org">, #<ROM::Struct::User id=2 name="Jane" email="jane@example.com">]

p user_repo.by_id(2)