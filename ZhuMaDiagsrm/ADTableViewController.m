//
//  ADTableViewController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/11.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "ADTableViewController.h"

#import "TwoCell.h"
#import "TwoModel.h"

@interface ADTableViewController ()

{
    NSInteger page;
}

@property(nonatomic, strong)NSMutableArray *array;
@end

@implementation ADTableViewController
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (void)leftClickAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播记者";
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = vie;
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self lodjizhelist];
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
    
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    cell.userName.text  = model.hostname;
    cell.zhuchiren.text = model.typename;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TwoModel *model = [self.array objectAtIndex:indexPath.row];
    
    [Manager sharedManager].zhuchiren   = model.hostname;
    
    [Manager sharedManager].zhuchirenid = model.hostid;
    
    [Manager sharedManager].jizheid     = model.hostid;
    [Manager sharedManager].editjizheidbiaoji     = @"editjizheidbiaoji";
//    [Manager sharedManager].biaoji = nil;
//    NSLog(@"ADTableViewController ==== %@--%@--%@",model.hostname,model.typeid,model.hostid);
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        
        [weakSelf.array removeAllObjects];
        
        
        for (TwoModel *model in [TwoModel mj_objectArrayWithKeyValuesArray:arr]) {
            [weakSelf.array addObject:model];
        }
        
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


















@end
