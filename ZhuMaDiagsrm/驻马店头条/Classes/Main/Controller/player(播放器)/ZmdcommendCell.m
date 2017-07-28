//
//  ZmdcommendCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/12.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZmdcommendCell.h"

@implementation ZmdcommendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
//        self.contentlab.font = [UIFont systemFontOfSize:16];
//        
//        self.contentlab.text = [Manager sharedManager].pingLunString;
//        
//        self.contentlab.numberOfLines = 0;//根据最大行数需求来设置
//        self.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
//        CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
//        //关键语句
//        CGSize expectSize = [self.contentlab sizeThatFits:maximumLabelSize];
//        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//        self.contentlab.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
//        
//        [Manager sharedManager].pingLunHeight = expectSize.height;
//        
//    
//        self.contentlab.textAlignment = NSTextAlignmentLeft;
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
