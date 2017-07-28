//
//  ActTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/10.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActModel.h"

@interface ActTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UILabel *dowUpLabel;
@property (weak, nonatomic) IBOutlet UIView *leftBgImage;
@property (weak, nonatomic) IBOutlet UIView *rightBgimage;

@property(nonatomic, strong)NSString *timeSp;

@property (weak, nonatomic) IBOutlet UIImageView *peoImage;

@property (weak, nonatomic) IBOutlet UILabel *leftlabel;

@property (weak, nonatomic) IBOutlet UIImageView *APPImage;

@property (weak, nonatomic) IBOutlet UILabel *rightlabel;

- (void)showCellWithMode:(ActModel *)model;

@end
