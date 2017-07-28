//
//  WaiLianController.m
//  驻马店头条
//
//  Created by 孙满 on 16/11/16.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "WaiLianController.h"
#import "UMSocial.h"
#import <JavaScriptCore/JavaScriptCore.h>

#import "NewsDetailsTableviewController.h"
#import "WaiLianController.h"

#import "ZMDNPicContentViewController.h"

#import "ZMDPlayerViewController.h"
@interface WaiLianController ()<UMSocialUIDelegate,UIWebViewDelegate>

@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonnull, strong)UIButton *button;
@property(nonatomic, strong)NSString *SHareDetail;//分享的内容

@end

@implementation WaiLianController
- (UIWebView *)webView
{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        self.webView.dataDetectorTypes = UIDataDetectorTypeAll;
    }
    return _webView;
}
- (void)viewDidLoad {
        [super viewDidLoad];
   
        self.view.backgroundColor = [UIColor whiteColor];
        [self setupButton];
  
        self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
        self.webView.scalesPageToFit = YES;
        self.webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.webView];
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    
    self.webView.delegate = self;
  
    
}
//- (void)qtfm:(NSNotification *)text {
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(videoPlay)userInfo:nil repeats:NO];
//    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
//}
//- (void)videoPlay
//
//{
//    NSLog(@"jingruhoutai");
//    [self.webView stringByEvaluatingJavaScriptFromString:@"player.play();"];
//    
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{ JSContext *context =  [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //获取该UIWebview的javascript执行环境
    //在该javascript执行环境中，定义一个js函数
    //ios7 的新特性    
    context[@"iosStartFunction"] = ^() {
        
        //js中的参数 Gy34578
        
        NSArray *args = [JSContext currentArguments];
        NSString *jsvale   = [NSString stringWithFormat:@"%@",args[1]];
        NSString *jsvaleid = [NSString stringWithFormat:@"%@",args[0]];
        
       // NSLog(@"88888888%@%@",jsvale,jsvaleid);
        if ([jsvale isEqualToString:@"4"]) {
            
            [self loadTheMovieUrlWithMovieUrl:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",jsvaleid,jsvale] withTitle:nil];
            
        }else if ([jsvale isEqualToString:@"5"]){
            ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
            
            picContentVc.manyPicLink = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",jsvaleid,jsvale];
            
            picContentVc.sharetitle  = @"";
            picContentVc.picture     = @"";
            
            //                picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:picContentVc animated:YES completion:nil];
            
        }else {
            NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
            [Manager sharedManager].jinru = @"jinruwebview";
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
            
            webCtrol.type =[NSString stringWithFormat:@"%@",jsvale];
            webCtrol.idString =[NSString stringWithFormat:@"%@",jsvaleid];
            
            //                na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:na animated:YES completion:nil];
            
        }
        
        
    };
    //获取webview的标题
    NSString *tittt = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    self.title = [NSString stringWithFormat:@"%@",tittt
                  ];
    self.SHareDetail = [NSString stringWithFormat:@"%@",tittt
                        ];

    
}




//请求视频链接
-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ZMDPlayerViewController *zmdPlayer = [[ZMDPlayerViewController alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakself = self;
    __weak typeof (zmdPlayer) weakPlayer =  zmdPlayer;
    
    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
//         NSLog(@"dianying shipin  %@",dic);
         
         
         zmdPlayer.string = [dic objectForKey:@"ar_title"];
         zmdPlayer.movieURL = [dic objectForKey:@"ar_movieurl"];
         zmdPlayer.ar_id = [dic objectForKey:@"ar_id"];
         zmdPlayer.clicknum = [dic objectForKey:@"ar_onclick"];
         zmdPlayer.ar_pic = [dic objectForKey:@"ar_pic"];
         zmdPlayer.timeString = [dic objectForKey:@"ar_time"];
         zmdPlayer.fabu = [dic objectForKey:@"ar_ly"];
         zmdPlayer.ar_cateid = [dic objectForKey:@"ar_cateid"];
         zmdPlayer.ar_type = [dic objectForKey:@"ar_type"];
         
         [Manager setupclicknum:[dic objectForKey:@"ar_type"] arid:[dic objectForKey:@"ar_id"]];
         
//         weakPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [weakself presentViewController:weakPlayer animated:YES completion:nil];
         [MBProgressHUD hideHUDForView:weakself.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
                        });
         
         //NSLog(@"%@",error);
     }];
    
    
}








- (void)setupButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.frame = CGRectMake(0, 0, 30, 30);
    
    
    
       
    [self.button setImage:[UIImage imageNamed:@"分享-2"] forState:UIControlStateNormal];
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(sharebtn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *nvibar = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    self.navigationItem.rightBarButtonItem = nvibar;
    
}


- (void)sharebtn{
    self.button.hidden = YES;
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
    
    
    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.urlString;
        
//            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                                imgString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.SHareDetail image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
                self.button.hidden = NO;
            }];
        
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.urlString;
//            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                                imgString];
        
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.SHareDetail image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
                self.button.hidden = NO;
            }];
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.qqData.url = self.urlString;
//            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                                imgString];
        
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.SHareDetail image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
                self.button.hidden = NO;
            }];
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.qzoneData.url = self.urlString;
//            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                                imgString];
        
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.SHareDetail image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
                self.button.hidden = NO;
            }];
        
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
       
//            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
//                                                imgString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titleename,self.urlString] image:[UIImage imageNamed:@""] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
                self.button.hidden = NO;
            }];
        
    }
    
}
- (void)Back {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        if ([self.qtfm isEqualToString:@"qtfm"]) {
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.button.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidbtn:) name:@"hidbtn" object:nil];
}
- (void)hidbtn:(NSNotification *)text  {
    self.button.hidden = NO;
}





@end
