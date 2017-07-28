//
//  ZMDNcirculationModel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/28.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDNcirculationModel : NSObject


@property(nonatomic,assign) NSInteger  id ;


@property(nonatomic,copy) NSString * ar_title ;

@property(nonatomic,copy) NSString * ar_pic ;

@property(nonatomic,copy) NSString * ar_wl;
@property (nonatomic, assign)NSInteger ar_type;

@property (nonatomic, assign)NSInteger ar_id;
@property(nonatomic,strong) NSString * ar_userpic ;
@property(nonatomic,strong) NSString * ar_time ;
@property(nonatomic,strong) NSString * cname ;
@property(nonatomic,strong) NSString * state ;
@end
