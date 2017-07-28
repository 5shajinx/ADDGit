//
//  BuMenTwoTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/23.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "BuMenTwoTableViewController.h"
#import "RTTableViewController.h"
#import "BMLBModel.h"

@interface BuMenTwoTableViewController ()
@property(nonatomic, strong)NSMutableArray *arr;


@end

@implementation BuMenTwoTableViewController
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIView *downview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30*Kscaleh)];
    self.tableView.tableFooterView = downview;
    
     [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    [self req];
    

    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    BMLBModel *model = _arr[indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"  %@(%@)",model.title,model.total];
    cell.textLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:17.0];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RTTableViewController *rt = [[RTTableViewController alloc]init];
    BMLBModel *model = _arr[indexPath.row];
    rt.idid = model.id;
     rt.str = model.title;
    [self.navigationController pushViewController:rt animated:YES];
}



- (void)req {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    //NSDictionary *par = @{@"&cateid":@"49"};
    [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_list&cateid=49" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSMutableArray *arr = [dic objectForKey:@"items"];
        
        weakSelf.arr = [BMLBModel mj_objectArrayWithKeyValuesArray:arr];
        [weakSelf.tableView reloadData];
          [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    }];
    
}





- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}
@end
