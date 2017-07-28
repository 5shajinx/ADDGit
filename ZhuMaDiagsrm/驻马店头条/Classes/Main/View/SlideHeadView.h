//
//  SlideHeadView.h
//  slideNavDemo
//
//  Created by 冯学杰 on 16/3/31.
//  Copyright © 2016年 冯学杰. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SlideHeadView : UIView<UIScrollViewDelegate>

/** 文字scrollView  */
@property (nonatomic, strong) UIScrollView *titleScrollView;
/** 控制器scrollView  */
@property (nonatomic, strong) UIScrollView *contentScrollView;
/** 标签文字  */
@property (nonatomic ,strong) NSMutableArray * titlesArr;
/** 标签按钮  */
@property (nonatomic, strong) NSMutableArray *buttons;
/** 选中的按钮  */
@property (nonatomic ,strong) UIButton * selectedBtn;
/** 选中的按钮背景图  */
@property (nonatomic ,strong) UIImageView * imageBackView;

//用户头像button
@property (nonatomic ,strong) UIButton * userPicButton;

//加号
@property (nonatomic ,strong) UIButton * AddButton;
//添加的图标
@property (nonatomic ,strong) UIImageView * tuBiaoImagr;


//KVO
//@property (nonatomic, strong) NSString *KVOStr;


@property (nonatomic, copy) void(^viewBlock)();

-(void)setSlideHeadView;
-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle;
-(void)removeChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle;
- (void)remove;
-(void)setupTitle;
@property (nonatomic ,strong)UIImageView *btn;
@property (nonatomic, strong)NSString *KvoStr;

//@property (nonatomic ,strong) UIButton * selectedBtn;//标记

@end
