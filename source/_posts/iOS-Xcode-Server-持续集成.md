title: iOS Xcode Server 持续集成
date: 2016-08-17 13:02:45
categories:  Mac OS Server
tags:  [Xcode Server]
---
[转载自牧码人_简书](http://www.jianshu.com/p/5faf777fdd97)


#前言
常用的持续集成工具有Jenkins、Travis CI、Xcode server等，当然我们选择最简单的Xcode server。

OS X server中集成了git版本管理功能，Xcode server持续集成服务，还有wiki知识库管理等，你甚至还可以拿它搭建一个网站服务器。

在持续集成过程中你可以直接使用os x server 的git版本管理功能，将代码提交至自己搭建的OS X server服务器。也可以将代码提交至其他git版本管理仓库中(比如GitHub)。

设备

>1.一台Git服务器，可以用GitHub、oschina等。
 2.一台装OS X Server的服务器，必须为MAC，下文简称 Xcode Server服务器。
 3.若干MAC做客户端，下文简称客户端。
 4.若干台iOS测试机。

![](http://cc.cocimg.com/api/uploads/20160418/1460947852507721.jpg)
<!-- more -->
#配置Xcode Server服务器

1、Apple给开发者可以凭开发者账号免费兑换OS X Server。免费兑换地址：

https://developer.apple.com/devcenter/mac/loadredemptioncode.action?seedId=13CB96H8S4

2、下载OS X Server后点击安装。

3、打开 Server 应用，以查看 OS X Server 中提供的服务列表。选择“Xcode”。

点按“选取 Xcode”按钮，然后在“应用程序”文件夹中选择“Xcode”。Xcode 服务将自动启动。

![](http://cc.cocimg.com/api/uploads/20160418/1460947991508601.jpg)

4、开发者团队

在此处千万不要添加开发者账号

![](http://cc.cocimg.com/api/uploads/20160418/1460948069330944.jpg)

5、添加git存储库，如果用Github、oschina或者自己搭建的git服务器则不需要此步骤。

Xcode 服务 Bot 将从源 Git 储存库访问项目和代码。

点按“储存库”，然后点按 添加按钮。选取 Git 储存库的名称，然后点按“创建”。

储存库的 URL 基于服务器主机名称和储存库名称。例如，储存库的 URL 将为：`https://myserver.example.com/git/Mac_Calc.git`

![](http://cc.cocimg.com/api/uploads/20160418/1460948113327431.jpg)

#配置Xcode客户端，创建bot

1、打开xcode>product>create bot

2、填写bot名称，选择Xcode Server服务器

![](http://cc.cocimg.com/api/uploads/20160418/1460948144163523.jpg)

3、Actions：选择执行的动作：

a、对代码进行静态分析

b、对代码进行单元测试

c、生成archive包（可以选择是否生成用户安装包）

4、cleaning：选择在何时清理项目，有几个选项（总是、每天、每周、从不）

5、configuration：选择编译配置（Debug、release）

![](http://cc.cocimg.com/api/uploads/20160418/1460948172334787.jpg)

6、选择在何时Xcode Server服务器开始持续集成，有几个选项（定时、在有新代码提交时、手动）

![](http://cc.cocimg.com/api/uploads/20160418/1460948204916489.jpg)

7、Before Integration 在开始持续集成前执行的脚本

8、After Integration在持续集成后执行的脚本

![](http://cc.cocimg.com/api/uploads/20160418/1460948361416744.jpg)

9、至此，创建bot完成

#Xcode Server服务器证书配置

1、配置Certificates

打开钥匙串，将iPhone Developer: xxx和iPhone Distribution:xxx导出为.p12文件

![](http://cc.cocimg.com/api/uploads/20160418/1460948394647612.jpg)

将导出的.p12文件 导入装OS X Server的MAC的钥匙串中，这次需导入到钥匙串系统中，而不是登录中

![](http://cc.cocimg.com/api/uploads/20160418/1460948423996794.jpg)

持续集成生成包时证书由/usr/bin/codesign管理，所以需将codesign添加为允许访问证书的程序

![](http://cc.cocimg.com/api/uploads/20160418/1460948458399167.jpg)

在显示简介中选择 访问控制 >始终通过这些应用程序访问 中点击加号，开始选择/usr/bin/codesign程序。选择完成后点击确认。由于usr是隐藏文件，在选择时使用快捷键 CMD+SHIFT+. 显示隐藏文件

![](http://cc.cocimg.com/api/uploads/20160418/1460948483341197.jpg)

按照以上步骤将iPhone Distribution:xxx的访问控制，也添加/usr/bin/codesign程序。

2、将Provisioning Profiles拷贝到Xcode Server

Xcode客户端证书保存在以下文件夹中

	User/Library/MobileDevice/ProvisioningProfiles

Xcode Server服务器证书保存在以下文件夹中

	/Library/Developer/XcodeServer/ProvisioningProfiles

将Xcode客户端路径下的证书保存至Xcode Server服务器对应路径下

3、在上传代码到仓库时需选择正确的证书，如下图

![](http://cc.cocimg.com/api/uploads/20160418/1460948525292926.jpg)

#开始持续集成

点击integrate开始持续集成

![](http://cc.cocimg.com/api/uploads/20160418/1460948567315763.jpg)

正常情况等待几分钟会看到下面的界面，说明持续集成完成。可以将ipa包安装到手机，也可以将Archive上传到appStore。当然也可以直接用iPhone Safari访问xcode server进行安装。

![](http://cc.cocimg.com/api/uploads/20160418/1460948609187346.jpg)


#cocoapod依赖管理,上传ipad

在本篇中我们主要讲解如何在持续集成前执行 pod install进行依赖管理，如何在持续集成后将.ipa上传至蒲公英服务器。


打开Xcode>Bot>Edit Bot>Triggers

![](http://cc.cocimg.com/api/uploads/20160420/1461119594489114.jpg)

首先添加Before Integrate脚本。

持续集成前先执行 pod install。

如果项目中没有使用CocoaPods管理三库请略过此步骤，想具体了解CocoaPods，请Google。

	export LC_ALL="en_US.UTF-8"

进入工程根目录

	cd QYBaseProject

 执行pod install

	/usr/local/bin/pod install

![](http://cc.cocimg.com/api/uploads/20160420/1461119641462086.jpg)

添加 After Integrate脚本。

持续集成后将ipa包上传至蒲公英。

蒲公英是免费的应用分发平台，如果没有注册请注册。注册后在账户设置中有API Key、User Key。。

```bash
IPA_NAME=$(basename "${XCS_ARCHIVE%.*}".ipa)
IPA_PATH="${XCS_OUTPUT_DIR}/ExportedProduct/Apps/${IPA_NAME}"
echo ${IPA_PATH}
```

请根据蒲公英自己的账号，将其中的 uKey 和 _api_key 的值替换为相应的值。

```bash
curl -F "file=@${IPA_PATH}" -F "uKey=User Key" -F "_api_key=API Key" http://www.pgyer.com/apiv1/app/upload
```

![](http://cc.cocimg.com/api/uploads/20160420/1461119665822939.jpg)

点击Integrate开始持续集成。

集成完成后Xcode server会自动将ipa包上传至蒲公英，上传成功后，蒲公英会给你发送邮件。

现在在iPhone Safari浏览器中打开邮件中的链接，点击安装。

如果你的开发者账号不是企业账号，请用在账号中添加过Device id的设备上安装。

![](http://cc.cocimg.com/api/uploads/20160420/1461119695808831.jpg)

