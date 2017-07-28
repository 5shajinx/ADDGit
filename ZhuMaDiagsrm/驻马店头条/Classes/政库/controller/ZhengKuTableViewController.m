//
//  ZhengKuTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/3.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZhengKuTableViewController.h"

#import "ZKModel.h"
#import "ZKCell.h"

#import "ZKDetailsViewController.h"
#import "Manager.h"

static NSString *webCasher = @"Casher";

@interface ZhengKuTableViewController ()
{
    NSInteger currentpage;
}

@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)DataBaseManager *manager;
@property(nonatomic, strong)ZKModel *model;
@end

@implementation ZhengKuTableViewController
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray array];
    }
    return _array;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.title = @"政库";
//    
//    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnn.frame = CGRectMake(20, 20, 30, 30);
//    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
//    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//  UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
//    
//    self.navigationItem.leftBarButtonItem = bar;
//    
//    
    
    
    
    
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 44, ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [self.navigationController.navigationBar addSubview:line];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont  fontWithName:@"STHeitiSC-Light" size:20.0],
                                                                      NSForegroundColorAttributeName:[UIColor blackColor]}];
  
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZKCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getDataFromlocal];
    
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
          [self reflash];
    }
   
   
    
    
    
    
}
-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 250 + [Manager sharedManager].HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ZKModel *model = _array[indexPath.row];
    
//    if (indexPath.row != 0) {
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 5)];
//        lable.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//        [cell.contentView addSubview:lable];
//    }
    
    //[cell.picImg sd_setImageWithURL:[NSURL URLWithString:model.zk_photo]];
    [cell.picImg sd_setImageWithURL: [NSURL URLWithString:model.zk_photo] placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.picImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.picImg.clipsToBounds = YES;
    
    cell.nameLab.text = model.zk_name;
    cell.nameLab.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    
    cell.zhiweiLab.textAlignment = NSTextAlignmentCenter;
    cell.zhiweiLab.text = model.zk_job;
    cell.zhiweiLab.numberOfLines = 0;
    cell.zhiweiLab.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(320*Kscalew, 60*Kscalew);//labelsize的最大值
    //关键语句
    CGSize expectSize = [cell.zhiweiLab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    cell.zhiweiLab.frame = CGRectMake((ScreenW-320*Kscalew)/2, 120*Kscalew, expectSize.width, expectSize.height);
    [Manager sharedManager].HEIGHT = expectSize.height;
    cell.zhiweiLab.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:13.0];
    
    
//    [cell.gerenLvli addTarget:self action:@selector(gerenlvli:) forControlEvents:UIControlEventTouchUpInside];
//    cell.gerenLvli.tag      = indexPath.row;
    cell.gerenLvli.hidden = YES;
    
    [cell.xiangguanNews addTarget:self action:@selector(xiangguannews:) forControlEvents:UIControlEventTouchUpInside];
    cell.xiangguanNews.tag = indexPath.row;
    
    return cell;
}









- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZKDetailsViewController *zhengKuDetails = [[ZKDetailsViewController alloc]init];
    ZKModel *model = _array[indexPath.row];
    
    zhengKuDetails.imageStr = model.zk_photo;
    
    zhengKuDetails.nameStr  = model.zk_name;
    
    zhengKuDetails.jobStr   = model.zk_job;
    
    zhengKuDetails.idStr    = model.zk_id;
    
    self.tabBarController.tabBar.hidden = YES;
    
    [self.navigationController pushViewController:zhengKuDetails animated:YES];
}


- (void)gerenlvli:(UIButton *)sender {
    
    ZKDetailsViewController *zhengKuDetails = [[ZKDetailsViewController alloc]init];
    zhengKuDetails.isop = NO;
    ZKModel *model = _array[sender.tag];
    zhengKuDetails.imageStr = model.zk_photo;
    zhengKuDetails.nameStr  = model.zk_name;
    zhengKuDetails.jobStr   = model.zk_job;
    zhengKuDetails.idStr    = model.zk_id;
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:zhengKuDetails animated:YES];
    
}
- (void)xiangguannews:(UIButton *)sender {
    
    ZKDetailsViewController *zhengKuDetails = [[ZKDetailsViewController alloc]init];
    zhengKuDetails.isop = YES;
    ZKModel *model = _array[sender.tag];
    zhengKuDetails.imageStr = model.zk_photo;
    zhengKuDetails.nameStr  = model.zk_name;
    zhengKuDetails.jobStr   = model.zk_job;
    zhengKuDetails.idStr    = model.zk_id;
    
    
   // self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:zhengKuDetails animated:YES];
    
}



- (void)setUpTabBarItem {
    UITabBarItem *tabBarItem  = [[UITabBarItem alloc]initWithTitle:@"政库" image:[UIImage imageNamed:@"2"] selectedImage:[UIImage imageNamed:@"2"]];
    
    //tabBarItem.badgeValue = @"new";
    //tabBar自带渲染颜色，会将tabBarItem渲染成系统的蓝色，我们设置image的属性为原始状态即可；
    self.tabBarItem = tabBarItem;
    //调整图标的位置（上左下右），都是从边框的方向  指向图片为正值
    tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
   

}
- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
        [self setUpTabBarItem];
       
    }
    return self;
}



- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden =  YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden =  NO;

}



#pragma mark - 网络请求
- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:webCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadTitiles];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
//        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//        });
        
    });
}
-(void)loadTitiles
{
    //[MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"zk_id":@"0"};
     [session GET:zkurl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSMutableArray *arrara = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
         NSArray *arr = [weakSelf comparearr:arrara];
         
         
//         NSMutableArray *arr = [[[arrar reverseObjectEnumerator] allObjects] mutableCopy];
         
         //本地取数据
         dispatch_async(dispatch_get_global_queue(0, 0), ^{
             NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
             NSString *filewebCaches = [file stringByAppendingPathComponent:webCasher];
             
             [arr writeToFile:filewebCaches atomically:YES];
         });
         
         [weakSelf hhhhhhhhhh:arr];
         
         [weakSelf.tableView reloadData];
         [weakSelf.tableView.mj_header endRefreshing];
         
         //[MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
}

- (void)hhhhhhhhhh:(id)arr{
    
    self.array = [ZKModel mj_objectArrayWithKeyValuesArray:arr];
    
    ZKModel *model =  [self.array lastObject];
    currentpage = [model.zk_id integerValue];
   
}


//刷新数据
-(void)reflash
{
    
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadzk];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if ([Manager sharedManager].page != 0) {
            [weakSelf loadMorezk];
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
    
}




-(void)loadzk
{
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *par = @{@"zk_id":@"0"};
    [session GET:zkurl parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arrara = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
       NSArray *arr = [weakSelf comparearr:arrara];
        
        weakSelf.array = [ZKModel mj_objectArrayWithKeyValuesArray:arr];
        
        ZKModel *model =  [[ZKModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        currentpage = [model.zk_id integerValue];

        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)loadMorezk
{
   
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
     NSDictionary *par = @{@"zk_id":[NSString stringWithFormat:@"%ld",currentpage]};
     [session GET:zkurl parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arrara = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];

         
        NSArray *arr = [weakSelf comparearr:arrara];
        
        NSMutableArray *arrar = [ZKModel mj_objectArrayWithKeyValuesArray:arr];
        for (ZKModel *model in arrar) {
            [weakSelf.array addObject:model];
        }
         
        ZKModel *model =  [[ZKModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
         
        currentpage = [model.zk_id integerValue];
         
         
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

//对复杂对象数组排序
- (NSArray *)comparearr:(NSMutableArray *)arr {
   
    NSArray *newResult = [arr sortedArrayUsingComparator:^(id obj1,id obj2)
     {
         NSDictionary *dic1 = (NSDictionary *)obj1;
         NSDictionary *dic2 = (NSDictionary *)obj2;
         NSString *num1 = (NSString *)[dic1 objectForKey:@"zk_myorder"];
         NSString *num2 = (NSString *)[dic2 objectForKey:@"zk_myorder"];
         if ([num1 integerValue] < [num2 integerValue])
         {
             return (NSComparisonResult)NSOrderedAscending;
         }
         else
         {
             return (NSComparisonResult)NSOrderedDescending;
         }
         return (NSComparisonResult)NSOrderedSame;
     }];
    return newResult;
}







@end


