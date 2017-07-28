//
//  OneXiaoPicCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/15.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMDNReco.h"
#import "ZMDNRecommend.h"
@interface OneXiaoPicCell : UITableViewCell

@property (strong, nonatomic)  UIImageView *titlePic;
@property (strong, nonatomic)  UILabel *title;
@property (strong, nonatomic)  UIImageView *userpic;
@property (strong, nonatomic)  UILabel *from;
@property (strong, nonatomic)  UILabel *common;
@property (strong, nonatomic)  UILabel *postTime;
//@property (strong, nonatomic)  UIButton *hitBtn;

@property (strong, nonatomic)  UIImageView *pinglunIMG;
@property (nonatomic, strong) ZMDNReco *recoModel;

@property(nonatomic,strong)  ZMDNRecommend* recommendModel ;


@property(nonatomic,copy) void  (^deleteCellBlock)(UITableViewCell *cell);

@end
