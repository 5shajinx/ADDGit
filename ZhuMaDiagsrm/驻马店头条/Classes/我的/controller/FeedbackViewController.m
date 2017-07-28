//
//  FeedbackViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "FeedbackViewController.h"
#import "sys/utsname.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (strong, nonatomic)  UITextView *feedbackTextView;
@property(nonatomic, strong)UILabel *lab;
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    // Do any additional setup after loading the view.
    [self setupnavigationbar];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupnavigationbar {
    self.navigationItem.title = @"反馈";
    self.feedbackTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 90, ScreenW-40, 200)];
    self.feedbackTextView.delegate = self;
    self.feedbackTextView.layer.masksToBounds = YES;
    self.feedbackTextView.layer.cornerRadius = 10;
    [_feedbackTextView.layer setBorderWidth:1.0];
    _feedbackTextView.font = [UIFont systemFontOfSize:18];
    _feedbackTextView.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [self.view addSubview:self.feedbackTextView];
    
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 50, 30);
    [btnn setTitle:@"提交" forState:UIControlStateNormal];
    [btnn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(comminInformation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.rightBarButtonItem = bar;
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)comminInformation {
    if (self.feedbackTextView.text.length != 0) {
        [self lodfeedback];
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.feedbackTextView resignFirstResponder];
}





- (void)lodfeedback {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //手机系统版本
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    NSString *information = [NSString stringWithFormat:@"%@系统版本%@",[FeedbackViewController deviceVersion],phoneVersion];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
     __weak typeof(self) weakSelf = self;
    
    if (self.feedbackTextView.text != nil) {
        NSDictionary *dic = @{@"ptuid":str,@"fedback_deviceinfo":information,@"fedback_content":self.feedbackTextView.text};
        
        
        [session POST:@"http://zmdtt.zmdtvw.cn/index.php/api/Fedback/index" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSNumber *number = [diction objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            //NSLog(@"%@",[diction objectForKey:@"Message"]);
            
            if ([code isEqualToString:@"0"] ){
                //NSLog(@"%@",[diction objectForKey:@"Message"]);
                weakSelf.lab = [[UILabel alloc]initWithFrame:CGRectMake((ScreenW-80)/2, (ScreenH-30)/2, 80 , 30)];
                weakSelf.lab.text = @"提交成功";
                weakSelf.lab.textColor = [UIColor redColor];
                [weakSelf.view addSubview:weakSelf.lab];
                
                [weakSelf performSelector:@selector(removeView) withObject:nil afterDelay:1.5f];
            }
            
            [weakSelf.feedbackTextView resignFirstResponder];
            weakSelf.feedbackTextView.text = nil;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }
    
    
}

- (void)removeView {
    self.lab.hidden = YES;
}







+ (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //CLog(@"%@",deviceString);
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus (A1522/A1524)";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6S";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6S Plus";
    
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    //CLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
}








@end
