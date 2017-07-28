//
//  XGImageTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/7.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end
