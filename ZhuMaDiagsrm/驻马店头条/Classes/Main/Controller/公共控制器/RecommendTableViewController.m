//
//  RecommendTableViewController.m
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/6.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "ZMDNRecommend.h"
#import "ZMDNNoPicTableViewCell.h"
//#import "ZMDNWebViewController.h"
#import "PrefixHeader.pch"
#import "WEBVIEWController.h"

#import "ImageCirculationView.h"
#import "mydatabase.h"
#import "ZMDNNetWorkStata.h"
#import "ZMDNOneBigTableViewCell.h"
#import "ZMDNThreePicTableViewCell.h"
#import "ZMDNAdTableViewCell.h"
#import "ZMDNPicContentViewController.h"
#import "ZMDPlayerViewController.h"
#import "MainMovieCell.h"
#import "OneXiaoPicCell.h"
#import "CityViewController.h"
#import "JRSegmentViewController.h"
#define ImageH 150

#define Top 108

#import "NewsDetailsTableviewController.h"

#import "ZMDZBViewController.h"
#import "YinPinViewController.h"
#import "ZMDDSViewController.h"
#import "ZBDTTableViewController.h"

#import "ActivityRuleViewController.h"
#import "SignWebViewController.h"


#import "ZMDUserTableViewController.h"
#import "QDViewController.h"
#import "SYCollectionModel.h"
#import "SYCollectionViewCell.h"
#import "SlideHeadView.h"
#import "ActViewController.h"//活动
#import "WaiLianController.h"//活动web
#import "ShopIngViewController.h"//商城
#import <CommonCrypto/CommonCrypto.h>//MD5
#import "threeViewController.h"



#import "ZMDNYingYinViewController.h"
#import "ZMDNLeftViewController.h"
#import "ZMDNCenterViewController.h"
#import "ZMDNrightViewController.h"
#import "NewNetWorkManager.h"
static NSString *zhuyenews = @"zhuyenews";

@interface RecommendTableViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, clickPhoto,UICollectionViewDelegate,UICollectionViewDataSource>
{
        int page;
        NSInteger currentPage;
        NSInteger pageNum;
        NSInteger listNum;
        NSString *tableName;
        UIView *vieww;
    
}

@property(nonatomic, strong) NSMutableArray *recArr;
@property(nonatomic, strong) FMDatabase *db;


@property(nonatomic, strong) UICollectionView *collectionview;
@property(nonatomic, strong) NSMutableArray *collectionArr;
@property(nonatomic, strong) NSMutableArray *yingYinArray;



@end

@implementation RecommendTableViewController

- (NSMutableArray *)collectionArr {
    if (_collectionArr == nil) {
        self.collectionArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _collectionArr;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SYCollectionModel *model = self.collectionArr[indexPath.row];
    NSString *restr = [NSString stringWithFormat:@"%@",model.nurl];
    
    if ([restr isEqualToString:@"http://zmdtt.zmdtvw.cn/public/zt/list.html"]) {
        //纯web界面 公用界面(专题)
        [self lodHomePageNavigation];
        
        SYCollectionModel *model =  [self.collectionArr objectAtIndex:indexPath.row];
        
        
        WaiLianController *subVc = [[WaiLianController alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:subVc];
        subVc.urlString = [NSString stringWithFormat:@"%@",model.nurl];
        subVc.titleename = [NSString stringWithFormat:@"%@",model.nname];
        
        
        [self presentViewController:nav animated:YES completion:nil];
        

        
    }else if([restr isEqualToString:@"zmdtt:sign"]){
        //签到
        QDViewController *vc = [[QDViewController alloc] initWithAddVCARY:@[[SignWebViewController new],[ShopIngViewController new],[ActivityRuleViewController new]] TitleS:@[@"签到",@"商城",@"流量"]];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];

        
    }else if([restr isEqualToString:@"zmdtt:activity"]){
        //活动
        ActViewController *activityVC = [[ActViewController alloc]init];
                UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:activityVC];
    [self presentViewController:naVC animated:YES completion:nil];
        

    }
    else if([restr isEqualToString:@"zmdtt:service"]){
       //在路上
        //便民
        threeViewController  *bianmin = [[threeViewController alloc]init];
        UINavigationController *ZKnaVC = [[UINavigationController alloc]initWithRootViewController:bianmin];
        [self presentViewController:ZKnaVC animated:YES completion:nil];
        

    }
    else if([restr isEqualToString:@"zmdtt:movie"]){
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        if (_yingYinArray) {
            for (NSDictionary *diccc in _yingYinArray) {
NSString *sttttt = [NSString stringWithFormat:@"%@",[diccc objectForKey:@"menu_title"]];
                [arr addObject:sttttt];
            }
        }
        
        if (arr.count) {
            ZMDNYingYinViewController *yingyin = [[ZMDNYingYinViewController alloc]initWithAddVCARY:@[[ZMDNLeftViewController new],
                [ZMDNCenterViewController new],
                [ZMDNrightViewController new]] TitleS:arr];
            yingyin.urlArr = _yingYinArray;
            
            [[NSUserDefaults standardUserDefaults] setObject:_yingYinArray forKey:@"yingYinArray"];
            
            UINavigationController *navvvv = [[UINavigationController alloc]initWithRootViewController:yingyin];
            [self presentViewController:navvvv animated:YES completion:nil];
   
        } else{
            
            
           // 影音
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"服务器开小差,请稍后重试" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
            
                            UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            }];
                            [alertVC addAction:actionsure1];
                            [self presentViewController:alertVC animated:YES completion:nil];
            
        }
        
        
        
        
        

    }   else if([restr isEqualToString:@"zmdtt:road"]){
        
        
        
    }
    

    
    
}
- (void)ZiXunDetail{
    [NewNetWorkManager requestGETWithURLStr:@"http://api.zhumadian.ctv-cloud.com/api/program_list.php?token=1ff80aceac0553704aa0275390aa3515" parDic:nil finish:^(id resonbject) {
        NSDictionary *dic = [resonbject objectForKey:@"data"];
        NSArray *arr = [dic objectForKey:@"menu_data"];
        self.yingYinArray = [NSMutableArray arrayWithArray:arr];
        [_yingYinArray removeObjectAtIndex:0];

        
    } conError:^(NSError *error) {
        
    }];
    
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sycell" forIndexPath:indexPath];
    SYCollectionModel *model = [self.collectionArr objectAtIndex:indexPath.row];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.nlogo]];
    cell.lable.text = model.nname;
     
    return cell;
}

-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    //请求资讯的数据
    [self  ZiXunDetail];
    [[Manager sharedManager] location];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabview:) name:@"tabview" object:nil];
   
    [self getarr];
    [self lodHomePageNavigation];
    
    //通知修改位置

    
}



- (void)getarr {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:@"synavi"];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        if (fileDic == nil) {
            [self lodHomePageNavigation];
        }else {
            [self getNoNilArr:fileDic];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        });
    
    });
}


- (void)getNoNilArr:(NSMutableArray *)arr {
    
     self.collectionArr = [SYCollectionModel mj_objectArrayWithKeyValuesArray:arr];
}
- (void)lodHomePageNavigation {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:HomePageNavi parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSMutableArray *arr = [dic objectForKey:@"lst"];
        
        
        if (arr.count != 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:@"synavi"];
                [arr writeToFile:filewebCaches atomically:YES];
            });
        }
        
        [weakSelf getNoNilArr:arr];
        [weakSelf.collectionview reloadData];
//        NSLog(@"--------------%@",arr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error=%@",error);
    }];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.recArr = [NSMutableArray arrayWithCapacity:1];
  
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi2" object:nil];
    
    
    
    if ([self.title isEqualToString:@"推荐"])
    {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 255*Kscaleh+ScreenW/5-30*Kscalew+45)];
        ImageCirculationView *circulationView = [[ImageCirculationView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250*Kscaleh)];
        circulationView.clickDelege = self;
        circulationView.contentMode= UIViewContentModeScaleAspectFill;
        [view addSubview:circulationView];
        self.tableView.tableHeaderView = view;
        
        UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 255*Kscaleh+ScreenW/5-30*Kscalew+44, ScreenW, .5)];
        lab.backgroundColor = [UIColor colorWithWhite:.9 alpha:.5];
        [view addSubview:lab];
        
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(ScreenW/5, ScreenW/5-30*Kscalew+40);
        // 设置最小行间距
        layout.minimumLineSpacing = 0;
        // 设置滚动方向（默认垂直滚动）
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 255*Kscaleh, ScreenW, ScreenW/5-30*Kscalew+35) collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.backgroundColor = [UIColor whiteColor];
        [_collectionview registerClass:[SYCollectionViewCell class] forCellWithReuseIdentifier:@"sycell"];
        [view addSubview:_collectionview];
       
        
        
        if ( [ZMDNNetWorkStata isconnectedNetwork] == nil)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无网络连接" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertVC addAction:actioncancle];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
        
    }


    
    if ((_ar_areaid >= 2 && _ar_areaid <= 9) || _ar_areaid == 11)
    {
        
        self.title = @"定位";
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
       // self.tableView.tableHeaderView = view1;
        
        vieww = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        vieww.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.5];
        vieww.userInteractionEnabled = YES;
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
        imageview.image = [UIImage imageNamed:@"city"];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        imageview.clipsToBounds = YES;
        [vieww addSubview:imageview];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(35, 5, ScreenW-35, 20);
        [btn setTitle:@"点击选择地区" forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectedzone) forControlEvents:UIControlEventTouchUpInside];
        [vieww addSubview:btn];
         
        
      //  [self.view addSubview:vieww];
      //  [self.view bringSubviewToFront:vieww];
    }
    else
    {
        tableName = self.title;
        
    [[NSNotificationCenter defaultCenter] removeObserver:@"tongzhi2" name:nil object:self];
    }
   
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNNoPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"noPicCell"];
    
   // [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"havPic"];
    [self.tableView registerClass:[OneXiaoPicCell class] forCellReuseIdentifier:@"havPic"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNOneBigTableViewCell" bundle:nil] forCellReuseIdentifier:@"bigpic"];
   
    
    [self.tableView registerClass:[ZMDNThreePicTableViewCell class] forCellReuseIdentifier:@"threePic"];
 
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"ad"];

    //[self.tableView registerNib:[UINib nibWithNibName:@"ZMDNAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"movie"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainMovieCell" bundle:nil] forCellReuseIdentifier:@"movie"];
    
    
    
    self.tableView.separatorColor = Color(240, 240, 240);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
   
    _recArr = [NSMutableArray arrayWithCapacity:1];
    
    if ( [ZMDNNetWorkStata isconnectedNetwork] != nil)
    {
        [self setUpReflash];
    } else
    {
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无网络连接" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        }];
//        [alertVC addAction:actioncancle];
//        [self presentViewController:alertVC animated:YES completion:nil];
        
//        _recArr =  [[mydatabase shareMyDataBase] jyqGainTableName:tableName andModelName:nil];
//         [self.tableView reloadData];
       [self getDataFromlocal];
    }
    
    
    
    
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30*Kscaleh)];
    self.tableView.tableFooterView = downview;
}
//通知跳转地点选择界面
- (void)tongzhi:(NSNotification *)text{
    if ([text.userInfo[@"textOne"] isEqualToString:@"chuanshiji"]) {
        
        [[Manager sharedManager] location];
        CityViewController *cityVC = [[CityViewController alloc] init];
        
        [self presentViewController: cityVC animated:YES completion:nil];
        
    }
    
    
}
- (void)tabview:(NSNotification *)text {
    //NSLog(@"1432412341234123412");
    [self loadNewNews];
}
- (void)lodareadata {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    currentPage = 0;
    __weak typeof(self) weakself = self;
    NSDictionary *para = [[NSDictionary alloc] init];
    if (![self.title isEqual: @"定位"])
    {
        para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage]};
    }
    
    if ([self.title isEqual: @"定位"])
    {
        para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage],@"ar_areaid":[NSNumber numberWithInteger:self.ar_areaid]};
        //NSLog(@"-=-=-=-=-=-=-=-%@",para);
    }
    [session GET:CHANGECOLUMNDATA parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        //        NSMutableArray *arr = [[[arrar reverseObjectEnumerator] allObjects] mutableCopy];
        // NSLog(@"====-----------===%@",arr);
        
        if (arr.count != 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:zhuyenews];
                [arr writeToFile:filewebCaches atomically:YES];
            });
        }
        
        [weakself wuInternet:arr];
        //[_recArr addObjectsFromArray:recommendArr];
        [weakself.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}


- (void)selectedzone
{
    
   //定位成功发送通知  通知名字
    
    [[Manager sharedManager] location];
    CityViewController *cityVC = [[CityViewController alloc] init];
    
    [self presentViewController: cityVC animated:YES completion:nil];
}





-(BOOL)shouldAutorotate
{
    return NO;
}






//刷新数据
-(void)setUpReflash
{
     __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [weakSelf loadNewNews];
        
        [self getarr];
        [self lodHomePageNavigation];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (page == 0) {
            [weakSelf loadMoreNews];
//        }else {
//             [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }
        
        
     }];
}
- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:zhuyenews];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
       
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadNewNews];
       }else {
           [self wuInternet:fileDic];
        }
        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//        });
        
    });
}
- (void)wuInternet:(NSMutableArray *)arr {
    
//    [[mydatabase shareMyDataBase] wzDeleteReCordFromTableName:tableName];
//    [[mydatabase shareMyDataBase] jyqCreateTableID:tableName];
//    [[mydatabase shareMyDataBase] insertRecorderDataWithTableName:tableName andModelArray:arr];
    
    NSMutableArray *recommendArr = [ZMDNRecommend mj_objectArrayWithKeyValuesArray:arr];
    //[_recArr removeAllObjects];
    _recArr = recommendArr;
    
    if ([self.title isEqualToString:@"推荐"]){
        if (_recArr != nil) {
            //NSLog(@"666666");
            if (_recArr.count != 0) {
                ZMDNRecommend *com = _recArr[_recArr.count-1];
                if (com.ar_id == 0) {
                    [_recArr insertObject:_recArr[_recArr.count-1] atIndex:0];
                    [self.recArr removeObjectAtIndex:_recArr.count-1];
                }
            }
        }
    }
    
    
    ZMDNRecommend *com = [_recArr lastObject];
//    if (page == com.ar_id) {
//        page = 0;
//    }else {
        page = com.ar_id;
//    }

}
//下拉刷新
-(void)loadNewNews
{
     [self.tableView.mj_footer endRefreshing];
    
    
   
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    currentPage = 0;
     __weak typeof(self) weakself = self;
    NSDictionary *para = [[NSDictionary alloc] init];
    if (![self.title isEqual: @"定位"])
    {
        para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage]};
    }
    
    if ([self.title isEqual: @"定位"])
    {
         para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage],@"ar_areaid":[NSNumber numberWithInteger:self.ar_areaid]};
        //NSLog(@"-=-=-=-=-=-=-=-%@",para);
    }
    [session GET:CHANGECOLUMNDATA parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
//        NSMutableArray *arr = [[[arrar reverseObjectEnumerator] allObjects] mutableCopy];
        //NSLog(@"====-----------===%@",arr);
        
        if (arr.count != 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:zhuyenews];
                [arr writeToFile:filewebCaches atomically:YES];
            });
        }
        
        [weakself wuInternet:arr];
        //[_recArr addObjectsFromArray:recommendArr];
         [weakself.tableView reloadData];
         [weakself.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.tableView.mj_header endRefreshing];
    }];
    
}


/**
 *  上啦刷新
 */
-(void)loadMoreNews
{
    
    [self.tableView.mj_header endRefreshing];
    
    currentPage = page;
    NSDictionary *para = [[NSDictionary alloc] init];
    __weak typeof(self) weakself = self;
    if (![self.title isEqual: @"定位"])
    {
        para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage]};
     }
    else
    {
        para = @{@"cateid":[NSNumber numberWithInteger:_cate_id] ,@"ar_id":[NSNumber numberWithInteger:currentPage],@"ar_areaid":[NSNumber numberWithInteger:_ar_areaid]};
    }
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session GET:CHANGECOLUMNDATA parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
        //NSLog(@"ZHUYE *****  %@",arr);
       // [[mydatabase shareMyDataBase] insertRecorderDataWithTableName:tableName andModelArray:arr];
        
        NSMutableArray *recommendArr = [ZMDNRecommend mj_objectArrayWithKeyValuesArray:arr];
        for (ZMDNRecommend *model in recommendArr) {
            [_recArr addObject:model];
        }
        //[_recArr addObjectsFromArray:recommendArr];
//        for (ZMDNRecommend *com in _recArr) {
//             page = com.ar_id;
//        }
        
        ZMDNRecommend *com = [_recArr lastObject];
//        if (page == com.ar_id) {
//            page = 0;
//        }else {
            page = com.ar_id;
//        }
        
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakself.tableView.mj_footer endRefreshing];
    }];
 }





#pragma mark - Table view data source


//设置cell的分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _recArr.count;

}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _recArr[indexPath.row];
    
    if (recommend.ar_type == 1)
    {
        return  [ZMDNNoPicTableViewCell heightForCell:recommend];
    }
    else if (recommend.ar_type == 2)
    {
        return 110;
    }
    else if (recommend.ar_type == 3)
    {
        return 170;
    }
    
    else if (recommend.ar_type == 6)
    {
        return 90;
    }

    return 275;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _recArr[indexPath.row];
   
    
    if (recommend.ar_type == 1)
    {
        return  [ZMDNNoPicTableViewCell heightForCell:recommend];
    }
    else if (recommend.ar_type == 2)
    {
        return 110;
    }
    else if (recommend.ar_type == 3)
    {
        return 170;
    }
    
    else if (recommend.ar_type == 6)
    {
        return 160*Kscaleh;
    }
    
    return 275;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZMDNRecommend *recommend  = _recArr[indexPath.row];
    
     
    
    if (recommend.ar_type == 1)
    {
        ZMDNNoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noPicCell"];
        cell.recommendModel = recommend;
         return cell;
    }
    else if (recommend.ar_type == 2)
    {
        OneXiaoPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"havPic"];
        
        picCell.recommendModel = recommend;
        
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return picCell;
    }
    else if (recommend.ar_type == 3)
    {
        ZMDNThreePicTableViewCell *threePicCell = [tableView dequeueReusableCellWithIdentifier:@"threePic"];
        threePicCell.recommendModel = recommend;
        threePicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return threePicCell;
    
    }
    else if (recommend.ar_type == 4)
        
    {
        MainMovieCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"movie"];
        adCell.recommendModel = recommend;
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell;
    }
    else if (recommend.ar_type == 6)
        
    {
        ZMDNAdTableViewCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"ad" forIndexPath:indexPath];
        adCell.recommendModel = recommend;
        if (indexPath.row == 0) {
            adCell.adlable.hidden = YES;
        }else {
            adCell.adlable.hidden = NO;
        }
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell;
    }
    
    
    ZMDNOneBigTableViewCell *bigPicCell = [tableView dequeueReusableCellWithIdentifier:@"bigpic"];
    bigPicCell.recommendModel = recommend;
    bigPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (recommend.ar_type == 0) {
        bigPicCell.pagelable.hidden = YES;
        bigPicCell.tutu.hidden = YES;
        bigPicCell.lab1.hidden = YES;
    }else {
        bigPicCell.pagelable.hidden = NO;
        bigPicCell.tutu.hidden = NO;
        bigPicCell.lab1.hidden = NO;
    }
    
    return  bigPicCell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _recArr[indexPath.row];
//    NSLog(@"===============%@",recommend.ar_title);
    NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%d&type=%d",recommend.id,recommend.ar_type];
   
    
    if (recommend.ar_type == 4)
    {
            if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
               
                [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:recommend.ar_title];
            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = recommend.ar_wl;
                wailian.titleename    = recommend.ar_title;
                [self presentViewController:na animated:YES completion:nil];
            }

        
    }
    
     else if (recommend.ar_type == 5)
     {
         if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
             ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
             picContentVc.manyPicLink = htmlUrl;
             picContentVc.sharetitle  = recommend.ar_title;
             picContentVc.picture     = recommend.ar_pic;

             
             
//             picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
             [self presentViewController:picContentVc animated:YES completion:nil];
         }else {
             WaiLianController *wailian = [[WaiLianController alloc]init];
             UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
             wailian.urlString = recommend.ar_wl;
             wailian.titleename    = recommend.ar_title;
             [self presentViewController:na animated:YES completion:nil];
         }
         
     }
    
     else if (recommend.ar_type == 6)
     {
         
         WaiLianController *zwfw = [[WaiLianController alloc]init];
         UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
         
    NSString *adid = [NSString stringWithFormat:@"%@?=",[Manager sharedManager].adIdString];
         //MD5加密
         const char *cstr = [adid UTF8String];
         unsigned char result[CC_MD5_DIGEST_LENGTH];
         unsigned long length = strlen(cstr);
         CC_MD5(cstr, (CC_LONG)length, result);
         NSMutableString *md5Str = [NSMutableString string];
         for (int i = 0;i < CC_MD5_DIGEST_LENGTH; i++) {
             [md5Str appendFormat:@"%02X",result[i]];
         }
         
     NSString *urls = [NSString stringWithFormat:@"%@&uuid=%@&key=%@",recommend.ar_wl,[Manager sharedManager].adIdString,[md5Str lowercaseString]];
         
         //zwfw.urlString = recommend.ar_wl;
         //Md5加密过的Url
         zwfw.urlString = [NSString stringWithFormat:@"%@",urls];
         zwfw.titleename = recommend.ar_title;
//         na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [self presentViewController:na animated:YES completion:nil];
         
     }
     else
     {
         if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
             NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
             UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
             if ([recommend.state isEqualToString:@"1"]) {
                 [Manager sharedManager].jinru = nil;
             }else {
                 [Manager sharedManager].jinru = @"jinruwebview";
             }             
             webCtrol.idString =[NSString stringWithFormat:@"%d",recommend.id];
             webCtrol.type =[NSString stringWithFormat:@"%d",recommend.ar_type];
             webCtrol.userpicture =[NSString stringWithFormat:@"%@",recommend.ar_userpic];
             webCtrol.titlee =[NSString stringWithFormat:@"%@",recommend.ar_title];
             webCtrol.time =[NSString stringWithFormat:@"%@",recommend.ar_time];
             webCtrol.author =[NSString stringWithFormat:@"%@",recommend.ar_ly];
             [self presentViewController:na animated:YES completion:nil];
             
//             WEBVIEWController *webCtrol = [[WEBVIEWController alloc] init];
//             [Manager sharedManager].jinru = @"jinruwebview";
//             
//             
//             webCtrol.type =[NSString stringWithFormat:@"%d",recommend.ar_type];
//             webCtrol.idString =[NSString stringWithFormat:@"%d",recommend.id];
//             webCtrol.ar_cateid =[NSString stringWithFormat:@"%@",recommend.ar_cateid];
//             webCtrol.userpicture = [NSString stringWithFormat:@"%@",recommend.ar_userpic];
//             webCtrol.title =[NSString stringWithFormat:@"%@",recommend.ar_title];
//             webCtrol.author =[NSString stringWithFormat:@"%@",recommend.ar_ly];
//             webCtrol.time =[NSString stringWithFormat:@"%@",recommend.ar_time];
//             
//             webCtrol.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//             [self presentViewController:webCtrol animated:YES completion:nil];
         }else {
             WaiLianController *wailian = [[WaiLianController alloc]init];
             UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
             wailian.urlString = recommend.ar_wl;
             wailian.titleename    = recommend.ar_title;
             [self presentViewController:na animated:YES completion:nil];
         }
         
     }
    
   
    
}


    


-(void)circulationView:(ImageCirculationView *)circulationView clickThePhotoWithTitle:(NSString *)title andUrl:(NSString *)url andInter:(NSInteger)type anid:(NSInteger)id andareid:(NSInteger)ar_id anduserpic:(NSString *)ar_userpic andwl:(NSString *)arwl andtime:(NSString *)time andcname:(NSString *)cname andpicture:(NSString *)picture andstate:(NSString *)state
{
    
    if (type == 4)
    {
        if ([arwl isEqual:[NSNull null]] || arwl == nil || [arwl isEqualToString:@""]) {
            [self loadTheMovieUrlWithMovieUrl:url withTitle:title];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = arwl;
            wailian.titleename    = title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
    }
    
    else if (type == 5)
    {
        if ([arwl isEqual:[NSNull null]] || arwl == nil || [arwl isEqualToString:@""]) {
            ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
            
            picContentVc.manyPicLink = url;
            picContentVc.sharetitle  = title;
            picContentVc.picture     = picture;
            
//            picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:picContentVc animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = arwl;
            wailian.titleename    = title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
    }
    else if (type == 6)
    {
        
        WaiLianController *zwfw = [[WaiLianController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
        zwfw.urlString   = arwl;
        zwfw.titleename = title;
        
//        na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:na animated:YES completion:nil];
        
    }
    
    
    else
    {
        
            if ([arwl isEqual:[NSNull null]] || arwl == nil || [arwl isEqualToString:@""]) {
                //WEBVIEWController
                NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
                if ([state isEqualToString:@"1"]){
                    [Manager sharedManager].jinru = nil;
                }else {
                    [Manager sharedManager].jinru = @"jinruwebview";
                }
                
                
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
                //        webCtrol.userpicture = [NSString stringWithFormat:@"%@",];
                
                webCtrol.userpicture =[NSString stringWithFormat:@"%@",ar_userpic];
                webCtrol.titlee =[NSString stringWithFormat:@"%@",title];
                webCtrol.time =[NSString stringWithFormat:@"%@",time];
                webCtrol.author =[NSString stringWithFormat:@"%@",cname];
                webCtrol.type =[NSString stringWithFormat:@"%ld",type];
                webCtrol.idString =[NSString stringWithFormat:@"%ld",id];
                webCtrol.ar_cateid =[NSString stringWithFormat:@"%ld",ar_id];
                
//                na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:na animated:YES completion:nil];
            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = arwl;
                wailian.titleename    = title;
                [self presentViewController:na animated:YES completion:nil];
            }
        
        
    }
    
    
//                    WaiLianController *wailian = [[WaiLianController alloc]init];
//                    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
//                    wailian.urlString = @"http://zmdtt.zmdtvw.cn/Public/test/topic.html?cateid=38";
//                    wailian.titlee    = title;
//                    [self presentViewController:na animated:YES completion:nil];

}



//请求视频链接
-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ZMDPlayerViewController *zmdPlayer = [[ZMDPlayerViewController alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakself = self;
    __weak typeof (zmdPlayer) weakPlayer =  zmdPlayer;
    
    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
          
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
         //NSLog(@"dianying shipin  %@",dic);
         
         
         zmdPlayer.string = [dic objectForKey:@"ar_title"];
         zmdPlayer.movieURL = [dic objectForKey:@"ar_movieurl"];
         zmdPlayer.ar_id = [dic objectForKey:@"ar_id"];
         zmdPlayer.clicknum = [dic objectForKey:@"ar_onclick"];
         zmdPlayer.ar_pic = [dic objectForKey:@"ar_pic"];
         zmdPlayer.timeString = [dic objectForKey:@"ar_time"];
         zmdPlayer.fabu = [dic objectForKey:@"ar_ly"];
         zmdPlayer.ar_cateid = [dic objectForKey:@"ar_cateid"];
         zmdPlayer.ar_type = [dic objectForKey:@"ar_type"];
         
        [Manager setupclicknum:[dic objectForKey:@"ar_type"] arid:[dic objectForKey:@"ar_id"]];
         
//         weakPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [weakself presentViewController:weakPlayer animated:YES completion:nil];
          [MBProgressHUD hideHUDForView:weakself.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
                        });
         
         //NSLog(@"%@",error);
     }];
    
    
}
//- (void)viewWillAppear:(BOOL)animated {
//    
//     [[Manager sharedManager] dingYueList];
//    
//    [[Manager sharedManager] lodCollectionList];
//}

@end
