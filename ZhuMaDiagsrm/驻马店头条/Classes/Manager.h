//
//  Manager.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/20.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Manager : NSObject

//声明属性  用于实现传值

//声明单例方法
+ (Manager *)sharedManager;

@property (nonatomic, strong) NSString *jrStr;
//@property (nonatomic, strong)NSString *str;
@property(nonatomic, assign)CGFloat mainHeight;

@property(nonatomic, assign)CGFloat HEIGHT;

+ (UIImage *)shotScreen;
- (void)location;
//测试
@property(nonatomic, strong)NSMutableArray *text;

@property(nonatomic, strong)NSMutableArray *LMarray;

@property (nonatomic, strong)NSMutableArray *cateid;

@property(nonatomic, assign)NSInteger intger;

@property(nonatomic, assign)NSInteger index;

@property(nonatomic, assign)NSInteger height;//zhengwufuwu

@property(nonatomic, strong)NSString *sssss;//panduanbiaoshi
@property(nonatomic, strong)NSString *dingyuebiaoshi;
//用户信息
@property(nonatomic, strong)NSString *usid;
@property(nonatomic, strong)NSString *token;
@property (nonatomic, strong)NSString *string;
@property (nonatomic, strong)NSString *picString;
@property (nonatomic, strong)NSString *qianming;
@property (nonatomic, strong)NSString *type;
@property (nonatomic, strong)NSString *msg;
@property(nonatomic, strong)NSString *nickname;
@property(nonatomic, strong)NSString *picture;

+ (NSString *)valiMobile:(NSString *)mobile;//正则表达式匹配手机号

-(BOOL)checkPassWord:(NSString *)password;//正则匹配用户密码6-20位数字和字母组合

@property(nonatomic, assign)CGFloat pingLunHeight;


@property(nonatomic, assign)CGFloat lvliHeight;

@property(nonatomic, strong)NSString *bmlbid;
@property(nonatomic, strong)NSString *bmlbtitle;

+ (void)setupclicknum:(NSString *)type arid:(NSString *)arid;

@property(nonatomic, assign)NSInteger inttt;

@property(nonatomic, assign)NSInteger page;
@property(nonatomic, assign)NSInteger fabuheight;

@property(nonatomic, assign)NSInteger lv;
@property(nonatomic, strong)NSMutableArray *xwcname;
@property(nonatomic, strong)NSMutableArray *xwcid;

@property(nonatomic, assign)NSInteger xwcIndex;
@property(nonatomic, assign)NSInteger refresh;


@property(nonatomic, assign)NSInteger heightWebview;

@property(nonatomic, strong)NSString *movieURL;
@property(nonatomic, strong)NSString *jinru;

@property(nonatomic, strong)NSMutableArray *dingyueArray;
+ (NSString *)timeWithTimeIntervalString:(NSString *)str;
+ (NSString *)othertimeWithTimeIntervalString:(NSString *)str;
+ (NSString *)otheronetimeWithTimeIntervalString:(NSString *)str;
@property(nonatomic, strong)NSString *firstQiDong;


@property(nonatomic, strong)NSString *zonename;
@property(nonatomic, strong)NSString *zoneid;
@property(nonatomic, strong)NSString *zonearid;



@property(nonatomic, strong)NSString *hiddenlogin;

@property(nonatomic, strong)NSString *shipinskip;

@property(nonatomic, strong)NSString *liuliang;



- (void)panduanjincikugengxin;
- (void)returnjinci;


//判断是否点赞
@property(nonatomic, strong)NSMutableSet *mutSet;
@property(nonatomic, strong)NSMutableSet *MovieMutSet;


//直播
@property(nonatomic, strong)NSString *zhuchirenid;
@property(nonatomic, strong)NSString *zhuchiren;
@property(nonatomic, strong)NSString *zhibobiaoji;
@property(nonatomic, strong)NSString *zhiboid;
@property(nonatomic, strong)NSString *jizheid;
@property(nonatomic, strong)NSString *biaoji;
@property(nonatomic, strong)NSString *classifyid;
@property(nonatomic, strong)NSString *url;
@property(nonatomic, strong)NSString *edit;
- (NSString *)md5:(NSString *)str;
@property(nonatomic, strong)NSString *userid;
- (UIImage *)zhuanhuanpic:(NSString *)string;
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;//压缩图片
@property(nonatomic, strong)NSString *editjizheid;
@property(nonatomic, strong)NSString *editjizheidbiaoji;


//判断时候是否是定位
@property(nonatomic, assign)BOOL locaton;
//判断时候是第二次点击位置
@property(nonatomic, assign)NSString *numbbb;


//推送的deviceToken
@property(nonatomic, strong)NSString *tuiSongString;
//adid
@property(nonatomic, strong)NSString *adIdString;
@property(nonatomic, assign)BOOL dddf;

@property(nonatomic, assign)BOOL firstt;//是否进行了频道编辑
@property(nonatomic, assign)BOOL isErron;//标记是否标题错误


@end
