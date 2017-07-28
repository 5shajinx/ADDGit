//
//  ZMDNNoPicTableViewCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/9/2.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNNoPicTableViewCell.h"
#import "ZMDNRecommend.h"

@implementation ZMDNNoPicTableViewCell

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
    
    CGRect contentframe = CGRectMake(10, 10, ScreenW-20, 0);
    contentframe.size.height = [[self class]heightWithContentText:recommendModel.ar_title];
    self.titleLable.frame = contentframe;
     self.titleLable.text = recommendModel.ar_title;
    self.titleLable.numberOfLines = 0;
//    self.titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
    self.titleLable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
//    CGSize maximumLabelSize = CGSizeMake(ScreenW-20, 100*Kscalew);//labelsize的最大值
//    //关键语句
//    CGSize expectSize = [self.titleLable sizeThatFits:maximumLabelSize];
//    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//    self.titleLable.frame = CGRectMake(10, 10, ScreenW-20, expectSize.height);
   // [Manager sharedManager].mainHeight = expectSize.height+10;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.userPic sd_setImageWithURL:[NSURL URLWithString:recommendModel.ar_userpic]];
    self.userPic.layer.masksToBounds = YES;
    self.userPic.layer.cornerRadius = 10;
    self.userPic.backgroundColor = [UIColor whiteColor];
    //self.pinglunIMG.image = [UIImage imageNamed:@"pinglun"];
    self.from.text = recommendModel.ar_ly;
    self.time.text = [Manager othertimeWithTimeIntervalString:recommendModel.ar_time];
    //self.common.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    self.userPic.contentMode = UIViewContentModeScaleToFill;
    self.common.hidden = YES;
}

//根据content里的内容字符串的多少，来动态计算文本的高度，从而达到 自适应的目的；
+ (CGFloat )heightWithContentText:(NSString *)text {
    CGFloat height = [text boundingRectWithSize:CGSizeMake(ScreenW - 20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
    return height;//字符串动态计算之后所占的高度
}
//为cell自定义高度的方法，给外界调用方法的接口；并将cell的高度返回给外界（视图控制器）使用；
+ (CGFloat )heightForCell:(ZMDNRecommend *)model {
    //1.得到内容lable字符串自适应得到的高度
    CGFloat height = [self heightWithContentText:model.ar_title];
    return height + 65*Kscaleh;
}
//NSStringDrawingUsesLineFragmentOrigin = 1 << 0, // The specified origin is the line fragment origin, not the base line origin
//NSStringDrawingUsesFontLeading = 1 << 1, // Uses the font leading for calculating line heights
//NSStringDrawingUsesDeviceMetrics = 1 << 3, // Uses image glyph bounds instead of typographic bounds
//NSStringDrawingTruncatesLastVisibleLine


@end
