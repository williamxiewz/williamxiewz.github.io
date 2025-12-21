title: swift perfect 服务器配置https证书
date: 2017-06-02 10:59:57
categories: Swift Perfect
tags: [Https,Swift perfect,EC2]
---


https://medium.com/@iamjono/easily-secure-your-perfect-server-side-swift-code-with-https-3df86a8cab28


因项目需要须使用https服务，得知阿里云可以免费申请，确实感谢。
我们的前提：  1.有阿里云的服务器账号。
            2.申请的域名托管在阿里云的云解析服务
有了这两个前提申请就方便快捷多了。

1.登录阿里云-->安全(云盾)-->CA证书服务
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl1.jpeg)

2.选择购买证书
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl2.jpeg)


3.在配置单中选择 "免费型DV SSL"   证书提供商品牌为:“赛门铁克”
                           注意:免费数字证书,最多保护一个明细子域名,不支持通配符，一个阿云帐户最多签发20张免费证书
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl3.png)

4.支付 （0元）
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl4.png)

5.支付后会看到一条状态为“待完成”的记录，此时千万别以为就可以等待阿里云审核了，其实后面还是有资料要填写的。
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl5.png)

6.选择补全.
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl6.png)

7.填写相应信息。真实填写就可以了。包括：域名、姓名、邮箱等等。因为我的域名是托管到阿里云解析服务的，所以我的认证方式DNS解析认证。填写完成后才是“待审核”状态，等待就可以了。
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl7.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl8.png)

8.系统生成证书.填写完毕就是提交审核,
阿里云会发生一份邮件给你填写的邮箱,邮件的内容：发送给你的 主机记录和记录值，这个应该是阿里云去做的认证审核。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl9.png)

9.订单进度
我勾选了DNS 证书绑定的域名在阿里云解析产品上,会自动帮我们添加记录.
如果没有使用阿里云的DNS域名解析,那手动去添加吧.
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl10.png)


10.等待10分钟，此过程阿里云系统会去检测，检测到了就成功，此时你的域名证书记录状态为“已签发”

11.下载此证书，选择对应的应用服务器，我们用的是nignx，下载后一个压缩文件，里面包含2个文件,xx.pem xx.key。
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/swiftperfectssl11.png)

12.安装证书,80 端口重定向到https

```swift
let confData = [
    "servers": [
        // Serves Port 80
        // Configuration data for another server which:
        //	* Redirects all traffic back to the first server.
        [
            "name":"localhost",
            "port":80,
            "routes":[
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.redirect,"base":"https://localhost"]
            ],    
        ],
        // Serves Port 443.
        [
            "name":"localhost",
            "port":443,
            "routes":[
                ["method":"get", "uri":"/", "handler":PerfectHTTPServer.HTTPHandler.staticFiles],
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
                 "documentRoot":"./webroot",
                 "allowResponseFilters":true]
            ],
            "tlsConfig":[
                "certPath": "./webroot/cert/21411439650856.pem",
                "verifyMode": "peer",
                "keyPath": "./webroot/cert/21411494650856.key",
                "cipherList":"ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4"
            ],
            "runAs":"root",
        ]
    ]
]
```

13. local build  test 

14.delopy swift perfect


15.通过https访问，大功告成。

16.apple ATS 测试


```bash
nscurl --ats-diagnostics --verbose https://www.konekti-ai.com
```
