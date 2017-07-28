
//
//  ZMDNNavViewController.m
//  cqzmd
//
//  Created by Mac10.11.4 on 16/4/21.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNNavViewController.h"
#import "ActivityController.h"


@interface ZMDNNavViewController ()
{
    UIView *redview;
}
@property(nonatomic,strong)UILabel *imageview1;
@property(nonatomic,strong)UILabel *imageview2;
@property(nonatomic,strong)UIView *vieww;

@end

@implementation ZMDNNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    //cliptoBouce 为NO时才能设置layer层的阴影；
    //先创建uiview
    redview = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-31, -13, 62, 62)];
    redview.backgroundColor = [UIColor clearColor];
    redview.layer.cornerRadius = 31;
    redview.layer.borderWidth = 1.0f;
    redview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    redview.layer.shadowColor = [UIColor blackColor].CGColor;
    redview.layer.shadowOpacity = 0.8f;
    redview.layer.shadowRadius = 3.0;
    redview.layer.shadowOffset = CGSizeMake(0, 1);
    
//    NSString *dom1 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
//    NSString *tex1 = [dom1 stringByAppendingPathComponent:@"ad.text"];
//    NSString *string1 = [NSString stringWithContentsOfFile:tex1 encoding:NSUTF8StringEncoding error:nil];
//    if ([[Manager sharedManager].liuliang isEqualToString:@"liuliang"]) {
//        if (![string1 isEqualToString:@"ad1"]) {
//            [self setupad];
//        }
//    }
    
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}


-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
   return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}



- (void)viewWillDisappear:(BOOL)animated {
    
    self.imageview2.hidden = YES;
    
    [self.tabBarController.tabBar addSubview:redview];
    
    
    self.imageview1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-31, -13, 62, 62)];
    self.imageview1.backgroundColor = [UIColor whiteColor];
    self.imageview1.layer.masksToBounds = YES;
    self.imageview1.layer.cornerRadius = 31;
    self.imageview1.text = @"首页";
    self.imageview1.numberOfLines = 0;
    
    self.imageview1.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:18];
    [self.imageview1.layer setBorderWidth:1.0];
    self.imageview1.layer.borderColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    
    self.imageview1.textColor = [UIColor grayColor];
    self.imageview1.textAlignment = NSTextAlignmentCenter;
    [self.tabBarController.tabBar addSubview:self.imageview1];
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"two",@"one", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}




- (void)viewWillAppear:(BOOL)animated {

    
    self.imageview1.hidden = YES;
    
    
    [self.tabBarController.tabBar addSubview:redview];
    
    
    self.imageview2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-31, -13, 62, 62)];
    
    self.imageview2.backgroundColor = [UIColor whiteColor];
    self.imageview2.layer.masksToBounds = YES;
    self.imageview2.layer.cornerRadius = 31;
    //self.imageview2.alpha = 1.0;
    
    [self.imageview2.layer setBorderWidth:1.0];
    self.imageview2.layer.borderColor=[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor;
    
    self.imageview2.text = @"广视\n融媒";
    self.imageview2.numberOfLines = 0;
    self.imageview2.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:16];
    self.imageview2.textColor = [UIColor redColor];
    self.imageview2.textAlignment = NSTextAlignmentCenter;
    
    [self.tabBarController.tabBar addSubview:self.imageview2];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ad) name:@"ad" object:nil];
    
}
- (void)ad {
    self.vieww.hidden = YES;
}

- (void)setupad {
    
    self.vieww = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.vieww.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    [self.view addSubview:self.vieww];
    UIImageView *imageAD = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW-250*Kscalew)/2, (ScreenH-300*Kscaleh)/2, 250*Kscalew, 300*Kscaleh)];
    imageAD.backgroundColor = [UIColor redColor];
    imageAD.layer.masksToBounds = YES;
    imageAD.layer.cornerRadius = 8;
    imageAD.userInteractionEnabled = YES;
    imageAD.image = [UIImage imageNamed:@"hb.png"];
    imageAD.contentMode = UIViewContentModeScaleAspectFill;
    imageAD.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAD:)];
    [imageAD addGestureRecognizer:tap];
    [self.vieww addSubview:imageAD];
    [self.view bringSubviewToFront:self.vieww];
  
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((ScreenW-250*Kscalew)/2+250*Kscalew-10, (ScreenH-300*Kscaleh)/2-27, 30, 30);
    [btn setTitle:@"X" forState:UIControlStateNormal];
 [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 15;
    [btn.layer setBorderWidth:1.0];
    btn.layer.borderColor=[UIColor blackColor].CGColor;
    [btn addTarget:self action:@selector(hidview) forControlEvents:UIControlEventTouchUpInside];
    [self.vieww addSubview:btn];
}
- (void)clickAD:(UITapGestureRecognizer *)sender {
    ActivityController *activity = [[ActivityController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:activity];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
}
- (void)hidview {
    [self.vieww removeFromSuperview];
}

@end
