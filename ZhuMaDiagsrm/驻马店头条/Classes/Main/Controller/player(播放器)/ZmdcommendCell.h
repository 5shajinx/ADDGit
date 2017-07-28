//
//  ZmdcommendCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/12.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZmdcommendCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userimg;

@property (weak, nonatomic) IBOutlet UILabel *userlab;

@property (weak, nonatomic) IBOutlet UILabel *zannum;

@property (weak, nonatomic) IBOutlet UIButton *zanbtn;

@property (weak, nonatomic) IBOutlet UILabel *contentlab;

@property (weak, nonatomic) IBOutlet UILabel *timeAndCommendnumlab;

@property (weak, nonatomic) IBOutlet UIButton *deletebtn;



@end
