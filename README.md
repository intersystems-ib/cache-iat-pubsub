# Caché Publisher - Subscriber

The purpose of this repository is to provide a simple example of *Publisher-Subscriber model* implemented using [InterSystems Caché](http://www.intersystems.com/our-products/cache/cache-overview/).

This example came out of a session which discussed ways of processing work **asynchronously** using **persistent queues**.

## Installation
```
set path="C:\Temp\cache-iat-pubsub-master\cache"
do $system.OBJ.ImportDir(path,"*.inc","ck",.error,1)
do $system.OBJ.ImportDir(path,"*.xml","ck",.error,1)
```

## Run the code
```
; create events and subscriber jobs
do ##class(IAT.S05.PubSub.Example.Main).Setup()
; send some messages to channels
do ##class(IAT.S05.PubSub.Example.Main).Run()
; show log
zwrite ^PubSub.Log
```

## Implementation
[Caché Event API](http://docs.intersystems.com/cache20152/csp/documatic/%25CSP.Documatic.cls?LIBRARY=samples&CLASSNAME=%25SYSTEM.Event&MEMBER=&CSPCHD=001000000000Np0VyNuBwTDT$PiD99hk51sfrKUAanvu8tIi0c&CSPSHARE=1) is used to let the subscriber processes sleep until they are notified. 

### Main classes
* Manager - handles core operations such as adding subscribers, terminate all subscriber jobs, etc.
* Publisher - generic publisher, provides a basic *Send* operation which notifies a subscriber that a message is ready.
* Subscriber - generic subscriber, all subscriber must extend from this.
![](https://dl.dropboxusercontent.com/u/2198214/ISC/images/Events_PubSub_Classes1.png)

### Example classes
The following classes provides an example of how the main classes could be used, in this case there are two subscribers:
* *SubPatient* which handles Patient related messages.
* *SubDummy* which handles dummy messages.
![](https://dl.dropboxusercontent.com/u/2198214/ISC/images/Events_PubSub_Classes2.png)

### Log
After running the example, the log stored in *^PubSub.Log* global will look similar to this:
![](https://dl.dropboxusercontent.com/u/2198214/ISC/images/Events_PubSub_Log.png)

### Further discussion
There are several points of this example that can be discussed as an exercise:

#### Caché Event API vs Semaphores
* **$system.Event** (Caché Event API) can only wait / wake up resources on the **same system** (not networking supported).
* It would be interesting implementing this same model using **$system.Semaphore** over an *ECP* scenario.

#### Multiple types of subscribers
* In *IAT.PubSub.Publisher:Send()* method, it simply creates a message header, save it to queue and send a signal to one of the subscribers.
* It would be interesting allowing more than one type of subscriber per channel. In this case, the *Send()* method should create several message headers and signal the different types of configured subscribers.
