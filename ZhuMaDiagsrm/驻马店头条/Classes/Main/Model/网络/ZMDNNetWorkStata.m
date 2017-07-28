//
//  ZMDNNetWorkStata.m
//  cqzmd
//
//  Created by Mac10.11.4 on 16/5/3.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNNetWorkStata.h"
#import "Reachability.h"


@implementation ZMDNNetWorkStata



//网络是否连接
+(NSString *)isconnectedNetwork
{
   
     NSString* result = nil;
    Reachability *network = [Reachability reachabilityForInternetConnection];
    switch (network.currentReachabilityStatus)
    {
        case NotReachable:// 没有网络连接
           
            result=nil;
            break;
            
        case ReachableViaWWAN:// 使用3G网络
          
             result=@"3g";
            break;
    
        case ReachableViaWiFi:// 使用WiFi网络
           
            result=@"wifi";
            break;
        default:
            break;
    }
    
    return result;
    
}









@end
