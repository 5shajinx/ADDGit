//
//  mydatabase.h
//  myreflash
//
//  Created by Mac10.11.4 on 16/4/25.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ZMDNRecommend;
@class ZMDNColumModel;

@interface mydatabase : NSObject


//数据库单利
+(instancetype)shareMyDataBase;

/**根据类名返回属性数组*/
+ (id)propertyKeysWithString:(NSString *)classStr;


//判断表格是否存在（tableName是表名）
- (BOOL)isExistTable:(NSString *)tableName;



#pragma mark - 创建表格
//创建表格（会自动加上id作为主键,fieldArray是字段）
- (void)wzCreateTableID:(NSString *)tableName;



//创建多布局表
- (BOOL)jyqCreateTableID:(NSString *)tableName ;


//建立栏目的表
-(void)creatcolumnTable;
//插入栏目
-(void)insertColunm:(ZMDNColumModel*)model;


#pragma mark --新的插入

//- (BOOL)jyqInsertRecorderDataWithTableName:(NSString *)tableName withModel:(ZMDNRecommend*)modelName;
//- (BOOL)jyqinsertRecorderDataWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr;


#pragma mark - 旧的插入记录

//以model数组的形式请求插入用户数据
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr;
//插入记录
- (BOOL)wzInsertRecorderDataWithTableName:(NSString *)tableName valuesDictionary:(NSDictionary *)dic;
#pragma mark - 删除记录

//删除一个表中所有信息
-(void)wzDeleteReCordFromTableName:(NSString *)tableName;


#pragma make - 获取记录


-(NSMutableArray *)jyqGainTableName:(NSString *)tableName andModelName:(NSString*)modelName;


//返回数据库表中所有的数据对象
-(NSMutableArray *)wzGainTableRecoderID:(NSString *)tableName andModelName:(NSString*)modelName;












@end
