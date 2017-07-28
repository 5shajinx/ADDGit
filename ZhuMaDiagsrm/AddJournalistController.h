//
//  AddJournalistController.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/10.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddJournalistController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;

@property (weak, nonatomic) IBOutlet UITextView *miaotextfield;

@property (weak, nonatomic) IBOutlet UITextField *shenfentextfield;


@property (weak, nonatomic) IBOutlet UIImageView *imageview;


@property (weak, nonatomic) IBOutlet UIButton *fabuBtn;




@property(nonatomic, strong)NSString *edit;

@property(nonatomic, strong)NSString *xingming;
@property(nonatomic, strong)NSString *miaoshu;
@property(nonatomic, strong)NSString *shenfen;
@property(nonatomic, strong)NSString *fengmian;

@property(nonatomic, strong)NSString *jizheid;
@property(nonatomic, strong)NSString *leixingid;
@end
