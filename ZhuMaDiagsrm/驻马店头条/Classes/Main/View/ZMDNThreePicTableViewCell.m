//
//  ZMDNThreePicTableViewCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNThreePicTableViewCell.h"
#import "ZMDNRecommend.h"


@implementation ZMDNThreePicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UILabel *)newstitle {
    if (_newstitle == nil) {
        self.newstitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenW-20, 30)];
        self.newstitle.font =  [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    }
    return _newstitle;
}

- (UIImageView *)imageOne {
    if (_imageOne == nil) {
        self.imageOne = [[UIImageView alloc]initWithFrame:CGRectMake(10, 50, (ScreenW-30)/3, 80)];
        //_imageOne.backgroundColor = [UIColor redColor];
        
    }
    return _imageOne;
}
- (UIImageView *)imageTwo {
    if (_imageTwo == nil) {
        self.imageTwo = [[UIImageView alloc]initWithFrame:CGRectMake(15+(ScreenW-30)/3, 50, (ScreenW-30)/3, 80)];
        //_imageTwo.backgroundColor = [UIColor redColor];
        
    }
    return _imageTwo;
}
- (UIImageView *)imagethree {
    if (_imagethree == nil) {
        self.imagethree = [[UIImageView alloc]initWithFrame:CGRectMake(20+(ScreenW-30)/3*2, 50, (ScreenW-30)/3, 80)];
        //_imagethree.backgroundColor = [UIColor redColor];
        
    }
    return _imagethree;
}



- (UIImageView *)hot {
    if (_hot == nil) {
        self.hot = [[UIImageView alloc]initWithFrame:CGRectMake(10, 135, 20, 20)];
        _hot.backgroundColor = [UIColor whiteColor];
        _hot.layer.masksToBounds = YES;
        _hot.layer.cornerRadius = 10;
        
    }
    return _hot;
}



- (UIImageView *)pinglunIMG {
    if (_pinglunIMG == nil) {
        self.pinglunIMG = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-55, 140, 10, 10)];
        // _pinglunIMG.backgroundColor = [UIColor redColor];
    }
    return _pinglunIMG;
}


- (UILabel *)fromWhere {
    if (_fromWhere == nil) {
        self.fromWhere = [[UILabel alloc]initWithFrame:CGRectMake(40, 135, 100, 20)];
        self.fromWhere.font = [UIFont systemFontOfSize:12];
        _fromWhere.textColor = [UIColor lightGrayColor];
    }
    return _fromWhere;
}

- (UILabel *)common {
    if (_common == nil) {
        self.common = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-40, 135, 30, 20)];
        self.common.font = [UIFont systemFontOfSize:12];
        _common.textColor = [UIColor lightGrayColor];
    }
    return _common;
}

- (UILabel *)newstime {
    if (_newstime == nil) {
        self.newstime = [[UILabel alloc]initWithFrame:CGRectMake(140, 135,90, 20)];
        self.newstime.font = [UIFont systemFontOfSize:12];
        _newstime.textColor = [UIColor lightGrayColor];
    }
    return _newstime;
}


//- (UIButton *)cancelBtn {
//    if (_cancelBtn == nil) {
//        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //self.hitBtn.backgroundColor = [UIColor grayColor];
//        [self.cancelBtn addTarget:self action:@selector(hitbt:) forControlEvents:UIControlEventTouchUpInside];
//        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"recommend_cancel"] forState:UIControlStateNormal];
//        _cancelBtn.frame = CGRectMake(ScreenW-30, 120, 20, 20);
//    }
//    return _cancelBtn;
//}
//- (void)hitbt:(UIButton *)sender {
//    if (self.deleteCellBlock)
//    {
//        self.deleteCellBlock(self);
//    }
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.newstitle];
        [self.contentView addSubview:self.imageOne];
        [self.contentView addSubview:self.imageTwo];
        [self.contentView addSubview:self.imagethree];
        [self.contentView addSubview:self.hot];
        [self.contentView addSubview:self.newstime];
        //[self.contentView addSubview:self.common];
        [self.contentView addSubview:self.fromWhere];
        //[self.contentView addSubview:self.pinglunIMG];
//        [self.contentView addSubview:self.cancelBtn];
    }
    return self;
}


-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
   self.newstitle.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.newstitle.text = _recommendModel.ar_title;
    self.newstitle.numberOfLines = 0;

    self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    
    [self.imageOne sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
    self.imageOne.contentMode = UIViewContentModeScaleToFill;
    [self.imageTwo sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic1] placeholderImage:[UIImage imageNamed:@"hui"]];
    self.imageTwo.contentMode = UIViewContentModeScaleToFill;
    [self.imagethree sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic2] placeholderImage:[UIImage imageNamed:@"hui"]];
    self.imagethree.contentMode = UIViewContentModeScaleToFill;
      self.pinglunIMG.image = [UIImage imageNamed:@"pinglun"];
    
    [self.hot sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_userpic] placeholderImage:[UIImage imageNamed:@"ground"]];
    self.hot.contentMode = UIViewContentModeScaleToFill;
    self.hot.layer.masksToBounds = YES;
    self.hot.layer.cornerRadius = 10;
    
    self.fromWhere.text = _recommendModel.ar_ly;
    self.newstime.text = [Manager othertimeWithTimeIntervalString:_recommendModel.ar_time];;
    
    self.imageOne.contentMode = UIViewContentModeScaleAspectFill;
    self.imageOne.clipsToBounds = YES;
    
    self.imageTwo.contentMode = UIViewContentModeScaleAspectFill;
    self.imageTwo.clipsToBounds = YES;
    
    self.imagethree.contentMode = UIViewContentModeScaleAspectFill;
    self.imagethree.clipsToBounds = YES;
    //[self layoutIfNeeded];
    
    //self.cellHeight = CGRectGetMaxY(self.common.frame) + 10;
    
}












@end
