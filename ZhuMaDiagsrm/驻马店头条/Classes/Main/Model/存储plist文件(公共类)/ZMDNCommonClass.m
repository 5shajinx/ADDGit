//
//  ZMDNCommonClass.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/23.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNCommonClass.h"

@implementation ZMDNCommonClass



+(NSString *)pilstPathWithName:(NSString*)plistName
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:plistName];
    return filename;
    
}

+(void)savePlistDataWithArr:(NSArray*)arr andPlistName:(NSString *)plistName
{
    NSString *filePath = [[self class] pilstPathWithName:plistName];
    [arr writeToFile:filePath atomically:YES];
   
}





+(id)getPlistDataWithPlistName:(NSString *)plistName
{
    
     NSString *filePath = [self pilstPathWithName:plistName];

     id arr = [[NSArray alloc] initWithContentsOfFile:filePath];
    
     return arr;
}




@end
