class Test
    attr_reader :num
    
    def initialize(num)
        @num=num
    end

    # 別に演算子のオーバーロードを試したかったわけではないが
    # やっていくうちに不安になったのでメモ
    # def plus でも同じ効果になるので注意
    def +(other)
        return Test.new(@num + other.num)
    end

    #まあ、eval中で newtst=tstcls+tstcls2とかやっても
    #新しい変数はeval外で反映されないので面白くないけど。
    #次のオーバーライドで puts tstcls+tstcls2 ってやれば
    #+演算子が機能していることはわかるよ。
    def to_s
        "number is " + @num.to_s
    end
end

tstcls = Test.new(2)
tstcls2 = Test.new(3)

#ほんとにやりたかっとのはここから
#StandardError以外のエラーの補足
while true
    begin
        eval gets 
    rescue SyntaxError => e
        puts "シンタックスエラーです。オリジナルメッセージ:"
        puts e
        puts "続行します"
    rescue StandardError => e
        puts "その他のエラー"
        puts e
    end
    puts "\n"
end