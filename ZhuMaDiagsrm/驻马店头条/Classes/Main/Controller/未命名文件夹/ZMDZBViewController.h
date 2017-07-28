//
//  ZMDZBViewController.h
//  驻马店头条
//
//  Created by 孙满 on 17/3/23.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDZBViewController : UIViewController<UIScrollViewDelegate>
{
    NSArray  *_JGVCAry;
    NSArray  *_JGTitleAry;
    UIView   *_JGLineView;
    UIScrollView *_MeScroolView;
}
- (instancetype)initWithAddVCARY:(NSArray*)VCS TitleS:(NSArray*)TitleS;


@end
