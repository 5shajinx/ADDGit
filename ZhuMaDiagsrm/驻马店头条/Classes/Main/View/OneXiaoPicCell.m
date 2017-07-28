//
//  OneXiaoPicCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/15.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "OneXiaoPicCell.h"
#import "PrefixHeader.pch"
@implementation OneXiaoPicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (UIImageView *)titlePic {
    if (_titlePic == nil) {
        self.titlePic = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW - 10 -(ScreenW-30)/3, 15, (ScreenW-30)/3, 80)];
        _titlePic.backgroundColor = [UIColor lightGrayColor];
        
    }
    return _titlePic;
}

- (UILabel *)title {
    if (_title == nil) {
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, ScreenW- 25 -(ScreenW-30)/3, 60)];
        //_title.backgroundColor = [UIColor redColor];
    }
    return _title;
}


- (UIImageView *)userpic {
    if (_userpic == nil) {
        self.userpic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 75, 20, 20)];
        _userpic.backgroundColor = [UIColor whiteColor];
       
        
    }
    return _userpic;
}


- (UILabel *)from {
    if (_from == nil) {
        self.from = [[UILabel alloc]initWithFrame:CGRectMake(40, 75, 100, 20)];
        self.from.font = [UIFont systemFontOfSize:12];
        _from.textColor = [UIColor lightGrayColor];
    }
    return _from;
}
- (UILabel *)postTime {
    if (_postTime == nil) {
        self.postTime = [[UILabel alloc]initWithFrame:CGRectMake(140, 75, 80, 20)];
        self.postTime.font = [UIFont systemFontOfSize:12];
        
        _postTime.textColor = [UIColor lightGrayColor];
    }
    return _postTime;
}
- (UIImageView *)pinglunIMG {
    if (_pinglunIMG == nil) {
        self.pinglunIMG = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW- 55 -(ScreenW-30)/3, 80, 10, 10)];
       // _pinglunIMG.backgroundColor = [UIColor redColor];
    }
    return _pinglunIMG;
}

- (UILabel *)common {
    if (_common == nil) {
        self.common = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW- 40 -(ScreenW-30)/3, 75, 30, 20)];
        self.common.font = [UIFont systemFontOfSize:12];
        _common.textColor = [UIColor lightGrayColor];
    }
    return _common;
}




//- (UIButton *)hitBtn {
//    if (_hitBtn == nil) {
//        self.hitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //self.hitBtn.backgroundColor = [UIColor grayColor];
//        [self.hitBtn addTarget:self action:@selector(hitbt:) forControlEvents:UIControlEventTouchUpInside];
//        [self.hitBtn setBackgroundImage:[UIImage imageNamed:@"recommend_cancel"] forState:UIControlStateNormal];
//        _hitBtn.frame = CGRectMake(ScreenW-30, 70, 20, 20);
//    }
//    return _hitBtn;
//}
//- (void)hitbt:(UIButton *)sender {
//    if (self.deleteCellBlock)
//    {
//        self.deleteCellBlock(self);
//    }
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self.contentView addSubview:self.titlePic];
         [self.contentView addSubview:self.title];
         [self.contentView addSubview:self.userpic];
         [self.contentView addSubview:self.from];
         //[self.contentView addSubview:self.common];
         [self.contentView addSubview:self.postTime];
        //[self.contentView addSubview:self.pinglunIMG];
//         [self.contentView addSubview:self.hitBtn];
    }
    return self;
}


-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    self.title.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.title.text = _recommendModel.ar_title;
    
    self.title.numberOfLines = 0;
    
    self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    
//    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_recommendModel.ar_pic]];
//    UIImage *image = [[UIImage alloc]initWithData:data];
//    UIImage *img = [[Manager sharedManager] getPartOfImage:image rect:CGRectMake(0, 0, (ScreenW-30)/3, 80)];
    
    if ([_recommendModel.ar_pic isEqualToString:@""] || _recommendModel.ar_pic == nil || [_recommendModel.ar_pic isEqual:[NSNull null]]) {
        
        self.titlePic.image = [UIImage imageNamed:@"hui"];
    }else {
         [self.titlePic sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic]placeholderImage:[UIImage imageNamed:@"hui"]];
        
    }
    
   
    
    self.titlePic.contentMode = UIViewContentModeScaleAspectFill;
     self.titlePic.clipsToBounds = YES;
    
    [self.userpic sd_setImageWithURL:[NSURL URLWithString:_recommendModel.ar_userpic]];
    
    self.userpic.layer.masksToBounds = YES;
    self.userpic.layer.cornerRadius = 10;
    self.userpic.contentMode = UIViewContentModeScaleToFill;
    self.pinglunIMG.image = [UIImage imageNamed:@"pinglun"];
    
    self.from.text = _recommendModel.ar_ly;
    self.postTime.text = [Manager othertimeWithTimeIntervalString:_recommendModel.ar_time];
    
}
-(void)setRecoModel:(ZMDNReco *)recoModel
{
    _recoModel = recoModel;
    self.title.text = _recoModel.title;
    [self.titlePic sd_setImageWithURL:[NSURL URLWithString:_recoModel.titlepic] placeholderImage:nil];
    self.from.text = @"驻马店新闻";
    self.postTime.text = _recoModel.newstime;
    self.common.text = @"评论量200";
    
}








@end
