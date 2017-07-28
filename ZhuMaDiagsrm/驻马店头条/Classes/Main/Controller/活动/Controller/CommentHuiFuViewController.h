//
//  CommentHuiFuViewController.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/19.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"

@interface CommentHuiFuViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *dianzanButton;
@property (weak, nonatomic) IBOutlet UIButton *sharebutton;
@property (nonatomic, strong)commentModel *nodddel;
@property(nonatomic, strong)NSString *aidStr;//活动id
@property(nonatomic, strong)NSString *titlee;//活动名称
@property(nonatomic, strong)NSString *anameString;//活动名称传值

@end
