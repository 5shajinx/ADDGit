//
//  TouTiaoZhiBoModel.h
//  驻马店头条
//
//  Created by 孙满 on 17/2/6.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouTiaoZhiBoModel : NSObject
//1
@property(nonatomic, strong)NSString *code;
@property(nonatomic, strong)NSString *Message;
@property(nonatomic, strong)NSString *data;

//2
@property(nonatomic, strong)NSString *offset;
@property(nonatomic, strong)NSString *maxpage;
@property(nonatomic, strong)NSString *total;
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong)NSString *rows;

//3
@property(nonatomic, strong)NSString *zb_id;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *time;
@property(nonatomic, strong)NSString *topimage;
@property(nonatomic, strong)NSString *endtime;
@property(nonatomic, strong)NSString *starttime;
//直播分享图标
@property(nonatomic, strong)NSString *photo;
@property(nonatomic, assign)NSInteger type;

@end
