//
//  ZMDNTianXiaViewController.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/11.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDNTianXiaViewController.h"

@interface ZMDNTianXiaViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;

@end

@implementation ZMDNTianXiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    
    
    [self simpleUIWebViewTest];
    
    
    
    
    
    
    // Do any additional setup after loading the view.
}
- (void)simpleUIWebViewTest {
    // 1.创建webview，并设置大小，"20"为状态栏高度
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    // 2.创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_myUrlStr]];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [webView loadRequest:request];
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    if (response.statusCode != 200) {
        
        
        
        [self showOnleText:@"数据返回失败,请稍后重试" delay:1];
        
        
        
        
        
        
        
        return NO;
    }
    return YES;
}



- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
     hud.center = self.view.center;//屏幕正中心
    
    
    [hud hideAnimated:YES afterDelay:delay];
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
