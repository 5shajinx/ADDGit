//
//  ZMDNNewfirstMoviewTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDNNewfirstMoviewTableViewCell.h"

@implementation ZMDNNewfirstMoviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self showdetilewithimageAndlabel];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self showdetilewithimageAndlabel];
    // Configure the view for the selected state
}
-(void)showdetilewithimageAndlabel{
    if(!_picImage){
    self.picImage = [[UIImageView alloc]init];
    [self.contentView addSubview:self.picImage];
    [self.picImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10);
        make.width.offset(120);
        make.height.offset(80);
        
    }];
    
    self.titLablel = [[UILabel alloc]init];
    self.titLablel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.titLablel];
    [self.titLablel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.offset(10);
        make.left.mas_equalTo(self.picImage.mas_right).offset(10);
        
        make.height.offset(17);
    }];
    
    }
}
@end
