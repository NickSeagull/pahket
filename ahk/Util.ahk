print(msg)
{
  ; TODO: Load port from env var
  BaseURL := "http://localhost:3000"
  Http := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
  ; Send the request
  Http.Open("POST", BaseURL . "/stdout", False)
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

pahket_exit_server()
{
  ; TODO: Load port from env var
  BaseURL := "http://localhost:3000"
  Http := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
  ; Send the request
  Http.Open("GET", BaseURL . "/end", False)
  Http.Send()

  ; Request was unsuccessful
  if (Http.status != 200 && Http.status != 204)
  {
    throw Exception("Request failed: " Http.status
      ,, Method " " Endpoint "`n" Http.responseText)
  }
  ToolTip, % msg
}
