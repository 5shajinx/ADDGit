//
//  ZMDPlayerViewController.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/2.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsModel.h"



@interface ZMDPlayerViewController : UIViewController

@property(nonatomic, strong)NSString *string;

@property(nonatomic, strong)NSString *timeString;

@property(nonatomic, strong)NSString *fabu;

@property(nonatomic, strong)NSString *movieURL;

@property (weak, nonatomic) IBOutlet UIView *avPlayer;

@property (weak, nonatomic) IBOutlet UITableView *tableview;


@property(nonatomic, strong)NSString *ar_id;

@property(nonatomic, strong)NSString *clicknum;

@property(nonatomic, strong)NSString *ar_pic;

@property(nonatomic, strong)DetailsModel *receiveModel;

@property(nonatomic, strong)NSString *ar_type;
@property(nonatomic, strong)NSString *ar_cateid;


@property(nonatomic,assign)BOOL allowRotation;
//评论量]
@property(nonatomic, strong)NSString *commitNumber;


@end
