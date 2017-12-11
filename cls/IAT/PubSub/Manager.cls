Include IAT.PubSub

/// Publisher-Subscriber manager 
Class IAT.PubSub.Manager Extends %RegisteredObject
{

/// Setup Publisher-Subscriber system as specified in $$$Config global.
/// This method can be called periodically to check that jobs are running as configured.
/// Configuration global is expected to be like:
/// $$$Config(CHANNEL, "Subscriber", SUBSCRIBERSUBCLASS) = NUMBEROFPROCESSES
///  CHANNEL = channel name
///  SUBSCRIBERSUBCLASS = full name of the subscriber class (must extend from Subscriber)
///  NUMBEROFPROCESSES = number of processes that will be running subscriber class
ClassMethod Setup()
{
	set ret = $$$OK
	try {
		set channel=""
		for {
			set channel=$order($$$Config(channel))
			quit:channel=""
			
			$$$ThrowOnError(..AddChannel(channel))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Add a channel. 
/// It must be configured in $$$Config global.
ClassMethod AddChannel(pChannel As %String) As %Status
{
	set ret = $$$OK
	try {
		$$$LOG("channel="_pChannel)
			
		do $system.Event.Create($$$ResourceName(pChannel))
		set subscriber=""
		for {
			set subscriber=$order($$$Config(pChannel,"Subscriber",subscriber),1,numJobs)
			quit:subscriber=""
			
			$$$ThrowOnError(..AddSubscriber(pChannel, subscriber, numJobs))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Add a subscriber to a channel with a number of processes.
/// It must be configured in $$$Config global.
ClassMethod AddSubscriber(pChannel As %String, pSubscriber As %String, pNumJobs As %Integer) As %Status
{
	set ret = $$$OK
	try {
		// check dead, running subscriber jobs for channel
		set job="", runningJobs=0, deadJobs=""
		for {
			set job=$order($$$StatusChannel(pChannel, "Job", job))
			quit:job=""
			
			set process = ##class(%SYS.ProcessQuery).%OpenId(job)
			if process'=$$$NULLOREF {
				set runningJobs=runningJobs+1
			} else {
				set deadJobs=deadJobs_$listbuild(job)
			}
		}
		
		// clean dead jobs
		for i=1:1:$listlength(deadJobs) {
			$$$ThrowOnError(..CleanJob($listget(deadJobs,i)))
		}
		
		// create new jobs
		set newJobs = (pNumJobs-runningJobs)
		$$$LOG(pSubscriber_" config="_pNumJobs_" dead="_$ll(deadJobs)_" running="_runningJobs_" new="_newJobs)
		
		if newJobs > 0 {
			for i=1:1:newJobs {
				// start subscriber
				job $classmethod(pSubscriber, "Start", pChannel)
				
				// save job information
				set $$$StatusChannel(pChannel, "Job", $zchild)=""
				set $$$StatusJob($zchild, "Channel")=pChannel
				set $$$StatusJob($zchild, "Created")=$zdatetime($horolog,3)
			}
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Terminate all running subscriber jobs.
ClassMethod TerminateAll()
{
	set ret = $$$OK
	try {
		set job=""
		for {
			set job=$order($$$StatusJob(job))
			quit:job=""
			$$$ThrowOnError(..Terminate(job))
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Terminate a specific subscriber job.
ClassMethod Terminate(pJob As %String) As %Status
{
	set ret = $$$OK
	try {
		$$$LOG(pJob)
		do $system.Process.Terminate(pJob)
		$$$ThrowOnError(..CleanJob(pJob))
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Loop over $$$Queue and notify subscriber processes.
/// This method should be used ONLY when system has been shut down and event queue must be reprocessed.
ClassMethod RestartQueue()
{
	set ret = $$$OK
	try {
		set channel=""
		for {
			set channel = $order($$$Queue(channel))
			quit:channel=""
			
			set id = "", numMessages=0
			for {
				set id = $order($$$Queue(channel,id))
				quit:id=""
				
				$$$LOG(channel_"->"_id)
				do $system.Event.Create($$$ResourceName(channel))
				do $system.Event.Signal($$$ResourceName(channel), id)
			}
		}
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

/// Clean saved data for a job in Publisher-Subscriber data structures. 
ClassMethod CleanJob(pJob As %String) As %Status
{
	set ret = $$$OK
	try {
		set channel = $get($$$StatusJob(pJob, "Channel"))
		if channel'="" {
			kill $$$StatusChannel(channel, "Job", pJob)
		}
			
		kill $$$StatusJob(pJob)
	} catch ex {
		set ret = ex.AsStatus()
	}
	quit ret
}

}

