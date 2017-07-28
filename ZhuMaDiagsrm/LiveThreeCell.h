//
//  LiveThreeCell.h
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


@interface LiveThreeCell : UITableViewCell
@property (nonatomic, assign)id<PassValueDelegate>delegated;
@property (weak, nonatomic) IBOutlet UIImageView *threeuserimage;

@property (weak, nonatomic) IBOutlet UILabel *threenamelable;

@property (weak, nonatomic) IBOutlet UILabel *threetimelable;

@property (weak, nonatomic) IBOutlet UILabel *threelinelable;

@property (weak, nonatomic) IBOutlet UILabel *threecontentlable;

@property (weak, nonatomic) IBOutlet UIImageView *threeimage1;
@property (weak, nonatomic) IBOutlet UIImageView *threeimage2;

@property (weak, nonatomic) IBOutlet UIImageView *threeimage3;

@property (weak, nonatomic) IBOutlet UIImageView *threemovieimage;

@property (weak, nonatomic) IBOutlet UIImageView *playbtn;


@property(nonatomic , strong)LiveContentModel *recommendModel;
+ (CGFloat)heightForCell:(LiveContentModel *)model;

//@property(nonatomic , strong)UILabel *botumlable;
@property (weak, nonatomic) IBOutlet UILabel *botumlable;

@end
