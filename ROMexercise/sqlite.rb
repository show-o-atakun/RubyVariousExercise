require 'sqlite3'

# testというデータベースを作成
db = SQLite3::Database.new 'test.db'

# idとnameを持つusersテーブルを作成するSQL
sql = <<-SQL
  create table users (
    id integer primary key,
    name text
  );
SQL

# usersテーブルを作成する
db.execute(sql)

# テーブルにレコードを書き込む
db.execute('insert into users (name) values (?)', 'sample1')
db.execute('insert into users (name) values (?)', 'sample2')

# selectでデータを出力する
db.execute('select * from users') do |row|
  p row
end
 