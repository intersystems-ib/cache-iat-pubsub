^INC^Save for Source Control^^~Format=Cache.S~^UTF8
%RO
IAT.PubSub^INC^^^0
#; Publisher-Subscriber
.
#; Utils
#define CurrentClass         		$classname()
#define CurrentMethod        		##safeexpression(""""_$get(%methodname)_"""")
.
#; Resource name for a channel (see $system.Event) 
#define ResourceName(%channel)		"PubSub"_%channel
.
#; Configuration:
#;   $$$Config(CHANNEL, "Subscriber", SUBSCRIBERSUBCLASS) = NUMBEROFPROCESSES
#define Config                		^PubSub.Config
.
#; Status of running jobs:
#;   $$$StatusJob(JOB, "Channel")=CHANNEL
#;   $$$StatusJob(JOB, "Created")=TIMESTAMP
#define StatusJob                	^PubSub.StatusJob
.
#; Status of running channels:
#;   $$$StatusChannel(CHANNEL, "Job", JOB)=""
#define StatusChannel            	^PubSub.StatusChannel
.
#; Persistent Queue
#;   $$$Queue(CHANNEL, HEADERID)
#define Queue						^PubSub.Queue
.
#; Traces
#define LOG(%txt)					set ^PubSub.Log($i(^PubSub.Log),$$$CurrentClass,$$$CurrentMethod,$job,$ztime($p($h,",",2),1))=%txt
.
#define DEBUGMODE 1
#define LOGDEBUG(%txt)     	##continue
#if $$$DEBUGMODE           	##continue
 $$$LOG(%txt) 				##continue
#endif



