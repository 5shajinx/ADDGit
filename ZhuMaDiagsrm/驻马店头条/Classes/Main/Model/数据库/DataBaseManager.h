//
//  DataBaseManager.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailsModel.h"
#import "LMModel.h"


@interface DataBaseManager : NSObject


//声明数据库属性
@property (nonatomic, retain) FMDatabase *db;
//声明方法
+ (DataBaseManager *)sharedFMDBManager;
- (NSString *)backFilePath;
//创建数据库
- (void)createDataDase;


- (void)createMovieTitleTable;
- (void)insertMovieTitle:(LMModel *)model;
- (void)deleteMovieTitle:(LMModel *)model;
- (NSMutableArray *)allMoviesListTitle ;




- (void)createMovieContentTable;
- (void)insertMovieContent:(DetailsModel *)model;
- (void)deleteMovieContent:(DetailsModel *)model;
- (NSMutableArray *)allMovieContentList ;
























@end
