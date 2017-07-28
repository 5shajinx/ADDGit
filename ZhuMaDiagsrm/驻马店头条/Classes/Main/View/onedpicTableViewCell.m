//
//  onedpicTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/5/8.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "onedpicTableViewCell.h"

@implementation onedpicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    self.title.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.title.text = _recommendModel.ar_title;
    
    self.title.numberOfLines = 0;
    
   // self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    
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
    
    self.from.text = _recommendModel.ar_ly;
    self.postTime.text = [Manager othertimeWithTimeIntervalString:_recommendModel.ar_time];
    
}

@end
