//
//  ActivityController.m
//  驻马店头条
//
//  Created by 孙满 on 16/12/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ActivityController.h"
#import "ActivityRuleViewController.h"
@interface ActivityController ()<UITextFieldDelegate>
{
    NSString *string;
    NSString *operators;
}
@property(nonatomic, strong)UITextField *textfield;
@end

@implementation ActivityController

- (void)back {
    NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *text11= [doucments11 stringByAppendingPathComponent:@"ad.text"];
    NSString *st11 = @"ad1";
    [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupbackbutton {
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
}

- (void)xiugaikongjian {
    self.zeroButton.layer.masksToBounds = YES;
    self.zeroButton.layer.cornerRadius = 5;
    [self.zeroButton.layer setBorderWidth:1.0];
    self.zeroButton.layer.borderColor=[UIColor orangeColor].CGColor;
    
    self.oneButton.layer.masksToBounds = YES;
    self.oneButton.layer.cornerRadius = 5;
    [self.oneButton.layer setBorderWidth:1.0];
    self.oneButton.layer.borderColor=[UIColor orangeColor].CGColor;
    
    self.phoneTextfield.delegate = self;
    self.phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextfield.layer.masksToBounds = YES;
    self.phoneTextfield.layer.cornerRadius = 5;
    [self.phoneTextfield.layer setBorderWidth:1.0];
    self.phoneTextfield.layer.borderColor=[UIColor orangeColor].CGColor;
    
    self.passwordTextfield.delegate = self;
    self.passwordTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTextfield.layer.masksToBounds = YES;
    self.passwordTextfield.layer.cornerRadius = 5;
    [self.passwordTextfield.layer setBorderWidth:1.0];
    self.passwordTextfield.layer.borderColor=[UIColor orangeColor].CGColor;
    
    self.lingquButton.backgroundColor = [UIColor orangeColor];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self setupbackbutton];
    [self xiugaikongjian];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"ad",@"ad",nil];
    NSNotification *notification =[NSNotification notificationWithName:@"ad" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}
- (void)viewWillAppear:(BOOL)animated {
}
- (IBAction)clickZeroButton:(id)sender {
    
    self.zeroButton.backgroundColor = [UIColor orangeColor];
    [self.zeroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    self.oneButton.backgroundColor =  [UIColor whiteColor];
    [self.oneButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    string = @"0";
}
- (IBAction)clickOneButton:(id)sender {
    self.zeroButton.backgroundColor = [UIColor whiteColor];
    [self.zeroButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    
    self.oneButton.backgroundColor =  [UIColor orangeColor];
    [self.oneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    string = @"1";
}




- (IBAction)clickSendYZM:(id)sender {
    [self lodPhoneZeron];
}
- (void)lodPhoneZeron{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSDictionary *dic = @{@"phone":self.phoneTextfield.text,@"key":@"bdf71ca268ebdf15eadab08fec934fb7"};
    
    [session GET:@"http://apis.juhe.cn/mobile/get" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        if (![[dicc objectForKey:@"resultcode"] isEqualToString:@"200"]) {
            if ([Manager valiMobile:self.phoneTextfield.text] == nil) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择类型" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"联通" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    operators = @"2";
                    NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                    NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                    NSString *st11 = operators;
                    [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    [weakself lodyzm];
                }];
                UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"移动" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    operators = @"1";
                    NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                    NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                    NSString *st11 = operators;
                    [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    [weakself lodyzm];
                }];
                UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"电信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    operators = @"3";
                    NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                    NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                    NSString *st11 = operators;
                    [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    [weakself lodyzm];
                }];
                [alert addAction:action1];
                [alert addAction:action2];
                [alert addAction:action3];
                
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[Manager valiMobile:self.phoneTextfield.text] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionC];
                [self presentViewController:alert animated:YES completion:nil];
            }
 
            
        }else {
            NSMutableDictionary *dic = [dicc objectForKey:@"result"];
            if ([[dic objectForKey:@"company"] containsString:@"联通"]) {
                operators = @"2";
                NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                NSString *st11 = operators;
                [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }else if ([[dic objectForKey:@"company"] containsString:@"移动"]){
                operators = @"1";
                NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                NSString *st11 = operators;
                [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }else {
                operators = @"3";
                NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
                NSString *text11= [doucments11 stringByAppendingPathComponent:@"operators.text"];
                NSString *st11 = operators;
                [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            if ([[dic objectForKey:@"city"] containsString:@"驻马店"] ) {
                [weakself lodyzm];
            }else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"非驻马店号，暂不支持参与活动" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionC];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

- (void)lodyzm{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *dict = @{@"phone":self.phoneTextfield.text};
    __weak typeof(self) weakself = self;
    if ([Manager valiMobile:self.phoneTextfield.text] == nil) {
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
            }else if ([code isEqualToString:@"0"] ) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dicc objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionC];
                [self presentViewController:alert animated:YES completion:nil];
            }else if ([code isEqualToString:@"1"]) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }else if ([code isEqualToString:@"2"]) {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }else {
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[Manager valiMobile:self.phoneTextfield.text] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:actionC];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
                self.yzmButton.clipsToBounds = YES;
                [self.yzmButton setTitle:@"|发送验证码" forState:UIControlStateNormal];
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"正在发送(%.dS)", seconds];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.yzmButton setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
            self.yzmButton.clipsToBounds = NO;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)clickLingQuButton:(id)sender {
   [self lodLogin];
}


- (void)lodLogin{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSString *dom1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex1 = [dom1 stringByAppendingPathComponent:@"operators.text"];
    NSString *oper = [NSString stringWithContentsOfFile:tex1 encoding:NSUTF8StringEncoding error:nil];
    
    
    if (self.phoneTextfield.text != nil && self.passwordTextfield.text != nil && string != nil && oper != nil) {
        NSDictionary *dict = @{@"phone":self.phoneTextfield.text,@"code":self.passwordTextfield.text,@"stretch":string,@"operators":oper};
        [session GET:@"http://zmdtt.zmdtvw.cn/index.php/api/ptuser/trafficPhone" parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
           
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                //  NSLog(@"%@",[dicc objectForKey:@"Message"]);
                
                [Manager sharedManager].usid      = [[dic objectForKey:@"user"] objectForKey:@"phone"];
                [Manager sharedManager].token     = weakself.passwordTextfield.text;
                [Manager sharedManager].msg       = [[dic objectForKey:@"user"] objectForKey:@"msg"];
                [Manager sharedManager].type      = @"1";
                [Manager sharedManager].nickname  = [[dic objectForKey:@"user"] objectForKey:@"nickname"];
                [Manager sharedManager].picture   = [[dic objectForKey:@"user"] objectForKey:@"photo"];
                
                [weakself ZMDThirdPathLogin];
            }
            if ([code isEqualToString:@"1"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dic objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionC];
                [self presentViewController:alert animated:YES completion:nil];
            }
            if ([code isEqualToString:@"2"]) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dic objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alert addAction:actionC];
                [self presentViewController:alert animated:YES completion:nil];
            }
            [self.phoneTextfield resignFirstResponder];
            [self.passwordTextfield resignFirstResponder];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }

}
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
        
        //        NSLog(@" //nickname  password  phone  ptuid  qopenid  type  username  wopenid  xopenid     ======  %@",dicc );
        //nickname  password  phone  ptuid  qopenid  type  username  wopenid  xopenid
        
        [Manager sharedManager].string    = [[dicc objectForKey:@"user"] objectForKey:@"nickname"];
        [Manager sharedManager].picString = [[dicc objectForKey:@"user"] objectForKey:@"photo"];
        [Manager sharedManager].qianming = [[dicc objectForKey:@"user"] objectForKey:@"msg"];
        
//        NSNumber *numString = [[dicc objectForKey:@"user"] objectForKey:@"ptuid"];
//        NSNumberFormatter* numberpt = [[NSNumberFormatter alloc] init];
//        NSString *ptuid = [numberpt stringFromNumber:numString];
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
           
        }
        if ([code isEqualToString:@"1"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dicc objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:actionC];
            [self presentViewController:alert animated:YES completion:nil];
        }
        if ([code isEqualToString:@"2"]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[dicc objectForKey:@"Message"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:actionC];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)isornotlogin{
    //判断标识
    NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *text= [doucments stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *st = @"login";
    [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"username.text"];
    NSString *stringg = [Manager sharedManager].string;
    [stringg writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
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
    
    
    NSString *doucments11 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *text11= [doucments11 stringByAppendingPathComponent:@"ad.text"];
    NSString *st11 = @"ad1";
    [st11 writeToFile:text11 atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"领取成功" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:actionC];
    [self presentViewController:alert animated:YES completion:nil];
    
   
}



- (IBAction)clickActivityButton:(id)sender {
    ActivityRuleViewController *activity = [[ActivityRuleViewController alloc]init];
    [self.navigationController pushViewController:activity animated:YES];
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
@end
