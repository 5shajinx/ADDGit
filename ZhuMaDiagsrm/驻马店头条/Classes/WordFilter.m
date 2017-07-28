//
//  WordFilter.m
//  43234
//
//  Created by 孙满 on 16/12/29.
//  Copyright © 2016年 吕书涛. All rights reserved.
//

#import "WordFilter.h"
#define EXIST @"isExists" 

@interface WordFilter()

@property (nonatomic,strong) NSMutableDictionary *root;
@property (nonatomic,assign) BOOL isFilterClose;
//测试git
@end

@implementation WordFilter
static WordFilter *instance;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}


- (void)initFilter:(NSMutableArray *)filepath{
    
    self.root = [NSMutableDictionary dictionary];

    
    for (NSString *str in filepath) {
        //插入字符，构造节点
        [self insertWords:str];
    }
  
    
}

-(void)insertWords:(NSString *)words{
    NSMutableDictionary *node = self.root;
    
    for (int i = 0; i < words.length; i ++) {
        NSString *word = [words substringWithRange:NSMakeRange(i, 1)];
        
        if (node[word] == nil) {
            node[word] = [NSMutableDictionary dictionary];
        }
        
        node = node[word];
    }
    
    //敏感词最后一个字符标识
    node[EXIST] = [NSNumber numberWithInt:1];
}

- (NSString *)filter:(NSString *)str{
    
    if (self.isFilterClose || !self.root) {
        return str;
    }
    
    NSMutableString *result = result = [str mutableCopy];
    
    for (int i = 0; i < str.length; i ++) {
        NSString *subString = [str substringFromIndex:i];
        NSMutableDictionary *node = [self.root mutableCopy] ;
        int num = 0;
        
        for (int j = 0; j < subString.length; j ++) {
            NSString *word = [subString substringWithRange:NSMakeRange(j, 1)];
            
            if (node[word] == nil) {
                break;
            }else{
                num ++;
                node = node[word];
            }
            
            //敏感词匹配成功
            if ([node[EXIST]integerValue] == 1) {
                
                NSMutableString *symbolStr = [NSMutableString string];
                for (int k = 0; k < num; k ++) {
                    [symbolStr appendString:@"*"];
                }
                
                [result replaceCharactersInRange:NSMakeRange(i, num) withString:symbolStr];
                
                i += j;
                break;
            }
        }
    }
    
    return result;
}

- (void)freeFilter{
    self.root = nil;
}

- (void)stopFilter:(BOOL)b{
    self.isFilterClose = b;
}







@end
