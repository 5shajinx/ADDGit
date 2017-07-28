//
//  commentModel.h
//  驻马店头条
//
//  Created by 孙满 on 17/4/13.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentModel : NSObject
@property(nonatomic, strong)NSString *comid; ///评论id
@property(nonatomic, strong)NSString *nickname;//用户名称
@property(nonatomic, strong)NSString *photo;//用户头像
@property(nonatomic, strong)NSString *zcnum;//支持数
@property(nonatomic, strong)NSString *userid;//用户id

@property(nonatomic, strong)NSString *saytext;//评论内容
@property(nonatomic, strong)NSString *saytime;//评论时间
@property(nonatomic, strong)NSString *count;//回复数



@end
