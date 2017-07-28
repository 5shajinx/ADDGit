//
//  ZMDDSNewTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 2017/7/11.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVModel.h"

@interface ZMDDSNewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISlider *mySilder;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *leftnameLabel;
@property (weak, nonatomic) IBOutlet UISlider *onlabel;
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;

-(void)showdetilewithModel:(TVModel *)model;

@end
