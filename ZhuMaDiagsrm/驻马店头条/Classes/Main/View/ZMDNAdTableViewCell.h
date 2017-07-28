//
//  ZMDNAdTableViewCell.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZMDNRecommend;

@interface ZMDNAdTableViewCell : UITableViewCell

@property(nonatomic,strong)  ZMDNRecommend * recommendModel ;
@property (weak, nonatomic) IBOutlet UIImageView *adPic;

@property (nonatomic, assign) CGFloat cellHeight;
@property (weak, nonatomic) IBOutlet UILabel *adlable;

@end
