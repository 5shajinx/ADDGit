//
//  CityViewController
//  City
//
//  Created by strj on 15/12/7.
//  Copyright © 2015年 strj. All rights reserved.
//

#import "CityViewController.h"
#import "ZMDCityModel.h"

#import "ZMDNMainViewController.h"
#import "ZhengKuTableViewController.h"
//#define ScreenFrame [UIScreen mainScreen].bounds
#import "ZMDNNavViewController.h"
#import "Demo2ViewController.h"
#import "CustomPagerController.h"
#import "ZBDTTableViewController.h"
#import "hudongViewController.h"
#import "JRSegmentViewController.h"
#import "Manager.h"
#import <CoreLocation/CoreLocation.h>

static NSString *citycash = @"cityChase";

@interface CityViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
        CLLocationManager *_locationManager;
        CLGeocoder *_geocoder;
        NSString *currentVersion;
        
}

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *indexSource;
@property (nonatomic, strong) NSString *weizhi;
@property (nonatomic, strong) NSString *weizhiid;


@property (nonatomic,retain)NSDictionary *allKeysDict;
@end

@implementation CityViewController






- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}
- (NSMutableArray *)indexSource {
    if (_indexSource == nil) {
        self.indexSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _indexSource;
}

- (void)viewWillAppear:(BOOL)animated {
    [[Manager sharedManager] location];
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self initNav];
    [self initData];
    [self initTableView];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 31)];
    view1.backgroundColor = [UIColor lightGrayColor];
     _tableView.tableHeaderView = view1;
    
   UIView *vieww = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    vieww.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1];
    vieww.userInteractionEnabled = YES;
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
    imageview.image = [UIImage imageNamed:@"city"];
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;
    [vieww addSubview:imageview];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(35, 5, ScreenW-35, 20);
    [btn setTitle:@"自动定位地区" forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectedzone) forControlEvents:UIControlEventTouchUpInside];
    [vieww addSubview:btn];
    
    
      [view1 addSubview:vieww];
    [view1 bringSubviewToFront:vieww];

    
    
    
}
//自动定位
- (void)selectedzone{
    
   
    //[Manager sharedManager].locaton = NO;
    
    [self location];
}

/**
 *  定位
 */
+ (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}
-(void)location
{
    _locationManager = [[CLLocationManager alloc] init];
    
    
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        NSLog(@"44444444");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位服务没有打开，请设置打开" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate = self;
        [alertView show];
    }
    
    if (IPHONE8)
    {
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
        {
            
            [_locationManager requestWhenInUseAuthorization];
        }
        else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)
        {   _locationManager.delegate = self;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            CLLocationDistance distance = 100;
            _locationManager.distanceFilter = distance;
            [_locationManager startUpdatingLocation];
        }
    }
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;{
    
    
    if (buttonIndex == 0)
        
    {
        if (IPHONE8) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
        }
  
        
    }
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{  CLLocation *location =  [locations firstObject];
    _geocoder = [[CLGeocoder alloc] init];
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        [Manager sharedManager].locaton = YES;
        
        CLPlacemark *placeMark = [placemarks firstObject];
        NSString *positionStr = [NSString stringWithFormat:@"%@",placeMark.subLocality];
        //        positionStr = @"52452上蔡5345";
        
        
        NSInteger area_id;
        NSArray *townArr = @[@"驿城区",@"遂平",@"西平",@"上蔡",@"汝南",@"平舆",@"确山",@"正阳",@"泌阳"];
        
        if([positionStr containsString:townArr[1]])
        {
            positionStr = @"遂平";
            area_id = 3;
            
        }else if([positionStr containsString:townArr[2]])
        {
            positionStr = @"西平";
            area_id = 4;
            
        }else if([positionStr containsString:townArr[3]])
        {
            positionStr = @"上蔡";
            area_id = 5;
            
        }else if([positionStr containsString:townArr[4]])
        {
            positionStr = @"汝南";
            area_id = 6;
            
        }else if([positionStr containsString:townArr[5]])
        {
            positionStr = @"平舆";
            area_id = 7;
            
        }else if([positionStr containsString:townArr[6]])
        {
            positionStr = @"确山";
            area_id = 8;
            
        }
        else if([positionStr containsString:townArr[7]])
        {
            positionStr = @"正阳";
            area_id = 9;
            
        }else if([positionStr containsString:townArr[8]])
        {
            positionStr = @"泌阳";
            area_id = 11;
        }else {
            positionStr = @"驻马店";
            area_id = 2;
        }
        
        NSString *doucments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *text= [doucments stringByAppendingPathComponent:@"weizhi.text"];
        NSString *st = placeMark.name;
        [st writeToFile:text atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        
        //加载刷新数据
        [[NSUserDefaults standardUserDefaults] setObject:positionStr forKey:@"定位"];
        NSString *citiidstr = [NSString stringWithFormat:@"%ld",(long)area_id];
        
        [[NSUserDefaults standardUserDefaults] setObject:citiidstr forKey:@"定位id"];
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:positionStr,@"name",citiidstr,@"areaid",nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"city" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //创建通知
        NSNotification *tification =[NSNotification notificationWithName:@"city22" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:tification];
        

        
        //通知修改图的位置
        NSNotification *notificatio =[NSNotification notificationWithName:@"dingweicity" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notificatio];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }];
    
    [manager stopUpdatingLocation];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
   
    

    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"99999---%@",error);
}

-(void)initNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    //================================
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(18, 25, 35, 35);
    [closeBtn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63, ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [backView addSubview:line];
   
    //=================================
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"dangqianweizhi.text"];
    _weizhi = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, ScreenW-80, 25)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    if (width != 320){
        titleLabel.text = [NSString stringWithFormat:@"当前位置-%@",_weizhi];
    }
    [backView addSubview:titleLabel];
}

-(void)initTableView {
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
   _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.sectionIndexColor = [UIColor redColor];
    [self.view addSubview:_tableView];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    _tableView.tableFooterView = vie;
     
}


-(void)initData {
    [self getDataFromlocal];
    [self loadTitiles];
}

-(void)loadTitiles
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/index/area" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
//        NSLog(@"%@",arr);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:citycash];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhh:arr];
        [_tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}
- (void)hhhhhhhhhh:(id)arr{
    _dataSource = [ZMDCityModel mj_objectArrayWithKeyValuesArray:arr];
}

- (void)getDataFromlocal {
   
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:citycash];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadTitiles];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
//        });
        
    });
}





-(void)OnCloseBtn:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *cellIndentifier = @"cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZMDCityModel *model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",model.ar_name];
    
    return cell;
}



#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZMDCityModel *model = [self.dataSource objectAtIndex:indexPath.row];

    [[NSUserDefaults standardUserDefaults] setObject:model.ar_name forKey:@"定位"];
    [[NSUserDefaults standardUserDefaults] setObject:model.ar_areaid forKey:@"定位id"];

//    NSLog(@"%@---%@---%@",model.ar_name,model.ar_arid,model.ar_areaid);

    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:model.ar_name,@"name",model.ar_areaid,@"areaid",nil];
     //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"city" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    //创建通知
    NSNotification *tification =[NSNotification notificationWithName:@"city22" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:tification];
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
}



- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
