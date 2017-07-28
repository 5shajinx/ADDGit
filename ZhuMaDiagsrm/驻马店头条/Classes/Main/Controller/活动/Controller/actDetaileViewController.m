//
//  actDetaileViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/11.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "actDetaileViewController.h"
#import "UMSocial.h"
#import "CommentDetailViewController.h"
@interface actDetaileViewController ()
@property(nonatomic, strong)UILabel *numberLabel;
@property(nonatomic, strong)NSString *titlee;//分享
@property(nonatomic, strong)NSString *shareUrl;//分享
@property(nonatomic, strong)NSString *imgString;//分享的标记
@property(nonatomic, strong)HXEasyCustomShareView *shareView;

@end

@implementation actDetaileViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    self.titlee= [NSString stringWithFormat:@"%@",self.anameString];
    self.shareUrl = [NSString stringWithFormat:@"%@", self.URLString];
   
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self requsetdate];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = [NSString stringWithFormat:@"在现场"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    

    //数据请求
    [self requsetdate];

    //控件展示
    [self showdetaile];

}
//数据请求
- (void)requsetdate{
    NSString *stttt = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comcount/aid/%@",self.commidStr];
    
    //NSLog(@"777777%@",self.commidStr);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:stttt parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"number"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
  
}

//返回
- (void)Back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)showdetaile{
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    
    [self.view addSubview:webview];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - 40, ScreenW, 40)];
    bgview.backgroundColor = [UIColor colorWithRed:0.5 green:0.0 blue:0.0 alpha:0];
    
    UIButton *retButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retButton.frame = CGRectMake(5, 0, 35, 35);
    [retButton setImage:[UIImage imageNamed:@"houtuiii"] forState:UIControlStateNormal];
    
    [retButton addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 80, 0, 35, 35)];
    imageView.image = [UIImage imageNamed:@"liuyann"];
    UITapGestureRecognizer *numGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(numberAction)];
    [imageView addGestureRecognizer:numGes];
    imageView.userInteractionEnabled = YES;
    imageView.backgroundColor = [UIColor clearColor];
    
     self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(35/2, 0, 35/2, 13)];
    _numberLabel.backgroundColor = [UIColor redColor];

   
    _numberLabel.font = [UIFont systemFontOfSize:13];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *Shareimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 40, 0, 35, 35)];
    Shareimage.image = [UIImage imageNamed:@"shaa"];
    UITapGestureRecognizer *shareGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareAction)];
    [Shareimage addGestureRecognizer:shareGes];
    Shareimage.userInteractionEnabled = YES;
    Shareimage.backgroundColor = [UIColor clearColor];
  
    
    //imageView.layer.masksToBounds = Shareimage.layer.masksToBounds = YES;
    //imageView.layer.cornerRadius = Shareimage.layer.cornerRadius = 35/2;
    bgview.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    
    
    [bgview addSubview:Shareimage];
    [imageView addSubview:_numberLabel];
    [bgview addSubview:imageView];
    [bgview addSubview:retButton];
    [self.view addSubview:bgview];
    
    
    
    
}
- (void)numberAction{
    CommentDetailViewController *commentVC = [[CommentDetailViewController alloc]init];
    
    commentVC.aidStr = [NSString stringWithFormat:@"%@",self.commidStr];
    commentVC.anameString = [NSString stringWithFormat:@"%@",self.anameString];

    [self.navigationController pushViewController:commentVC animated:YES];
    
    
    
    
}
- (void)shareAction{
    [self addGuanjiaShareView];
}
//创建分享UI
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
    NSString *countStr = @"驻马店广播电视台";

    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = _shareUrl;
        if ([_imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _imgString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        
        [UMSocialData defaultData].extConfig.title = self.titlee;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = _shareUrl;
        
        if ([_imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _imgString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.qqData.url = _shareUrl;
        
        if ([_imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _imageString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
        
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = _shareUrl;
        
        if ([_imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _imageString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
         self.imgString = [NSString stringWithFormat:@"%@", self.imageString];
        if ([_imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titlee,_shareUrl] image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                _imageString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titlee,_shareUrl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
            
        }
        
    }
    
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
