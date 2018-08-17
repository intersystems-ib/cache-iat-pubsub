/// Example of message used for Patient channel
Class IAT.PubSub.Example.MsgPatient Extends IAT.PubSub.MsgBody
{

Property MRN As %String;

Property Name As %String;

Property LastName As %String;

Property DOB As %String;

Storage Default
{
<Data name="MsgPatientDefaultData">
<Subscript>"MsgPatient"</Subscript>
<Value name="1">
<Value>MRN</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>LastName</Value>
</Value>
<Value name="4">
<Value>DOB</Value>
</Value>
</Data>
<DefaultData>MsgPatientDefaultData</DefaultData>
<Type>%Library.CacheStorage</Type>
}

}

