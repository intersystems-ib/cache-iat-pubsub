/// Message header for Publisher-Subscriber system.
Class IAT.PubSub.MsgHeader Extends %Persistent
{

/// Classname of the body referenced by this header. 
Property BodyClass As %String(MAXLEN = "");

/// ID of the body referenced by this header.
Property BodyId As %String;

/// Create a MsgHeader from a given MsgBody
Method %OnNew(pBody As MsgBody) As %Status [ Private, ServerOnly = 1 ]
{
	set ret = $$$OK
	try {
		if $isobject(pBody) {
			set ..BodyClass = $classname(pBody)
			set ..BodyId = pBody.%Id()
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

Storage Default
{
<Data name="MsgHeaderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BodyClass</Value>
</Value>
<Value name="3">
<Value>BodyId</Value>
</Value>
</Data>
<DataLocation>^IAT.PubSub.MsgHeaderD</DataLocation>
<DefaultData>MsgHeaderDefaultData</DefaultData>
<IdLocation>^IAT.PubSub.MsgHeaderD</IdLocation>
<IndexLocation>^IAT.PubSub.MsgHeaderI</IndexLocation>
<StreamLocation>^IAT.PubSub.MsgHeaderS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

