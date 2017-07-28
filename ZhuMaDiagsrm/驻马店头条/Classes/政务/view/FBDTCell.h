//
//  FBDTCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface FBDTCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titlelable;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *contentlable;
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UILabel *commonlable;



@end
