//
//  ZMDDSViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/3/23.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDDSViewController.h"
#import "NewNetWorkManager.h"
#import "TVModel.h"
#import "TVTableViewCell.h"
#import "ZMDDSNewTableViewCell.h"
//电视
@interface ZMDDSViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mytableView;
@property (nonatomic, strong)NSMutableArray *dateSource;


@end

@implementation ZMDDSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.view.backgroundColor = [UIColor colorWithRed:214/255 green:214/255 blue:214/255 alpha:1];
    
    self.mytableView = [[UITableView alloc]init];
    self.mytableView.frame = self.view.frame;
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    [self.view addSubview:_mytableView];
    self.dateSource = [NSMutableArray arrayWithCapacity:1];
    
    [self.mytableView registerNib:[UINib nibWithNibName:@"TVTableViewCell" bundle:nil] forCellReuseIdentifier:@"TVTableViewCell"];
    
    //新cell
    [self.mytableView registerNib:[UINib nibWithNibName:@"ZMDDSNewTableViewCell" bundle:nil] forCellReuseIdentifier:@"newZMDDSNewTableViewCell"];
    
    
    self.mytableView.tableFooterView = [[UIView alloc]init];
    self.mytableView.scrollEnabled = NO;
    
    //self.mytableView.userInteractionEnabled = NO;
    //数据请求
    [self requestdate];



//    // 下拉刷新
//    self.mytableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//        [self xialashuaxin];
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            // 结束刷新
//            [self.mytableView.mj_header endRefreshing];
//        });
//        
//        
//    }];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//    });
//    // 上拉刷新
//    self.mytableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self shanglashuaxin];//上拉刷新
//        
//        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
//         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 结束刷新
//            [self.mytableView.mj_footer endRefreshing];
//        });
//    }];


}
//下拉刷新
- (void)xialashuaxin{
    
}
//上拉刷新
- (void)shanglashuaxin{
    
}
//数据请求
- (void)requestdate{
    [NewNetWorkManager requestGETWithURLStr:@"http://zmdtt.zmdtvw.cn/api/index/vedioshow" parDic:nil finish:^(id resonbject) {
        NSString * str= [NSString stringWithFormat:@"%@",[resonbject objectForKey:@"code"]];
        if ([str isEqualToString:@"0"]) {
            NSArray *arr = [resonbject objectForKey:@"data"];
            
        for (NSDictionary *dic in arr) {
        TVModel *model = [[TVModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
                
                [self.dateSource addObject:model];
                
            }
            
            [self.mytableView reloadData];
            
        }
    } conError:^(NSError *error) {
        NSLog(@"数据请求失败");
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dateSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
//    TVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TVTableViewCell" forIndexPath:indexPath];
//    TVModel *model = self.dateSource[indexPath.row];
//    
//    [cell mycellShowDateWithModel:model];
    
    ZMDDSNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newZMDDSNewTableViewCell" forIndexPath:indexPath];
       TVModel *model = self.dateSource[indexPath.row];
       [cell showdetilewithModel:model];

    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (ScreenH - 130)/3 ;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"该功能暂未开放" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addAction:actionsure1];
    [self presentViewController:alertVC animated:YES completion:nil];
    

    
}

@end
