//
//  AddAnswerViewController.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/11.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAnswerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *wenzitextview;

@property (weak, nonatomic) IBOutlet UITextField *zhuchirentextfiel;

@property (weak, nonatomic) IBOutlet UIButton *luyinBtn;

@property (weak, nonatomic) IBOutlet UITextField *wailiantextfield;

@property (weak, nonatomic) IBOutlet UIImageView *imageone;

@property (weak, nonatomic) IBOutlet UIImageView *imagetwo;

@property (weak, nonatomic) IBOutlet UIImageView *imagethree;

@property (weak, nonatomic) IBOutlet UIImageView *imageforth;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;


@property(nonatomic, strong)NSString *wenzi;
@property(nonatomic, strong)NSString *zhuchiren;
@property(nonatomic, strong)NSString *wailian;
@property(nonatomic, strong)NSString *pic1;
@property(nonatomic, strong)NSString *pic2;
@property(nonatomic, strong)NSString *pic3;
@property(nonatomic, strong)NSString *pic4;

@property(nonatomic, strong)NSString *jizheid;
@property(nonatomic, strong)NSString *zbcontentid;







@end
