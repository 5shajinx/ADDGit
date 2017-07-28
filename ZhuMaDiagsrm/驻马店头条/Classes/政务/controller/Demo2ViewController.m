//
//  Demo1ViewController.m
//  DLSlideViewDemo
//
//  Created by Dongle Su on 14-12-11.
//  Copyright (c) 2014年 dongle. All rights reserved.
//

#import "Demo2ViewController.h"
#import "DLFixedTabbarView.h"
#import "oneViewController.h"

#import "threeViewController.h"

#import "ZWTwoViewController.h"
#import "ZhengKuTableViewController.h"


@interface Demo2ViewController ()

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 62, ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.view addSubview:line];
    
    self.tabedSlideView.baseViewController = self;
    self.tabedSlideView.tabItemNormalColor = [UIColor blackColor];
    
    self.tabedSlideView.tabItemSelectedColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarTrackColor = [UIColor colorWithRed:0.833 green:0.052 blue:0.130 alpha:1.000];
    self.tabedSlideView.tabbarBackgroundImage = [UIImage imageNamed:@"tabbarBk"];
    self.tabedSlideView.tabbarBottomSpacing = 3.0;
    
    DLTabedbarItem *item1 = [DLTabedbarItem itemWithTitle:@"发布大厅" image:[UIImage imageNamed:@"goodsNew"] selectedImage:[UIImage imageNamed:@"goodsNew_d"]];
    
    DLTabedbarItem *item2 = [DLTabedbarItem itemWithTitle:@"机构列表" image:[UIImage imageNamed:@"goodsHot"] selectedImage:[UIImage imageNamed:@"goodsHot_d"]];
    
    
    
    
    
    DLTabedbarItem *item3 = [DLTabedbarItem itemWithTitle:@"政库服务" image:[UIImage imageNamed:@"goodsHot"] selectedImage:[UIImage imageNamed:@"goodsHot_d"]];
    
    
    
    self.tabedSlideView.tabbarItems = @[item1, item2,item3];
    [self.tabedSlideView buildTabbar];
    
    self.tabedSlideView.selectedIndex = 0;


}



- (NSInteger)numberOfTabsInDLTabedSlideView:(DLTabedSlideView *)sender{
    return 3;
}
- (UIViewController *)DLTabedSlideView:(DLTabedSlideView *)sender controllerAt:(NSInteger)index{
    switch (index) {
        case 0:
        {
            oneViewController *ctrl = [[oneViewController alloc] init];
            return ctrl;
        }
        case 1:
        {
            ZWTwoViewController *ctrl = [[ZWTwoViewController alloc] init];
            return ctrl;
        }
        case 2:
        {
ZhengKuTableViewController *ctrl = [[ZhengKuTableViewController alloc] init];
        
    UINavigationController *ZKnaVC = [[UINavigationController alloc]initWithRootViewController:ctrl];
            
            return ZKnaVC;
        }
                default:
            return nil;
    }
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpTabBarItem];
    }
    return self;
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"政务" image:[UIImage imageNamed:@"shujidetu"] selectedImage:[UIImage imageNamed:@"shujidetu"]];
    self.tabBarItem = tabBarItem;
    
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
    //tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    tabBarItem.imageInsets = UIEdgeInsetsMake(-4, 0,4, 0);
}


@end
