//
//  JRSegmentViewController.m
//  JRSegmentControl
//
//  Created by 湛家荣 on 15/8/29.
//  Copyright (c) 2015年 湛家荣. All rights reserved.
//

#import "JRSegmentViewController.h"

@interface JRSegmentViewController () <UIScrollViewDelegate, JRSegmentControlDelegate>
{
    CGFloat vcWidth;  // 每个子视图控制器的视图的宽
    CGFloat vcHeight; // 每个子视图控制器的视图的高
    
    JRSegmentControl *segment;
    
    BOOL _isDrag;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JRSegmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.navigationController.navigationBar addSubview:line];
    
    
    [self setupScrollView];
    [self setupViewControllers];
    [self setupSegmentControl];
    [self setUpTabBarItem];
    
    
}


//- (void)back {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)setupbutton {
//    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnn.frame = CGRectMake(20, 20, 30, 30);
//    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
//    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
//    self.navigationItem.leftBarButtonItem = bar;
//}

- (void)handleClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.tabBarController.tabBar.hidden = NO;
}


- (CGFloat)itemWidth
{
    if (_itemWidth == 0) {
        _itemWidth = 60.0f;
    }
    return _itemWidth;
}

- (CGFloat)itemHeight
{
    if (_itemHeight == 0) {
        _itemHeight = 30.0f;
    }
    return _itemHeight;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger )supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

/** 设置scrollView */
- (void)setupScrollView
{
    CGFloat Y = 0.0f;
    if (self.navigationController != nil && ![self.navigationController isNavigationBarHidden]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        Y = 64.0f;
    }
    
    vcWidth = self.view.frame.size.width;
    vcHeight = self.view.frame.size.height - Y;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, Y, vcWidth, vcHeight)];
    scrollView.contentSize = CGSizeMake(vcWidth * self.viewControllers.count, vcHeight);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.pagingEnabled = YES;
    scrollView.delegate      = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

/** 设置子视图控制器，这个方法必须在viewDidLoad方法里执行，否则子视图控制器各项属性为空 */
- (void)setupViewControllers
{
    int cnt = (int)self.viewControllers.count;
    for (int i = 0; i < cnt; i++) {
        UIViewController *vc = self.viewControllers[i];
        [self addChildViewController:vc];
        
        vc.view.frame = CGRectMake(vcWidth * i, 0, vcWidth, vcHeight);
        [self.scrollView addSubview:vc.view];
    }
}

/** 设置segment */
- (void)setupSegmentControl
{
    
    _itemWidth = 60.0f;
    // 设置titleView
    segment = [[JRSegmentControl alloc] initWithFrame:CGRectMake(0, 0, _itemWidth * 4, 30.0f)];
    segment.titles = self.titles;
    segment.cornerRadius = 3.0f;
    segment.titleColor = self.titleColor;
    segment.indicatorViewColor = self.indicatorViewColor;
    segment.backgroundColor = self.segmentBgColor;
    
    segment.delegate = self;
    self.navigationItem.titleView = segment;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [segment selectedBegan];
    
    _isDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_isDrag) {
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        [segment setIndicatorViewPercent:percent];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        [segment selectedEnd];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    
    [segment setSelectedIndex:index];
    
    _isDrag = NO;
}



#pragma mark - JRSegmentControlDelegate

- (void)segmentControl:(JRSegmentControl *)segment didSelectedIndex:(NSInteger)index {
    
    CGFloat X = index * self.view.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(X, 0) animated:YES];
}

- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"民生" image:[UIImage imageNamed:@"minshengss"] selectedImage:[UIImage imageNamed:@"minshengss"]];
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
   // tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
    //[tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpTabBarItem];
    }
    return self;
}

@end
