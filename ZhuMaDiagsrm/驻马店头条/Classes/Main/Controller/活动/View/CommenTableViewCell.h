//
//  CommenTableViewCell.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"
@interface CommenTableViewCell : UITableViewCell
//传时机的block
@property (nonatomic, copy) void(^touchBlock)(NSString* index);
@property (weak, nonatomic) IBOutlet UIImageView *touchimage;
@property (weak, nonatomic) IBOutlet UIImageView *userPicImage;
@property (weak, nonatomic) IBOutlet UILabel *Usernamelabel;
@property (weak, nonatomic) IBOutlet UILabel *nubOfSay;
@property (weak, nonatomic) IBOutlet UILabel *saytime;
@property (weak, nonatomic) IBOutlet UILabel *detaileLabel;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property(nonatomic, strong)NSString *timeSp;

@property(nonatomic, strong)NSString *nummm;//点赞

@property(nonatomic, strong)NSString *comid; ///评论id

-(void)showDetailWithModel:(commentModel *)model;
-(void)HuifushowDetailWithModel:(commentModel *)model;
@property (weak, nonatomic) IBOutlet UIButton *didseleButtonnn;

@end
