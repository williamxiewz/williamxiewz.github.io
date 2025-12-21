title: Google Cardboard for iOS 虚拟现实开发
date: 2016-07-08 17:07:56
categories: Virtual Reality
tags: Cardboard for iOS
---

[原文链接](https://developers.google.com/vr/ios/get-started)

This document describes how to use the Google VR SDK for iOS (iOS SDK) to create your own Virtual Reality (VR) experiences.

You can use a VR viewer, such as Google Cardboard, to turn your smartphone into a VR platform. Your phone can display 3D scenes with binocular rendering, track and react to head movements, and interact with apps by activating the trigger input.

Note: The various manufacturers of smartphone VR viewers use different methods to simulate when a user taps the screen of their phone to interact with an app. These can include pulling a magnet and pressing a button. On some viewer models, the user actually does touch the screen of their phone so there is no simulation required. To keep things simple, on this page we'll refer to these methods collectively as "activating the trigger input."
The iOS SDK contains tools for spatial audio that go far beyond simple left side/right side audio cues to offer 360 degrees of sound. You can also control the tonal quality of the sound—for example, you can make a conversation in a small spaceship sound drastically different than one in a large, underground (and still virtual) cave.

The demo app used in this tutorial, "Treasure Hunt," is a basic game, but it demonstrates the core features of the Google VR SDK. In the game, users look around a virtual world to find and collect objects. It demonstrates some basic features, such as lighting, movement in space, and coloring. It shows how to set up the trigger input, detect if the user is looking at something, set up spatial audio, and render images by providing a different view for each eye.
<!-- more -->
这个 Cardboard SDK 可以让你很方便的控制音频的空间感（例如左右声道），也可以控制响度，所以你可以让一段对话在一个小飞船中或者一个很大的地下洞穴中表现得很不一样。

在这个示例程序中我们完成了一个寻宝游戏，他演示了 Cardboard 的核心功能。玩家将会在一个虚拟的世界中寻找宝物。你将会学习如何使用光照、空间运动和着色等基本功能如果玩家看见了他要找的东西，将会触发空间音效和视差效果。




#基本要求

为了能够运行这个示例程序，你至少需要满足以下条件：

- Xcode 7.1 或更高版本
- CocoaPods,访问 [CocoaPods](https://cocoapods.org/) 来安装。
- 一部运行 iOS 7.0 或更高版本的 iPhone。
 

#下载并构建 app

1.首先将项目 clone 到本地：

	git clone https://github.com/googlesamples/cardboard-ios.git

2.在你的命令行中，进入到 CardboardSamples 里的 TreasureHunt 文件夹然后执行：

	pod update

这将会安装项目所有的依赖。


因为你懂的原因出现下面的情况:
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard1-1.png)

但是我又有强迫症,所以使用这么的方式让Terminal也能在翻墙(本人使用Surge Mac 版)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard1-2.png)
下载速度:
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard1-3.png)
结果如下:
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard1-4.png)
3.现在你应该能看见 TreasureHunt.xcworkspace 文件了，用 Xcode 运行起来应该像这个样子：在 Xcode 上运行 TreasureHunt
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard1.png)

#开始游戏

现在戴上你的耳机，来在这个虚拟现实的空间里搜寻宝物吧！

##寻找宝物

1.四处移动你的方向，直到宝物进入你的视野：宝物已经在视野中显示了

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard2.png)
2.直视这个宝物，他将会变成橘色：直视宝物的时候它变成橘色了

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopgooglecardboard3.png)

3.激活开关就可以收集宝物（根据 Cradboard 的不同，可能是拨动物理按钮也可能是触碰屏幕之类的)


#代码概览

这个寻宝游戏（TreasureHunt）通过 OpenGL 来为你的双眼呈现不同的讯息，他们是这样工作的：

- 一个 [UIViewController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/) 拥有一个 [GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html) 对象
- 一个渲染器遵循 [GCSCardboardViewDelegate](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html) 协议
- 通过 [CADisplayLink](https://developer.apple.com/library/prerelease/ios/documentation/QuartzCore/Reference/CADisplayLink_ClassRef/index.html) 对象添加一个渲染循环
- 捕获输入



##让UIViewController拥有一个 GCSCardboardView

这个寻宝游戏定义了一个 [UIViewController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/)，也就是 TreasureHuntViewController，他拥有一个 [GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html)，并且有一个遵循 [GCSCardboardViewDelegate](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html) 协议的 TreasureHuntRenderer 的实例来成为 GCSCardboardView 的代理。 此外，这个应用有一个渲染循环，TreasureHuntRenderLoop 这个类，他有一个 [-render](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html#method-detail) 方法来GCSCardboardView。

```objc
- (void)loadView {
  _treasureHuntRenderer = [[TreasureHuntRenderer alloc] init];
  _treasureHuntRenderer.delegate = self;

  _cardboardView = [[GVRCardboardView alloc] initWithFrame:CGRectZero];
  _cardboardView.delegate = _treasureHuntRenderer;
  ...
  _cardboardView.vrModeEnabled = YES;
  ...
  self.view = _cardboardView;
}
```

##定义一个遵循GCSCardboardViewDelegate协议的渲染器

[GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html) 将会用于向你展示内容，他通过 [GCSCardboardViewDelegate](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html) 协议来完成这些工作，所以 TreasureHuntRenderer 将会遵循 GCSCardboardViewDelegate协议：

```objc
#import "GVRCardboardView.h"

/** TreasureHunt renderer. */
@interface TreasureHuntRenderer : NSObject<GVRCardboardViewDelegate>

@end
```

##声明 GCSCardboardViewDelegate 协议中的内容

为了在 [GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html) 显示内容，TreasureHuntRenderer 需要遵循 [GCSCardboardViewDelegate](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html) 的这些协议：

```objc
@protocol GCSCardboardViewDelegate<NSObject>
 
- (void)cardboardView:(GCSCardboardView *)cardboardView
         didFireEvent:(GCSUserEvent)event;
 
- (void)cardboardView:(GCSCardboardView *)cardboardView
     willStartDrawing:(GCSHeadTransform *)headTransform;
 
- (void)cardboardView:(GCSCardboardView *)cardboardView
     prepareDrawFrame:(GCSHeadTransform *)headTransform;
 
- (void)cardboardView:(GCSCardboardView *)cardboardView
              drawEye:(GCSEye)eye
    withHeadTransform:(GCSHeadTransform *)headTransform;
 
- (void)cardboardView:(GCSCardboardView *)cardboardView
   shouldPauseDrawing:(BOOL)pause;
 
@end
```

接下来我们将实现 `willStartDrawing`，`prepareDrawFrame`，和 `drawEye` 方法。

##实现 willStartDrawing 方法

要执行 GL(Graphics Library) 一次性初始化，实现 [-cardboardView:willStartDrawing:](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html#method-detail) 方法，并在其中来加载着色器初始化集合场景并添加到 GL 的参数中，并且还初始化了一个 [GCSCardboardAudioEngine](https://developers.google.com/vr/ios/reference/interface_g_v_r_audio_engine) 实例：



```objc
- (void)cardboardView:(GVRCardboardView *)cardboardView
     willStartDrawing:(GVRHeadTransform *)headTransform {
  // Load shaders and bind GL attributes.
  // Load mesh and model geometry.
  // Initialize GVRCardboardAudio engine.
  _cardboard_audio_engine =
  [[GVRCardboardAudioEngine alloc]initWithRenderingMode:
      kRenderingModeBinauralHighQuality];
  [_cardboard_audio_engine preloadSoundFile:kSampleFilename];
  [_cardboard_audio_engine start];
  ...
  [self spawnCube];
}
```

##实现 prepareDrawFrame 方法

通过实现 [-cardboardView:prepareDrawFrame:](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html#method-detail) 方法，将可以决定将要呈现在人眼前内容的逻辑。任何对于特定帧内容的操作应该在这里实现，在这里更新模型并清除 GL 绘制状态等。应用将会计算头部的方向并更新音频引擎。

```objc
- (void)cardboardView:(GVRCardboardView *)cardboardView
     willStartDrawing:(GVRHeadTransform *)headTransform {
  // Load shaders and bind GL attributes.
  // Load mesh and model geometry.
  // Initialize GVRCardboardAudio engine.
  _cardboard_audio_engine =
  [[GVRCardboardAudioEngine alloc]initWithRenderingMode:
      kRenderingModeBinauralHighQuality];
  [_cardboard_audio_engine preloadSoundFile:kSampleFilename];
  [_cardboard_audio_engine start];
  ...
  [self spawnCube];
}

```

##实现 drawEye 方法

这里将会是整个渲染代码的核心，就像你建立一个常规的 OpenGL ES 应用一样。下面这段代码将为你展示如何在 [-drawEye](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html#method-detail) 方法中为 每个 眼球呈现场景的变换和透视效果。注意，这个方法会为每一个眼球调用，如果 GCSCardboardView 没有启用 VR 模式，那么眼球将会被设置为最中间。这种单眼渲染模式也是有用的，他能在非 VR 视图下也展现 3D 场景。



```objc

- (void)cardboardView:(GVRCardboardView *)cardboardView
              drawEye:(GVREye)eye
    withHeadTransform:(GVRHeadTransform *)headTransform {
  // Set the viewport.
  CGRect viewport = [headTransform viewportForEye:eye];
  glViewport(viewport.origin.x, viewport.origin.y, viewport.size.width,
      viewport.size.height);
  glScissor(viewport.origin.x, viewport.origin.y, viewport.size.width,
      viewport.size.height);

  // Get the head matrix.
  const GLKMatrix4 head_from_start_matrix =
      [headTransform headPoseInStartSpace];

  // Get this eye's matrices.
  GLKMatrix4 projection_matrix = [headTransform
      projectionMatrixForEye:eye near:0.1f far:100.0f];
  GLKMatrix4 eye_from_head_matrix =
      headTransform eyeFromHeadMatrix:eye];

  // Compute the model view projection matrix.
  GLKMatrix4 model_view_projection_matrix =
      GLKMatrix4Multiply(projection_matrix,
      GLKMatrix4Multiply(eye_from_head_matrix, head_from_start_matrix));

  // Render from this eye.
  [self renderWithModelViewProjectionMatrix:model_view_projection_matrix.m];
}

```
返回这个方法的调用以后，[GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html) 会将它渲染到屏幕上。

##用 CADisplayLink 添加渲染循环

为了渲染内容，我们需要[CADisplayLink](https://developer.apple.com/library/prerelease/ios/documentation/QuartzCore/Reference/CADisplayLink_ClassRef/index.html) 来驱动一个渲染循环。 在这个寻宝游戏中，我们用到了 TreasureHuntRenderLoop 来实现这个渲染循环。 这需要调用 [GCSCardboardView](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html) 中的 [-render](https://developers.google.com/vr/ios/reference/interface_g_v_r_cardboard_view.html#method-detail) 方法。 我们在 TreasureHuntViewController 的 [- viewWillAppear:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instm/UIViewController/viewWillAppear:) and -viewDidDisappear: 方法中生成它并且在 [-viewDidDisappear:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instm/UIViewController/viewDidDisappear:) 方法中销毁它。


```objc
- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  _renderLoop = [[TreasureHuntRenderLoop alloc]
   initWithRenderTarget:_cardboardView selector:@selector(render)];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];

  [_renderLoop invalidate];
  _renderLoop = nil;
}
```
##捕获输入

Cradboard SDK 可以接受到输入的事件（通常是拨动 Cardboard 上的按钮），你要在用户触发这个按钮的时候做一些事情，只需要实现 [- cardboardView:didFireEvent](https://developers.google.com/vr/ios/reference/protocol_g_v_r_cardboard_view_delegate-p.html#method-detail) 代理方法。

```objc
- (void)cardboardView:(GVRCardboardView *)cardboardView
         didFireEvent:(GVRUserEvent)event {
  switch (event) {
    case kGVRUserEventBackButton:
    // If the view controller is in a navigation stack or
    // over another view controller, pop or dismiss the
    // view controller here.
    break;
    case kGVRUserEventTrigger:
     NSLog(@"User performed trigger action");
     // Check whether the object is found.
     if (_is_cube_focused) {
       // Vibrate the device on success.
       AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
       // Generate the next cube.
       [self spawnCube];
     }
     break;
  }
}

```