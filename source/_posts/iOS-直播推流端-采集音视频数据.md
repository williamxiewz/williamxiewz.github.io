---
title: 'iOS 直播推流端:采集音视频数据'
date: 2016-09-08 17:40:42
categories:  音视频开发
tags:    [AVCaptureSession,AVFoundation,直播推流]
---




OS上使用AVFoundation.framework框架来调用系统相机并获取视频数据。视频数据可以根据设定的参数，可采集到RGB或YUV数据，一般使用的是GBRA32，420v，420f，下面演示相机的调用和视频数据的获取。
a)引入框架的头文件#import <AVFoundation/AVFoundation.h>
b)调用的类遵守协议AVCaptureVideoDataOutputSampleBufferDelegate
c)声明变量
AVCaptureSession            *captureSession;
AVCaptureDevice             *captureDevice;
AVCaptureDeviceInput        *captureDeviceInput;
AVCaptureVideoDataOutput    *captureVdieoDataOutput;
d)实现
e)demo地址 https://github.com/depthlove/STMCamera



AVFoundation 是 iOS系统上可以捕捉iPhone／iPad／iPod摄像头的一个库，这个库采集输出的是YUV/RGB。跟编码h264没有关系，AVFoundation只是作为一个视频输入源而已，要将它的数据采用编码器编码才能得到h264 数据。具体可参看我的博文《利用FFmpeg+x264将iOS摄像头实时视频流编码为h264文件》http://depthlove.github.io/2015/09/18/use-ffmpeg-and-x264-encode-iOS-camera-video-to-h264/ ， 《利用x264将iOS摄像头实时视频流编码为h264文件》http://depthlove.github.io/2015/09/17/use-x264-encode-iOS-camera-video-to-h264/ ， 《在iOS上硬编码推流－硬编码h264（四）》http://depthlove.github.io/2016/03/20/hw-encode-and-transfer-in-ios-platform-videotoolbox-encode-h264-part4/



AVFoundation: 音视频数据采集需要用AVFoundation框架.

`AVCaptureDevice`：硬件设备，包括麦克风、摄像头，通过该对象可以设置物理设备的一些属性（例如相机聚焦、白平衡等）

`AVCaptureDeviceInput`：硬件输入对象，可以根据AVCaptureDevice创建对应的AVCaptureDeviceInput对象，用于管理硬件输入数据。

`AVCaptureOutput`：硬件输出对象，用于接收各类输出数据，通常使用对应的子类AVCaptureAudioDataOutput（声音数据输出对象）、AVCaptureVideoDataOutput（视频数据输出对象）

`AVCaptionConnection`:当把一个输入和输出添加到AVCaptureSession之后，AVCaptureSession就会在输入、输出设备之间建立连接,而且通过AVCaptureOutput可以获取这个连接对象。

`AVCaptureVideoPreviewLayer`:相机拍摄预览图层，能实时查看拍照或视频录制效果，创建该对象需要指定对应的AVCaptureSession对象，因为AVCaptureSession包含视频输入数据，有视频数据才能展示。

AVCaptureSession: 协调输入与输出之间传输数据

系统作用：可以操作硬件设备
工作原理：让App与系统之间产生一个捕获会话，相当于App与硬件设备有联系了， 我们只需要把硬件输入对象和输出对象添加到会话中，会话就会自动把硬件输入对象和输出产生连接，这样硬件输入与输出设备就能传输音视频数据。

现实生活场景：租客（输入钱），中介（会话），房东（输出房），租客和房东都在中介登记，中介就会让租客与房东之间产生联系，以后租客就能直接和房东联系了。

捕获音视频步骤:官方文档

1.创建AVCaptureSession对象

2.获取AVCaptureDevicel录像设备（摄像头），录音设备（麦克风），注意不具备输入数据功能,只是用来调节硬件设备的配置。

3.根据音频/视频硬件设备(AVCaptureDevice)创建音频/视频硬件输入数据对象(AVCaptureDeviceInput)，专门管理数据输入。

4.创建视频输出数据管理对象（AVCaptureVideoDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的视频数据

5.创建音频输出数据管理对象（AVCaptureAudioDataOutput），并且设置样品缓存代理(setSampleBufferDelegate)就可以通过它拿到采集到的音频数据

6.将数据输入对象AVCaptureDeviceInput、数据输出对象AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中,就会自动让音频输入与输出和视频输入与输出产生连接.

7.创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器layer中

8.启动AVCaptureSession，只有开启，才会开始输入到输出数据流传输。

```objc




```


```swift


```
