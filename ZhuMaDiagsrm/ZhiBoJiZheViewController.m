//
//  ZhiBoJiZheViewController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/10.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "ZhiBoJiZheViewController.h"
#import "TwoCell.h"
#import "TwoModel.h"
#import "AddJournalistController.h"
#import "PrefixHeader.pch"
#import "UITableViewRowAction+JZExtension.h"
@interface ZhiBoJiZheViewController ()
{
    NSInteger page;
}
@property(nonatomic, strong)NSMutableArray *array;

@end

@implementation ZhiBoJiZheViewController


- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (void)setupbutton {
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.rightBarButtonItem = bar;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"记者列表";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    [self setupbutton];
    
    [self lodjizhelist];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = vie;
    
    
    //[self setUpReflash];
}

- (void)leftClickAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)rightClickAction {
    AddJournalistController *add = [[AddJournalistController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
    [Manager sharedManager].edit = nil;
    [self presentViewController:na animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    TwoModel *model = [self.array objectAtIndex:indexPath.row];
    
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.cornerRadius = 45/2;
    
    cell.zhuchiren.layer.masksToBounds = YES;
    cell.zhuchiren.layer.cornerRadius = 5;
    
    //[cell.userImage sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    
    [cell.userImage sd_setImageWithURL: [NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"30"]];
    cell.userName.text  = model.hostname;
    cell.zhuchiren.text = model.typename;
   
    return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoModel *model = [self.array objectAtIndex:indexPath.row];
    
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        AddJournalistController *add = [[AddJournalistController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
        [Manager sharedManager].edit = @"编辑";
        add.xingming = model.hostname;
        add.miaoshu  = model.depict;
        add.shenfen  = model.typename;
        add.fengmian = model.photo;
        
        add.jizheid  = model.hostid;
        add.leixingid  = model.typeid;
        [self presentViewController:na animated:YES completion:nil];
        
    }];
    editRowAction.backgroundColor = [UIColor magentaColor];
    
    return @[editRowAction];
}


- (void)lodjizhelist {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

    __weak typeof(self) weakSelf = self;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=host&userid=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid];
//    NSLog(@"^^^^^^^^*****************^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//        NSLog(@"记者列表 *********** %@",dicc);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        //NSLog(@"&&&&&&&&&&& %@",arr);
        [weakSelf.array removeAllObjects];
        for (TwoModel *model in [TwoModel mj_objectArrayWithKeyValuesArray:arr]) {
            //NSLog(@"model == %@",model);
            [weakSelf.array addObject:model];
            //NSLog(@"jizhehahahaha === %@",model.photo);
        }
//        weakSelf.array = [TwoModel mj_objectArrayWithKeyValuesArray:arr];
//        TwoModel *model =  [[TwoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
//        page = [model.hostid integerValue];
        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
        [weakSelf.tableView reloadData];
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self lodjizhelist];
}


////刷新数据
//-(void)setUpReflash
//{
//    __weak typeof (self) weakSelf = self;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [weakSelf lodxiala];
//    }];
//    [self.tableView.mj_header beginRefreshing];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (page != 0) {
//            [weakSelf lodshangla];
//        }else {
//            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }
//    }];
//    
//}
////下拉刷新
//-(void)lodxiala
//{
//    [self.tableView.mj_footer endRefreshing];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    __weak typeof(self) weakSelf = self;
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-M-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSDate* date = [dateFormatter dateFromString:dateString];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
//    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=host&userid=%@&start=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid,@"0"];
//    //NSLog(@"^^^^^^^^*****************^^^^^^^^ %@",urlString);
//    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
//        NSError *err;
//        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//        //NSLog(@"*********** %@",dicc);
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
//        arr = [dicc objectForKey:@"data"];
//        //NSLog(@"&&&&&&&&&&& %@",arr);
////        [weakSelf.array removeAllObjects];
////        for (TwoModel *model in [TwoModel mj_objectArrayWithKeyValuesArray:arr]) {
////            //NSLog(@"model == %@",model);
////            [weakSelf.array addObject:model];
////            //NSLog(@"jizhehahahaha === %@",model.photo);
////        }
//        
//        
//        weakSelf.array = [TwoModel mj_objectArrayWithKeyValuesArray:arr];
//        TwoModel *model =  [[TwoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
//        page = [model.hostid integerValue];
//        
//        NSNumber *number = [dicc objectForKey:@"code"];
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        NSString *code = [numberFormatter stringFromNumber:number];
//        if ([code isEqualToString:@"0"] ) {
//        }
//        [weakSelf.tableView reloadData];
//        [weakSelf.tableView.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//    }];
//    
//    
//}
////上啦刷新
//-(void)lodshangla
//{
//    [self.tableView.mj_header endRefreshing];
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    __weak typeof(self) weakSelf = self;
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"YYYY-M-dd"];
//    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSDate* date = [dateFormatter dateFromString:dateString];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
//    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=host&userid=%@&start=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid,[NSString stringWithFormat:@"%ld",page]];
//    //NSLog(@"^^^^^^^^*****************^^^^^^^^ %@",urlString);
//    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
//        NSError *err;
//        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//        //NSLog(@"*********** %@",dicc);
//        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
//        arr = [dicc objectForKey:@"data"];
//        //NSLog(@"&&&&&&&&&&& %@",arr);
////        [weakSelf.array removeAllObjects];
//        for (TwoModel *model in [TwoModel mj_objectArrayWithKeyValuesArray:arr]) {
//            //NSLog(@"model == %@",model);
//            [weakSelf.array addObject:model];
//            //NSLog(@"jizhehahahaha === %@",model.photo);
//        }
//        TwoModel *model =  [[TwoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
//        
//        if (page == [model.hostid integerValue]) {
//            page = 0;
//        }else {
//            page = [model.hostid integerValue];
//        }
//        
//        
//        
//        
//        
//        
//        NSNumber *number = [dicc objectForKey:@"code"];
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        NSString *code = [numberFormatter stringFromNumber:number];
//        if ([code isEqualToString:@"0"] ) {
//        }
//        [weakSelf.tableView reloadData];
//        [self.tableView.mj_footer endRefreshing];
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
//    }];
//
//    
//}
//


@end
