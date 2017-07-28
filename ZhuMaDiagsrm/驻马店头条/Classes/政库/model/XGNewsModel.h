//
//  XGNewsModel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XGNewsModel : NSObject

@property(nonatomic, strong)NSString *ar_cateid;
@property(nonatomic, strong)NSString *ar_id;
@property(nonatomic, strong)NSString *ar_pic;

@property(nonatomic, strong)NSString *ar_time;
@property(nonatomic, strong)NSString *ar_title;
@property(nonatomic, strong)NSString *ar_type;

@property(nonatomic, strong)NSString *ar_userid;
@property(nonatomic, strong)NSString *ar_volume;
@property(nonatomic, strong)NSString *ar_wl;
@property(nonatomic, strong)NSString *ar_userpic;
@property(nonatomic, strong)NSString *cname;
@end
