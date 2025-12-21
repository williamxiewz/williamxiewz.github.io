title: 发布自己的pods到CocoaPods trunk
date: 2017-03-15 22:45:58
categories: 
tags:
---

使用CocoaPods trunk之前请确认CocoaPods版本是否是0.33或以上，打开Teaminal(终端)输入pod --version即可查看，如果版本过低，请执行sudo gem install cocoapods安装最新版本！

1.注册trunk
pod trunk register xxx@cocoapods.org 'williamxie' --description='williamxie' macbook pro' --verbose

xxx@cocoapods.org - 一个真实存在的邮箱,替换自己的邮箱
williamxie - 用户名
williamxie's macbook pro - 描述性文字

如果所有的步骤都能成功的话，你会受到一份邮件，需要点击验证下。

查看trunk
pod trunk me

可以查看你已经注册的信息，其中包含你的name、email、since、Pods、sessions，其中Pods为你往CocoaPods提交的所有的Pod！

添加其他维护者（如果你的pod是由多人维护的，你也可以添加其他维护者）
pod trunk add-owner XPRACSignal williamxie@cocoapods.org

以上所有的步骤都是准备阶段……



进入项目级步骤

创建podspec
pod spec create DeepSwift
执行完该命令之后会在工程目录生成DeepSwift.podspec文件，然后编辑这个文件！里面注释很多，应该都能看懂，就不一一讲解了。这里就贴一张图了，该文件去掉了很多注释信息，以免干扰！



提交code到git仓库中，并打上tag版本号
这一步可使用git命名行也可使用工具，最重要的是tag，因为CocoaPods是根据tag来分析的！

提交到CocoaPods trunk
执行命令pod trunk push即可完成提交，改命令会首先验证你本地的podspec文件，之后会上传spec文件到trunk，最后会将你上传的podpec文件转换为需要的json文件。
提示：
1.验证podspec也可手动执行命令pod spec lint DeepSwift.podspec
2.提交成功之后以前需要花些时间去验证（猜测可能是跑build等），貌似现在稍等1分钟就可以。

测试pod
执行命令pod search DeepSwift



补充

如果你之前提交过Pod，那么trunk之后你需要去Claim your Podp[https://trunk.cocoapods.org/claims/new]认领下！
