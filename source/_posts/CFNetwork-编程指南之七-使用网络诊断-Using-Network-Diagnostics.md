---
title: 'CFNetwork 编程指南之七: 使用网络诊断(Using Network Diagnostics)'
date: 2016-08-10 11:59:13
categories: iOS网络编程
tags: CFNetwork
---

#使用网络诊断

在许多基于网络的应用中，会发生基于网络的错误，这些错误与你的应用无关。然而，大多数用户可能不知道为什么应用失败。CFNetDiagnostics API为你提供一种快速而简单的方法来帮助用户解决网络问题。

如果你的应用使用一个CFStream 对象，然后调用[CFNetDiagnosticCreateWithStreams](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticCreateWithStreams)函数创建一个网络诊断引用(CFNetDiagnosticRef) 。[CFNetDiagnosticCreateWithStreams](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticCreateWithStreams)有一个分配器，读取流和写入流作为参数。如果你的应用只使用读取流或写入流，未使用的参数设置为NULL。

如果不存在流，你还可以直接从URL创建一个网络诊断引用。要做到这一点，调用[CFNetDiagnosticCreateWithURL](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticCreateWithURL) 函数，并传递一个分配器，URL到CFURLRef。它将返回一个网络诊断引用供你使用。

为了通过网络诊断助手诊断问题，调用[CFNetDiagnosticDiagnoseProblemInteractively](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticDiagnoseProblemInteractively) 函数并传递网络诊断引用。列表6-1展示了如何使用CFNetDiagnostics 诊断在运行循环上实现的流。

列表6-1 当发生流错误时使用CFNetDiagnostics API

```c
case kCFStreamEventErrorOccurred: 

    CFNetDiagnosticRef diagRef =
        CFNetDiagnosticCreateWithStreams(NULL, stream, NULL); 

    (void)CFNetDiagnosticDiagnoseProblemInteractively(diagRef);
    CFStreamError error = CFReadStreamGetError(stream);
    reportError(error);
    CFReadStreamClose(stream);
    CFRelease(stream);
    break;
```
<!-- more -->
CFNetworkDiagnostics 同样可以检索问题的状态，而不是使用网络诊断助手。通过调用[CFNetDiagnosticCopyNetworkStatusPassively](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFNetDiagnosticsRef/index.html#//apple_ref/doc/c_ref/CFNetDiagnosticCopyNetworkStatusPassively)，便可以完成。该函数返回一个常数例如`kCFNetDiagnosticConnectionUp` 或`kCFNetDiagnosticConnectionIndeterminate。`

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/UsingNetworkDiagnostics/UsingNetworkDiagnostics.html#//apple_ref/doc/uid/TP30001132-CH7-SW1)
