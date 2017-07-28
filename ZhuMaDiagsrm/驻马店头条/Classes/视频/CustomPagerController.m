//
//  CustomPagerController.m
//  TYPagerControllerDemo
//
//  Created by tany on 16/5/17.
//  Copyright © 2016年 tanyang. All rights reserved.
//

#import "CustomPagerController.h"
#import "CustomViewController.h"

#import "Manager.h"
#import "LMModel.h"
#import "Manager.h"
#import "ZMDNNetWorkStata.h"

 


static NSString *movietitlewebCasher = @"MovieTitleCasher";

@interface CustomPagerController (){
    DataBaseManager *dataManager;
    
}

@property (nonatomic,assign) NSInteger pagee;


@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)NSMutableArray *namearray;
@property(nonatomic, strong)NSMutableArray *cate_idarray;
@property(nonatomic, strong)NSMutableArray *modelarray;

@property(nonatomic, strong)NSMutableArray *ceshi;

@property(nonatomic, strong)NSMutableArray *arr;

//@property(nonatomic, strong)UIButton *btn;
//@property(nonatomic, strong)UIButton *button;
@end

@implementation CustomPagerController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    if (width == 375) {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 71*Kscaleh, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [self.view addSubview:line];
    }else if (width == 414){
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 67*Kscaleh, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [self.view addSubview:line];
    }else {
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 77*Kscaleh, ScreenW, 1)];
        line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
        [self.view addSubview:line];
    }
    
    
    
    
    
    
    
    self.array = [NSMutableArray array];
    self.namearray = [NSMutableArray array];
    self.cate_idarray = [NSMutableArray array];
    self.modelarray = [NSMutableArray array];
    
//    self.ceshi = [NSMutableArray array];
//    self.ceshi = [@[@"推荐",@"热点视频",@"视频新闻",@"新闻联播",@"晚间播报",@"魅力乡村",@"法政在线",@"大驿站",@"房车视界",@"655",@"454",@"45",@"545"]mutableCopy];
    
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil)  {
//        if ([[Manager sharedManager].firstQiDong isEqualToString:@"diyici"]) {
//            [self getDataFromlocal];
//        }
//        if ([[Manager sharedManager].firstQiDong isEqualToString:@"nil"]) {
            [self getDataFromlocal];
            [self loadTitiles];
//        }
    }
    
    
    
    if ([ZMDNNetWorkStata isconnectedNetwork] == nil) {
       
        NSString *str =  [self backDocumentsPathWithFileName:@"array.text"];
        self.namearray = [NSMutableArray arrayWithContentsOfFile:str];
        //NSLog(@"%@",[NSMutableArray arrayWithContentsOfFile:str][0]);
        //[self getDataFromlocal];
    }
    
    self.cellSpacing = 8;
    self.adjustStatusBarHeight = YES;
    //self.cellWidth = ScreenW/4.5;
//    self.progressView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_showNavBar) {
        [Manager sharedManager].lv = 0;
        self.navigationController.navigationBarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!_showNavBar) {
        self.navigationController.navigationBarHidden = NO;
    }
}


#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    return self.namearray.count;
}


- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index
{   
    NSString *title = self.namearray[index];
    return title;
}
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
        CustomViewController *VC = [[CustomViewController alloc]init];
        VC.text = [@(index) stringValue];
        return VC;
}

- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:movietitlewebCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadTitiles];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
           
        });
    });
}



-(void)loadTitiles
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    [session GET:LMURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:movietitlewebCasher];
            [arr writeToFile:filewebCaches atomically:YES];
        });

        weakSelf.array = [LMModel mj_objectArrayWithKeyValuesArray:arr];
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (LMModel * model in self.array)
        {
           // [dataManager insertMovieTitle:model];
            [array addObject:model.cate_name];
            [weakSelf.cate_idarray addObject: model.cate_id];
        }
        
       
         NSString *arrayPath = [weakSelf backDocumentsPathWithFileName:@"array.text"];
        [array writeToFile:arrayPath atomically:YES];
        
        
        
        NSString *Path = [weakSelf backDocumentsPathWithFileName:@"idArray.text"];
        [weakSelf.cate_idarray writeToFile:Path atomically:YES];
        

        
            [weakSelf hhhhhhhhhh:array];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@",error);
    }];
    
}
- (void)hhhhhhhhhh:(id)arr{
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
        self.namearray = arr;
        [Manager sharedManager].cateid = self.cate_idarray;
    }

    
    if ([ZMDNNetWorkStata isconnectedNetwork] == nil)  {
        NSMutableArray *array = [dataManager allMoviesListTitle];
         for (LMModel * model in array) {
            [self.namearray addObject:model.cate_name];
            [[Manager sharedManager].cateid addObject:model.cate_id];
        }
//        NSString *arrayPath = [self backDocumentsPathWithFileName:@"array.text"];
//        self.namearray = [NSMutableArray arrayWithContentsOfFile:arrayPath];
//       
//        NSString *Path = [self backDocumentsPathWithFileName:@"/idArray.text"];
//        [Manager sharedManager].cateid = [NSMutableArray arrayWithContentsOfFile:Path];
     }
    
}


- (NSString *)backDocumentsPathWithFileName:(NSString *)fileName {
    NSString *DocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *newFilePath = [DocumentsPath stringByAppendingPathComponent:fileName];
    
    return newFilePath;
}


- (void)setUpTabBarItem {
   
  
    
//    
//    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"视听" image:[UIImage imageNamed:@"shi"] selectedImage:[UIImage imageNamed:@"shi"]];
//    self.tabBarItem = tabBarItem;
//    
    
    
    
    self.tabBarController.tabBar.barStyle = UIBarStyleBlack;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
   // tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setUpTabBarItem];
    }
    return self;
}


@end
