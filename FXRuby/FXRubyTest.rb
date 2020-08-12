require "open3"
require "fox16"
include Fox

class MyHello < FXMainWindow
    def initialize(app, title="Hello!")
        main=super(app, title, :width=>323, :height=>200)

        btnHello=FXButton.new(main, "Click and say Hello!", :opts=>BUTTON_NORMAL|LAYOUT_CENTER_X|LAYOUT_CENTER_Y)

        btnHello.connect(SEL_COMMAND) do |sender, sel, data|
            msgBox=FXMessageBox.new(btnHello, "Hello from FxRuby", "Hello!", :opts=>MBOX_OK)
            msgBox.execute
        end

        self.connect(SEL_CLOSE, method(:on_close))
    end

    def on_close(sender, sel, event)
        puts "Executing Next Step.."
        Open3.popen3("AnotherRB.exe") { |stdin, stdout| print stdout.read }
        return 0
    end
end

puts "Loading First Step..."
Open3.popen3("AnotherRB.exe") { |stdin, stdout| print stdout.read }
        
app=FXApp.new
main=MyHello.new(app)
app.create
main.show(PLACEMENT_SCREEN)
app.run
