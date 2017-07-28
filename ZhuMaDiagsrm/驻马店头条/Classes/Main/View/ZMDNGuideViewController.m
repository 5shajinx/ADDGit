//
//  ZMDNGuideViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/10.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNGuideViewController.h"
#import "ZMDNMainViewController.h"
#import "ZhengKuTableViewController.h"
//#define ScreenFrame [UIScreen mainScreen].bounds
#import "ZMDNNavViewController.h"
#import "Demo2ViewController.h"
#import "CustomPagerController.h"

#import "hudongViewController.h"
#import "JRSegmentViewController.h"
#import "ZMDZBViewController.h"
#import "ZMDZhiBoCenterViewController.h"
#import "YinPinViewController.h"
#import "ZBDTTableViewController.h"
#import "ZMDDSViewController.h"
#import "ZMDZBRoomViewController.h"
#define PageNum 4

@interface ZMDNGuideViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) UIScrollView * launchScollView;

@property(nonatomic, strong)  UIPageControl *pageControl;
//@property (nonatomic,strong) ZMDNMainViewController *courseTable;
@property(nonatomic, strong) ZMDNNavViewController *nav;

@end

@implementation ZMDNGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self initLaunchImageScollView];
    [self addImageViews];
    [self initPageControl];
    
}



-(void)initLaunchImageScollView
{
    _launchScollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, ScreenW, ScreenH+20)];
    [self.view addSubview:_launchScollView];
    _launchScollView.pagingEnabled = YES;
    _launchScollView.bounces = NO;
    _launchScollView.showsVerticalScrollIndicator = 0;
    _launchScollView.showsHorizontalScrollIndicator = 0;
    _launchScollView.contentSize = CGSizeMake(PageNum * ScreenW , 0);
    _launchScollView.delegate = self;
}



//添加图片视图
-(void)addImageViews
{
    NSArray *images = @[@"WeChat1",@"WeChat2",@"WeChat3",@"WeChat4"];
    
    for (int i = 0; i < PageNum; i++)
    {
        UIImageView *launchImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenW, -20, ScreenW, ScreenH+20)];
        launchImage.contentMode=UIViewContentModeScaleAspectFill;
        launchImage.clipsToBounds = YES;
        launchImage.userInteractionEnabled = YES;
        launchImage.image = [UIImage imageNamed:images[i]];
        [_launchScollView addSubview:launchImage];
        if (i == (PageNum - 1))
        {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((ScreenW-150)/2, ScreenH-50, 150, 50);
            
            btn.backgroundColor = [UIColor clearColor];
            //btn.backgroundColor = [UIColor redColor];
            [btn addTarget:self action:@selector(gotoApp:) forControlEvents:UIControlEventTouchUpInside];
            [launchImage addSubview:btn];
            
            
            
//            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoApp:)];
//            tap.numberOfTapsRequired = 1;
//            tap.numberOfTouchesRequired = 1;
//            [launchImage addGestureRecognizer:tap];
        }
        
    }
}


-(void)initPageControl
{
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.center = CGPointMake(ScreenW/2, ScreenH - 15);
    _pageControl.bounds = CGRectMake(0, 0, 150, 50);
    _pageControl.numberOfPages = PageNum;
    _pageControl.currentPage = 0;
    [_pageControl setCurrentPageIndicatorTintColor:[UIColor redColor]];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    
    //2.5添加点击事件
    [_pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}


//page添加点击事件
- (void)handlePageControlAction:(UIPageControl *)pageCon{
  
    NSInteger page = pageCon.currentPage;
    
   [_launchScollView setContentOffset:CGPointMake(ScreenW * page, 0)];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger x = scrollView.contentOffset.x/ScreenW;
    _pageControl.currentPage = x;
}



-(void)gotoApp:(UIButton*)sender
{
    
    
//    [Manager sharedManager].liuliang = @"liuliang";
//    
//       
//    CustomPagerController   *movie   = [[CustomPagerController alloc]init];
//    
//    
//    ZhengKuTableViewController *zhengku = [[ZhengKuTableViewController alloc]init];
//    UINavigationController *nazhengku = [[UINavigationController alloc]initWithRootViewController:zhengku];
//    
//    
//    ZMDNMainViewController *viewC = [[ZMDNMainViewController alloc] init];
//    UINavigationController  *nav = [[ZMDNNavViewController alloc] initWithRootViewController:viewC];
//    
//    
//    Demo2ViewController *zhengwu = [[Demo2ViewController alloc]init];
//    
//    
//    hudongViewController *hudong = [[hudongViewController alloc]init];
//    UINavigationController *nazhengVC= [[UINavigationController alloc]initWithRootViewController:hudong];
//    
//   
//    
//    nazhengVC.tabBarItem.title = @"民生";
//    nazhengVC.tabBarItem.image = [UIImage imageNamed:@"minshengss"];
//    nazhengVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
//
//
//    
//    
//    UITabBarController *tabbarcontroller = [[UITabBarController alloc]init];
//    tabbarcontroller.viewControllers = @[movie,nazhengku,nav,zhengwu,nazhengVC];
//    tabbarcontroller.tabBar.barTintColor = [UIColor clearColor];
//    tabbarcontroller.selectedIndex = 2;
//    
//    [[UITabBar appearance] setShadowImage:[UIImage new]];
//    
//    [tabbarcontroller.tabBar setBackgroundImage:[UIImage new]];
//    
//    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -7, ScreenW, 56)];
//    lable.backgroundColor = [UIColor whiteColor];
//    
//    // lable.backgroundColor = [UIColor whiteColor];
//    [tabbarcontroller.tabBar addSubview:lable];
//    [tabbarcontroller.tabBar sendSubviewToBack:lable];
//    
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -7, ScreenW, 1)];
//    lab.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
//    [tabbarcontroller.tabBar addSubview:lab];
//    
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabbarcontroller;
    
    

    ZMDNMainViewController *mainVC =  [[ZMDNMainViewController alloc] init];
    _nav = [[ZMDNNavViewController alloc] initWithRootViewController:mainVC];
    //视听
    ZMDZBViewController *ZhiBovc = [[ZMDZBViewController alloc] initWithAddVCARY:@[[CustomPagerController new],[YinPinViewController new],[ZMDDSViewController new]] TitleS:@[@"电视点播",@"广播直播",@"电视直播"]];
    UINavigationController *ZhiBonav = [[UINavigationController alloc] initWithRootViewController:ZhiBovc];
    
    
  
    //新直播
    ZMDZhiBoCenterViewController *newvc = [[ZMDZhiBoCenterViewController alloc] initWithAddVCARY:@[[ZBDTTableViewController new],[ZBDTTableViewController new],[ZMDZBRoomViewController new]] TitleS:@[@"视频直播",@"图文直播",@"直播间"]];
    
    
    
    UINavigationController *nzhiboav = [[UINavigationController alloc] initWithRootViewController:newvc];
    
    Demo2ViewController *zhengwu = [[Demo2ViewController alloc]init];
    
    
    //互动
    hudongViewController *hudong = [[hudongViewController alloc]init];
    
    
    
    UINavigationController *nazhengVC= [[UINavigationController alloc]initWithRootViewController:hudong];
    
    nazhengVC.tabBarItem.title = @"民生";
    nazhengVC.tabBarItem.image = [UIImage imageNamed:@"minshengss"];
    
    nazhengVC.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    
    
    //TabBarController
    UITabBarController *tabbarcontroller = [[UITabBarController alloc]init];
    tabbarcontroller.viewControllers = @[ZhiBonav,zhengwu,_nav,nzhiboav,nazhengVC];
    tabbarcontroller.tabBar.barTintColor = [UIColor clearColor];
    tabbarcontroller.selectedIndex = 2;
    
    [[UITabBar appearance] setShadowImage:[UIImage new]];
    
    [tabbarcontroller.tabBar setBackgroundImage:[UIImage new]];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW,49+5)];
    lable.backgroundColor = [UIColor whiteColor];
    [tabbarcontroller.tabBar addSubview:lable];
    [tabbarcontroller.tabBar sendSubviewToBack:lable];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, ScreenW, 1)];
    lab.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [tabbarcontroller.tabBar addSubview:lab];
    
    for (UIBarItem *item in tabbarcontroller.tabBar.items) {
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIFont fontWithName:@"Helvetica" size:14.0], NSFontAttributeName, nil]
                            forState:UIControlStateNormal];
        tabbarcontroller.tabBar.tintColor = [UIColor redColor];
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:[UIColor redColor] forKey:NSBackgroundColorAttributeName];
        [item setTitleTextAttributes:dict forState:UIControlStateSelected];
    }
    
    
     [UIApplication sharedApplication].keyWindow.rootViewController = tabbarcontroller;
    
   }






@end
