//
//  ZMDNNewMovieTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDNNewMovieTableViewCell.h"

@implementation ZMDNNewMovieTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self settButtonImage];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self settButtonImage];
    // Configure the view for the selected state
}
-(void)settButtonImage{
    [self.shareButton setImage:[UIImage imageNamed:@"newShare.png"] forState:UIControlStateNormal];
    
   // [self.shouCangButton setImage:[UIImage imageNamed:@"selecterSC.png"] forState:UIControlStateSelected];
    [self.shouCangButton setImage:[UIImage imageNamed:@"newSC"] forState:UIControlStateNormal];
    [self.downloadButton setImage:[UIImage imageNamed:@"Newdownload.png"] forState:UIControlStateNormal];
   // [self.commitButton setImage:[UIImage imageNamed:@"dowJT.png"] forState:UIControlStateNormal];
   // [self.commitButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    
    //先隐藏下载功能
    self.downloadButton.hidden = YES;
    
}


@end
