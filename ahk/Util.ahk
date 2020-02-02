SetWorkingDir, % A_ScriptDir
#Include C:\Users\nikit\dev\pahket\ahk\Jxon.ahk

print(msg)
{
  ; TODO: Load port from env var
  BaseURL := "http://localhost:3000"
  Http := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
  ; Send the request
  Http.Open("POST", BaseURL . "/log", False)
  Http.SetRequestHeader("Content-Type", "application/json")
  Http.Send(Jxon_Dump(msg))

  ; Request was unsuccessful
  if (Http.status != 200 && Http.status != 204)
  {
    throw Exception("Request failed: " Http.status
      ,, Method " " Endpoint "`n" Http.responseText)
  }
  ToolTip, % msg
}

print("hello")
print("hello1")
print("hello2")
print("hello3")