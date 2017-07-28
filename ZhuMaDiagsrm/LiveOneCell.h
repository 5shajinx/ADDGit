//
//  LiveOneCell.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveContentModel.h"

@protocol PassValueDelegate <NSObject>

- (void)PassValueDelegatestring ;

@end
@interface LiveOneCell : UITableViewCell
@property (nonatomic, assign)id<PassValueDelegate>delegated;
@property (weak, nonatomic) IBOutlet UIImageView *oneuserimage;
@property (weak, nonatomic) IBOutlet UILabel *onenamelable;
@property (weak, nonatomic) IBOutlet UILabel *onetimelable;
@property (weak, nonatomic) IBOutlet UILabel *onelinelable;
@property (weak, nonatomic) IBOutlet UILabel *onecontentlable;

@property (weak, nonatomic) IBOutlet UIImageView *onecontentimage1;


@property (weak, nonatomic) IBOutlet UIImageView *onemovieimage;

@property (weak, nonatomic) IBOutlet UIImageView *playbtn;

@property(nonatomic , strong)LiveContentModel *recommendModel;
+ (CGFloat)heightForCell:(LiveContentModel *)model;

//@property(nonatomic , strong)UILabel *botumlable;


@property (weak, nonatomic) IBOutlet UILabel *botumlable;




@end
