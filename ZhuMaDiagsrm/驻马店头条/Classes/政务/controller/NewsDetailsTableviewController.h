//
//  NewsDetailsTableviewController.h
//  驻马店头条
//
//  Created by 孙满 on 16/11/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+XMGExtension.h"
@interface NewsDetailsTableviewController : UIViewController

@property(nonatomic, strong)NSString *idString;//

@property(nonatomic, strong)NSString *str;


@property(nonatomic, strong)NSString *type;//
@property(nonatomic, strong)NSString *state;//

@property(nonatomic, strong)NSString *ar_id;
@property(nonatomic, strong)NSString *ar_cateid;//
@property(nonatomic, strong)NSString *newsPic;

@property(nonatomic, strong)NSString *onclick;
@property(nonatomic, strong)NSString *userpicture;
@property(nonatomic, strong)NSString *titlee;
@property(nonatomic, strong)NSString *author;
@property(nonatomic, strong)NSString *time;
@end
