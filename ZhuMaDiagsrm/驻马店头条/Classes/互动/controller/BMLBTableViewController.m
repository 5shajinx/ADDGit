//
//  BMLBTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/14.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "BMLBTableViewController.h"
#import "BMLBModel.h"
#import "BMLBCell.h"

#import "Manager.h"

@interface BMLBTableViewController ()
@property(nonatomic, strong)NSMutableArray *array;
@end

@implementation BMLBTableViewController
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"部门列表";
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BMLBCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self loadlists];
    
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30*Kscaleh)];
    self.tableView.tableFooterView = downview;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BMLBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BMLBModel *model = _array[indexPath.row];
    cell.titlab.text = model.title;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BMLBModel *model = _array[indexPath.row];
    
    [Manager sharedManager].bmlbid = model.id;
    [Manager sharedManager].bmlbtitle = model.title;
    
     
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadlists
{
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_list" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSMutableArray *arr = [dic objectForKey:@"items"];
        
        
       
        
        weakSelf.array = [BMLBModel mj_objectArrayWithKeyValuesArray:arr];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    }];
    
    
}














@end
