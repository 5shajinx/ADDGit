//
//  onedpicTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/5/8.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMDNRecommend.h"
@interface onedpicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *titlePic;


@property (weak, nonatomic) IBOutlet UILabel *from;

@property (weak, nonatomic) IBOutlet UILabel *postTime;
@property (weak, nonatomic) IBOutlet UIImageView *userpic;



 
 @property(nonatomic,strong)  ZMDNRecommend* recommendModel ;
 

@end
