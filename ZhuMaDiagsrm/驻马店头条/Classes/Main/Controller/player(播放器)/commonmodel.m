//
//  commonmodel.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/8.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "commonmodel.h"
#import "NSDate+XMGExtension.h"
@implementation commonmodel
- (NSString *)saytime
{
    NSDate *create = [NSDate dateWithTimeIntervalSince1970:_saytime.doubleValue];
    
    //NSLog(@"%@",confromTimesp);
    // 日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 设置日期格式(y:年,M:月,d:日,H:时,m:分,s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 帖子的创建时间
    //    NSDate *create = [fmt dateFromString:_ar_time];
    //
    if (create.isThisYear) { // 今年
        if (create.isToday) { // 今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if (cmps.hour >= 1) { // 时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 1分钟 > 时间差距
                return @"刚刚";
            }
        } else if (create.isYesterday) { // 昨天
            fmt.dateFormat = @"昨天HH:mm";
            return [fmt stringFromDate:create];
        } else { // 其他
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:create];
        }
    } else { // 非今年
        return _saytime;
    }
}

@end
