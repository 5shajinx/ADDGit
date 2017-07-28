//
//  ZMDNNewCommendTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 2017/7/13.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMDNNewCommendTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)UILabel * commitDetailLabel;
@property(nonatomic,strong)UILabel * timrLabel;
@property(nonatomic,strong)UIButton *zanButton;
@property(nonatomic,strong)UILabel * zanNumberLabel;

@property(nonatomic,strong)UIButton * huifuButton;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIImageView *userImage;
@property(nonatomic,strong)UIButton * deleteButton;

@end
