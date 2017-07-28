//
//  mydatabase.m
//  myreflash
//
//  Created by Mac10.11.4 on 16/4/25.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "mydatabase.h"
#import <objc/runtime.h>
#import "FMDB.h"
#import "ZMDNRecommend.h"
#import "ZMDNColumModel.h"

@interface mydatabase ()

@property(nonatomic, strong) FMDatabase *db;

@property(nonatomic, strong) FMResultSet *ms;

@end

@implementation mydatabase

//获取类的各个属性，存到数组中
+ (id)propertyKeysWithString:(NSString *)classStr

{
    unsigned int outCount, i;
    
    //获取一个类的各个成员变量存放在properties[]数组中
    objc_property_t *properties = class_copyPropertyList([NSClassFromString(classStr) class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
    }
    
    free(properties);
    
    return keys;
}



+ (id)KeysWithDic:(NSDictionary *)dic

{
    NSArray *arr = [[NSArray alloc] init];
    
    if (dic)
    {
       arr = [dic allKeys];
    }
    return arr;
}




//单利数据库
static mydatabase *dataBase = nil;

//得到数据库，单例的数据库
+ (instancetype)shareMyDataBase
{
    if (!dataBase)
    {
        @synchronized(self)
        {
            if (!dataBase)
            {
                dataBase = [[mydatabase alloc] init];
                
                NSString *dbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/WZProject.db"];
//                 NSLog(@"===%@===", dbPath);
                dataBase.db = [FMDatabase databaseWithPath:dbPath];
                if (![dataBase.db open])
                {
                    dataBase = nil;
                }
            }
        }
    }
    return dataBase;
}


//判断表格是否存在
- (BOOL)isExistTable:(NSString *)tableName
{
    BOOL value = NO;
    if ([_db tableExists:tableName])
    {
        value = YES;
//        NSLog(@"%@存在", tableName);
    }
    return value;
}


//创建表
- (void)wzCreateTableID:(NSString *)tableName
{

    if ([dataBase.db open]) {
        
        if (![dataBase.db tableExists:tableName])
        {
            //@"create table if not exists t_health(id integer primary key  autoincrement, name text,phone text)"
            
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (id text primary key, titlepic text,title text, titleurl text, newstime text)",tableName];
            
            BOOL myValue = [dataBase.db executeUpdate:sql];
            
            if (myValue) {
//                NSLog(@"表创建成功");
            }
            else
            {
//                NSLog(@"表创建失败");
            }
        }
    }

}



//建立新闻的表
- (BOOL)jyqCreateTableID:(NSString *)tableName
{
    BOOL myValue = NO;
    
    if ([dataBase.db open]) {
        
        if (![dataBase.db tableExists:tableName])
        {
            //@"create table if not exists t_health(id integer primary key  autoincrement, name text,phone text)"
            
            NSString *sql = [NSString stringWithFormat:@"CREATE TABLE %@ (id integer primary key  autoincrement, ar_id integer, ar_title text,ar_pic text, ar_pic1 text, ar_pic2 text, ar_time text, ar_ly text, ar_volume integer,ar_type integer)",tableName];
            
             myValue = [dataBase.db executeUpdate:sql];
            
            if (myValue) {
//                NSLog(@"表创建成功");
            }
            else
            {
//                NSLog(@"表创建失败");
            }
        }
    }
    
    return myValue;
}


//建立栏目的表
-(void)creatcolumnTable
{
    NSString *sql = [NSString stringWithFormat:@"create table if not exists column(cate_id integer primary key  autoincrement, cate_name text)"];
   [dataBase.db executeUpdate:sql];
//    NSLog(@"%d",value);

}

//插入栏目
-(void)insertColunm:(ZMDNColumModel*)model
{
  [dataBase.db executeUpdate:@"INSERT INTO column(cate_id, cate_name) VALUES (?,?)", [NSNumber numberWithInteger:model.cate_id],model.cate_name];
//    NSLog(@"%d",value);
    
}



//以字典数组的形式请求插入用户数据
- (BOOL)insertRecorderDataWithTableName:(NSString *)tableName andModelArray:(NSArray *)arr
{
    for (NSDictionary* dic in arr)
    {
        [self wzInsertRecorderDataWithTableName:tableName valuesDictionary:dic];
    }
    
    return YES;
}



//以字典的形式插入记录
- (BOOL)wzInsertRecorderDataWithTableName:(NSString *)tableName valuesDictionary:(NSDictionary *)dic
{
    BOOL Incertvalue = NO;
    NSArray *propotyArr = [[self class] KeysWithDic:dic];
    
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"INSERT INTO %@", tableName]];
    [sqlString appendString:@" ("];
    for (NSString *string in propotyArr)
    {
        [sqlString appendString:string];
        [sqlString appendString:@","];
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length] - 1, 1)];
    [sqlString appendString:@") VALUES ("];
    for (int i = 0; i < [propotyArr count]; ++i)
    {
        [sqlString appendString:@"?,"];
        
    }
    [sqlString deleteCharactersInRange:NSMakeRange([sqlString length]-1, 1)];
    [sqlString appendString:@")"];
    
    if ([dataBase.db executeUpdate:sqlString withArgumentsInArray:[dic allValues]])
    {
        Incertvalue = YES;
    }
    return Incertvalue;
    
}





- (NSMutableArray *)jyqGainTableName:(NSString *)tableName andModelName:(NSString*)modelName
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
    
    dataBase.ms = [dataBase.db executeQuery:sqlString];
    
    while ([dataBase.ms next])
    {
        ZMDNRecommend* model = [[ZMDNRecommend alloc] init];
                
        NSArray *  arr = [model modelNeedSavekeys];
      
        for (id key in arr)
        {
                id aa = [dataBase.ms objectForColumnName:key];
                [model setValue:aa forKey:key];
        }
        [returnArray addObject:model];
        
    }
    
    [dataBase.ms close];
    //[dataBase.db close];
    return returnArray;

}



//取出来
-(NSMutableArray *)wzGainTableRecoderID:(NSString *)tableName andModelName:(NSString*)modelName
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] initWithCapacity:1];
    NSMutableString *sqlString = [NSMutableString string];
    [sqlString appendString:[NSString stringWithFormat:@"SELECT * FROM %@", tableName]];
    
    dataBase.ms = [dataBase.db executeQuery:sqlString];
    
    while ([dataBase.ms next])
    {
        id model = [[NSClassFromString(modelName) alloc] init];
        
        NSArray *propeties = [[self class] propertyKeysWithString:modelName];
        
        for (id key in propeties ) {
            
                id aa = [dataBase.ms objectForColumnName:key];
                [model setValue:aa forKey:key];
      }
        
        [returnArray addObject:model];
        
    }
    
    [dataBase.ms close];
    return returnArray;
}


-(void)wzDeleteReCordFromTableName:(NSString *)tableName
    {
        NSString *sqlString = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
        [dataBase.db executeUpdate:sqlString];
    }
















@end
