title: 'CFNetwork 编程指南之六: 使用FTP服务器(Working with FTP Servers)'
date: 2016-08-10 11:58:41
categories: iOS网络编程
tags: CFNetwork
---

#使用FTP服务器

本文揭示了如何使用CFFTP API的一些基本特性。管理FTP事务是异步执行的，而管理文件传输是同步实现的。

##下载文件
使用CFFTP类似于CFHTTP ，因为它们都是基于CFStream。与其他任何异步使用CFStream的API一样，使用CFFTP下载一个文件要求你为文件创建一个读取流和一个回调函数。当读取流接收数据时，回调函数将运行，你需要适当的下载字节。这个过程通常执行两个函数：一个用来设置流，另一个充当回调函数。

###设置FTP流
首先使用[CFReadStreamCreateWithFTPURL](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamCreateWithFTPURL) 函数创建一个读取流并传入要下载远程服务器上文件的URL字符串。URL字符串的例子`ftp://ftp.example.com/file.txt`。注意：字符串包含服务器名称、路径和文件。接下来，在文件下载的位置创建一个本地写入流。这个过程使用[CFWriteStreamCreateWithFile](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamCreateWithFile) 函数完成，传入要下载文件的路径。

<!-- more -->

由于读写流必须保持同步，创建一个包含所有共同信息，例如代理字典、文件大小、写入字节数、剩余字节数和缓存区的结构。结构如列表5-1所示

列表5-1 流结构

```c
typedef struct MyStreamInfo {

CFWriteStreamRef  writeStream;
CFReadStreamRef  readStream;
CFDictionaryRef  proxyDict;
SInt64            fileSize;
UInt32            totalBytesWritten;
UInt32            leftOverByteCount;
UInt8            buffer[kMyBufferSize];
} MyStreamInfo;
```

为你刚刚创建的读写流初始化结构。可以定义流客户端内容(`CFStreamClientContext`)的info字段执行结构。这在以后非常有用。

用[CFWriteStreamOpen](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/c/func/CFWriteStreamOpen) 函数打开你的写入流，这样你可以开始写入本地文件。确保流正常打开，调用[CFWriteStreamGetStatus](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamGetStatus) 函数检查返回`kCFStreamStatusOpen` 或`kCFStreamStatusOpening`。

写入流打开后，将回调函数与读取流结合。调用[CFReadStreamSetClient](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/c/func/CFReadStreamSetClient) 函数并传递读取流，你的回调函数要接收的网络事件，回调函数名称和`CFStreamClientContext` 对象。在之前设置客户端环境流中的info 字段，在运行时结构将发送到回调函数。

一些FTP服务可能需要用户名，其他可能还需要密码。如果访问的服务器需要用户名进行验证，调用[CFReadStreamSetProperty](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/c/func/CFReadStreamSetProperty) 函数并传递读取流，[kCFStreamPropertyFTPUserName]() 属性和包含用户名的CFString 对象的引用。此外，如果需要设置密码，设置kCFStreamPropertyFTPPassword 属性。

一些网络配置也可以使用FTP代理。获取代理信息的方式取决于你的代码是运行在OS X 还是iOS上。

- 在OS X 中，可以调用SCDynamicStoreCopyProxies 函数在字典中检索代理设置并传递NULL。

- 在iOS中，可以调用[CFNetworkCopyProxiesForURL](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFProxySupport/index.html#//apple_ref/c/func/CFNetworkCopyProxiesForURL)来检索代理设置。

这些函数返回一个动态存储引用。可以使用这个值来设置读取流的kCFStreamPropertyFTPProxy 属性。设置代理服务器，指定端口并返回一个布尔值，该值表明FTP流是否执行被动模式。

除了提到的属性，还有一些其他的属性用于FTP流。完整的列表如下。

- `kCFStreamPropertyFTPUserName` ——使用用户名登陆（可设置并可检索；匿名FTP连接不要设置）

- `kCFStreamPropertyFTPPassword` ——使用密码登陆（可设置并可检索；匿名FTP连接不要设置）

- `kCFStreamPropertyFTPUsePassiveMode` ——是否采用被动模式（可设置并可检索）

- `kCFStreamPropertyFTPResourceSize` ——下载项目的预期大小，如果可用（可检索；只有FTP读取流可用）

- `kCFStreamPropertyFTPFetchResourceInfo` ——是否要求资源信息，例如大小，开始下载前是否需要该信息（可设置并可检索）；设置这个属性可能会影响性能

- `kCFStreamPropertyFTPFileTransferOffset` ——开始转移的文件偏移量（可设置并可检索）

- `kCFStreamPropertyFTPAttemptPersistentConnection` ——是否尝试重用连接（可设置并可检索）

- `kCFStreamPropertyFTPProxy` ——包含代理字典的键值对（可设置并可检索）的CFDictionary 类型

- `kCFStreamPropertyFTPProxyHost` ——FTP代理主机名称（可设置并可检索）

- `kCFStreamPropertyFTPProxyPort` ——FTP代理主机端口号（可设置并可检索）

读取流分配正确的属性后，使用CFReadStreamOpen 函数打开流。假设并不返回一个错误，所有的流都正确设置。

###实现回调函数
回调函数将接收三个参数：读取流，事件类型和MyStreamInfo 结构。事件的类型决定了采取什么行动。

最常见的事件是kCFStreamEventHasBytesAvailable，当读取流从服务器接收到字节时，将发送该事件。首先，调用[CFReadStreamRead ](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamOpen)函数检查读取了多少字节。确保返回值不小于0（错误）或者等于0（已经下载完）。如果返回值为正，然后你可以开始将读取流中的数据写入到磁盘中。

调用[CFWriteStreamWrite](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamWrite) 函数写入数据到写入流。有时候在没有写入所有读取流中的数据是，[CFWriteStreamWrite](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamWrite) 可以返回。出于这个原因，只要还在写入数据，设置一个运行循环。代码见列表5-2，其中的info 是设置流（[Setting up the Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW2)）中的MyStreamInfo 结构。写入到写入流的方法使用阻塞流。通过写入流事件驱动可以实现更好的性能，但代码比较复杂。

列表5-2 将数据从读取流中写入到写入流


```c
bytesRead = CFReadStreamRead(info->readStream,   
info->buffer, kMyBufferSize);
//...make sure bytesRead > 0 ...
bytesWritten = 0; 
while (bytesWritten < bytesRead) { 

CFIndex result;

result = CFWriteStreamWrite(info->writeStream,
info->buffer + bytesWritten, bytesRead - bytesWritten); 
if (result <= 0) {
    fprintf(stderr, "CFWriteStreamWrite returned %ld\n", result);
    goto exit;
}
bytesWritten += result;
}info->totalBytesWritten += bytesWritten;

```

只要在读取流中有可用的直接，重复整个过程。

要当心其他两个事件`kCFStreamEventErrorOccurred` 和`kCFStreamEventEndEncountered`。如果出现错误，使用[CFReadStreamGetError](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFReadStreamRef/index.html#//apple_ref/doc/c_ref/CFReadStreamGetError) 检索错误然后退出。如果在文件末尾发生错误，下载已经完成可以退出。

确保一切完成并且没有其他过程使用流后删除所有流。首先，关闭写入流并设置客户端为NULL。然后从运行循环上取消流并释放。当完成后，从运行循环上删除流。

##上传文件
上传文件类似下载文件。正如下载文件一样，你需要一个读取流和一个写入流。然而，当上传文件，读取流为本地文件而写入流为远程文件。按照设置流（[Setting up the Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW2)）中的说明，但无论在任何地方引用读取流，将代码应用到写入流，反之亦然。

在回调函数中查找`kCFStreamEventCanAcceptBytes`事件，而不是查找`kCFStreamEventHasBytesAvailable` 事件。首先，使用读取流并将数据放到MyStreamInfo中缓冲区，从文件中读取字节。然后，运行[CFWriteStreamWrite](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamWrite) 函数将字节从缓冲区写入到写入流。[CFWriteStreamWrite](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamWrite) 返回写入流的字节数。如果写入的字节数少于从文件读取的数目，计算出剩余的字节并将它们存储到缓冲区。在接下来的写入周期，如果有剩余的直接，将它们写入到写入流而不是从读取流中加载新数据。只要写入流可以接受字节（[CFWriteStreamCanAcceptBytes](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFWriteStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamCanAcceptBytes)），重复整个过程。循环代码见列表5-3.

列表5-3 写入数据到写入流

```c
do { 

// Check for leftover data
if (info->leftOverByteCount > 0) {
    bytesRead = info->leftOverByteCount;
} else {
    // Make sure there is no error reading from the file
    bytesRead = CFReadStreamRead(info->readStream, info->buffer,
                                kMyBufferSize);
    if (bytesRead < 0) {
        fprintf(stderr, "CFReadStreamRead returned %ld\n", bytesRead);
        goto exit;
    }
    totalBytesRead += bytesRead;
}

// Write the data to the write stream
bytesWritten = CFWriteStreamWrite(info->writeStream,
info->buffer, bytesRead); 
if (bytesWritten > 0) {

    info->totalBytesWritten += bytesWritten;

    // Store leftover data until kCFStreamEventCanAcceptBytes event occurs again
    if (bytesWritten < bytesRead) {
        info->leftOverByteCount = bytesRead - bytesWritten;
        memmove(info->buffer, info->buffer + bytesWritten,
                info->leftOverByteCount);
    } else {
        info->leftOverByteCount = 0;
    }
} else {
    if (bytesWritten < 0)
        fprintf(stderr, "CFWriteStreamWrite returned %ld\n",
bytesWritten); 
    break;
}
} while (CFWriteStreamCanAcceptBytes(info->writeStream));
```


就像下载文件时，会有`kCFStreamEventErrorOccurred` 和`kCFStreamEventEndEncountered` 事件。

##创建远程目录
在远程服务器上创建目录，设置一个写入流正如你要上传文件。然而，提供一个目录路径而非文件，CFURL 对象传递到[CFWriteStreamCreateWithFTPURL](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamCreateWithFTPURL) 函数。用斜杠’/’结束路径。例如，一个适当的目录路径为`ftp://ftp.example.com/newDirectory/`，而非 `ftp://ftp.example.com/newDirectory/newFile.txt`。当运行循环执行回调函数，将发送`kCFStreamEventEndEncountered`事件，这表明已经创建了目录（或者`kCFStreamEventErrorOccurred`，表明发生错误）

每次调用[CFWriteStreamCreateWithFTPURL](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/c_ref/CFWriteStreamCreateWithFTPURL)只可以创建一个目录级别。只有你有正确的服务器权限，才能创建目录。

##下载目录列表
通过FTP下载目录列表与下载或上传文件略有不同。这是由于传入的数据必须被解析。首先，建立一个读取流来获取目录列表。对于下载文件这个必须完成：创建流，注册回调函数，运行循环上安排流（如果有必要，设置用户名、密码和代理信息），最后打开流。在接下来的例子中，当检索目录列表时，你不需要读取和写入流，因为传入的数据将要显示到屏幕上而非文件中。

在回调函数中，当心`kCFStreamEventHasBytesAvailable` 事件。从读取流中加载数据前，确保上次回调函数运行后的流中没有剩余数据。从`MyStreamInfo` 结构的`leftOverByteCount`字段加载偏移。然后，从流中读取数据，考虑你计算的偏移。缓冲区大小和读取的字节数也需要计算。如列表5-4所示。

列表5-4 加载目录列表数据

```c
// If previous call had unloaded data
int offset = info->leftOverByteCount;
// Load data from the read stream, accounting for the offset
bytesRead = CFReadStreamRead(info->readStream, info->buffer + offset,
kMyBufferSize - offset);
if (bytesRead < 0) {

fprintf(stderr, "CFReadStreamRead returned %ld\n", bytesRead);
break;
} else if (bytesRead == 0) {
break;

}

bufSize = bytesRead + offset;
totalBytesRead += bufSize;
```

数据被读取到缓冲区后，设置一个循环来解析数据。解析的数据不一定是整个目录列表；它可以（可能）是大块的列表。使用[CFFTPCreateParsedResourceListing](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/c_ref/CFFTPCreateParsedResourceListing)函数创建解析数据的循环，需传入缓冲区数据，缓冲区大小和字典引用。它返回解析的字节数。只要这个值大于0，继续循环。[CFFTPCreateParsedResourceListing](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFFTPStreamRef/index.html#//apple_ref/doc/c_ref/CFFTPCreateParsedResourceListing) 字典创建包含所有目录列表信息；关于更多可用键参阅设置流（ [Setting up the Streams](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html#//apple_ref/doc/uid/TP30001132-CH9-SW2)）。

`CFFTPCreateParsedResourceListing` 有可能返回一个正数，而不是创建一个解析字典。例如，如果在列表的末尾包含的信息不能被解析，`CFFTPCreateParsedResourceListing` 将返回一个正数告诉调用者数据已经消耗。然而，`CFFTPCreateParsedResourceListing` 不创建一个解析字典，因为它无法理解数据。

如果创建一个解析字典，重新计算读取的字节数和缓存区大小，如列表5-5所示。

列表5-5 加载目录列表并解析


```c
do{ 

bufRemaining = info->buffer + totalBytesConsumed;

bytesConsumed = CFFTPCreateParsedResourceListing(NULL, bufRemaining,
                                                bufSize, &parsedDict);
if (bytesConsumed > 0) {

    // Make sure CFFTPCreateParsedResourceListing was able to properly
    // parse the incoming data
    if (parsedDict != NULL) {
        // ...Print out data from parsedDict...
        CFRelease(parsedDict);
    }

    totalBytesConsumed += bytesConsumed;
    bufSize -= bytesConsumed;
    info->leftOverByteCount = bufSize;

} else if (bytesConsumed == 0) {

    // This is just in case. It should never happen due to the large buffer size
    info->leftOverByteCount = bufSize;
    totalBytesRead -= info->leftOverByteCount;
    memmove(info->buffer, bufRemaining, info->leftOverByteCount);

} else if (bytesConsumed == -1) {
    fprintf(stderr, "CFFTPCreateParsedResourceListing parse failure\n");
    // ...Break loop and cleanup...
}
} while (bytesConsumed > 0);

```

当流没有更多的可用字节，清理所有流并从运行循环删除它们。

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFFTPTasks/CFFTPTasks.html)
