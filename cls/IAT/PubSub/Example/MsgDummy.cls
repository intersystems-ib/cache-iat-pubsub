/// Example of message used for Patient channel
Class IAT.PubSub.Example.MsgDummy Extends IAT.PubSub.MsgBody
{

Property Username As %String [ InitialExpression = {$username} ];

Property Timestamp As %TimeStamp [ InitialExpression = {$zdatetime($horolog,3)} ];

Property Text As %String(MAXLEN = 500);

Storage Default
{
<Data name="MsgDummyDefaultData">
<Subscript>"MsgDummy"</Subscript>
<Value name="1">
<Value>Username</Value>
</Value>
<Value name="2">
<Value>Timestamp</Value>
</Value>
<Value name="3">
<Value>Text</Value>
</Value>
</Data>
<DefaultData>MsgDummyDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

