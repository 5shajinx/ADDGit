//
//  RTTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/23.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "RTTableViewController.h"


#import "RTCell.h"
#import "RTModel.h"

#import "DWAnswerController.h"
#import "MJRefreshBackStateFooter.h"

@interface RTTableViewController ()
{
    NSInteger page;
    NSInteger currentpage;
}
@property(nonatomic, strong)NSMutableArray *array;

@property(nonatomic, strong)MJRefreshBackStateFooter *foot;

@end

@implementation RTTableViewController

- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray array];
    }
    return _array;
}


- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.navigationItem.title = self.str;
    [self.tableView registerNib:[UINib nibWithNibName:@"RTCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    self.tableView.tableFooterView = view;
    
    //[self lodinformation];
    
    [self setUpReflash];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RTCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    RTModel *model = _array[indexPath.row];
    if ([model.reply isEqualToString:@"0"]) {
        cell.alab.text = @" [未回复]";
    }else {
        cell.alab.text = @" [已回复]";
    }
    
    cell.blab.text = model.title;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DWAnswerController *details = [[DWAnswerController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    RTModel *model = _array[indexPath.row];
    details.wenti = model.title;
    details.time = model.time;
    details.username = model.username;
    details.content = model.content;
    details.detID = model.id;
    details.reply = model.reply;
    [self presentViewController:na animated:YES completion:nil];
    

    
}


- (void)lodinformation {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.idid == nil) {
        dic = @{@"&start":@"0"};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
             //NSLog(@"%@",arr);
            weakSelf.array = [RTModel mj_objectArrayWithKeyValuesArray:arr];
            
            for (RTModel *model in weakSelf.array) {
                page = [model.id integerValue];
            }
            
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }else {
        dic = @{@"id":self.idid,@"start":@"0"};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
             //NSLog(@"*************     %@",arr);
            weakSelf.array = [RTModel mj_objectArrayWithKeyValuesArray:arr];
            
            for (RTModel *model in weakSelf.array) {
                page = [model.id integerValue];
            }
            
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }
    
    
    
}







//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMovievideos];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (page != 0) {
            [weakSelf loadMoreMovievideos];
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            
        }
    
        
    }];
}


//下拉刷新
-(void)loadMovievideos
{
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    //NSLog(@"-------745675---------%@",[Manager sharedManager].cateid);
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.idid == nil) {
        dic = @{@"start":@"0"};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
             //NSLog(@"%@",arr);
            weakSelf.array = [RTModel mj_objectArrayWithKeyValuesArray:arr];
            
            
           
                 //NSLog(@"* %ld",page);
                page = weakSelf.array.count;
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }else {
        dic = @{@"id":self.idid,@"start":@"0"};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
            // NSLog(@"********************************       %@",arr);
            weakSelf.array = [RTModel mj_objectArrayWithKeyValuesArray:arr];
            
            
                page = weakSelf.array.count;
                //NSLog(@"**************%ld",page);
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }
    
    
    
}

/**
 *  上啦刷新
 */
-(void)loadMoreMovievideos
{
   
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    currentpage = page;
    
    //NSLog(@"wai---%ld",page);
    
    NSDictionary *dic = [NSDictionary dictionary];
    if (self.idid == nil) {
        dic = @{@"start":[NSString stringWithFormat:@"%ld",currentpage]};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
            //NSLog(@"1111------%@",arr);
            
            for (RTModel *model in [RTModel mj_objectArrayWithKeyValuesArray:arr]) {
                [weakSelf.array addObject:model];
             }
            
            
            
            if (page == weakSelf.array.count) {
                page = 0;
            }else {
                page = weakSelf.array.count;
            }
            
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }else {
        //dic = @{@"id":self.idid,@"start":[NSString stringWithFormat:@"%ld",currentpage]};
        
        NSString *url = [NSString stringWithFormat:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&id=%@&status=1&count=15&start=%ld",self.idid,currentpage];
        
        [session GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
            //NSLog(@"**************** %@",arr);
            for (RTModel *model in [RTModel mj_objectArrayWithKeyValuesArray:arr]) {
                [weakSelf.array addObject:model];
               
            }
            
            if (page == weakSelf.array.count) {
                page = 0;
            }else {
                page = weakSelf.array.count;
            }
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];
    }
    
}








- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
@end
