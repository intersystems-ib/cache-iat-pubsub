/// Subscriber for Patient channel
Class IAT.PubSub.Example.SubDummy Extends IAT.PubSub.Subscriber
{

/// Callback that is called when a message is received by subscriber
Method OnMessage(pBody As IAT.PubSub.Example.MsgDummy) As %Status
{
	set ret = $$$OK
	try {
		$$$LOG("MsgDummy. ID="_pBody.%Id()_" Text="_pBody.Text)
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}

