Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "msiexec.exe /?",1,False
Set WshShell = Nothing