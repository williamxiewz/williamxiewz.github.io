title: awakeFromNib 整理摘录
date: 2017-10-24 16:18:48
categories: [iOS SDK]
tags:
---

（1）awakeFromNib和initWithCoder:差别
awakeFromNib 从xib或者storyboard加载完毕就会调用
initWithCoder: 只要对象是从文件解析来的，就会调用
同时存在会先调用initWithCoder:

（2）initWithCoder: & initWithFrame:
initWithCoder：使用文件加载的对象调用（如从xib或stroyboard中创建）
initWithFrame：使用代码加载的对象调用（使用纯代码创建）
注意：所以为了同时兼顾从文件和从代码解析的对象初始化，要同时在initWithCoder: 和 initWithFrame: 中进行初始化

nib 加载结构时 发送一个awakeFromNib消息告诉每个对象重建一个nib 归档，但只有在所有的档案中的对象已加载和初始化。当一个对象接收awakefromnibmessage，这是保证其所有出口和行动连接已经建立。

你必须调用awakefromnib super实施给父类的运行的机会去做额外的初始化工作。虽然这种方法的默认实现不执行任何操作，许多UIKit类提供非空的实现。你可以叫super 实现在任何一点你自己的awakefromnib方法里。

实例化过程中，存档中的每个对象未归档然后初始化的方法适合于它的类型。符合nscoding协议对象（包括所有子类和处理）正在用他们的initwithcoder初始化：方法。不符合nscoding协议所有的对象都是使用init方法初始化。在所有对象被实例化和初始化，the nib 加载代码，将所有这些对象的出口和动作的连接。然后调用对象的awakefromnib方法。更详细的信息有关的步骤，然后nib在加载过程中，看到“NIB文件”在资源规划指南。

// 先归档方法
-(id)initWithCoder:(NSCoder *)aDecoder
{
self = [super initWithCoder:aDecoder];
if (self) {
}
return self;
}
// 保证出口和行动连接已经建立 调用 awakeFromNib
-(void)awakeFromNib
{
[super awakeFromNib];
}


NIB文件是应用程序所有对象的存档。当程序启动后，对象从文件中释放，重新赋予生命，准备接收用户触发的事件信息。这种机制有些与众不同：大多数GUI的设计都是为界面布局产生源代码；相反，Interface Builder则允许开发者编辑好页面元素的状态后，把它们保存在文件里面。在对象从文件中释放、获得生命，而没有接收到用户事件以前，所有的对象自动发送awakeFromNib消息。开发者可以添加awakeFromNib方法，用来初始化文本框的值。

parm mark 2

-(void)awakeFromNib;从字面上理解，就是从nib文件中唤醒对象，完成对每一个对象的实例化或与nib文件的关联。
谁唤醒这个方法？

awakeFromNib是由nib loading machinery发出的。[NSBundle loadNibFile:externalNameTable:withZone:],加载nib文件，完成初始化设置和连接，并且在所有关联的对象上唤醒awakeFromNib方法。

谁响应这个方法？

Cunstom Controller 和Cunstom Window都会响应awakeFromNib方法。当一个nib文件已经完成所有对象的加载之后，会对每一个与nib文件关联的对象loop back。此时，如果awakeFromNib方法中有需要响应的对象，它就会在该对象上唤起awakeFromNib方法。因此，我们可以在awakeFromNib方法中操作任何甚至所有的nib中的对象。

需要注意的问题：
当使用一个controller控制多个nib文件时，awakeFromNib方法会被多次调用。因此，当不使用awakeFromNib方法来完成nib对象的初始化时，需要注意此方法的多次调用对其他nib文件造成的影响。

