//
//  zmdmodel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zmdmodel : NSObject
@property(nonatomic, strong)NSString *ar_movieurl;
@property(nonatomic, strong)NSString *ar_title;
@property(nonatomic, strong)NSString *ar_ly;
@property(nonatomic, strong)NSString *ar_onclick;
@property(nonatomic, strong)NSString *ar_pic;
@property(nonatomic, strong)NSString *ar_length;
@property(nonatomic, assign)BOOL iscollection;
@property(nonatomic, strong)NSString *ar_userpic;

@property(nonatomic, strong)NSString *ar_id;
@property(nonatomic, strong)NSString *userid;
@property(nonatomic, strong)NSString *ar_type;


@property(nonatomic, strong)NSString *ar_wl;
@property(nonatomic, strong)NSString *ar_volume;



@end
