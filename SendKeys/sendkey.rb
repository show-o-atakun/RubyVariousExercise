require "win32ole"
wsh = WIN32OLE.new ("Wscript.Shell")
wsh.Run ("notepad.exe")
sleep(0.2)
wsh.AppActivate ("Visual Studio Code")
wsh.SendKeys ("ls{ENTER}")