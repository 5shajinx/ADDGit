//
//  ZMDNNewMovieTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 2017/7/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDNNewMovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commitLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *shouCangButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

@end
