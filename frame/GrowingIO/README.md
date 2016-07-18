请选择安装方式:手动安装方式
1. 下载 iOS SDK, 解压缩并拷贝到您代码的工程目录里
2. 将解压缩后的 Growing.h 和 libGrowing.a 添加到您的工程中
3. 添加依赖项目
libsqlite3.tbd:用于临时缓存日志
libicucore.tbd:用于解析页面内容
CoreTelephony.framework:用于读取运营商名称
SystemConfiguration.framework:用于判断网络状态
Security.framework:使App可以使用安全连接与服务器通信
Foundation.framework:基础依赖库

4. 添加编译参数
5. 初始化 GrowingIO，在您的 AppDelegate.m 中添加
#import "Growing.h"
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {      
    ...      
    // 启动GrowingIO
    [Growing startWithAccountId:@"944396c52dd53e96"];// 其他配置      
    // 开启Growing调试日志 可以开启日志      
    // [Growing setEnableLog:YES];  
}
6. 添加 URL Scheme
添加 URL scheme growing.e4f2c8e956c4030e 可以方便您唤醒 App 进行圈选。
7. 添加激活圈选的代码
因为您代码的复杂程度以及iOS SDK的版本差异，有时候 [Growing handleUrl:url] 并没有被调用。请在各个平台上调试这段代码，确保当App被URL scheme唤醒之后，该函数能被调用到。
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    ...
    if ([Growing handleUrl:url]) { // 请务必确保该函数被调用    
        return YES;    
    }    
    return NO;
}
8. 其他配置项
采集 Banner 统计数据收起
UIView *view;…view.growingAttributesValue = @"BannerID";其中 view 是您的Banner元素，@"BannerID"是这个Banner的唯一ID。请确保响应点击的控件，与设置ID的控件是同一个。
用户自定义维度收起
GrowingIO 的数据分析工具本身提供了例如 “访问来源”，“关键字”，“城市”,“操作系统"，”浏览器“等等这些维度。这些维度都可以和用户创建的指标进行多维的分析。但是往往不能满足用户对数据多维度分析的要求，因为每个公司的产品都有各自的用户维度，比如客户所服务的公司，用户正在使用的产品版本等等。GrowingIO 为了能够让数据分析变得更加的灵活，我们在 SDK 中提供了用户自定义维度的API接口:
[Growing setCS1Value:@"CS1的Value" forKey:@"CS1的Key"];    
[Growing setCS2Value:@"CS2的Value" forKey:@"CS2的Key"];    
[Growing setCS3Value:@"CS3的Value" forKey:@"CS3的Key"];    
...    
[Growing setCS5Value:@"CS10的Value" forKey:@"CS10的Key"];
在 SDK 中，我们总计支持上传 10 个自定义维度 CS1 - CS10，所有 CS 属性都必须是用户的属性，不能是订单 ID，商品ID 等和用户没有确定的关联关系的属性。其中：
CS1 字段：在 GrowingIO 系统中用于识别注册用户的身份，因此 CS1 的value 必须填写用户的唯一身份标示 ID；

CS2 字段：在 GrowingIO 系统中用于识别 SaaS 客户的租户，因此所有的 SaaS 用户必须填写租户的唯一身份标示 ID，非 SaaS 用户不做限定；

对于未登录的用户，不要设置 CS1 及其他 CS 属性 ;

对于无值的 CS 属性，可以不设置，或者设置成您认为有意义的值；

CS 设置在各个平台必须保持一致；
如下例子中，总计上传 4 个用户属性，分别是：
CS1: user_id:100324
CS2: company_id:943123
CS3: user_name:王同学
CS4: company_name:GrowingIO
CS5: sales_name:销售员小王
-(void)viewWillAppear{    
    [super viewWillAppear];
    [Growing setCS1Value:@"100324" forKey:@"user_id"];    
    [Growing setCS2Value:@"943123" forKey:@"company_id"];    
    [Growing setCS3Value:@"王同学" forKey:@"user_name"];    
    [Growing setCS4Value:@"GrowingIO" forKey:@"company_name"];    
    [Growing setCS5Value:@"销售员小王" forKey:@"sales_name"];  
}
对于CS1字段设置时机的说明基本原则
当 App 使用者的登录状态改变时设置 CS1 字段的值

设置后，在下一次任意 Activity.onResume 被调用时，新的 CS1 字段的值才会被发送

在 CS1 字段的值被发送前，重复设值会导致新的值取代旧的，旧值会被丢弃
在以下情况下，需要注意如何设置 CS1 字段
用户手动登录：如果有多个登录入口，在每一个入口登录成功后，都需要调用 GrowingIO.setCS1 来设置用户的唯一标识；如果有第三方登录，成功登录后需要调用 GrowingIO.setCS1 方法；
自动登录：App 启动时，自动登录或者用户默认是登录状态，也需要调用 GrowingIO.setCS1 方法；
注册：有的 App 注册成功后，默认登录，这种情况下也需要调用 GrowingIO.setCS1 方法；
退出：退出登录时，需要把 CS1 字段置空，传""或者 null 都可以
其他 CS 字段遵循相似的设置方法
在上传成功之后，请联系在线客服，我们会为您配置并且激活相应的属性字段