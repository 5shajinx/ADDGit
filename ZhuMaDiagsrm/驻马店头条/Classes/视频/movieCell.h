//
//  movieCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/16.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface movieCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *titlelable;

@property (weak, nonatomic) IBOutlet UILabel *sourcelable;

@property (weak, nonatomic) IBOutlet UILabel *commonlable;

@property (weak, nonatomic) IBOutlet UILabel *timelable;

@property (weak, nonatomic) IBOutlet UIButton *playbtn;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;

@property (weak, nonatomic) IBOutlet UIImageView *userimageview;

@property (weak, nonatomic) IBOutlet UILabel *timeLength;



@end
