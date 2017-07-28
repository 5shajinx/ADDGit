//
//  WebviewController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/21.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "WebviewController.h"

@interface WebviewController ()
@property(nonatomic, strong)UIWebView *webView;
@end

@implementation WebviewController
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"直播视频";
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.webView];
    NSURL *url = [NSURL URLWithString:self.str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
