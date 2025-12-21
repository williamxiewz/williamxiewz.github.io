---
title: iOS App上架流程
date: 2016-08-08 22:16:57
categories: iOS SDK
tags: [iOS上架App Store] 
---

准备条件:
>1.一个已付费的开发者账号（账号类型分为个人（Individual）、公司（Company）、企业（Enterprise）、高校（University）四种类型，每年资费分别为$99、$99、$299、免费。）。
2.你的Xcode必须是正式版的.

打开苹果开发者中心：https://developer.apple.com

打开后点击：账号
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide1.png)
<!-- more -->
开发者登录账号

点击：Certificates, Identifiers & Profiles (专门生成证书，绑定Bundle Id，绑定device设备，生成描述文件的地方)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide2.png)


点击Certificates生成证书

>1.选择iOS, tvOS, watchOS
 2.选择All
 3.点击右上角新添加证书

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide3.png)

由于是做App上传，选择生产证书（选择App Store and Ad Hoc）


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide4.png)

>注意：一个开发者账号只能创建（1-2个开发（测试）证书，2-3个生产（发布）证书），如果你的App Store Ad Hoc 前面的按钮不能选择，则代表你的这个账号无法再创建新的生产证书了。
解决方法：

从共同使用这个账号的人电脑上生成.p12文件，导入自己的电脑。（尽量不要执行下面第2步）
如果你想生成的话，把现有的删除一个（建议删除时间比较靠前的）。注意：如果删除一个证书，那么正在使用这个证书的人将不能再使用了，除非重新生成，然后利用.p12重新导入自己的电脑里！
注意：如果你想删除证书，执行下面步骤，否则略过。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide5.png)
然后接上上图，生产证书部分继续


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide6.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide7.png)

上传CSR文件去获取证书（CSR文件需要我们到本机钥匙串里去创建）


在Launchpad的其他里面，点击钥匙串访问弹出如下界面

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide8.png)

钥匙串访问
工具栏选择钥匙串访问->证书助理->从证书颁发机构请求证书...


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide9.png)

填写信息
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide10.png)

将CSR文件保存到MAC磁盘的某个位置（这里我选择的是桌面，进行存储）
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide11.png)

![CertificateSigningRequest.certSigningRequest 文件](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide13.png)


然后回到浏览器，点击choose File..
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide14.png)



选择创建好的：CertificateSigningRequest.certSigningRequest 文件，点击选取
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide15.png)


跳转到如下界面，点击 DownLoad 下载生成的证书（cer后缀的文件），然后点击Done，你创建的发布证书就会存储在帐号中。
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide17.png)



注意：这个证书只能下载一次。点击下载后，关闭页面后就不能再回到下载页面了。
如果不需要给别的电脑使用，则直接跳过下面附加项，跳转到第五步（绑定Bundle Identifier）

![附加项：生成p12文件在其他电脑上使用这个发布证书](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide20.png)

双击安装证书后，打开钥匙串访问，选择安装的证书右键单击
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide18.png)

安装的发布证书

注意：如果没有导出，可以把这个证书删除，然后重新双击下载的证书文件安装。
导出证书
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide19.png)


存储证书

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide20.png)


>注意：存储的文件格式一定要是.p12

设置密码

可以为证书设置密码，也可以不设置密码；如果设置了密码，那么别人安装这个证书的时候就要输入密码，否则无法安装。这里就不设置密码了。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide21.png)



保存导出的证书

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide22.png)

如果需要在其它电脑上也能发布App,那么就必须要安装这个发布证书。

五、创建App IDs和绑定你的App的Bundle Identifier
回到刚才的页面：https://developer.apple.com/account/ios/identifiers/bundle/bundleList.action

点击App IDs,进入如下界面，点击右上角的 + 号

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide23.png)


填写App IDs和Bundle Identifier

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide24.png)



注意：

上传App使用的Bundle Identifier(不要有-，都是英文+数字)必须是固定的，不能使用占位符。
如果你的Bundle Identifier已经在网站上绑定了，如果你又修改了你工程里面这个Bundle Identifier的话，需要重新进入到开发者账号里面绑定。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide25.png)


下面选择App中包含的服务，默认有两项，其余的根据自己项目的需求进行选择

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide26.png)

点击continue
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide27.png)



点击Register

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide29.png)

点击Done

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide28.png)



六、生成描述文件（描述文件的作用就是把证书和Bundle Identifier关联起来）
找到Provisioning Profiles ，点击All，然后点击右上角 + 号

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide30.png)


因为是发布，所以选择下面App Store这个描述文件，点击Continue

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide31.png)


在App ID 这个选项栏里面找到你刚刚创建的：App IDs（Bundle Identifier） 类型的套装，点击Continue


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide32.png)

选择你刚创建的发布证书（或者生成p12文件的那个发布证书），根据自己电脑上的发布证书日期来选择，点击Continue

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide33.png)


在Profile Name栏里输入一个名字（这个是PP文件的名字，可随便输入，在这里我用工程名字，便于分别），然后点击Generate


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide34.png)

Download生成的PP文件，然后点击Done，双击安装（闪一下就完事了，没其它效果）


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide35.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide36.png)


六、在App Store开辟空间
回到Member Center，点击iTunes Connect

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide37.png)


登录开发者账号（还是之前已付费的账号）

登录成功后，点击我的App

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide38.png)


点击左上角那个＋号，点击新建(注意：我们是iOS App开发，不要选Mac App啦）


依次按提示填入对应信息（SKU是公司用于做统计数据之类的id，根据公司需求填写），然后点击创建

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide39.png)


注意：如果都填好以后，可能会告诉你，你的App名称已经被占用，那么不好意思，你只能改名了！（而且建议大家起名不要往比较出名的App上靠，否则审核可能会被拒绝）

填写App其它信息

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide40.png)


填写价格和销售范围（由于我的开发者账号没有签订纳税合同，所以不能上线收费应用，所以只能暂时免费）

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide41.png)


依次把不同尺寸的App截图拉入到对应的里面
需要填写不同尺寸的手机屏幕截图（也就是拿不同尺寸的模拟器运行后，挑出至少3页最多5页进行截图然后拖到响应的区里）（在模拟器Command＋S 就可以保存屏幕截图到桌面了）（注意：如果提示拖进去的图片尺寸不对，则把模拟器弄成100%然后再Command 加 S) 尺寸参照表在下面


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide42.png)


尺寸参照图

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide43.png)


填写App简介

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide44.png)


按提示依次输入

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide45.png)



错误提示：如果上传App 图标失败，提示Alpha错误的话，看下面。
打开你的图标图片，勾掉这个

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide46.png)

点击分级后面的编辑，如实填写后，点击完成

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide47.png)

填写审核信息

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide48.png)


版本发布就是：（然后最下面选择自动发布的话就是如果审核通过，就自动上传到App Store供人下载）

此时这个构建版本还没有生成，我们先把基本信息填写完毕，然后再进入Xcode中把项目打包发送到过来。

七、在Xcode中打包工程
找到你刚刚下载的发布证书（后缀为.cer）或者p12文件，和PP文件，双击，看起来没反应，但是他们已经加入到你的钥匙串中。

在Xcode中选择iOS Device(这里不能选择模拟器)，按照下图提示操作

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide49.png)


查看版本号和构建版本号

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide50.png)


配置发布证书

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide51.png)


检查
将断点、全局断点，僵尸模式等都要去掉。
设置Release模式（Debug是测试的，Release是发布用的）

选择 Xcode下 Product 下 Archive（专门用于传项目，或者打包项目）

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide52.png)

输入付费的开发者账号

选择Upload提交

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide53.png)

如下就代表上传成功

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide55.png)

返回﻿﻿ItunesConnect网站上你自己的App信息中查看一下

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide56.png)

另一种上传应用的方式:

Application Loader上传应用

点击export 导出 ipa
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide58.png)

选择第一个,导出成功以后
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide59.png)

打开Application Loader应用
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide60.png)
操作界面
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide61.png)
开始上传应用
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide62.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide63.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperappdistributionguide64.png)
