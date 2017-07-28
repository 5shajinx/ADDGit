//
//  MineWindowCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/2/17.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineWindowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UIImageView *minimg;

@property (weak, nonatomic) IBOutlet UIImageView *tapImage;
@property (assign,nonatomic) BOOL vol;




@end
