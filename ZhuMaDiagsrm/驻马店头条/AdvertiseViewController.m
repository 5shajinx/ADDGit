//
//  AdvertiseViewController.m
//  zhibo
//
//  Created on 16/5/17.
//  Copyright  All rights reserved.
//

#import "AdvertiseViewController.h"

@interface AdvertiseViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation AdvertiseViewController
- (void)returnBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"qiDongADURL.text"];
    NSString *urlString = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    self.adUrl = urlString;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH)];
    _webView.scalesPageToFit = YES;
    _webView.backgroundColor = [UIColor whiteColor];
//    if (self.adUrl == nil) {
//        self.adUrl = @"http://www.tripadvisor.cn";
//    }
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}

- (void)setAdUrl:(NSString *)adUrl
{
    _adUrl = adUrl;
    
    
    
}



@end
