//
//  LiveForthCell.h
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


@interface LiveForthCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *forthuserimage;

@property (weak, nonatomic) IBOutlet UILabel *forthnamelable;
@property (weak, nonatomic) IBOutlet UILabel *forthtimelable;
@property (weak, nonatomic) IBOutlet UILabel *forthlinelable;


@property (weak, nonatomic) IBOutlet UILabel *forthcontentlable;


@property (weak, nonatomic) IBOutlet UIImageView *forthimage1;
@property (weak, nonatomic) IBOutlet UIImageView *forthimage2;
@property (weak, nonatomic) IBOutlet UIImageView *forthimage3;
@property (weak, nonatomic) IBOutlet UIImageView *forthimage4;


@property (weak, nonatomic) IBOutlet UIImageView *movieimageview;

@property (weak, nonatomic) IBOutlet UIImageView *playbtn;

@property(nonatomic , strong)LiveContentModel *recommendModel;
+ (CGFloat)heightForCell:(LiveContentModel *)model;



@property (weak, nonatomic) IBOutlet UILabel *botumlable;


//@property (strong, nonatomic)UILabel *botumlable;


@property (nonatomic, assign)id<PassValueDelegate>delegated;
@end
