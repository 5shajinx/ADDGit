//
//  NewNetWorkManager.m
//  VLv
//
//  Created by lanouhn on 16/6/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

#import "NewNetWorkManager.h"
#import "AFNetworking.h"

@implementation NewNetWorkManager

/*GET 请求 : 方法的作用
 *@param urlStr : 数据请求接口地址
 *@para finish : 数据请求成功的回调
 *@para conError : 数据请求失败的回调
 */
+ (void)requestGETWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id resonbject))finish conError:(void(^)(NSError *error)) conError {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    //增加支持格式
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    
    
     [manager GET:urlStr parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
         //请求数据的进度
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         // 数据请求完成的回调
         finish(responseObject);
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         // 数据请求失败的回调
         conError(error);
         
     }];
    
    
}
/*POST 请求 : 方法的作用
 *@param urlStr : 数据请求接口地址
 *@para finish : 数据请求成功的回调
 *@para conError : 数据请求失败的回调
 */
+ (void)requestPOSTWithURLStr:(NSString *)urlStr parDic:(NSDictionary *)dic finish:(void(^)(id resonbject))finish conError:(void(^)(NSError *error)) conError {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    
    [manager  POST:urlStr parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
         //请求数据的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 数据请求完成的回调
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 数据请求失败的回调
        conError(error);
    }];
    
    
    
    
}



@end
