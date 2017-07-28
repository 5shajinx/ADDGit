//
//  WordFilter.h
//  43234
//
//  Created by 孙满 on 16/12/29.
//  Copyright © 2016年 吕书涛. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordFilter : NSObject
+ (instancetype)sharedInstance;
- (void)initFilter:(NSMutableArray *)filepath;
- (NSString *)filter:(NSString *)str;
@end
