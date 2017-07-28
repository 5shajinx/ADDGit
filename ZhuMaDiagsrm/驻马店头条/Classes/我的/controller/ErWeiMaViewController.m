//
//  ErWeiMaViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/9/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "UMSocial.h"
@interface ErWeiMaViewController ()<UMSocialUIDelegate>

@property(nonatomic, strong)HXEasyCustomShareView *shareView;

@end

@implementation ErWeiMaViewController


- (void)backto {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫码分享";
    //self.view.backgroundColor = [UIColor cyanColor];
    self.view.backgroundColor = [UIColor whiteColor];
 
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(backto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenH-100, ScreenW, 30)];
    lab.text = @"长按分享二维码";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor redColor];
    [self.view addSubview:lab];
    [self.view bringSubviewToFront:lab];
    
    [self erweima];
}

//生产二维码
- (void)erweima
{
//    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
//    [filter setDefaults];
//   // NSString *myAppID = @"1217309519";
//    NSString *dataString = [NSString stringWithFormat:@"http://a.app.qq.com/o/simple.jsp?pkgname=com.zmdtv.client"];
//    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//    [filter setValue:data forKey:@"inputMessage"];
//    CIImage *outputImage = [filter outputImage];
//    //    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 175, 175)];
//    //    imageView.image = [UIImage imageWithCIImage:outputImage];
//    //    [self.view addSubview:imageView];
    UIImageView *newImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW-200*Kscalew)/2, (ScreenH-200*Kscalew)/2, 200*Kscalew, 200*Kscalew)];
    //给死图片
    newImageView.image = [UIImage imageNamed:@"android-ios-erwei"];
    newImageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(sharePicture:)];
    [newImageView addGestureRecognizer:longTap];
  //  newImageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200*Kscalew];
    [self.view addSubview:newImageView];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat )size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width  = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs,(CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaleImage];
}




- (void)sharePicture:(UILongPressGestureRecognizer *)gesture {
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
    NSString *contStr = [NSString stringWithFormat:@"广视融媒新闻客户端下载链接"];
     NSString *Urlstr = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/vseson/wap/wap.html"];
    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.wechatSessionData.url = Urlstr;
        
        //            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
        //                                                imgString];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:contStr image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
            self.shareView.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        
        [UMSocialData defaultData].extConfig.title = contStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = Urlstr;
        //            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
        //                                                imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contStr image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.qqData.url = Urlstr;
        //            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
        //                                                imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:contStr image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = @"驻马店广播电视台";
        [UMSocialData defaultData].extConfig.qzoneData.url = Urlstr;
        //            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
        //                                                imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:contStr image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
        
        //            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
        //                                                imgString];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:contStr image:[UIImage imageNamed:@"android-ios-erwei"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
            self.shareView.hidden = YES;
        }];
        
    }
    
}








@end
