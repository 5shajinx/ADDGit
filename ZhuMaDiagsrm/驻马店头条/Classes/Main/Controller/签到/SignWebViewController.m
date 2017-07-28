//
//  SignWebViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/3/23.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//
//签到详情
#import "SignWebViewController.h"
#import "UMSocial.h"
#import "ZMDUserTableViewController.h"


@interface SignWebViewController ()<UMSocialUIDelegate>

@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonnull, strong)UIButton *button;

@end

@implementation SignWebViewController
- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-100*Kscaleh)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    NSString *string = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Sign/index/ptuid/%@",str];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)viewWillAppear:(BOOL)animated {
    
    [Manager sharedManager].dddf = ![Manager sharedManager].dddf;
     
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str == nil && [Manager sharedManager].dddf) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请先登录" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actionsure2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
            
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:user animated:YES completion:nil];
        }];
 
        [alertVC addAction:actionsure2];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    
}

@end
