Class IAT.PubSub.Example.MsgOrder Extends IAT.PubSub.MsgBody
{

Property Number As %String;

Property Description As %String;

Storage Default
{
<Data name="MsgOrderDefaultData">
<Subscript>"MsgOrder"</Subscript>
<Value name="1">
<Value>Number</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
</Data>
<DefaultData>MsgOrderDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

