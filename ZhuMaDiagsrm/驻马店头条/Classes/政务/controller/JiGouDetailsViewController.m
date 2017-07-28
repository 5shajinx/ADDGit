//
//  JiGouDetailsViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "JiGouDetailsViewController.h"

#import "ZWOneCell.h"
#import "ZWTwoCell.h"

#import "RDModel.h"
#import "NewsDetailsTableviewController.h"
#import "WEBVIEWController.h"

@interface JiGouDetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
     NSInteger xwcIndex;
     NSInteger currentPage;
     NSInteger page;
    NSInteger jglbfbheight;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataarr;


@end

@implementation JiGouDetailsViewController
- (NSMutableArray *)dataarr {
    if (_dataarr == nil) {
        self.dataarr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self addTableView];
    
    [self setUpReflash];
}

- (void)Back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    xwcIndex = [_text integerValue];
    //[self lodList];
}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
   
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 13*Kscaleh, ScreenW, ScreenH-50) style:UITableViewStyleGrouped];
    tableView.delegate   = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    _tableView = tableView;
    [tableView registerNib:[UINib nibWithNibName:@"ZWOneCell" bundle:nil] forCellReuseIdentifier:@"onecell"];
    
    [tableView registerNib:[UINib nibWithNibName:@"ZWTwoCell" bundle:nil] forCellReuseIdentifier:@"twocell"];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.tableView.tableFooterView = view;
    
}

- (void)addHorHeaderScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 200)];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(2*CGRectGetWidth(self.view.frame), 0);
    [self.view addSubview:scrollView];
    
    UIView *page1View = [[UIView alloc]initWithFrame:scrollView.bounds];
    page1View.backgroundColor = [UIColor orangeColor];
    [scrollView addSubview:page1View];
    UIView *page2View = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame), 0, CGRectGetWidth(self.view.frame), 200)];
    page2View.backgroundColor = [UIColor redColor];
    [scrollView addSubview:page2View];
    
    _tableView.tableHeaderView = scrollView;
}

#pragma mark - delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    
    RDModel *model = [self.dataarr objectAtIndex:indexPath.row];
   
//     || [model.ar_pic isEqual:[NSNull null]]
//    if ([model.ar_pic isEqualToString:@""]) {
//        ZWTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell"];
//        cell.lableTwo.text = model.ar_title;
//        cell.lableTwo.numberOfLines = 0;
//        cell.lableTwo.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
    
    if ([model.ar_pic isEqual:[NSNull null]] || [model.ar_pic isEqualToString:@""] || model.ar_pic == nil) {
        ZWTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell" forIndexPath:indexPath];
        cell.lableTwo.text = model.ar_title;        
        cell.lableTwo.numberOfLines = 0;
        cell.lableTwo.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGSize maximumLabelSize = CGSizeMake(ScreenW-20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [cell.lableTwo sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        cell.lableTwo.frame = CGRectMake(10, 10, ScreenW-20, expectSize.height);
        jglbfbheight = expectSize.height;
        cell.timelable.text = [Manager othertimeWithTimeIntervalString:model.ar_time];
        cell.oncliclable.text = [NSString stringWithFormat:@"评论量:%@",model.ar_volume];
        return cell;
    }
   
        ZWOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell" forIndexPath:indexPath];
        //[cell.imageviewOne sd_setImageWithURL:[NSURL URLWithString:model.ar_pic]];
        [cell.imageviewOne sd_setImageWithURL:[NSURL URLWithString:model.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
        cell.imageviewOne.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageviewOne.clipsToBounds = YES;
        cell.lableOne.text = model.ar_title;
        cell.lableOne.numberOfLines = 0;
        cell.lableOne.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.timelable.text = [Manager othertimeWithTimeIntervalString:model.ar_time];
        cell.onclicklab.text = [NSString stringWithFormat:@"评论量:%@",model.ar_volume];
    
        return cell;
    
//    return cell;
}


- (void)viewWillDisappear:(BOOL)animated {
   
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RDModel *model = [self.dataarr objectAtIndex:indexPath.row];
    
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            //WEBVIEWController
            NewsDetailsTableviewController *webview = [[NewsDetailsTableviewController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webview];
            [Manager sharedManager].jinru = nil;
            webview.idString = model.ar_id;
            
            webview.titlee  = [NSString stringWithFormat:@"%@",model.ar_title];
            webview.time   = [NSString stringWithFormat:@"%@",model.ar_time];
            webview.onclick   = [NSString stringWithFormat:@"%@",model.ar_onclick];
//            na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:na animated:YES completion:nil];
  
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     RDModel *model = [self.dataarr objectAtIndex:indexPath.row];
    if ([model.ar_pic isEqual:[NSNull null]] || [model.ar_pic isEqualToString:@""] || model.ar_pic == nil) {
        return jglbfbheight + 52;
    }else {
        return 105 ;
    }
    return 0;
}



- (void)lodList{
    [self.tableView.mj_footer endRefreshing];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    currentPage  = 0;
    NSMutableArray *arrayid = [Manager sharedManager].xwcid;

    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/colnews/xwcid/%@/ar_id/%ld",arrayid[xwcIndex],currentPage];
    
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"===========%@",arr);
        
        NSMutableArray *aaaa = [NSMutableArray arrayWithCapacity:1];
        for (RDModel *model in [RDModel mj_objectArrayWithKeyValuesArray:arr]) {
            [aaaa addObject:model];
        }
        
        weakSelf.dataarr = aaaa;

        
        RDModel *model =  [[RDModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        page = [model.ar_id integerValue];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        //NSLog(@"%@",error);
    }];
    
    
    
}
    

//刷新数据
-(void)setUpReflash
{
    
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf lodList];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (page != 0) {
            [weakSelf loadMorenews];
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
    
}



////下拉刷新
//-(void)loadnews
//{
//    [self.tableView.mj_footer endRefreshing];
//    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    currentPage  = 0;
//    NSMutableArray *arrayid = [Manager sharedManager].xwcid;
//    
//    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/colnews/xwcid/%@/ar_id/%ld",arrayid[xwcIndex],currentPage];
//    __weak typeof(self) weakSelf = self;
//    [session GET:DTURL parameters:str progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
//        NSError *err;
//        NSArray *arrr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//        
//       NSMutableArray *arrAA = [[[arrr reverseObjectEnumerator] allObjects] mutableCopy];
//        
//        weakSelf.arr = [RDModel mj_objectArrayWithKeyValuesArray:arrAA];
//        
//        RDModel *model =  [[RDModel mj_objectArrayWithKeyValuesArray:arrAA] lastObject];
//        page = [model.ar_id integerValue];
//        
//        [weakSelf.tableView reloadData];
//        [weakSelf.tableView.mj_header endRefreshing];
//        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
//    }];
//}

/**
 *  上啦刷新
 */
-(void)loadMorenews
{
    
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    currentPage = page;
     __weak typeof(self) weakSelf = self;
    NSMutableArray *arrayid = [Manager sharedManager].xwcid;
    if (arrayid != nil ) {
        NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/colnews/xwcid/%@/ar_id/%ld",arrayid[xwcIndex],page];
        [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
           
           
            
            NSMutableArray *arrar = [NSMutableArray arrayWithCapacity:1];
            arrar = [RDModel mj_objectArrayWithKeyValuesArray:arr];
            for (RDModel *model in arrar) {
                [weakSelf.dataarr addObject:model];
            }
            
            RDModel *model =  [arrar lastObject];
            
            if (currentPage == page) {
                page = 0;
            }else {
                page = [model.ar_id integerValue];
            }
            
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        }];

    }
    
    
}



@end
