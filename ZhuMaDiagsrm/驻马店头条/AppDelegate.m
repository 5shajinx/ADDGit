//
//  AppDelegate.m
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/5.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "AppDelegate.h"
#import "ZMDNNavViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ZMDNGuideViewController.h"
#import "ZMDNMainViewController.h"
#import "ZMDNPicContentViewController.h"
#import "WEBVIEWController.h"
#import "ZMDPlayerViewController.h"
#import "ZhengKuTableViewController.h"


#import "Demo2ViewController.h"

#import "AdvertiseView.h"

#import "ZBDTTableViewController.h"
#import "hudongViewController.h"
#import "JRSegmentViewController.h"

#import "YinPinViewController.h"

#import "CustomPagerController.h"
#import "NewsDetailsTableviewController.h"
//推送
#import "JPUSHService.h"

//分享
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

#import "CustomButton.h"
#import <AdSupport/AdSupport.h>
#import <Foundation/Foundation.h>//UUId

#import <ifaddrs.h>
#import <arpa/inet.h>
#import "AppUntils.h"
#import "ZMDZBViewController.h"
#import "ZMDDSViewController.h"

#import "ZMDZhiBoCenterViewController.h"
#import "ZMDShiPinViewController.h"
#import "ZMDPicTextZBViewController.h"
#import "ZMDZBRoomViewController.h"

//static NSString * const jpushAppKey = @"b4be396b01968b6b43d682e3";
static NSString * const jpushAppKey = @"70ec5f18a7325078ffa99616";

static NSString * const channel = @"01a81b8f100460ad2b082dd5";
//static NSString * const channel = @"7a41b44ef2a3c9963100a9b0";


static BOOL isProduction = FALSE;


@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
    NSString *currentVersion;
    
}


@property(nonatomic, strong) ZMDNNavViewController *nav;
@property (strong, nonatomic) UIView *lunchView;
@property (strong, nonatomic) NSString *biaoji;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [self location];
    [AppUntils  saveUUIDToKeyChain];
    [self UUID];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    //Required
    
    [JPUSHService setupWithOption:launchOptions appKey:jpushAppKey channel:channel apsForProduction:isProduction];
    
     [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    /**
     * 分享，注册友盟
     */
    
    [UMSocialData setAppKey:@"578edd6767e58e046b002091"];
    //微信分享
    [UMSocialWechatHandler setWXAppId:@"wxfcaae8b9f7ff28a8" appSecret:@"c523b827ba147c2236cb8cb605b6618f" url:@"http://www.umeng.com/social"];
    
    
    //第一个参数为新浪appkey,第二个参数为新浪secret，第三个参数是新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1861293897" secret:@"da7455aab06259f05bd2a6050e03c970" RedirectURL:@"http://open.weibo.com/apps/1861293897/privilege/oauth"];
    
    
    //qq和qq空间
    [UMSocialQQHandler setQQWithAppId:@"1106052162" appKey:@"AfZPCO0YLkiPlfSw" url:@"http://www.umeng.com/social"];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
     
    [self.window makeKeyAndVisible];
    
    
    [[Manager sharedManager] panduanjincikugengxin];
    
   
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //当前版本号
    currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];


    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"newversion.text"];
    NSString *newversion = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
        
    if (![newversion isEqualToString:currentVersion]){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"zhuyeCasher"];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSError *err;
        [fileMgr removeItemAtPath:filewebCaches error:&err];
//        NSLog(@"%@-------%@",newversion,currentVersion);
        
        
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"newversion.text"];
        NSString *st = [infoDic objectForKey:@"CFBundleShortVersionString"];
        [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [Manager sharedManager].firstQiDong = @"diyici";
        [self mainKuangJiaTwo];
       
    }
    else
    {
        [Manager sharedManager].firstQiDong = @"nil";
        [self mainKuangJia];
        
    }
    
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {// 图片存在
        AdvertiseView *advertiseView = [[AdvertiseView alloc] initWithFrame:self.window.bounds];
        advertiseView.filePath = filePath;
        [advertiseView show];
    }
    
    [self lodAD];
    
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@\\%@",
                    userAgent,
                    @"zmdtvw-ios"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
#if !__has_feature(objc_arc)
   
#endif

  
    
    return YES;
}


-(void) UUID {
    //获取UUID作为唯一标示符来使用.
  NSString *UUID = [AppUntils readUUIDFromKeyChain];
[Manager sharedManager].adIdString = [NSString stringWithFormat:@"%@",UUID];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
  
    application.applicationIconBadgeNumber = 0;

    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;

}







- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"qt",@"fm",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"qtfm" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}






- (NSUInteger )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
    {
    if (_allowRotation == 1) {
        return UIInterfaceOrientationMaskAll;
    }else
    {
        return (UIInterfaceOrientationMaskPortrait);
    }
}
// 支持设备自动旋转
- (BOOL)shouldAutorotate{
    if (_allowRotation == 1) {
        return YES;
    }
    return NO;
}



- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return  [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options{
    [UMSocialSnsService handleOpenURL:url];
    
    NSString *typeString = [url.query substringWithRange:NSMakeRange(5,1)];
    NSString *idString = [url.query substringFromIndex:10];
    
    if ([url.host isEqualToString:@"news"]){
        if ([typeString isEqualToString:@"0"] || [typeString isEqualToString:@"1"] || [typeString isEqualToString:@"2"] || [typeString isEqualToString:@"3"]) {
            
            NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
            [Manager sharedManager].jinru = @"jinruwebview";
            //webCtrol.userpicture = [NSString stringWithFormat:@"%@",recommend.ar_userpic];
            webCtrol.type =[NSString stringWithFormat:@"%@",typeString];
            webCtrol.idString =[NSString stringWithFormat:@"%@",idString];
           // webCtrol.ar_cateid =[NSString stringWithFormat:@"%@",string];
            webCtrol.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [_nav presentViewController:na animated:YES completion:nil];
        }
    }else if([url.host isEqualToString:@"pic"]){
        if ([typeString isEqualToString:@"5"]) {
            
            ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
//            picContentVc.manyPicLink = htmlUrl;
//            picContentVc.sharetitle  = content;
            picContentVc.typeString = typeString;
            picContentVc.idString = idString;
            picContentVc.shareBiaoji = @"biaoji";
            picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [_nav presentViewController:picContentVc animated:YES completion:nil];
        }
    }else {
        if ([typeString isEqualToString:@"4"]) {
            NSString *getoneString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",idString,typeString];
            [self loadTheMovieUrlWithMovieUrl:getoneString withTitle:@""];
        }
    }
   
    return YES;
}


- (void)mainKuangJia
{
   // CustomPagerController   *navition   = [[CustomPagerController alloc]init];
    
    ZMDNMainViewController *mainVC =  [[ZMDNMainViewController alloc] init];
    _nav = [[ZMDNNavViewController alloc] initWithRootViewController:mainVC];
      //视听
    ZMDZBViewController *ZhiBovc = [[ZMDZBViewController alloc] initWithAddVCARY:@[[CustomPagerController new],[YinPinViewController new],[ZMDDSViewController new]] TitleS:@[@"电视点播",@"广播直播",@"电视直播"]];
    UINavigationController *ZhiBonav = [[UINavigationController alloc] initWithRootViewController:ZhiBovc];
    
    
    
    //新直播
    ZMDZhiBoCenterViewController *newvc = [[ZMDZhiBoCenterViewController alloc] initWithAddVCARY:@[[ZMDShiPinViewController new],[ZMDPicTextZBViewController new],[ZMDZBRoomViewController new]] TitleS:@[@"视频直播",@"图文直播",@"直播间"]];
    //新直播
   // ZMDZhiBoCenterViewController *newvc = [[ZMDZhiBoCenterViewController alloc] initWithAddVCARY:@[[ZBDTTableViewController new],[ZBDTTableViewController new],[ZMDZBRoomViewController new]] TitleS:@[@"视频直播",@"图文直播",@"直播间"]];
    UINavigationController *nzhiboav = [[UINavigationController alloc] initWithRootViewController:newvc];
    
    
   // ZhengKuTableViewController *zhengku = [[ZhengKuTableViewController alloc]init];
  //   UINavigationController *nazhengku = [[UINavigationController alloc]initWithRootViewController:zhengku];
    
    Demo2ViewController *zhengwu = [[Demo2ViewController alloc]init];

  
//互动
    hudongViewController *hudong = [[hudongViewController alloc]init];
    UINavigationController *nazhengVC= [[UINavigationController alloc]initWithRootViewController:hudong];
    
   nazhengVC.tabBarItem.title = @"民生";
    nazhengVC.tabBarItem.image = [UIImage imageNamed:@"minshengss"];
    
    nazhengVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);

    
    //TabBarController
    UITabBarController *tabbarcontroller = [[UITabBarController alloc]init];
    tabbarcontroller.viewControllers = @[ZhiBonav,zhengwu,_nav,nzhiboav,nazhengVC];
    tabbarcontroller.tabBar.barTintColor = [UIColor clearColor];
    tabbarcontroller.selectedIndex = 2;
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    [tabbarcontroller.tabBar setBackgroundImage:[UIImage new]];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW,49+5)];
    lable.backgroundColor = [UIColor whiteColor];
    [tabbarcontroller.tabBar addSubview:lable];
    [tabbarcontroller.tabBar sendSubviewToBack:lable];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW, 1)];
    lab.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [tabbarcontroller.tabBar addSubview:lab];
    
    for (UIBarItem *item in tabbarcontroller.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        tabbarcontroller.tabBar.tintColor = [UIColor redColor];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:[UIColor redColor] forKey:NSBackgroundColorAttributeName];
        [item setTitleTextAttributes:dict forState:UIControlStateSelected];
    }
    
    
    
    
    self.window.rootViewController = tabbarcontroller;
    
}

- (void)mainKuangJiaTwo
{
    
  //  CustomPagerController   *movie   = [[CustomPagerController alloc]init];
    
   //新直播
 //   ZMDZBViewController *newvc = [[ZMDZBViewController alloc] initWithAddVCARY:@[[ZBDTTableViewController new],[YinPinViewController new],[ZMDDSViewController new]] TitleS:@[@"云直播",@"广播",@"电视"]];
 
    //新直播
    ZMDZhiBoCenterViewController *newvc = [[ZMDZhiBoCenterViewController alloc] initWithAddVCARY:@[[ZMDShiPinViewController new],[ZMDPicTextZBViewController new],[ZMDZBRoomViewController new]] TitleS:@[@"视频直播",@"图文直播",@"直播间"]];
    
    //新直播
   // ZMDZhiBoCenterViewController *newvc = [[ZMDZhiBoCenterViewController alloc] initWithAddVCARY:@[[ZBDTTableViewController new],[ZBDTTableViewController new],[ZMDZBRoomViewController new]] TitleS:@[@"视频直播",@"图文直播",@"直播间"]];
      UINavigationController *nzhiboav = [[UINavigationController alloc] initWithRootViewController:newvc];
    
    ZMDZBViewController *ZhiBovc = [[ZMDZBViewController alloc] initWithAddVCARY:@[[CustomPagerController new],[YinPinViewController new],[ZMDDSViewController new]] TitleS:@[@"云直播",@"广播",@"电视"]];
    UINavigationController *ZhiBonav = [[UINavigationController alloc] initWithRootViewController:ZhiBovc];
    
    
    
    
    ZMDNGuideViewController *guiVC = [[ZMDNGuideViewController alloc] init];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    _nav = [[ZMDNNavViewController alloc] initWithRootViewController:guiVC];
    
    
    Demo2ViewController *zhengwu = [[Demo2ViewController alloc]init];
    
  //  ZBDTTableViewController  *haa  = [[ZBDTTableViewController alloc]init];
    hudongViewController *hudong = [[hudongViewController alloc]init];
    //民生
    JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:vc];
    vc.segmentBgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    vc.indicatorViewColor =  [UIColor redColor];
    vc.titleColor = [UIColor redColor];
    [vc setViewControllers:@[hudong]];
    [vc setTitles:@[@"网络问政"]];
    
    
    UITabBarController *tabbarcontroller = [[UITabBarController alloc]init];
    tabbarcontroller.viewControllers = @[ZhiBonav,zhengwu,_nav,nzhiboav,navi];
    tabbarcontroller.tabBar.barTintColor = [UIColor clearColor];
    tabbarcontroller.selectedIndex = 2;
    
    
    
    CGRect rect = CGRectMake(0, 0, ScreenW, ScreenH);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [tabbarcontroller.tabBar setBackgroundImage:img];
    [tabbarcontroller.tabBar setShadowImage:img];
    
    
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW, 54)];
    lable.backgroundColor = [UIColor whiteColor];
    [tabbarcontroller.tabBar addSubview:lable];
    [tabbarcontroller.tabBar sendSubviewToBack:lable];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW, 1)];
    lab.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [tabbarcontroller.tabBar addSubview:lab];
    //[tabbarcontroller.tabBar setBackgroundImage:[UIImage imageNamed:@"ccc.png"]];
    tabbarcontroller.tabBar.hidden = YES;
    
    for (UIBarItem *item in tabbarcontroller.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
    }
    
    // 字体颜色 选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0F], NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    // 字体颜色 未选中
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0F],  NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]];
    
    self.window.rootViewController = tabbarcontroller;
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
  // NSLog(@"推送deviceToken -- >> %@",deviceToken);
  //    [Manager sharedManager].tuiSongString = [NSString stringWithFormat:@"%@",deviceToken];
    
    [JPUSHService registerDeviceToken:deviceToken];

    
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    [JPUSHService setAlias:@"123456" callbackSelector:nil object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
          [Manager sharedManager].tuiSongString = [NSString stringWithFormat:@"%@",[JPUSHService registrationID]];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    

}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    // 取得Extras字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"type"]; //服务端中Extras字段，key是自己定义的
    NSString *customizeField2 = [userInfo valueForKey:@"txt"];
    //NSLog(@"userInfo =====  %@",userInfo);
    NSRange range = [customizeField2 rangeOfString:@","];
    NSString *str = [customizeField2 substringToIndex:range.location];//ar_id
    NSString *string = [customizeField2 substringFromIndex:range.location];//ar_cateid
   
    NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",str,customizeField1];
    
    if ([customizeField1 isEqualToString:@"0"] ||[customizeField1 isEqualToString:@"1"] || [customizeField1 isEqualToString:@"2"] || [customizeField1 isEqualToString:@"3"])
    {
//        WEBVIEWController *webCtrol = [[WEBVIEWController alloc] init];
        NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
        [Manager sharedManager].jinru = @"jinruwebview";
        //webCtrol.userpicture = [NSString stringWithFormat:@"%@",recommend.ar_userpic];
        webCtrol.type =[NSString stringWithFormat:@"%@",customizeField1];
        webCtrol.idString =[NSString stringWithFormat:@"%@",str];
        webCtrol.ar_cateid =[NSString stringWithFormat:@"%@",string];
        
        webCtrol.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_nav presentViewController:na animated:YES completion:nil];
    }
   else if ([customizeField1 isEqualToString:@"4"])
    {
         [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:content];
    }
    
    else if ([customizeField1 isEqualToString:@"5"])
    {
        ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
        picContentVc.manyPicLink = htmlUrl;
        picContentVc.sharetitle  = content;
        picContentVc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [_nav presentViewController:picContentVc animated:YES completion:nil];
    }
    
     else if([customizeField1 isEqualToString:@"http"])
    {
        WaiLianController *zwfw = [[WaiLianController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
        zwfw.urlString = str;
        //zwfw.title = model.name;
        na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [_nav  presentViewController:na animated:YES completion:nil];
    }
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
     [JPUSHService setBadge:0];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    //NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //NSLog(@"shibai ------  haha");
    }
    return result;
}

/**
 *  定位
 */
-(void)location
{
    _locationManager = [[CLLocationManager alloc] init];
    
    if (![CLLocationManager locationServicesEnabled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务没有打开，请设置打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    if (IPHONE8)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
            
            [_locationManager requestWhenInUseAuthorization];
            
        }
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {
            _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            CLLocationDistance distance = 100;
            _locationManager.distanceFilter = distance;
            [_locationManager startUpdatingLocation];
        }
    }
    
}

#pragma mark --LocationDeledate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *location =  [locations firstObject];
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placeMark = [placemarks firstObject];
        
       
        
        NSString *positionStr = [NSString stringWithFormat:@"%@",placeMark.subLocality];
//        positionStr = @"52452上蔡5345";
        
        
        NSInteger area_id;
        NSArray *townArr = @[@"驻马店",@"遂平",@"西平",@"上蔡",@"汝南",@"平舆",@"确山",@"正阳",@"泌阳"];
        
        if([positionStr containsString:townArr[1]])
        {
            positionStr = @"遂平";
            area_id = 3;
            
        }else if([positionStr containsString:townArr[2]])
        {
            positionStr = @"西平";
            area_id = 4;
            
        }else if([positionStr containsString:townArr[3]])
        {
            positionStr = @"上蔡";
            area_id = 5;
            
        }else if([positionStr containsString:townArr[4]])
        {
            positionStr = @"汝南";
            area_id = 6;
            
        }else if([positionStr containsString:townArr[5]])
        {
            positionStr = @"平舆";
           area_id = 7;
            
        }else if([positionStr containsString:townArr[6]])
        {
            positionStr = @"确山";
            area_id = 8;
            
        }
        else if([positionStr containsString:townArr[7]])
        {
            positionStr = @"正阳";
            area_id = 9;
            
        }else if([positionStr containsString:townArr[8]])
        {
            positionStr = @"泌阳";
           area_id = 11;
        }else {
            positionStr = @"驻马店";
            area_id = 2;
        }
        
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"weizhi.text"];
        NSString *st = placeMark.name;
        [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:positionStr forKey:@"定位"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",area_id] forKey:@"定位id"];
        
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:positionStr, @"name",[NSString stringWithFormat:@"%ld",area_id],@"areaid",nil];
        
        
        
        
        NSNotification *notification =[NSNotification notificationWithName:@"titlearr" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
   
    [manager stopUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"99999---%@",error);
}



/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}




//加载广告
- (void)lodAD{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
  
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/api/ad/index?pid=401" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        if (![dic isEqual:[NSNull null]]) {
            NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *text= [doucments stringByAppendingPathComponent:@"qiDongADURL.text"];
            NSString *st =  [dic objectForKey:@"ad_link"];
            
            [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSMutableArray *arr = [NSMutableArray array];
            if ([dic objectForKey:@"ad_code"] != nil) {
                [arr addObject:[dic objectForKey:@"ad_code"]];
            }
            // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
            if (arr.count != 0) {
                [weakSelf getAdvertisingImage:arr];
            }
        }
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
    }];
    
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage:(NSMutableArray *)arr
{
    
    // TODO 请求广告接口
    NSString *imageUrl = arr[arc4random() % arr.count];
    //NSLog(@"-----%@",imageUrl);
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    //NSLog(@"=======%@",imageName);
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist)
    {
        // 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
    
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
//            NSLog(@"保存成功");
            [self deleteOldImage];
            [kUserDefaults setValue:imageName forKey:adImageName];
            [kUserDefaults synchronize];
            //如果有广告链接，将广告链接也保存下来
        }else{
//            NSLog(@"保存失败");
        }
    });
}

/**
 *  删除旧图片
 */
- (void)deleteOldImage
{
    NSString *imageName = [kUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName
{
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        return filePath;
    }
    return nil;
}











//请求视频链接
-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ZMDPlayerViewController *zmdPlayer = [[ZMDPlayerViewController alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
   // __weak typeof (zmdPlayer) weakPlayer =  zmdPlayer;
    
    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
         
         zmdPlayer.string = [dic objectForKey:@"ar_title"];
         zmdPlayer.movieURL = [dic objectForKey:@"ar_movieurl"];
         zmdPlayer.ar_id = [dic objectForKey:@"ar_id"];
         zmdPlayer.clicknum = [dic objectForKey:@"ar_onclick"];
         zmdPlayer.ar_pic = [dic objectForKey:@"ar_pic"];
         zmdPlayer.timeString = [dic objectForKey:@"ar_time"];
         zmdPlayer.fabu = [dic objectForKey:@"ar_ly"];
         zmdPlayer.ar_cateid = [dic objectForKey:@"ar_cateid"];
         zmdPlayer.ar_type = [dic objectForKey:@"ar_type"];
         
         zmdPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [_nav presentViewController:zmdPlayer animated:YES completion:nil];
       
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
     }];
    
}


@end
