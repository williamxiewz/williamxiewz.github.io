---
title: iBeacon 微定位技术
date: 2016-08-10 19:01:39
categories: iOS SDK
tags: iBeacon
---

在一家大型商场,医院或是大楼里,你是否会曾经有过找不到想要去的地方的经历呢?
这种情况下采用上面介绍的传统定位方式,就有些"力不从心"了,首先不能采用GPS定位,而WiFi 和蜂窝式移动电话基站定位误差比较大,这种情况下的定位就是 "微定位"技术了

#地理围栏

微定位技术中一个比较重要的概念---地理围栏. 地理围栏(Geo-fencing)是LBS的一种新应用,就是用一个虚拟的栅栏围出一个虚拟地理边界. 当手机进入,离开某个特定地理区域,或在该区域活动时,手机可以可以接受自动通知和警告.有了地理围栏技术,位置社交网站就可以帮助用户进入某一个地区时自动登记.

地理围栏可以采用传统定位或微定位实现,当然微定位更加有现实意义,建立地理围栏技术往往是处于电子商务,店内导航和设计活动等目的. 定位环境比较复杂,定位要求比较精确.
<!-- more -->
#iBeacon 技术

苹果公司在iOS 7 之后 支持iBeacon技术,iBeacon技术是苹果公司研发的,它使用低功率蓝牙技术,通过多个iBeacon 基站创建一个信号区域(地理围栏),当设备进去该区域时,相应的应用便会提示用户进入这个地理围栏.

iBeacon 是苹果公司推出的一项室内定位技术，通过软件和硬件的结合，从而大大提高室内精度，从原来的几百米，几十米，提高到一米以内的定位精度。有了这么高精度的定位能力，许多原来只能想一想的事情，现在可以做到了：当你走到某个商品前，手机应用自动跳出商品的介绍，让你的购物体验感，大大增强。下图是一个典型的应用场景：

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledevelopdingweijishuibeacon1.jpg)

当用户(安装了特定应用的iOS用户)进入一家大型商场,在门口会有一个iBeacon 基站,它会提示用户是否需要接入这个信号网络。如果用户选择了”是"，他就可以享受到很多服务，iBeacon基站可以核对用户的 Passbook中是否具有本店的某种商品的优惠券或打折卡，当然也可以为用户发放电子优惠 
打折卡（即pass)，然后存人到passbook中。
也可以为用户提供商场的室内导航。最后要结账的时候，iBeacon可以提供零接触支付。


此外，每个iBeacon基站内置ARM架构cpu、蓝牙模块和闪存，以及加速度计、陀螺仪 寺传愁器。由于采用低功耗蓝牙技术通信，iBeacon基站更加省电，一个小纽扣电池使能为 一个iBeacon基站提供长达两年的续航时间。

#iBeacon技术实现微定位

iBeacon技术通信的核心是低功耗蓝牙通信，iBeacon基站就是一个外设，它只是负责广 
播数据，而中心是用户iOS设备上的应用。我们在开发阶段可以使用一个ios设备，在上 
面安装一个特定应用使其作为iBeacon基站角色。如果不考虑成本，我们可以使用iOS设 
备作为iBeacon基站，但事实上这样一个方案过于奢侈了，现在已经有一些公司开发出了功 
能完善的iBeacon技术的基站，它只需要很低的费用就可以构建iBeacon地理围栏。 

##iBeacon 基站服务端


```swift
import UIKit
import CoreBluetooth
import CoreLocation
// iBeacon UUID
let kUUID = "88936DF5-E10B-4382-89D6-8AE0D80373F8"
// 地理围栏区域
let kID = "com.williamxie.AirLocate"
// 蓝牙强度
let kPower = -59

class ViewController: UIViewController , CBPeripheralManagerDelegate {
    //蓝牙低功耗外设管理者
    var peripheralManager : CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
    }
    
    //广播数据开关
    @IBAction func valueChanged(sender: AnyObject) {
        
        let swc = sender as! UISwitch
        if swc.on {
            
            let uuid = NSUUID(UUIDString: kUUID)
            //CLBeaconRegion 对象 描述了 基于蓝牙低功耗Beacon 的地理围栏区域
            // 创建iBeancon 基站 定位标示符 和 地理围栏表示
            let region = CLBeaconRegion(proximityUUID: uuid!, identifier: kID)
            //获取iBeacon 基站广播所需数据
            let peripheralData = region.peripheralDataWithMeasuredPower(kPower)
            let dict:NSDictionary = peripheralData
            //进行广播
            self.peripheralManager.startAdvertising(dict as! [String : AnyObject] )
            
        } else {
        	//定制广播
            self.peripheralManager.stopAdvertising()
        }
    }
    
    //MARK: --实现CBPeripheralManagerDelegate协议
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        print("外设状态变化")
    }
}

```

##iBeacon 客户端


`ViewController.swift`
```swift

import UIKit
import CoreBluetooth
import CoreLocation
//表示iBeacon 基站
let kUUID = "88936DF5-E10B-4382-89D6-8AE0D80373F8"
//表示 地理围栏
let kID = "com.williamxie.AirLocate"
//蓝牙强度
let kPower = -59

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var lblRanging: UILabel!
    
    var locationManager : CLLocationManager!
    //地理围栏区域
    var region : CLBeaconRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        let uuid = NSUUID(UUIDString: kUUID)
        self.region = CLBeaconRegion(proximityUUID: uuid!, identifier: kID)
        
        self.locationManager.requestAlwaysAuthorization()
    }
    //view 销毁的时候停止监听和距离检测
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(false)
        self.locationManager.stopMonitoringForRegion(self.region)
        self.locationManager.stopRangingBeaconsInRegion(self.region)
    }
    
    @IBAction func rangValue(sender: AnyObject) {
        let swc = sender as! UISwitch
        if swc.on {
            //开始检测距离
            self.locationManager.startRangingBeaconsInRegion(self.region)
        } else {
            //停止检测距离
            self.locationManager.stopRangingBeaconsInRegion(self.region)
        }
    }
    
    
    @IBAction func onClickMonitoring(sender: AnyObject) {
        //开始检测范围
        self.locationManager.startMonitoringForRegion(self.region)
    }
    
    //MARK: --实现CLLocationManagerDelegate委托协议
    //范围状态变化时候调用
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        let notification = UILocalNotification()
        //判断是在围栏外还是围栏内
        if state == .Inside {
            notification.alertBody = "你在围栏内"
        } else if state == .Outside {
            notification.alertBody = "你在围栏外"
        } else {
            return
        }
        //发送本地通知
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
     }
    //在设备将要进入到指定的地理围栏内时候调用
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let notification = UILocalNotification()
        notification.alertBody = "你进入围栏"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    //在设备将要退出到指定的地理围栏内时候调用
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        let notification = UILocalNotification()
        notification.alertBody = "你退出围栏"
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    //在指定的围栏中Beacon设备位置变化时调用, beacons是多个beacon设备的数组
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
       
        let aryBeacons = beacons as NSArray
        //逻辑查询条件对象,用来在内存中过滤集合对象,通过格式化Predicate字符串创建NSPredicate
        var predicate = NSPredicate(format: "proximity = %d", CLProximity.Unknown.rawValue)
        let unknownBeacons = aryBeacons.filteredArrayUsingPredicate(predicate)
        if unknownBeacons.count > 0 {
            self.lblRanging.text = "未检测到"
        }
        
        predicate = NSPredicate(format: "proximity = %d", CLProximity.Immediate.rawValue)
        let immediateBeacons = aryBeacons.filteredArrayUsingPredicate(predicate)
        if immediateBeacons.count > 0 {
            self.lblRanging.text = "最接近"
        }
        
        predicate = NSPredicate(format: "proximity = %d", CLProximity.Near.rawValue)
        let nearBeacons = aryBeacons.filteredArrayUsingPredicate(predicate)
        if nearBeacons.count > 0 {
            self.lblRanging.text = "近距离"
        }
        
        predicate = NSPredicate(format: "proximity = %d", CLProximity.Far.rawValue)
        let farBeacons = aryBeacons.filteredArrayUsingPredicate(predicate)
        if farBeacons.count > 0 {
            self.lblRanging.text = "远距离"
        }
        
    }
}

要用到通知,所以配置通知的环境 在Info.plist 添加字段

`AppDelegate.swift`
```swift
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let setting = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(setting)
        
        return true
    }
```





参考:

`CLBeaconRegion` 类
```swift 
public class CLBeaconRegion : CLRegion {
	//identifier 是用来表示地理围栏的
    public init(proximityUUID: NSUUID, identifier: String)
    
    public init(proximityUUID: NSUUID, major: CLBeaconMajorValue, identifier: String)
    
    public init(proximityUUID: NSUUID, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String)

    public func peripheralDataWithMeasuredPower(measuredPower: NSNumber?) -> NSMutableDictionary

  	/// 接近UUID 一个128的唯一表示,表示一个或多个iBeacon基站 
    public var proximityUUID: NSUUID { get }
    // 主值 它是一个16位的无符号整数，用于区分有相同的接近UUID的 iBeacon基站
    public var major: NSNumber? { get }
    // 副值  它是一个16位的无符号整数，用于区分有相同的接近UUID和的主值的iBeacon基站 
    public var minor: NSNumber? { get }
    //
    public var notifyEntryStateOnDisplay: Bool
}
```
