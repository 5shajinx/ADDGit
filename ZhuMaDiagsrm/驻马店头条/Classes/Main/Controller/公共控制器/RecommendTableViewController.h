//
//  RecommendTableViewController.h
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/6.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecommendTableViewController :UITableViewController

@property (nonatomic, assign) NSInteger cate_id;

@property (nonatomic, assign) NSInteger  ar_areaid;

@property(nonatomic,copy) NSString * flag ;

//专题传值Url
@property(nonatomic, strong)NSString *subjectUrl;



@end
