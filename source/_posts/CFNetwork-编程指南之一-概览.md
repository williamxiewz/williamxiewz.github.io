---
title: 'CFNetwork 编程指南之一: 概览'
date: 2016-08-10 11:56:09
categories: iOS网络编程
tags: CFNetwork
---

CFNetwork是核心服务框架中的一个框架，提供了抽象概念的网络协议库。这些抽象概念使得执行各种网络任务变得更容易，例如：

- 使用BSD套接字
- 使用SSL或TLS创建加密连接
- 解析DNS主机
- 使用HTTP，验证HTTP和HTTP服务器
- 使用FTP服务器
- 发布、解析和浏览Bonjour 服务（[NSNetServices and CFNetServices Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/NSNetServiceProgGuide/Introduction.html#//apple_ref/doc/uid/TP40002736)中有讨论)。
<!-- more -->
本文是针对想在应用中使用网络协议的开发人员。为了完全理解本文，读者应该对网络编程概念如BSD套接字、流和HTTP协议有很好的理解。此外，读者应熟悉OS X编程概念包括运行循环。关于OS X更多信息请阅读OS X技术概述。

##本文组织结构
本文包含以下章节：

- [CFNetwork Concepts](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Concepts/Concepts.html#//apple_ref/doc/uid/TP30001132-CH4-SW10) 描述了每个CFNetwork API及它们是如何交互的。

- [Working with Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFStreamTasks/CFStreamTasks.html#//apple_ref/doc/uid/TP30001132-CH6-SW1) 描述了如何使用CFStream API来发送和接收网络数据。

- [Communicating with HTTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPTasks/CFHTTPTasks.html#//apple_ref/doc/uid/TP30001132-CH5-SW2) 描述了如何发送和接收HTTP消息。

- [Communicating with Authenticating HTTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW1)描述了如何与安全HTTP服务器通信。

- [Working with FTP Servers](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW1) 描述了如何从一个FTP服务器上上传和下载文件，以及如何下载目录列表。

- [Using Network Diagnostics](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/UsingNetworkDiagnostics/UsingNetworkDiagnostics.html#//apple_ref/doc/uid/TP30001132-CH7-SW1) 描述了如何为应用添加网络诊断。

##另请参阅
关于OS X网络API更多信息，可查看：

- 开始使用网络

请参考下面的CFNetwork参考文档：

- [CFFTPStream Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/uid/TP40003359)是CFFTPStream API的参考文档。

- [CFHTTPMessage Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFMessageRef/index.html#//apple_ref/doc/uid/TP40003336)是CFHTTPMessage API的参考文档。

- [CFHTTPStream Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPStreamRef/index.html#//apple_ref/doc/uid/TP40003363)是CFHTTPStream API的参考文档。

- [CFHTTPAuthentication Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPAuthenticationRef/index.html#//apple_ref/doc/uid/TP40003335)是CFHTTPAuthentication API的参考文档。

- [CFHost Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHostRef/index.html#//apple_ref/doc/uid/TP40003333)是CFHost API的参考文档。

- [CFNetServices Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetServiceRef/index.html#//apple_ref/doc/uid/TP40003365)是CFNetServices API的参考文档。

- [CFNetDiagnostics Reference](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/uid/TP40003364)是CFNetDiagnosticsAPI的参考文档。

除了苹果提供的文档，下面是socket级别编程的参考书：

- UNIX网络编程，卷1（Stevens, Fenner and Rudoff）

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Introduction/Introduction.html)
