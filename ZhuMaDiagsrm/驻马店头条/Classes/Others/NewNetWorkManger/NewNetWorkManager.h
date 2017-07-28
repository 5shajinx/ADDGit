//
//  NewNetWorkManager.h
//  VLv
//
//  Created by lanouhn on 16/6/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NewNetWorkManager : NSObject
/*GET 请求 : 方法的作用
 *@param urlStr : 数据请求接口地址
 *@para finish : 数据请求成功的回调
 *@para conError : 数据请求失败的回调
 */
+ (void)requestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id resonbject))finish conError:(void(^)(NSError *error)) conError;
/*POST 请求 : 方法的作用
 *@param urlStr : 数据请求接口地址
 *@para finish : 数据请求成功的回调
 *@para conError : 数据请求失败的回调
 */
+ (void)requestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id resonbject))finish conError:(void(^)(NSError *error)) conError;


@end
