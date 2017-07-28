//
//  LiveContentViewController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/11.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "LiveContentViewController.h"
#import "AddAnswerViewController.h"
#import "PrefixHeader.pch"
#import "LiveContentModel.h"

#import "LiveNoCell.h"
#import "LiveOneCell.h"
#import "LiveTwoCell.h"
#import "LiveThreeCell.h"
#import "LiveForthCell.h"
#import "UMSocial.h"




#import "UITableViewRowAction+JZExtension.h"

#import "WebviewController.h"
@interface LiveContentViewController ()<PassValueDelegate>
{
    NSInteger page;
    NSInteger tagg;
    NSInteger inde;
    NSInteger total;
    
}


@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, strong)NSIndexPath *indexPath;

@end

@implementation LiveContentViewController
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupbutton {
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}


- (void)viewWillAppear:(BOOL)animated {
    [self setupbutton];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
       [self lodLiveContent];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //通知主线程刷新，
            [self.tableView reloadData];
        });
        
    });
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"直播详情";
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"you"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = bar1;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveNoCell" bundle:nil] forCellReuseIdentifier:@"nocell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveOneCell" bundle:nil] forCellReuseIdentifier:@"onecell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveTwoCell" bundle:nil] forCellReuseIdentifier:@"twocell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveThreeCell" bundle:nil] forCellReuseIdentifier:@"threecell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LiveForthCell" bundle:nil] forCellReuseIdentifier:@"forthcell"];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = vie;
     self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self lodLiveContent];
    [self setUpReflash];
    
}
- (void)rightClickAction {
    AddAnswerViewController *answer = [[AddAnswerViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:answer];
    [Manager sharedManager].zhuchiren = nil;
    [Manager sharedManager].biaoji = nil;
    [self presentViewController:na animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveContentModel *recommend  = _dataArray[indexPath.row];
    
    if (recommend.photo1 != nil && recommend.photo2 == nil) {
     return  [LiveOneCell heightForCell:recommend];
    }
    if (recommend.photo2 != nil && recommend.photo3 == nil) {
        return  [LiveTwoCell heightForCell:recommend];
    }
    if (recommend.photo3 != nil && recommend.photo4 == nil) {
        return  [LiveThreeCell heightForCell:recommend];
    }
    if (recommend.photo1 != nil && recommend.photo2 != nil && recommend.photo3 != nil && recommend.photo4 != nil) {
        return  [LiveForthCell heightForCell:recommend];
    }
    return  [LiveNoCell heightForCell:recommend];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (model.photo1 != nil && model.photo2 == nil) {
        LiveOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"onecell" forIndexPath:indexPath];
        cell.recommendModel = model;
        cell.delegated = self;
        //inde = indexPath.row;
        
        return cell;
    }
    if (model.photo2 != nil && model.photo3 == nil) {
        LiveTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twocell" forIndexPath:indexPath];
        cell.recommendModel = model;
        cell.delegated = self;
        //inde = indexPath.row;
        return cell;
    }
    if (model.photo3 != nil && model.photo4 == nil) {
        LiveThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threecell" forIndexPath:indexPath];
        cell.recommendModel = model;
        cell.delegated = self;
        //inde = indexPath.row;
        return cell;
    }
    if (model.photo1 != nil && model.photo2 != nil && model.photo3 != nil && model.photo4 != nil){
        LiveForthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forthcell" forIndexPath:indexPath];
        cell.delegated = self;
        //inde = indexPath.row;
        cell.recommendModel = model;
       
        return cell;
    }
    
     LiveNoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nocell" forIndexPath:indexPath];
     cell.recommendModel = model;
    
     cell.delegated = self;
  
     return cell;
}


































- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
                    LiveContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (model.videourl.length != 0) {
        WebviewController *webview = [[WebviewController alloc]init];
        webview.str = model.videourl;
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webview];
        [self presentViewController:na animated:YES completion:nil];
    }
    
   
//
//
//            [_player destroyPlayer];
//            _player = nil;
//            LiveContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
//             if (model.videourl != nil) {
//                 
//                _player = [[XLVideoPlayer alloc] init];
//                _player.videoUrl =  model.videourl;
//                [_player playerBindTableView:tableView currentIndexPath:_indexPath];
//                 
//                 _player.frame = CGRectMake(0, 64, ScreenW, 250);
//                 [self.tableView.superview addSubview:_player];
//                 [self.tableView.superview bringSubviewToFront:_player];
//                _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
//                    [player destroyPlayer];
//                    _player = nil;
//                };
//             }
    
    
    
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //NSLog(@"删除");
         [self loddeleteindexpath:indexPath];
    }];
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        LiveContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
        AddAnswerViewController *answer = [[AddAnswerViewController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:answer];
        
        answer.wenzi         = model.depict;
        answer.zhuchiren     = model.hostname;
        answer.wailian       = model.hrefer;
        answer.pic1          = model.photo1;
        answer.pic2          = model.photo2;
        answer.pic3          = model.photo3;
        answer.pic4          = model.photo4;
        
        answer.jizheid       = model.hostid;
        answer.zbcontentid   = model.zbxq_id;
        
        [Manager sharedManager].biaoji = @"editzbcontent";
        
        [self presentViewController:na animated:YES completion:nil];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    editRowAction.backgroundColor = [UIColor magentaColor];
    return @[deleteRowAction,editRowAction];
}

- (void)loddeleteindexpath:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

     __weak typeof(self) weakSelf = self;
    LiveContentModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    //NSLog(@"%ld",indexPath.row);
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=delivenr&zbxq_id=%@",[[Manager sharedManager] md5:single],model.zbxq_id];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"%@",dicc);
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.dataArray removeObject:model];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}









- (void)lodLiveContent {
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
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=livenr&zb_id=%@&start=%@",[[Manager sharedManager] md5:single],self.ZHIBOID,@"0"];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        total = [[dicc objectForKey:@"total"] integerValue];
        
        weakSelf.dataArray = [LiveContentModel mj_objectArrayWithKeyValuesArray:arr];
        
       
        
        LiveContentModel *model =  [[LiveContentModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        if (weakSelf.dataArray.count == total) {
            page = 0;
        }else {
            page = [model.zbxq_id integerValue];
        }
        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        
        if ([code isEqualToString:@"0"] ) {
            
        }
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
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
        if (page != 0) {
            [weakSelf lodshangla];
        }else {
            //[weakSelf lodshangla];
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
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=livenr&zb_id=%@&start=%@",[[Manager sharedManager] md5:single],self.ZHIBOID,@"0"];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
       //  NSLog(@"jiangyaochuxian---------%@",dicc);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
         total = [[dicc objectForKey:@"total"] integerValue];
        //[weakSelf.dataArray removeAllObjects];
//        for (LiveContentModel *model in [LiveContentModel mj_objectArrayWithKeyValuesArray:arr]) {
//            [weakSelf.dataArray addObject:model];
//        }
        weakSelf.dataArray = [LiveContentModel mj_objectArrayWithKeyValuesArray:arr];
        
        LiveContentModel *model =  [[LiveContentModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        if (weakSelf.dataArray.count == total) {
            page = 0;
        }else {
            page = [model.zbxq_id integerValue];
        }
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        //NSLog(@"%@",[dicc objectForKey:@"Message"]);
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
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=livenr&zb_id=%@&start=%@",[[Manager sharedManager] md5:single],self.ZHIBOID,[NSString stringWithFormat:@"%ld",page]];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        // NSLog(@"%@",dicc);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
         total = [[dicc objectForKey:@"total"] integerValue];
        
        //[weakSelf.dataArray removeAllObjects];
        
        for (LiveContentModel *model in [LiveContentModel mj_objectArrayWithKeyValuesArray:arr]) {
            [weakSelf.dataArray addObject:model];
        }
        LiveContentModel *model =  [[LiveContentModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        if (weakSelf.dataArray.count == total) {
            page = 0;
        }else {
            page = [model.zbxq_id integerValue];
        }
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        if ([code isEqualToString:@"0"] ) {
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}









@end
