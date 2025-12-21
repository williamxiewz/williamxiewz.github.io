---
title: '翻译: Apple Pay编程指南'
date: 2016-08-10 20:38:06
categories: iOS SDK
tags: [ApplePay,编程指南]
---

#关于Apple Pay

ApplePay是一种移动支付技术，它能够让用户以一种便捷安全的方式为现实世界中购买的商品和服务付款。

关于相关App里的数字商品和服务，请参考[In-App Purchase Programming Guide](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/StoreKitGuide/Introduction.html#//apple_ref/doc/uid/TP40008267).

![](https://developer.apple.com/library/ios/ApplePay_Guide/Art/payment_intro_2x.png)
<!--more-->
##Apple Pay 工作流程

使用Apple Pay的APP需要在Xcode中开启Apple Pay capabilities这一项特殊的权限。你同样需要注册一个商业标示，并设置密钥；在给服务器发送支付信息时，这些密匙可以确保数据的安全传输。

To initiate a payment, your app creates a payment request. This request includes the subtotal for the services and goods purchased, as well as any additional charges for tax, shipping, or discounts. Pass this request to a payment authorization view controller, which displays the request to the user and prompts for any needed information, such as a shipping or billing address. Your delegate is called to update the request as the user interacts with the view controller.

发送一个付款,你的app创建一个付款请求,这个请求包括 所购买的服务和商品的合计, 也包括附加的税 打折,购物, 通过这个情节 给一个 付款授权视图控制器, 将要显示这个请求给送货 和 提示 任何需要的信息, 比如 购物和付款地址, 你的代理 被调用 更新 这个请求 用户交互 和这个视图控制器.

支付请求就是描述当前进行的购买操作，包括支付金额。你把支付请求发送给一个授权支付的视图控制器；该试图控制器呈现相关请求内容，并提示用户需要输入的信息，例如配送地址或者账单地址。接着，当用户与视图控制器交互，并提供新的支付信息时，APP会调用支付请求的委托，继续执行支付流程。


As soon as the user authorizes the payment, Apple Pay encrypts payment information to prevent an unauthorized third party from accessing it. On the device, Apple Pay sends the payment request to the Secure Element, which is a dedicated chip on the user’s device. The Secure Element adds the payment data for the specified card and merchant, creating an encrypted payment token. It then passes this token to Apple’s servers, where it is reencrypted using your Merchant Identifier certificate. Finally, the servers pass the token back to your app for processing.

一旦用户授权这个支付,Apple Pay就会加密支付信息 防止未授权第三方支付访问它.
在设备上,Apple Pay 发送 支付请求到 安全模块,这个模块就是用户设备专门的芯片.
这个安全模块添加指定银行卡和商家的支付信息数据,创建一个加密支付token.




Apple Pay会对支付信息进行加密处理，以防止未获授权的第三方获取用户的支付信息。你可以在自己的服务器上完成整个支付流程，也可以在自己的服务器上使用第三方支付平台来解码支付信息，并完成支付处理。

The payment token is never accessed or stored on Apple’s servers. The servers simply reencrypt the token using your certificate. This process lets your app securely encrypt the payment information without it having to distribute your Merchant Identifier certificate as part of the app.

关于Apple Pay安全性的更多信息, 请参考 [iOS Security Guide](https://www.apple.com/business/docs/iOS_Security_Guide.pdf).

In most cases, your app passes the encrypted payment token to a third-party payment platform to decrypt and process the payment. However, if your team has an existing payment infrastructure, you can decrypt and process the payment on your own server.

关于支持Apple Pay的支付平台信息，请参考[developer.apple.com/apple-pay/](https://developer.apple.com/apple-pay/)


#配置支付环境

一个商用ID标识可以帮助Apple Pay识别你，让你能够接受付款。在支付信息加密的过程中，把公匙和证书与ID标示关联起来进行加密是必不可少的一步。在APP使用Apple Pay之前，你首先得注册一个商用ID，并配置它的相关证书。

注册商用ID标示

>1.在开发者会员中心，选择“[Certificates，Identifiers&Profiles](http://developer.apple.com/account)”
 2.在Identifiers下，选择Merchant IDs
 3.在右上角点击"+"按钮
 4.在Description栏、ID栏输入相应信息，点击"Continue"
 5.浏览下配置参数，点击"Register"
 6.点击"Done"

为你的ID标示配置一个证书

>1.在开发者会员中心，选择"[Certificates，Identifiers&Profiles](http://developer.apple.com/account)" 
 2.在Identifiers下，选择Merchant IDs
 3.选择列表中的ID标示，点击Edit
 4.点击"Create Certificate"，按照指示获取或生成签名证书请求（CSR），点击"Continue"
 5.点击"Choose File",选择你的CSR，点击"Generate"
 6.点击"Download"下载证书，点击"Done"

如果KeyChain Access中显示了警示信息，表示未知授权签发证书或者无效证书发行人，那么要确保你已经在钥匙链中安装了WWDR中级证书-G2和Apple Root CA-G2。你可以在这个地方下载这些东西：[apple.com/certificateauthority](https://www.apple.com/certificateauthority/).

为了在Xcode中启用Apple Pay，打开APP工程文件的Capabilities面板。在Apple Pay这行将开关按钮设置为"ON"，接着选择APP需要使用的ID标示。

![](https://developer.apple.com/library/ios/ApplePay_Guide/Art/enable_apple_pay_2x.png)

>注意：在APP排错时，偶尔手动启用Apple Pay很管用。请按照以下步骤手动启用Apple Pay：
	1.在会员中心，选择Certificates，Identifiers& Profiles
	2.在Identifiers下，选择App IDs
	3.选择列表中的app ID，点击"Edit"
	4.选择 Apple Pay ，点击"Edit"
	5.选择你需要使用的ID标示，点击"Continue"
	6.浏览配置参数，点击"Assign"
	7.点击"Done"

#创建支付请求

创建支付请求

支付请求是[PKPaymentRequest](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/cl/PKPaymentRequest)类的实例，它的组成部分包括一个用来表示将要购买的项目的摘要，一个可用的配送方式列表，一个表示用户需要提供的配送信息的描述，以及一些商家和支付平台的信息。

##判定用户是否能够支付

在创建支付请求之前，要首先通过调用[PKPaymentAuthorizationViewController](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentAuthorizationViewController_Ref/index.html#//apple_ref/occ/cl/PKPaymentAuthorizationViewController) 类里的[canMakePaymentsUsingNetworks:](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentAuthorizationViewController_Ref/index.html#//apple_ref/occ/clm/PKPaymentAuthorizationViewController/canMakePaymentsUsingNetworks:)方法来判断用户是否能够使用你提供的支付网络进行支付。如果要判断用户的硬件是否支持Apple Pay或者是否因为家长控制而不能支付，请使用[canMakePayments](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentAuthorizationViewController_Ref/index.html#//apple_ref/occ/clm/PKPaymentAuthorizationViewController/canMakePayments) 方法。

If canMakePayments returns NO, the device does not support Apple Pay. Do not display the Apple Pay button. Instead, fall back to another method of payment.

If canMakePayments returns YES but canMakePaymentsUsingNetworks: returns NO, the device supports Apple Pay, but the user has not added a card for any of the requested networks. You can, optionally, display a payment setup button, prompting the user to set up his or her card. As soon as the user taps this button, initiate the process of setting up a new card (for example, by calling the [openPaymentSetup](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPassLibrary_Ref/index.html#//apple_ref/occ/instm/PKPassLibrary/openPaymentSetup) method).

Otherwise, as soon as the user presses the Apple Pay button, you must begin the payment authorization process. Do not ask the user to perform any other tasks before presenting the payment request. For example, if the user needs to enter a discount code, you must ask for the code before he or she presses the Apple Pay button.

NOTE

To create an Apple Pay–branded button for initiating payment request on iOS 8.3 or later, use the [PKPaymentButton](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentButton_Class/index.html#//apple_ref/occ/cl/PKPaymentButton) class. For iOS 8.2 or earlier, use the resources described in the [Apple Pay Identity Guidelines](https://developer.apple.com/apple-pay/Apple-Pay-Identity-Guidelines.pdf).

For additional guidelines on using Apple Pay buttons and payment marks, see [Apple Pay](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/ApplePay.html#//apple_ref/doc/uid/TP40006556-CH69) in [iOS Human Interface Guidelines](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/index.html#//apple_ref/doc/uid/TP40006556).


如果用户不能进行支付，那就不要显示支付按钮，相应的应该退回到其它支付方式。


Bridging from Web-Based Interfaces

If your app uses a web-based interface for purchasing goods and services, you must move the request from the web interface to native iOS code before processing an Apple Pay transaction. Listing 3-1 shows the steps needed to process requests from a web view.

Listing 3-1Buying items from a web view
// Called when the web view tries to load "myShoppingApp:buyItem"
-(void)webView:(nonnull WKWebView *)webView
decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction
decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler {
 
    // Get the URL for the selected link.
    NSURL *URL = navigationAction.request.URL;
 
    // If the scheme and resource specifier match those defined by your app,
    // handle the payment in native iOS code.
    if ([URL.scheme isEqualToString:@"myShoppingApp"] &&
        [URL.resourceSpecifier isEqualToString:@"buyItem"]) {
 
        // Create and present the payment request here.
 
        // The web view ignores the link.
        decisionHandler(WKNavigationActionPolicyCancel);
    }
 
    // Otherwise the web view loads the link.
    decisionHandler(WKNavigationActionPolicyAllow);
}



##支付请求包含货币和地区信息

所有的汇总金额应该使用同一种货币，货币的信息可使用PKPaymentRequest类的[currencyCode](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/currencyCode)属性进行指定。像"USD"这样，使用3个字符格式的ISO货币编码。

一个支付请求里的国家代码表示了这次购买发生的国家或者将要在这个国家处理这次支付。像"US"这样，使用2个字符格式的ISO国家编码。

在支付请求里指定的商用ID必须匹配应用中指定的商用ID列表之一。

	request.currencyCode = @"USD";
	request.countryCode  = @"US";
	request.merchantIdentifier = @"merchant.com.example";

##支付请求包含一个支付摘要项目的列表

支付摘要项目，属于[PKPaymentSummaryItem](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentSummaryItem_Ref/index.html#//apple_ref/occ/cl/PKPaymentSummaryItem) 类，描述了支付请求的不同部分。在一个支付请求里不要使用太多的摘要项目---典型的项目像比如小计金额、折扣信息、配送信息、含税信息以及总计金额等。如果你想要提供更详细的支付项目列表，可以在你应用的其它地方提供。

每一个摘要项目会有一个标签和数额，就像在代码列表3-1中显示的那样。标签文本是一个用户可阅读的摘要项目描述信息，数额是相对应的支付数额。在一个支付请求中所有的数额都要使用在这个请求中指定的货币。对于折扣或优惠券，则需要把数额设成负数。

Listing 3-2创建支付项目


// 12.75 subtotal
NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];
self.subtotal = [PKPaymentSummaryItem summaryItemWithLabel:@"Subtotal" amount:subtotalAmount];
  
// 2.00 discount
NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithMantissa:200 exponent:-2 isNegative:YES];
self.discount = [PKPaymentSummaryItem summaryItemWithLabel:@"Discount" amount:discountAmount];
>注意:
这里使用[NSDecimalNumber](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSDecimalNumber_Class/index.html#//apple_ref/occ/cl/NSDecimalNumber)类来存储摘要项目的数额，它是一个以10为底数的数值。可以使用指定尾数和指数的方式（像代码中那样）来创建这个类的实例，也可以通过指定字符串和locale来实例化，字符串指定了相应的数值。这里总是使用以10为底数的数值来做财务计算--例如当需要计算5%折扣掉的金额时。

尽管有时使用其它的计数方法更方便，但是像float或者Double这样的IEEE浮点数类型是不适合作财务计算的，这些数据类型使用的是以2为底数的数值表示方法，这就表示有一些十进制数值不能准确得被表示--例如0.42必须以0.41999这样的循环小数来近似表示，而这种近似表示常常会造成财务计算的错误结果。

在这个摘要项目列表中的最后一个是总计金额。这个金额是通过把所有其它金额相加而得到。总计的显示方法和其它的摘要项目不同：应该使用你公司的名称做为其标签，使用所有其它项目的金额总和做为金额。使用paymentSummaryItems 属性将这些摘要项目加入支付请求。

	// 10.75 grand total
	NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
	totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
	totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
	self.total = [PKPaymentSummaryItem summaryItemWithLabel:@"My Company Name" amount:totalAmount];
	self.summaryItems = @[self.subtotal, self.discount, self.total];
	request.paymentSummaryItems = self.summaryItems;

##配送方式是一种特殊的摘要项目

对于每一种可用的配送方式创建一个[PKShippingMethod](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKShippingMethod_Ref/index.html#//apple_ref/occ/cl/PKShippingMethod)的实例。就像其它支付摘要项目一样，配送方式包含用户易于辨别的标签，比如"标准配送"或者"第二天配送"，还有一个金额来表示配送费用。与其它摘要项目不同的是，配送方式还有一个[detail](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKShippingMethod_Ref/index.html#//apple_ref/occ/instp/PKShippingMethod/detail)属性--像"7月29日到达"或者"24小时之内配送"等--可以用来解释各个配送方式之间的区别。

使用[identifier](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKShippingMethod_Ref/index.html#//apple_ref/occ/instp/PKShippingMethod/identifier)属性来在代理方法中区分不同的配送方式，这个属性只会在你的应用内使用--框架看不到这个属性，并且它也不会出现在UI中。在创建配送方式时为其分配一个独一无二的标识符。为了方便调试，可使用文本缩写，比如"discount", "standard", 或者 "next-day".

有一些配送方式在某些地区可能不适用，或者有不同的价格，你可以在用户选择配送地址或配送方式的代理方法时更新这些信息，就像[Your Delegate Updates Shipping Methods and Costs](https://developer.apple.com/library/ios/ApplePay_Guide/Authorization.html#//apple_ref/doc/uid/TP40014764-CH4-SW2)描述的一样。

##指定你支持的支付方式

通过在[supportedNetworks](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/supportedNetworks)属性中填入字符串常量数组来指定你支持的支付网络。通过指定[merchantCapabilities](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/merchantCapabilities)属性来指定你支持的支付处理标准，3DS支付方式是必须支持的，EMV方式是可选的。

商家支持的支付处理标准使用标识位来进行组合，像下面这样：


	request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
	// Supports 3DS only
	request.merchantCapabilities = PKMerchantCapability3DS;
	// Supports both 3DS and EMV
	request.merchantCapabilities = PKMerchantCapability3DS | PKMerchantCapabilityEMV;

##指示所需配送信息和账单信息

通过填充 [requiredBillingAddressFields](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/requiredBillingAddressFields) 和 [requiredShippingAddressFields](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/requiredShippingAddressFields)属性来指定所需账单信息和配送地址信息。当你显示一个视图控制器时，它会提示用户输入所需内容。这些字段常量可以像下面这样进行组合来设置这些属性：


	request.requiredBillingAddressFields = PKAddressFieldEmail;
	request.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;

如果你已经有了用户的账单和配送信息，可以直接在支付请求中使用它们。但是尽管Apple Pay默认使用了这些信息，用户仍然可以在授权支付的过程中修改这些信息。


	ABRecordRef record = ABPersonCreate();
	CFErrorRef error;
	BOOL success;
	success = ABRecordSetValue(record, kABPersonFirstNameProperty, @"John", &error);
	if (!success) { /* ... handle error ... */ }
	success = ABRecordSetValue(record, kABPersonLastNameProperty, @"Appleseed", &error);
	if (!success) { /* ... handle error ... */ }
	ABMultiValueRef shippingAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
	NSDictionary *addressDictionary = @{
	(NSString *) kABPersonAddressStreetKey: @"1234 Laurel Street",
	(NSString *) kABPersonAddressCityKey: @"Atlanta",
	(NSString *) kABPersonAddressStateKey: @"GA",
	(NSString *) kABPersonAddressZIPKey: @"30303"
	};
	ABMultiValueAddValueAndLabel(shippingAddress,
	(__bridge CFDictionaryRef) addressDictionary, kABOtherLabel,nil);
	success = ABRecordSetValue(record, kABPersonAddressProperty, shippingAddress, &error);
	if (!success) { /* ... handle error ... */ }
	request.shippingAddress = record;
	CFRelease(shippingAddress);
	CFRelease(record);

存储额外信息

使用[applicationData](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentRequest_Ref/index.html#//apple_ref/occ/instp/PKPaymentRequest/applicationData)属性来存储一些在你的应用中关于这次支付请求的唯一标识信息，比如一个购物车的标识符。在用户授权支付之后，这个属性的哈希值会出现在这次支付的token中。

#授权支付

支付授权过程是由支付授权view controller和它的代理协作完成的。支付授权view controller做了两件事情：它让用户选择支付请求所必需的账单和配送信息，还有让用户最终授权同意这次支付。当用户和view controller交互时，代理方法就会被调用，这样你的应用就可以不断地更新显示的信息--例如在配送地址更改后更新配送费用。用户最终授权支付请求之后代理方法同样也会被调用。

>注意：在实现这些方法时注意，这些方法可能会被多次调用，而它们被调用的顺序取决于用户的行为的顺序。

在所有这个授权过程中被调用的代理方法中，都会有一个completion block被做为参数之一传入，支付授权view controller会在一个代理方法执行完毕（通过调用completion块）后再调用另一个代理方法。唯一的例外是[paymentAuthorizationViewControllerDidFinish:](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentAuthorizationViewControllerDelegate_Ref/index.html#//apple_ref/occ/intfm/PKPaymentAuthorizationViewControllerDelegate/paymentAuthorizationViewControllerDidFinish:)方法：它不包含completion block，所以它可以在任何时候被调用。

这个completion block有一个传入参数，基于现有的可用信息，你可以通过这个参数并指定这次交易的状态。如果这次交易没有任何问题，传入PKPaymentAuthorizationStatusSuccess，否则，你要传入一个识别问题的值。

通过在[PKPaymentAuthorizationViewController](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PKPaymentAuthorizationViewController_Ref/index.html#//apple_ref/occ/cl/PKPaymentAuthorizationViewController)类的构造方法中传入一个支付请求来对它进行实例化，然后给这个视图控制器设置一个代理，就可以把它展示给用户了。


	PKPaymentAuthorizationViewController *viewController = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
	if (!viewController) { /* ... Handle error ... */ }
	viewController.delegate = self;
	[self presentViewController:viewController animated:YES completion:nil];

当用户与这个视图控制器进行交互时，它的代理方法会被调用。

通过代理更新配送方式和费用

当用户提供配送信息之后，授权view controller 会调用paymentAuthorizationViewController:didSelectShippingAddress:completion: 和 paymentAuthorizationViewController:didSelectShippingMethod:completion:这两个代理方法。在这两个方法中根据最新信息来更新支付请求。

	
    - (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                   didSelectShippingAddress:(ABRecordRef)address
                                 completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *, NSArray *))completion
	{
    	self.selectedShippingAddress = address;
    	[self updateShippingCost];
    	NSArray *shippingMethods = [self shippingMethodsForAddress:address];
    	completion(PKPaymentAuthorizationStatusSuccess, shippingMethods, self.summaryItems);
	}
  
    - (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                    didSelectShippingMethod:(PKShippingMethod *)shippingMethod
                                 completion:(void (^)(PKPaymentAuthorizationStatus, NSArray *))completion
	{
    	self.selectedShippingMethod = shippingMethod;
    	[self updateShippingCost];
    	completion(PKPaymentAuthorizationStatusSuccess, self.summaryItems);
	}

当支付被授权后，支付token会被创建

当用户最终授权了一个支付请求，框架会通过与苹果服务器和嵌入在设备中的一个安全模块进行通信，生成一个支付token。然后你在paymentAuthorizationViewController:didAuthorizePayment:completion:方法中将这个token和其它一些你需要用来处理这次购买的信息--例如配送地址和购物车标识--发送给你的服务器。这个过程是这样的：

框架发送支付请求给安全模块，只有安全模块可以访问存储在设备上的标记化的卡信息。
安全模块把特定的卡和商家等支付数据加密，以保证只有苹果可以读取，然后发送给框架。框架会将这些数据发送给苹果。
苹果服务器再次加密这些支付数据，以保证只有商家可以读取。然后服务器对它进行签名，生成支付token，然后发送给设备。
框架调用相应的代理方法并传入这个token，然后你的代理方法传送token给你的服务器。
至于你的服务器采取的行为要取决于你是自己处理这次支付或者你是和其它支付平台合作来进行支付处理。不管怎样，你的服务器处理这个订单然后传送一个状态信息给设备，代理方法会把这个状态信息传送给completion块，像在“Processing a Payment”中讨论过的。

    
    - (void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
	didAuthorizePayment:(PKPayment *)payment
	completion:(void (^)(PKPaymentAuthorizationStatus))completion
	{
	NSError *error;
	ABMultiValueRef addressMultiValue = ABRecordCopyValue(payment.billingAddress, kABPersonAddressProperty);
	NSDictionary *addressDictionary = (__bridge_transfer NSDictionary *) ABMultiValueCopyValueAtIndex(addressMultiValue, 0);
	NSData *json = [NSJSONSerialization dataWithJSONObject:addressDictionary options:NSJSONWritingPrettyPrinted error: &error];
	// ... Send payment token, shipping and billing address, and order information to your server ...
	PKPaymentAuthorizationStatus status;  // From your server
	completion(status);
	}
在代理方法中释放授权View Controller

在框架显示交易状态之后，授权View Controller会调用代理paymentAuthorizationViewControllerDidFinish:的方法。在这个方法的实现中，先释放授权页面控制器再显示你自己的订单确认页面。


    - (void) paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
	{
	[controller dismissViewControllerAnimated:YES completion:nil];
	}

#支付处理

处理一个支付请求涉及以下几个步骤：

>1.把支付信息，以及支付流程+所需的其他信息，一起发送给你的服务器。
 2.验证支付数据的哈希表和签名
 3.为加密过的支付数据解码
 4.向支付处理系统提交支付数据
 5.向订单追踪系统提交订单

处理支付请求时，你有两个选择；你既可以利用支付平台处理支付请求，也可以自己实现支付请求处理流程。一个常用的支付平台可以完成上述大部分操作。

读取，验证，以及处理支付信息需要有一定的相关密码知识，例如计算SHA-1哈希表，读取和验证PKCS#7签名，执行Elliptic Curve Diffie-Hellman密匙交换。如果没有一定的密码学背景，你可以考虑使用第三方支付平台来完成这些操作。

关于支持Apple Pay支付平台的更多信息，请参考[developer.apple.com/apple-pay/](https://developer.apple.com/apple-pay/)

处理支付请求所用的信息拥有一种嵌套式的数据结构，如下图。支付令牌是PKPaymentToken类的实例。其paymentData属性值是一个JSON词典，它的头文件信息可以用来验证和加密支付数据。加密过的数据信息包括支付金额、持卡人姓名，以及一些其他指定的支付处理协议。



![Figure 5-1 Payment数据结构](https://developer.apple.com/library/ios/ApplePay_Guide/Art/payment_data_structure_2x.png)

关于支付数据结构格式的详细信息，请参看：[Payment Token Format Reference](https://developer.apple.com/library/ios/documentation/PassKit/Reference/PaymentTokenJSON/PaymentTokenJSON.html#//apple_ref/doc/uid/TP40014929).
