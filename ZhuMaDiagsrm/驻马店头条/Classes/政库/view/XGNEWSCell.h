//
//  XGNEWSCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XGNEWSCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageviewNews;
@property (weak, nonatomic) IBOutlet UILabel *titleNews;
@property (weak, nonatomic) IBOutlet UIImageView *userpicNews;
@property (weak, nonatomic) IBOutlet UILabel *timeNews;
@property (weak, nonatomic) IBOutlet UILabel *commonNews;
@property (weak, nonatomic) IBOutlet UILabel *sourceNews;

@end
