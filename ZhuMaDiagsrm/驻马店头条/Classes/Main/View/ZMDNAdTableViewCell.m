//
//  ZMDNAdTableViewCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNAdTableViewCell.h"
#import "ZMDNRecommend.h"

@implementation ZMDNAdTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    
    [self.adPic sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
    
    self.adPic.contentMode = UIViewContentModeScaleAspectFill;
    

    
    self.adPic.clipsToBounds = YES;
    
    [self layoutIfNeeded];
    
    self.cellHeight =  CGRectGetMaxY(self.adPic.frame);
    
}
























@end
