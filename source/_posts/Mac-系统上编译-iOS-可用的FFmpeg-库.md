title: Mac 系统上编译 iOS 可用的FFmpeg 库
date: 2016-08-24 15:32:07
categories:  
tags:   [FFmpeg]
---

[原文转载](http://www.jianshu.com/p/ec432a8f5729)

1、[gas-preprocessor](https://github.com/libav/gas-preprocessor)
2、[yasm 1.2.0](https://github.com/yasm/yasm)
3、[FFmpeg-iOS-build-script](https://github.com/kewlbear/FFmpeg-iOS-build-script)（ps:这个脚本真是业界良心呀，帮我们省下了不少心。）

好了，已经有了，但是怎么优雅的使用出招式呢？慢慢来，博主力求详细的为大家分解每个步骤。

#1、下载[gas-preprocessor](https://github.com/libav/gas-preprocessor)

那么 gas-preprocessor 是什么呢？

	gas-preprocessor 其实就是我们要编译 FFmpeg 的所需脚本文件。

1）我们将其解压后，发现内部只有简单的 4 个文件，如下图：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg1.png)

不难发现其中的 `gas-preprocessor.pl`，没错，这就是我们要找的刀了，恭喜，你获取了小木剑一把，继续往坑里走少年。

2）继续将 `gas-preprocessor.pl` 文件复制到 /usr/sbin/ 目录下（ps：应该会有很多小伙伴发现这个目录是根本没法修改的，那么这种情况下，小伙伴们可以将文件复制到 /usr/local/bin/ 目录下），然后为文件开启可执行权限，打开终端并输入以下命令行：

	chmod 777 /usr/sbin/gas-preprocessor.pl
或

	chmod 777 /usr/local/bin/gas-preprocessor.pl

#2、安装 yasm
yasm 又是什么呢？

>Yasm是一个完全重写的 NASM 汇编。目前，它支持x86和AMD64指令集，接受NASM和气体汇编语法，产出二进制，ELF32 ， ELF64 ， COFF ， Mach - O的（ 32和64 ），RDOFF2 ，的Win32和Win64对象的格式,并生成STABS 调试信息的来源，DWARF 2 ，CodeView 8格式。

1）下载yasm
上一篇文章博文带大家下载了一个好东西 homebrew，既然是优雅的编译，我们就用最像程序员的东西，命令行了，打开终端，输入如下：

	brew install yasm

2）检测是否已安装 yasm

	brew install yasm

如果你成功安装了 yasm，输出如下图：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg2.png)

好了，你获得了隔壁老王内裤一条。额。。让我们继续前进。

#3、编译FFmpeg-iOS-build-script

编译FFmpeg-iOS-build-script,得到我们需要的iOS能用的ffmpeg库

这个脚本有神马用呢？

不难看出，这个脚本是转为 iOS 编译出可用的 ffmpeg 的库，这个业界良心，我们称之为`神的内裤`

好吧，不搞笑，有了这个脚本，我们根本就不用下载 ffmpeg 了，脚本会帮我们下载好最新版本的 ffmpeg，

并打包成一个 iOS 可用的 ffmpeg 库提供给我们了，当然，前提是你必须要跟着博主一步一步入坑才行喔。

1）进入我们的 gitHub 网站，把 [FFmpeg-iOS-build-script](https://github.com/kewlbear/FFmpeg-iOS-build-script) 下载好压缩包。

2）编译脚本，打包出我们需要的 iOS 的 ffmpeg 库
解压 [FFmpeg-iOS-build-script](https://github.com/kewlbear/FFmpeg-iOS-build-script) 得到的文件如下：


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg3.png)

我们目标不是开发 tvos 吧。。那么我们的目标脚本就只剩下 build-ffmpeg.sh 了。打开终端，进入解压后的 FFmpeg-iOS-build-script 文件夹，命令行如下：

	cd 小伙伴们的FFmpeg-iOS-build-script文件夹路径

执行 build-ffmpeg.sh 脚本：

	./build-ffmpeg.sh

当然，官方是有说明的：
To build everything:

	./build-ffmpeg.sh
To build arm64 libraries:

	./build-ffmpeg.sh arm64
To build fat libraries for armv7 and x86_64 (64-bit simulator):

	./build-ffmpeg.sh armv7 x86_64
To build fat libraries from separately built thin libraries:

	./build-ffmpeg.sh lipo
好了，执行完命令行后，终端就会拿着这条内裤，在啪啪啪了（编译）。。。这段时间里，你可以去喝杯咖啡慢慢等待，最后得到的文件如下：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg4.png)

小伙伴们不难看到，FFmpeg-iOS 就是我们所需要的文件夹了，看到内部的各种 .a 文件，也就是我们熟悉的静态库了。

4、集成FFmpeg 库开发工程当中

1）把 FFmpeg-iOS 直接复制到你的工程目录下

2）把 FFmpeg-iOS 从你的工程目录下拖到工程当中，最后得到的结果如下图：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg5.png)

3）编译一下，你会发下有错误，哈哈，原因是你没有链接编译文件
好，我们进入 Build Setting ，修改 header search Path 链接到工程的 include 文件当中 操作如下：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopffmpeg6.png)


OK，我们可以在工程当中引入 #import "avformat.h" 文件了，编译 Success



好了，至此，我们已经成功编译并集成了 ffmpeg 了，但是怎么使用呢？怎么压缩视频，视频压缩视频？
怎么实现 h264 编码？怎么将视频/音频推送到流媒体服务器呢？这些都是我们将要说的。
