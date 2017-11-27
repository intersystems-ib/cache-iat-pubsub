Include IAT.PubSub

/// Simple generic publisher
Class IAT.PubSub.Publisher Extends %RegisteredObject
{

/// Send a message body to a channel
ClassMethod Send(pChannel As %String, pBody As MsgBody) As %Status
{
	set ret = $$$OK
	try {
		set header = ##class(MsgHeader).%New(pBody)
		$$$ThrowOnError(header.%Save())
		set id = header.%Id()
		
		set $$$Queue(pChannel,id)=""
		do $system.Event.Signal($$$ResourceName(pChannel),id)
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}

