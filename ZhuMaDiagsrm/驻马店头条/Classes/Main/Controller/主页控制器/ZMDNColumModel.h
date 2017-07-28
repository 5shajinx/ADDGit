//
//  ZMDNColumModel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/20.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDNColumModel : NSObject





//栏目id
@property (nonatomic, assign)  NSInteger cate_id;


//栏目名字
@property(nonatomic,strong) NSString * cate_name ;

//标识定位用
@property(nonatomic,assign) NSInteger sort ;


//咨询(天下)
@property(nonatomic,strong) NSString * url ;




@end
