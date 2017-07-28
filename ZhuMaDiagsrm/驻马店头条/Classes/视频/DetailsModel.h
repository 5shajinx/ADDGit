//
//  DetailsModel.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsModel : NSObject


@property(nonatomic, strong)NSString *ar_title;//标题
@property(nonatomic, strong)NSString *ar_movieurl;//视频连接
@property(nonatomic, strong)NSString *ar_pic;//图片
@property(nonatomic, strong)NSString *ar_time;//发布时间
@property(nonatomic, strong)NSString *ar_ly;//来源
@property(nonatomic, strong)NSString *ar_volume;//评论量
@property(nonatomic, strong)NSString *ar_cateid;
@property(nonatomic, strong)NSString *ar_id;
@property(nonatomic, strong)NSString *ar_onclick;
@property(nonatomic, strong)NSString *ar_type;
@property(nonatomic, strong)NSString *shareurl;//
@property(nonatomic, strong)NSString *ar_userpic;//
@property(nonatomic, strong)NSString *ar_wl;
@property(nonatomic, assign)BOOL collect;
@property(nonatomic, strong)NSString *ar_length;


@end
