SetWorkingDir, %A_ScriptDir%
#Include <AHKhttp\AHKhttp>

;; Using library
x := Uri.Decode("example")
MsgBox % x