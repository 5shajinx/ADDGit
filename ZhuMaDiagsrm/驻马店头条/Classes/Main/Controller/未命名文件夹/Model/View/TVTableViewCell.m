//
//  TVTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/27.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "TVTableViewCell.h"
#import "SDImageCache.h"
@implementation TVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)mycellShowDateWithModel:(TVModel* )model{
    
    
    self.picHeight.constant = (ScreenH - 115)/3 - 18 -3 - 12 - 2;
    
    
    NSString *sss = [NSString stringWithFormat:@"%@",model.img];
    [self.myimage sd_setImageWithURL:[NSURL URLWithString:sss] placeholderImage:[UIImage imageNamed:@""]];
    self.titLabel.text = [NSString stringWithFormat:@"%@",model.name];
    // 图居中裁剪
    self.myimage.contentMode =  UIViewContentModeScaleAspectFill;
    self.myimage.clipsToBounds = YES;
    
}
@end
