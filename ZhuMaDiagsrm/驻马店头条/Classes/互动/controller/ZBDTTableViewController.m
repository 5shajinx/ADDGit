//
//  ZBDTTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/18.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZBDTTableViewController.h"
#import "ZHIBOCell.h"
#import "TouTiaoZhiBoModel.h"
#import "ZBDTDetailsTableViewController.h"
#import "MBProgressHUD.h"
static NSString *zhiboString = @"ZhiBoChasa";

@interface ZBDTTableViewController ()
{
    NSInteger page;
    NSString *string;
    NSString *timeSp;
    NSString *offset;
    NSString *maxpage;
}
@property(nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation ZBDTTableViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZHIBOCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
    self.tableView.tableFooterView = vie;
    
    [self getDataFromlocal];
    [self setUpReflash];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHIBOCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    TouTiaoZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.topimage]];
    [cell.imageview sd_setImageWithURL: [NSURL URLWithString:model.topimage] placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageview.clipsToBounds = YES;
    cell.titlelable.text = [NSString stringWithFormat:@"  %@",model.title];
    cell.titlelable.textColor = [UIColor blackColor];
    cell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];

   
    
    if ([timeSp integerValue] <= [model.endtime integerValue]) {
        cell.xiaolable.text = @"进行中";
        cell.xiaolable.backgroundColor = [UIColor redColor];
    }
    else
    {
        cell.xiaolable.text = @"已结束";
        cell.xiaolable.backgroundColor = [UIColor lightGrayColor];
    }
    
    cell.xiaolable.layer.masksToBounds = YES;
    cell.xiaolable.layer.cornerRadius = 3;
    
    
    NSString *year = [[Manager timeWithTimeIntervalString:model.starttime] substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [[Manager timeWithTimeIntervalString:model.starttime] substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [[Manager timeWithTimeIntervalString:model.starttime] substringWithRange:NSMakeRange(8, 2)];
    
    cell.dalable.text = [NSString stringWithFormat:@"%@\n%@月%@日",year,month,day];
    
    
    cell.dalable.numberOfLines = 0;
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TouTiaoZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    ZBDTDetailsTableViewController *details = [[ZBDTDetailsTableViewController alloc]init];
    details.urlstring = string;
    details.idtring   = model.zb_id;
    
    details.imageString = model.topimage;
    details.titleString = model.title;
    
    
    details.ShareTuBiaoUrlStr = model.photo;
    
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:details animated:YES];
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:zhiboString];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodxiala];
        }else {
            [self liveHuanCun:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}
- (void)liveHuanCun:(NSMutableArray *)arr {
    
    self.dataArray = [TouTiaoZhiBoModel mj_objectArrayWithKeyValuesArray:arr];
    page = 2;
}





//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf lodxiala];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        if (page <= [maxpage integerValue]) {
            [weakSelf lodshangla];
        }else {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        
    }];
    
}
//下拉刷新
-(void)lodxiala
{
    [self.tableView.mj_footer endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"1" forKey:@"type"];
    
    NSString *urlString = @"http://zmdtt.zmdtvw.cn/index.php/api/index/zb?page=1";
    [session GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
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
            NSString *filewebCaches = [file stringByAppendingPathComponent:zhiboString];
            [arr writeToFile:filewebCaches atomically:YES];
        });
       //
        [self liveHuanCun:arr];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}
//上啦刷新
-(void)lodshangla
{
    [self.tableView.mj_header endRefreshing];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    //NSLog(@"page == %ld",page);
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/api/index/zb?page=%ld",page];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:@"0" forKey:@"type"];

    [session GET:urlString parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        
        for (TouTiaoZhiBoModel *model in [TouTiaoZhiBoModel mj_objectArrayWithKeyValuesArray:arr]) {
            [weakSelf.dataArray addObject:model];
        }
        
        page++;
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
        
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
       
    }];
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}

@end
