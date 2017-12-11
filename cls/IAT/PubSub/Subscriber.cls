Include IAT.PubSub

/// Generic subscriber for Publisher-Subscriber system.
/// All subscriber *MUST* extend from this class.
Class IAT.PubSub.Subscriber Extends %RegisteredObject
{

/// Subscribed channel
Property Channel As %String;

/// Resource name for subscribed channel (see $system.Event) 
Property Resource As %String;

/// Header of the message received. 
Property Header As MsgHeader;

/// Start running subscriber. 
ClassMethod Start(pChannel As %String) As %Status
{
	set ret = $$$OK
	try {
		$$$LOG(pChannel)
		set obj = ..%New(pChannel)
		if obj=$$$NULLOREF $$$ThrowStatus(%objlasterror)
		do obj.Run()
	} catch ex {
		set ret = ex.AsStatus()
		$$$LOG($system.Status.GetErrorText(ret))
	}
	quit ret
}

/// Create a Subscriber from a given channel.
Method %OnNew(pChannel As %String) As %Status [ Private, ServerOnly = 1 ]
{
	set ret = $$$OK
	try {
		set ..Channel = pChannel
		set ..Resource = $$$ResourceName(pChannel)
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Subscriber run method. Wait for a message and process it.
/// User *MUST* implement OnMessage callback.
Method Run() As %Status
{
	set ret = $$$OK
	try {
		for {
			// wait until a message is received
			set data = $system.Event.WaitMsg(..Resource)
			
			// retrieve data from event
			set code = $listget(data,1)
			set headerId = $listget(data,2)
			
			// dequeueu message from queue
			kill $$$Queue(..Channel, headerId)
			$$$LOG("Grabs: "_headerId)
			
			// instantiate message header
			set ..Header = ##class(MsgHeader).%OpenId(headerId)
			$$$LOG(..Header.BodyClass_" "_..Header.BodyId)
			
			// instantiate message body
			set body = $classmethod(..Header.BodyClass, "%OpenId", ..Header.BodyId)
			
			// execute user callback for given body
			$$$ThrowOnError(..OnMessage(body))
		}
	} catch ex {
		set ret = ex.AsStatus()
		$$$LOG($system.Status.GetOneErrorText(ret))
	}
}

/// Callback that is called when a message is received by subscriber
Method OnMessage(pBody As IAT.PubSub.MsgBody) As %Status
{
	quit $$$ERROR($$$NotImplemented)
}

}

