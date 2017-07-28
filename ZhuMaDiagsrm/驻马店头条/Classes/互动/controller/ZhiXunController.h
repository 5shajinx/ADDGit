//
//  ZhiXunController.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhiXunController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *clickCommit;

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@property (weak, nonatomic) IBOutlet UITextField *bumenTextfield;


@property (weak, nonatomic) IBOutlet UILabel *selectimageLable;


@property (weak, nonatomic) IBOutlet UITextView *detailsTextview;

@property (weak, nonatomic) IBOutlet UITextField *titleTextfield;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *shuomingLable;


@property(nonatomic, strong)NSString *str;
@property(nonatomic, strong)NSString *biaoshi;
@end
