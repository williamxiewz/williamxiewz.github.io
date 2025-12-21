title: Apple Pay编程开发详细教程
date: 2016-08-12 21:22:21
categories: iOS SDK
tags: ApplePay
---
#Apple Pay简介

##什么是Apple Pay
Apple Pay，简单来说, 就是一种移动支付方式。通过Touch ID/ Passcode，用户可使用存储在iPhone 6, 6p等设备上的信用卡和借记卡支付证书来授权支付；

它是苹果公司在2014苹果秋季新品发布会上发布的一种基于NFC的手机支付功能，于2014年10月20日在美国正式上线，2016年2月18日凌晨5：00， Apple Pay 业务在中国上线。

Apple Pay 是在 iOS 8 中第一次被介绍，它可以为你的应用中的实体商品和服务，提供简单、安全、私密的支付方式。它使得用户支付起来非常简便，只需按一下指纹就可以授权进行交易。
<!-- more -->
##使用前提
1.支持iOS设备

Apple Pay 只能在特定的设备上使用，目前为止，这些设备包括 iPhone 6, iPhone 6+, iPad Air 2, iPad mini 3. 这是因为 Apple Pay 需要特定的硬件芯片来支持，这个硬件叫做 Secure Element （简称SE，安全元件）,他可以用来存储和加解密信息。
	![Apple Pay设备支持列表](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguidesupportDevice.png)

2.系统支持

	iOS8.0+版本

>注意：iOS9.2才真正的支持“银联支付”， 意味着iOS9.2以后才可以在中国市场使用

3.银行支持
 	需要将被支持银行的银行卡， 添加到手机wallet应用当中
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguidesupportBank1.png)
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguidesupportBank2.png)

##应用场景
1.线下支付

如果发现以下标识，就代表该商家支持Apple Pay

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepayID.png)

苹果公开的Apple Pay商家有	

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepaysupportMerchant.png)
2.线上支付

2.1应用内支付

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepaysupport.png)

2.2 Apple Pay on Web 






##与其他第三方支付的区别
1.硬件方面

>Apple Pay：必须是iOS设备， 而且是按照线上支付和线下支付区分不同的真机设备(Apple Pay设备支持列表)
微信、支付宝： 基本跟硬件设备无关， 支持大多数的只能手机

2.网络环境要求

>Apple Pay：线上支付需要联网， 线下支付无需联网就可以支付
微信、支付宝： 无论是线上还是线下支付， 都需要联网使用

3.使用技术

>Apple Pay：线下支付使用的是 基于NFC的近场通讯技术
微信、支付宝： 线下支付使用的是 扫码支付（条形码、二维码）

4.主要功能

>Apple Pay：线上支付、线下支付、部分升级后的ATM机可以取款
微信、支付宝： 线上支付、线下支付、转账、理财等

5.安全性能
>Apple Pay：不保留银行卡信息，并且不会暴漏给外界、不分流银行存款（不需要从银行卡转钱到另外一个平台）、不能充值  安全性较高
微信、支付宝： 密码保护，身份验证等手段保护账户  安全性相对稍差

6.支付时长
>Apple Pay：无论是线上支付，还是线下支付， 只需要验证指纹即可支付。非常迅速
微信、支付宝： 需要扫码支付， 流程相对繁琐，所以时长较长

7.各自弊端
>Apple Pay：只适用于苹果设备， 支付场景单一，无转账理财等业务
微信、支付宝： 安全性较差， 必须联网操作，需要充值到对应平台


#为什么要使用Apple Pay
Apple Pay 大大简化了开发者的工作。你无需自己来管理卡号，也不需要用户去注册银行卡。你可以移除部分业务模块，甚至不需要用户模块了。购买和账单信息回自动交由 Apple Pay token 来处理。这意味着简化了购买流程，可以带来更高的转化率。

在 WWDC session 702 , [Apple Pay Within Apps]() 中, Nick Shearer 介绍了部分 Apple Pay 在美国的不同商业交易中超高转化率的统计情况。
Stubhub 发现使用 Apple Pay 的客户的转换率超过传统客户 20%。
OpenTable 发现采用了 Apple Pay 之后呈现了 50%的增长。
Staples 发现采用了 Apply Pay 后，实现了109%的转换率增长。
其实不仅仅是超高的转化率,还有就是让我们的支付方式看起来高大上.

#Apple Pay 工作流程

接入方式

因为 Apple Pay 在国内是跟银联合作的，所以在接入方式的选择上有两种。一种是使用 CUP SDK（CUP 就是 China Union Pay）等第三方的 SDK。另外一种就是使用 iOS 的 PassKit Framework 和银联的接口来接入。本质上来说，第三方 SDK 就是对 PassKit Framework 和传输信息的加密解密过程做了一层封装，让开发者可以轻松完成 Apple Pay 的接入。

两种接入方式对比：第一种使用第三方 SDK 接入的方式开发成本较低，但缺点在于对 Payment Sheet 定制化程度不够。而第二种形式的缺点就是开发成本较高。不仅 iOS 端要处理好 Payment Sheet 的显示和隐藏的逻辑，还要对各种异常情况做好相应的 UI 处理。同时在后台也需要处理好以下情况：支付信息的解密，银联接口的交互，以及订单状态的处理。

支付流程分析

要理解 Apple Pay 的支付流程，其中最关键一点就是：Apple 不处理跟扣款相关的逻辑，它只负责支付信息的传递。Apple 通过 Touch ID 来验证银行卡卡持有者身份。实际的扣款行为则是发生在银联端，接入了 Apple Pay 的商户组织好 Apple 返回的支付信息，向银联发出扣款请求之后，该笔交易才会真正发生扣款。所以，商户还是要跟银联进行结算的，Apple Pay 只是提供了一种支付渠道。


![](https://developer.apple.com/library/ios/ApplePay_Guide/Art/payment_intro_2x.png)

Apple Pay 应用内支付流程如下:

>1.App 根据使用场景显示 Payment Sheet。
 2.用户选择需要进行支付的卡以及支付需要的个人信息后，进行指纹验证，之后根据情况，有些银行卡还需要输入卡对应的密码（PIN 码）
 3.iOS 将支付相关信息发送到 Apple 的服务器，进行加密。然后通过回调函数将加密后的支付信息返回给对应 App。
 4.App 在收到回调之后，将对应信息发送到自己的服务器。
 5.服务器在收到 App 发送来的支付信息后，对数据进行解密操作，提取其中需要的信息，组织银联接口报文，调用银联的接口，完成扣款

下面对过程中的关键地方做一些说明。

1.App 收到的 Payment sheet 回调信息中，包含了一个 PKPayment 的对象，该对象包含了所有跟 Apple Pay 支付相关所有信息。比如用户的手机号或者收货地址等等，其中最重要的就是 payment token，它的 paymentData 字段数据就是需要发送给服务器的内容。用户信息部分是明文的，而支付信息也就是 paymentData 部分则是被加密过的。

2.paymentData 的内容是 Json 格式的二进制流，服务器在收到这个数据之后进行解析，其中的 header.wrappedKey 是使用非对称加密算法加密过的对称秘钥。使用在苹果开发者后台配置 merchant 时的私钥进行解密，会得到这个对称秘钥。然后用这个对称秘钥对 data 字段所包含的加密数据进行解密，可以得到 Apple 返回的与支付相关的信息。此支付信息是加密过的，包含了用户支付的卡号和 PIN 码等信息，理论上只有银联才能解析出来真正的内容，我们作为商户是看不到具体信息的。服务器端需要将这些解密过的信息组织成银联所需的报文内容，然后调用银联的扣款接口，完成扣款。

>特别注意：paymentData 里的有一个交易金额字段，但该字段返回的数据并不是实际支付的金额。在组织银联报文的时候一定要注意不要直接使用该字段的内容作为扣款金额的值。

3.调用银联接口时也有一些需要注意的事项。拿调用银联扣款接口举例，在组织好报文并调用银联接口发送给银联之后，银联的接口返回结果同时有同步和异步两种形式。注意：如果同步结果返回成功，说明银联成功收到并开始处理扣款请求，并不是代表扣款成功。扣款是否成功，是通过异步形式来通知的。扣款不成功的原因可能有很多，比如卡被冻结，PIN 码错误，余额不足等等。为了保证交易状态的准确，推荐的做法是这样：在调用扣款接口后，如果 3 秒内没有收到本次调用的异步结果回调，则使用银联的流水号，开始轮询银联的交易状态接口来确保拿到确切的交易结果。

4.Apple Pay 是很重视数据安全的。从上面的流程可以看到，为了保证整个交易的安全，Apple Pay 对每个关键流程都有加密处理。同时对每个绑定了 Apple Pay 的银行卡生成一个虚拟卡号，这个卡号的部分信息可以在 wallet 里绑定的卡片详情里看到。在实际支付中是用的这个卡号来做交易，这样可以在一定程度上保证我们银行卡的信息安全。



#Apple Pay对象类简介

所有这些类都包含在 PassKit（因此以 PK 开头） 之内，所以你需要在用到 Apple Pay 的地方，引入这个框架

	import PassKit


`PKPaymentButton`


`PKPaymentSummaryItem`
这个类是你的Apple Pay 交易清单上的一条。它可以是商品的，也可以是税，或者运费。
账单列表使用PKPaymentSummaryItem添加描述和价格，价格使用NSDecimalNumber。
PKPaymentSummaryItem初始化：
  label为商品名字或者是描述，amount为商品价格，折扣为负数，type为该条账单为最终价格还是估算价格(比如出租车价格预估)

`NSDecimalNumber`
 NSDecimalNumber可以使用数字初始化，也可以使用字符串

`PKPaymentRequest`
PKPaymentRequest 合并你所有想要用户看到的信息。诸如 merchant identifier, country code 和 currency code。

`PKPaymentAuthorisationViewController`
PKPaymentAuthorisationViewController 让用户及时授权 PKPaymentRequest，并且选择投递地址和支付的卡。

`PKPayment`
PKPayment包括需要处理的交易的信息，并且包含需要用户确认的消息。

        
        
        

        

#iOS应用内集成Apple Pay 
开发环境 : 
 >1.Mac OS X 10.11.6
  2.Xcode 8 beta4 
  3.付费开发者账号
  4.Swift 3.0

##配置支付环境
1.1创建一个Xcode项目
`为项目创建一个AppleID`
Apple Pay Demo > General > Bundle identifier

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideconfigureAppleID.png)

1.2开启Apple Pay功能
Apple Pay Demo > Capabilities
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideconfigureAddMerchantID.png)
1.3添加MerchantID
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideconfigureMerchantID2.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideconfigureMerchantIDApplePay2.png)

##代码实现

	定义成员变量
	//支付视图
    @IBOutlet weak var payView: UIView!
	//支付按钮
    var payButton : PKPaymentButton? = nil
	//价格数组 
    let priceArray = [9888.0,230.0,200.0,150.0,233.0,33.0,-1800.0]
    /// 购物清单数组
    var paymentSummaryItems : [PKPaymentSummaryItem]? = nil
    /// 配送方式数组
    var paymentShippingMethods : [PKShippingMethod]? = nil

1.判断当前是否支持Apple Pay

	//1.判断当前设备是否支持苹果支付
	if !PKPaymentAuthorizationViewController.canMakePayments() {
		//隐藏
		payView.isHidden = true
		print("设备不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")
	}

2.判断当前是否添加银行卡
检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测

	if !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: [PKPaymentNetwork.chinaUnionPay,PKPaymentNetwork.visa,PKPaymentNetwork.masterCard]){
        print("没有绑定银行卡,跳转到绑定银行卡界面")
        //创建一个跳转按钮,当用户点击按钮时,跳转到添加银行卡界面
        payButton = PKPaymentButton(paymentButtonType: PKPaymentButtonType.setUp, paymentButtonStyle: PKPaymentButtonStyle.whiteOutline)
        payButton!.addTarget(self, action: #selector(ViewController.jump), for: .touchUpInside)
        //添加到payView
        payView.addSubview(payButton!)
    }
	//跳转到银行卡界面
    func jump()  {
        let pl = PKPassLibrary()
        pl.openPaymentSetup()
    }

如图:
![没有绑定银行卡,需要去绑定](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepaysetup.png)
如果当前系统支持Apple Pay 以及 Wallet 已经添加了银行卡,显示购买按钮

	payButton = PKPaymentButton(paymentButtonType: PKPaymentButtonType.buy, paymentButtonStyle: PKPaymentButtonStyle.black) 
    payButton!.addTarget(self, action: #selector(ViewController.buy), for: .touchUpInside)     
    //添加到payView
    payView.addSubview(payButton!)

如图:
![可以正常支付](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepaypay.png)           

>注意:显示的Apple Pay按钮和Set Apple Pay按钮图片需要按照官方文档 要求设置

3.创建支付请求
创建一个PKPaymentRequest,该request需要包括所有商品和服务费用的，例如邮寄费，税或者折扣等

	//1.创建PKPaymentRequest
	let request = PKPaymentRequest()
    //2.配置支付请求
    //2.1配置申请的merchantID
    request.merchantIdentifier = "你申请的merchantID"
    //2.2 配置国家代码 和 货币
    request.countryCode = "CN"
    request.currencyCode = "CNY"
    //2.3 配置用户可进行支付的银行卡
    request.supportedNetworks = [PKPaymentNetwork.chinaUnionPay,PKPaymentNetwork.discover,PKPaymentNetwork.masterCard]
    //2.4 配置商家处理协议 
    //设置支持的交易处理协议，3DS必须支持，EMV为可选，目前国内的话还是使用两者吧
    request.merchantCapabilities = [PKMerchantCapability.capability3DS,PKMerchantCapability.capabilityEMV]
    //2.5 配置购买商品清单(订单)
    var sum : Double = 0.0
    _ = priceArray.map { i  in
                sum = sum + i
        }
        
    let item1 = PKPaymentSummaryItem(label: "DJI精灵4无人机主机", amount: NSDecimalNumber(value: priceArray[0]))
    let item2 = PKPaymentSummaryItem(label: "DJI精灵4智能电池", amount: NSDecimalNumber(value: priceArray[1]))
    let item3 = PKPaymentSummaryItem(label: "DJI精灵4螺旋桨", amount: NSDecimalNumber(value: priceArray[2]))
    let item4 = PKPaymentSummaryItem(label: "DJI精灵4旅行背包", amount: NSDecimalNumber(value: priceArray[3] ) )
    let item5 = PKPaymentSummaryItem(label: "DJI精灵4第二手柄", amount: NSDecimalNumber(value: priceArray[4]))
    let item6 = PKPaymentSummaryItem(label: "DJI精灵4云台盖", amount: NSDecimalNumber(value: priceArray[5]))
    let item7 = PKPaymentSummaryItem(label: "大学生折扣价", amount: NSDecimalNumber(value: priceArray[6]))
    //最后这个是支付给谁
    let totalItem = PKPaymentSummaryItem(label: "DJI官方旗舰店", amount: NSDecimalNumber(value: sum))
    //note:支付清单 ,最后一个item ,代表汇总
    //summaryItems为账单列表，类型是 NSMutableArray，这里设置成成员变量，在后续的代理回调中可以进行支付金额的调整。
    request.paymentSummaryItems = [item1,item2,item3,item4,item5,item6,item7,totalItem]
    self.paymentSummaryItems = request.paymentSummaryItems
    //3.0 配置请求的附加信息
    //设置发票配送信息(billingAddress)和货物配送地址信息(ShippingAddress),用户设置后可以通过代理回调 代理获取信息的更新
    //3.1  是否显示发票收货地址, 显示哪些选项
	//如果需要邮寄账单可以选择进行设置，默认PKAddressFieldNone(不邮寄账单)
	//楼主感觉账单邮寄地址可以事先让用户选择是否需要，否则会增加客户的输入麻烦度，体验不好
    request.requiredBillingAddressFields = .all
    //3.2 送货地址信息,默认PKAddressFieldNone(没有送货地址)
    //需要根据不同的商品类型来设置requiredShippingAddressFields，如果使电子/虚拟商品（一般为提取/下载链接），则显示联系人邮箱。如果为实物，则显示联系人地址、手机号以及邮箱
    request.requiredShippingAddressFields = .all
        
    //设置货物的配送方式，不需要不配置
    //3.3 配置快递方式 <PKShippingMethod*>
    let method1 = PKShippingMethod(label: "韵达快递", amount: NSDecimalNumber(value: 0.0))
    method1.detail = "送货上门"
    method1.identifier = "yundakuaidi"
        
    let method2 = PKShippingMethod(label: "顺风快递", amount: NSDecimalNumber(value: 18.0))
    method2.detail = "24小时"
    method2.identifier = "shunfengkuaidi"
    
    request.shippingMethods =  [method1,method2]
    self.paymentShippingMethods = request.shippingMethods   
    //3.4 配置快递取货方式
    request.shippingType = .storePickup
        
    //3.5 添加一些附加的数据
    request.applicationData = "BuyID=123456789".data(using: String.Encoding.utf8)
        
        
4.弹出授权视图控制,让用户去支付

 	//显示购物信息并进行支付
    let avc  = PKPaymentAuthorizationViewController(paymentRequest: request)
    avc.delegate = self
    self.present(avc, animated: true, completion: nil)

>显示所有已绑定的银行卡。
当选择卡片会调用代理方法paymentAuthorizationViewController:didSelectPaymentMethod:completion:该方法，需要实现completion完成回调，否则会卡在payment processing界面

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepayavc.png)

![等待用户TouchID或者输入密码](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplepaywillauthrizetion.png)

![Apple Pay支付完成](https://github.com/williamxiewz/williamxie-github-io/raw/master/applepayprogrammingguideapplePayDone.png)

5.PKPaymentAuthorizationViewControllerDelegate 代理方法

5.1 选择支付方式代理方法
 	
 	/**
     选择支付方式
     - parameter controller:    授权视图控制器
     - parameter paymentMethod: 支付方式信息
     - parameter completion:    回调
     */
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect paymentMethod: PKPaymentMethod, completion: ([PKPaymentSummaryItem]) -> Void) {
    	//作用:
        //选择支付方式选择回调,用于更新不同的货币,支付金额等,主要更新paymentSummaryItems对象数组
        print("已经选了一个付款方式")
        //付款方式
        var  paymentType : String = ""
        switch paymentMethod.type {
        case .unknown:
            paymentType = "未知"
        case .debit:
            paymentType = "借记卡"
        case .credit:
            paymentType = "信用卡"
        case .prepaid:
            paymentType = "预付卡"
        case .store:
            paymentType = "store方式"
        }
		//网络内购部分数据会为nil
        print("当前网络:\(paymentMethod.network),支付方式:\(paymentType),支付卡号:\(paymentMethod.displayName)")
        print(paymentMethod.paymentPass)
        
        completion(self.paymentSummaryItems!)
        
    }

5.2选择送货地址信息代理方法

    /**
     选择送货地址信息
     - parameter controller: 授权视图控制器
     - parameter contact:    送货地址信息
     - parameter completion: 回调
     */
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        print("选择收货人联系方式:\(contact))")
        //送货信息选择回调，如果需要根据送货地址调整送货方式，比如普通地区包邮+极速配送，偏远地区只有付费普通配送，进行支付金额重新计算，可以实现该代理.
        //返回给系统  更新以后的shippingMethods配送方式和更新以后的summaryItems账单列表
        //如果不支持该送货信息返回想要的PKPaymentAuthorizationStatus
        
        completion(PKPaymentAuthorizationStatus.success, self.paymentShippingMethods!, self.paymentSummaryItems!)
    }

5.3选择邮寄方式代理方法
	
	/**
     选择邮寄方式
     - parameter controller:     授权视图控制器
     - parameter shippingMethod: 邮寄方式
     - parameter completion:     回调
     */
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        print("选择邮寄方式为:\(shippingMethod.label)")
        //配送方式回调，如果需要根据不同的送货方式进行支付金额的调整，比如包邮和付费加速配送，可以实现该代理
        //更新paymentSummaryItems数组
        completion(PKPaymentAuthorizationStatus.success, self.paymentSummaryItems!)
    }

5.4已经授权支付代理方法

	func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: (PKPaymentAuthorizationStatus) -> Void) {
        print("完成授权,获取Token,连接商家服务器")
		//支付凭据，发给服务端进行验证支付是否真实有效
        print(payment.token)
        print(payment.shippingMethod)  //送货方式
        print(payment.billingContact)  //账单信息
        print(payment.shippingContact) //送货信息

        // 一般在此处,拿到支付信息, 发送给服务器处理, 处理完毕之后, 服务器会返回一个状态, 告诉客户端,是否支付成功, 然后由客户端进行处理
        let isSuccess = true
		//它需要你连接服务器并上传支付令牌和其他信息，以完成整个支付流程。
        if isSuccess {
            completion(.success)
        }else{
            completion(.failure)
        }
        print("已经授权支付")
    }

5.5授权控制器完成支付或者取消

 	func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        self.dismiss(animated: true, completion: nil)
        print("取消或者完成交易")   
    }

![项目源代码](#)

#Web端集成Apple Pay
