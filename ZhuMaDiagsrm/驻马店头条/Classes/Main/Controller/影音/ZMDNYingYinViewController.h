//
//  ZMDNYingYinViewController.h
//  驻马店头条
//
//  Created by 孙满 on 2017/7/19.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDNYingYinViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray  *_JGVCAry;
    NSArray  *_JGTitleAry;
    UIView   *_JGLineView;
    UIScrollView *_MeScroolView;
}
@property(nonatomic, strong)NSMutableArray *urlArr;
- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;

@end
