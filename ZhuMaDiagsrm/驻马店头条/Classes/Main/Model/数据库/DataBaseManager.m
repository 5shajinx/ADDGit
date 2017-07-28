//
//  DataBaseManager.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "DataBaseManager.h"

static DataBaseManager *manager = nil;

@implementation DataBaseManager

+ (DataBaseManager  *)sharedFMDBManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DataBaseManager alloc]init];
    });
    return manager;
    
}
//准备好文件路径
- (NSString *)backFilePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newFilePath = [documentPath stringByAppendingPathComponent:@"dataBaseManager.sqlite"];
    return newFilePath;
}
//创建数据库
- (void)createDataDase {
    //创建数据库开始
    self.db = [FMDatabase databaseWithPath:[self backFilePath]];
    //打开数据库
    if ([self.db open]) {
        //NSLog(@"数据库打开成功");
    }else {
       // NSLog(@"数据库打开失败");
    }
}


//视频标题
- (void)createMovieTitleTable {
     [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'MovieTitleList' ('cate_id' TEXT , 'cate_name' TEXT, 'isCollect' BOOLEAN)"];
}
- (void)insertMovieTitle:(LMModel *)model {
     [self.db executeUpdate:@"insert into MovieTitleList (cate_id, cate_name, isCollect) values(?,?,?)",model.cate_id,model.cate_name,  @(model.isCollect)];
     //NSLog(result?@"添加成功":@"添加失败");
}

- (void)deleteMovieTitle:(LMModel *)model {
   [self.db executeUpdate:@"delete from MovieTitleList where cate_id = ?",model.cate_id];
  //NSLog(result ?@"删除成功":@"删除失败");
}

- (NSMutableArray *)allMoviesListTitle {
    FMResultSet *set = [self.db executeQuery:@"select * from MovieTitleList"];
    NSMutableArray  *array = [[NSMutableArray alloc]initWithCapacity:1];
    while ([set next]) {
        LMModel *model = [[LMModel alloc]init];
        model.cate_id      = [set stringForColumn:@"cate_id"];
        model.cate_name         = [set stringForColumn:@"cate_name"];
        model.isCollect     = [set boolForColumn:@"isCollect"];
        [array addObject:model];
    }
    return array;
}


//视频内容
- (void)createMovieContentTable {
    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS 'MovieList' ('ar_title' TEXT , 'ar_id' TEXT NOT NULL, 'ar_movieurl' TEXT, 'ar_volume' TEXT, 'ar_cateid' TEXT, 'ar_pic' TEXT, 'ar_time' TEXT, 'ar_ly' TEXT, 'ar_onclick' TEXT, 'ar_type' TEXT, 'shareurl' TEXT, 'ar_userpic' TEXT 'collect' BOOLEAN)"];
}

- (void)insertMovieContent:(DetailsModel *)model {
      [self.db executeUpdate:@"insert into MovieList (ar_title, ar_id, ar_movieurl, ar_volume, ar_cateid, ar_pic, ar_time, ar_ly, ar_onclick, ar_type, shareurl, ar_userpic, collect ) values(?,?,?,?,?,?,?,?,?,?,?,?,?)",model.ar_title,model.ar_id,model.ar_movieurl,model.ar_volume,model.ar_cateid,model.ar_pic,model.ar_time,model.ar_ly,model.ar_onclick,model.ar_type,model.shareurl,model.ar_userpic, @(model.collect)];
   // NSLog(result?@"添加成功":@"添加失败");
}

- (void)deleteMovieContent:(DetailsModel *)model {
     [self.db executeUpdate:@"delete from MovieList where ar_id = ?",model.ar_id];
    //NSLog(result ?@"删除成功":@"删除失败");
}

- (NSMutableArray *)allMovieContentList {
    FMResultSet *set = [self.db executeQuery:@"select * from MovieList"];
    NSMutableArray  *array = [[NSMutableArray alloc]initWithCapacity:1];
    while ([set next]) {
        DetailsModel *model = [[DetailsModel alloc]init];
        model.ar_title      = [set stringForColumn:@"ar_title"];
        model.ar_id         = [set stringForColumn:@"ar_id"];
        model.ar_movieurl   = [set stringForColumn:@"ar_movieurl"];
        model.ar_onclick    = [set stringForColumn:@"ar_onclick"];
        model.ar_cateid     = [Manager sharedManager].cateid[[Manager sharedManager].index];
        model.ar_pic        = [set stringForColumn:@"ar_pic"];
        model.collect     = [set boolForColumn:@"collect"];
        [array addObject:model];
    }
    return array;
}



















@end
