---
title: Multipeer connectivity 对等结构网络编程
date: 2016-08-10 18:58:32
categories: iOS网络编程
tags:  Multipeer connectivity
---

#对等结构网络 

对等结构网络是苹果的[Ad Hoc](https://zh.wikipedia.org/zh-cn/無線隨意網路)网络的一种,是在小空间里构建无限网络的解决方案。苹果公司的GameKit或Multipeer Connectivity(多点连接）框架中提供了开发这种网络的APi.


在iOS7中，引入了一个全新的框架——Multipeer Connectivity(多点连接)。利用Multipeer Connectivity框架，即使在没有连接到WiFi（WLAN）或移动网络（xG）的情况下，距离较近的Apple设备（iMac/iPad/iPhone）之间可基于蓝牙和WiFi（P2P WiFi）技术进行发现和连接实现近场通信。
<!-- more -->
Multipeer Connectivity扩充的功能与利用AirDrop传输文件非常类似，可以将其看作AirDrop不能直接使用的补偿，代价是需要自己实现。

多点连接网络,每个点都足对等的,每个对等点都通过”广播服务"和"搜索服务",


"广播服务"的目的是为了能够被其他端点搜索到，"搜索服务"的目的是为了是能够搜索到其他端点。 

当捜索到其他的端点,可以请求建立连接，连接一旦创建.会话（session)也就建义起来了。会话是与网络中运行应用的对等点对应的，每一对等点都会有一个PeerhId作为标示区别彼此。 

多点连接网络在苹果设备之间进行连接时,链路层采用蓝牙或WiFi实现,并采用 Bonjour发现服务。这些对于开发人员是不可见的,开发人员不用关心它们的细节问题。 
另外，采用蓝牙连接的对等网络在数据传输时，传输的距离有限制。 


>在Multipeer connectivity框架中主要的类如下:
- MCSession:描述连接的会话对象，一个设备的应用创建了会话对象，就可以邀请其他设备加入。 
- MCNearbyServiceAdvertiser :服务广播对象，广播服务告诉附近的对等点，它可以 
被搜索到。
- MCAdvertiserAssistant:服务广播对象助手类,提供iOS标准要求的确认对话框界面。
- MCNearbyServiceBrowser:服务搜索对象，能够搜索附近发出广播服务的对等点，  
- MCBrowserViewController:提供ios标准搜索界面，通过该界面能够捜索到附近广播服务的对等点，并能够请求连接。
- MCPeerID:PeerId类，在多点连接网格中对等点的唯一标识peerld。 


>Multipeer Connectivity框架中上述类相关的协议：
- MCSessionDelegate: MCSession的委托协议。
- MCNearbyServiceAdvertiserDelcgale: MCNearbyServiceAdvertiser的委托协议。
- MCNearbvServiceBrowserDelegate: MCNearbyServiceBrowser的委托协议。 
- MCBrowserViewControllerDelegate: MCBrowserViewController的委托协议。

#P2PGame游戏

```swift
import UIKit
import MultipeerConnectivity

let  GAMING = 0          //游戏进行中
let  GAMED  = 1          //游戏结束

class ViewController: UIViewController, MCSessionDelegate, MCBrowserViewControllerDelegate, UIAlertViewDelegate {
    
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var lblPlayer2: UILabel!
    @IBOutlet weak var lblPlayer1: UILabel!
    
    @IBOutlet weak var btnConnect: UIButton!
    @IBOutlet weak var btnClick: UIButton!
    
    var timer : NSTimer!
    
    let serviceType = "P2PGame-service"
    
    var serviceBrowser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearUI()
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: self.peerID)
        self.session.delegate = self
        
        self.serviceBrowser = MCBrowserViewController(serviceType: serviceType, session: self.session)
        self.serviceBrowser.delegate = self
        
        self.assistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: self.session)
        self.assistant.start()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onClick(sender: AnyObject) {
        
        if var count:Int = Int(self.lblPlayer1.text!) {
            self.lblPlayer1.text = String(format: "%i", ++count)
            
            let sendStr = String(format:"{\"code\":%i,\"count\":%i}",GAMING,count)
            let data = sendStr.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            
            var error : NSError?

            try!  self.session.sendData(data!, toPeers: self.session.connectedPeers, withMode: .Unreliable)
            
            if error != nil {
                NSLog("Error sending data:  %@", error!.localizedDescription)
            }
        }
    }
    
    
    @IBAction func connect(sender: AnyObject) {
        self.presentViewController(self.serviceBrowser, animated: true, completion: nil)
    }
    
    //清除UI画面上的数据
    func clearUI() {
        self.btnClick.enabled = false
        self.lblPlayer1.text = "0"
        self.lblPlayer2.text = "0"
        self.lblTimer.text = "30s"
        if self.timer != nil {
            self.timer.invalidate()
        }
    }
    
    //更新计时器
    func updateTimer() {
        
        var strRemainTime = self.lblTimer.text! as NSString
        let len = strRemainTime.length
        strRemainTime = strRemainTime.substringToIndex(len - 1)
        
        if var remainTime:Int = Int(strRemainTime as! String) {
            remainTime--
            //剩余时间为0 比赛结束
            if remainTime == 0 {
                
                var player1 = Int(self.lblPlayer1.text!)
                var player2 = Int(self.lblPlayer2.text!)
                var msg = "平手"
                
                if player1 > player2 {
                    msg = "我获胜"
                } else if player1 < player2 {
                    msg = "对手获胜"
                }
                
                let alerView = UIAlertView(title: "Game Over.", message:msg, delegate: self, cancelButtonTitle: "OK")
                alerView.show()
                
                self.clearUI()
                
            } else {
                self.lblTimer.text = String(format: "%is", remainTime)
            }
        }

    }
    
    //MARK: --实现UIAlertViewDelegate协议
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        self.btnClick.enabled = true
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
            selector: "updateTimer",
            userInfo: nil, repeats: true)
        
    }
    
    //MARK: --实现MCSessionDelegate协议
    //端点状态变化
    func session(session: MCSession!, peer peerID: MCPeerID!, didChangeState state: MCSessionState) {
  
        var logmsg = ""
        
        switch state {
        case .NotConnected:
            logmsg = "断开连接"
            dispatch_async(dispatch_get_main_queue()) {
                self.btnClick.enabled = false
            }
        case .Connecting:
            logmsg = "连接中..."
        case .Connected:
            logmsg = "已连接"
            dispatch_async(dispatch_get_main_queue()) {
                self.btnClick.enabled = true
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self,
                    selector: "updateTimer",
                    userInfo: nil, repeats: true)
            }
        }
        NSLog("Peer [%@] changed state to %@", peerID.displayName, logmsg)
    }
    
    //接收端点数据
    func session(session: MCSession!, didReceiveData data: NSData!, fromPeer peerID: MCPeerID!) {
        
       let jsonObj = try!  NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.MutableContainers) as! [String : AnyObject]
        
        let codeObj = jsonObj["code"] as! Int
        
        if codeObj == GAMING {
            let countObj = jsonObj["count"] as! Int
            dispatch_async(dispatch_get_main_queue()) {
                self.lblPlayer2.text = String(format: "%i", countObj)
            }
        } else if codeObj == GAMED {
            dispatch_async(dispatch_get_main_queue()) {
                self.clearUI()
            }
        }
    }
    
    // 接收端点数据流方式
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!, withName streamName: String!, fromPeer peerID: MCPeerID!) {
        
    }
    
    // 开始端点接收资源
    func session(session: MCSession!, didStartReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!) {
        
    }
    
    // 接收端点资源完成
    func session(session: MCSession!, didFinishReceivingResourceWithName resourceName: String!, fromPeer peerID: MCPeerID!, atURL localURL: NSURL!, withError error: NSError!) {
        
    }
    
    //MARK: --实现MCNearbyServiceBrowserDelegate协议
    func browserViewControllerDidFinish(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(browserViewController: MCBrowserViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}




```
