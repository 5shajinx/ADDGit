//
//  ActivityRuleViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/5/16.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ActivityRuleViewController.h"
#import <MessageUI/MessageUI.h>

@interface ActivityRuleViewController (MFMessageComposeViewControllerDelegate)

@end

@implementation ActivityRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    self.upLabel.backgroundColor = [UIColor whiteColor];
    self.upLabel.font = [UIFont systemFontOfSize:16];
    self.upLabel.numberOfLines = 0;
    
    //  [self.view addSubview:textview];
    
    NSString *labelText = @"《广视融媒》定向流量大放送活动，仅限驻马店用户。\n套餐1:免费可领取1G流量；\n套餐2:1元领取5G流量。\n套餐使用规则：每个月内各种流量套餐只能使用一次，不可重复选择，次月自动生效。\n24小时即可生效，该活动适用于联通、电信，并且2G/3G/4G通用。\n\n有一点大家要注意，赠送的是省内流量哦\n1、电信用户短信开通关闭方式：\n开通：发送KTZMDTT至10001，立即生效。\n关闭：发送TDZMDTT至10001，次月1日生效。";
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (ScreenW < 330) {
        [paragraphStyle setLineSpacing:4];//调整行间距
    _liantongbutton.frame = CGRectMake(50, ScreenH - 100 - 60, 100, 35);
        
    _dianxinbutton.frame = CGRectMake(ScreenW - 50 - 100, ScreenH - 100 - 60, 100, 35);
  
        
    } else{
    [paragraphStyle setLineSpacing:8];//调整行间距
        
    _liantongbutton.frame = CGRectMake(50, ScreenH - 100 - 120, 100, 40);
        
    _dianxinbutton.frame = CGRectMake(ScreenW - 50 - 100, ScreenH - 100 - 120, 100, 40);
        
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.upLabel.attributedText = attributedString;
    [self.upLabel sizeToFit];

    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LiantongButton:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该功能暂未开放" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:actionsure1];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)dianxinButton:(UIButton *)sender {
      [self showMessageView:[NSArray arrayWithObjects:@"10001", nil] title:@"KTZMDTT" body:@"KTZMDTT"];
}




 
 /*
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
btn.frame = CGRectMake(30, ScreenH - 100, (ScreenW-120)/2, 40);
btn.backgroundColor = [UIColor redColor];
[btn setTitle:@"联通传送门" forState:UIControlStateNormal];
[btn addTarget:self action:@selector(liantong) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:btn];

UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
btn1.frame = CGRectMake(ScreenW-(ScreenW-120)/2-30, ScreenH - 100, (ScreenW-120)/2, 40);
btn1.backgroundColor = [UIColor redColor];
[btn1 setTitle:@"电信传送门" forState:UIControlStateNormal];
[btn1 addTarget:self action:@selector(dianxin) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:btn1];
  */

- (void)liantong{
    
}
- (void)dianxin{
    [self showMessageView:[NSArray arrayWithObjects:@"10001", nil] title:@"KTZMDTT" body:@"KTZMDTT"];
}


#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}


#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
