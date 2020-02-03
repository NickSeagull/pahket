;; Interoperation with the HTTP server on the Haskell side
;; This class shouldn't be used except by some of the Pahket's
;; StdLib functions.
class __Pahket__ {
  ;; 'sendRequest' method copied from G33kDudes Discord.ahk/CallAPI.
  ;; Source:
  ;; https://github.com/G33kDude/Discord.ahk/blob/master/Discord.ahk#L22
  sendRequest(requestType, endpoint, data="")
  {
    Http := ComObjCreate("WinHTTP.WinHTTPRequest.5.1")
    Http.Open(requestType, __PahketBaseURL__ . endpoint, False)
    Http.SetRequestHeader("Content-Type", "application/json")
    (data ? Http.Send(Jxon_Dump(data)) : Http.Send())
    if (Http.status != 200 && Http.status != 204)
    {
      throw Exception("Request failed: " Http.status
        ,, Method " " Endpoint "`n" Http.responseText)
    }
    return this.Jxon_Load(Http.responseText)
  }

  exitServer()
  {
    this.sendRequest("GET", "/end")
  }

  stdout(msg)
  {
    this.sendRequest("POST", "/stdout", msg)
  }
}