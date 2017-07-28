
//
//  ThreePicTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/5/5.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ThreePicTableViewCell.h"
#import "ZMDNRecommend.h"

@implementation ThreePicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
}
-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    self.newstitle.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.newstitle.text = _recommendModel.ar_title;
    self.newstitle.numberOfLines = 0;
    
//    self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    
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
