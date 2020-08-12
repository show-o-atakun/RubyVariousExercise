require 'rom-repository'

#rom = ROM.container(:sql, 'sqlite::memory') do |conf|
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