# 次はEncodingの実験
# 一番うまく言った方法
# エンターキーは2回必要だが…
# まず、プロンプトはWindows-31Jなる文字コードを使用するので
# これで受け取る
STDIN.set_encoding "Windows-31J"
str = gets.chomp

# ほんで、前後に無効文字が含まれるらしく、
# それを次の表記で強制的に取り除く
# 次の通りで動くが、
#puts str.encode("utf-8", invalid: :replace, replace: '')

# 無効文字を削除すれば、わざわざutf-8に変換しなくてもいいっぽい
# つまり次の通り
puts str.encode("Windows-31J", invalid: :replace, replace: '')

# これでevalいけるか
eval str
# 試しに puts "あああ"+"いいい"とかやると...
# OKみたいです