//
//  LiveTwoCell.h
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


@interface LiveTwoCell : UITableViewCell
@property (nonatomic, assign)id<PassValueDelegate>delegated;
@property (weak, nonatomic) IBOutlet UIImageView *twouserimage;
@property (weak, nonatomic) IBOutlet UILabel *twonamelable;
@property (weak, nonatomic) IBOutlet UILabel *twotimelable;

@property (weak, nonatomic) IBOutlet UILabel *twolinelable;

@property (weak, nonatomic) IBOutlet UILabel *twocontentlable;


@property (weak, nonatomic) IBOutlet UIImageView *twoimage1;

@property (weak, nonatomic) IBOutlet UIImageView *twoimage2;

@property (weak, nonatomic) IBOutlet UIImageView *playbtn;

@property (weak, nonatomic) IBOutlet UIImageView *twomovieimage;

@property(nonatomic , strong)LiveContentModel *recommendModel;
+ (CGFloat)heightForCell:(LiveContentModel *)model;
//@property(nonatomic , strong)UILabel *botumlable;

//@property (strong, nonatomic)UILabel *botumlable;

@property (weak, nonatomic) IBOutlet UILabel *botumlable;

@end
