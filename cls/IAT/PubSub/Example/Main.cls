Include IAT.PubSub

/// Simple test class for Publisher-Subscriber.
/// <pre>
/// ; create events and subscriber jobs
/// do ##class(IAT.PubSub.Example.Main).Setup()
/// ; send some messages to channels
/// do ##class(IAT.PubSub.Example.Main).Run()
/// ; show log
/// zw ^PubSub.Log
/// </pre>
Class IAT.PubSub.Example.Main Extends %RegisteredObject
{

Parameter ChannelPatient = "Patient";

Parameter ChannelDummy = "Dummy";

/// Config and setup Publisher-Subscriber 
ClassMethod Setup() As %Status
{
	set ret = $$$OK
	try {
		set $$$Config(..#ChannelPatient, "Subscriber", "IAT.PubSub.Example.SubPatient") = 4
		set $$$Config(..#ChannelDummy, "Subscriber", "IAT.PubSub.Example.SubDummy") = 2
		$$$ThrowOnError(##class(IAT.PubSub.Manager).Setup())
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Delete messages
ClassMethod Delete() As %Status
{
	set ret = $$$OK
	try {
		$$$ThrowOnError(##class(IAT.PubSub.MsgBody).%DeleteExtent())
		$$$ThrowOnError(##class(IAT.PubSub.MsgHeader).%DeleteExtent())
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Run tests. Send some messages channels.
ClassMethod Run(pNum As %Integer = 5) As %Status
{
	set ret = $$$OK
	try {
		$$$ThrowOnError(..SendPatient(pNum))
		$$$ThrowOnError(..SendDummy(pNum))
	} catch ex {
		set ret = ex.AsStatus()
		$$$LOG($system.Status.GetErrorText(ret))
	}
	quit ret
}

/// Publish messages in patient channel
ClassMethod SendPatient(pNum As %Integer = 5) As %Status
{
	set ret = $$$OK
	try {
		for i=1:1:pNum {
			set data = ##class(IAT.PubSub.Example.MsgPatient).%New()
			set data.MRN = i
			set data.Name = i
			set data.LastName = i
			$$$ThrowOnError(data.%Save())
			
			$$$LOG("Sending data "_i_" to "_..#ChannelPatient)
			$$$ThrowOnError(##class(IAT.PubSub.Publisher).Send(..#ChannelPatient, data))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Publish messages in dummy channel
ClassMethod SendDummy(pNum As %Integer = 5) As %Status
{
	set ret = $$$OK
	try {
		for i=1:1:pNum {
			set data = ##class(IAT.PubSub.Example.MsgDummy).%New()
			set data.Text = i
			$$$ThrowOnError(data.%Save())
			
			$$$LOG("Sending data "_i_" to "_..#ChannelDummy)
			$$$ThrowOnError(##class(IAT.PubSub.Publisher).Send(..#ChannelDummy, data))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}

