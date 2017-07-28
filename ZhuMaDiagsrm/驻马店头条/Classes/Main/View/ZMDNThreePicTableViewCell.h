//
//  ZMDNThreePicTableViewCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMDNRecommend;

@interface ZMDNThreePicTableViewCell : UITableViewCell
@property (strong, nonatomic)  UILabel *newstitle;
@property (strong, nonatomic)  UIImageView *imageOne;
@property (strong, nonatomic)  UIImageView *imagethree;
@property (strong, nonatomic)  UIImageView *imageTwo;
@property (strong, nonatomic)  UIImageView *hot;

//@property (strong, nonatomic)  UIButton *cancelBtn;
@property (strong, nonatomic)  UILabel *newstime;
@property (strong, nonatomic)  UILabel *common;
@property (strong, nonatomic)  UILabel *fromWhere;

@property(nonatomic,copy) void (^deleteCellBlock) (UITableViewCell *cell) ;

@property (nonatomic, assign) CGFloat cellHeight;

@property(nonatomic,strong)  ZMDNRecommend * recommendModel ;
@property (strong, nonatomic)  UIImageView *pinglunIMG;
@end
