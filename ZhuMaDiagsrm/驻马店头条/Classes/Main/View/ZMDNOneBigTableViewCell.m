//
//  ZMDNOneBigTableViewCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNOneBigTableViewCell.h"

#import "ZMDNRecommend.h"

@implementation ZMDNOneBigTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    self.newstitle.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.newstitle.text = _recommendModel.ar_title;
   
    CGSize size = [self getTheLableSize: self.newstitle withMaxWidth:ScreenW - 20];
    
    [self.hot sd_setImageWithURL:[NSURL URLWithString:_recommendModel.ar_userpic]];
    self.hot.layer.masksToBounds = YES;
    self.hot.layer.cornerRadius = 10;
    self.hot.backgroundColor = [UIColor whiteColor];
    self.hot.contentMode = UIViewContentModeScaleToFill;
     //self.pinglunIMG.image = [UIImage imageNamed:@"pinglun"];
    
    [self.newstitle sizeThatFits:size];
    
    //self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    
    
    self.common.hidden = YES;
    self.pinglunIMG.hidden = YES;
    
    
    [self.bigPic sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];

    self.bigPic.layer.masksToBounds = YES;
    self.bigPic.layer.cornerRadius = 10;

    self.bigPic.contentMode = UIViewContentModeScaleAspectFill;
    self.bigPic.clipsToBounds = YES;
    
    

    self.pagelable.text = [NSString stringWithFormat:@"%@图",_recommendModel.ar_length];

    
    self.from.text = _recommendModel.ar_ly;
    self.newsTime.text = [Manager othertimeWithTimeIntervalString:_recommendModel.ar_time];
    [self layoutIfNeeded];
    
    self.cellHeight = CGRectGetMaxY(self.common.frame) + 10;
   

    
    
}


-(CGSize)getTheLableSize:(UILabel*)showLable withMaxWidth:(CGFloat)maxWidth
{
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    
    CGSize contentSize = [showLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
    
    showLable.size = contentSize;
    
    return contentSize;
}





@end
