/// Generic message body for Publisher-Subscriber system.
/// All messages MUST extend from this class.
Class IAT.PubSub.MsgBody Extends %Persistent
{

Storage Default
{
<Data name="MsgBodyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^IAT.PubSub.MsgBodyD</DataLocation>
<DefaultData>MsgBodyDefaultData</DefaultData>
<IdLocation>^IAT.PubSub.MsgBodyD</IdLocation>
<IndexLocation>^IAT.PubSub.MsgBodyI</IndexLocation>
<StreamLocation>^IAT.PubSub.MsgBodyS</StreamLocation>
<Type>%Library.CacheStorage</Type>
}

}

