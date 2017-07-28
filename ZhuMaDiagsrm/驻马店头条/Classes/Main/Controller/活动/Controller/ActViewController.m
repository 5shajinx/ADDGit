//
//  ActViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/10.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ActViewController.h"
#import "ActTableViewCell.h"
#import "ActModel.h"
#import "actDetaileViewController.h"
static NSString *HuoDongString = @"Activedata";

@interface ActViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *page;
    NSString *string;
    NSString *timeSp;
    NSString *offset;
    NSString *maxpage;
}
@property(nonatomic, strong)UITableView *mytaleView;
@property(nonatomic, strong)NSMutableArray *dataSource;

@property(nonatomic, strong)NSString *urlStr;



@end

@implementation ActViewController
- (NSMutableArray *)dataSource{
    if (_dataSource == nil ) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"活动";
      
     UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
     btn.frame = CGRectMake(0, 0, 30, 30);
     [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
     [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
     UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
     self.navigationItem.leftBarButtonItem = bar;
    
    
    self.mytaleView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenW, ScreenH)];
    _mytaleView.delegate = self;
    _mytaleView.dataSource = self;
    [self.view addSubview:self.mytaleView];
    [self.mytaleView registerNib:[UINib nibWithNibName:@"ActTableViewCell" bundle:nil] forCellReuseIdentifier:@"ActTableViewCell"];
    //请求数据
   [self requestDate];
    //显示数据
   // [self getDataFromlocal];
    //刷新数据
   [self setUpReflash];

    // Do any additional setup after loading the view.
}
//返回
- (void)Back{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//网络请求
- (void)requestDate{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/api/Activity/index/page/0" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        self.urlStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]];
        
        NSMutableArray *arr = [dic objectForKey:@"list"];
        for (NSDictionary *dic in arr) {
            ActModel *model = [[ActModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.dataSource addObject:model];
            
        }
        
        if (arr.count != 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:HuoDongString];
                [arr writeToFile:filewebCaches atomically:YES];
            });
        }
        
       // [weakSelf getNoNilArr:arr];
        [weakSelf.mytaleView reloadData];
        //        NSLog(@"--------------%@",arr);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"error=%@",error);
    }];
    
}
- (void)getDataFromlocal {
    //从本地取数据
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:HuoDongString];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodxiala];
        }else {
            [self requestDate];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mytaleView reloadData];
        });
        
    });

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ActTableViewCell" forIndexPath:indexPath];
    ActModel *model = self.dataSource[indexPath.row];
    [cell showCellWithMode:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 255;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
   ActModel *model = self.dataSource[indexPath.row];

    
    NSString *url = [self.urlStr stringByAppendingString:[NSString stringWithFormat:@"%@",model.aid]];
    actDetaileViewController *actVC = [[actDetaileViewController alloc]init];
    actVC.URLString = [NSString stringWithFormat:@"%@", url];
    actVC.anameString = [NSString stringWithFormat:@"%@",model.aname];
    actVC.imageString = [NSString stringWithFormat:@"%@",model.apic];
    actVC.commidStr = [NSString stringWithFormat:@"%@",model.aid];
    self.tabBarController.tabBar.hidden = YES;
     
    [self.navigationController pushViewController:actVC animated:YES];
    
    
    
    
}




//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.mytaleView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodxiala];
    }];
    [self.mytaleView.mj_header beginRefreshing];
    self.mytaleView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if ([page intValue] <= [maxpage integerValue]) {
            [weakSelf lodshangla];
        }else {
            [self.mytaleView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }];
    
}
//下拉刷新
-(void)lodxiala
{
    ActModel *mode = [self.dataSource lastObject];
    page = [NSString stringWithFormat:@"%@",mode.aid];
    
    [self.mytaleView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSString *urlString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/index/page/%@",page];
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [[dicc objectForKey:@"data"] objectForKey:@"rows"];
        
        string = [[dicc objectForKey:@"data"] objectForKey:@"url"];
        offset = [[dicc objectForKey:@"data"] objectForKey:@"offset"];
        maxpage = [[dicc objectForKey:@"data"] objectForKey:@"maxpage"];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:HuoDongString];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        //[self getDataFromlocal];
       // [self liveHuanCun:arr];

        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
        
        [weakSelf.mytaleView reloadData];
        [weakSelf.mytaleView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];

}
- (void)liveHuanCun:(NSMutableArray *)arr {
    
    self.dataSource = [ActModel mj_objectArrayWithKeyValuesArray:arr];
    page = [NSString stringWithFormat:@"%d",2];
}
//上啦刷新
-(void)lodshangla
{
    ActModel *mode = [self.dataSource lastObject];
    page = [NSString stringWithFormat:@"%@",mode.aid];

    [self.mytaleView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    //NSLog(@"page == %ld",page);
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/index/page=%@",page];
    
    

    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"%@",dicc);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [[dicc objectForKey:@"data"] objectForKey:@"rows"];
        
        string = [[dicc objectForKey:@"data"] objectForKey:@"url"];
        offset = [[dicc objectForKey:@"data"] objectForKey:@"offset"];
        maxpage = [[dicc objectForKey:@"data"] objectForKey:@"maxpage"];
        
        for (ActModel *model in [ActModel mj_objectArrayWithKeyValuesArray:arr]) {
            [weakSelf.dataSource addObject:model];
        }

        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
        
        
        [weakSelf.mytaleView reloadData];
        [weakSelf.mytaleView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
