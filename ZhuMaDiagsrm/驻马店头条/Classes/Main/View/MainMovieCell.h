//
//  MainMovieCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/20.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMDNRecommend.h"


@interface MainMovieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titlelable;


@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@property (weak, nonatomic) IBOutlet UIImageView *userimage;

@property (weak, nonatomic) IBOutlet UILabel *timeLength;


@property (weak, nonatomic) IBOutlet UILabel *timelable;

@property (weak, nonatomic) IBOutlet UILabel *sourcelable;

@property (weak, nonatomic) IBOutlet UILabel *commonlable;

@property(nonatomic , strong)ZMDNRecommend *recommendModel;

+ (CGFloat)heightForCell:(ZMDNRecommend *)model;
@property (nonatomic, assign) CGFloat cellHeight;
@end
