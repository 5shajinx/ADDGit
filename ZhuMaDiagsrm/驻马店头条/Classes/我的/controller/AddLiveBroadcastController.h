//
//  AddLiveBroadcastController.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/10.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLiveBroadcastController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fenleiTextfield;
@property (weak, nonatomic) IBOutlet UITextField *zhuchirenTextField;

@property (weak, nonatomic) IBOutlet UITextField *biaotiTextfield;

@property (weak, nonatomic) IBOutlet UITextView *miaoshuTextView;

@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;
@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;


@property (weak, nonatomic) IBOutlet UIView *botummonView;

@property (weak, nonatomic) IBOutlet UITextField *startTIME;
@property (weak, nonatomic) IBOutlet UITextField *endTIME;

@property(nonatomic, strong)NSString *zhiboid;
@property(nonatomic, strong)NSString *zhibotypeid;
@property(nonatomic, strong)NSString *zhuchirenid;





@property(nonatomic, strong)NSString *biaoti;
@property(nonatomic, strong)NSString *miaoshu;
@property(nonatomic, strong)NSString *tupian;
@property(nonatomic, strong)NSString *fenlei;
@property(nonatomic, strong)NSString *zhuchiren;

@property(nonatomic, strong)NSString *kaishi;
@property(nonatomic, strong)NSString *jieshu;

@property(nonatomic, strong)NSString *editzb;

@property(nonatomic, strong)NSString *lai;
@end
