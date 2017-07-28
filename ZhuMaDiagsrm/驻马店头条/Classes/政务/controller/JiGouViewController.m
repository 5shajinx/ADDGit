//
//  JiGouViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "JiGouViewController.h"

#import "RightDetailsModel.h"
#import "JiGouDetailsViewController.h"

@interface JiGouViewController ()



@property(nonatomic, strong)UIImageView *imageview;
@property(nonatomic, strong)UILabel *titlelab;
@property(nonatomic, strong)UILabel *numlab;

@end

@implementation JiGouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButton];
    
    
    self.adjustStatusBarHeight = YES;
    self.cellSpacing = 40;
    
    if ([Manager sharedManager].xwcname.count == 1) {
        self.cellWidth = ScreenW;
    }else if ([Manager sharedManager].xwcname.count == 2){
        self.cellWidth = ScreenW/2;
    }else if ([Manager sharedManager].xwcname.count == 3){
        self.cellWidth = ScreenW/3;
    }else if ([Manager sharedManager].xwcname.count == 4){
        self.cellWidth = ScreenW/4;
    }else {
//        self.cellWidth = ScreenW/4;
    }
    
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_showNavBar) {
        self.navigationController.navigationBarHidden = YES;

    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_showNavBar) {
        self.navigationController.navigationBarHidden = NO;
    }
}


#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    if ([Manager sharedManager].xwcname.count == 0) {
        return [Manager sharedManager].xwcname.count;
    }
    return [Manager sharedManager].xwcname.count;
}


- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{
   
    NSString *title = [Manager sharedManager].xwcname[index];
    
    return title;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    JiGouDetailsViewController *VC = [[JiGouDetailsViewController alloc]init];
    
    VC.text = [@(index) stringValue];
    
    return VC;
}


- (void)Back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupButton {
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    vie.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:vie];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    //[btn setTitle:@"back" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [vie addSubview:btn];
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(150*Kscalew, 20, 40, 40)];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageviewstring]];
    self.imageview.layer.masksToBounds = YES;
    self.imageview.layer.cornerRadius = 20;
    [vie addSubview:self.imageview];
    
    self.titlelab = [[UILabel alloc]initWithFrame:CGRectMake(200*Kscalew, 20, 150*Kscalew, 20)];
    self.titlelab.text = self.titlestring;
    self.titlelab.font = [UIFont systemFontOfSize:14];
    [vie addSubview:self.titlelab];
    
    self.numlab = [[UILabel alloc]initWithFrame:CGRectMake(200*Kscalew, 40, 150*Kscalew, 20)];
    self.numlab.text = [NSString stringWithFormat:@"订阅量：%@",self.numstring];
    self.numlab.font = [UIFont systemFontOfSize:14];
    [vie addSubview:self.numlab];
}












@end
