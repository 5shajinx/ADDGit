//
//  ZMDNNoPicTableViewCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/9/2.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMDNRecommend;

@interface ZMDNNoPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *common;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UIImageView *pinglunIMG;
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property(nonatomic , strong)ZMDNRecommend *recommendModel;

+ (CGFloat)heightForCell:(ZMDNRecommend *)model;
@end
