//
//  ShopIngViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/5/16.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ShopIngViewController.h"

@interface ShopIngViewController ()
@property(nonatomic, strong)UIWebView *webView;

@end

@implementation ShopIngViewController
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
    
    
    NSString *string = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/jfmall.php?ptuid=%@",str];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
