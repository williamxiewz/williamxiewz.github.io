---
title: Bonjour网络编程
date: 2016-08-10 18:53:34
categories: iOS网络编程
tags: Bonjour
---

#Bonjour 介绍
Bonjour(法语”你好’’的意思),它可以使应用不必指定眼务器端口和IP地址就可以以动态发现。 

发现眼务是通过特定命名搜索服务的.例如"tony. _tonyipp. _tcp.local"这样的命名，发 现服务命名格式如下：
 <服务名>._〈服务类>._<传输协议名>.<域名> 

tony为服务名,服务名是一个描述性的名字。tonyipp是服务类.可以由开发人员自己命名，也可使用已经注册的服务类型名，例如ipp是打印服务。目前已经注册的服务类型名有400多种，可以在http://www. dns-sd.org/ServiceTypes.html的网址查看。tcp是传输协议，local是本地域名。 

苹果提供的Bonour编程比较简单，主要是两个类：NSNetServce和NSNetSeowser,以及它们的委托协议NSNetServiceDelegate和NSNetServiceBrowserDelegate。在服务器端需要发布五福,而客户端需要解析服务或查询服务。一旦连接建立起来,捷克语进行通信了,之后的事情和Bonjour无关了。

<!-- more -->

#发布服务
