//
//  LiveNoCell.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LiveContentModel.h"
@protocol PassValueDelegate <NSObject>

- (void)PassValueDelegatestring;

@end
@interface LiveNoCell : UITableViewCell
@property (nonatomic, assign)id<PassValueDelegate>delegated;
@property (weak, nonatomic) IBOutlet UIImageView *userimageview;
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UILabel *usernamelable;
@property (weak, nonatomic) IBOutlet UILabel *linelable;
@property (weak, nonatomic) IBOutlet UILabel *contentlable;

@property (weak, nonatomic) IBOutlet UIImageView *nomovieimage;

@property (weak, nonatomic) IBOutlet UIImageView *playbtn;

@property(nonatomic , strong)LiveContentModel *recommendModel;
+ (CGFloat)heightForCell:(LiveContentModel *)model;

@property (weak, nonatomic) IBOutlet UILabel *botumlable;

//@property(nonatomic , strong)UILabel *botumlable;

@end
