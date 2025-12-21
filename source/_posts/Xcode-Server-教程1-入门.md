---
title: Xcode Server 教程1：入门
date: 2016-08-17 13:03:42
categories: iOS开发
tags: [Xcode Server, CI, 持续集成, Mac OS Server, iOS]
description: Xcode Server入门教程，学习如何安装和配置Xcode Server进行持续集成，包括环境搭建、Bot创建等基础知识
keywords: Xcode Server,持续集成,CI,Bot,自动化测试,iOS开发
---

[原文翻译地址](https://honzadvorsky.com/articles/2015-08-04-xcs_tutorials_1_getting_started/)

> 这篇文章是 Xcode Server 系列教程的第一部分，带你入门 Apple 官方的持续集成解决方案。

## 前言：为什么需要持续集成？

想象一下这样的开发场景：你的团队成员花费数周时间开发一个新功能分支，却没有及时合并其他人的修改。当产品经理催促交付时，他创建一个 Pull Request。大家快速浏览代码（因为它包含了数千行新增代码），草草完成代码审查后合并上线。一切看似完美？

### 现实中的问题

事实并非如此。你兴致勃勃地开始新功能开发，期待着喝彩和掌声。然而在 Twitter 上消磨时光后，你发现没有对新功能进行充分测试，应用在 32 位设备上崩溃了。

这不是虚构的故事，而是许多团队的真实写照。大多数团队都没有实施[持续集成](https://en.wikipedia.org/wiki/Continuous_integration)（CI），要么觉得团队规模太小不需要，要么太忙没时间搭建。

> **持续集成**是一种软件开发实践，强调频繁地集成代码变更，并通过自动化测试确保代码质量。

在上面的例子中，持续集成的两个核心原则都被打破了：
1. **了解变更内容** - 团队不知道合并了什么（一个 bug 导致应用在 32 位设备崩溃）
2. **频繁集成** - 没有及时合并代码，导致大量差异，无法进行有效的代码审查

## Xcode Server 简介

如果你的团队还没有使用 CI，或者现有的 CI 工具效果不佳，这篇文章就是为你准备的。今天将展示如何使用 Apple 官方的持续集成服务器——[Xcode Server](http://help.apple.com/serverapp/mac/4.0/#/apdEC37D10C-B277-4C06-9E1F-8DCB0A5970EB)（简称 XCS）。
<!-- more -->
## Xcode Server 的优势

Xcode Server 之所以成为我所有项目的首选 CI 解决方案，有以下几个关键优势：

### 🚀 核心特性
- **完全免费** - Apple 官方免费提供
- **自托管** - 数据完全在自己控制下
- **设备测试** - 支持在已连接的 iOS 设备上进行测试
- **OTA 安装** - 支持应用无线安装和分发
- **版本控制** - 可以精确控制 Xcode 版本，无需等待他人更新

### 🎯 独特优势
最重要的是，**Xcode Server 由 Xcode 的维护者开发**，这意味着你能获得：
- Xcode 最新版本和最新特性的原生支持
- 代码覆盖率统计
- UI 测试结果可视化
- 性能测试基准
- 与 Xcode 完美集成


## 教程计划

### 本篇内容
- Xcode Server 基础安装和配置
- 创建第一个 Bot
- 基本的构建和测试流程在这个系列的后续文章中，我将解释如何从中获取CocoaPods（甚至是私有pod）之类的工具，如何归档Ad Hoc 和App Store版本，如何插入诸如“[Buildasaur](https://github.com/czechboy0/Buildasaur) ”和“[fastlane](https://fastlane.tools/) ”之类的工具，甚至如何编写相对于Xcode Server API的程序。总的说来，我会展示如何充分利用XCode Server。

这个系列主要讲述如何使用XCode Server。如果你想了解XCode Server内部是如何工作的，我已经写过这样的一篇[文章](http://honzadvorsky.com/articles/2015-05-04-under-the-hood-of-xcode-server/)。

#所需软件清单

为了深入理解这篇文章，你需要：

- 装有OS X10.10或者以上版本的Mac，Xcode 6或者更高版本
- 访问Developer Portal的苹果开发者账号

#环境

我选择使用XCode 7 beta 3和OS X Server5 beta 3，尽管它们都是测试版。与OS X Server 4和XCode 6 没有太大区别。所以都使用旧一点的版本应该也没有问题（只是屏幕看上去会有些许不同）。

#本文主旨

本文中，我们要在你的Mac上安装OS X Server，并使得它与XCode可以一起使用。然后我们在XCode Server上创建一个Bot，来测试一个从GitHub下载下来的iOS 应用程序。 就这样。非常简单易懂，这篇文章接下来的部分，我们会更接近一个真实的，更为复杂的iOS开发团队建立。

我们开始吧！

#1.下载OS X Server

XCode需要 OS X Server开启持续集成服务。在Mac App Store上下载OS X Server一般要花费19.99美元。然而，iOS和Mac 开发者可以免费下载。接下来我们要进行免费下载。

浏览开发者门户的OS X [下载区](https://developer.apple.com/osx/download/)，下载最新版本的OS X Server5（你需要登录你的开发者账户。）

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart11.jpg)

现在点击已下载的安装包，安装OS X Server。

#2.启用XCode Server

启动OS X Server（在你的应用程序文件夹下，名字为“Server.app”）,点击Services下面的Xcode。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart12.jpg)

然后你需要告诉 OS X Server 使用哪一个XCode，点击“Choose Xcode…”，选择你的XCode 7（XCode 6 也可以）就可以了。

接下来，XCode Server需要花费大约30秒完成准备工作。之后点击右上角的ON 开关，状态文本将会变成“Starting”。当所有准备工作完成，开始运行的时候，可以看到一个绿色的圆点和“Available on your local network…”。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart13.jpg)

好了，你建立起一个XCode Server！

#3.检出我们的测试工程

现在，我们创建一个Bot来测试GitHub上的一个应用程序（这是我为你特别准备的，是不是很善解人意？）正如你期望的，它叫做，“[XCSTutorial Project1](https://github.com/czechboy0/XCSTutorialProject1)”。它是一个带有iOS 应用程序目标的XCode工程。

创建Bot的一种方式是直接由XCode创建。为了后续工作顺利进行，首先需要将你的工程检出到本地。现在我们进行检出。打开终端，切换到工作路径下，比如在你的文档目录下，运行下面的三个命令：

```bash
git clone --branch step1 git@github.com:czechboy0/XCSTutorialProject1.git
cd XCSTutorialProject1
open XCSTutorialProject1.xcodeproj
```
这会把工程克隆到本地（向导的第一步）并在XCode中打开。请确保你正在使用的XCode与之前在XCode Server中选择的XCode是同一个（最好是XCode 7）。

#4.在XCode中追加Server

在我们创建Bot之前，我们需要在XCode注册我们新创建的XCode Server。选择 XCode 的`Preferences` (CMD+,)，然后选择“Accounts”，在底端点击加号按钮，选择“Add Server”。


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart14.jpg) 

在地址栏输入本机地址（127.0.0.1），因为刚刚在本机上安装了XCode Server……

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart15.jpg)

然后输入凭证（与Mac账户的凭证相同，对我来说是 User Name: honzadvorsky和我的登录密码。）

点击“Add”之后，你会看到你的服务器被追加到XCode的Preference里面。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart16.jpg)

#5.创建一个Bot

我一直在说Bot，但是它们到底是什么东西呢？

`Bot`，是一个XCS 的专业术语，是一个构建工作的描述。它告诉XCode Server 代码位置，如何去生成以及测试代码，在生成结束以后通知哪些人等等。运行一次这样的`Bot`叫做`集成`。集成产生有价值的东西，比如archives、IPA、测试结果和日志。

现在来创建我们的第一个Bot。Bot的控制按钮隐藏在XCode左边区域的最后一列，Report导航栏下。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart17.jpg)

在左下方，点击齿轮图标和“Create Bot…”。

 
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart18.jpg)

现在可以看到弹出了一个与下面类似的表单，注意，复选框要求你共享scheme。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart19.jpg)

这是什么意思呢？

>Scheme 是你 xcodeproj j和 xcworkspace文件夹下的文件，描述了使用哪一个目标（例如 XCSTutorialProject1 - iOS app）和如何生成（例如Debug 或者 Release）。只有共享的schema才可以检入到你的代码库，并且只有这些共享的schema可以被持续集成服务例如XCode Server使用。

总体而言，schema是一个生成方案。所以要确保XCode Server可以看到它，这里我们通过共享实现（当在XCode里面编辑scheme的时候，点击Shared 复选框，这会将scheme加入到我们的代码库中）。

第一次在你的项目中创建Bot，你会看到这个。通常，你会继续并让XCode提交scheme到你的代码库。但是我已经为你做完了这些。所以，点击Cancel，转到终端，在你的工程文件夹下运行下面的命令


```bash
git checkout step2
```

然后重启XCode（抱歉，XCode不喜欢自己修改scheme），重复Bot创建过成。这一次，应该没有关于scheme的消息了，正如下面截图所示。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart110.jpg)

点击下一步，此处你的XCode将会检查是否有权访问你的（实际上，此处是我的）代码库。很有可能（如果你像我一样使用一个自签证书）会首先看到XCode抱怨`“The server SSH fingerprint failed to verify.”`这是XCode 7的新的特性，来防止[MITM](https://en.wikipedia.org/wiki/Man-in-the-middle_attack)袭击。你需要点击“View”然后点击“Trust”。这意味着你声明：“没有问题，XCode。我了解并且相信这个XCode Server，不需要担心。”

然后，如果你还没有在XCode的Preferences -> Accounts中登录到你的代码库，XCode会要求你“登录”，它说`“请提供证书，以便于XCode Server可以从这个代码库中检出文件。”`点击“登录”，告诉XCode，是要创建新的SSH键还使用既存的。因为在 ~/.ssh/里面已经存在SSH键，所以我告诉XCode “使用既存的SSH键”。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart111.jpg)

你的Bot会获取选定分支上的变更，生成代码的最新版本。这意味着如果你想在多分支上测试代码，比如说 master 和 release两个分支，你需要为它们创建两个独立的Bot（在后续的教程中，我们利用[Buildasaur](https://github.com/czechboy0/Buildasaur)使得这个过程连贯起来）。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart112.jpg)

选择master，然后点击Next。等一下你会看到所有Bot的配置选项。我们来看一下这些都意味着什么（这段时间比较适合去喝一杯咖啡或者去趟洗手间……伦敦现在的天气不错，不是吗？……板球……好了，回到Bots！）

#6.Bot配置

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart113.jpg)

`Schedule`告诉Bot什么时候运行:

- Periodical 意味着Bot每小时，每天还是每周运行一次
- On Commit使得Bot每5分钟从代码库获取一次最新代码，并且无论何时，发现新的提交任务，都会启动新的集成。在 master 分支上的On Commit Bot可以帮助你快速的发现什么时候测试开始失败，而不需要每个人都记着去手工执行测试
- Manual 只有当点击XCode中的“集成”时才会运行

`Actions` 告诉Bot要做那些工作:

- Perform analyze action运行静态分析
- Perform test action运行应用程序测试
- Perform archive action存档你的应用程序，以备在TestFlight或者应用程序商店发布时使用。
- 允许查看测试覆盖了哪些代码，这个选项会迫使XCode Server收集覆盖率数据而无需在scheme中将偏好设置为on。如果在本地运行测试，你不想收集覆盖率数据，但又需要利用在CI 服务器运行时的覆盖率，这个特性就显得非常有用。
- 标记和导出，应用程序从生成档案中通过Wi-Fi直接安装到iOS设备上，以后我会专门写一篇文章介绍你应该如何实现这一操作。

`Configuration` 允许重写Bot的生成配置（Debug，Release……）。我总是选择默认的“Use Scheme Setting”。

`Cleaning`通过定期地清除它的所有资源并从scratch上检出代码库，确保Bot不会依赖于 DerivedData 的状态，或者它的源文件夹。你曾经遇到过损坏的 Pods 文件夹吗？这是一种在新的集成（从scratch上检出所有的东西）开始之前移除所有的产品、中间文件和源文件夹的方式。选项有：

- Always – 每次集成前移除所有的产品和中间产物
- Once a day – 每天只有第一次集成从scratch开始
- Once a week – 每周只有第一次集成从scratch开始
- Never – 不能自动移除产品

选项很多，是吗？但是，无需担心，一般使用默认值就可以了。如果不做任何更改，应该是不会有问题的。

现在请确保“Perform test action”被选中，点击下一步。

在这里，XCode 7 Beta 4 似乎有一个bug，XCode崩溃了。并不是对所有用户都出现，但是如果你的XCode此时崩溃了，请安装 [XCode7 Beta 5](https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_7_beta_5/Xcode_7_beta_5.dmg) 或者以上版本来代替之前的XCode。

你将会看到一个标题为“Choose the devices that this bot will test with”的页面，这正是我们现在要选择的。在顶端的下拉框中有一个值是“iOS”，并且是不可用的。这是因为在一开始选择的这个scheme告诉XCode Server 我们在一个iOS 目标上生成。

`Test With` 给了你四个选项：

- All iOS Devices and Simulators – 在所有已连接的iOS设备和模拟器上进行测试。这会花费一定的时间，因为每个版本的iOS都有10多个模拟器。如果你安装了两个XCode，像我现在这样，就要测试iOS8.4和 iOS 9.0，一共有20多个设备。然而，如果是只花费几秒钟的单元测试，这个时间是可以的。
- All iOS Devices – 所有已连接的iOS设备，不包含模拟器。
- All iOS Simulators –所有的iOS模拟器，不包含已连接的iOS设备。
- Specific iOS Devices – 指定的模拟器和已连接的iOS设备。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart114.jpg)

我们选择最后一个选项，指定的iOS设备，选择3个设备进行测试。如果你已经连接了一个开发设备，它会直接显示在列表中，你可以将它包含到你的测试进程（超简单）。

一直点下一步，直到看到一个叫做“Configure Bot triggers”的页面。

`触发器`是一种在集成之前或者之后运行的行为。XCode Server支持两种触发器类型：脚本和发送邮件通知。

使用`脚本`，你基本上可以实现实现所有功能：运行 pod install，或者 fastlane ，甚至是当生成结束以后通知其他成员。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart115.jpg)

`Weirdness Alert` – 有个地方特别容易出错。当XCode Server检出代码库的时候，没有把路径变更到附录文件夹（就像你运行 git clone ...到本地的时候，你需要将路径改变到你的工程目录）。因此在你的脚本中，需要做的第一件事情是 cd PROJECT_NAME （在我们的案例中是 cd XCSTutorialProject1)然后再运行 pod install 或者 fastlane。

第二个触发器类型是`发送邮件通知`，它并不是你期望的那样。当集成结束的时候它会给你发送一封邮件。然而它比这更聪明。它可以发送邮件给所有的提交者，因为它知道谁在上一次集成后提交过代码。这样，只有变更代码的人会被通知。如果想让某些地址总是可以收到这些邮件，你也可以追加。

你也可以指定当集成失败的时候只通知你，你也可以控制这些邮件的内容。非常棒！

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart116.jpg)

创建一种类型的邮件通知，追加上你的邮件地址。但是，不要勾选Bot中发送给所有的提交者复选框。否则，我会收到你完成集成的邮件（因为我是所有这些内容的提交者。）这是XCode Server一个非常有趣的地方——它的邮件系统不是为开源项目设计的。

你点击“Create”之后，应该可以看到你创建第一个Bot的请求成功了。

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopxcodeserverpart117.jpg)

祝贺你！创建了第一个Bot。

很好奇你刚才做的这些有什么意义？看一下[教程2](http://honzadvorsky.com/articles/2015-08-06-xcs_tutorials_2_integrations)，在那篇文章中我们将详细讲解集成结果！
