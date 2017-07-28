//
//  LeftCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/22.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "LeftCell.h"
#import "Manager.h"

@implementation LeftCell

- (UIImageView *)cirleLable {
    if (_cirleLable == nil) {
        self.cirleLable = [[UIImageView alloc]initWithFrame:CGRectMake(100*Kscalew, 8, 10, 10)];
//      self.cirleLable.backgroundColor = [UIColor orangeColor];
        [self.cirleLable.layer setBorderWidth:1.0];
        self.cirleLable.layer.borderColor=[UIColor redColor].CGColor;
        self.cirleLable.layer.masksToBounds = YES;
        self.cirleLable.layer.cornerRadius = 5;
    }
    return _cirleLable;
}

- (UIImageView *)XcirleLable {
    if (_XcirleLable == nil) {
        self.XcirleLable = [[UIImageView alloc]initWithFrame:CGRectMake(2*Kscalew, 2, 6, 6)];
        self.XcirleLable.backgroundColor = [UIColor redColor];
        self.XcirleLable.layer.masksToBounds = YES;
        self.XcirleLable.layer.cornerRadius = 3;
    }
    return _XcirleLable;
}


- (UILabel *)lineLable {
    if (_lineLable == nil) {
        self.lineLable = [[UILabel alloc]initWithFrame:CGRectMake(104.8*Kscalew, 0, .4*Kscalew, 0)];
        _lineLable.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLable;
}


- (UILabel *)yearLable {
    if (_yearLable == nil) {
        self.yearLable = [[UILabel alloc]initWithFrame:CGRectMake(25*Kscalew, 5, 70*Kscalew, 20)];
        _yearLable.textAlignment = NSTextAlignmentRight;
    }
    return _yearLable;
}
- (UILabel *)monthLable {
    if (_monthLable == nil) {
        self.monthLable = [[UILabel alloc]initWithFrame:CGRectMake(25*Kscalew, 30, 70*Kscalew, 20)];
        _monthLable.textAlignment = NSTextAlignmentRight;
    }
    return _monthLable;
}

- (UILabel *)contentLable {
    if (_contentLable == nil) {
        self.contentLable = [[UILabel alloc]initWithFrame:CGRectMake(115*Kscalew, 5, 290*Kscalew, 0)];
        //_contentLable.backgroundColor = [UIColor redColor];
        _contentLable.textAlignment = NSTextAlignmentLeft;
        _contentLable.numberOfLines = 0;
    }
    return _contentLable;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.lineLable];
        [self.contentView addSubview:self.cirleLable];
        [self.cirleLable addSubview:self.XcirleLable];
        [self.contentView addSubview:self.yearLable];
        [self.contentView addSubview:self.monthLable];
        [self.contentView addSubview:self.contentLable];
    }
    return self;
}










@end
