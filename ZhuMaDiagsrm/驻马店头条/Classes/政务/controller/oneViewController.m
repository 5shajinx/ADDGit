//
//  oneViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/17.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "oneViewController.h"
#import "FBDTModel.h"

#import "FBDTCell.h"
#import "FBDTNewModel.h"

#import "WEBVIEWController.h"
#import "fabudatingCell.h"
#import "ImageView.h"

#import "NewsDetailsTableviewController.h"


static NSString *FBDTwebCasher = @"FaBuCasher";

#define num self.dataArray.count

@interface oneViewController ()<clickfbdtpic>
{
    NSInteger page;
    CGFloat zwfbheight;
}

@property(nonatomic, strong)NSMutableArray *dataArray;



@property(nonatomic, strong)NSMutableArray *newsDataArray;


@end

@implementation oneViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.newsDataArray = [NSMutableArray arrayWithCapacity:1];
   
    ImageView *circulationView = [[ImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 250*Kscaleh)];
    circulationView.clickDelege = self;
    self.tableView.tableHeaderView = circulationView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FBDTCell" bundle:nil] forCellReuseIdentifier:@"fbdtcell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"fabudatingCell" bundle:nil] forCellReuseIdentifier:@"fabudatingcell"];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    self.tableView.tableFooterView = vie;
    [self getDataFromlocal];
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
//        [self lodnews];
        [self setUpReflash];
    }
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    FBDTNewModel *recommendModel = [self.newsDataArray objectAtIndex:indexPath.row];
    //NSLog(@"----------------------%@",recommendModel.ar_pic);
    if ([recommendModel.ar_pic isEqualToString:@""] || [recommendModel.ar_pic isEqual:[NSNull null]]  || recommendModel.ar_pic == nil) {
         fabudatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fabudatingcell" forIndexPath:indexPath];
        cell.titlelable.text = recommendModel.ar_title;
        cell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        cell.titlelable.numberOfLines = 0;
        cell.titlelable.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(ScreenW-20, 150);//labelsize的最大值
        //关键语句
        CGSize expectSize = [cell.titlelable sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        cell.titlelable.frame = CGRectMake(10, 5, ScreenW-20, expectSize.height);
        zwfbheight = expectSize.height;
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.userimg sd_setImageWithURL:[NSURL URLWithString:recommendModel.dwlogo] placeholderImage:[UIImage imageNamed:@"hui"]];
        cell.userimg.layer.masksToBounds = YES;
        cell.userimg.layer.cornerRadius = 10;
        cell.timelable.text   = recommendModel.dwname;
        cell.sourcelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.ar_time];
        return cell;
    }else {
        FBDTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fbdtcell" forIndexPath:indexPath];
        cell.titlelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.ar_time];
        //[cell.imageview sd_setImageWithURL:[NSURL URLWithString:recommendModel.ar_pic]];
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:recommendModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
        cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageview.clipsToBounds = YES;
        cell.contentlable.text = recommendModel.ar_title;
        cell.contentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        cell.contentlable.numberOfLines = 0;
        cell.timelable.text = recommendModel.dwname;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    FBDTNewModel *model = [self.newsDataArray objectAtIndex:indexPath.row];
    
    if ([model.ar_pic isEqual:[NSNull null]] || [model.ar_pic isEqualToString:@""] || model.ar_pic == nil) {
        return 60 + zwfbheight;
     }
    return 120;
    
}


- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:FBDTwebCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //NSLog(@"%@",filewebCaches);
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodnews];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
//        });
        
    });
}

- (void)hhhhhhhhhh:(id)arr{
    
//    for (FBDTNewModel *model in [FBDTNewModel mj_objectArrayWithKeyValuesArray:arr]) {
//        [self.newsDataArray addObject:model];
//    }
    self.newsDataArray = [FBDTNewModel mj_objectArrayWithKeyValuesArray:arr];
    FBDTNewModel *model =  [[FBDTNewModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
    
    page = [model.ar_id integerValue];
    
}

- (void)lodnews {
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    page = 0;
    NSDictionary *dic = @{@"ar_id":[NSNumber numberWithInteger:page]};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/news/" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"arr ============   %@",arr);
        //本地取数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:FBDTwebCasher];
            
          
            
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhh:arr];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];

}




//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadxinwen];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (page == 0) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }else {
            [weakSelf loadMorexinwen];
        }
        
    }];
    
}
//下拉刷新
-(void)loadxinwen
{
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    page = 0;
    NSDictionary *dic = @{@"ar_id":[NSNumber numberWithInteger:page]};
    __weak typeof (self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/news/" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//        NSLog(@"==========%@",arr);
        weakSelf.newsDataArray = [FBDTNewModel mj_objectArrayWithKeyValuesArray:arr];
        
        FBDTNewModel *model =  [[FBDTNewModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        page = [model.ar_id integerValue];
//        NSLog(@"-----%ld-----%ld",page,[model.ar_id integerValue]);
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

// 上啦刷新

-(void)loadMorexinwen
{
    
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof (self) weakSelf = self;
    NSDictionary *par = @{@"ar_id":[NSNumber numberWithInteger:page]};
     [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/news/" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        array = [FBDTNewModel mj_objectArrayWithKeyValuesArray:arr];
        
        
        for (FBDTNewModel *model in array) {
            [weakSelf.newsDataArray addObject:model];
        }
         
        FBDTNewModel *model =  [[FBDTNewModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
//         NSLog(@"%ld-----%ld",page,[model.ar_id integerValue]);
//         if (page == [model.ar_id integerValue]) {
//             page = 0;
//         }else {
             page = [model.ar_id integerValue];
//         }
        
         
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     FBDTNewModel *model = [self.newsDataArray objectAtIndex:indexPath.row];
    
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            //WEBVIEWController
    NewsDetailsTableviewController *webview = [[NewsDetailsTableviewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webview];
    [Manager sharedManager].jinru = nil;
    webview.idString = model.ar_id;
    
    webview.titlee  = [NSString stringWithFormat:@"%@",model.ar_title];
    webview.author = [NSString stringWithFormat:@"%@",model.dwname];
    webview.time   = [NSString stringWithFormat:@"%@",model.ar_time];
            
//    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
           
            
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }

    
    
   
}



-(void)circulationView:(ImageView *)circulationView clickThePictureWithTitle:(NSString *)title andUrl:(NSString *)url andInter:(NSString *)arid andwl:(NSString *)arwl {
    
        if ([arwl isEqual:[NSNull null]] || arwl == nil || [arwl isEqualToString:@""]) {
    NewsDetailsTableviewController *webview = [[NewsDetailsTableviewController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webview];
    [Manager sharedManager].jinru = nil;
    webview.idString = arid;
    webview.titlee    = title;
            
//    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = arwl;
            wailian.titleename    = title;
            
            [self presentViewController:na animated:YES completion:nil];
        }
    
   
   
}





















@end
