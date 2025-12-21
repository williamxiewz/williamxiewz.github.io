---
title: HomeKit 开发指南
date: 2016-08-10 13:08:12
categories: 智能家居
tags: HomeKit
---
#第一部分：简介

该文档旨在帮你编写HomeKit app。HomeKit库是用来沟通和控制家庭自动化配件的，这些家庭自动化配件都支持苹果的HomeKit Accessory Protocol。HomeKit应用程序可让

用户发现兼容配件并配置它们。用户可以创建一些action来控制智能配件（例如恒温或者光线强弱），对其进行分组，并且可以通过Siri触发。HomeKit 对象被存储在用户iOS设备的数据库中，并且通过iCloud还可以同步到其他iOS设备。HomeKit支持远程访问智能配件，并支持多个用户设备和多个用户。HomeKit 还对用户的安全和隐私做了处理。


![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/into_diagram_2x.png)
<!-- more -->

>注意：如果你是开发设计[HomeKit](https://developer.apple.com/homekit)硬件的供应商，你可以去Hardware Developers下的HomeKit页面了解MFi Program相关信息，也可以阅读 [External Accessory Programming Topics](https://developer.apple.com/library/ios/featuredarticles/ExternalAccessoryPT/Introduction/Introduction.html#//apple_ref/doc/uid/TP40009502)

另请参阅

以下资源提供了更多关于创建HomeKit应用程序的信息：
[HomeKit User Interface Guidelines](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/HomeKit.html#//apple_ref/doc/uid/TP40006556-CH70) 提供了用户界面设计指南
[App Store Review Guidelines: HomeKit](https://developer.apple.com/app-store/review/guidelines/#homekit) 提供了加快app审核的技巧
[HomeKit Framework Reference](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HomeKit_Framework/index.html#//apple_ref/doc/uid/TP40014519) 描述了HomeKit框架中的类和方法
[External Accessory Framework Reference](https://developer.apple.com/library/ios/documentation/ExternalAccessory/Reference/ExternalAccessoryFrameworkReference/index.html#//apple_ref/doc/uid/TP40008235) 列出了系统提供的发现和配置无线智能家居产品UI
[HomeKit Catalog](https://developer.apple.com/library/ios/samplecode/HomeKitCatalog/Introduction/Intro.html#//apple_ref/doc/uid/TP40015048) 提供示例演示HomeKit特性
[WWDC 2014: Introducing HomeKit](https://developer.apple.com/videos/play/wwdc2014/213/) 对HomeKit更高层次的分析
[iOS Security](https://www.apple.com/business/docs/iOS_Security_Guide_Oct_2014.pdf) 描述HomeKit如何处理iOS上的安全和隐私
<!--more-->
#第二部分：启用HomeKit

HomeKit应用服务只提供给通过App Store发布的app应用程序。在你的Xcode工程中， HomeKit应用程序需要额外的配置，你的app必须有开发证书和代码签名才能使用HomeKit。在Xcode的Capabilities面板使用HomeKit，可避免代码签名的问题。你无需直接在Xcode或者会员中心编辑授权文件（entitlements）。

##设置

为了完成本文档中所有步骤，你需要：
	
>1.一个安装Xcode 6 或者Xcode 6 以上版本的Mac电脑。
 2.为了获得最佳体验，你的Mac电脑上最好安装最新的OS X 系统和最新的Xcode 版本。
 3.加iOS开发者计划。
 4.在Member Center 拥有创建代码签名和资源配置的权限。

在你开始使用HomeKit之前，请确保你已经完成以下任务。创建你团队的配置文件（Provisioning Profile），请参阅：[App Distribution Quick Start](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/Introduction/Introduction.html#//apple_ref/doc/uid/TP40013839).
 
![](http://cc.cocimg.com/api/uploads/20150324/1427185340565965.png)

当你成功地完成了之前的任务后，General面板中Team弹出菜单中的错误信息和问题修复按钮将会消失。代码签名配置被成功创建后会展示下方的General面板。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/2_create_teamprofile_2x.png)

解决代码签名和证书配置问题，请参阅 [App Distribution Guide](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40012582)文档中[Troubleshooting](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/Troubleshooting/Troubleshooting.html#//apple_ref/doc/uid/TP40012582-CH5)这一节。


##启用HomeKit

想要使用HomeKit，首先要启用它。Xcode将会添加HomeKit权限到你的工程授权文件中和会员中心的App ID授权文件中，也会将HomeKit框架添加到你的工程中。HomeKit 需要一个明确的App ID, 这个App ID是为了你完成这些步奏而创建的。

启用HomeKit的步骤如下：

>1.在Xcode中，选择View > Navigators > Show Project Navigator。
 2.从Project/Targets弹出菜单中target（或者从Project/Targets的侧边栏）
 3.点击Capabilities查看你可以添加的应用服务列表。
 4.滑到HomeKit 所在的行并打开关。
 
##下载HomeKit Accessory Simulator

无需为了开发Homekit 应用程序而购买硬件产品。你可以使HomeKit Accessory Simulator来测试HomeKit app和模拟配件设备之间的通信。HomeKit Accessory Simulator不是和Xcode一起发布的。 

下载HomeKit Accessory Simulator步骤如下：

>1.在Capabilities面板的HomeKit分区，点击Download HomeKit Accessory Simulator按钮。（或者选择Xcode > Open Developer Tool > More Developer Tools）
 2.在浏览器中搜索并且下载"Hardware IO Tools for Xcode ".dmg文件。
 3.在 Finder中双击~/Downloads中的.dmg文件。
 4.把HomeKit Accessory Simulator拖拽到/Application文件中。

之后，你将可以使用HomeKit Accessory Simulator测试你的HomeKit应用程序，正如[Testing YourHomeKit App](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW1)中描述的那样。

#第三部分：创建Home布局

HomeKit 允许用户创建一个或者多个Home布局。每个Home（[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)）代表一个有网络设备的住所。用户拥有Home的数据并可通过自己的任何一台iOS设备进行访问。用户也可以和客户共享一个Home，但是客户的权限会有更多限制。被指定为primary home的home默认是Siri指令的对象，并且不能指定home。

每个Home一般有多个room，并且每个room一般会有多个智能配件。在home([HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMRoom_Class/index.html#//apple_ref/occ/cl/HMRoom)) 中，每个房间是独立的room，并具有一个有意义的名字，例如“卧室”或者“厨房”，这些名字可以在Siri 命令中使用。一个accessory（[HMAccessory](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/cl/HMAccessory)）代表实际家庭中的自动化设备，例如车库开门器。一个sevice（[HMService](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/cl/HMService)）是accessory提供的?种实际服务，例如打开或者关闭车库，或者车库上的灯。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/homes_2x.png)

如果你的app 缓存了home布局的信息，那么当其布局发声改变的时候，app就需要更新这些信息。使用[HMHomeManager](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/cl/HMHomeManager)对象可以从HomeKit数据库获取[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)和其他相关的对象。本章描述的API获取对象后，你应该通过代理回调函数保持获取对象和HomeKit数据库同步，具体描述请参看“[Observing HomeKit Database Changes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)".

##创建 Home Manager对象
使用Home Manager—一个[HMHomeManager](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/cl/HMHomeManager)对象的访问home、room、配件、服务以及其他HomeKit对象。在创建家庭对象管理器（home manager）之后，直接设置它的代理，以便获取到这些对象之后及时的通知到你。


	self.homeManager = [[HMHomeManager alloc] init];
	self.homeManager.delegate = self;

当你创建一个home manager对象时，HomeKit就开始从HomeKit数据库获取这些homes和相关对象，例如room和accessory对象。当HomeKit正在获取那些对象时，home manager 的[primaryHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/primaryHome)属性是nil，并且[homes](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/homes)属性是个空数组。你的app应该处理用户还没有完成创建home的情况，但是app应该等待直到HomeKit完成初始化。当获取对象完成之后，HomeKit 会发送[homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:)消息给home manager的代理。

>注意：当app进入前台或者在后台Home manager属性发生改变时，这个[homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:)方法就会被调用，详情请参阅“[Observing Changes to the Collection of Homes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW3)”。

##获取Primary Home和 Homes集合
通过home manager的[primaryHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/primaryHome)属性，可以得到primary home，代码如下：

	HMHome *home = self.homeManager.primaryHome;

使用home manager的[homes](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/homes)属性可以得到用户的所有home的集合；例如自家主要居所、度假别墅以及办公室。每个home都对应一个独立的home对象。


	HMHome *home;
 	for(home in self.homeManager.homes ){
	 ...
	}

##获取 Home中的所有room
在一个home中，rooms属性定义accessories的物理位置。用home的[rooms](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instp/HMHome/rooms)属性可以枚举home中的所room。


	HMHome *home = self.homeManager.primaryHome;
 	HMRome *room;
 	for(room in home.rooms){
 		...
 	}

##获取Room 中的Accessories
Accessories 数组属于home，但是被指定给了home中的room。假如用户没有给一个accessory指定room，那么这个accessories被指定一个默认的room ,这个room是[roomForEntireHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/roomForEntireHome)方法的返回值。用room的[accessories](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMRoom_Class/index.html#//apple_ref/occ/instp/HMRoom/accessories)属性可以枚举room中所有的accessory。代码如下：


	HMAccessory *accessory;
 	for(accessory in room.accessories){
 	…
 	}

如果你要展示一个个accessory的相关信息或者允许用户控制它，可设置accessory的代理方法并实现这个代理方法，详情请见“[Observing Changes to Accessories](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW1)”.
一旦你获取到一个accessory对象，你就可以访问它的服务和对象，详情请参阅“[Accessing Services and Characteristics](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)”。

##获取Home中的Accessories属性
使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类中的[accessories](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instp/HMHome/accessories)的方法，可以直接从Home对象中获取所有的accessory对象，而不用枚举home中的所有room对象（详情请见“[Getting the Accessories in a Room](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW5)”)。

#第四部分：创建Homes和添加Accessories

HomeKit对象被保存在一个可以共享的HomeKit数据库里，它可以通过HomeKit框架被多个应英程序访问。所有HomeKit调用的方法都是异步写入的，并且这些方法都包含一个完成处理后的参数。如果这个方法处理成功了，你的应用将会在完成处理函数里更新本地对象。应用程序启动时，HomeKit对象发生改变的并不能收到代理回调?法，只能接受处理完成后的回调函数。

想要观察其他应用程序启动时HomeKit对象的变化，请参阅：[Observing HomeKit Database Changes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)。查阅异步消息完成处理后传过来的错误码的信息，请参阅：[HomeKit Constants Reference](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HomeKit_Constants/index.html#//apple_ref/doc/uid/TP40014524).

##对象命名规则

HomeKit对象的名字，例如home、room和zone对象都可以被Siri识别，这一点已经在文档中指出。以下几点是HomeKit对象的命名规则：

>1.对象名字在其命名空间内必须是唯一的。
2.属于用户所有的home名字都在一个命名空间内。
3.一个home对象及其所包含的对象在另一个命名空间内。
4.名字只能包含数字、字母、空格以及省略号字符。
5.名字必须以数字或者字母字符开始。
6.在名字比较的时候,空格或者省略号是忽略的（例如home1和home 1 同一个名字）。
7.名字没有大小写之分。

想了用户可以使用哪些语言与Siri进行交互，请参阅[HomeKit User Interface Guidelines](https://developer.apple.com/homekit/ui-guidelines/)文档中的"Siri Integration"

##创建Homes

在[HMHomeManager](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/cl/HMHomeManager)类中使用[addHomeWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instm/HMHomeManager/addHomeWithName:completionHandler:)异步方法可以添加一个home。作为参数传到那个方法中的home的名字，必须是唯一独特的，并且是Siri可以识别的home名字。


	[self.homeManager addHomeWithName:@"My Home" completionHandler:^(HMHome *home, NSError *error) {
		if (error != nil) {
			// Failed to add a home
		} else {
			// Successfully added a home
		} 
	}];

在else语句中，写入代码以更新你应的程序的视图。为了获取home manager对象，请参阅[Getting the Home Manager Object](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW2).

##在Home中增加一个Room

使用[addRoomWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addRoomWithName:completionHandler:)异步方法可以在一个home中添加一个room对象。作为参数传到那个方法中的room的名字，必须是唯一独特的，并且是Siri可识别的room名字。


	NSString *roomName = @"Living Room";
	[home addRoomWithName:roomName completionHandler:^(HMRoom *room, NSError *error) {
		if (error != nil) {
			// Failed to add a room to a home
		} else {
			// Successfully added a room to a home
		} 
	}];

在else语句中，写入代码更新应用程序的视图。

##发现配件

Accessories封装了物理配件的状态，因此它不能被用户创建。想要允许用户给家添加新的配件，我们可以使[HMAccessoryBrowser](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowser_Class/index.html#//apple_ref/occ/cl/HMAccessoryBrowser)对象找到一个与home没有关联的配件。[HMAccessoryBrower](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowser_Class/index.html#//apple_ref/occ/cl/HMAccessoryBrowser)对象在后台搜寻配件，当它找到配件的时候，使用委托来通知你的应用程序。只有在[startSearchingForNewAccessories](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowser_Class/index.html#//apple_ref/occ/instm/HMAccessoryBrowser/startSearchingForNewAccessories)方法调用之后或者[stopSearchingForNewAccessories](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowser_Class/index.html#//apple_ref/occ/instm/HMAccessoryBrowser/stopSearchingForNewAccessories)方法调用之前，[HMAccessoryBrowserDelegate](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowserDelegate_Protocol/index.html#//apple_ref/occ/intf/HMAccessoryBrowserDelegate)消息才被发送给代理对象。

发现home中的配件
1.在你的类接口中添加配件浏览器委托协议，并且添加一个配件浏览器属性。代码如下：

	@interface EditHomeViewController ()<HMAccessoryBrowserDelegate>
	@property HMAccessoryBrowser *accessoryBrowser;
	@end

用你自己的类名代替EditHomeViewController

2.创建配件浏览器对象，并设置它的代理


	self.accessoryBrowser = [[HMAccessoryBrowser alloc] init];
	self.accessoryBrowser.delegate = self;

3.开始搜寻配件


	[ self.accessoryBrowser startSearchingForNewAccessories];

4.将找到的配件添加到你的收藏里

    - (void)accessoryBrowser:(HMAccessoryBrowser *)browser didFindNewAccessory:(HMAccessory *)accessory {
		// Update the UI per the new accessory; for example,reload a picker view.
		[self.accessoryPicker reloadAllComponents];
	}

用你自己的代码实现上面的[accessoryBrowser:didFindNewAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowserDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMAccessoryBrowserDelegate/accessoryBrowser:didFindNewAccessory:)方法。 当然也可以实现[accessoryBrowser:didRemoveNewAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryBrowserDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMAccessoryBrowserDelegate/accessoryBrowser:didRemoveNewAccessory:) 这个方法来移除配件，这个配件对你的视图或者收藏来说不再是新的。

5.停止搜寻配件

如果一个视图控制器正在开始搜寻配件，那么可以通过重写[viewWillDisappear:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/index.html#//apple_ref/occ/instm/UIViewController/viewWillDisappear:)方法来停止搜寻配件。代码如下：

    - (void)viewWillDisappear:(BOOL)animated {

		[self.accessoryBrowser stopSearchingForNewAccessories];
    }

>注意： 在WiFi网络环境下，为了安全地获取新的并且能够被HomeKit发现的无线配件，请参阅[External Accessory Framework Reference](https://developer.apple.com/library/ios/documentation/ExternalAccessory/Reference/ExternalAccessoryFrameworkReference/index.html#//apple_ref/doc/uid/TP40008235).

##为Home和room添加配件（Accessory）

配件归属于home，并且它可以被随意添加到home中的任意一个room中。使用[addAccessory:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addAccessory:completionHandler:)这个异步方法可以在home中添加配件。这个配件的名字作为一个参数传递到上述异步方法中，并且这个名字在配件所属的home中必须是唯一的。使用[assignAccessory:toRoom:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/assignAccessory:toRoom:completionHandler:) 这个异步方法可以给home中的room添加配件。配件默认的room是[roomForEntireHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/roomForEntireHome)这个方法返回值room。下面的代码演示了如何给home和room添加配件:


	// Add an accesory to a home and a room
	// 1. Get the home and room objects for the completion handlers.

	__block HMHome *home = self.home;
	__block HMRoom *room = roomInHome;

	// 2. Add the accessory to the home
	[ home addAccessory:accessory completionHandler:^(NSError *error) {
		if (error) {
			// Failed to add accessory to home
		} else {
			if (accessory.room != room) {
				// 3. If successfully, add the accessory to the room

				[home assignAccessory:accessory toRoom:room completionHandler:^(NSError *error) {
					if (error) {
							// Failed to add accessory to room
					} }];
			} }
	}];

配件可提供一项或者多项服务，这些服务的特性是由制造商定义。想了解配件的服务和特性目的，请参阅 [Accessing Services and Characteristics](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1).

##更改配件名称

使用[updateName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/instm/HMAccessory/updateName:completionHandler:) 异步方法可以改变配件的名称，代码如下：


	[accessory updateName:@"Kid's Night Light" completionHandler:^(NSError *error) {
		if (error) {
			// Failed to change the name
		} else {
			// Successfully changed the name
		}
	}];

##为Homes和Room添加Bridge（桥接口）

桥接口是配件中的一个特殊对象，它允许你和其他配件交流，但是不允许你直接和HomeKit交流。例如一个桥接口可以是控制多个灯的枢纽，它使用的是自己的通信协议，而不是HomeKit配件通信协议。想要给home添加多个桥接口 ，你可以按照[Adding Accessories to Homes and Rooms](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/WritingtotheHomeKitDatabase/WritingtotheHomeKitDatabase.html#//apple_ref/doc/uid/TP40015050-CH4-SW5)中所描述的步骤，添加任何类型的配件到home中。当你给home添加一个桥接口时，在桥接口底层的配件也会被添加到home中。正如[Observing HomeKit Database Changes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW2)中所描述的那样，每次更改通知设计模，home的代理不会接收到桥接口的[home:didAddAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddAccessory:) 代理消息，而是接收一个有关于配件的[home:didAddAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddAccessory:)代理消息。在home中，要把桥接口后的配件和任何类型的配件看成一样的--例如，把它们加入配件列表的配置表中。相反的是，当你给room增添一个桥接口时，这个桥接口底层的配件并不会自动地添加到room中，原因是桥接口和它的的配件可以位于到不同的room中。

##创建分区

分区 ([HMZone](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMZone_Class/index.html#//apple_ref/occ/cl/HMZone)) 是任意可选的房间（rooms）分组；例如楼上、楼下或者卧室。房间可以被添加到一个或者多个区域。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/zones_2x.png)

可使用[addZoneWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addZoneWithName:completionHandler:) 异步方法创建分区。所创建的作为参数传递到这个方法中分区的名称，在home中必须是唯一的，并且应该能被Siri识别。代码如下：


	__block HMHome *home = self.home;
	NSString *zoneName = @"Upstairs";
	[home addZoneWithName:zoneName completionHandler:^(HMZone *zone, NSError *error){
		if (error) {
			// Failed to create zone
		} else {
			// Successfully created zone, now add the rooms
		}
	}];

可使用[addRoom:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMZone_Class/index.html#//apple_ref/occ/instm/HMZone/addRoom:completionHandler:)异步方法给分区添加一个room，代码如下：

	__block HMRoom *room = roomInHome;
	[zone addRoom:room completionHandler:^(NSError *error) {
		if (error) {
			// Failed to add room to zone
		} else {
			// Successfully added room to zone
		} 
	}];

#第五部分：观察HomeKit数据库的变化

每个Home都有一个HomeKit数据库。如下图所示，HomeKit数据库会安全地和home授权的用户的iOS设备以及潜在的客人的iOS设备进行同步。为了给用户展示当前最新的数据，你的应用需要观察HomeKit数据库的变化。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/architecture_2x.png)

##HomeKit代理方法

HomKit使用代理设计模式（[delegation design pattern](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/Delegation.html#//apple_ref/doc/uid/TP40008195-CH14-SW2)）来通知应用程序HomeKit对象的改变。一般来讲，如果你的应用程序调用了一个带有完成处理参数的HomeKit方法，并且这个方法被成功调用了，那么相关联的代理消息就会被发送给其他HomeKit应用，无论这些应用是安装在同一台iOS设备上还是远程iOS设备上。这些应用甚至可以运行在客人的iOS设备上。如果你的应用发起了数据改变，但是代理消息并没有发送到你的应用，那么添加代码到完成处理方法和相关联的代理方法中来刷新数据和更新视图就成为必须了。如果home布局发生了显著变化，那么就重新加载关于这个home的所有信息。在完成程序处理的情况下，请在更新应用之前检查那个方法是否成功。Homkit也会调用代理方法来通知你的应用程序home网络状态的改变。

例如，下图演示了使用代理方法的过程：响应用户的操作，你的应用程序调用了[addRoomWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addRoomWithName:completionHandler:)方法，并且没有错误发生，完成处理程序应当更新home的所有视图。如果成功了，homeKit将会发送[home:didAddRoom:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddRoom:)消息给其他应用中homes的代理。因此，你实现的这个[home:didAddRoom:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddRoom:)方法也应该更新home的所有视图。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/changeflow_2x.png)

应用程序只有在前台运行的时候才能接受代理消息。当你的应用在后台时，HomeKit数据库的改变并不会成批处理。也就是说，如果你的应用在后台，当其他的应用成功地添加一个room到home中的时候，你的应用程序并不会接收到[home:didAddRoom:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddRoom:) 消息。当你的应用程序到前台运行时，你的应用程序将会接收到[homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:)消息，这个消息是表示你的应用程序要重新加载所有的数据。

##观察Homes集合的改变

设置home manager的代理并且实现[HMHomeManagerDelegate](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intf/HMHomeManagerDelegate)协议，当primary home或者home集合发生改变时，可以接收代理消息。

所有的应用都需要实现[homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:)方法，这个方法在完成最初获取homes之后被调用。对新建的home manager来说，在这个方法被调用之前，[primaryHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/primaryHome)属性的值是nil，[homes](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/homes)数组是空的数组。当应用程序开始在前台运行时也会调用 [homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:) 方法，当其在后台运行时数据发生改变。该[homeManagerDidUpdateHomes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManagerDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeManagerDelegate/homeManagerDidUpdateHomes:)方法会重新加载与homes相关联的所有数据。

观察homes的变化

1.在你的类接口中添加HMHomeManagerDelegate代理和homeManager属性。代码如下：

	@interface AppDelegate ()<HMHomeManagerDelegate>
	@property (strong, nonatomic) HMHomeManager *homeManager;
	@end

2.创建home manager对象并设置其代理

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    	self.homeManager = [[HMHomeManager alloc] init];
		self.homeManager.delegate = self;
		return YES;
	}

3.实现homes发生改变时调用的代理方法。例如：如果多个视图控制器展示了homes相关信息，你可以发布一个更改通知去更新所有视图。

    - (void)homeManagerDidUpdateHomes:(HMHomeManager *)manager {
		// Send a notification to the other objects
		[[NSNotificationCenter defaultCenter]
		postNotificationName:@"UpdateHomesNotification" object:self];
	}
    - (void)homeManagerDidUpdatePrimaryHome:(HMHomeManager *)manager {
		// Send a notification to the other objects
		[[NSNotificationCenter defaultCenter]
		postNotificationName:@"UpdatePrimaryHomeNotification" object:self];
	}

视图控制器注册更改通知并且执行适当的操作。

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHomes:) name:@"UpdateHomesNotification" object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePrimaryHome:) name:@"UpdatePrimaryHomeNotification" object:nil];

##观察个别home的变化

展示home信息的视图控制器应该成为home对象的代理，并且当home发生改变时更新视图控制器的视图。

观察特定home对象的改变

1.在类接口中添加home代理协议。

	@interface HomeViewController ()<HMHomeDelegate>

	@end
2.设置配件代理

	home.delegate = self;

3.实现[HMHomeDelegate](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intf/HMHomeDelegate)协议

例如：实现[home:didAddAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddAccessory:)和[home:didRemoveAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didRemoveAccessory:) 方法来更新展示配件的视图。用[HMAccessory](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/cl/HMAccessory)类的[room](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/instp/HMAccessory/room)属性可以获得配件所属的room。（对配件来说，默认的room是[roomForEntireHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/roomForEntireHome)这个方法的返回值。）

>Bridge Note:当你为home添加桥接口时，桥接口底层的配件会自动被添加到home中。你的代理会接收到桥接口后每个配件的 [home:didAddAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddAccessory:)消息，但是你的代理不会接收到桥接口的[home:didAddAccessory:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddAccessory:)消息。

##观察配件的变化

配件的状态可以在任何时间发生变化。配件可能不能被获得，可以被移除，或者被关闭。请更新用户界面以反映配件状态的更改，尤其是如果你的app允许用户控制配件时。

这以下步骤中，我们假设你已经从HomeKit数据库中检索到了配件对象，正如[Getting the Accessories in a Room](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW5)中描述的那样。

观察个别配件的变化

1.在类接口中添加配件代理协议。

	@interface AccessoryViewController ()<HMAccessoryDelegate>  
	
	@end

2.设置配件的代理

	accessory.delegate = self;

3.实现 [HMAccessoryDelegate](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryDelegate_Protocol/index.html#//apple_ref/occ/intf/HMAccessoryDelegate) 协议

比如，执行[accessoryDidUpdateReachability:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMAccessoryDelegate/accessoryDidUpdateReachability:)方法以启用或者禁用配件控制。

    - (void)accessoryDidUpdateReachability:(HMAccessory *)accessory {
    	if (accessory.reachable == YES) {
       		// Can communicate with the accessory
    	} else {
       		// The accessory is out of range, turned off, etc
    	}
	}

如果你展示了配件的服务状态和特性，那么请执行以下代理方法来相应地更新其视图：

[accessoryDidUpdateServices:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMAccessoryDelegate/accessoryDidUpdateServices:)

[accessory:service:didUpdateValueForCharacteristic:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessoryDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMAccessoryDelegate/accessory:service:didUpdateValueForCharacteristic:)

想了解配件的服务，请参阅[Accessing Services and Their Characteristics](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1).

#第六部分：访问服务和特性

服务([HMService](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/cl/HMService))代表了一个配件(accessory)的某个功能和一些具有可读写的特性([HMCharacteristic](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristic_Class/index.html#//apple_ref/occ/cl/HMCharacteristic))。一个配件可以拥有多项服务,一个服务也可以有很多特性。比如一个车库开门器可能拥有一个照明和开关的服务。照明服务可能拥有打开/关闭和调节亮度的特性。用户不能制造智能家电配件和它们的服务-配件制造商会制造配件和它们的服务-但是用户可以改变服务的特性。一些拥有可读写属性的特性代表着某种物理状态，比如，一个恒温器中的当前温度就是一个只可读的值，但是目标温度又是可读写的。苹果预先定义了一些服务和特性的名称，以便让Siri能够识别它们。

##获得配件的服务和属性

在依照[Getting the Accessroties in a Room](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW5)中描述，你创建了一个配件对象之后,你可以获得配件的服务和特性。当然你也可以直接从home中按照类型获得不同的服务。

>重要:不要暴露匿名服务-比如固件升级服务-给用户

通过[HMAccessory](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/cl/HMAccessory)类对象的[services](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAccessory_Class/index.html#//apple_ref/occ/instp/HMAccessory/services)属性，我们可以获得一个配件的服务。

	NSArray *services = accessroy.services;

要获得一个home当中配件提供的特定服务，使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类对象的[servicesWithTypes:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/servicesWithTypes:)方法。

	//Get all lights and thermostats in a home
	NSArray *lightServices = [home servicesWithTypes:[HMServicesTypeLightbulb]];
	NSArray *thermostatServices = [home servicesWithTypes:[HMServicesTypeThermostat]];

使用[HMServices](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/cl/HMService)类对象的[name](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/instp/HMService/name)属性来获得服务的名称

	NSString *name = services.name;

要获得一个服务的特性，请使用[characteristics](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/instp/HMService/characteristics)属性。

	NSArray *characteristics = service.characteristics

使用[servicesType](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/instp/HMService/serviceType)属性来获得服务的类型

	NSString *serviceType = service.serviceType;

苹果定义了一些服务类型，并能被Siri识别:

>1.门锁(Door locks)
 2.车库开门器(Garage door openers)
 3.灯光(Lights)
 4.插座(Outlets)
 5.恒温器(Thermostats)

##改变服务名称

使用[updateName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/instm/HMService/updateName:completionHandler:)异步方法来改变服务名称。传入此方法的服务名称参数必须在一个home当中是唯一的，并且服务名可被Siri识别。


	[service updateName:@"Garage 1 Opener" completionHandler:^(NSError *error) {
    	if (error) {
        	// Failed to change the name
    	} else {
        	// Successfully changed the name
    	}
	}];

##访问特性的值

特性代表了一个服务的一个参数，它要么是只读、可读写或者只写。它提供了这个参数可能的值的信息，比如，一个布尔或者一个范围值。恒温器中的温度就是只读的，而目标温度又是可读写的。一个执行某个任务的命令且不要求任何返回-比如播放一段声音或者闪烁一下灯光来确认某个配件-可能就是只写的。

苹果定义了一些特性的类型，并能被Siri识别:

>1.亮度(Brightness)
 2.最近温度(Current temperature)
 3.锁的状态(Lock state)
 4.电源的状态(Power state)
 5.目标状态(Target state)
 6.目标温度(Target temperature)

比如，对于一个车库开门器来说，目标状态就是打开或者关闭。对于一个锁来说，目标状态又是上锁和未上锁。

在你获得了一个[HMService](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/cl/HMService)对象之后,如 [Getting Services and Their Properties](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW2)所描述的,你可以获得每个服务的特性的值。因为这些值是从配件中获得的，这些读写的方法都是异步的，并可以传入一个完成回调的block。

使用[readValueWithCompletionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristic_Class/index.html#//apple_ref/occ/instm/HMCharacteristic/readValueWithCompletionHandler:)异步方法来读取一个特性的值。


	[characteristic readValueWithCompletionHandler:^(NSError *error) {
    	if (error == nil) {
       		// Successfully read the value
       		id value = characteristic.value;
    	}
    	else {
       		// Unable to read the value
		}
	}];

在if语句块中，加入你的代码以更新app的视图。

使用[writeValue:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristic_Class/index.html#//apple_ref/occ/instm/HMCharacteristic/writeValue:completionHandler:)异步方法来向一个特性写入值。


	[self.characteristic writeValue:@42 withCompletionHandler:^(NSError *error) {
    	if (error == nil) {
       		// Successfully wrote the value
    	}else {
       		// Unable to write the value
		}
	}];

不要以为函数调用完成就意味着写入成功，实际上只有在当完成回调执行并没有错误产生时才表示写入成功。比如，直到一个开关的特性改变之前都不要改变这个开关的状态。在if语句块中，加入你的代码，以更新app的视图。

另外，在别的app更新了特性的值时也需要更新视图，在[Observing Changes to Accessories](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW1)中有描述。

##创建服务组

一个服务组([HMServiceGroup](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMServiceGroup_Class/index.html#//apple_ref/occ/cl/HMServiceGroup))提供了控制不同配件的任意数量服务的快捷方式-比如，当用户离开家之后控制家中的某些灯。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/servicegroups_2x.png)

在你创建了一个[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)对象之后,如[Getting the Primary Home and Collection of Homes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/FindingandAddingAccessories/FindingandAddingAccessories.html#//apple_ref/doc/uid/TP40015050-CH3-SW3)中描述,你也就在这个家中创建一个服务组。

为了创建一个服务组,我们使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类对象的[addServiceGroupWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addServiceGroupWithName:completionHandler:)方法。方法中参数服务组的名称必须在此家中唯一，并可以被Siri识别。


	[self.home addServiceGroupWithName:@"Away Lights" completionHandler:^(HMServiceGroup *serviceGroup, NSError *error) {
    	if (error == nil) {
       		// Successfully created the service group
		} else {
       		// Unable to create the service group
       	}
    }];
我们使用[HMServiceGroup](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMServiceGroup_Class/index.html#//apple_ref/occ/cl/HMServiceGroup)类对象的[addService:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMServiceGroup_Class/index.html#//apple_ref/occ/instm/HMServiceGroup/addService:completionHandler:)方法来向服务组中添加一个服务。服务可以在一个或多个服务组中。


	[serviceGroup addService:service completionHandler:^(NSError *error) {
    	if (error == nil) {
       		// Successfully added service to service group
    	}
       	// Unable to add the service to the service group
    }];

通过[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类对象的[serviceGroups](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instp/HMHome/serviceGroups)属性，来获得这个家的所有服务组。


NSArray *serviceGroups = self.home.serviceGroups;
通过[HMServiceGroup](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMServiceGroup_Class/index.html#//apple_ref/occ/cl/HMServiceGroup)类对象的[accessory](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMService_Class/index.html#//apple_ref/occ/instp/HMService/accessory)属性，我们获得服务所对应的智能电器。

	HMAccessory *accessory = service.accessory;

和配件类似，代理方法在别的app改变服务组时也会被调用。如果你的app使用了服务组，请阅读[HMHomeDelegate Protocol Reference](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/doc/uid/TP40014474)文档，获悉你应该实现哪些方法以观察这些变化。

#第七部分：测试HomeKitApp

如果你没有智能电器(智能配件），你可以使用HomeKit Accessroy Simulator来模拟home中的智能电器。每个模拟配件都拥有服务和特性，你可以从你的App当中控制它。你的App在HomeKit数据库中创建对象和关系。它可以创建home布局，可以添加新的配件到模拟的home环境当中，最后向home中的每个房间添加智能配件。然后，你的app就能控制这些在HomeKit Accessory Simulator展示的模拟智能配件了。为了使用HomeKit Accessory Simulator，请在iOS模拟器中运行你的应用程序，或者使用Xcode在iOS设备上运行应用程序。

HomeKit Accessory Simulator是一个附加的开发者工具，不过并没有安装在Xcode当中。请按照[Download HomeKit Accessory Simulator](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/EnablingHomeKit/EnablingHomeKit.html#//apple_ref/doc/uid/TP40015050-CH2-SW3)中所述的安装HomeKit Accessory Simulator。

##添加智能电器（配件）

使用HomeKit Accessory Simulator来添加智能电器到模拟网络中。

向网络中添加智能电器配件，请按照下面的步骤添加：

>1.在HomeKit Accessory Simulator中，点击底部左边‘+’按钮。
 2.从弹出菜单中选择添加智能电器(Add Accessory)
 3.输入智能电器的名字和制造商。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_accessory_2x.png)

4.点击完成

如果想删除一个智能电器，请选择一个智能电器然后点击键盘上的Delete键。

##向智能电器（配件）中添加服务

一个智能电器需要一项服务和特性，你可以从app控制它。从预定义了服务列表中选择一项服务，并自定义特性。

按照下面步骤向智能电器中添加服务

1.在HomeKit Accessory Simulator中，选择Accessories列中的某个配件。
该配件的服务信息会展示在一个详情界面中。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_service_2x.png)

>注意:所有智能电器都有一个Accessory Information，显示在所有其他服务的下方。你可以向这个Accessory Information服务添加特性，但你不能删除默认的特性。


2.点击添加服务(Add Service)，并从弹出视图中选择一个服务类型。

新添加的服务会在右边详细显示。HomeKit Accessory Simulator为每种服务创建通用的特性。比如一个灯光服务的默认特性为色彩(Hue)，饱和度(Saturation)，亮度(Brightness)和开关。(开关特性和电源状态特性是一样的,正如 [Accessing Values of Characteristics](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW3)中描述的那样。）一些特性是强制性的有一些也是可选择的。比如，开关特性就是强制性的，而色彩，饱和度，亮度这些特性都是可选择的。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_service_2_2x.png)

##向服务中添加特性

你可以向服务中添加预定义的特性，或者自定义的特性。每种特性你都只能添加一个。

按照下面的步骤向服务中添加特性：

1.在HomeKit Accessory Simulator中，服务详情视图，点击添加特性(Add Characteristic)

2.在特性类型菜单中，选择一个类型或者自定义类型。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_characteristic_2x.png)

3.在其他文本框中输入此特性的其他信息，并点击完成(Finish).

新添加的特性会在详细视图展示出来。

点击特性右边的减号来删除一个特性。如果特性右边并没有减号显示，这说明这个特性对这个服务来说是必须的。比如，你可以删除电灯服务中的色彩(Hue)，饱和度(Saturation)和亮度(Brightness)，但是你不可以删除开关特性。


##通过你的App向家庭中添加智能电器（配件）

在你通过HomeKit Accessory Simulator创建了一个智能电器后，运行你的App然后添加一个新的智能电器到你的家庭。

如何配对家庭中的智能电器：

1.  在Xcode中，点击Run并调用[addAccessory:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addAccessory:completionHandler:)方法(如[Adding Accessories to Homes and Rooms](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/WritingtotheHomeKitDatabase/WritingtotheHomeKitDatabase.html#//apple_ref/doc/uid/TP40015050-CH4-SW5)中描述的那样).

2.  如果弹出了一个Add HomeKit Accessory对话框声明这个智能电器未被信任(这在HomeKit Accessory Simulator中是被允许的)，不用管它，点击Add Anyway。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_accessory_dialog1_2x.png)

3.  在接下来显示的Add HomeKit Accessory对话框中，输入智能电器的setup code然后点击Add。

在HomeKit Accessory Simulator，setup code显示在详情界面智能电器名称下。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_accessory_dialog2_2x.png)

关于如何编写代码来添加一个智能电器到家庭和房间请阅读[Creating Homes and Adding Accessoris](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/WritingtotheHomeKitDatabase/WritingtotheHomeKitDatabase.html#//apple_ref/doc/uid/TP40015050-CH4-SW1)。

##控制智能电器（配件）

在HomeKit Accessory Simulator中，你可以获得智能电器的服务，并在其他HomeKit App中设置服务的特性值来模拟控制这个智能电器，或者手动地模拟控制智能电器。

想要控制一个智能电器你需要:

1.在HomeKit Accessory Simulator中的智能电器列表（Accessories column）中选择一个智能电器。这个智能电器的服务和特性会被展示在详情界面。

2.操作一个特性的控件来改变它的值。

比如，为了改变一个灯泡的颜色（Hue），饱和度（Saturation）和亮度（Brightness），请滑动这个滑块。为了打开这个灯泡请选择On选项。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/accessory_detail_view_2x.png)

如果你的app展示了一个服务的特性，比如灯泡的开关状态，当你在HomeKit Accessory Simulator中改变这些特性的值时，它应当更新视图。

为了观察HomeKit数据库的变化，请阅读[Observing HomeKit Database Changes]()。如果你想从app中通过编写代码来控制一个智能电器，请阅读[Accessing Services and Characteristics]()。

##添加桥接口

为了模拟那些不支持HomeKit Accessory Protocol协议的智能电器，需要添加一个虚拟桥接口，然后将智能电器添加到这个虚拟桥接口。配置虚拟桥接口底层的智能电器和配置其他类型的智能电器差不多。

添加一个虚拟桥接口到网络

添加一个代表这个虚拟桥接口的智能电器。

为了添加一个虚拟桥接口到网络你需要:

1.在HomeKit Accessory Simulator中，点击智能电器列表底部的“+”按钮。

2.在弹出框中选择Add 虚拟桥接口。

3.输入一个智能电器的名称和制造商。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/add_bridge_2x.png)
4.点击完成

##向虚拟桥接口添加智能电器配件

可向一个虚拟桥接口添加一个或多个智能电器。

为了向一个虚拟桥接口添加一个智能电器，需要:

1.在HomeKit Accessory Simulator左边的列表中，选择虚拟桥接口中的一个虚拟桥接口。

2.在详情页面选择Add Accessory。

3.输入一个智能电器名字和制造商。

4.点击完成。

想要了解虚拟桥接口中的智能电器的详细信息，请选择虚拟桥接口部分中的智能电器。如果需要的话你可以点击虚拟桥接口旁边的查看详情来查看这个虚拟桥接口的智能电器。在你添加了一个服务和特性到这些智能电器之后，如[Adding Services to Accessories](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW3)和[Adding Characteristics to Services](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW9)中描述。它们会在这个虚拟桥接口被选择之后被展示出来。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/view_bridge_accessories_2x.png)

##在你的App中添加虚拟桥接口到home

将虚拟桥接口和home匹配的过程和将一个智能电器配置到一个home的过程是一样的，如[Adding Accessories to a Home in Your App](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW4)描述的。在虚拟桥接口底层的智能电器配件也一样被加入到了home，如 [Adding Bridges to Homes and Rooms](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/WritingtotheHomeKitDatabase/WritingtotheHomeKitDatabase.html#//apple_ref/doc/uid/TP40015050-CH4-SW9)所描述。

##控制虚拟桥接口底层的智能电器

如何控制虚拟桥接口底层的智能电器和直接控制智能电器的步骤一致，如[Controlling Accessories in HomeKit Accessory Simulator](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW5)中描述，除了你直接选择虚拟桥接口下的智能电器之外。

##在多设备和多用户环境中测试

在iOS模拟器中你不能测试分享HomeKit数据库到多个iOS设备和用户。你应该安装你的App到多台iOS设备上，在这些设备中输入iCloud证书，然后运行你的App。或者，使用ad hoc授权来在多台注册设备中测试你的app，如[Distributing Your App Using Ad Hoc Provisioning in App Distribution Guide](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/TestingYouriOSApp/TestingYouriOSApp.html#//apple_ref/doc/uid/TP40012582-CH8-SW4)描述。

>1.为了测试单用户多设备环境，你应该使用同一个iCloud账户在多台设备登陆。
 2.为了测试多用户使用同一家庭的智能电器，你应该在多台设备使用不同的iCloud账户登陆。

你的App应该应该可以允许一个用户邀请客人到你的家中，如[Managing Users](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/ManagingUsers/ManagingUsers.html#//apple_ref/doc/uid/TP40015050-CH9-SW1)所述。

#第八部分：创建动作集（Action Sets）和触发器（Triggers）

一个动作集合[HMActionSet](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMActionSet_Class/index.html#//apple_ref/occ/cl/HMActionSet)和触发器[HMTimerTrigger](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTimerTrigger_Class/index.html#//apple_ref/occ/cl/HMTimerTrigger)允许你同时控制多个智能电器。比如，一个动作集合可能会在用户上床休息之前执行一组动作[HMAction](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAction_Class/index.html#//apple_ref/occ/cl/HMAction)。一个写动作向一个特性写入了值。动作集合中的动作是以不确定的顺序执行的。一个触发器会在一个特定的时间出发一个动作集并可以重复执行。每一个动作集合在一个家庭中都有唯一的名称并可被Siri识别。

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/actionsets_2x.png)

##创建写入动作

写入动作会向一个服务的特性写入值并被加入到动作集合中去。[HMAction](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMAction_Class/index.html#//apple_ref/occ/cl/HMAction)类是[HMCharacteristicWriteAction](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristicWriteAction_Class/index.html#//apple_ref/occ/cl/HMCharacteristicWriteAction)具体类的抽象基类。一个动作有一个相关联的特性对象，你可以通过[Accessing Services and Characteristics](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/AccessingServicesandTheirCharacteristics/AccessingServicesandTheirCharacteristics.html#//apple_ref/doc/uid/TP40015050-CH6-SW1)中描述的来获取相关的服务和特性，然后创建这个[HMCharacteristicWriteAction](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristicWriteAction_Class/index.html#//apple_ref/occ/cl/HMCharacteristicWriteAction)。

为了创建一个动作，我们使用[HMCharacteristicWriteAction](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristicWriteAction_Class/index.html#//apple_ref/occ/cl/HMCharacteristicWriteAction)类中的[initWithCharacteristic:targetValue:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristicWriteAction_Class/index.html#//apple_ref/occ/instm/HMCharacteristicWriteAction/initWithCharacteristic:targetValue:)方法。

	HMCharacteristicWriteAction *action = [[HMCharacteristicWriteAction alloc] initWithCharacteristic:characteristic targetValue:value];

在你的代码中，你使用对应的特性的期望来替换value参数，并使用对应的[HMCharacteristic](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMCharacteristic_Class/index.html#//apple_ref/occ/cl/HMCharacteristic)对象来替换characteristic参数。

##创建并执行动作集

一个动作集就是一个共同执行的动作的集合。比如一个夜间动作集合可能包含关闭电灯，调低恒温水平和锁上房门。

为了创建一个动作集我们使用[addActionSetWithName:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addActionSetWithName:completionHandler:)异步方法。


	[self.home addActionSetWithName:@"NightTime" completionHandler:^(HMActionSet *actionSet, NSError *error) {
    	if (error == nil) {
        	// 成功添加了一个动作集
    	} else {
    	    // 添加一个动作集失败
    	}
	}];

为了添加一个动作到动作集，我们使用[addAction:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMActionSet_Class/index.html#//apple_ref/occ/instm/HMActionSet/addAction:completionHandler:)异步方法。

	[actionSet addAction:action completionHandler:^(NSError *error) {
    	if (error == nil) {
        	// 成功添加了一个动作到动作集
    	} else {
    		// 添加一个动作到动作集失败
    	}
	}];

想要移除一个动作，可使用[removeAction:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMActionSet_Class/index.html#//apple_ref/occ/instm/HMActionSet/removeAction:completionHandler:)方法。

想要执行一个动作集，可使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类的[executeActionSet:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/executeActionSet:completionHandler:)方法。比如，用户希望控制所有的节日彩灯。我们就创建一个动作集来打开所有的节日彩灯，另外一个动作集来关闭所有的节日彩灯。为了打开所有的节日彩灯，发送[executeActionSet:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/executeActionSet:completionHandler:)消息给home对象，并传递"打开节日彩灯"动作集。

##创建并开启触发器

触发器会执行一个或多个动作集。iOS会在后台管理和运行你的触发器。[HMTrigger](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTrigger_Class/index.html#//apple_ref/occ/cl/HMTrigger)类是[HMTimerTrigger](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTimerTrigger_Class/index.html#//apple_ref/occ/cl/HMTimerTrigger)具体类的抽象类。当你创建一个定时触发器时，你需要指定触发时间和触发的周期。创建并开启一个定时触发器需要多个步骤来完成。

遵循下面几步来创建并启动一个定时触发器

创建一个定时触发器

1.创建定时触发器。

	self.trigger = [[HMTimerTrigger alloc] 
	initWithName:name 
	fireDate:fireDate 
	timeZone:niL 
	recurrence:nil 
	recurrenceCalendar:nil];

触发时间必须设置在将来的某个时刻，第二个参数必须为0.如果你设置了一个周期，周期的最小值是5分钟，最大值是5周。关于如何使用[NSDateComponents](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSDateComponents_Class/index.html#//apple_ref/occ/cl/NSDateComponents)和[NSCalendar](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSCalendar_Class/index.html#//apple_ref/occ/cl/NSCalendar)来设置周期，请阅读[Date and Time Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DatesAndTimes/DatesAndTimes.html#//apple_ref/doc/uid/10000039i)

2.添加一个动作集到触发器。

使用[HMTrigger](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTrigger_Class/index.html#//apple_ref/occ/cl/HMTrigger)基类方法[addActionSet:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTrigger_Class/index.html#//apple_ref/occ/instm/HMTrigger/addActionSet:completionHandler:)，来添加一个动作集到触发器。

3.添加一个触发器到家庭。

使用HMHome类中的[addTrigger:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addTrigger:completionHandler:)方法来添加一个触发器到家庭。

4.启动触发器。

新创建的触发器默认是未启动的。需要使用[enable:complationHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMTrigger_Class/index.html#//apple_ref/occ/instm/HMTrigger/enable:completionHandler:)方法启动触发器。

一个定时触发器被启动后，会周期性的运行它的动作集。

#第十部分：用户管理

创建home的用户是该home的管理员，可以执行所有操作，包括添加一个客人用户到home。任何管理员添加到这个home的用户(HMUser)都有一个有限的权限。客人不能更改家庭的布局，但是可以执行下面的动作：

识别智能电器
读写特性
观察特性值变化
执行动作集
比如，一个家庭的户主可以创建一个home布局并向其中添加家庭成员。每个家庭成员必须拥有一个iOS设备和Apple ID以及相关的iCloud账户。iCloud需要个人输入的Apple ID和户主提供的Apple ID相吻合，以便让他们访问这个home。考虑到隐私问题，Apple ID对你的App是不可见的。

管理员需要遵从以下步骤来添加一个客人到home中：

>1.管理员调用一个动作将客人添加到home中。
2.你的App调用[addUserWithCompletionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addUserWithCompletionHandler:)异步方法。
3.HomeKit展示一个对话框，要求输入客人的Apple ID。
4.用户输入客人的Apple ID。
5.在完成回调中返回一个新的用户。
6.你的App展示客人的名字。

添加一个客人到home，需要在客人的iOS设备上做以下操作：

>1.用户在iCloud偏好设置中输入iCloud凭证(Apple ID和密码)。
2.用户启动你的App。
3.你的App通过home manager object获得一个home集合。
4.如果iCloud的凭证和管理员输入的Apple ID相同，那么管理员的home将会出现在[homes](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeManager_Class/index.html#//apple_ref/occ/instp/HMHomeManager/homes)属性中。

客人执行的操作可能会失败。如果一个异步方法中出现[HMErrorCodeInsufficientPrivileges](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HomeKit_Constants/index.html#//apple_ref/c/econst/HMErrorCodeInsufficientPrivileges)错误码的话，这就意味着用户没有足够的权限来执行动作-也许这个用户只是客人，而不是管理员。

为了测试你的App是否正确处理了客人用户，请阅读[Testting Multiple iOS Devices and Users](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/TestingYourHomeKitApp/TestingYourHomeKitApp.html#//apple_ref/doc/uid/TP40015050-CH7-SW12)。

##添加和移除用户

为了添加一个客人用户到home，请使用[addUserWithCompletionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/addUserWithCompletionHandler:)异步方法。


	[self.home addUserWithCompletionHandler:^(HMUser *user, NSError *error) {
    	if (error == nil) {
        	// Successfully added a user
    	}
    	else {
     	  	// Unable to add a user
		}
	}];

想要移除home中的用户，请使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)类的[removeUser:completionHandler:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instm/HMHome/removeUser:completionHandler:)方法。

通过实现[HMHomeDelegate](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intf/HMHomeDelegate)协议中的[home:didAddUser:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didAddUser:)和[home:didRemoveUser:](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHomeDelegate_Protocol/index.html#//apple_ref/occ/intfm/HMHomeDelegate/home:didRemoveUser:)协议方法检查新添加和移除的用户并更新视图。关于如何创建一个delegate，请阅读[Observing Changes to Individual Homes](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/RespondingtoHomeKitDatabaseChanges/RespondingtoHomeKitDatabaseChanges.html#//apple_ref/doc/uid/TP40015050-CH5-SW4)。

##获得用户名

出于隐私的考虑，你的app对用户名只有读得权限，并不能读写用户的Apple ID。使用[HMHome](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/cl/HMHome)对象的[users](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMHome_Class/index.html#//apple_ref/occ/instp/HMHome/users)属性来获取用户。使用[HMUser](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMUser_Class/index.html#//apple_ref/occ/cl/HMUser)类的[name](https://developer.apple.com/library/ios/documentation/HomeKit/Reference/HMUser_Class/index.html#//apple_ref/occ/instp/HMUser/name)属性来获取用户名
