//
//  PasswordLoginController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/21.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "PasswordLoginController.h"


@interface PasswordLoginController ()<UITextFieldDelegate>
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)UILabel *lab;

@property(nonatomic, strong)UIView *YZMview;
@property(nonatomic, strong)UITextField *SJTextfield;
@property(nonatomic, strong)UITextField *YZMTexfield;
@property(nonatomic, strong)UIButton *sendYZM;
@property(nonatomic, strong)UIButton *loginBtn;
@property(nonatomic, strong)UIButton *passwordLoginBtn;


@property(nonatomic, strong)UIView *aYZMview;
@property(nonatomic, strong)UITextField *aSJTextfield;
@property(nonatomic, strong)UITextField *aYZMTexfield;
@property(nonatomic, strong)UIButton *aloginBtn;
@property(nonatomic, strong)UIButton *apasswordLoginBtn;
@property(nonatomic, strong)UIButton *btnn;
@property(nonatomic, strong)UIButton *zhmm;



@property(nonatomic, strong)UITextField *ZCSJTextfield;

@property(nonatomic, strong)UIView *zhaohuiView;
@property(nonatomic, strong)UITextField *ZHSJTextfield;
@property(nonatomic, strong)UITextField *ZHYZM;
@property(nonatomic, strong)UITextField *ZHpass;
@property(nonatomic, strong)UIButton *ZHLOGIN;
@end

@implementation PasswordLoginController
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账号密码登录";
    
    self.btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnn.frame = CGRectMake(20, 20, 30, 30);
    [self.btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [self.btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:self.btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    self.YZMview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _YZMview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.YZMview];
    [self setupyzmlogin];
    
    self.aYZMview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    _aYZMview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.aYZMview];
    _aYZMview.hidden = YES;
    [self setupbackpassword];
    
    
    self.zhaohuiView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.zhaohuiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.zhaohuiView];
    self.zhaohuiView.hidden = YES;
    [self setupzhaohuipassword];
}


- (void)backpassword:(UIButton *)sender {
    if ([Manager valiMobile:self.SJTextfield.text] == nil) {
        [self lodbackpassword];
        _YZMview.hidden = YES;
        _aYZMview.hidden = NO;
    }else {
        self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (ScreenH-30)/2+100, ScreenW , 30)];
        self.lab.text = [Manager valiMobile:self.SJTextfield.text];
        self.lab.textColor = [UIColor redColor];
        self.lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.lab];
        [self performSelector:@selector(removeView) withObject:nil afterDelay:.5f];
    }
}
- (void)removeView {
    self.lab.hidden = YES;
}


- (void)lodbackpassword {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if ([Manager valiMobile:self.SJTextfield.text] == nil) {
        
        NSDictionary *dict = @{@"phone":self.ZCSJTextfield.text};
        [session GET:backmima parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
       //     NSLog(@"---------%@",dicc);
       //    NSLog(@"-----------%@",[dicc objectForKey:@"Message"]);
            if ([code isEqualToString:@"0"] ) {
               //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
           else if ([code isEqualToString:@"1"]) {
               // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
           else if ([code isEqualToString:@"2"]) {
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
           }else {
               //NSLog(@"%@",[dicc objectForKey:@"Message"]);
           }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
        self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (ScreenH-30)/2+100, ScreenW , 30)];
        self.lab.text = [Manager valiMobile:self.SJTextfield.text];
        self.lab.textColor = [UIColor redColor];
        self.lab.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.lab];
        [self performSelector:@selector(removeView) withObject:nil afterDelay:.5f];
    }
}


- (void)commitlogin:(UIButton *)sender {
    [self passwordlogin];
}

- (void)passwordlogin {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSDictionary *dict = @{@"phone":self.SJTextfield.text,@"code":self.aSJTextfield.text};
    [session GET:isture parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
       
        
        if ([code isEqualToString:@"0"] ) {
           // NSLog(@"====%@",[dicc objectForKey:@"Message"]);
            [weakself commitzhanghaomioma];
         }
        if ([code isEqualToString:@"1"]) {
           // NSLog(@"------%@",[dicc objectForKey:@"Message"]);
        }
        if ([code isEqualToString:@"2"]) {
           // NSLog(@"********%@",[dicc objectForKey:@"Message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)commitzhanghaomioma {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [self.aYZMTexfield resignFirstResponder];
    __weak typeof(self) weakself = self;
    if ( [[Manager sharedManager] checkPassWord:self.aYZMTexfield.text] == YES) {
        NSDictionary *dict = @{@"username":self.SJTextfield.text,@"password":self.aYZMTexfield.text};
        //NSLog(@"%@  %@",self.SJTextfield.text,self.aYZMTexfield.text);
        [session GET:commitdata parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            //NSLog(@"*******  %@",dicc);
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
                [Manager sharedManager].usid      = [[dicc objectForKey:@"user"] objectForKey:@"phone"];
                [Manager sharedManager].token     = weakself.YZMTexfield.text;
                [Manager sharedManager].msg       = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
                [Manager sharedManager].type      = @"1";
                [Manager sharedManager].nickname  = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
                [Manager sharedManager].picture   = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
                
                [weakself ZMDThirdPathLogin];
            }
            if ([code isEqualToString:@"1"]) {
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            if ([code isEqualToString:@"2"]) {
               // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            if ([code isEqualToString:@"3"]) {
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }else {
        // NSLog(@"请输入6-20位数字字母组合");
    }
   
}


//第三方登陆
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
        
        //NSLog(@"%@",dicc );
        //nickname  password  phone  ptuid  qopenid  type  username  wopenid  xopenid
        
        [Manager sharedManager].string    = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
        [Manager sharedManager].picString = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
        [Manager sharedManager].qianming  = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
        
//        NSNumber *numString = [[dicc objectForKey:@"user"] objectForKey:@"ptuid"];
//        NSNumberFormatter* numberpt = [[NSNumberFormatter alloc] init];
//        NSString *ptuid = [numberpt stringFromNumber:numString];
//        
        
        NSNumber *ptuid = [[dicc objectForKey:@"user"] objectForKey:@"ptuid"];

        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
           // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            [weakself.textfield resignFirstResponder];
            NSString *dou = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPat = [dou stringByAppendingPathComponent:@"ptuid.text"];
            NSString *ptuidstr = [NSString stringWithFormat:@"%@",ptuid];
            [ptuidstr writeToFile:textPat atomically:YES encoding:NSUTF8StringEncoding error:nil];
            [weakself isornotlogin];
            
            [weakself dismissViewControllerAnimated:YES completion:nil];
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



- (void)login:(UIButton *)sender {
    
      [self.textfield resignFirstResponder];
      [self lodlogin];
}

- (void)lodlogin {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
  
    __weak typeof(self) weakself = self;
    NSDictionary *dict = @{@"username":self.SJTextfield.text,@"password":self.YZMTexfield.text};
    [session GET:zhmmlogin parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//         NSLog(@"*******  %@",dicc);
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
//        NSLog(@"%@",[dicc objectForKey:@"Message"]);
        if ([code isEqualToString:@"0"] ) {
//            NSLog(@"%@",[dicc objectForKey:@"Message"]);
            
            [Manager sharedManager].usid      = [[dicc objectForKey:@"user"] objectForKey:@"phone"];
            [Manager sharedManager].token     = weakself.YZMTexfield.text;
            [Manager sharedManager].msg       = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
            [Manager sharedManager].type      = @"1";
            [Manager sharedManager].nickname  = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
            [Manager sharedManager].picture   = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
            
            [weakself ZMDThirdPathLogin];
        
        }
       else if ([code isEqualToString:@"1"]) {
//            NSLog(@"%@",[dicc objectForKey:@"Message"]);//密码错误
            self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, (ScreenH-30)/2+100, ScreenW , 30)];
            self.lab.text = @"密码错误";
            self.lab.textColor = [UIColor redColor];
            self.lab.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:self.lab];
            [self performSelector:@selector(lodin) withObject:nil afterDelay:1.0f];
        }
       else {
//            NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}
- (void)lodin {
    self.lab.hidden = YES;
}




- (void)isornotlogin{
    //判断标识
    NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *text= [doucments stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *st = @"login";
    [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"username.text"];
    NSString *string = [Manager sharedManager].string;
    [string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
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








- (void)setupyzmlogin {
    self.SJTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 150, ScreenW-80, 40)];
    self.SJTextfield.delegate = self;
    //_SJTextfield.borderStyle = UITextBorderStyleLine;
    [_SJTextfield.layer setBorderWidth:1.0];
    _SJTextfield.layer.borderColor=[UIColor blackColor].CGColor;
    _SJTextfield.placeholder = @" 请输入手机号";
    _SJTextfield.layer.masksToBounds = YES;
    _SJTextfield.layer.cornerRadius = 5;
    self.SJTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.YZMview addSubview:self.SJTextfield];
    
    self.YZMTexfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 220, ScreenW-80, 40)];
    //_YZMTexfield.borderStyle = UITextBorderStyleLine;
    [_YZMTexfield.layer setBorderWidth:1.0];
    _YZMTexfield.layer.borderColor=[UIColor blackColor].CGColor;
    self.YZMTexfield.delegate = self;
    _YZMTexfield.placeholder = @" 请输入密码";
    _YZMTexfield.layer.masksToBounds = YES;
    _YZMTexfield.layer.cornerRadius = 5;
     self.YZMTexfield.secureTextEntry = YES;
    [self.YZMview addSubview:self.YZMTexfield];
    
    self.sendYZM = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendYZM.frame = CGRectMake(10, ScreenH-70, 100, 40);
    [_sendYZM setTitle:@"注册" forState:UIControlStateNormal];
    _sendYZM.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_sendYZM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_sendYZM addTarget:self action:@selector(zcpassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sendYZM];
    
    self.zhmm = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zhmm.frame = CGRectMake(ScreenW-110, ScreenH-70, 100, 40);
    [self.zhmm setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.zhmm.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.zhmm setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.zhmm addTarget:self action:@selector(zhaohuipassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zhmm];

    
    
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(40, 350, ScreenW-80, 30);
    [_loginBtn setTitle:@"进入广视融媒" forState:UIControlStateNormal];
    _loginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
     self.loginBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:118/255.0 blue:197/255.0 alpha:1];
//    [_loginBtn.layer setBorderWidth:1.0];
//    _loginBtn.layer.borderColor=[UIColor redColor].CGColor;
    [_loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.YZMview addSubview:self.loginBtn];
    
}
- (void)zcpassword {
    self.aYZMview.hidden = NO;
}
- (void)zhaohuipassword {

    self.zhaohuiView.hidden = NO;
}



- (void)setupzhaohuipassword {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenW-50, 70, 40, 40) ;
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hidview) forControlEvents:UIControlEventTouchUpInside];
    [self.zhaohuiView addSubview:btn];
    
    
    self.ZHSJTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 150, ScreenW-80, 40)];
    self.ZHSJTextfield.delegate = self;
    //_aSJTextfield.borderStyle = UITextBorderStyleLine;
    [self.ZHSJTextfield.layer setBorderWidth:1.0];
    self.ZHSJTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ZHSJTextfield.placeholder = @" 请输入手机号";
    self.ZHSJTextfield.layer.masksToBounds = YES;
    self.ZHSJTextfield.layer.cornerRadius = 5;
    self.self.ZHSJTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.zhaohuiView addSubview:self.ZHSJTextfield];
    UIButton *btntn = [UIButton buttonWithType:UIButtonTypeCustom];
    btntn.frame = CGRectMake(ScreenW-80-110, 0, 110, 40) ;
    [btntn setTitle:@"|  发送验证码" forState:UIControlStateNormal];
    [btntn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btntn addTarget:self action:@selector(zhfasongyzm) forControlEvents:UIControlEventTouchUpInside];
    [self.ZHSJTextfield addSubview:btntn];
    
    
    
    
    self.ZHYZM = [[UITextField alloc]initWithFrame:CGRectMake(40, 220, ScreenW-80, 40)];
    self.ZHYZM.delegate = self;
    //_aSJTextfield.borderStyle = UITextBorderStyleLine;
    [self.ZHYZM.layer setBorderWidth:1.0];
    self.ZHYZM.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ZHYZM.placeholder = @" 请输入验证码";
    self.ZHYZM.layer.masksToBounds = YES;
    self.ZHYZM.layer.cornerRadius = 5;
    self.ZHYZM.keyboardType = UIKeyboardTypeNumberPad;
    [self.zhaohuiView addSubview:self.ZHYZM];
    
    
    
    self.ZHpass = [[UITextField alloc]initWithFrame:CGRectMake(40, 290, ScreenW-80, 40)];
    //_aYZMTexfield.borderStyle = UITextBorderStyleLine;
    [self.ZHpass.layer setBorderWidth:1.0];
    self.ZHpass.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ZHpass.delegate = self;
    self.ZHpass.placeholder = @" 请输入新的密码";
    self.ZHpass.layer.masksToBounds = YES;
    self.ZHpass.layer.cornerRadius = 5;
    self.ZHpass.secureTextEntry = YES;
    [self.zhaohuiView addSubview:self.ZHpass];
    
    self.ZHLOGIN = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ZHLOGIN.frame = CGRectMake(40, 400, ScreenW-80, 30);
    [self.ZHLOGIN setTitle:@"找回密码成功" forState:UIControlStateNormal];
    self.ZHLOGIN.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.ZHLOGIN.layer.masksToBounds = YES;
    self.ZHLOGIN.layer.cornerRadius = 5;
    self.ZHLOGIN.backgroundColor = [UIColor colorWithRed:34/255.0 green:118/255.0 blue:197/255.0 alpha:1];
    //    [_aloginBtn.layer setBorderWidth:1.0];
    //    _aloginBtn.layer.borderColor=[UIColor redColor].CGColor;
    [self.ZHLOGIN addTarget:self action:@selector(zhaohuimimalogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.ZHLOGIN setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.zhaohuiView addSubview:self.ZHLOGIN];
}
- (void)hidview {
    self.zhaohuiView.hidden = YES;
}

- (void)zhaohuimimalogin:(UIButton *)sender {
    self.zhaohuiView.hidden = YES;
}


- (void)zhfasongyzm {
    
}


- (void)setupbackpassword {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenW-50, 70, 40, 40) ;
    [btn setTitle:@"X" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(hiddenview) forControlEvents:UIControlEventTouchUpInside];
    [self.aYZMview addSubview:btn];
    
    
    self.ZCSJTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 150, ScreenW-80, 40)];
    self.ZCSJTextfield.delegate = self;
    //_aSJTextfield.borderStyle = UITextBorderStyleLine;
    [self.ZCSJTextfield.layer setBorderWidth:1.0];
    self.ZCSJTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.ZCSJTextfield.placeholder = @" 请输入手机号";
    self.ZCSJTextfield.layer.masksToBounds = YES;
    self.ZCSJTextfield.layer.cornerRadius = 5;
    self.ZCSJTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.aYZMview addSubview:self.ZCSJTextfield];
    UIButton *btntn = [UIButton buttonWithType:UIButtonTypeCustom];
    btntn.frame = CGRectMake(ScreenW-80-110, 0, 110, 40) ;
    [btntn setTitle:@"|  发送验证码" forState:UIControlStateNormal];
    [btntn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btntn addTarget:self action:@selector(zcfasongyzm) forControlEvents:UIControlEventTouchUpInside];
    [self.ZCSJTextfield addSubview:btntn];
    
    self.aSJTextfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 220, ScreenW-80, 40)];
    self.aSJTextfield.delegate = self;
    //_aSJTextfield.borderStyle = UITextBorderStyleLine;
    [self.aSJTextfield.layer setBorderWidth:1.0];
    self.aSJTextfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.aSJTextfield.placeholder = @" 请输入验证码";
    self.aSJTextfield.layer.masksToBounds = YES;
    self.aSJTextfield.layer.cornerRadius = 5;
    self.aSJTextfield.keyboardType = UIKeyboardTypeNumberPad;
    [self.aYZMview addSubview:self.aSJTextfield];
    
    
    self.aYZMTexfield = [[UITextField alloc]initWithFrame:CGRectMake(40, 290, ScreenW-80, 40)];
    //_aYZMTexfield.borderStyle = UITextBorderStyleLine;
    [self.aYZMTexfield.layer setBorderWidth:1.0];
    self.aYZMTexfield.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.aYZMTexfield.delegate = self;
    self.aYZMTexfield.placeholder = @" 请输入密码";
    self.aYZMTexfield.layer.masksToBounds = YES;
    self.aYZMTexfield.layer.cornerRadius = 5;
    self.aYZMTexfield.secureTextEntry = YES;
    [self.aYZMview addSubview:self.aYZMTexfield];
    
    self.aloginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _aloginBtn.frame = CGRectMake(40, 400, ScreenW-80, 30);
    [_aloginBtn setTitle:@"注册成功" forState:UIControlStateNormal];
    _aloginBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _aloginBtn.layer.masksToBounds = YES;
    _aloginBtn.layer.cornerRadius = 5;
    _aloginBtn.backgroundColor = [UIColor colorWithRed:34/255.0 green:118/255.0 blue:197/255.0 alpha:1];
//    [_aloginBtn.layer setBorderWidth:1.0];
//    _aloginBtn.layer.borderColor=[UIColor redColor].CGColor;
    [_aloginBtn addTarget:self action:@selector(commitlogin:) forControlEvents:UIControlEventTouchUpInside];
    [_aloginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.aYZMview addSubview:self.aloginBtn];
}

- (void)zcfasongyzm {
    
    [self lodbackpassword];
    
}





- (void)hiddenview {
    self.aYZMview.hidden = YES;
}

//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}



- (void)setTime{
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
        }
    });
    dispatch_resume(_timer);
}

@end
