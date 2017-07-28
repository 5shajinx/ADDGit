//
//  ZMDNRecommend.h
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDNRecommend : NSObject



//新闻id
@property (nonatomic, assign) int id;

//无用id
@property (nonatomic, assign) int ar_id;

//新闻标题
@property(nonatomic,copy) NSString * ar_title;

//新闻图片
@property(nonatomic,copy) NSString * ar_pic ;

//新闻图片1
@property(nonatomic,copy) NSString * ar_pic1 ;

//新闻图片2
@property(nonatomic,copy) NSString * ar_pic2 ;

//发布时间
@property(nonatomic,copy) NSString * ar_time ;

//新闻来源
@property(nonatomic,copy) NSString * ar_ly;

//评论量
@property (nonatomic, assign) int ar_volume;


//新闻类型
@property (nonatomic, assign) int ar_type;


@property(nonatomic, assign)BOOL isCollect;

@property(nonatomic,strong) NSString * ar_cateid;
@property(nonatomic,strong) NSString * ar_number;
@property(nonatomic,strong) NSString * ar_userpic;
@property(nonatomic,strong) NSString * ar_length;
-(NSArray*)modelNeedSavekeys;

@property(nonatomic,strong) NSString * ar_wl;
@property(nonatomic,strong) NSString * cname;

@property(nonatomic,strong)NSString *keep_id;
@property(nonatomic,strong) NSString * state;

@end
