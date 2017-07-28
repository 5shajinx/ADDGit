//
//  ZMDZhiBoCenterViewController.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/10.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDZhiBoCenterViewController.h"
//尺寸
#define kDeviceHight [UIScreen mainScreen].bounds.size.height
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
@interface ZMDZhiBoCenterViewController ()

@end

@implementation ZMDZhiBoCenterViewController

- (void)Back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    btn.frame = CGRectMake(0, 0, 30, 30);
    //    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    //    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    //    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //    self.navigationItem.leftBarButtonItem = bar;
    
    //显示TabBar
    [self setUpTabBarItem];
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
}
- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"直播" image:[UIImage imageNamed:@"sanjianxingyou"] selectedImage:[UIImage imageNamed:@"sanjianxingyou"]];
    self.tabBarItem = tabBarItem;
    
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
    tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
}

-(instancetype)initWithAddVCARY:(NSArray *)VCS TitleS:(NSArray *)TitleS{
    if (self = [super init]) {
        _JGVCAry = VCS;
        _JGTitleAry = TitleS;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        //先初始化各个界面
        UIView *BJView  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 35 + 30)];
        BJView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:BJView];
        
        for (int i = 0 ; i<_JGVCAry.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*(kDeviceWidth/_JGVCAry.count), 10, kDeviceWidth/_JGVCAry.count, BJView.frame.size.height-2);
            [btn setTitle:_JGTitleAry[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(SeleScrollBtn:) forControlEvents:UIControlEventTouchUpInside];
            [BJView addSubview:btn];
        }
        
        _JGLineView = [[UIView alloc] initWithFrame:CGRectMake(0,BJView.frame.size.height-2, kDeviceWidth/_JGVCAry.count, 2)];
        
        
        _JGLineView.backgroundColor = [UIColor redColor];
        [BJView addSubview:_JGLineView];
        
        
        _MeScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BJView.frame.size.height, kDeviceWidth, kDeviceHight-BJView.frame.size.height-64)];
        _MeScroolView.backgroundColor = [UIColor whiteColor];
        _MeScroolView.pagingEnabled = YES;
        _MeScroolView.delegate = self;
        [self.view addSubview:_MeScroolView];
        
        for (int i2 = 0; i2<_JGVCAry.count; i2++) {
            UIView *view = [[_JGVCAry objectAtIndex:i2] view];
            view.frame = CGRectMake(i2*kDeviceWidth, 0, kDeviceWidth, _MeScroolView.frame.size.height);
            [_MeScroolView addSubview:view];
            [self addChildViewController:[_JGVCAry objectAtIndex:i2]];
        }
        
        [_MeScroolView setContentSize:CGSizeMake(kDeviceWidth*_JGVCAry.count, _MeScroolView.frame.size.height)];
        
    }
    return self;
}

/**
 *  滚动停止调用
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int index = scrollView.contentOffset.x/scrollView.frame.size.width;
    //    NSLog(@"当前第几页====%d",index);
    
    /**
     *  此方法用于改变x轴
     */
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _JGLineView.frame;
        f.origin.x = index*(kDeviceWidth/_JGVCAry.count);
        _JGLineView.frame = f;
    }];
    
    UIButton *btn = [self.view viewWithTag:1000+index];
    for (UIButton *b in btn.superview.subviews) {
        if ([b isKindOfClass:[UIButton class]]) {
            b.selected = (b==btn) ? YES : NO;
        }
    }
    
}

//点击每个按钮然后选中对应的scroolview页面及选中按钮
-(void)SeleScrollBtn:(UIButton*)btn{
    for (UIButton *button in btn.superview.subviews)
    {
        if ([button isKindOfClass:[UIButton class]]) {
            button.selected = (button != btn) ? NO : YES;
        }
    }
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = _JGLineView.frame;
        f.origin.x = (btn.tag-1000)*(kDeviceWidth/_JGVCAry.count);
        _JGLineView.frame = f;
        _MeScroolView.contentOffset = CGPointMake((btn.tag-1000)*kDeviceWidth, 0);
    }];
}


@end
