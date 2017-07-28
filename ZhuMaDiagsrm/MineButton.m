//
//  MineButton.m
//  驻马店头条
//
//  Created by 孙满 on 16/11/24.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "MineButton.h"

@implementation MineButton


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
//        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize btnS = contentRect.size;
    CGFloat titleX = 0;
    CGFloat titleY = btnS.height * 0.7;
    CGFloat titleW = btnS.width;
    CGFloat titleH = btnS.height * 0.3;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize btnS = contentRect.size;
    CGFloat imageX = btnS.height * 0.25;
    CGFloat imageY = btnS.height * 0.2;
    CGFloat imageW = btnS.height * 0.5;
    CGFloat imageH = btnS.height * 0.5;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    //在这里可以动态的调整自己的frame
    
    
    
}

@end
