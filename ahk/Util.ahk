#NoEnv
SetBatchLines, -1

new Example("wss://127.0.0.1:80/")
return


class Example extends WebSocket
{
	OnOpen(Event)
	{
		this.Send("Hi! I am John")
	}

	OnMessage(Event)
	{
		MsgBox, % "Received Data: " Event.data
		this.Close()
	}

	OnClose(Event)
	{
		MsgBox, Websocket Closed
		this.Disconnect()
	}

	OnError(Event)
	{
		MsgBox, Websocket Error
	}

	__Delete()
	{
		MsgBox, Exiting
		ExitApp
	}
}