//
//  FBDTDetailsModel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBDTDetailsModel : NSObject

@property(nonatomic, strong)NSString *ar_id;
@property(nonatomic, strong)NSString *ar_title;

@property(nonatomic, strong)NSString *ar_pic;
@property(nonatomic, strong)NSString *ar_wl;
@property(nonatomic, strong)NSString *ar_time;
@property(nonatomic, strong)NSString *ar_volume;
@property(nonatomic, strong)NSString *dwname;
@property(nonatomic, strong)NSString *dwid;
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong)NSString *ar_userid;
@property(nonatomic, strong)NSString *shareurl;

- (id)initWithDiction:(NSDictionary *)dic;

@property(nonatomic, strong)NSString *ar_type;



@end
