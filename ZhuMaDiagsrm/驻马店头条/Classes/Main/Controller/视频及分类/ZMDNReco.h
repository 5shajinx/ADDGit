//
//  ZMDNReco.h
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/11.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMDNReco : NSObject

/*   每条视频模型数据  */
//新闻id
@property(nonatomic,copy) NSString* id;

//新闻标题
@property(nonatomic,copy) NSString * title ;

//标题链接
@property(nonatomic,copy) NSString * titleurl ;

//标题配图
@property(nonatomic,copy) NSString * titlepic ;

//发表时间
@property(nonatomic,copy) NSString * newstime ;


//@property(nonatomic,copy) NSString * ar_id ;
//@property(nonatomic,copy) NSString * ar_onclick ;

//-(id)initWithDict:(NSDictionary *)dict;
//
//+(id) newsWithDict:(NSDictionary *)dict;

@end
