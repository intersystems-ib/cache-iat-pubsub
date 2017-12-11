/// Subscriber for Patient channel
Class IAT.PubSub.Example.SubPatient Extends IAT.PubSub.Subscriber
{

/// Callback that is called when a message is received by subscriber
Method OnMessage(pBody As IAT.PubSub.Example.MsgPatient) As %Status
{
	set ret = $$$OK
	try {
		$$$LOG("MsgPatient. ID="_pBody.%Id()_" Name="_pBody.Name)
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}

