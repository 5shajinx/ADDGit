//
//  LiveContentModel.h
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveContentModel : NSObject

@property(nonatomic , strong)NSString *zbxq_id;
@property(nonatomic , strong)NSString *depict;
@property(nonatomic , strong)NSString *hrefer;//外链
@property(nonatomic , strong)NSString *photo1;
@property(nonatomic , strong)NSString *photo2;
@property(nonatomic , strong)NSString *photo3;
@property(nonatomic , strong)NSString *photo4;
@property(nonatomic , strong)NSString *time;
@property(nonatomic , strong)NSString *hostid;
@property(nonatomic , strong)NSString *hostname;
@property(nonatomic , strong)NSString *photo;

@property(nonatomic , strong)NSString *videoimg;// 视频缩略图
@property(nonatomic , strong)NSString *videourl;//视频地址

@end
