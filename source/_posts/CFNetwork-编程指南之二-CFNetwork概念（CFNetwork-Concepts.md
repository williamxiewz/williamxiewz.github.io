title: 'CFNetwork 编程指南之二: CFNetwork概念（CFNetwork Concepts)'
date: 2016-08-10 11:56:29
categories: iOS网络编程
tags: CFNetwork
---
#CFNetwork概念

CFNetwork是一个低级别高性能的框架，使你能够精细的控制协议栈。它是BSD套接字的扩展，标准套接字抽象API提供对象来简化任务，例如与FTP和HTTP服务器通信或解析DNS主机。CFNetwork物理上和理论上都基于BSD套接字。

正如CFNetwork依赖与BSD套接字，有大量的Cocoa类依赖CFNetwork（例如，NSURL）。此外，Cocoa类的web工具包用来在窗口显示网页内容。这两个类是高层级，并实现大部分的网络协议。因此，软件层的结构如图1-1所示。

![图1-1 OS X上CFNetwork和其他软件层](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Art/layers_2x.png)
<!-- more -->
##何时使用CFNetwork
CFNetwork相对BSD套接字有很多优点，它提供了run-loop集成，因此，如果你的应用程序是基于运行循环，你可以使用网络协议，而不用实现线程。CFNetwork还包含大量的对象可帮助你使用网络协议，而不用实现具体的细节。例如，你可以使用FTP协议，而不用实现CFFTP API的所有细节。如果你了解网络协议，需要它们提供低级别的控制，但是不想自己实现，这时CFNetwork可能是正确的选择。

使用CFNetwork替代Foundation 级别网络API有很多好处。CFNetwork更侧重于网络协议，而Foundation 级别API侧重于数据访问，例如通过HTTP或FTP传输数据。虽然框架API提供了一些可配置性，但CFNetwork提供了更多。关于框架网络类的更多信息，请参阅[URL Session Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/URLLoadingSystem/URLLoadingSystem.html#//apple_ref/doc/uid/10000165i)。

现在你已了解CFNetwork如何与其他OS X网络API交互，可以开始了解CFNetwork API和形成CFNetwork基础的两个API。

##CFNetwork基础
在学习CFNetwork API之前，你首先需要了解API，这些API是CFNetwork的基础。CFNetwork依赖的两个API：CFSocket和CFStream是核心基础框架的一部分。理解这两个API对使用CFNetwork至关重要。

###CFSocket API
套接字是网络通信的底层。一个套接字类似于电话插孔。它允许你连接到另一个套接字（通过本地或网络）并发送数据给该套接字。

最常见的套接字是BSD套接字。CFSocket是BSD套接字的一个抽象概念。CFSocket提供几乎BSD套接字的所有功能，使用很少的开销将套接字集成到一个运行循环中。CFSocket并不局限于基于流套接字（例如，TCP），它可以处理任何类型的套接字。

你可以使用[CFSocketCreate](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFSocketRef/index.html#//apple_ref/doc/c_ref/CFSocketCreate) 函数从头创建一个CFSocket对象，或者使用[CFSocketCreateWithNative](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFSocketRef/index.html#//apple_ref/doc/c_ref/CFSocketCreateWithNative)函数创建。然后你可以使用函数[CFSocketCreateRunLoopSource](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFSocketRef/index.html#//apple_ref/doc/c_ref/CFSocketCreateRunLoopSource) 创建一个运行循环源，并使用函数[CFRunLoopAddSource](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFRunLoopRef/index.html#//apple_ref/doc/c_ref/CFRunLoopAddSource)将其添加到运行循环。这样，当CFSocket对象接收到一条消息时，你的CFSocket回调函数会运行起来。

关于更多CFSocket API的信息，可阅读CFSocket参考（[CFSocket Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFSocketRef/index.html#//apple_ref/doc/uid/20001445)）。

###CFStream API
读写流提供一种简单的方法以与设备无关的方式来与各种媒体进行数据交换。你可以为内存中、文件中或网络中（使用套接字）的数据创建流，并且你可以使用流而无需将所有的数据加载到内存中。

流是一个字节序列串行传输的通信路径。流是单向路径，所以需要一个双向通信，一个输入（读取）流和一个输出（写入）流。除了基于文件的流，你不能寻找一个流；一旦数据流被提供或消耗，不能从流中重新取回。

CFStream是一个API，它为两个新CFType对象：CFReadStream 和CFWriteStream提供了一个抽象。这两种类型的流遵守所有常见核心基础API约定。关于核心基础类型的更多信息，可参阅核心基础设计概念（[Core Foundation Design Concepts](https://developer.apple.com/library/ios/documentation/CoreFoundation/Conceptual/CFDesignConcepts/CFDesignConcepts.html#//apple_ref/doc/uid/10000122i)）。

CFStream构建在CFSocket之上，在CFHTTP和CFFTP之下。如图1-2可以看出，尽管CFStream不是CFNetwork正式的部分，但它是几乎所有CFNetwork的基础。

![图1-2 CFStream API结构](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Art/framework_layers_2x.png)

你可以像使用UNIX文件描述符一样使用读写流。首先，你指定流类型（内存、文件或套接字）实例化流并设置选项。接下来，你可以多次打开流并进行读写。流存在时，可以访问属性获得流信息。流属性是关于流的所有信息，例如它的源或目标，但不是实际写入或读取的数据。当你不再需要流时，关闭并处理它。

用于读写流的CFStream函数将暂停或阻塞当前进程，直到数据可以读取或写入。为了避免在流阻塞的时候试图读取或写入流，使用异步函数并安排流到一个运行循环上。当可以无阻塞的读取和写入时，将调用你的回调函数。

此外，CFStream内置支持安全套接字层（SSL）协议。你可以设置包含流SSL信息的字典，例如属性的安全级别或自签证书。然后传递它给你的流，正如`kCFStreamPropertySSLSettings`属性设置流为SSL流。

使用流（[Working with Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFStreamTasks/CFStreamTasks.html#//apple_ref/doc/uid/TP30001132-CH6-SW1)）章节描述了如何使用读写流。

##CFNetwork API 概念
为了理解CFNetwork框架，你需要熟悉构建它的block。CFNetwork框架分成单独的API，每个API覆盖一个特定的网络协议。这些API可以结合使用或分开使用，这取决于你的应用。API大多数编程约定是常见的，所以理解他们很重要。

###CFFTP API
使用CFFTP与FTP服务器通信会更加容易，使用CFFTP API，你可以创建FTP读取流（下载）和FTP写入流（上传）。使用FTP读写流，你可以执行如下功能：

- 从FTP服务器下载文件

- 上传文件到FTP服务器

- 从FTP服务器下载目录清单

- 在FTP服务器上创建目录。

FTP流就像其他CFNetwork流一样工作。例如，你可以通过调用CFReadStreamCreateWithFTPURL 函数，创建一个FTP读取流。然后，你可以在任何时候调用CFReadStreamGetError 函数来检查流的状态。

通过设置FTP流的属性，你可以为特定应用调整你的流。例如，如果流连接的服务器需要一个用户名和密码，你需要设置特定的属性这样流可以正常工作。关于FTP流不同属性的更多信息，请参阅[Setting up the Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW2)。

可以同步或异步使用CFFTP流。为了打开与FTP服务器的连接，调用CFReadStreamOpen函数，该服务器在FTP读取流创建的时候就已指定。为了读取流，使用CFReadStreamRead 函数并提供读取流引用CFReadStreamRef，当创建FTP读取流时该引用会返回。CFReadStreamRead 函数用FTP服务器输出填充缓存区。

关于使用CFFTP的更多信息，参阅[Working with FTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW1)

###CFHTTP API
发送和接收HTTP消息可使用CFHTTP API。正如CFFTP是FTP协议的抽象，CFHTTP是HTTP协议的抽象。

超文本传输协议（HTTP）是一种客户端和服务器端的请求/响应协议。客户端创建一个请求消息。这个消息被序列化，序列化其实就是将消息转换成原始字节流。消息不能传递除非先被序列化。然后将请求消息发送到服务器。请求通常是请求一个文件，例如网页。服务器响应并后发送回一个字符串然后是消息。这个过程可以重复多次。

要创建一个HTTP请求消息，你指定以下内容：

- 请求方法，可以是超文本传输协议定义的请求方法，例如 OPTIONS, GET, HEAD, POST, PUT, DELETE, TRACE, 和CONNECT

- URL，例如 `http://www.apple.com`

- HTTP 版本，例如1.0版本或1.1版本。

- 消息的标题通常根据标题名称指定，例如User-Agent，或值，例如MyUserAgent。

- 消息主体

消息创建后，将其序列化。序列化后，请求如下：


	GET / HTTP/1.0\r\nUser-Agent: UserAgent\r\nContent-Length: 0\r\n\r\n

序列化对应的是反序列化。反序列化是将从客户端或服务器接收到的原始字节流恢复成本地的表述。CFNetwork提供获取消息类型（请求或响应），HTTP版本，URL，进入的序列化的消息的标题和主体所需要的所有功能。

使用CFHTTP的更多例子在与HTTP服务通信（[Communicating with HTTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPTasks/CFHTTPTasks.html#//apple_ref/doc/uid/TP30001132-CH5-SW2)）。

###CFHTTPAuthentication API
如果你发送一个HTTP请求到身份验证服务器而没有认证信息（或不正确的认证信息），服务器将返回身份验证怀疑（俗称401或407响应）。CFHTTPAuthentication API向受到怀疑的HTTP消息提出身份验证申请。CFHTTPAuthentication 支持如下身份验证方案：

- 基本

- 摘要

- NT LAN管理（NTLM）

- 简单的受保护的GSS-API 谈判机制（SPNEGO）

OS X v10.4的新功能是提供持续请求欧诺个能。在OS X v10.3中，每次请求被怀疑，你必须从头开始身份验证。现在，你为每个服务器维护一组CFHTTPAuthentication 对象。当你收到一个401或407响应，你查找服务器正确的对象和凭证，并请求。CFNetwork使用存储在对象的信息尽可能高效的处理请求。

通过持续请求，新版本的CFHTTPAuthentication 提供更好的性能。关于如何使用CFHTTPAuthentication 的更多信息，可查看与身份验证HTTP服务器进行通信（[Communicating with Authenticating HTTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW1)）。

###CFHost API
你使用CFHost API获取主机信息，包括名称、地址和可达性信息。获取信息的过程被称为解析。

CFHost 与CFStream类似：

- 创建CFHost 对象

- 开始解析CFHost 对象

- 检索地址、主机名或可达性信息

- 当你完成时，销毁CFHost 对象

像所有的CFNetwork、CFHost都兼容IPv4 和IPv6 。使用CFHost，你可以编写代码完全透明的处理IPv4 和IPv6 。

CFHost的集成与CFNetwork密切相关。例如，有个称为CFStreamCreatePairWithSocketToCFHost 的CFStream 函数会从CFHost对象中直接创建一个CFStream 对象。关于CFHost对象函数的更多信息，参见[CFHost Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHostRef/index.html#//apple_ref/doc/uid/TP40003333)。

###CFNetServices API
如果你想让你的应用使用Bonjour 注册一个服务或发现服务可以使用CFNetServices API。Bonjour 是苹果零配置网络（ZEROCONF）的实现，它允许你发布、发现和解析网络服务。

为了实现Bonjour ，CFNetServices API定义三个对象类型：CFNetService、CFNetServiceBrowser和CFNetServiceMonitor。CFNetService对象表示一个单一的网络服务，例如打印机或文件服务器。它包含另一台计算机解析服务器所需的所有信息，例如名称、类型、域和域内网络服务。CFNetServiceBrowser是一个对象用于发现域或域内网络服务。CFNetServiceMonitor对象用于监控CFNetService 对象的变化，例如iChat中的状态消息。

详细Bonjour的描述见[Bonjour Overview](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/NetServices/Introduction.html#//apple_ref/doc/uid/10000119i)。关于使用CFNetServices 实现Bonjour的更多信息，可查看[NSNetServices and CFNetServices Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/NSNetServiceProgGuide/Introduction.html#//apple_ref/doc/uid/TP40002736)。

###CFNetDiagnostics API
连接到网络的应用依赖于一个稳定的链接。如果网络不稳定，这将导致应用程序的问题。采用CFNetDiagnostics API，用户可以自己诊断如下网络问题：

- 物理连接失败（例如，未插入电缆）

- 网络故障（例如，DNS或DHCP服务器不再响应）

- 配置失败（例如，代理配置不正确）

一旦网络故障诊断出来，CFNetDiagnostics 指导用户解决问题。如果Safari连接网站失败，你可能会看到CFNetDiagnostics 起作用。CFNetDiagnostics 助手如图1-3所示。

![图1-3 网络诊断助手](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Art/net_diagnostics_2x.png)

通过CFNetDiagnostics 提供的网络故障内容，你可以调用[CFNetDiagnosticDiagnoseProblemInteractively](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticDiagnoseProblemInteractively)函数引导用户通过提示找到解决办法。此外，你可以使用CFNetDiagnostics 查询连接状态并为用户提供统一的错误消息。

如何集成CFNetDiagnotics 到你的应用，可参阅使用网络诊断（ [Using Network Diagnostics](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/UsingNetworkDiagnostics/UsingNetworkDiagnostics.html#//apple_ref/doc/uid/TP30001132-CH7-SW1)）。CFNetDiagnostics 是OS X v10.4中新的API。

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Concepts/Concepts.html#//apple_ref/doc/uid/TP30001132-CH4-SW10)
