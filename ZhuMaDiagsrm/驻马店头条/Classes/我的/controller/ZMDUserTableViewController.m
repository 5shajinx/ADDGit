//
//  ZMDUserTableViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/2/28.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDUserTableViewController.h"
#import "UMSocial.h"
#import "ErWeiMaViewController.h"
#import "UserMessageTableViewController.h"
#import "ShouCangTableViewController.h"

#import "PasswordLoginController.h"
#import "FeedbackViewController.h"
#import "AboutUsController.h"
#import "MineButton.h"
#import "CenterViewController.h"
#import "DYListTableViewController.h"
#import "MineWindowCell.h"
#import "ErWeiMaController.h"
#import "NewNetWorkManager.h"



#import "sys/utsname.h"//获取设备型号
@interface ZMDUserTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSString *zbpassword;
    NSString *zbusername;
}
@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UITextField *textfield;

@property(nonatomic, strong)NSArray *arr;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UIImageView *imageview;
@property(nonatomic, strong)UILabel *userlable;

@property(nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UIView *clearView;//正在清除View
@property (nonatomic, strong)UILabel *successLabel;//清除缓存成功Label

@property(nonatomic, strong)UIView *YZMview;
@property(nonatomic, strong)UITextField *SJTextfield;
@property(nonatomic, strong)UITextField *YZMTexfield;
@property(nonatomic, strong)UIButton *sendYZM;
@property(nonatomic, strong)UIButton *loginBtn;
@property(nonatomic, strong)UIButton *passwordLoginBtn;
@property(nonatomic, strong)UILabel *lab;
@property(nonatomic, strong)UIImageView *qqimage;
@property(nonatomic, strong)UIImageView *wechatimage;
@property(nonatomic, strong)UIImageView *sinaimage;
@property(nonatomic, assign)BOOL isyejian;
@property(nonatomic, strong)UIView *vieww;

@property(nonatomic, strong)UIToolbar *toolbar;
@property(nonatomic, strong)UIButton *btnn;
@property(nonatomic, strong)UIButton *canclebtn;
@property(nonatomic, strong)UILabel *titstr;

@property(nonatomic, strong)UIButton *xxbtn;
@property(nonatomic, assign)BOOL yzmbutton;
@property(nonatomic, strong)UIView *footView;
@property(nonatomic, strong)NSString *yaoqingMa;

@end

NSInteger const Simble_SIZE = 40;
NSInteger const Simble_TOP  = 10;

@implementation ZMDUserTableViewController





- (void)canclebutton {
    self.YZMview.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    
    
    
    self.btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnn.frame = CGRectMake(20, 25, 30, 30);
    [self.btnn setImage:[UIImage imageNamed:@"baiback"] forState:UIControlStateNormal];
    [self.btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnn];
    [self.view bringSubviewToFront:self.btnn];
    
    
    self.canclebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.canclebtn.frame = CGRectMake(20, 25, 30, 30);
    [self.canclebtn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [self.canclebtn addTarget:self action:@selector(canclebutton) forControlEvents:UIControlEventTouchUpInside];
    self.titstr = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, ScreenW-100, 30)];
    self.titstr.text = @"帐号";
    self.titstr.textColor = [UIColor lightGrayColor];
    self.titstr.textAlignment = NSTextAlignmentCenter;
    
    
    self.YZMview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _YZMview.backgroundColor = [UIColor whiteColor];
    _YZMview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenYZMview)];
    [_YZMview addGestureRecognizer:tap];
    
    
    
    
    self.vieww = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 320*Kscaleh)];
    
    
    self.vieww.backgroundColor = [UIColor colorWithRed:115/255.0 green:115/255.0 blue:115/255.0 alpha:1.0];
    MineButton *btn = [MineButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"收藏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"30"] forState:UIControlStateNormal];
    btn.frame = CGRectMake((ScreenW/3-60*Kscalew)/2, 250*Kscaleh, 60*Kscalew, 60*Kscalew);
    btn.backgroundColor =  [UIColor clearColor];
    [btn addTarget:self action:@selector(shoucang:) forControlEvents:UIControlEventTouchUpInside];
    [self.vieww addSubview:btn];
    
    MineButton *btn1 = [MineButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"亮度" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"ye"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake((ScreenW/3-60*Kscalew)/2 + ScreenW/3, 250*Kscaleh, 60*Kscalew, 60*Kscalew);
    btn1.backgroundColor =  [UIColor clearColor];
    [btn1 addTarget:self action:@selector(yejian:) forControlEvents:UIControlEventTouchUpInside];
    [self.vieww addSubview:btn1];
    
    MineButton *btn2 = [MineButton buttonWithType:UIButtonTypeCustom];
    [btn2 setTitle:@"设置" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
    btn2.frame = CGRectMake((ScreenW/3-60*Kscalew)/2 + ScreenW/3*2, 250*Kscaleh, 60*Kscalew, 60*Kscalew);
    btn2.backgroundColor = [UIColor clearColor];
    [btn2 addTarget:self action:@selector(shezhi:) forControlEvents:UIControlEventTouchUpInside];
    [self.vieww addSubview:btn2];
    
    //    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 300*Kscaleh, ScreenW, 1)];
    //    line1.backgroundColor = [UIColor lightGrayColor];
    //    line1.alpha = .2;
    //    [self.vieww addSubview:line1];
    //    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3, 230*Kscaleh, 1, 70*Kscalew)];
    //    line2.backgroundColor = [UIColor lightGrayColor];
    //    line2.alpha = .2;
    //    [self.vieww addSubview:line2];
    //
    //    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/3*2, 230*Kscaleh,  1, 70*Kscalew)];
    //    line.backgroundColor = [UIColor lightGrayColor];
    //    line.alpha = .2;
    //    [self.vieww addSubview:line];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250*Kscaleh)];
    //self.imageView.backgroundColor = [UIColor colorWithRed:111/255.0 green:142/255.0 blue:174/255.0 alpha:1.0];
    //self.imageView.image = [UIImage imageNamed:@"ak.jpg"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0 , ScreenW, self.imageView.frame.size.height)];
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW-80*Kscalew)/2, (270*Kscaleh -110*Kscalew)/2, 80*Kscalew, 80*Kscalew)];
    self.imageview.image = [UIImage imageNamed:@"yonghu"];
    self.imageview.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    self.imageview.layer.masksToBounds = YES;
    self.imageview.userInteractionEnabled = YES;
    self.imageview.layer.cornerRadius = 40*Kscalew;
    
    self.userlable = [[UILabel alloc]initWithFrame:CGRectMake((ScreenW-150*Kscalew)/2, 340*Kscaleh/2, 150*Kscalew, 20*Kscalew)];
    self.userlable.textAlignment = NSTextAlignmentCenter;
    self.userlable.text = @"点击登陆";
    self.userlable.textColor = [UIColor whiteColor];
    self.userlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapgesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleClickImage:)];
    tapgesture2.numberOfTapsRequired = 1;
    [self.userlable addGestureRecognizer:tapgesture2];
    //给图像添加一个单机手势，用来切换用户图像
    UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleClickImage:)];
    tapgesture.numberOfTapsRequired = 1;
    [self.imageview addGestureRecognizer:tapgesture];
    
    _arr = @[@"我的直播",@"我的订阅",@"意见反馈",@"清除缓存",@"关于我们",@"二维码",@"邀请码"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MineWindowCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = self.vieww;
    [self.vieww addSubview:self.imageView];
    [self.tableView addSubview:self.userlable];
    [self.tableView addSubview:self.imageview];
    
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame=CGRectMake(20, 100, 30, 30);
    [self.button setTitle:@"yincang" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(hiddenview) forControlEvents:UIControlEventTouchUpInside];
    [self.YZMview addSubview:self.button];
    [self.view addSubview:_YZMview];
    
    self.textfield.delegate = self;
    
    [self setupyzmlogin];
    
    //[self readData];
    
    if (self.moviedetails != nil) {
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"movie", @"name",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"movie" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    self.xxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.xxbtn.frame = CGRectMake(ScreenW-50, 25, 30, 30);
    [self.xxbtn setImage:[UIImage imageNamed:@"cuox"] forState:UIControlStateNormal];
    [self.xxbtn addTarget:self action:@selector(xxxxxbutton) forControlEvents:UIControlEventTouchUpInside];
   
    [self.YZMview addSubview:self.xxbtn];

}


//发送邀请码
- (void)sendYQM{
    self.tableView.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
   // 获取所有信息字典
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    
   // NSString *executableFile = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey]; //获取项目名称
    
  //  NSLog(@"executableFile == %@",executableFile);
    
    NSString *version = [infoDictionary objectForKey:(NSString *)kCFBundleVersionKey]; //获取项目版本号
   // NSLog(@"version .. %@",version);
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
 //   NSLog(@"app_Version .. %@",app_Version);
    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
  //  NSLog(@"app_build >> %@",app_build);
    
    
    NSString *deviceName = [self getDeviceName];
  //  NSLog(@"设备型号-->%@", deviceName);
    
//    NSString *iPhoneName = [UIDevice currentDevice].name;
//    NSLog(@"iPhone名称-->%@", iPhoneName);
//    
//    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSLog(@"app版本号-->%@", appVerion);
//    NSString *systemName = [UIDevice currentDevice].systemName;
//    NSLog(@"当前系统名称-->%@", systemName);
//    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
//    NSLog(@"当前系统版本号-->%@", systemVersion);
  
    
    NSString *adId = [NSString stringWithFormat:@"%@", [Manager sharedManager].adIdString];
    NSString *tuisongStr = [NSString stringWithFormat:@"%@", [Manager sharedManager].tuiSongString];
  
    
    NSDictionary *dic = @{@"registrationid":tuisongStr,
                                 @"code":_yaoqingMa,
                                 @"buildmodel":deviceName,
                                 @"buildproduct":@"苹果公司",
                                 @"buildbrand":@"苹果公司",
                                 @"buildfingerprint":adId,
                                 @"versionname":app_build,
                                 @"versioncode":app_Version,
                                 };
    
    NSLog(@"00AF3EF2-C2A2-4702-A291-A14FD8A08BDF%@",dic);
    
    if (tuisongStr.length < 8) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"与数据接口通讯不畅,请稍后再试" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:actionsure1];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    } else{
   [NewNetWorkManager requestGETWithURLStr:@"http://zmdtt.zmdtvw.cn/index.php/api/invitecode/index" parDic:dic finish:^(id resonbject) {
;
       
       if([[resonbject objectForKey:@"code"] integerValue] == 0){
           UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发送失败" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }];
           [alertVC addAction:actionsure1];
           [self presentViewController:alertVC animated:YES completion:nil];
  
       }else if ([[resonbject objectForKey:@"code"] integerValue                         ] == 1){
           UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"发送成功" preferredStyle:UIAlertControllerStyleAlert];
           UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           }];
           [alertVC addAction:actionsure1];
           
           //写
           NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
           NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"YaoQingMatt.text"];
           NSString *string = @"0123456789";
           [string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];

           
           
           [self.tableView reloadData];
           
        [self presentViewController:alertVC animated:YES completion:nil];
           
       }

   } conError:^(NSError *error) {

       
   }];
    }
    
}
// 获取设备型号然后手动转化为对应名称
- (NSString *)getDeviceName
{
    // 需要#import "sys/utsname.h"
#warning 题主呕心沥血总结！！最全面！亲测！全网独此一份！！
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"国行、日版、港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"港行、国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"美版、台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"美版、台版iPhone 7 Plus";
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])      return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])      return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceString isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceString isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceString isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    return deviceString;
}
- (void)hiddenview {
    //self.navigationController.navigationBar.hidden = NO;
    _YZMview.hidden = YES;
}
- (void)xxxxxbutton {
    self.YZMview.hidden = YES;
}
- (void)hiddenYZMview {
    [self.SJTextfield resignFirstResponder];
    [self.YZMTexfield resignFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated {
    [Manager sharedManager].hiddenlogin = nil;
    
    NSString *uerpicUrl = [NSString stringWithFormat:@"%@",[Manager sharedManager].picture];
[[NSUserDefaults standardUserDefaults] setObject:uerpicUrl forKey:@"userheadpic"];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //通知刷新并显示头像
    NSNotification *notificatio =[NSNotification notificationWithName:@"shuaxinjiemian" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notificatio];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
}

- (void)shoucang:(UIButton *)sender {
    ShouCangTableViewController *massage = [[ShouCangTableViewController alloc]init];
    
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:massage];
    [self presentViewController:na animated:YES completion:nil];
}

- (void)yejian:(UIButton *)sender {
    if (self.isyejian == NO) {
        self.view.window.alpha = 0.5;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"night"];
    }else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"night"];
        self.view.window.alpha = 1;
    }
    _isyejian = !_isyejian;
}
- (void)shezhi:(UIButton *)sender {
    UserMessageTableViewController *massage = [[UserMessageTableViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:massage];
    [self presentViewController:na animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filewebCaches = [file stringByAppendingPathComponent:@"/arr.text"];
    NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
    if (fileDic.count != 0) {
        [[WordFilter sharedInstance] initFilter:fileDic];
    }
    
    
    [self.textfield resignFirstResponder];
    
    //    //去除导航栏下方的横线
    //    [self.navigationController.navigationBar setBackgroundImage:nil
    //                       forBarPosition:UIBarPositionTopAttached
    //                           barMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    [self readData];
}

- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)handleClickImage:(UITapGestureRecognizer *)sender {
    self.imageView.userInteractionEnabled = NO;
    _YZMview.hidden = NO;
    
    //[self.view bringSubviewToFront:self.button];
    //self.navigationController.navigationBar.hidden = YES;
}


- (void)sendtanzhengma:(UIButton *)sender {
    if (self.yzmbutton) {
        [self lodyzm];
   
    }
    
}
- (void)login:(UIButton *)sender {
    
    [self lodLogin];
}
- (void)passwordLogin:(UIButton *)sender {
  
    [self.SJTextfield resignFirstResponder];
    [self.YZMTexfield resignFirstResponder];
    PasswordLoginController *pass = [[PasswordLoginController alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:pass];
    [self presentViewController:navi animated:YES completion:nil];
    
}

- (void)isornotlogin{
    //判断标识
    NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *text= [doucments stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *st = @"login";
    [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //写
    NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"username.text"];
    NSString *string = [Manager sharedManager].string;
    [string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    /*
    NSString *AdocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *AtextFilePath = [AdocumentsPath stringByAppendingPathComponent:@"username.text"];
    //3.通过路径获取数据
    NSString *string = [NSString stringWithContentsOfFile:AtextFilePath encoding:NSUTF8StringEncoding error:nil];
    */


    NSString *doucmentsFilePat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textPat = [doucmentsFilePat stringByAppendingPathComponent:@"imageurl.text"];
    NSString *str = [Manager sharedManager].picString ;
    [str writeToFile:textPat atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *doucmentsFilePathUsid = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textPathUsid = [doucmentsFilePathUsid stringByAppendingPathComponent:@"usid.text"];
    NSString *stringUsid = [Manager sharedManager].usid;
    [stringUsid writeToFile:textPathUsid atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    NSString *ncFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *nctextPath = [ncFilePath stringByAppendingPathComponent:@"Signature.text"];
    NSString *ncstring = [Manager sharedManager].qianming ;
    [ncstring writeToFile:nctextPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)readData {
    [self.toolbar removeFromSuperview];
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    [Manager sharedManager].sssss = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"username.text"];
    
    
    
    if ([NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil] != nil) {
        //        NSLog(@"-----%@",[NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil]);
        NSString *string = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
        self.userlable.text = [[WordFilter sharedInstance] filter:string];
        
        self.userlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    }else {
        self.userlable.text = @"点击登陆";
        self.userlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
        self.userlable.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labellogin)];
        [self.userlable addGestureRecognizer:ges];
        
        
        //        NSLog(@"+++=++++%@",[NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil]);
    }
    
    
    NSString *documentsPat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePat = [documentsPat stringByAppendingPathComponent:@"imageurl.text"];
    
    if ([NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil] != nil) {
        
        NSString *strrr = [NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil];
        if (strrr.length == 0) {
            self.imageview.image = [UIImage imageNamed:@"yonghu"];
        }else {
            [self.imageview sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil]]];
        }
        
        self.imageView.image = [UIImage imageNamed:@"模糊.jpg"];
        //        [self.imageView addSubview:self.toolbar];
        
    }else {
        self.imageview.image = [UIImage imageNamed:@"yonghu"];
        
        self.imageView.image = [UIImage imageNamed:@""];
        self.imageView.backgroundColor = [UIColor colorWithRed:111/255.0 green:142/255.0 blue:174/255.0 alpha:1.0];
        
    }
    
    
    self.YZMview.hidden = YES;
    self.tableView.scrollEnabled = YES;
    
    if ([Manager sharedManager].sssss != nil) {
        self.imageview.userInteractionEnabled = NO;
    }else {
        self.imageview.userInteractionEnabled = YES;
    }
    
    
    [self.YZMview addSubview:self.titstr];
    [self.YZMview addSubview:self.canclebtn];
    [self.view bringSubviewToFront:self.btnn];
    [self.YZMview sendSubviewToBack:self.btnn];
   
}


//label登录
- (void)labellogin{
    self.imageView.userInteractionEnabled = NO;
    _YZMview.hidden = NO;

}
//登陆
- (void)ZMDThirdPathLogin {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *dict = @{@"username":[Manager sharedManager].usid,@"password":[Manager sharedManager].token,@"photo":[Manager sharedManager].picture,@"nickname":[Manager sharedManager].nickname,@"msg":[Manager sharedManager].msg,@"type":[Manager sharedManager].type};
    __weak typeof(self) weakself = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/ptuser/morelogin" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
               // NSLog(@" //nickname  password  phone  ptuid  qopenid  type  username  wopenid  xopenid     ======  %@",dicc );
        //nickname  password  phone  ptuid  qopenid  type  username  wopenid  xopenid
        
        [Manager sharedManager].string    = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
        
        zbusername = [[dicc objectForKey:@"user"] objectForKey:@"username"];
        zbpassword = [[dicc objectForKey:@"user"] objectForKey:@"password"];
        //存账号
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"zhanghao.text"];
        NSString *st = [[dicc objectForKey:@"user"] objectForKey:@"username"];
        [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
        //存密码
        NSString *doucments1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text1= [doucments1 stringByAppendingPathComponent:@"mima.text"];
        NSString *st1 = [[dicc objectForKey:@"user"] objectForKey:@"password"];
        [st1 writeToFile:text1 atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        [Manager sharedManager].picString = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
        [Manager sharedManager].qianming  = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
        
        
        
        
//        NSNumber *numString = [[dicc objectForKey:@"user"] objectForKey:@"ptuid"];
//        NSNumberFormatter* numberpt = [[NSNumberFormatter alloc] init];
//        NSString *ptuid = [numberpt stringFromNumber:numString];
//        NSLog(@"ppppppppppp%@",ptuid);

           NSNumber *ptuid = [[dicc objectForKey:@"user"] objectForKey:@"ptuid"];

        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
    
        
        if ([code isEqualToString:@"0"] ) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            [self.textfield resignFirstResponder];
            NSString *dou = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPat = [dou stringByAppendingPathComponent:@"ptuid.text"];
            NSString *ptuidstr = [NSString stringWithFormat:@"%@",ptuid];
            
            [ptuidstr writeToFile:textPat atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [weakself isornotlogin];
            [weakself readData];
            
            [weakself lodZBregister];
            
            
        }
        if ([code isEqualToString:@"1"]) {
            // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        if ([code isEqualToString:@"2"]) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)lodZBregister {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    __weak typeof(self) weakSelf = self;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    if (zbusername != nil &&  zbpassword!= nil) {
        
        
        NSDictionary *dic = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"register",@"username":zbusername,@"password":zbpassword};
        
        [session GET:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            //NSLog(@" ======  %@",dicc );
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号密码不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}





- (void)qqlogin:(UITapGestureRecognizer *)sender {
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        // 获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            //NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            [Manager sharedManager].usid      = snsAccount.usid;
            [Manager sharedManager].token     = snsAccount.accessToken;
            [Manager sharedManager].msg       = [response.thirdPlatformUserProfile objectForKey:@"msg"];
            [Manager sharedManager].type      = @"3";
            [Manager sharedManager].nickname  = snsAccount.userName;
            [Manager sharedManager].picture   =  snsAccount.iconURL;
            
            [self ZMDThirdPathLogin];
            
        }});
}
- (void)wechatlogin:(UITapGestureRecognizer *)sender {
    
    //      UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该功能暂未添加，请稍后再试" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //
    //    }];
    //
    //    [alertVC addAction:actioncancle];
    //    [self presentViewController:alertVC animated:YES completion:nil];
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            //NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            //NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            
            [Manager sharedManager].usid       = snsAccount.usid;
            [Manager sharedManager].token      = snsAccount.accessToken;
            [Manager sharedManager].msg        = @"";
            [Manager sharedManager].type       = @"2";
            [Manager sharedManager].nickname   = snsAccount.userName;
            [Manager sharedManager].picture    = snsAccount.iconURL;
            [self ZMDThirdPathLogin];
        }
    });
    
}
- (void)sinalogin:(UITapGestureRecognizer *)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
 
        //获取微博用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            // NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            //NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            
            [Manager sharedManager].usid       = snsAccount.usid;
            [Manager sharedManager].token      = snsAccount.accessToken;
            [Manager sharedManager].msg        = @"";
            [Manager sharedManager].type       = @"4";
            [Manager sharedManager].nickname   = snsAccount.userName;
            [Manager sharedManager].picture    =  snsAccount.iconURL;
            
            [self ZMDThirdPathLogin];
        }});
}


- (void)lodyzm{
    self.yzmbutton = NO;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dict = @{@"phone":self.SJTextfield.text};
    __weak typeof(self) weakself = self;
    if ([Manager valiMobile:self.SJTextfield.text] == nil) {
        [session GET:yanzheng parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if (![code isEqualToString:@"3"]) {
                [weakself setTime];
            }
            if ([code isEqualToString:@"0"] ) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            if ([code isEqualToString:@"1"]) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            if ([code isEqualToString:@"2"]) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            if ([code isEqualToString:@"3"]) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[Manager valiMobile:self.SJTextfield.text] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:actionC];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}


- (void)lodLogin{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSDictionary *dict = @{@"phone":self.SJTextfield.text,@"code":self.YZMTexfield.text};
    [session GET:userlogin parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            
            
            [Manager sharedManager].usid      = [[dicc objectForKey:@"user"] objectForKey:@"phone"];
            [Manager sharedManager].token     = weakself.YZMTexfield.text;
            [Manager sharedManager].msg       = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
            [Manager sharedManager].type      = @"1";
            [Manager sharedManager].nickname  = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
            [Manager sharedManager].picture   = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
            
            [weakself ZMDThirdPathLogin];
        }
        if ([code isEqualToString:@"1"]) {
            // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            
        }
        if ([code isEqualToString:@"2"]) {
            // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        [self.SJTextfield resignFirstResponder];
        [self.YZMTexfield resignFirstResponder];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)setTime{
    [self showOnleText:@"发送成功" delay:2];
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.sendYZM.clipsToBounds = YES;
                [self.sendYZM setTitle:@"|  发送验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"正在发送(%.dS)", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.sendYZM setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            self.sendYZM.clipsToBounds = NO;
            if (timeout == 0) {
                self.yzmbutton = YES;
            }
        }
    });
    dispatch_resume(_timer);
}


- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
    // hud.center = self.view.center;//屏幕正中心
    CGPoint pot = self.loginBtn.center;
    pot.y += 60;
    hud.center = pot;
    
    
    [hud hideAnimated:YES afterDelay:delay];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //读
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *YaoQingMa = [documentsPath stringByAppendingPathComponent:@"YaoQingMatt.text"];
    NSString *ssss = [NSString stringWithContentsOfFile:YaoQingMa encoding:NSUTF8StringEncoding error:nil];
    if(ssss.length == 10 ){
        return _arr.count - 1;
    }else{
    return _arr.count;
}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineWindowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    //cell.contentView.userInteractionEnabled = NO;

    cell.namelable.text = [NSString stringWithFormat:@" %@",_arr[indexPath.row]];
    cell.minimg.image = [UIImage imageNamed:[NSString stringWithFormat:@"min%ld",indexPath.row+1]];
    cell.minimg.contentMode = UIViewContentModeScaleAspectFill;
    cell.minimg.clipsToBounds = YES;
    if (indexPath.row == (_arr.count - 1)) {
        cell.tapImage.userInteractionEnabled = YES;
        cell.contentView.userInteractionEnabled = YES;
    }
    
    
    if (indexPath.row == 3) {
        // 计算缓存
        CGFloat imageSizes = [[SDImageCache sharedImageCache] getSize]  / 1024.0 / 1024.0;
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        NSFileManager * manager = [NSFileManager defaultManager];
        NSArray *files = [manager subpathsAtPath:cachesPath];
        CGFloat lrcSizes = 0;
        NSMutableArray *lrcArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *lrcFile in files) {
            
            if ([lrcFile containsString:@"lrc"]) {
                
                NSString *lrcFiles = [NSString stringWithFormat:@"%@/%@",cachesPath,lrcFile];
                CGFloat lrcSize = [[manager attributesOfItemAtPath:lrcFiles error:nil] fileSize] / 1024.0 / 1024.0;
                lrcSizes += lrcSize;
                
                [lrcArr addObject:lrcFiles];
            }
        }
        CGFloat fileSize = imageSizes + lrcSizes;
        NSString *clearCacheName = fileSize >= 1 ? [NSString stringWithFormat:@"%.2fM",fileSize] : [NSString stringWithFormat:@"%.2fK",fileSize * 1024.0];
        //cell.textLabel.text = [NSString stringWithFormat:@"清除缓存 (%@)",clearCacheName];
        cell.namelable.text = @" 清除缓存";
    }
    
    //    UIImageView *lab = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-30, 10, 20, 20)];
    //    lab.image = [UIImage imageNamed:@"cell.png"];
    //    [cell.contentView addSubview:lab];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
 //   [self.tableView reloadData];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
    
}

- (void)lodZBkogin {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    session.responseSerializer.acceptableContentTypes = nil;//[NSSet setWithObject:@"text/ plain"];
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"zhanghao.text"];
    NSString *zhanghao = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    NSString *dom1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex1 = [dom1 stringByAppendingPathComponent:@"mima.text"];
    NSString *mima = [NSString stringWithContentsOfFile:tex1 encoding:NSUTF8StringEncoding error:nil];

    __weak typeof(self) weakSelf = self;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString]; //------------将字符串按formatter转成nsdate
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    
    if (zhanghao != nil && mima != nil) {
        
        NSDictionary *dic = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"login",@"username":zhanghao,@"password":mima};
        
        [session GET:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            
            if ([code isEqualToString:@"0"] ) {
                [Manager sharedManager].userid = [[dicc objectForKey:@"data"] objectForKey:@"userid"];

                
                CenterViewController *zhibo = [[CenterViewController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zhibo];
                [self presentViewController:na animated:YES completion:nil];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"error=== %@",error);
        }];
    }else {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"账号密码不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    if (indexPath.row == 0){
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该功能暂未开放" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *actionsure2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alertVC addAction:actionsure2];
//        [self presentViewController:alertVC animated:YES completion:nil];
        if (str == nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请先登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionsure2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      
        }];
        [alertVC addAction:actionsure2];
        [self presentViewController:alertVC animated:YES completion:nil];
        }else {
            [self lodZBkogin];
        }
    }
    if (indexPath.row == 1) {
        DYListTableViewController *massage = [[DYListTableViewController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:massage];
        [self presentViewController:na animated:YES completion:nil];
    }
    
    
    if (indexPath.row == 2) {
        FeedbackViewController *feedback = [[FeedbackViewController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:feedback];
        [self presentViewController:na animated:YES completion:nil];
    }
    
    if (indexPath.row == 3) {
        // 计算缓存
        CGFloat imageSizes = [[SDImageCache sharedImageCache] getSize]  / 1024.0 / 1024.0;
        //NSLog(@"%.2f",imageSizes);
        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
        NSFileManager * manager = [NSFileManager defaultManager];
        NSArray *files = [manager subpathsAtPath:cachesPath];
        CGFloat lrcSizes = 0;
        NSMutableArray *lrcArr = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *lrcFile in files) {
            
            if ([lrcFile containsString:@"lrc"]) {
                
                NSString *lrcFiles = [NSString stringWithFormat:@"%@/%@",cachesPath,lrcFile];
                CGFloat lrcSize = [[manager attributesOfItemAtPath:lrcFiles error:nil] fileSize] / 1024.0 / 1024.0;
                lrcSizes += lrcSize;
                
                [lrcArr addObject:lrcFiles];
                //NSLog(@"%.2f,%@",lrcSize,lrcFiles);
            }
        }
        //NSLog(@"%.2f",lrcSizes);
        CGFloat fileSize = imageSizes + lrcSizes;
        //NSLog(@"%.2f",fileSize);
        NSString *clearCacheName = fileSize >= 1 ? [NSString stringWithFormat:@"%.2fM",fileSize] : [NSString stringWithFormat:@"%.2fK",fileSize * 1024.0];
        
        
        // UIAlertController
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"清除缓存" message:[NSString stringWithFormat:@"是否清除缓存(%@)", clearCacheName] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //按钮触发的方法
            [self.view.window addSubview:self.clearView];
            //延时执行
            [self performSelector:@selector(handleToSuccess) withObject:nil afterDelay:1.0f];
            //清除缓存
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            //cell.textLabel.text = @"清除缓存";
            for (NSString *lrcStr in lrcArr) {
                [manager removeItemAtPath:lrcStr error:nil];
            }
        }]];
        // 模态推出
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    //    if ( indexPath.row == 3) {
    //        ErWeiMaViewController *erweima = [[ErWeiMaViewController alloc]init];
    //        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:erweima];
    //        [self presentViewController:na animated:YES completion:nil];
    //    }
    
    if (indexPath.row == 4) {
        AboutUsController *aboutUs = [[AboutUsController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:aboutUs];
        [self presentViewController:na animated:YES completion:nil];
    }
    if (indexPath.row == 5) {
//        ErWeiMaController *erweima = [[ErWeiMaController alloc]init];
//           UINavigationController *naa = [[UINavigationController alloc]initWithRootViewController:erweima];
//        [self presentViewController:naa animated:YES completion:nil];
        ErWeiMaViewController *erweima = [[ErWeiMaViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:erweima];
        [self presentViewController:na animated:YES completion:nil];
      
    }
    if (indexPath.row == 6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输邀请码" message:nil preferredStyle:UIAlertControllerStyleAlert];
 

        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框；
            UITextField *userNameTextField = alertController.textFields.firstObject;
            self.yaoqingMa = [NSString stringWithFormat:@"%@",userNameTextField.text];
            [self sendYQM];
        }]];
        
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入邀请码";
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.frame = CGRectMake(0, 0, 100, 50);
            
        }];
      
        
        [self presentViewController:alertController animated:true completion:nil];

             
        
        
    }
}



//延时、定时器方法的实现
- (void)handleToSuccess {
    self.clearView.hidden = YES;
    self.clearView = nil;
    
    [self.view.window addSubview:self.successLabel];
    //延时执行
    [self performSelector:@selector(handleToHidden) withObject:nil afterDelay:1.0f];
    //定时器
    //[NSTimer scheduledTimerWithTimeInterval:.8 target:self selector:@selector(handleToHidden) userInfo:nil repeats:NO];
}

//延时、定时器方法的实现
- (void)handleToHidden {
    self.successLabel.hidden = YES;
    self.successLabel = nil;
}

//清除动画
- (void)drawTick {
    UIView *logoView = [[UIView alloc] initWithFrame:CGRectMake((self.clearView.frame.size.width - Simble_SIZE) / 2, Simble_TOP, Simble_SIZE, Simble_SIZE)];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(Simble_SIZE/2, Simble_SIZE/2) radius:Simble_SIZE/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    
    [path moveToPoint:CGPointMake(Simble_SIZE/4, Simble_SIZE/2)];
    CGPoint p1 = CGPointMake(Simble_SIZE/4+10, Simble_SIZE/2+10);
    [path addLineToPoint:p1];
    
    CGPoint p2 = CGPointMake(Simble_SIZE/4*3, Simble_SIZE/4);
    [path addLineToPoint:p2];
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineWidth = 5;
    layer.path = path.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.5;
    [layer addAnimation:animation forKey:NSStringFromSelector(@selector(strokeEnd))];
    
    [logoView.layer addSublayer:layer];
    [self.clearView addSubview:logoView];
}
//正在清除View
- (UIView *)clearView {
    if (_clearView == nil) {
        //创建UIActivityIndicatorView背底半透明View (活动指示器)
        self.clearView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW / 2 - 64, ScreenH / 2 - 80, 128, 100)] ;
        _clearView.backgroundColor = [UIColor blackColor];
        _clearView.alpha = .8;
        
        [self drawTick];
        
        UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 128, 40)];
        aLabel.text = @"正在清除...";
        aLabel.font = [UIFont systemFontOfSize:18];
        aLabel.textColor = [UIColor whiteColor];
        aLabel.textAlignment = NSTextAlignmentCenter;
        [_clearView addSubview:aLabel];
    }
    return _clearView;
}

//清除缓存成功Label
- (UILabel *)successLabel {
    if (_successLabel == nil) {
        //创建UIActivityIndicatorView背底半透明View (活动指示器)
        self.successLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW / 2 - 64, ScreenH / 2 - 44, 128, 44)];
        _successLabel.layer.cornerRadius = 5;
        _successLabel.layer.masksToBounds = YES;
        _successLabel.backgroundColor = [UIColor blackColor];
        _successLabel.alpha = 1;
        _successLabel.text = @"清除缓存成功!";
        _successLabel.font = [UIFont systemFontOfSize:18];
        _successLabel.textColor = [UIColor whiteColor];
        _successLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _successLabel;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据偏移量改变导航条的透明度
    CGFloat yOffset = scrollView.contentOffset.y;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    CGFloat alpha = scrollView.contentOffset.y / 90 > 1 ? 1:scrollView.contentOffset.y / 90;
    //    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    //     self.navigationItem.title = @"我的";
    //self.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    /**
     *  对表头效果拉伸的出来,yOffset 初始状态 ： -200.000000
     */
    if (yOffset < 0) {
        CGRect f = self.imageView.frame;
        //下拉的偏移量赋给
        f.origin.y = yOffset;
        //加上下拉的偏移量得到一个新的高度
        f.size.height =  -yOffset + 250*Kscaleh;
        //x位置 f.size.height/kImageOriginHight * ScreenWidth 通过高度比例得到宽度的值，然后减去原来宽度，边长的宽度 除以2得到x轴位置
        f.origin.x = -(f.size.height*self.view.frame.size.width/(250*Kscalew) -  self.view.frame.size.width)/2;
        ////f.size.height/kImageOriginHight * ScreenWidth 通过高度比例得到宽度的值，
        f.size.width = f.size.height*self.view.frame.size.width/(250*Kscalew);
        self.imageView.frame = f;
        
    }
}

/**
 *  根据透明度去绘制一个图片，也可以省略此处用一个透明的图片，没这个效果好
 */
-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color=[UIColor colorWithRed:15 green:20 blue:15 alpha:alpha];
    CGSize colorSize=CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(colorSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return img;
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.text ) {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}



- (void)setupyzmlogin {
    self.yzmbutton = YES;
    
    
    self.SJTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 120, ScreenW-80, 40)];
    
//    [_SJTextfield.layer setBorderWidth:1.0];
//    _SJTextfield.layer.borderColor=[UIColor blackColor].CGColor;
    _SJTextfield.placeholder = @" 请输入手机号";
    _SJTextfield.delegate = self;
    _SJTextfield.layer.masksToBounds = YES;
    _SJTextfield.layer.cornerRadius = 5;
    _SJTextfield.borderStyle = UITextBorderStyleNone;
//    self.SJTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.YZMview addSubview:self.SJTextfield];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 159, ScreenW-80, 1)];
    lable.backgroundColor = [UIColor lightGrayColor];
    [self.YZMview addSubview:lable];
    
    
    self.sendYZM = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendYZM.frame = CGRectMake(ScreenW - 190, 120, 150, 40);
    [_sendYZM setTitle:@"|  发送验证码" forState:UIControlStateNormal];
    _sendYZM.titleLabel.textAlignment = NSTextAlignmentRight;
    [_sendYZM setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_sendYZM addTarget:self action:@selector(sendtanzhengma:) forControlEvents:UIControlEventTouchUpInside];
    [self.YZMview addSubview:self.sendYZM];
    
    self.YZMTexfield = [[UITextField alloc]initWithFrame:CGRectMake(40,190, ScreenW-80, 40)];
    
//    [_YZMTexfield.layer setBorderWidth:1.0];
//    _YZMTexfield.layer.borderColor=[UIColor blackColor].CGColor;
    self.YZMTexfield.delegate = self;
    _YZMTexfield.placeholder = @" 请输入验证码";
    _YZMTexfield.layer.masksToBounds = YES;
//    self.YZMTexfield.keyboardType = UIKeyboardTypeNumberPad;
    _YZMTexfield.layer.cornerRadius = 5;
    _YZMTexfield.borderStyle = UITextBorderStyleNone;
    [self.YZMview addSubview:self.YZMTexfield];
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(40, 229, ScreenW-80, 1)];
    lable1.backgroundColor = [UIColor lightGrayColor];
    [self.YZMview addSubview:lable1];
    
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(40, 290, ScreenW-80, 40);
    [_loginBtn setTitle:@"进入广视融媒" forState:UIControlStateNormal];
    _loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginBtn.layer.masksToBounds = YES;
    self.loginBtn.backgroundColor = [UIColor redColor];
    _loginBtn.layer.cornerRadius = 5;
    //[_loginBtn.layer setBorderWidth:1.0];
    //_loginBtn.layer.borderColor=[UIColor redColor].CGColor;
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.YZMview addSubview:self.loginBtn];
    
    
    //    self.passwordLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _passwordLoginBtn.frame = CGRectMake((ScreenW - 100)/2,335, 100, 30);
    //    [_passwordLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
    //    _passwordLoginBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    //    _passwordLoginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    //    [_passwordLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    [_passwordLoginBtn addTarget:self action:@selector(passwordLogin:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.YZMview addSubview:self.passwordLoginBtn];
    
    
    
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 440, ScreenW, 20)];
    _lab.text = @"～～～～～社交帐号登录～～～～～";
    _lab.textAlignment = NSTextAlignmentCenter;
    _lab.font = [UIFont systemFontOfSize:12];
    _lab.textColor = [UIColor lightGrayColor];
    [self.YZMview addSubview:self.lab];
    
    
    self.qqimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW/2-105, 485, 50, 50)];
    _qqimage.layer.masksToBounds = YES;
    _qqimage.layer.cornerRadius = 25;
    _qqimage.userInteractionEnabled = YES;
    _qqimage.image = [UIImage imageNamed:@"qq"];
    _qqimage.contentMode = UIViewContentModeScaleAspectFill;
    _qqimage.clipsToBounds = YES;
    UITapGestureRecognizer *qqtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqlogin:)];
    [self.qqimage addGestureRecognizer:qqtap];
    [self.YZMview addSubview:self.qqimage];
    
    self.wechatimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW/2-25, 485, 50, 50)];
    _wechatimage.layer.masksToBounds = YES;
    _wechatimage.layer.cornerRadius = 25;
    _wechatimage.userInteractionEnabled = YES;
    
    _wechatimage.image = [UIImage imageNamed:@"wx"];
    _wechatimage.contentMode = UIViewContentModeScaleAspectFill;
    _wechatimage.clipsToBounds = YES;
    UITapGestureRecognizer *wechattap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(wechatlogin:)];
    [self.wechatimage addGestureRecognizer:wechattap];
    [self.YZMview addSubview:self.wechatimage];
    
    self.sinaimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW/2+55, 485, 50, 50)];
    _sinaimage.layer.masksToBounds = YES;
    _sinaimage.layer.cornerRadius = 25;
    _sinaimage.userInteractionEnabled = YES;
    _sinaimage.image = [UIImage imageNamed:@"wb"];
    _sinaimage.contentMode = UIViewContentModeScaleAspectFill;
    _sinaimage.clipsToBounds = YES;
    UITapGestureRecognizer *sinatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sinalogin:)];
    [self.sinaimage addGestureRecognizer:sinatap];
    [self.YZMview addSubview:self.sinaimage];
    
    
}

@end
