//
//  CenterViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/2/6.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "CenterViewController.h"
#import "SQMenuShowView.h"
#import "UMSocial.h"
#import "LiveContentViewController.h"
#import "AddLiveBroadcastController.h"
#import "ZhiBoModel.h"
#import "OneCell.h"
#import "ZhiBoJiZheViewController.h"
#import "AddJournalistController.h"
#import "UITableViewRowAction+JZExtension.h"
@interface CenterViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>
{
    NSInteger page;
    NSInteger tagg;
    NSInteger total;
}

@property(nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic,strong) ZhiBoJiZheViewController *courseTable;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property (strong, nonatomic)  UIButton *addbtn;
@property (strong, nonatomic)  SQMenuShowView *showView;
@property (assign, nonatomic)  BOOL  isShow;
@property (assign, nonatomic)  NSInteger  num;
@property (nonatomic, strong)  UITableView *tableView;



@end

@implementation CenterViewController
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 64, ScreenW, ScreenH);
    
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的直播";
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"分享-2"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = barbtn;
    
    self.addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addbtn.frame = CGRectMake(ScreenW-65, ScreenH-70, 50, 50);
    self.addbtn.backgroundColor = [UIColor orangeColor];
    [self.addbtn setImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    self.addbtn.layer.masksToBounds = YES;
    self.addbtn.layer.cornerRadius = 25;
    [self.addbtn addTarget:self action:@selector(addzhiboInformation) forControlEvents:UIControlEventTouchUpInside];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OneCell" bundle:nil] forCellReuseIdentifier:@"zhiboCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addbtn];
    [self.addbtn bringSubviewToFront:self.view];
    
    UIView *footvie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 10)];
    self.tableView.tableFooterView = footvie;
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.num = 0;
    __weak typeof(self) weakSelf = self;
    [self.showView selectBlock:^(SQMenuShowView *view, NSInteger index) {
        weakSelf.isShow = NO;
        if (index == 0) {
            [self setupbutton:index];
        }
    }];
    
    [self setUpReflash];
    
   
}

- (void)addzhiboInformation {
    AddLiveBroadcastController *add = [[AddLiveBroadcastController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
    [Manager sharedManager].zhuchirenid = nil;
    [Manager sharedManager].zhibobiaoji = nil;
    [Manager sharedManager].zhuchiren = nil;
    
    [self presentViewController:na animated:YES completion:nil];
}
- (void)setupbutton:(NSInteger )index{
    self.num = index;
    if (index == 0) {
        self.courseTable = [[ZhiBoJiZheViewController alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:self.courseTable];
        [self.navigationController presentViewController:navi animated:YES completion:nil];
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _isShow = NO;
    [self.showView dismissView];
}

- (SQMenuShowView *)showView{
    
    if (_showView) {
        return _showView;
    }
    
    _showView = [[SQMenuShowView alloc]initWithFrame:(CGRect){CGRectGetWidth(self.view.frame)-100-10,64+5,100,100}
                                               items:@[@"记者列表"]
                                           showPoint:(CGPoint){CGRectGetWidth(self.view.frame)-25,10}];
    _showView.sq_backGroundColor = [UIColor whiteColor];
    [self.view addSubview:_showView];
    return _showView;
}


- (void)show{
    _isShow = !_isShow;
    
    if (_isShow) {
        [self.showView showView];
        
    }else{
        [self.showView dismissView];
    }
    
}

#pragma mark  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
#pragma mark  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhiboCell"];
    ZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    //[cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    //NSLog(@"--------%@",model.title);
    [cell.imageview sd_setImageWithURL: [NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"50"]];
    cell.imageview.contentMode = UIViewContentModeRedraw;
    cell.titlelable.text = model.title;
    cell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    cell.contentlable.text = model.depict;
    cell.contentlable.numberOfLines = 0;
    cell.contentlable.textColor = [UIColor lightGrayColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveContentViewController *live = [[LiveContentViewController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:live];
    ZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [Manager sharedManager].zhiboid = model.zb_id;
    live.ZHIBOID  = model.zb_id;
    [self presentViewController:na animated:YES completion:nil];
    //[self.navigationController pushViewController:live animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self setEditing:false animated:true];
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
    //        [self.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
    //        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    //        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
    //        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    //    }];
    //    topRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *ac1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"删除.jpg"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        [self loddeleteindexpath:indexPath];
    }];
    ac1.backgroundColor = [UIColor blackColor];
    
    UITableViewRowAction *ac2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"修改.jpg"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        ZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
        AddLiveBroadcastController *add = [[AddLiveBroadcastController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:add];
        [Manager sharedManager].zhibobiaoji = @"editzb";
        [Manager sharedManager].zhuchiren = nil;
        add.zhibotypeid = model.classify;
        add.zhuchirenid = model.presenter;
        add.zhiboid     = model.zb_id;
        
 add.kaishi      = [Manager timeWithTimeIntervalString:model.starttime];
    add.jieshu      = [Manager timeWithTimeIntervalString:model.endtime];
        
        add.biaoti      = model.title;
        add.miaoshu     = model.depict;
        add.tupian      = model.photo;
        
        
        add.lai = @"123456";
        //        add.fenlei      = model.zb_id;
        //        add.zhuchiren   = model.photo;
        
        [self presentViewController:na animated:YES completion:nil];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    ac2.backgroundColor = [UIColor blackColor];
    
    UITableViewRowAction *ac = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault image:[UIImage imageNamed:@"分享.jpg"] handler:^(UITableViewRowAction * _Nullable action, NSIndexPath * _Nullable indexPath) {
        tagg = indexPath.row;
        [self addGuanjiaShareView];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }];
    ac.backgroundColor = [UIColor blackColor];
    return @[ac1,ac2,ac];
}

- (void)loddeleteindexpath:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    
    ZhiBoModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=delive&zb_id=%@&start=%@",[[Manager sharedManager] md5:single],model.zb_id,@"0"];
    //    NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //        NSLog(@"----%@",dicc);
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        //        NSLog(@"%@",[dicc objectForKey:@"Message"]);
        
        if ([code isEqualToString:@"0"] ) {
            [weakSelf.dataArray removeObject:model];
            [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=live&userid=%@&start=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid,@"0"];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        total = [[dicc objectForKey:@"total"] integerValue];
        //        [weakSelf.dataArray removeAllObjects];
//        NSLog(@"--------%@",arr);
        
        weakSelf.dataArray = [ZhiBoModel mj_objectArrayWithKeyValuesArray:arr];
        //        for (ZhiBoModel *model in [ZhiBoModel mj_objectArrayWithKeyValuesArray:arr]) {
        //            [weakSelf.dataArray addObject:model];
        //        }
        ZhiBoModel *model =  [[ZhiBoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        
        if (total == weakSelf.dataArray.count) {
            page = 0;
        }else {
            page = [model.zb_id integerValue];
        }
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        // NSLog(@"%@",[dicc objectForKey:@"Message"]);
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
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=live&userid=%@&start=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid,[NSString stringWithFormat:@"%ld",page]];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        total = [[dicc objectForKey:@"total"] integerValue];
        //NSLog(@"---%@",arr);
        //        [weakSelf.dataArray removeAllObjects];
        for (ZhiBoModel *model in [ZhiBoModel mj_objectArrayWithKeyValuesArray:arr]) {
            [weakSelf.dataArray addObject:model];
        }
        ZhiBoModel *model =  [[ZhiBoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        if (total == weakSelf.dataArray.count) {
            page = 0;
        }else {
            page = [model.zb_id integerValue];
        }
        
        
        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        if ([code isEqualToString:@"0"] ) {
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}


- (void)addGuanjiaShareView {
    //    NSArray *shareAry = @[@{@"image":@"shareView_wx",
    //                            @"title":@"微信"},
    //                          @{@"image":@"shareView_friend",
    //                            @"title":@"朋友圈"},
    //                          @{@"image":@"shareView_qq",
    //                            @"title":@"QQ"},
    //                          @{@"image":@"shareView_qzone",
    //                            @"title":@"QQ空间"},
    //                          @{@"image":@"shareView_wb",
    //                            @"title":@"新浪微博"},
    //                          ];
    
    NSArray *shareAry = @[@{@"image":@"shareView_wx",
                            @"title":@"微信"},
                          @{@"image":@"shareView_friend",
                            @"title":@"朋友圈"},
                          @{@"image":@"shareView_qq",
                            @"title":@"QQ"},
                          @{@"image":@"shareView_qzone",
                            @"title":@"QQ空间"},
                          @{@"image":@"shareView_wb",
                            @"title":@"新浪微博"},
                          ];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 54)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"分享到";
    [headerView addSubview:label];
    
    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, headerView.frame.size.height-0.5, headerView.frame.size.width, 0.5)];
    lineLabel.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    [headerView addSubview:lineLabel];
    
    UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 0.5)];
    lineLabel1.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
    
    self.shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.shareView.headerView = headerView;
    float height = [self.shareView getBoderViewHeight:shareAry firstCount:7];
    self.shareView.boderView.frame = CGRectMake(0, 0, self.shareView.frame.size.width, height);
    self.shareView.middleLineLabel.hidden = YES;
    [self.shareView.cancleButton addSubview:lineLabel1];
    self.shareView.cancleButton.frame = CGRectMake(self.shareView.cancleButton.frame.origin.x, self.shareView.cancleButton.frame.origin.y, self.self.shareView.cancleButton.frame.size.width, 54);
    self.shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.shareView setShareAry:shareAry delegate:self];
    [self.tableView.superview addSubview:self.shareView];
    
    [self.tableView.superview bringSubviewToFront:self.shareView];
}
#pragma mark HXEasyCustomShareViewDelegate
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    NSString *countStr = @"驻马店广播电视台";

    if ([title isEqualToString:@"微信"]) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        ZhiBoModel *model = self.dataArray[indexPath.row];
        NSString *shareurl = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn?zb=%@",model.zb_id];
        [UMSocialData defaultData].extConfig.title = countStr;
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:[NSString stringWithFormat:@"%@%@",model.depict,shareurl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
            self.shareView.hidden = YES;
            [self.shareView sendSubviewToBack:self.tableView.superview];
        }];
    }
    
    if ([title isEqualToString:@"朋友圈"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        ZhiBoModel *model = self.dataArray[indexPath.row];
        
        NSString *shareurl = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn?zb=%@",model.zb_id];
        
        [UMSocialData defaultData].extConfig.title = model.title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:[NSString stringWithFormat:@"%@%@",model.depict,shareurl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
            self.shareView.hidden = YES;
            [self.shareView sendSubviewToBack:self.tableView.superview];
        }];
    }
    if ([title isEqualToString:@"QQ"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        ZhiBoModel *model = self.dataArray[indexPath.row];
        
        NSString *shareurl = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn?zb=%@",model.zb_id];
        
        [UMSocialData defaultData].extConfig.title = countStr
        
        
        ;
        [UMSocialData defaultData].extConfig.qqData.url = shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:[NSString stringWithFormat:@"%@%@",model.depict,shareurl] image:nil location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                // NSLog(@"分享成功！");
            }
            self.shareView.hidden = YES;
            [self.shareView sendSubviewToBack:self.tableView.superview];
        }];
    }
    if ([title isEqualToString:@"QQ空间"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        ZhiBoModel *model = self.dataArray[indexPath.row];
        
        NSString *shareurl = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn?zb=%@",model.zb_id];
        
        [UMSocialData defaultData].extConfig.title = model.title;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:[NSString stringWithFormat:@"%@%@",model.depict,shareurl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
            self.shareView.hidden = YES;
            [self.shareView sendSubviewToBack:self.tableView.superview];
        }];
    }
    if ([title isEqualToString:@"新浪微博"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        ZhiBoModel *model = self.dataArray[indexPath.row];
        
        NSString *shareurl = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn?zb=%@",model.zb_id];
        
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        UMSocialUrlResource *result = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.photo];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",model.title,shareurl] image:nil location:nil urlResource:result presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
            [self.shareView sendSubviewToBack:self.tableView.superview];
        }];
    }
    
}




- (void)lodzhibolist {
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=live&userid=%@&start=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid,@"0"];
    //NSLog(@"^^^^^^^^^^^^^^^^ %@",urlString);
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        //NSLog(@"%@",dicc);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        total = [[dicc objectForKey:@"total"] integerValue];
        //        [weakSelf.dataArray removeAllObjects];
        weakSelf.dataArray = [ZhiBoModel mj_objectArrayWithKeyValuesArray:arr];
        
        //        for (ZhiBoModel *model in [ZhiBoModel mj_objectArrayWithKeyValuesArray:arr]) {
        //
        //            //NSLog(@"======%@",model);
        //            [weakSelf.dataArray addObject:model];
        //        }
        
        ZhiBoModel *model =  [[ZhiBoModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        
        if (total == weakSelf.dataArray.count) {
            page = 0;
        }else {
            page = [model.zb_id integerValue];
        }
        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        
        if ([code isEqualToString:@"0"] ) {
            
        }
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [self lodzhibolist];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [self.tableView reloadData];
        }); 
        
    });

}


@end
