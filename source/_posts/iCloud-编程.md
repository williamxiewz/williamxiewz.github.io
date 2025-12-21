title: iCloud 编程
date: 2016-08-08 21:48:46
categories: iOS SDK
tags: iCloud
---
#iCloud简介

iCloud 是苹果"云战略"的重要棋子，iCloud是苹果的云服务技术。它的重点是提供数据的存储服务，苹果给每个用户免费提供5GB的云服务空间。如果不够，用户可以付费购买更多的空间。苹果公司斥资 10亿美元在北卡罗莱纳州建设新数据中心-iDataCenter，该数据中心面积为50万平方英尺，也是美国最大规模的数据中心之一。 

iCloud被整合到iOS 5和OS X 10.7. 4中，使用了这些设备的用户，只需在多个设备中设置苹果账号就可以同步、共享和备份数据。如图4-1所示，我的iphone设备上的通讯录可以同步到我的ipad和Mac Air电脑中。iCloud可以存放照片、文档等内容，以无线方式将它们推送到你的所有设备上。这都是自动在后台执行的，当打开电脑时候你会发现这些信息已经在那里了！

使用iCLoud 服务除了能够存储特定应用数据,还可以通过编程方式存储自己应用的数据,iOS8 之后苹果支持4中类的iCloud存储:
- iCloud 键值数据存储
- iCloud 文档存储
- iCloud Core Data 技术
- iCloudKit 存储编程

<!-- more -->
#iCloud 键值数据存储


iCloud键值数据存储的应用场景是这样的：我有看电子书的习惯，经常在乘坐地铁的时候使用iphone看电子书，当看到精彩内容的时候，我到站了 ，于是我关闭了这个应用。当晚上回到家时，我想用Ipad躺在沙发上看那本电子书，而且我想接着那个精彩的地方开始看。一个设计良好的电子书应用应该是：当我使用ipad打开这本书的时候，它应该马上跳到我当初退出的地方。这需要开发人员记录下退出时的页码，并保存在icloud中，然后其他设备使用该应用的时候获取这些记录信息，以便于初始化应用。

icloud键值数据存储，以一种键值对的方式存储简单类型数据，这些数据类型包括数字、日期、数组和字典等。数据结构是pust类型。每个应用只能存储64KB的数据。它也没有像文档存储那样有一套数据冲突解决方案，新的数据会覆盖旧的数据。因此，它经常用来存储系统设置、使用偏好以及应用的状态.


iCloud键值数据存储编程比较简单,在API使用方面,`NSUbiquitousKeyValueStore类`
它的使用类似于 `NSUserDefaults`,NSUserDefaults类 是苹果设计的访问本地系统的设置类.
而NSUbiquitousKeyValueStore类 是用来访问iCLoud 键值数据存储数据的.
NSUbiquitousKeyValueStore实例的获得也采用单例设计模式:

	var store = NSUbiquitousKeyValueStore.defaultStore() 

下面是NSUbiquitousKeyValueStore类的一些取值方法：
- boolForKey:根据键取出布尔值。 
- longLongForKey:根据键取出长整型值。
- objectForKey:根据键取出id类型值。
- stringForKey:根据键取出Nsstring类型值。 
- doubieForKey:根据键取出double类型值。
- arrayForKey;根据键取出数组类型值。 
- dictionaryForKey:根据键取出字典类型值。
- dataForKey:根据键取出NSData类型值。 


下面是NSUbiquitousKeyValueStore类的一些赋值方法： 
- setBoo]: forKey:根据键设置布尔值。 
- setLongLong: forKey:根据键设置长整型值。
- setObject; forKey:根据键设置id类型值。
- setString: forKey;根据键设置Nsstring类型值。
- setDouble: forKey:根据键设置double类型值。
- setArray: forKey:根据键设置数组类型值。
- setDictionary: forKey;根据键设置字典类型值。
- setData; forKey;根据键设置NSData类型值。 

力了监听iCLoud键值数据存储据的变化，可以在程序中注册通知消息 `NSUbiquitousKeyValueStoreDidchangeExternallyNotification`，这个通知是当一个设备更新了iCloud中的键值数据时,iCloud服务器会发出这个通知,使得其他设备都接受到这个通知.


##iCloud键值存储实例

开启Capabilities>iCloud>Key-Value storage

出现"<工程名>". entilements 这个文件是授权文件,它保存了该工程的iCloud授权的详细配置信息.


首先注册NSUbiquitousKeyValueStoreDidchangeExternallyNotification通知,并同步数据.

```swift

import UIKit

//背景音乐 存储键
let UbiquitousMusicKey = "MusicKey"
//音效 存储键
let UbiquitousSoundKey = "SoundKey"

class ViewController: UITableViewController {
    
    @IBOutlet weak var switchMusic: UISwitch!    
    @IBOutlet weak var switchSound: UISwitch!
    //单例
    var store = NSUbiquitousKeyValueStore.defaultStore()
    //观察着指针
    var storeDidChangeObserver : AnyObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化控件状态
        self.switchMusic.setOn(self.store.boolForKey(UbiquitousMusicKey), animated: true)
        self.switchSound.setOn(self.store.boolForKey(UbiquitousSoundKey), animated: true)
        //添加观察者,改通知在iCloud服务数据变化时候触发,当客户端接受到该小心时会调用closure
        self.storeDidChangeObserver = NSNotificationCenter.defaultCenter().addObserverForName(NSUbiquitousKeyValueStoreDidChangeExternallyNotification, object: nil, queue: nil) { (note) -> Void in
            //更新控件状态
            self.switchMusic.setOn(self.store.boolForKey(UbiquitousMusicKey), animated: true)
            self.switchSound.setOn(self.store.boolForKey(UbiquitousSoundKey), animated: true)
            
            let alert = UIAlertView(title: "iCloud变更通知", message: "你的iCloud存储数据已经变更", delegate: nil, cancelButtonTitle: "Ok")
            alert.show()
        }
        //同步到iCloud 服务器
        self.store.synchronize()
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self.storeDidChangeObserver)
    }


    @IBAction func setData(sender: AnyObject) {
        //存储iCloud服务器
        self.store.setBool(self.switchMusic.on, forKey: UbiquitousMusicKey)
        self.store.setBool(self.switchSound.on, forKey: UbiquitousSoundKey)
        self.store.synchronize()
    }
}




```
#iCloud文档存储

文档存储 iCloud文梢存储的应用场景是这样的：我有一个备忘录应用，我在上班的路上突发奇 
想，于是我用iphone记录下我好想法。然后，到公司的时候使用我的Mac Air运行我的备 
忘录应用，我会发现应用刚才记录的方法同步到我的Mac Air中了。

iCloud文档存储可以保存用户文档，用户在应用中创建文档，并通过 fcioud守护进程同步到icloud服务。文档类型没有限制，可以是文本文件、二进制文件。 
存储空间与用户的可用icloud服务空间有关，在文档冲突方面icloud提供一套API帮助 
解决这些问题。

##iCloud存储运行过程 

iCloud文档存储运行过程要比键值数据存储烦琐得多，将本地数据存储到iCloud服务器，大体分成3个步骤： 

步骤(1)`应用(App)`通过一个`Ubiquity容器标识`请求操作系统Ubiquity容器； 
步骤(2)操作系统授权`应用(App)`可以访问Ubiquity容器； 
步骤(3)通过Ubiquity容器实现与iCloud服务器传输数据。Ubiquity容器事实上也是设备上的目录，下面是运行在笔者设备某个应用的Ubiquity容器目录： 

/var/mobile/Library/Mobile % 20Documents/icloud〜cm〜51work6〜DoucmentDemo/

而应用的沙箱目录：
/var/mobile/Containers/Data/Application/5A858EE6-F4FA-4462-835F-2AB8ED1994DA/Docuinents 
可见沙箱目录与Ubiquity容器目录是不同的，使用的时候数据不能直接放在Ubiquity容器根目录下，而是要放在它的Documents子目录中，放入到这个目录中的数据可以自动同步到icioud服务器上，这个同步的过程开发者不用关系，由系统自动同步完成。

##iCloud文档储存实例

开启Capabilities>iCloud>iCloud Documents
出现"<工程名>". entilements 这个文件是授权文件,它保存了该工程的iCloud授权的详细配置信息
Containers选择 User default container 使用默认的容器名 : `"iCloud.<应用BundleID>"`
自定义文档类
```swift
class MyCloudDocument: UIDocument {
    //保存文档数据 ,这个文档是本文文件,所以是NSString类型
    var contents : NSString!
    
    //加载数据
    override func loadFromContents(contents: AnyObject, ofType typeName: String?) throws {
        
        let qContents = contents as! NSData
        
        if qContents.length > 0 {
            self.contents = NSString(data: qContents, encoding: NSUTF8StringEncoding)
        }
    }
    
    //保存数据
    override func contentsForType(typeName: String) throws -> AnyObject {
        let outError: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)
        let resContents = self.contents.dataUsingEncoding(NSUTF8StringEncoding)
        if let value = resContents {
            return value
        }
        throw outError
    }
}



```



```swift
import UIKit
//当前设备名
let DeviceName = UIDevice.currentDevice().name

class ViewController: UIViewController {

    @IBOutlet weak var txtContent: UITextField!
    //自定义文档类
    var myCloudDocument : MyCloudDocument!
    //查询元数据
    var query = NSMetadataQuery()
    
    //请求本地Ubiquity容器，从容器中获得Document目录URL
    lazy var ubiquitousDocumentsURL : NSURL? = {
        let fileManager = NSFileManager.defaultManager()
        var containerURL = fileManager.URLForUbiquityContainerIdentifier("iCloud.com.xxx.Demo")
        print("Ubiquity容器 : \(containerURL)")
        containerURL = containerURL?.URLByAppendingPathComponent("Documents")
        return containerURL
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //为查询iCloud文件的变化，注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateUbiquitousDocuments:", name: NSMetadataQueryDidFinishGatheringNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"updateUbiquitousDocuments:", name: NSMetadataQueryDidUpdateNotification, object: nil)
        
        //注册文档状态变化通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "resolveConflict:", name: UIDocumentStateChangedNotification, object: nil)
        
        //查询iCloud文件的变化
        if (self.ubiquitousDocumentsURL != nil) {
            self.query.predicate = NSPredicate(format: "%K like 'abc.txt'", NSMetadataItemFSNameKey)
            self.query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.query.enableUpdates()
        self.query.startQuery()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.query.disableUpdates()
        self.query.stopQuery()
    }


    
    //当iCloud中的文件变化时候调用
    func updateUbiquitousDocuments(notification : NSNotification) {
        //文件存在
        if self.query.results.count == 1 {
            let ubiquityURL  = self.query.results.last?.valueForAttribute(NSMetadataItemURLKey) as! NSURL
            
            self.myCloudDocument = MyCloudDocument(fileURL: ubiquityURL)
            self.myCloudDocument.openWithCompletionHandler({ (success) -> Void in
                if success {
                    NSLog("%@ : 打开iCloud文档", DeviceName)
                    if self.myCloudDocument.contents != nil {
                        self.txtContent.text = self.myCloudDocument.contents as String
                    } else {
                        self.txtContent.text =  ""
                    }
                }
            })
        } else { //文件不存在
            NSLog("文件不存在")
            let documentiCloudPath = self.ubiquitousDocumentsURL?.URLByAppendingPathComponent("abc.txt")
            self.myCloudDocument = MyCloudDocument(fileURL: documentiCloudPath!)
            self.myCloudDocument.contents = self.txtContent.text
        }
        
        if self.myCloudDocument != nil {
            //注册CloudDocument对象到文档协调者，文档状态变化才能收到通知
            NSFileCoordinator.addFilePresenter(self.myCloudDocument)
        }
    }
    
    @IBAction func saveClick(sender: AnyObject) {
        self.myCloudDocument.contents = self.txtContent.text
        self.myCloudDocument.updateChangeCount(UIDocumentChangeKind.Done)
        self.txtContent.resignFirstResponder()
    }
    
    //文档冲突解决
    func resolveConflict(notification : NSNotification) {
        if self.myCloudDocument != nil
            && self.myCloudDocument.documentState == UIDocumentState.InConflict {
            NSLog("冲突发生")
            do {
                //文档冲突解决策略
                try NSFileVersion.removeOtherVersionsOfItemAtURL(self.myCloudDocument.fileURL)
            } catch _ {
            }
            
            let conflictVersions = NSFileVersion.unresolvedConflictVersionsOfItemAtURL(self.myCloudDocument.fileURL)
            for item in conflictVersions! {
                let fileVersion = item 
                NSLog("fileVersion.name = %@",fileVersion.modificationDate!)
                fileVersion.resolved = true
            }
            self.myCloudDocument.contents = self.txtContent.text
            self.myCloudDocument.updateChangeCount(UIDocumentChangeKind.Done)
        }
        if self.myCloudDocument != nil {
            //从文档协调者中解除CloudDocument对象
            NSFileCoordinator.removeFilePresenter(self.myCloudDocument)
        }
    }
    
}



```

获取iCloud文档目录
```swift


```
查找Ubiquity 容器中的文档
```swift


```
iCloud中的文件变化处理
```swift


```
保存文档
```swift


```
解决文档冲突
```swift


```




#iCloud Core Data 技术
把一个文档保存在iCloud服务器端,文档的数据结构比较筒单,数据量也比较少，如果数据结构比较复杂，而是数据量相对大一些，再使用简单的数据结构文件就不能瞒住需求了,,可以考虑使用SQLite数据库,但是SQLite 是低级别数据持久化技术,而Core Data 是高级别的持久化技术,现在Core Data 可以借助于iCloud 技术奖户籍存到iCloud 服务中.


##iCloud Core Data  实例
配置项目
iCloud Core Data 是基于iCloud 文档存储
Capablities>iCloud>iCloud Documents
`CoreDataDAO.swift`
```swift
import Foundation
import CoreData

class CoreDataDAO: NSObject {
    
    override init() {
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self ,
            selector: #selector(CoreDataDAO.contentDidChange(_:)),
            name:NSPersistentStoreDidImportUbiquitousContentChangesNotification,
            object: self.persistentStoreCoordinator)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // 返回应用程序Docment目录的NSURL类型
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] 
    }()
    
    // MARK: - Core Data 堆栈
    //返回 被管理的对象上下文
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        //合并策略
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return managedObjectContext
    }()
    
    // 返回 持久化存储协调者
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("CoreDataNotes.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        
        do {
            
          let  x = try coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: self.iCloudPersistentStoreOptions)
        }catch {
        
            coordinator = nil
            // Report any error we got.
            var dict = [String: AnyObject]()
            
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error as NSError
            print("Unresolved error \(error), \((error as NSError).userInfo)")
            abort()

        }
        
        
        
//        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: self.iCloudPersistentStoreOptions, error: &error) == nil {
//            coordinator = nil
//            // Report any error we got.
//            var dict = [String: AnyObject]()
//            
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason
//            dict[NSUnderlyingErrorKey] = error
//            error = NSError(domain: "51work6.com", code: 9999, userInfo: dict)
//            print("Unresolved error \(error), \(error!.userInfo)")
//            abort()
//        }
        
        return coordinator
    }()
    
    //  返回 被管理的对象模型
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("CoreDataNotes", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    
    //使用这些配置
    var iCloudPersistentStoreOptions = {
        return [NSPersistentStoreUbiquitousContentNameKey: "iCloudMyNotesApp"]
    }()
    
    func contentDidChange(notification : NSNotification) {

        NSLog("%@", notification.userInfo!.description)
        
        self.managedObjectContext?.mergeChangesFromContextDidSaveNotification(notification)
        
        //投送通知更新UI
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("reloadViewNotification", object: nil)
        })
    }
    
}
```

#iCloudKit 存储编程

iOS 8 推出了CloudKit 存储,并提供了一套API用来开发.此外提供了一个iCloud服务器Web 管理工具 --- iCloud Dashboard(iCloud 仪表盘)

在介绍CloudKit编程之前，有必要介绍一下CloudKit中的一些术语：

- 容器：是应用的iCloud容器存储空间名字，在CloudKit容器类是CKContainer类。 
- 数据库：iCloud容器中存储数据的区域，被分为两个数据库---公有数据库和私有数据库，公有数据库是所有用户都能访问的数据,而私有数据库只能允许用户自己访问。在CloudKit数据库类是CKDatabase类。
- 记录类型（Record Type):相当于关系数据库中的表。 
- 记录(Record) :相当于数据表中记录。在CloudKit数据库类是CKRecord类。 
- 数据类型：记录（Record)中的字段是有数据类型的，他们分为database和asset两 
种。database数据是一般的字符、数字、日期时间和地理经纬度坐标等类型；asset类型是用来存储图片、声音、视频等二进制数据。 

iCloud Dashboard 

为了管理iCloud服务器，苹果提供了iCloud Dashboard的Web管理工具,可以通过网站[https://icloud.developer.apple.com/dashboard/](https://icloud.developer.apple.com/dashboard/)访问 或者在Xcodezhong 的CloudKit Dashboard按钮访问.

![]()

iCloud Dashboard左边导航菜单中有一些概念:

- Schema(模式):数据库对象的集合,iCloud中包含Record Type(记录类型),Security Role(安全角色）和Subscription Types(订阅类型).Record Type 可以管理记录类型,就是数据表; Security Roles定义角色，提供安全访问管理；Subscription Types可以订阅数据变化的通知。 
- Public Data: 公共数据库，其中包含User Records(用户记录),Default Zone(默认控件)和 Usage(用量)。User Records查看Users表中的数据，Users表的数据是由iCloud管理和维护的，开发人 
员不能删除他们；Default Zone查看公共数据库表中数据。Usage提供了数据访问的统计报告。 
- Private Data:私有数据库，其中Default Zone查看私有数据库表中数据。需要注意的是，如果当前账户下没有任何数据，这个导航菜单是看不到的。 
- Admin:管理员功能，Team当需要多人协同开发一个项目时候，为他们提供一个统 一的访问权限。Deployment可以查看Schema修改日志；可以重新初始化开发环境;发布数据库。 
- Environment:切换Development(开发环境）和Production(产品环境）。 


##CloudKit 实现实例

Capabilities > 开启iCloud > CloudKit > User default container 

iCloud 创建数据库
选择刚刚创建App对应的iCloud容器
Schema>Record Types ,点击+ 创建表,填写表名 和 字段


`NoteDAO.swift`

```swift
import Foundation
import CloudKit

class NoteDAO {
    //定义iCloud 容器
    var container : CKContainer!
    //定义database属性
    var database :  CKDatabase!
    //单例类方法
    class var sharedInstance: NoteDAO {
        struct Static {
            static var instance: NoteDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            
            let dao = NoteDAO()
            dao.container = CKContainer.defaultContainer()  //获得容器对象
            dao.database = dao.container.publicCloudDatabase // 获取共有数据库对象
                              //container.privateCloudDatabase  // 获取私有数据库对象
            
            Static.instance = dao
            
        }
        return Static.instance!
    }
    
    //插入Note方法
    func create(model: Note) -> Int {
        //创建名为"Note"的数据库表记录
        let record = CKRecord(recordType: "Note")
        //给记录设置 内容
        record.setObject(model.content, forKey: "content")
        //给记录设置内容
        record.setObject(model.date, forKey: "date")
        //数据库将记录对象插入到iCloud存储空间
        self.database.saveRecord(record, completionHandler: { (recd, error) -> Void in
            if error != nil {
                print("error:\(error)" )
            } else {
                print("插入数据成功。")
            }
        })
        
        return 0
    }
    
    //删除Note方法
    func remove(model: Note) -> Int {
        //创建一个data查询条件对象
        let predicate = NSPredicate(format: "date = %@", model.date)
        //查询对象
        let query = CKQuery(recordType: "Note", predicate: predicate)
        //查询操作
        let queryOperation = CKQueryOperation(query: query)
        //设置recordFetchedBlock回调属性,查询结果返回的回调,根据查询记录的个数调用多次
        //record 就是被查询到的记录
        queryOperation.recordFetchedBlock = { record in
            //将从iCloud存储空间删除,根据ID进行删除.
            self.database.deleteRecordWithID(record.recordID, completionHandler: { (recd, error) -> Void in
                if error != nil {
                    print("error: %@", error)
                } else {
                    print("删除数据成功。")
                }
            })
        }
        //执行查询操作
        self.database.addOperation(queryOperation)
        
        return 0
    }
    
    //修改Note方法
    func modify(model: Note) -> Int {
        
        let predicate = NSPredicate(format: "date = %@", model.date)
        let query = CKQuery(recordType: "Note", predicate: predicate)
        //查询操作
        let queryOperation = CKQueryOperation(query: query)
        //查询完以后,进行修改操作
        queryOperation.recordFetchedBlock = { record in
            record.setObject(model.content, forKey: "content")
            //修改操作
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            //执行修改回调
            modifyOperation.perRecordCompletionBlock = { (recd, error) -> Void in
                if error != nil {
                    print("error: %@", error)
                } else {
                    print("修改数据成功。")
                }
            }
            //执行修改操作
            self.database.addOperation(modifyOperation)
        }
        //执行查询操作
        self.database.addOperation(queryOperation)
        
        return 0
    }
    
    //查询所有数据方法
    func findAll() {
        
        let listData = NSMutableArray()
        //无条件的对象
        let predicate = NSPredicate(value: true)//不设置查询条件
        let query = CKQuery(recordType: "Note", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        //初始化QueryOperation
        let queryOperation = CKQueryOperation(query: query)
        //当提取数据时候设置
        queryOperation.recordFetchedBlock = { record in
            let content = record.objectForKey("content") as! String
            let date = record.objectForKey("date") as! NSDate

            let note = Note(date: date, content:content)
            listData.addObject(note)
        }
    
        queryOperation.queryCompletionBlock = { (cursor, error) in
            if error != nil {
                print("error: %@", error)
            } else {
                //投送通知更新UI
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSNotificationCenter.defaultCenter().postNotificationName("reloadViewNotification", object: listData)
                })
            }
        }
        
        //执行查询操作
        self.database.addOperation(queryOperation)

    }
    
    //按照主键查询数据方法
    func findById(model: Note)  {
        
        var note : Note!
        
        let predicate = NSPredicate(value: true)//不设置查询条件
        let query = CKQuery(recordType: "Note", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        //初始化QueryOperation
        let queryOperation = CKQueryOperation(query: query)
        //当提取数据时候设置
        queryOperation.recordFetchedBlock = { record in
            let content = record.objectForKey("content") as! String
            let date = record.objectForKey("date") as! NSDate
            
            note = Note(date: date, content:content)
        }
        
        queryOperation.queryCompletionBlock = { (cursor, error) in
            if error != nil {
                print("error: %@", error)
            } else {
                //投送通知更新UI
            }
        }
        
        //执行查询操作
        self.database.addOperation(queryOperation)

    }
    
}

```
