---
title: 'CFNetwork 编程指南之五: 与身份验证HTTP服务器通信(Communicating with Authenticating HTTP Servers)'
date: 2016-08-10 11:58:03
categories: iOS网络编程
tags: CFNetwork
---

#与身份验证HTTP服务器通信

本文描述了如何利用CFHTTPAuthentication API与需要身份验证的HTTP服务器通信。它解释了如何找到匹配的验证对象和证书，并将它们应用到HTTP请求，然后存储以供以后使用。

一般来说，如果一个HTTP服务器返回一个401或407响应你的HTTP请求，这表明服务器进行身份验证需要证书。在CFHTTPAuthentication API中，每个证书组存储在CFHTTPAuthentication 对象中。因此，每个不同的身份认证服务器和每个不同用户连接的服务器需要一个单独的CFHTTPAuthentication 对象。与服务器通信，你需要应用CFHTTPAuthentication 对象到HTTP请求。接下来更加详细的解释这些步骤。

<!-- more -->

##处理身份验证
添加身份验证支持将允许你的应用和身份验证服务器（如果服务器返回401或407响应）进行交互。尽管HTTP身份验证不是一个难的概念，它是一个复杂的过程。步骤如下：

>1.客户端向服务器发送一个HTTP请求。
2.服务器返回一个验证给客户端。
3.客户端将原始请求的证书打包并发送给服务器。
4.在客户端和服务器之间谈判
5.当服务器验证了客户端身份，返回请求的响应。

执行这个过程需要多个步骤。整个过程如图4-1和4-2.

![图4-1 处理身份验证](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Art/apply_2x.png)

![图4-2 找到一个身份验证对象](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/Art/authentication_2x.png)

当一个HTTP请求返回一个401或407响应，第一步是为客户端找到一个有效的CFHTTPAuthentication 对象。一个身份验证对象包括证书和其他信息，当应用到HTTP消息请求，与服务器验证你的身份。如果你已经与服务器进行过身份验证，你会有一个有效的身份验证对象。然而，在大多数情况下，你需要使用[CFHTTPAuthenticationCreateFromResponse](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPAuthenticationRef/index.html#//apple_ref/doc/c_ref/CFHTTPAuthenticationCreateFromResponse) 函数来创建一个对象。见列表4-1.

>注意：所有关于身份验证的示例代码改编自ImageClient 应用。

列表4-1 创建一个身份验证对象

```c
if (!authentication) {   

CFHTTPMessageRef responseHeader =
    (CFHTTPMessageRef) CFReadStreamCopyProperty(
        readStream,
        kCFStreamPropertyHTTPResponseHeader
    );

// Get the authentication information from the response.
authentication =
CFHTTPAuthenticationCreateFromResponse(NULL, responseHeader);   
CFRelease(responseHeader);
}
```

如果新身份验证对象有效，那么你已经完成可以继续图4-1的第二步。如果身份验证对象无效，然后扔掉身份验证对象和证书，检查证书。关于证书的更多信息，阅读安全证书（[Security Credentials](http://developer.apple.com/library/mac/qa/qa2001/qa1277.html)）。

不好的证书意味着服务器不接受登陆信息，它将继续监听新的证书。然而，如果证书是好的，但服务器仍然拒绝你的请求，然后服务器拒绝与你通信，你必须放弃。加上证书是不好的，重试整个过程，先创建身份验证对象直到你得到有效的证书和有效的验证对象。这个过程类似于列表4-2中的代码。

列表4-2 查找一个有效的身份验证对象

```c
CFStreamError err;

if (!authentication) {

// the newly created authentication object is bad, must return
return;
} else if (!CFHTTPAuthenticationIsValid(authentication, &err)) {
// destroy authentication and credentials
if (credentials) {
    CFRelease(credentials);
    credentials = NULL;
}
CFRelease(authentication);
authentication = NULL;

// check for bad credentials (to be treated separately)
if (err.domain == kCFStreamErrorDomainHTTP &&
    (err.error == kCFStreamErrorHTTPAuthenticationBadUserName
    || err.error == kCFStreamErrorHTTPAuthenticationBadPassword))
{
    retryAuthorizationFailure(&authentication);
    return;
} else {
    errorOccurredLoadingImage(err);
}
}

```
现在你有一个有效的身份验证对象，继续图4-1中的流程。首先，考虑你是否需要证书。如果你不需要，则应由身份验证对象到HTTP请求。身份验证对象应用到HTTP请求详见列表4-4（resumeWithCredentials）。

未存储证书（在内存中保存证书（[Keeping Credentials in Memory](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW6) ）和在永久性仓库中存储证书（[Keeping Credentials in a Persistent Store](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW5)）中有解释），获取有效证书的唯一方法是提示用户。大多数情况下，证书需要用户名和密码。通过传递身份验证对象到[CFHTTPAuthenticationRequiresUserNameAndPassword](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFHTTPAuthenticationRef/index.html#//apple_ref/doc/c_ref/CFHTTPAuthenticationRequiresUserNameAndPassword) 函数，你可以看到用户名和密码是必须的。如果证书需要用户名和密码，提示用户输入用户名和密码并在证书字典里存储。对于一个NTLM服务器，证书还需要一个域。在你有新的证书后，你可以调用列表4-4的函数resumeWithCredentials ，应用身份验证对象到HTTP请求。整个过程见列表4-3。

>注意：在代码列表中，前面有省略号的注释表明这个功能超出了本文的范围，但是需要实现。这不同与正常的注释描述正在发生什么功能。

列表4-3 查找证书（如果需要）并应用它们

```c
// ...continued from Listing 4-2
else {    cancelLoad();

if (credentials) {
    resumeWithCredentials();
}
// are a user name & password needed?
else if (CFHTTPAuthenticationRequiresUserNameAndPassword(authentication))
    {
    CFStringRef realm = NULL;
    CFURLRef url = CFHTTPMessageCopyRequestURL(request);

     // check if you need an account domain so you can display it if necessary
    if (!CFHTTPAuthenticationRequiresAccountDomain(authentication)) {
        realm = CFHTTPAuthenticationCopyRealm(authentication);
    }
    // ...prompt user for user name (user), password (pass)
    // and if necessary domain (domain) to give to the server...

    // Guarantee values
    if (!user) user = CFSTR("");
    if (!pass) pass = CFSTR("");

    CFDictionarySetValue(credentials,
kCFHTTPAuthenticationUsername, user);

    CFDictionarySetValue(credentials,
kCFHTTPAuthenticationPassword, pass);
   // Is an account domain needed? (used currently for NTLM only)
   if (CFHTTPAuthenticationRequiresAccountDomain(authentication)) {
       if (!domain) domain = CFSTR("");
       CFDictionarySetValue(credentials, kCFHTTPAuthenticationAccountDomain, domain);
   }
   if (realm) CFRelease(realm);
CFRelease(url);
} else {
   resumeWithCredentials();
   }
}
```
列表4-4 应用身份验证对象到请求

```c
void resumeWithCredentials() {   

// Apply whatever credentials we've built up to the old request
if (!CFHTTPMessageApplyCredentialDictionary(request, authentication,
                                            credentials, NULL)) {
    errorOccurredLoadingImage();
} else {
    // Now that we've updated our request, retry the load
    loadRequest();
}
}
```

##在内存中存储证书
如果你打算经常与一个身份验证服务器进行通信，重用证书可以来避免多次提示用户服务器用户名和密码。本章解释了一次性使用身份验证代码（例如处理身份验证（[Handling Authentication](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW3)））需要作出的变更，在内存中存储证书以便重用。

重用证书，你的代码中需要更改三个数据结构。

1.创建一个可变的数组来保存所有的身份验证对象。

	CFMutableArrayRef authArray;

代替：

	CFHTTPAuthenticationRef authentication;

2.使用字典，创建身份验证对象到证书的映射。

	CFMutableDictionaryRef credentialsDict;

代替：

	CFMutableDictionaryRef credentials;

3.保持这些结构在你原来修改当前身份验证对象和当前证书的地方。

	CFDictionaryRemoveValue(credentialsDict, authentication);

代替：

	CFRelease(credentials);

现在，创建HTTP请求后，在每次加载前，查找一个匹配的身份验证对象。查找适合对象的一个简单的非优化方法见列表4-5.

列表4-5 查找一个匹配的身份验证对象

```c
CFHTTPAuthenticationRef findAuthenticationForRequest {   

int i, c = CFArrayGetCount(authArray);
for (i = 0; i < c; i ++) {
    CFHTTPAuthenticationRef auth = (CFHTTPAuthenticationRef)
            CFArrayGetValueAtIndex(authArray, i);
    if (CFHTTPAuthenticationAppliesToRequest(auth, request)) {
        return auth;
    }
}
   return NULL;
}

```

如果身份验证数组有一个匹配的身份验证对象，然后检查证书仓库是否有正确的证书可用。这样做可以防止你需要再次提示用户输入用户名和密码。调用[CFDictionaryGetValue](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFDictionaryRef/index.html#//apple_ref/doc/c_ref/CFDictionaryGetValue) 函数可以查找证书，如列表4-6所示。

列表4-6 搜索证书仓库


	credentials = CFDictionaryGetValue(credentialsDict, authentication);


然后应用你的匹配的身份验证对象和证书到你原始的HTTP请求并重新发送。

>警告：在接收到服务器验证前，不要应用证书到HTTP请求。在你上次认证后，服务器可能改变，你可能会有一个安全风险。

有了这些变更，你的应用可以在内存中存储身份验证对象和证书以便未来使用。

##在永久性仓库中存储证书
在内存中存储证书可以防止用户在特定应用启动时重新输入服务器用户名和密码。然而，当应用退出，这些证书被释放。为了避免丢失证书，将它们保存到永久性仓库，这样每个服务器证书只需要生成一次。推荐用钥匙链来存储证书。即使你有很多个钥匙链，本文档中的钥匙链指的是用户默认的钥匙链。使用钥匙链表明你存储的身份验证信息可以用于其他试图访问同一个服务器的应用中，反之亦然。

在钥匙链中存储和检索证书需要两个函数：一个用于查找证书字典用于身份验证，另一个保存最近请求的证书。本文中这些函数声明如下：

```c
CFMutableDictionaryRef findCredentialsForAuthentication( CFHTTPAuthenticationRef auth);
void saveCredentialsForRequest(void);
```
findCredentialsForAuthentication 函数首先检查内存中的证书字典本地缓存是否有证书。如何实现见列表4-6。

如果内存中没有证书的缓存，然后搜索钥匙链。使用SecKeychainFindInternetPassword函数搜索钥匙链。该函数需要大量的参数。参数和一段简短的描述HTTP身份验证证书如何使用它们，如下：

`keychainOrArray`

NULL 指定用户默认钥匙链列表。

`serverNameLength`

serverName的长度，通常是strlen(serverName)。

`serverName`

从HTTP请求解析到的服务器名称

`securityDomainLength`

安全域的长度，或0表示没有域。在示例代码中， realm ? strlen(realm) : 0向账户传递两种情形。

`securityDomain`

利用CFHTTPAuthenticationCopyRealm 函数获取身份验证对象范围

`accountNameLength`

accountName的长度。由于accountName是NULL，值为0

`accountName`

当读取钥匙链记录时没有账户名，该字段为NULL。

`pathLength`

path的长度，如果没有路径则为0.在示例代码中，path ? strlen(path) : 0向账户传递两种情形。

`path`

利用CFURLCopyPath 函数从身份验证对象获取路径。

`port`

利用CFURLGetPortNumber函数获取端口号。

`protocol`

代表协议类型的字符串，例如HTTP或HTTPS。通过CFURLCopyScheme 函数获取协议类型。

`authenticationType`

利用CFHTTPAuthenticationCopyMethod函数获取身份验证类型。

`passwordLength`

0，因为在读取钥匙链记录时不需要密码。

`passwordData`

NULL，因为在读取钥匙链记录时不需要密码。

`itemRef`

查找到正确的钥匙链记录，返回钥匙链记录引用对象SecKeychainItemRef。

当正确的调用，代码如列表4-7所示。

列表4-7 搜索钥匙链

```c
didFind =   

SecKeychainFindInternetPassword(NULL,
                                strlen(host), host,
                                realm ? strlen(realm) : 0, realm,
                                0, NULL,
                                path ? strlen(path) : 0, path,
                                port,
                                protocolType,
                                authenticationType,
                                0, NULL,
                                &itemRef);
```


假设SecKeychainFindInternetPassword 成功返回，创建一个包含单独钥匙链属性(SecKeychainAttribute)的钥匙链属性列表(SecKeychainAttributeList)。钥匙链实现列表将包含用户名和密码。为了加载钥匙链属性列表，调用SecKeychainItemCopyContent 函数并将SecKeychainFindInternetPassword返回的钥匙链记录引用对象(itemRef)传递给它。该函数将用账号的用户名和密码void \**填充到钥匙链属性中。

用户名和密码可以用来创建一组新证书。列表4-8展示了这个过程。

列表4-8 从钥匙链价值服务器证书。


```c
if (didFind == noErr) {

SecKeychainAttribute    attr;
SecKeychainAttributeList attrList;
UInt32                  length;
void                    *outData;

// To set the account name attribute
attr.tag = kSecAccountItemAttr;
attr.length = 0;
attr.data = NULL;

attrList.count = 1;
attrList.attr = &attr;

if (SecKeychainItemCopyContent(itemRef, NULL, &attrList,
&length, &outData)== noErr) {
    // attr.data is the account (username) and outdata is the password
    CFStringRef username =
        CFStringCreateWithBytes(kCFAllocatorDefault, attr.data,
                                attr.length, kCFStringEncodingUTF8, false);
    CFStringRef password =
        CFStringCreateWithBytes(kCFAllocatorDefault, outData, length,
                                kCFStringEncodingUTF8, false);
    SecKeychainItemFreeContent(&attrList, outData);

    // create credentials dictionary and fill it with the user name & password
    credentials =
        CFDictionaryCreateMutable(NULL, 0,
                                  &kCFTypeDictionaryKeyCallBacks,
                                  &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(credentials, kCFHTTPAuthenticationUsername,
                        username);
    CFDictionarySetValue(credentials, kCFHTTPAuthenticationPassword,
                        password);

    CFRelease(username);
    CFRelease(password);
}
CFRelease(itemRef);
}
```



如果你可以先存储证书到钥匙链中，从钥匙链中检索证书才有用。首先，查看证书是否已经存储在钥匙链中。调用SecKeychainFindInternetPassword，传递用户名到accountName ，传递accountName 的长度到accountNameLength``。

如果记录存在，修改它来改变密码。设置钥匙链属性的数据字段包含用户名，主要你可以修改正确的属性。然后调用SecKeychainItemModifyContent 函数并传递钥匙链记录引用对象(itemRef)，钥匙链属性列表和新密码。通过修改钥匙链记录而非重写，钥匙链记录会正确的更新其他相关数据也将保留。记录如列表4-9所示。

列表4-9 修改钥匙链记录

```c
// Set the attribute to the account name   
attr.tag = kSecAccountItemAttr; 
attr.length = strlen(username); 
attr.data = (void*)username;
// Modify the keychain entry   
SecKeychainItemModifyContent(itemRef, &attrList, strlen(password),   
(void *)password);
```

如果记录不存在，你将需要从头开始创建它。`SecKeychainAddInternetPassword` 函数完成该任务。它的参数与`SecKeychainFindInternetPassword`相同，但与调用`SecKeychainFindInternetPassword`相比，你提供用户名和密码给`SecKeychainAddInternetPassword` 。释放钥匙链记录引用对象成功后调用`SecKeychainAddInternetPassword` ，除非你需要在其他地方使用。见列表4-10函数调用。

列表4-10 存储一个新的钥匙链记录

```
SecKeychainAddInternetPassword(NULL,   

                          strlen(host), host,
                          realm ? strlen(realm) : 0, realm,
                          strlen(username), username,
                          path ? strlen(path) : 0, path,
                          port,
                          protocolType,
                          authenticationType,
                          strlen(password), password,
                          &itemRef);

```


身份验证防火墙
身份验证防火墙与身份验证服务器非常相似，处理必须检查每个失败的HTTP请求的代理身份验证和服务器身份验证。这以为着，你需要单独存储（本地和永久）代理服务器和源服务器。因此，失败的HTTP响应的过程如下：

- 确定响应的状态码是否为407（代理怀疑）。如果是，检查当地代理仓库和永久性代理仓库查找一个匹配的身份验证对象和证书。如果这些都没有一个匹配的对象和证书，然后请求用户证书。应用身份验证对象到HTTP请求并重试。

- 确定响应的状态码是否为401（服务器怀疑）。如果是，遵循与407响应相同的过程，但是用原始服务器存储。

使用代理服务器有些细微的差别。首先，钥匙链调用的参数来自于代理主机和端口，而非一个源服务器的URL。第二，当要求用户输入用户名和密码，确保清楚的提示是什么密码。

通过这些指令，你的应用应该可以使用身份验证防火墙。

官方原文地址：
[CFNetwork Programming Guide](https://developer.apple.com/library/ios/documentation/Networking/Conceptual/CFNetwork/CFHTTPAuthenticationTasks/CFHTTPAuthenticationTasks.html#//apple_ref/doc/uid/TP30001132-CH8-SW1)
