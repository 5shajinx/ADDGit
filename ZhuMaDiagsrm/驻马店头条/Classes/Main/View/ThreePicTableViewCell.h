//
//  ThreePicTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/5/5.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMDNRecommend.h"
@interface ThreePicTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *newstitle;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imagethree;

@property (weak, nonatomic) IBOutlet UIImageView *hot;
@property (weak, nonatomic) IBOutlet UILabel *fromWhere;
@property (weak, nonatomic) IBOutlet UILabel *newstime;


@property(nonatomic,copy) void (^deleteCellBlock) (UITableViewCell *cell) ;

@property (nonatomic, assign) CGFloat cellHeight;

@property(nonatomic,strong)  ZMDNRecommend * recommendModel ;
@property (strong, nonatomic)  UIImageView *pinglunIMG;

/*
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
 */
@end
