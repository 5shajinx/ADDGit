
//
//  ZMDNSearchTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/12.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNSearchTableViewController.h"

#import "ZMDNNoPicTableViewCell.h"
#import "ZMDNOneBigTableViewCell.h"
#import "ZMDNThreePicTableViewCell.h"
#import "ZMDNAdTableViewCell.h"
#import "ZMDNRecommend.h"
#import "ZMDNPicContentViewController.h"
#import "ZMDPlayerViewController.h"
#import "OneXiaoPicCell.h"
#import "WEBVIEWController.h"

#import "MainMovieCell.h"
#import "NewsDetailsTableviewController.h"

@interface ZMDNSearchTableViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    int curruntPage;
    int page;
}


@property (strong, nonatomic) UISearchBar *zmdSearchBar;/***/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/

@end

@implementation ZMDNSearchTableViewController



-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpBackButton];
    
    
    _zmdSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 64, ScreenW - 100, 50)];
    _zmdSearchBar.delegate = self;
    _zmdSearchBar.searchBarStyle = UISearchBarStyleDefault;
    _zmdSearchBar.placeholder = @"请输入您要搜索的内容";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_zmdSearchBar];

    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNNoPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"noPicCell"];
    
    // [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"havPic"];
    [self.tableView registerClass:[OneXiaoPicCell class] forCellReuseIdentifier:@"havPic"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNOneBigTableViewCell" bundle:nil] forCellReuseIdentifier:@"bigpic"];
    
    
    [self.tableView registerClass:[ZMDNThreePicTableViewCell class] forCellReuseIdentifier:@"threePic"];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"ad"];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"MainMovieCell" bundle:nil] forCellReuseIdentifier:@"movie"];
    
    self.tableView.separatorColor = Color(240, 240, 240);
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    _searchDataSource = [[NSMutableArray alloc] initWithCapacity:1];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = vie;
}



-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}


//刷新数据
-(void)setUpReflash
{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [weakSelf loadNewNews];
     }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        if (curruntPage == page) {
//            [weakSelf.tableView.mj_footer setState:MJRefreshStateNoMoreData];
//        }else {
            [weakSelf loadMoreNews];
//        }
        
    }];
    
}

-(void)loadNewNews
{
    
    [self.tableView.mj_footer endRefreshing];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    curruntPage = 0;
    __weak typeof (self) weakSelf = self;
    NSDictionary *para = @{@"title":_zmdSearchBar.text,@"$page":[NSNumber numberWithInt:curruntPage],@"type":@"1"};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/search" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//    NSLog(@"搜索内容－－－－－%@",arr);
        NSMutableArray *recommendArr = [ZMDNRecommend mj_objectArrayWithKeyValuesArray:arr];
        
        //NSLog(@"***********   %@",arr);
//        [_searchDataSource removeAllObjects];
//        [_searchDataSource addObjectsFromArray:recommendArr];
//        NSLog(@"%@",_searchDataSource);
        weakSelf.searchDataSource = recommendArr;
        page = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
/**
 *  上啦刷新
 */
-(void)loadMoreNews
{
    
    [self.tableView.mj_header endRefreshing];
    curruntPage = page; 
    __weak typeof (self) weakSelf = self;
     NSDictionary *para = @{@"title":_zmdSearchBar.text,@"page":[NSNumber numberWithInt:curruntPage],@"type":@"1"};
     AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
     session.responseSerializer = [AFHTTPResponseSerializer serializer];
     session.requestSerializer = [AFJSONRequestSerializer serializer];
     [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/search" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
        
        NSMutableArray *recommendArr = [ZMDNRecommend mj_objectArrayWithKeyValuesArray:arr];

        for (ZMDNRecommend *model in recommendArr) {
            [weakSelf.searchDataSource addObject:model];
            
        }
        page += 1;
        
       // [_searchDataSource addObjectsFromArray:recommendArr];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
    
}


#pragma mark --searchBar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self setUpReflash];
    [searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    return YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}




#pragma mark --tableView delegate



//设置cell的分割线
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _searchDataSource[indexPath.row];
    if (recommend.ar_type == 1)
    {
        return  [ZMDNNoPicTableViewCell heightForCell:recommend];
    }
    else if (recommend.ar_type == 2)
    {
        return 110;
    }
    else if (recommend.ar_type == 3)
    {
        return 170;
    }
    
    else if (recommend.ar_type == 6)
    {
        return 140;
    }
    
    return 275;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _searchDataSource[indexPath.row];
    if (recommend.ar_type == 1)
    {
        return  [ZMDNNoPicTableViewCell heightForCell:recommend];
    }
    else if (recommend.ar_type == 2)
    {
        return 110;
    }
    else if (recommend.ar_type == 3)
    {
        return 170;
    }
    
    else if (recommend.ar_type == 6)
    {
        return 160*Kscaleh;
    }
    
    return 275;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZMDNRecommend *recommend  = _searchDataSource[indexPath.row];
    if (recommend.ar_type == 1)
    {
        ZMDNNoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noPicCell"];
        cell.recommendModel = recommend;
        return cell;
    }
    else if (recommend.ar_type == 2)
    {
        OneXiaoPicCell *picCell = [tableView dequeueReusableCellWithIdentifier:@"havPic"];
        
        picCell.recommendModel = recommend;
        
        picCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return picCell;
    }
    else if (recommend.ar_type == 3)
    {
        ZMDNThreePicTableViewCell *threePicCell = [tableView dequeueReusableCellWithIdentifier:@"threePic"];
        threePicCell.recommendModel = recommend;
        threePicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return threePicCell;
        
    }
    
    else if (recommend.ar_type == 4)
        
    {
        MainMovieCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"movie"];
        adCell.recommendModel = recommend;
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell;
    }
    
    else if (recommend.ar_type == 6)
        
    {
        ZMDNAdTableViewCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"ad"];
        adCell.recommendModel = recommend;
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell;
    }
    
    
    ZMDNOneBigTableViewCell *bigPicCell = [tableView dequeueReusableCellWithIdentifier:@"bigpic"];
    bigPicCell.recommendModel = recommend;
    bigPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (recommend.ar_type == 0) {
        bigPicCell.pagelable.hidden = YES;
        bigPicCell.tutu.hidden = YES;
        bigPicCell.lab1.hidden = YES;
    }else {
        bigPicCell.pagelable.hidden = NO;
        bigPicCell.tutu.hidden = NO;
        bigPicCell.lab1.hidden = NO;
    }
    return  bigPicCell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZMDNRecommend *recommend  = _searchDataSource[indexPath.row];
    NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%d&type=%d",recommend.id,recommend.ar_type];
    
    if (recommend.ar_type == 4)
    {
            if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
                 [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:recommend.ar_title];
            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = recommend.ar_wl;
                wailian.titleename    = recommend.ar_title;
                [self presentViewController:na animated:YES completion:nil];
            }
       
    }
    else if (recommend.ar_type == 6) {
        WaiLianController *zwfw = [[WaiLianController alloc]init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
        zwfw.urlString = recommend.ar_wl;
        zwfw.titleename = recommend.ar_title;
//        na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:na animated:YES completion:nil];
    }
    else if (recommend.ar_type == 5)
    {
        if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
            ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
            picContentVc.manyPicLink = htmlUrl;
            picContentVc.sharetitle  = recommend.ar_title;
            picContentVc.picture     = recommend.ar_pic;
            
//            picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:picContentVc animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = recommend.ar_wl;
            wailian.titleename    = recommend.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
    }
    
    else
    {
        if ([recommend.ar_wl isEqual:[NSNull null]] || recommend.ar_wl == nil || [recommend.ar_wl isEqualToString:@""]) {
            NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
            if ([recommend.state isEqualToString:@"1"]) {
                [Manager sharedManager].jinru = nil;
            }else {
                [Manager sharedManager].jinru = @"jinruwebview";
            }
            
            webCtrol.userpicture = [NSString stringWithFormat:@"%@",recommend.ar_userpic];
            webCtrol.type =[NSString stringWithFormat:@"%d",recommend.ar_type];
            webCtrol.idString =[NSString stringWithFormat:@"%d",recommend.id];
            webCtrol.ar_cateid =[NSString stringWithFormat:@"%@",recommend.ar_cateid];
            
//            na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:na animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = recommend.ar_wl;
            wailian.titleename = recommend.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
    }
    
}



//请求视频链接
-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ZMDPlayerViewController *zmdPlayer = [[ZMDPlayerViewController alloc] init];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakself = self;
    __weak typeof (zmdPlayer) weakPlayer =  zmdPlayer;
    
    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
         //NSLog(@"dianying shipin  %@",dic);
         
         
         zmdPlayer.string = [dic objectForKey:@"ar_title"];
         zmdPlayer.movieURL = [dic objectForKey:@"ar_movieurl"];
         zmdPlayer.ar_id = [dic objectForKey:@"ar_id"];
         zmdPlayer.clicknum = [dic objectForKey:@"ar_onclick"];
         zmdPlayer.ar_pic = [dic objectForKey:@"ar_pic"];
         zmdPlayer.timeString = [dic objectForKey:@"ar_time"];
         zmdPlayer.fabu = [dic objectForKey:@"ar_ly"];
         zmdPlayer.ar_cateid = [dic objectForKey:@"ar_cateid"];
         zmdPlayer.ar_type = [dic objectForKey:@"ar_type"];
         
         
         
//         weakPlayer.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
         [weakself presentViewController:weakPlayer animated:YES completion:nil];
         [MBProgressHUD hideHUDForView:weakself.view animated:YES];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [MBProgressHUD hideHUDForView:weakself.view animated:YES];
                        });
         
         //NSLog(@"%@",error);
     }];
    
    
}

- (void)setUpBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(backreturn) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    
}
- (void)backreturn {
    //刷新用户头像的通知
    
    //创建通知
    NSNotification *notifi = [NSNotification notificationWithName:@"shuaxinjiemian" object:nil userInfo:nil];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notifi];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    self.tabBarController.tabBar.hidden = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
