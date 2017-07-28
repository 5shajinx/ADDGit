//
//  ZBDTDetailsTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/21.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZBDTDetailsTableViewController.h"
#import "UMSocial.h"
#import "UIImageView+WebCache.h"
@interface ZBDTDetailsTableViewController ()<UMSocialUIDelegate>
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonatomic, strong)UIButton *button;
@end

@implementation ZBDTDetailsTableViewController

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _webView;
}

- (void)back {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"直播详情";
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 30, 30);
    [self.button setImage:[UIImage imageNamed:@"分享-2"] forState:UIControlStateNormal];
    self.button.layer.masksToBounds = YES;
    
    [self.button addTarget:self action:@selector(sharebtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nvibar = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    self.navigationItem.rightBarButtonItem = nvibar;
}



- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.button.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidbtn:) name:@"hidbtn" object:nil];
}


- (void)hidbtn:(NSNotification *)text  {
    self.button.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}


- (void)sharebtn{
    self.button.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self addGuanjiaShareView];
}
- (void)addGuanjiaShareView {
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_qq",
                            @"title":@"QQ"},
                          @{@"image":@"shareView_qzone",
                            @"title":@"QQ空间"},
                          @{@"image":@"shareView_wb",
                            @"title":@"新浪微博"},
                          
                          ];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    self.shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.shareView.headerView = headerView;
    float heightt = [self.shareView getBoderViewHeight:shareAry firstCount:7];
    self.shareView.boderView.frame = CGRectMake(0, 0, self.shareView.frame.size.width, heightt);
    self.shareView.middleLineLabel.hidden = YES;
    [self.shareView.cancleButton addSubview:lineLabel1];
    self.shareView.cancleButton.frame = CGRectMake(self.shareView.cancleButton.frame.origin.x, self.shareView.cancleButton.frame.origin.y, self.shareView.cancleButton.frame.size.width, 54);
    self.shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.shareView setShareAry:shareAry delegate:self];
    [self.view addSubview:self.shareView];
    
    [self.tabBarController.tabBar bringSubviewToFront:headerView];
}
#pragma mark HXEasyCustomShareViewDelegate
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)titlee {
    UIImageView *img = [[UIImageView alloc]init];
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.ShareTuBiaoUrlStr]]placeholderImage:[UIImage imageNamed:@"11111"]];
    NSString *strTitle = @"驻马店广播电视台";

    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring];
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                self.ShareTuBiaoUrlStr];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@",self.titleString,[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]] image:img location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
            self.shareView.hidden = YES;
            self.button.hidden = NO;
            self.tabBarController.tabBar.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        
        [UMSocialData defaultData].extConfig.title = self.titleString;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                  self.ShareTuBiaoUrlStr];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@%@",self.titleString,[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]] image:img location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
            self.button.hidden = NO;
            self.tabBarController.tabBar.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.qqData.url = [NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                             self.ShareTuBiaoUrlStr];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@%@",self.titleString,[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]] image:img location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
            self.button.hidden = NO;
            self.tabBarController.tabBar.hidden = YES;
        }];
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = self.titleString;
        [UMSocialData defaultData].extConfig.qzoneData.url = [NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring];
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                             self.ShareTuBiaoUrlStr];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"%@%@",self.titleString,[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]] image:img location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
            self.button.hidden = NO;
            self.tabBarController.tabBar.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
        
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                          self.ShareTuBiaoUrlStr];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titleString,[NSString stringWithFormat:@"%@%@",self.urlstring,self.idtring]] image:img location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
            self.shareView.hidden = YES;
            self.button.hidden = NO;
            self.tabBarController.tabBar.hidden = YES;
        }];
        
    }
    
}









@end
