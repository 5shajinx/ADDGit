//
//  ZMDNMainViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/23.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNMainViewController.h"
#import "RecommendTableViewController.h"
#import "ZMDNVideoCollectionViewController.h"
#import "ZMDNColumModel.h"
#import "ZMDNCommonClass.h"
#import "ZMDNNetWorkStata.h"
//#import "mydatabase.h"
//#import "ZMDNSearchTableViewController.h"
#import "SlideHeadView.h"
#import "AdvertiseViewController.h"

#import "SlideHeadView.h"

#import "ZMDAddViewController.h"
#import "ZMDNTianXiaViewController.h"
static NSString *zhuyewebCasher = @"zhuyeCasher";

@interface ZMDNMainViewController ()<UIScrollViewDelegate>

@property(nonatomic, strong) SlideHeadView *slideVC;

@property(nonatomic, strong) NSMutableArray *culumArr;

@property(nonatomic, strong) NSMutableArray *titleArr;
@property(nonatomic, strong) NSMutableArray *errorArr;

@property(nonatomic, strong)RecommendTableViewController *areaController;


@end

@implementation ZMDNMainViewController





- (void)viewDidLoad
{
    
    [super viewDidLoad];
    

     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"pushtoad" object:nil];
    
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAddView) name:@"addtonzhi" object:nil];
    
 
    
    self.errorArr = [NSMutableArray arrayWithCapacity:1];
    
    
    
    
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    _culumArr = [[NSMutableArray alloc] initWithCapacity:1];
    _titleArr = [[NSMutableArray alloc] initWithCapacity:1];
    
    [self setupNav];
    _slideVC = [[SlideHeadView alloc]init];
    
    
    
    
    
    
    
    
    
    [self.view addSubview:_slideVC];
    
    if ([[Manager sharedManager].firstQiDong isEqualToString:@"diyici"]) {
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [self getDataFromlocal];
         //[self loadTitiles];
    }
    else {
         [self getDataFromlocal];
         [self loadTitiles];
    }

    
}


//跳转到频道编辑也页面
- (void)pushToAddView{
    
    ZMDAddViewController *addVc = [[ZMDAddViewController alloc]init];
    addVc.Shuablock = ^(){
        [self loadTitiles];
   
    };
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController pushViewController:addVc animated:NO];
    
    
   
}

- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:zhuyewebCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
      //  if (fileDic == nil) {
            [self loadTitiles];
      //  }else {
       //     [self hhhhhhhhhh:fileDic];
      //  }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movie:) name:@"city" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topTitlearr:) name:@"titlearr" object:nil];
            
                self.slideVC.titlesArr = _titleArr;
            
                [self jyqaddChildViewController];
            
            });
    });
}

- (void)topTitlearr:(NSNotification *)text {
    NSString * positionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位"];
    [self.slideVC.titlesArr replaceObjectAtIndex:2 withObject:positionStr];
    [self.slideVC.buttons[2] setTitle:positionStr forState:UIControlStateNormal];
    
    
}

- (void)movie:(NSNotification *)text {
    //NSLog(@"======%ld",self.slideVC.titlesArr.count);
    [self.slideVC.titlesArr replaceObjectAtIndex:2 withObject:text.userInfo[@"name"]];
    [self.slideVC.selectedBtn setTitle:text.userInfo[@"name"] forState:UIControlStateNormal];
    [self.slideVC.buttons replaceObjectAtIndex:2 withObject:self.slideVC.selectedBtn];
    
    self.areaController.ar_areaid = [text.userInfo[@"areaid"] integerValue];
//    self.areaController.cate_id = [text.userInfo[@"arid"] integerValue];

    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"111",@"222",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tabview" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
}



-(void)loadTitiles
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
     __weak typeof(self) weakSelf = self;
    [session GET:COLUMNURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
      
        
            if ([Manager sharedManager].isErron) {
                    // 标题错乱 重新添加
            [self showOnleText:@"操作失败" delay:1.5];
                   [Manager sharedManager].isErron = NO;
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];
                    [weakSelf textaddxiaohguo:arr];
            return ;
                }

//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//            NSString *filewebCaches = [file stringByAppendingPathComponent:zhuyewebCasher];
//            [arr writeToFile:filewebCaches atomically:YES];
//        });
        
     //   [weakSelf hhhhhhhhhh:arr];
        //判断服务器有没有更新数组
        NSArray *rootArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"rootArr"];
        BOOL root = [self isEqToArrWithFirstArr:arr Secarr:rootArray];
        if (!root) {
            //newdicc
            NSMutableDictionary *mudic = [NSMutableDictionary dictionaryWithCapacity:1];
            NSLog(@"9999999%@",arr);
            for (int i = 0; i<arr.count; i++) {
                NSDictionary *dic = arr[i];
                
                NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cate_name"]];
                
                [mudic setObject:arr[i] forKey:str];
                
                
                
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newdicc"];

            [[NSUserDefaults standardUserDefaults] setObject:mudic forKey:@"newdicc"];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];

            [weakSelf textaddxiaohguo:arr];
            //保存服务器来的数组
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"rootArr"];
            return;
            
        }

        NSArray *Uparray = [[NSUserDefaults standardUserDefaults]objectForKey:@"UpArray"];
        
       // NSLog(@"99999999999999999&%@",Uparray);
        //判断数组中是否有重复的元素
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:0];
        for(NSString *str in Uparray)
        {
            [dic setValue:str forKey:str];
        }
       // NSLog(@"%@",[dic allKeys]);
        if ([dic allKeys].count == Uparray.count) {
            
            
            
            
            //没有重复的元素
            [weakSelf textaddxiaohguo:Uparray];
        } else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];

            [weakSelf textaddxiaohguo:arr];
            
        }
        
        
        
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"服务器开小差全局没数据,请稍后重试." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alView show];
        
        
        
        
    }];
}
//判断两个数组是否相同
- (BOOL)isEqToArrWithFirstArr:(NSArray *)firstArr Secarr:(NSArray *)secArr{
    if (firstArr.count != secArr.count) {
        return NO;
        
    }
    NSMutableSet *set1 = [NSMutableSet setWithArray:firstArr];
    NSMutableSet *set2 = [NSMutableSet setWithArray:secArr];
    [set1 minusSet:set2];
    if (set1.count>0) {
        return NO;
    }
    
    return YES;
    
}
//测试栏目切换效果
- (void)textaddxiaohguo:(NSArray *)add{

          NSArray *arrayy = [NSArray arrayWithArray:add];
    
    
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UpArray"];
        [[NSUserDefaults standardUserDefaults] setObject:arrayy forKey:@"UpArray"];
    
    
    
    [_titleArr removeAllObjects];
    
    self.slideVC.titlesArr = nil;
    
    [_culumArr removeAllObjects];
    [self hhhhhhhhhh:add];


}

- (void)hhhhhhhhhh:(id)arr{
    
    _culumArr = [ZMDNColumModel mj_objectArrayWithKeyValuesArray:arr];

//    NSLog(@"+++++++++++%@",arr);
    
 

    for (ZMDNColumModel * model in _culumArr)
    {
        [_titleArr addObject:model.cate_name];
   //     NSLog(@"^^^^^^^^^^^^^^^^^^^%@",model.cate_name);
    }
  //  NSLog(@"^^^^^^^^^^^^^^^^^^^%@",self.slideVC.titlesArr);

    [_slideVC remove];
    if (_titleArr.count>1) {
 
        self.slideVC.titlesArr = _titleArr;
        [self jyqaddChildViewController];


    }
    
    
    
    
    
    
//    //第一次启动
//    if ([[Manager sharedManager].firstQiDong isEqualToString:@"diyici"]) {
//        self.slideVC.titlesArr = _titleArr;
//        [self jyqaddChildViewController];
//        //[MBProgressHUD hideHUDForView:self.view animated:YES];
//    }
    
}

- (void)jyqaddChildViewController
{

    
    
    for (int i = 0; i < _culumArr.count ; i++)

    {
        
        ZMDNColumModel *model = _culumArr[i];
      int a = (int)model.sort;
        bool isbb = false;
        
        if (a == 3) {
            isbb = true;
        }
        
        
        
        if (((int)model.sort != 4) && ((int)model.sort != 5))
       // if (i != 3)
        
       // if(!_bbb)
        {
            RecommendTableViewController *recommendVc = [[RecommendTableViewController alloc] init];
            
            ZMDNColumModel *model = _culumArr[i];
            recommendVc.cate_id = model.cate_id;
            if (i!= 1)
            {
                   //if (i == 2){
                    if (isbb){

                    self.areaController = recommendVc;
                    recommendVc.flag = @"定位";
                    NSString * positionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位"];
                       //NSLog(@"--------%@",positionStr);
                    NSArray *townArr = @[@"驻马店",@"遂平",@"西平",@"上蔡",@"汝南",@"平舆",@"确山",@"正阳",@"泌阳"];
//                      for (NSString *arer in townArr) {
//                          if ([positionStr isEqualToString:@"驿城区"] || ![positionStr isEqualToString:arer])
//                          {
//                              positionStr = @"驻马店";
//                              recommendVc.ar_areaid = 2;
//                          }

                    if([positionStr containsString:townArr[1]])
                    {
                        positionStr = @"遂平";
                        recommendVc.ar_areaid = 3;
                        
                     }else if([positionStr containsString:townArr[2]])
                    {
                        positionStr = @"西平";
                        recommendVc.ar_areaid = 4;
                        
                    }else if([positionStr containsString:townArr[3]])
                    {
                        positionStr = @"上蔡";
                        recommendVc.ar_areaid = 5;
                        
                    }else if([positionStr containsString:townArr[4]])
                    {
                        positionStr = @"汝南";
                    recommendVc.ar_areaid = 6;
                        
                    }else if([positionStr containsString:townArr[5]])
                    {
                        positionStr = @"平舆";
                        recommendVc.ar_areaid = 7;
                        
                    }else if([positionStr containsString:townArr[6]])
                    {
                        positionStr = @"确山";
                        recommendVc.ar_areaid = 8;
                        
                    }
                    else if([positionStr containsString:townArr[7]])
                    {
                        positionStr = @"正阳";
                        recommendVc.ar_areaid = 9;
                        
                    }else if([positionStr containsString:townArr[8]])
                    {
                        positionStr = @"泌阳";
                        recommendVc.ar_areaid = 11;
                    }else {
                        positionStr = @"驻马店";
                        recommendVc.ar_areaid = 2;
                    }
                    
                       
                       
                       //NSLog(@"%@-----%d",positionStr,i);
                    [_titleArr replaceObjectAtIndex:i withObject:positionStr];
                }
            }
            //NSLog(@"*********%@",_titleArr[i]);
            

                  [_slideVC addChildViewController:recommendVc title:_titleArr[i]];
          
            
            
            
            
         }
        
        
        
       //else  if (i == 3)
        if ((int)model.sort == 4)
        {
            ZMDNVideoCollectionViewController *vedeoVC = [[ZMDNVideoCollectionViewController alloc] init];
            ZMDNColumModel *model = _culumArr[i];
            vedeoVC.cate_id = model.cate_id;

            
            [_slideVC addChildViewController:vedeoVC title:_titleArr[i]];
        }
        if ((int)model.sort == 5  && (model.url.length>8))
        {
            ZMDNTianXiaViewController *webVC = [[ZMDNTianXiaViewController alloc] init];
            webVC.myUrlStr = [NSString stringWithFormat:@"%@",model.url];
            
            
            [_slideVC addChildViewController:webVC title:_titleArr[i]];
        }
    }
    
    
    [_slideVC setSlideHeadView];
}



- (void)pushToAd {
    AdvertiseViewController *adVc = [[AdvertiseViewController alloc] init];
    [self.navigationController pushViewController:adVc animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    //self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)setupNav
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"drawer"] forState:UIControlStateNormal];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    self.view.backgroundColor = [UIColor whiteColor];
}

-(BOOL)shouldAutorotate
{
    return NO;
}
//方法走了 就是不显示
- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *ghud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  //  [self.view bringSubviewToFront:ghud   ];
    // Set the text mode to show only text.
    ghud.mode = MBProgressHUDModeText;
    ghud.label.text = text;
    // Move to bottm center.
    ghud.center = self.view.center;//屏幕正中心
    
    
    [ghud hideAnimated:YES afterDelay:delay];
}
@end
