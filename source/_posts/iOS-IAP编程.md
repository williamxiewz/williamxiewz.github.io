---
title: iOS IAP编程
date: 2016-08-08 23:00:04
categories: iOS SDK
tags: IAP
---

#协议

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap1.png)
<!-- more -->
![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap2.jpg)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap3.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap4.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap5.png)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap6.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap7.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap8.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap9.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap10.png)


![CNAPS CODE 查询地址](https://e.czbank.com/CORPORBANK/query_unionBank_index.jsp)

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap11.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap12.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap13.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap14.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap15.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap16.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap17.jpg)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap18.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap19.png)


#创建内购项目

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap20.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap21.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap22.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap23.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap24.png)



![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap25.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap26.png)


#添加内购项目测试账号

![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap27.png)


![](https://github.com/williamxiewz/williamxie-github-io/raw/master/appledeveloperiap28.png)





#实现代码

```swift
首先导入StoreKit.framework库

.h文件

#define kSandboxVerifyURL @"https://sandbox.itunes.apple.com/verifyReceipt" //开发阶段沙盒验证URL
#define kAppStoreVerifyURL @"https://buy.itunes.apple.com/verifyReceipt" //实际购买验证URL
#import <StoreKit/StoreKit.h>




enum{
    IAP0p20=20,
	IAP1p100,
	IAP4p600,
	IAP9p1000,
	IAP24p6000,
}buyCoinsTag;





//代理
@interface RechargeVC : UIViewController <SKPaymentTransactionObserver,SKProductsRequestDelegate >
{
int buyType;}

- (void) requestProUpgradeProductData;

-(void)RequestProductData;

-(void)buy:(int)type;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;


-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction;


- (void) completeTransaction: (SKPaymentTransaction *)transaction;


- (void) failedTransaction: (SKPaymentTransaction *)transaction;


-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction;


-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error;



- (void) restoreTransaction: (SKPaymentTransaction *)transaction;


-(void)provideContent:(NSString *)product;


-(void)recordTransaction:(NSString *)product;


@end
.m文件

#import "RechargeVC.h"


//在内购项目中创的商品单号
#define ProductID_IAP0p20 @"Nada.JPYF01"//20
#define ProductID_IAP1p100 @"Nada.JPYF02" //100
#define ProductID_IAP4p600 @"Nada.JPYF03" //600
#define ProductID_IAP9p1000 @"Nada.JPYF04" //1000
#define ProductID_IAP24p6000 @"Nada.JPYF05" //6000



@interface RechargeVC ()

@end


@implementation RechargeVC


- (void)viewDidLoad {

    [super viewDidLoad];

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self buy:IAP0p20];

}


-(void)buy:(int)type
{
    buyType = type;
    if ([SKPaymentQueue canMakePayments]) {
    [self RequestProductData];
    NSLog(@"允许程序内付费购买");
}
else
{
    NSLog(@"不允许程序内付费购买");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
    message:@"您的手机没有打开程序内付费购买"
    delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

    [alerView show];


    }
}

-(void)RequestProductData
{
    NSLog(@"---------请求对应的产品信息------------");
    NSArray *product = nil;
    switch (buyType) {
        case IAP0p20:
        product=[[NSArray alloc] initWithObjects:ProductID_IAP0p20,nil];
        break;
        case IAP1p100:
        product=[[NSArray alloc] initWithObjects:ProductID_IAP1p100,nil];
        break;
        case IAP4p600:
        product=[[NSArray alloc] initWithObjects:ProductID_IAP4p600,nil];
        break;
        case IAP9p1000:
        product=[[NSArray alloc] initWithObjects:ProductID_IAP9p1000,nil];
        break;
        case IAP24p6000:
        product=[[NSArray alloc] initWithObjects:ProductID_IAP24p6000,nil];
        break;

        default:
        break;
}
NSSet *nsset = [NSSet setWithArray:product];
SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];

request.delegate=self;
[request start];

}

//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{

    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", (int)[myProduct count]);
    // populate UI
    for(SKProduct *product in myProduct){
    NSLog(@"product info");
    NSLog(@"SKProduct 描述信息%@", [product description]);
    NSLog(@"产品标题 %@" , product.localizedTitle);
    NSLog(@"产品描述信息: %@" , product.localizedDescription);
    NSLog(@"价格: %@" , product.price);
    NSLog(@"Product id: %@" , product.productIdentifier);
}
SKPayment *payment = nil;
switch (buyType) {
        case IAP0p20:
        payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP0p20];    //支付25
        break;
        case IAP1p100:
        payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP1p100];    //支付108
        break;
        case IAP4p600:
        payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP4p600];    //支付618
        break;
        case IAP9p1000:
        payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP9p1000];    //支付1048
        break;
        case IAP24p6000:
        payment  = [SKPayment paymentWithProductIdentifier:ProductID_IAP24p6000];    //支付5898
        break;
        default:
        break;
}
NSLog(@"---------发送购买请求------------");
[[SKPaymentQueue defaultQueue] addPayment:payment];

}
- (void)requestProUpgradeProductData
{
    NSLog(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];

}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
    delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];

}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");

}

-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
}

//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:{//交易完成
            [self completeTransaction:transaction];
            NSLog(@"-----交易完成 --------");
            //购买成功后进行验证
            [self verifyPurchaseWithPaymentTransaction];

        } break;
        case SKPaymentTransactionStateFailed://交易失败
            { [self failedTransaction:transaction];
            NSLog(@"-----交易失败 --------");
            UIAlertView *alerView2 =  [[UIAlertView alloc] initWithTitle:@"提示"
            message:@"购买失败，请重新尝试购买"
            delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

            [alerView2 show];

        }break;
        case SKPaymentTransactionStateRestored://已经购买过该商品
            [self restoreTransaction:transaction];
            NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
            NSLog(@"-----商品添加进列表 --------");
            break;
            default:
            break;
        }
    }
}

/**
*  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
*
*/
-(void)verifyPurchaseWithPaymentTransaction{
    //从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];

    NSString *receiptString=[receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串

    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    //创建请求到苹果官方进行购买验证
    NSURL *url=[NSURL URLWithString:kSandboxVerifyURL];
    NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody=bodyData;
    requestM.HTTPMethod=@"POST";
    //创建连接并发送同步请求
    NSError *error=nil;
    NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        return;
    }
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if([dic[@"status"] intValue]==0){
        NSLog(@"购买成功！");
        NSDictionary *dicReceipt= dic[@"receipt"];
        NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
        NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
        //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        if ([productIdentifier isEqualToString:kProductID3]) {
            int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
        }else{
            [defaults setBool:YES forKey:productIdentifier];
        }
        [self.tableView reloadData];
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
    }else{
        NSLog(@"购买失败，未通过验证！");
    }
}

- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {

    NSArray *tt = [product componentsSeparatedByString:@"."];
    NSString *bookid = [tt lastObject];
    if ([bookid length] > 0) {
    [self recordTransaction:bookid];
    [self provideContent:bookid];
}
}

    // Remove the transaction from the payment queue.

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"失败");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {

    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{

}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@" 交易恢复处理");

}

-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
}

#pragma mark connection delegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
        break;
        case 304:
        break;
        case 400:
        break;
        case 404:
        break;
        case 416:
        break;
        case 403:
        break;
        case 401:
        case 500:
        break;
        default:
        break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听

}

@end
```
