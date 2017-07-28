//
//  ZJTagViewCell.m
//  ZJTagView
//
//  Created by ZeroJ on 16/10/24.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJTagViewCell.h"

@implementation ZJTagViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 15;
    self.titleLabel.layer.borderWidth = 1;
    self.titleLabel.font =[UIFont systemFontOfSize:15];
}

- (void)setInEditState:(BOOL)inEditState {
    _inEditState = inEditState;
    if (inEditState) {
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        
        
    }
    else {
        self.titleLabel.backgroundColor = [UIColor lightTextColor];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
//        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel = titleLabel;
    }
    
    return _titleLabel;
}
@end
