title: 'CFNetwork 编程指南之四: 与HTTP服务器通信(Communicating with HTTP Servers)'
date: 2016-08-10 11:57:31
categories: iOS网络编程
tags:  CFNetwork
---

#与HTTP服务器通信

本文解释了如何创建、发送和接收HTTP请求和响应。

##创建一个CFHTTP请求
HTTP请求是一个消息，这个消息由远程服务器执行的方法，操作的对象（URL），消息头和消息体。方法通常是下面之一：GET, HEAD, PUT, POST, DELETE, TRACE, CONNECT 或OPTIONS。
用CFHTTP创建一个HTTP请求分为四个步骤：

- 使用CFHTTPMessageCreateRequest 函数生成CFHTTP消息对象
- 使用CFHTTPMessageSetBody函数设置消息体
- 使用CFHTTPMessageSetHeaderFieldValue 函数设置消息头
- 通过调用CFHTTPMessageCopySerializedMessage函数序列化消息

<!-- more -->

示例代码类似列表3-1中的代码。

列表3-1 创建一个HTTP请求

```c
CFStringRef bodyString = CFSTR(""); // Usually used for POST data 
CFDataRef bodyData =     
CFStringCreateExternalRepresentation     
(kCFAllocatorDefault,bodyString,kCFStringEncodingUTF8, 0);

CFStringRef headerFieldName = CFSTR("X-My-Favorite-Field");
CFStringRef headerFieldValue = CFSTR("Dreams");

CFStringRef url = CFSTR("http://www.apple.com");
CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, url, NULL);

CFStringRef requestMethod = CFSTR("GET");
CFHTTPMessageRef myRequest =
CFHTTPMessageCreateRequest(kCFAllocatorDefault, requestMethod, myURL,
                          kCFHTTPVersion1_1);

CFDataRef bodyDataExt =
CFStringCreateExternalRepresentation(kCFAllocatorDefault,     
bodyData, kCFStringEncodingUTF8, 0);   
CFHTTPMessageSetBody(myRequest, bodyDataExt);     

CFHTTPMessageSetHeaderFieldValue(myRequest,
headerFieldName, headerFieldValue);
CFDataRef mySerializedRequest =       
CFHTTPMessageCopySerializedMessage(myRequest);
```

在此示例代码中，通过调用[CFURLCreateWithString](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFURLRef/index.html#//apple_ref/doc/c_ref/CFURLCreateWithString)，url 是首先转换成一个CFURL对象。然后调用[CFHTTPMessageCreateRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateRequest) ，有四个参数：kCFAllocatorDefault 指定默认系统内存分配器用来创建消息应用，requestMethod 指定方法，例如POST方法，myURL 用来指定URL，例如，`http://www.apple.com`，kCFHTTPVersion1_1指定消息HTTP版本是1.1.

[CFHTTPMessageCreateRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateRequest) 返回的消息对象引用(myRequest)和消息体(bodyData)一起发送到[CFHTTPMessageSetBody](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageSetBody) 。然后调用[CFHTTPMessageSetHeaderFieldValue](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageSetHeaderFieldValue) 使用相同消息对象引用，头(headerField)名称和设置的值(value)。头参数是个CFString对象，例如Content-Length,值参数是一个CFString对象例如1260.最后，调用[CFHTTPMessageCopySerializedMessage](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCopySerializedMessage)序列化消息，通过写入流发送到接受者，例子详见`http://www.apple.com`

>注意：请求主体通常省略。请求主体通常用于一个包含POST数据的POST请求。它也可以用于其他有关HTTP扩展的请求类型，例如WebDAV。更多信息参见[RFC 2616](http://www.w3.org/Protocols/rfc2616/rfc2616.html)。

当不再需要消息，释放消息对象并序列化消息。见列表3-2的示例代码

列表3-2 释放一个HTTP请求

```c
CFRelease(myRequest);   
CFRelease(myURL); 
CFRelease(url); 
CFRelease(mySerializedRequest); 
myRequest = NULL; 
mySerializedRequest = NULL;
```


##创建一个CFHTTP响应
创建一个HTTP响应的步骤与创建一个HTTP请求的步骤几乎完全相同。唯一的区别是，调用函数[CFHTTPMessageCreateResponse](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateResponse) ，而不是[CFHTTPMessageCreateRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateRequest)，两者使用相同的参数

反序列化传入的HTTP请求
反序列化一个传入的HTTP请求，使用[CFHTTPMessageCreateEmpty](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateEmpty) 函数，创建一个空消息，isRequest 参数设为TRUE 指定创建一个空的请求消息。然后调用[CFHTTPMessageAppendBytes](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageAppendBytes)函数将传入的消息添加到空消息中。[CFHTTPMessageAppendBytes](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageAppendBytes)反序列化消息并移除任何可能包含的控制信息。

继续这样做直到[CFHTTPMessageIsHeaderComplete](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageIsHeaderComplete) 函数返回TRUE。如果你不检查[CFHTTPMessageIsHeaderComplete](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageIsHeaderComplete) 是否返回TRUE，消息可能是不完整的或不可信的。列表3-3可以看到这两个函数使用的例子。

列表3-3 反序列化消息

```c
CFHTTPMessageRef myMessage =   
CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);   
if (!CFHTTPMessageAppendBytes(myMessage, &data, numBytes)) {   

//Handle parsing error
}

```


在示例中，data 是添加的数据而numBytes 是的data 长度。调用CFHTTPMessageIsHeaderComplete 验证附加消息的头是完整的。

```c
if (CFHTTPMessageIsHeaderComplete(myMessage)) { 

// Perform processing.
}

```



消息反序列化后，你可以调用如下函数从消息中提取信息：

- `CFHTTPMessageCopyBody` 用来获取消息主体
- `CFHTTPMessageCopyHeaderFieldValue` 用来获取特定头字段值
- `CFHTTPMessageCopyAllHeaderFields` 用来获取所有消息头字段
- `CFHTTPMessageCopyRequestURL `用来获取消息URL
- `CFHTTPMessageCopyRequestMethod `用来获取消息请求方法

当你不再需要该消息，释放并恰当的处理它。

##反序列化传入的HTTP响应
正如创建HTTP请求类似于创建HTTP响应一样，反序列化传入的HTTP请求与反序列化传入的HTTP响应类似。唯一重要的区别是，当调用[CFHTTPMessageCreateEmpty](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/c_ref/CFHTTPMessageCreateEmpty)，你必须给isRequest 参数传入FALSE 来指定将要创建的消息是响应消息。

##使用读取流序列化并发送HTTP请求
你可以使用CFReadStream对象来序列化和发送CFHTTP请求。当你使用CFReadStream对象来发送一个CFHTTP请求时，打开流因为消息必须在同一步中序列化好发送。使用CFReadStream 对象来发送CFHTTP请求，使获取请求的响应更加容易，因为响应作为流的属性是可用的。

###序列化并发送一个HTTP请求
使用CFReadStream 对象序列化并发送HTTP请求，首先创建一个CFHTTP请求并设置消息主体和头，在创建CFHTTP请求（[Creating a CFHTTP Request](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPTasks/CFHTTPTasks.html#//apple_ref/doc/uid/TP30001132-CH5-SW1)）中有描述。然后，调用[CFReadStreamCreateForHTTPRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamCreateForHTTPRequest) 函数创建一个CFReadStream 对象，传递你刚刚创建的请求。最后，通过[CFReadStreamOpen](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamOpen)打开读取流。

当调用[CFReadStreamCreateForHTTPRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamCreateForHTTPRequest) ，复制一份传入的CFHTTP请求对象。因此，如果有必要，你可以在调用[CFReadStreamCreateForHTTPRequest](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamCreateForHTTPRequest) 之后立即释放CFHTTP请求对象。

因为当创建CFHTTP请求时，读取流打开一个套接字连接myUrl 参数指定的服务器，两者之间允许有些时间差。打开读取流也会导致请求被序列化和发送。

列表3-4是一个关于如何序列化和发送HTTP请求的例子

列表3-4 读取流序列化HTTP请求

```c
CFStringRef url = CFSTR("http://www.apple.com"); 
CFURLRef myURL = CFURLCreateWithString(kCFAllocatorDefault, url, NULL); 
CFStringRef requestMethod = CFSTR("GET"); 
CFHTTPMessageRef myRequest =     
CFHTTPMessageCreateRequest(kCFAllocatorDefault,   
requestMethod, myUrl, kCFHTTPVersion1_1); 
CFHTTPMessageSetBody(myRequest, bodyData); 
CFHTTPMessageSetHeaderFieldValue(myRequest, headerField, value); 
CFReadStreamRef myReadStream =     
CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myRequest); 
CFReadStreamOpen(myReadStream);
```

###检查响应
在你安排请求到运行循环后，你将最终会得到一个头完成回调。在这一点上，你可以调用[CFReadStreamCopyProperty](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/c/func/CFReadStreamCopyProperty) 从读取流获取消息响应。


	CFHTTPMessageRef myResponse = (CFHTTPMessageRef)CFReadStreamCopyProperty(myReadStream,kCFStreamPropertyHTTPResponseHeader);

你可以通过调用CFHTTPMessageCopyResponseStatusLine函数，从消息响应获取完整状态行：

	CFStringRef myStatusLine = CFHTTPMessageCopyResponseStatusLine(myResponse);


通过调用CFHTTPMessageGetResponseStatusCode函数获取消息响应的状态码：


	UInt32 myErrCode = CFHTTPMessageGetResponseStatusCode(myResponse);

>注意：如果你正在同步使用这个类（没有安排到运行循环），你必须在调用CFReadStreamCopyProperty之前调用[CFReadStreamRead](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/c/func/CFReadStreamRead) ，先读取消息。CFReadStreamRead 调用一直阻塞直到数据可用（或连接失败）。不要在你的主应用线程中使用。

###处理身份验证错误
如果CFHTTPMessageGetResponseStatusCode 函数返回的状态码是401（远程服务器需要身份验证信息）或407（代理服务器需要身份验证），你需要将身份验证信息附加到请求并重新发送。关于如何处理身份验证的信息，请查看与需要身份验证HTTP服务器通信（ [Communicating with Authenticating HTTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW1)）。

###处理重定向错误
当`CFReadStreamCreateForHTTPRequest` 创建一个读取流，默认情况下流的自动重定向是禁用的。如果请求发送的统一资源定位符或URL重定向到另一个URL，发送该请求将导致一个错误，状态码在300到307之间。如果你接收到一个重定向错误，你需要关闭流，创建流，启用重定向并打开流。参见列表3-5.

列表3-5 重定向HTTP流

```c
CFReadStreamClose(myReadStream);
CFReadStreamRef myReadStream =
CFReadStreamCreateForHTTPRequest(kCFAllocatorDefault, myRequest);
if (CFReadStreamSetProperty(myReadStream,
kCFStreamPropertyHTTPShouldAutoredirect, kCFBooleanTrue) == false) {

// something went wrong, exit

}
CFReadStreamOpen(myReadStream);
```

当你创建一个读取流，你可能想要启用自动重定向。

##取消一个待定请求
一旦请求已经发送，不能阻止远程服务器处理它。然而，你不再关心响应数据，你可以关闭流。

>重要：如果另一个线程正在等待某个线程的流的内容，则不要关闭该流。如果你需要终止请求时，你应该使用非阻塞 I/O，在使用流时防止阻塞（[Preventing Blocking When Working with Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFStreamTasks/CFStreamTasks.html#//apple_ref/doc/uid/TP30000230-61973)）中有描述。确保在关闭流之前从你的运行循环上移除流。

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPTasks/CFHTTPTasks.html#//apple_ref/doc/uid/TP30001132-CH5-SW2)