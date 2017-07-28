//
//  TVTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/27.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVModel.h"
@interface TVTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myimage;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picHeight;

- (void)mycellShowDateWithModel:(TVModel *)model;

@end
