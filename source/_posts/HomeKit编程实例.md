title: HomeKit 编程实例
date: 2016-08-10 18:20:01
categories: 智能家居
tags: HomeKit
---
<!-- MFI (Made for iPod,Made for iPhone ,and Made for iPad) 认证是指 连接iPod,iPhone,iPad而特别设计的电子配件.并且这些配件已经被苹果公司授权认证,以此来满足苹果产品的性能标准. -->

#HomeKit智能家居平台

随着物联网技术的发展,构建智能家居的技术越来越成熟,苹果公司制定了HomeKit智能家居平台硬件规格标准,第三方设备制造商将可以为苹果设备推出大量智能家居产品.设备商都必须参加MFI 授权计划,并严格遵守此前公布的硬件规格要求.

HomeKit 硬件标准涵盖了包括蓝牙低功耗连接,WiFi连接和安全等规格设计,目前HomeKit只能家居设备包括风扇,车库门,电灯,锁,电源插座,数字开关和韩文琦等家用设备.

![](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/HomeKitDeveloperGuide/Art/into_diagram_2x.png)
<!-- more -->
#HomeKit 开发框架 
苹果公司给出了HomeKit 平台标准的同时给出了基于HomeKit开发框架 HomeKit.framework. 通过HomeKit框架可以开发基于苹果的设备客户端程序,开发人员不需要关系具体的配件的固件信息,不要关心如何与配件进行通信.HomeKit框架使智能家居的应用开发更加轻松,更加简单.

#HomeKit 术语

>1.Homes:家庭,用户可以有多个家庭,例如城市的商品房,郊外的别墅.
 2.Rooms:家庭中的房间,例如卧室,客厅和厨房等,一个家庭中有多个房间(比如两室一厅).
 3.Accessories:外部配件,它是实际智能家居配件,比如电风扇,车库门,电灯,油烟机.这些配件被安装在家庭中,并且又被分配给某个房间.
 4.Services:服务,是由配件提供的给用户控制的服务,比如电风扇的电源,电灯的亮度,油烟机的风速大小等.单个配件可以有多个控制服务.
 5.Zones: 区域,在家庭中可以对房间进行分组.这样便于控制.比如一楼的房间,孩子们的房间等.


这些术语对应的对象,在创建的时候需要指定一个唯一的名字,这个名字不仅仅在程序中使用,还可以通过Siri 发出命令,进行语音控制.

HomeKit API
HomeKit 提供了智能家居开发所需的类和协议:

主要类:
>1.HMHomeManager:HMHomeManager对象管理一个或者多个家庭集合.
 2.HMHome:HMHome对象允许在家庭中安装配件已经进行通信.
 3.HMRoom:HMRoom对象被用来代表家庭的一个房间
 4.HMAccessory:HMAccessory对象代表一个智能家居配件,比如灯,恒温器
 5.HMAccessoryBrowser:HMAccessoryBrowser对象代表一个用来发现新配件的网络浏览器
 6.HMService:HMService对象代表提供的服务
 7.HMServiceGroup:HMServiceGroup对象代表配件提供的服务的集合,可以将多个服务当做一个实体处理.
 8.HMCharacteristic:HMCharacteristic对象代表某个服务的特性,比如灯打开.
 9.HMZone:HMZone对象代表一个家庭的集合区域.

主要协议:
>1.HMHomeManagerDelegate:这个协议定义了HMHomeManager代理对象的接口
 2.HMHomeDelegate:该协议定义了家庭委托对象的接口
 3.HMAccessoryDelegate:该协议定义配件委托对象的接口,当配件状态更新时回调噶协议方法.
 4.HMAccessoryBrowserDelegate:HMAccessoryBrowser委托对象的接口,当发现了新的配件回调改协议方法.


#HomeKit 编程

HomeKit编程的流程:

>1.创建家庭
2.添加房间到家庭
3.查找配件
4.在家庭中安装配件
5.分配配件到家庭
6.从配件中找到服务
7.从服务中找到特征
8.通过特征读写配件状态*

上述流程分为两个阶段,1.创建家庭和房间,2.配件查找和控制.
创建家庭和房间包括:1,2.
配件查找和控制包括:3,4,5,6,7,8


#实例:Philips Light bulb 控制设计

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming1.png)


##配置Xcode 工程
创建Philips Light bulb 的工程,开启HomeKit功能呢
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming2-1.png)

##核心代码


`ViewController.swift`
```swift
import UIKit
import HomeKit

class ViewController: UITableViewController {
    //家庭管理者
    var homeManager = HMHomeManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate
extension ViewController{
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //获取home
            let home = homeManager.homes[(indexPath as NSIndexPath).row]
            homeManager.removeHome(home, completionHandler: { (error) -> Void in
                if error != nil {
                    print(error)
                } else  {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
}
// MARK: - UITableViewDataSource
extension ViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeManager.homes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let home = homeManager.homes[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = home.name
        
        return cell
    }
}
// MARK: - HMHomeManagerDelegate
extension ViewController : HMHomeManagerDelegate{
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("home更新")
        tableView.reloadData()
    }
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        print("home已经被移除")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "addHome" {
            let navController = segue.destination as! UINavigationController
            let addHomeViewController = navController.topViewController as! AddHomeViewController
            addHomeViewController.homeManager = homeManager
            
        }else if segue.identifier == "showRooms"{
            
            let listRoomsViewController = segue.destination as! ListRoomsViewController
            let home = homeManager.homes[tableView.indexPathForSelectedRow!.row]
            
            
            listRoomsViewController.home = home
        }
    }
}
```

`AddHomeViewController.swift`
```swift
import UIKit
import HomeKit
class AddHomeViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var homeManager : HMHomeManager!
    var home: HMHome!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: AnyObject) {
        //添加home
        homeManager.addHome(withName: textField.text!, completionHandler: {(home, error) -> Void in
            
            if error != nil{
                print(error)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }
}
```

`AddRoomViewController.swift`
```swift
import UIKit
import HomeKit
class AddRoomViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var home: HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(_ sender: AnyObject) {
        home.addRoom(withName: textField.text!, completionHandler: { (room, error) -> Void in
            if error != nil {
                print(error)
            } else  {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
```

`DetailRoomViewController.swift`
```swift
import UIKit
import HomeKit
let accessoryName = "Light"

class DetailRoomViewController: UIViewController, HMAccessoryBrowserDelegate {
    
    var home: HMHome!
    var room: HMRoom!
    var lightAccessory: HMAccessory!
    var accessoryBrowser = HMAccessoryBrowser()
    
    var brightnessCharacteristic: HMCharacteristic!
    var powerStateCharacteristic: HMCharacteristic!
    
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var brightnessSilder: UISlider!
    @IBOutlet weak var brightnessValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessoryBrowser.delegate = self
        self.findAccessory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.accessoryBrowser.stopSearchingForNewAccessories()
    }
    
    func findAccessory(){
        
            for accessory in room.accessories {
                if accessory.name == accessoryName {
                    self.lightAccessory = accessory
                }
            }
        
        // 开始查找配件
        if self.lightAccessory == nil {
            self.accessoryBrowser.startSearchingForNewAccessories()
        } else {
            self.findServicesForAccessory(self.lightAccessory)
        }
        
    }
    //MARK: --实现HMAccessoryBrowserDelegate协议
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        NSLog("发现配件...")
        
        if accessory.name == accessoryName {
            self.home.addAccessory(accessory, completionHandler: { [weak self] (error) -> Void in
                
                if error != nil {
                    NSLog("安装配件失败。")
                } else {
                    self!.home.assignAccessory(accessory, to: self!.room, completionHandler: { (error) -> Void in
                        self!.findServicesForAccessory(accessory)
                    })
                }
                
                })
        }
    }
    func findServicesForAccessory(_ accessory: HMAccessory){
        NSLog("查找配件的服务...")
        for service in accessory.services {
            NSLog(" 服务名 = \(service.name)")
            NSLog(" 服务类型 = \(service.serviceType)")
            
            NSLog(" 查找服务中的特征...")
            findCharacteristicsOfService(service)
        }
    }
    
    func findCharacteristicsOfService(_ service: HMService){
        for characteristic in service.characteristics {
            NSLog("   特征类型 = \(characteristic.characteristicType)")
            
            if characteristic.characteristicType == HMCharacteristicTypeBrightness{
                brightnessCharacteristic = characteristic
                brightnessCharacteristic.readValue(completionHandler: { [weak self] (error) -> Void in
                    if error != nil {
                        print(error)
                    } else  {
                        let oldValue = self!.brightnessCharacteristic.value as! Float
                        NSLog("oldValue : \(oldValue)")
                        self!.brightnessSilder.value = oldValue
                        self!.brightnessValue.text = String(format: "%0.0f", oldValue)
                    }
                    })
                
            } else if characteristic.characteristicType == HMCharacteristicTypePowerState {
                powerStateCharacteristic = characteristic
                powerStateCharacteristic.readValue(completionHandler: { [weak self] (error) -> Void in
                    if error != nil {
                        print(error)
                    } else  {
                        let oldValue = self!.powerStateCharacteristic.value as! Bool
                        NSLog("oldValue : \(oldValue)")
                        self!.powerSwitch.setOn(oldValue, animated: true)
                    }
                    })
            }
        }
    }
    
    
    @IBAction func switchValueChanged(_ sender: AnyObject) {
        let newValue = self.powerSwitch.isOn
        self.powerStateCharacteristic.writeValue(newValue, completionHandler: {(error) -> Void in
            if error != nil {
                print("Power状态写入失败: \(error)")
            }
        })
    }
    
    @IBAction func silderValueChanged(_ sender: AnyObject) {
        let newValue = self.brightnessSilder.value
        self.brightnessCharacteristic.writeValue(newValue, completionHandler: {(error) -> Void in
            if error != nil {
                print("亮度写入失败:\(error)")
            }
        })
        self.brightnessValue.text = String(format: "%0.0f", newValue)
    }
    
}
```

`ListRoomsViewController.swift`
```swift
import UIKit
import HomeKit

class ListRoomsViewController: UITableViewController ,HMHomeDelegate{
    
    var home: HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return home.rooms.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let room = home.rooms[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = room.name
        
        return cell
    }
    
    //MARK: --实现数据源协议
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = home.rooms[(indexPath as NSIndexPath).row]
            home.removeRoom(room, completionHandler: { (error) -> Void in
                
                if error != nil {
                    print(error)
                } else  {
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            })
        }
    }
    
    //MARK: --实现HMHomeDelegate协议
    func home(_ home: HMHome, didAdd room: HMRoom) {
        print("一个房间被创建")
    }
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        print("一个房间被删除")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject!) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addRoom"{
            
            let navController = segue.destination as! UINavigationController
            let addRoomViewController = navController.topViewController as! AddRoomViewController
            addRoomViewController.home = home
            
        } else if segue.identifier == "showDetailRoom" {
            
            let detailRoomViewController = segue.destination as! DetailRoomViewController
            detailRoomViewController.home = home
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            detailRoomViewController.room = home.rooms[indexPath.row]
        }
    }   
}
```

##运行测试

开发者网站下载HardwareIOTools_Xcode_xx.dmg
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming2-2.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming3.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming4.png)

打开模拟器
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming5.png)

点击加号
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming6.png)

创建一个配件
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming7-2.png)

添加一个服务
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming8-2.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming9.png)

选择Light
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming10.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming11-2.png)

运行App

>注意:info.plist 填写 NSHomeKitUsageDescription

授权访问iCloud云端的homekit数据
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming12.PNG)

添加Home
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming13.PNG)

在刚刚添加的Home中添加Room
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming14.PNG)

授权添加配件
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming17.PNG)

添加room 和模拟器的配件进行配对
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming15.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming16.png)
完成配对,这个时候操作界面的开关,模拟器也会自动调整数据


[项目源代码GitHub](https://github.com/williamxiewz/projectDemo/tree/master/homekit/Philips%20Light%20bulb)

[项目源代码BaiduPan](https://pan.baidu.com/s/1JKY5kIewt0IbidzwbYBaww)



#iOS10 Home app使用
Home app能够添加所有的HomeKit的配件.下面是一个门的例子

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming18.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming19.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming20.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming21.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming22.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming23.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming24.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming25.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applehomekitprogramming26.png)