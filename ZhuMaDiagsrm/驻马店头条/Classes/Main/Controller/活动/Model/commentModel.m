//
//  commentModel.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/13.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "commentModel.h"

@implementation commentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    
    if([key isEqualToString:@"id"]) {
       
          self.comid = value;
           return;
    }
}

    
    


@end
