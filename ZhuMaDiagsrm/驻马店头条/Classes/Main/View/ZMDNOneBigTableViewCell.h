//
//  ZMDNOneBigTableViewCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZMDNRecommend;

@interface ZMDNOneBigTableViewCell : UITableViewCell

//新闻标题
@property (weak, nonatomic) IBOutlet UILabel *newstitle;
@property (weak, nonatomic) IBOutlet UILabel *pagelable;

//新闻大图
@property (weak, nonatomic) IBOutlet UIImageView *bigPic;

//热图标
@property (weak, nonatomic) IBOutlet UIImageView *hot;

//来源
@property (weak, nonatomic) IBOutlet UILabel *from;

//评论
@property (weak, nonatomic) IBOutlet UILabel *common;

//时间
@property (weak, nonatomic) IBOutlet UILabel *newsTime;

//取消
//@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIImageView *pinglunIMG;

@property(nonatomic,copy) void  (^deleteCellBlock)(UITableViewCell *cell);


@property (nonatomic, assign) CGFloat cellHeight;

@property(nonatomic,strong) ZMDNRecommend* recommendModel ;

@property(nonatomic, strong) UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIImageView *tutu;


@end
