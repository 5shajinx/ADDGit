//
//  ErWeiMaController.m
//  驻马店头条
//
//  Created by 孙满 on 17/6/6.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//
//弃用了
#import "ErWeiMaController.h"

@interface ErWeiMaController ()

@property (nonatomic, strong) UIImageView *smallImageView;// 小图视图
@property (nonatomic, strong) UIImageView *bigImageView;// 大图视图
@property (nonatomic, strong) UIView *bgView;// 阴影视图
@end

@implementation ErWeiMaController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"blueBack"] style:UIBarButtonItemStylePlain target:self action:@selector(returnAction)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    
    
    
    
    
    
    
    
    // 小图
    self.smallImageView = [[UIImageView alloc] initWithFrame:CGRectMake((ScreenW - 100)/2, (ScreenH - 100)/2, 100, 100)];
    self.smallImageView.image = [UIImage imageNamed:@"10888"];
    // 添加点击响应
    self.smallImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewBigImage)];
    [self.smallImageView addGestureRecognizer:imageTap];
    [self.view addSubview:self.smallImageView];
    [self viewBigImage];

}
//返回
- (void)returnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewBigImage {
    [self bigImageView];// 初始化大图
    
    // 让大图从小图的位置和大小开始出现
    CGRect originFram = _bigImageView.frame;
    _bigImageView.frame = self.smallImageView.frame;
    [self.view addSubview:_bigImageView];
    
    // 动画到大图该有的大小
    [UIView animateWithDuration:0.5 animations:^{
        // 改变大小
        _bigImageView.frame = originFram;
        // 改变位置
        _bigImageView.center = self.view.center;// 设置中心位置到新的位置
    }];
    
    // 添加阴影视图
    [self bgView];
    [self.view addSubview:_bgView];
    
    // 将大图放到最上层，否则会被后添加的阴影盖住
    [self.view bringSubviewToFront:_bigImageView];
}
// 大图视图
- (UIImageView *)bigImageView {
    if (nil == _bigImageView) {
        _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, (ScreenH - ScreenW) / 2, ScreenW - 60, ScreenW - 60)];
        [_bigImageView setImage:self.smallImageView.image];
        // 设置大图的点击响应，此处为收起大图
        _bigImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImage)];
        [_bigImageView addGestureRecognizer:imageTap];
    }
    return _bigImageView;
}

// 阴影视图
- (UIView *)bgView {
    if (nil == _bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        // 设置阴影背景的点击响应，此处为收起大图
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBigImage)];
        [_bgView addGestureRecognizer:bgTap];
    }
    return _bgView;
}
// 收起大图
- (void)dismissBigImage {
    [self.bgView removeFromSuperview];// 移除阴影
    
    // 将大图动画回小图的位置和大小
    [UIView animateWithDuration:0.3 animations:^{
        // 改变大小
        _bigImageView.frame = self.smallImageView.frame;
        // 改变位置
        _bigImageView.center = self.smallImageView.center;// 设置中心位置到新的位置
    }];
    
    // 延迟执行，移动回后再消灭掉
    double delayInSeconds = 0.3;
    __block ErWeiMaController* bself = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [bself.bigImageView removeFromSuperview];
        bself.bigImageView = nil;
        bself.bgView = nil;
    });
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [self dismissBigImage];
    
    
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
