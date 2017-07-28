//
//  MineWindowCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/2/17.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "MineWindowCell.h"
@implementation MineWindowCell

- (void)awakeFromNib {
    [super awakeFromNib];

 
    
    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellImageanimations)];
    [self.tapImage addGestureRecognizer:ges];
    _vol = YES;

   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)viewWillDisappear:(BOOL)animated{
}
@end
