//
//  SYCollectionViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/3/13.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "SYCollectionViewCell.h"

@implementation SYCollectionViewCell


- (UIImageView *)imageview {
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(15*Kscalew, 10, ScreenW/5-30*Kscalew, ScreenW/5-30*Kscalew)];
//        _imageview.backgroundColor = [UIColor redColor];
    }
    return _imageview;
}

- (UILabel *)lable {
    if (_lable == nil) {
        self.lable = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenW/5-30*Kscalew+15, ScreenW/5, 20)];
//        _lable.backgroundColor = [UIColor redColor];
        self.lable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
        _lable.textAlignment = NSTextAlignmentCenter;
    }
    return _lable;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.lable];
        [self.contentView addSubview:self.imageview];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



@end
