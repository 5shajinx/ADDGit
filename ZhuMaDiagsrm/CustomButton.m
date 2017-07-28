//
//  CustomButton.m
//  test
//
//  Created by 郭梦 on 16/9/8.
//  Copyright © 2016年 郭梦. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGSize btnS = contentRect.size;
    CGFloat titleX = 0;
    CGFloat titleY = btnS.height * 0.65;
    CGFloat titleW = btnS.width;
    CGFloat titleH = btnS.height * 0.3;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGSize btnS = contentRect.size;
    CGFloat imageX = btnS.width * 0.25;
    CGFloat imageY = btnS.height * 0.2;
    CGFloat imageW = btnS.width * 0.5;
    CGFloat imageH = btnS.height * 0.4;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    //在这里可以动态的调整自己的frame
    
    
    
}

@end
