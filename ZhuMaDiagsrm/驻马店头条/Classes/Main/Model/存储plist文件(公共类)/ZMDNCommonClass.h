//
//  ZMDNCommonClass.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/23.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//





@protocol deleteCellDelegate <NSObject>

-(void)deleteTheCell:(UITableViewCell*)cell inTableView:(UITableView*)tableView;

@end


#import <Foundation/Foundation.h>

@interface ZMDNCommonClass : NSObject


//存plist数据
+(void)savePlistDataWithArr:(NSArray*)arr andPlistName:(NSString *)plistName;


//取plist数据
+(id)getPlistDataWithPlistName:(NSString *)plistName;



+(NSString *)pilstPathWithName:(NSString*)plistName;




@end
