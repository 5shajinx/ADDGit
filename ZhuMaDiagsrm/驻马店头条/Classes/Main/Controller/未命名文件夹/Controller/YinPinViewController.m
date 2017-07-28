//
//  YinPinViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/24.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "YinPinViewController.h"
#import "GBModel.h"
#import "GBCell.h"


static NSString *guangboCasher = @"guangbo";

@interface YinPinViewController ()

@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)NSMutableArray *imaarray;
@end

@implementation YinPinViewController
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}
- (NSMutableArray *)imaarray {
    if (_imaarray == nil) {
        self.imaarray = [NSMutableArray arrayWithCapacity:1];
    }
    return _imaarray;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"FM";
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GBCell" bundle:nil] forCellReuseIdentifier:@"cell"];
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self getDataFromlocal];
    [self loadTitiles];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GBCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    GBModel *model = [self.array objectAtIndex:indexPath.row];
    
    //[cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.img]];
    
    [cell.imageview sd_setImageWithURL: [NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"hui"]];
    
    cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     GBModel *model = [self.array objectAtIndex:indexPath.row];
     WaiLianController *gb = [[WaiLianController alloc]init];
     gb.urlString = model.url;
     gb.titleename = @"广播";
     gb.qtfm = @"qtfm";
     UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:gb];
     [self presentViewController:na animated:YES completion:nil];
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:guangboCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadTitiles];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}


- (void)hhhhhhhhhh:(id)arr{
    self.array = [GBModel mj_objectArrayWithKeyValuesArray:arr];
}







-(void)loadTitiles
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/api/index/audio" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSMutableArray *arr = [dic objectForKey:@"data"];
        //NSLog(@"======%@",dic);
        [self hhhhhhhhhh:arr];
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@",error);
        
        
        
    }];
    
}





@end
