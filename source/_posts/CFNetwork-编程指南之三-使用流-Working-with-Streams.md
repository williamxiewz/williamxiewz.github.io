title: 'CFNetwork 编程指南之三: 使用流(Working with Streams)'
date: 2016-08-10 11:57:01
categories: iOS网络编程
tags: CFNetwork
---
#Working with Streams

本文讨论如何创建、打开和检查读写流错误。它还描述了如何从读取流读取信息，如何从写入信息到写入流，如何在读取或写入流时防止阻塞以及如何通过代理服务器导航到流。

##使用读取流
核心基础流可用于读取或写入文件或使用网络套接字。除了创建这些流过程中的异常，其他行为类似。

###创建一个读取流
首先创建一个读取流。列表2-1为一个文件创建读取流。

列表2-1 为一个文件创建读取流

```c
CFReadStreamRef myReadStream = CFReadStreamCreateWithFile(kCFAllocatorDefault, fileURL);
```
<!-- more -->
在这个列表中，`kCFAllocatorDefault` 参数指定当前默认系统分配器来为流分配内存，fileURL 参数指定读取流创建到的文件名称，例如 `file:///Users/joeuser/Downloads/MyApp.sit`

类似的，你可以通过调用[CFStreamCreatePairWithSocketToCFHost](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFStreamConstants/index.html#//apple_ref/c/func/CFStreamCreatePairWithSocketToCFHost)（在使用运行循环阻止阻塞（[Using a Run Loop to Prevent Blocking](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFStreamTasks/CFStreamTasks.html#//apple_ref/doc/uid/TP30000230-62233)）中有描述）或者[CFStreamCreatePairWithSocketToNetService](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFStreamConstants/index.html#//apple_ref/c/func/CFStreamCreatePairWithSocketToNetService)（在NSNetServices and CFNetServices 编程指南（[NSNetServices and CFNetServices Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/NSNetServiceProgGuide/Introduction.html#//apple_ref/doc/uid/TP40002736)）中有描述）来创建一对基于网络服务的流。

现在，你已经创建流，你可以打开它。打开流将导致流保留需要的任何系统资源，例如打开文件所需的文件描述符。列表2-1是一个打开读取流的例子。

列表2-2 打开读取流

```c
if (!CFReadStreamOpen(myReadStream)) {  
     CFStreamError myErr = CFReadStreamGetError(myReadStream);  
       // An error has occurred.     
     if (myErr.domain == kCFStreamErrorDomainPOSIX) {  
         // Interpret myErr.error as a UNIX errno.    
     } else if (myErr.domain == kCFStreamErrorDomainMacOSStatus) {   
        // Interpret myErr.error as a MacOS error code.  
        OSStatus macError = (OSStatus)myErr.error;     
        // Check other error domains.    
     }
}
```

`CFReadStreamOpen` 函数返回`TRUE` 表示成功，`FALSE` 表示由于某种原因打开失败。如果`CFReadStreamOpen` 返回`FALSE`，例子调用`CFReadStreamGetError` 函数，将返回`CFStreamError` 类型结构，包含两个值：一个域代码和一个错误代码。域代码表明错误代码应该如何解释。例如，如果域代码是`kCFStreamErrorDomainPOSIX`，错误代码是`UNIX errno`值。其他错误域是`kCFStreamErrorDomainMacOSStatus`，表明错误代码是一个定义在`MacErrors.h`中的`OSStatus` 值，`kCFStreamErrorDomainHTTP`表明错误代码是`CFStreamErrorHTTP` 枚举中定义的值。

打开一个流是一个漫长的过程，所以`CFReadStreamOpen` 函数和`CFWriteStreamOpen` 函数返回`TRUE` 表明打开流的过程已经开始，来避免阻塞。为了检查打开的装填，可以调用`CFReadStreamGetStatus` 和`CFWriteStreamGetStatus`函数，如果仍处于打开过程则返回``kCFStreamStatusOpening`，如果已经打开则返回`kCFStreamStatusOpen` ，如果已经打开但失败了则返回`kCFStreamStatusErrorOccurred`。在大多数情况下，打开是否完成无关紧要，因为`CFStream`函数的读写将会阻塞直到打开流。

###从读取流中读取信息
从读取流中读取信息，调用函数`CFReadStreamRead`，这个函数类似于`UNIX read()` 系统调用。两者都采用缓存区和缓存区长度作为参数。两者都返回读取的字节数，在流或文件末尾则返回0，错误发生则返回-1.两者都阻塞直到可以读取一个字节并继续读取。列表2-3是从读取流中读取信息的例子。

列表2-3 从读取流（blocking）中读取信息

```c
CFIndex numBytesRead;
do {   
   UInt8 buf[myReadBufferSize]; 
    // define myReadBufferSize as desired  
    numBytesRead = CFReadStreamRead(myReadStream, buf, sizeof(buf)); 

    if( numBytesRead > 0 ) {     
      handleBytes(buf, numBytesRead);  
    } else if( numBytesRead < 0 ) {  
      CFStreamError error = CFReadStreamGetError(myReadStream);       
           reportError(error);    
    }

} while( numBytesRead > 0 );

```


###释放读取流
当所有数据都被读取，你可以调用CFReadStreamClose 函数关闭流，从而释放有关系统资源。然后通过调用[CFRelease](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFTypeRef/index.html#//apple_ref/doc/c_ref/CFRelease)函数释放流引用。你可以设置引用为NULL使其无效。如列表2-4的例子。

列表2-4 释放读取流

```c
CFReadStreamClose(myReadStream);
CFRelease(myReadStream);
myReadStream = NULL;
```


##使用写入流
使用写入流类似于使用读取流。一个主要的区别是[CFWriteStreamWrite](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamWrite) 函数并不能保证接收你传递给它的所有字节。相反，CFWriteStreamWrite 返回它接收的字节数。你会看到列表2-5中的实例代码，如果写入的字节数与需要写入的总字节数不一致，缓存区会调整并适应这一点。

列表2-5 创建、打开、写入并释放写入流

```c
CFWriteStreamRef myWriteStream =
        CFWriteStreamCreateWithFile(kCFAllocatorDefault, fileURL);
if (!CFWriteStreamOpen(myWriteStream)) {
    CFStreamError myErr = CFWriteStreamGetError(myWriteStream);
    // An error has occurred.
    if (myErr.domain == kCFStreamErrorDomainPOSIX) {
    // Interpret myErr.error as a UNIX errno.
    } else if (myErr.domain == kCFStreamErrorDomainMacOSStatus) {
        // Interpret myErr.error as a MacOS error code.
        OSStatus macError = (OSStatus)myErr.error;
        // Check other error domains.
    }
}
UInt8 buf[] = “Hello, world”;
CFIndex bufLen = (CFIndex)strlen(buf);
 
while (!done) {
    CFIndex bytesWritten = CFWriteStreamWrite(myWriteStream, buf, (CFIndex)bufLen);
    if (bytesWritten < 0) {
        CFStreamError error = CFWriteStreamGetError(myWriteStream);
        reportError(error);
    } else if (bytesWritten == 0) {
        if (CFWriteStreamGetStatus(myWriteStream) == kCFStreamStatusAtEnd) {
            done = TRUE;
        }
    } else if (bytesWritten != bufLen) {
        // Determine how much has been written and adjust the buffer
        bufLen = bufLen - bytesWritten;
        memmove(buf, buf + bytesWritten, bufLen);
 
        // Figure out what went wrong with the write stream
        CFStreamError error = CFWriteStreamGetError(myWriteStream);
        reportError(error);
 
    }
}
CFWriteStreamClose(myWriteStream);
CFRelease(myWriteStream);
myWriteStream = NULL;

```

##使用流时防止阻塞

当使用流来通信时，特别是基于套接字的流，数据传输可能需要很长时间。如果你同步执行你的流，你的整个应用将被迫等待数据传输。因此，强烈建议你的代码使用替代方法来防止阻塞。

当读取或写入一个CFStream对象时，有两种方法可以防止阻塞：

- 使用一个运行循环——注册账户接收stream-related 事件并安排流到一个运行循环上。当stream-related 事件发生时，调用你的回调函数（注册调用时指定）。

- 轮询——对于读取流，在读取流之前找出是否有需要读取的字节。对于写入流，在写入流之前找出流是否可以无阻塞的写入。

将在以下章节中讨论这些方法。

###使用运行循环防止阻塞
使用流的首选方法是运行循环。运行循环在你的主线程上执行。等待事件发生，然后调用与给定事件相关的函数。

在网络传输的情况下，当你的注册事件发生时，你的回调函数被运行循环执行。这样你可以不必轮询你的套接字流，可以减缓线程。

关于运行循环的更多信息，参阅线程编程指南（[Threading Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Multithreading/Introduction/Introduction.html#//apple_ref/doc/uid/10000057i)）。

这个例子首先创建一个套接字读取流：

```c
CFStreamCreatePairWithSocketToCFHost(kCFAllocatorDefault, host,port,
                                  &myReadStream, NULL);
```


CFHost对象引用、host指定远程主机为读取流的主机，port 参数指定主机使用的端口号。CFStreamCreatePairWithSocketToCFHost 函数返回新的读取流引用myReadStream。最后一个参数NULL表明调用者不希望创建写入流。如果你想创建一个写入流，最后一个参数为&myWriteStream。

在打开套接字读取流之前，创建一个内容，这样当你注册接收 stream-related事件时可以使用。

```c
CFStreamClientContext myContext = {0, myPtr, myRetain, myRelease, myCopyDesc};
```


第一个参数是`0`指定版本号。`info` 参数`myPtr`是你想要传递给回调函数的数据指针。通常，`myPtr`是一个指向结构体的指针，在结构体中你定义了包含有关流的信息。参数`retain` 是一个指向函数的指针，可以保留参数`info` 。所以在函数中设置为`myRetain`，在上面的代码中，`CFStream` 将调用`myRetain(myPtr)`来保留`info` 指针。同样，`release` 参数`myRelease`是一个指向函数的指针，释放参数info 。当流与内容分离，`CFStream`将调用 `myRelease(myPtr)`。最后，`copyDescription` 是函数的一个参数，该函数提供流的描述。例如，如果你是调用上文所示的CFCopyDesc(myReadStream) ，`CFStream`将调用`myCopyDesc(myPtr)`。

客户端环境允许你设置`retain`, `release`和`copyDescription` 参数为`NULL`。如果你设置`retain` 和参数`release `为`NULL`，系统将认为`info` 指针指向的内存一直存在直到流本身被销毁。如果你将`copyDescription` 参数设置为NULL，如果有要求，系统将提供`info `指针所指向内存的基本信息。

设置好客户端环境后，调用函数`CFReadStreamSetClient` 注册接收有关流事件。`CFReadStreamSetClient` 要求你指定回调函数和你想接收的事件。列表2-6中的例子指定回调函数和接收的`kCFStreamEventHasBytesAvailable`,`kCFStreamEventErrorOccurred`和`kCFStreamEventEndEncountered` 事件。然后调用[CFReadStreamScheduleWithRunLoop](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamScheduleWithRunLoop)函数安排流到一个运行循环上。例子见列表2-6.

列表2-6 安排流到运行循环上


```c
CFOptionFlags registeredEvents = kCFStreamEventHasBytesAvailable |
        kCFStreamEventErrorOccurred | kCFStreamEventEndEncountered;
if (CFReadStreamSetClient(myReadStream, registeredEvents, myCallBack, &myContext))
{
    CFReadStreamScheduleWithRunLoop(myReadStream, CFRunLoopGetCurrent(),
                                    kCFRunLoopCommonModes);
}
```

流安排到运行循环上后，你可以准备打开流，如列表2-7所示。

列表2-7 打开非阻塞读取流


```c
if (!CFReadStreamOpen(myReadStream)) {
    CFStreamError myErr = CFReadStreamGetError(myReadStream);
    if (myErr.error != 0) {
    // An error has occurred.
        if (myErr.domain == kCFStreamErrorDomainPOSIX) {
        // Interpret myErr.error as a UNIX errno.
            strerror(myErr.error);
        } else if (myErr.domain == kCFStreamErrorDomainMacOSStatus) {
            OSStatus macError = (OSStatus)myErr.error;
            }
        // Check other domains.
    } else
        // start the run loop
        CFRunLoopRun();
}

```

现在，等待你的回调函数执行。在你的回调函数中，检查事件代码并采取适当的行动。见列表2-8.

列表2-8 网络事件回调函数


```c
void myCallBack (CFReadStreamRef stream, CFStreamEventType event, void *myPtr) {
    switch(event) {
        case kCFStreamEventHasBytesAvailable:
            // It is safe to call CFReadStreamRead; it won’t block because bytes
            // are available.
            UInt8 buf[BUFSIZE];
            CFIndex bytesRead = CFReadStreamRead(stream, buf, BUFSIZE);
            if (bytesRead > 0) {
                handleBytes(buf, bytesRead);
            }
            // It is safe to ignore a value of bytesRead that is less than or
            // equal to zero because these cases will generate other events.
            break;
        case kCFStreamEventErrorOccurred:
            CFStreamError error = CFReadStreamGetError(stream);
            reportError(error);
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(),
                                              kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
            break;
        case kCFStreamEventEndEncountered:
            reportCompletion();
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(),
                                              kCFRunLoopCommonModes);
            CFReadStreamClose(stream);
            CFRelease(stream);
            break;
    }
}


```

当回调函数接收`kCFStreamEventHasBytesAvailabl`e `事件代码，它会调用`CFReadStreamRead` 来读取数据。

当回调函数接收`kCFStreamEventErrorOccurred` 事件代码，它会调用`CFReadStreamGetError` 来获取错误和自己的错误函数 (reportError)来处理错误。

当回调函数接收`kCFStreamEventEndEncountered `事件代码，它调用自己的函数 (`reportCompletion`)来处理最终的数据然后调用`CFReadStreamUnscheduleFromRunLoop` 函数从指定运行循环上移除流。然后运行`CFReadStreamClose `函数来关闭流，`CFRelease` 来释放流引用。

###轮询网络流
一般来说，轮询网络流是不明智的。然而，在某些罕见的情况下，它非常有用。为了轮询流，你首先检查流是否可以读取或写入，然后在流上执行一个读取或写入的操作。

当写入到一个写入流中，你通过调用`CFWriteStreamCanAcceptBytes`可以决定流是否接受数据。如果返回TRUE，那么你可以确定随后调用的`CFWriteStreamWrite` 函数将立即发送数据而没有阻塞。

同样，对于读取流，在调用CFReadStreamRead之前，调用CFReadStreamHasBytesAvailable函数。

列表2-9 是一个轮询读取流的例子

列表2-9 轮询读取流


```c
while (!done) {
    if (CFReadStreamHasBytesAvailable(myReadStream)) {
        UInt8 buf[BUFSIZE];
        CFIndex bytesRead = CFReadStreamRead(myReadStream, buf, BUFSIZE);
        if (bytesRead < 0) {
            CFStreamError error = CFReadStreamGetError(myReadStream);
            reportError(error);
        } else if (bytesRead == 0) {
            if (CFReadStreamGetStatus(myReadStream) == kCFStreamStatusAtEnd) {
                done = TRUE;
            }
        } else {
            handleBytes(buf, bytesRead);
        }
    } else {
        // ...do something else while you wait...
    }
}

```

列表2-10 轮询写入流的例子

列表2-10 轮询写入流


```c
UInt8 buf[] = “Hello, world”;
UInt32 bufLen = strlen(buf);
 
while (!done) {
    if (CFWriteStreamCanAcceptBytes(myWriteStream)) {
        int bytesWritten = CFWriteStreamWrite(myWriteStream, buf, strlen(buf));
        if (bytesWritten < 0) {
            CFStreamError error = CFWriteStreamGetError(myWriteStream);
            reportError(error);
        } else if (bytesWritten == 0) {
            if (CFWriteStreamGetStatus(myWriteStream) == kCFStreamStatusAtEnd)
            {
                done = TRUE;
            }
        } else if (bytesWritten != strlen(buf)) {
            // Determine how much has been written and adjust the buffer
            bufLen = bufLen - bytesWritten;
            memmove(buf, buf + bytesWritten, bufLen);
 
            // Figure out what went wrong with the write stream
            CFStreamError error = CFWriteStreamGetError(myWriteStream);
            reportError(error);
        }
    } else {
        // ...do something else while you wait...
    }
}

```

##导航防火墙
有两种方式设置流的防火墙。对于大多数流，你可以使用SCDynamicStoreCopyProxies 函数来检索代理设置，然后设置kCFStreamHTTPProxy （或kCFStreamFTPProxy）属性将结果应用于流。SCDynamicStoreCopyProxies 函数是系统配置框架的一部分，因此你需要在你的项目中使用该函数时需导入`<SystemConfiguration/SystemConfiguration.h>`。然后当你完成后，释放代理字典引用。整个过程如列表2-11所示。

列表2-11 通过代理服务器导航一个流

```c
CFDictionaryRef proxyDict = SCDynamicStoreCopyProxies(NULL);
CFReadStreamSetProperty(readStream, kCFStreamPropertyHTTPProxy, proxyDict);
```
然而，如果你经常需要使用代理设置多个流，这将变得更加复杂。在这种情况下，检索用户机器防火墙设置需要五个步骤：
- 为动态存储会话SCDynamicStoreRef，创建一个持久的句柄。

- 将句柄添加到运行循环中的动态存储会话上，这样可以收到代理更改的通知。

- 使用SCDynamicStoreCopyProxies 检索最新的代理设置。

- 当被告知变更，更新你的代理。

- 当通过后，清理SCDynamicStoreRef。

为动态存储会话创建句柄，使用SCDynamicStoreCreate 函数并传递一个分配器，一个名字来描述你的过程，一个回调函数和一个动态存储环境SCDynamicStoreContext。当初始化应用时运行。代码如列表2-12所示.

列表2-12 为动态存储会话创建一个句柄

```c
SCDynamicStoreContext context = {0, self, NULL, NULL, NULL};
systemDynamicStore = SCDynamicStoreCreate(NULL,
                                          CFSTR("SampleApp"),
                	                      proxyHasChanged,
           								  &context);
```
创建动态存储引用后，你需要将其添加到运行循环上。首先，采用动态存储引用 对 代理的任何更改 设置监控。使用SCDynamicStoreKeyCreateProxies 和SCDynamicStoreSetNotificationKeys函数可完成该功能。然后，你可以调用SCDynamicStoreCreateRunLoopSource 和CFRunLoopAddSource函数添加动态存储引用到运行循环上。代码如列表2-13所示。

列表2-13 添加一个动态存储引用到运行循环

```c
// Set up the store to monitor any changes to the proxies
CFStringRef proxiesKey = SCDynamicStoreKeyCreateProxies(NULL);
CFArrayRef keyArray = CFArrayCreate(NULL,
                                    (const void **)(&proxiesKey),
                                    1,
                                    &kCFTypeArrayCallBacks);
SCDynamicStoreSetNotificationKeys(systemDynamicStore, keyArray, NULL);
CFRelease(keyArray);
CFRelease(proxiesKey);
 
// Add the dynamic store to the run loop
CFRunLoopSourceRef storeRLSource =
    SCDynamicStoreCreateRunLoopSource(NULL, systemDynamicStore, 0);
CFRunLoopAddSource(CFRunLoopGetCurrent(), storeRLSource, kCFRunLoopCommonModes);
CFRelease(storeRLSource);
```

一旦动态存储引用添加到运行循环上，调用SCDynamicStoreCopyProxies函数，用它来预加载代理字典当前代理设置。如列表2-14所示

列表2-14 加载代理字典

```c
gProxyDict = SCDynamicStoreCopyProxies(systemDynamicStore);
```


由于动态存储引用添加到运行循环上，每次代理改变，你的回调函数会运行。释放当前代理字典并使用新的代理设置重新加载。回调函数示例代码如列表2-15所示。

列表2-15 代理回调函数
```c
void proxyHasChanged() {
CFRelease(gProxyDict);
   gProxyDict = SCDynamicStoreCopyProxies(systemDynamicStore);
}
```
因为所有代理信息是最新的。创建读取或写入流后，通过调用CFReadStreamSetProperty 和CFWriteStreamSetProperty函数，设置kCFStreamPropertyHTTPProxy 代理。如果流是叫做的readStream读取流，函数调用如列表2-16所示。

列表2-16 添加代理信息到流

```c
CFReadStreamSetProperty(readStream, kCFStreamPropertyHTTPProxy, gProxyDict);
```


当代理设置完成，确保释放字典和动态存储引用并从运行循环上删除动态存储引用。见列表2-17.

列表2-17 清理代理信息

```c
if (gProxyDict) {
CFRelease(gProxyDict);}
// Invalidate the dynamic store's run loop source
// to get the store out of the run loop
CFRunLoopSourceRef rls = SCDynamicStoreCreateRunLoopSource(NULL, systemDynamicStore, 0);
CFRunLoopSourceInvalidate(rls);
CFRelease(rls);
CFRelease(systemDynamicStore);
```
官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFStreamTasks/CFStreamTasks.html#//apple_ref/doc/uid/TP30001132-CH6-SW1)
