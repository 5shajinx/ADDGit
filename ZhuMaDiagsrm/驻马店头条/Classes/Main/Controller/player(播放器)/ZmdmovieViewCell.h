//
//  ZmdmovieViewCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZmdmovieViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *timelength;


@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *source;


@property (weak, nonatomic) IBOutlet UILabel *clicknumber;

@property (weak, nonatomic) IBOutlet UIImageView *userimage;

@end
