//
//  ShouCangTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ShouCangTableViewController.h"
#import "ShouCangCell.h"
#import "MineSCModel.h"
#import "UMSocial.h"

#import "MainMovieCell.h"
//视频
#import "movieCell.h"
#import "DetailsModel.h"
//无图
#import "ZMDNNoPicTableViewCell.h"
//一张小图
#import "OneXiaoPicCell.h"
//一张大图
#import "ZMDNOneBigTableViewCell.h"
//三张小图
#import "ZMDNThreePicTableViewCell.h"
//广告
#import "ZMDNAdTableViewCell.h"

#import "WEBVIEWController.h"
#import "ZMDNPicContentViewController.h"
#import "ZMDPlayerViewController.h"

#import "NewsDetailsTableviewController.h"
#import "ZMDNRecommend.h"
#import "ThreePicTableViewCell.h"//新三个图cell
#import "onedpicTableViewCell.h"//新一个图
#define JULI (ScreenW - 320)/3

static NSString *collectionchacer = @"collectionChacer";

@interface ShouCangTableViewController ()<UMSocialUIDelegate>
{
     NSInteger tagg;
}
@property(nonatomic, strong)NSMutableArray *arr;

@property(nonatomic, strong) ZMDPlayerViewController *playerview;
@property(nonatomic, strong) NSString *string;

@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, assign)BOOL isDel;
@property(nonatomic, strong)NSIndexPath *indexPath;


@end

@implementation ShouCangTableViewController
- (NSMutableArray *)arr {
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpBackButton];
    self.navigationItem.title = @"我的收藏";
   
     self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainMovieCell" bundle:nil] forCellReuseIdentifier:@"movie"];
    
 //   [self.tableView registerClass:[OneXiaoPicCell class] forCellReuseIdentifier:@"oneXiaoTucell"];

     [self.tableView registerNib:[UINib nibWithNibName:@"onedpicTableViewCell" bundle:nil] forCellReuseIdentifier:@"onedpicTableV"];
   // [self.tableView registerClass:[ThreePicTableViewCell class] forCellReuseIdentifier:@"threeTuce"];
       [self.tableView registerNib:[UINib nibWithNibName:@"ThreePicTableViewCell" bundle:nil] forCellReuseIdentifier:@"threeTuce"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNOneBigTableViewCell" bundle:nil] forCellReuseIdentifier:@"bigpic"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNNoPicTableViewCell" bundle:nil] forCellReuseIdentifier:@"noPicCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZMDNAdTableViewCell" bundle:nil] forCellReuseIdentifier:@"ad"];
    
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 0, 40, 20) ;
    [self.btn setTitle:@"编辑" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(deleatShouCang:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
    self.navigationItem.rightBarButtonItem = bar;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = footerView;

    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    self.string = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    //if (self.string != nil) {
        //[self getDataFromlocal];
        [self lodCollectionList];
    //}
}


- (void)deleatShouCang:(UIButton *)sender {
    if (_isDel == NO) {
        [self.btn setTitle:@"取消" forState:UIControlStateNormal];
        self.tableView.editing = YES;
    }else {
        [self.btn setTitle:@"编辑" forState:UIControlStateNormal];
        self.tableView.editing = NO;
    }
    _isDel = !_isDel;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     ZMDNRecommend *model = [self.arr objectAtIndex:indexPath.row];
    
    if (model.ar_type == 4) {
        return 275;
    }
    if (model.ar_type == 1) {
        return  [ZMDNNoPicTableViewCell heightForCell:(ZMDNRecommend *)model];
    }
    if (model.ar_type == 2) {
        return 100;
    }
    if (model.ar_type == 3) {
        return 160;
    }
    if (model.ar_type == 5) {
        return 275;
    }
    if (model.ar_type == 6) {
        return 160*Kscaleh;
    }
    return 275;
}
//删除对应数据
- (NSIndexPath *)removeDataAtIndex:(NSInteger)row
{
    NSMutableArray *copyArray = [NSMutableArray  arrayWithArray:_arr];
    [copyArray removeObjectAtIndex:row];
    _arr = [NSMutableArray arrayWithArray:copyArray];
    NSIndexPath * path = [NSIndexPath indexPathForRow:row inSection:0];
    return path;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZMDNRecommend *model = [self.arr objectAtIndex:indexPath.row];
    if (model.ar_type == 2) {
        onedpicTableViewCell  *picCell   = [tableView dequeueReusableCellWithIdentifier:@"onedpicTableV" forIndexPath:indexPath];
        picCell.recommendModel = (ZMDNRecommend *)model;
        return picCell;
    }
    
     if (model.ar_type == 4)
        
    {
        MainMovieCell *adCell = [tableView dequeueReusableCellWithIdentifier:@"movie" forIndexPath:indexPath];
        adCell.recommendModel = (ZMDNRecommend *)model;
        adCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return adCell; 
    }
    
    if (model.ar_type == 1) {
        ZMDNNoPicTableViewCell *noPicCell   = [tableView dequeueReusableCellWithIdentifier:@"noPicCell" forIndexPath:indexPath];
        noPicCell.recommendModel = (ZMDNRecommend *)model;
        return noPicCell;
    }
    if (model.ar_type == 3) {
        ThreePicTableViewCell *threePicCell   = [tableView dequeueReusableCellWithIdentifier:@"threeTuce" forIndexPath:indexPath];
        threePicCell.recommendModel = (ZMDNRecommend *)model;
        return threePicCell;
    }    
    if (model.ar_type == 6) {
        ZMDNAdTableViewCell *adCell   = [tableView dequeueReusableCellWithIdentifier:@"ad" forIndexPath:indexPath];
        adCell.recommendModel = (ZMDNRecommend *)model;
        return adCell;
    }
    
    ZMDNOneBigTableViewCell *bigPicCell   = [tableView dequeueReusableCellWithIdentifier:@"bigpic" forIndexPath:indexPath];
    bigPicCell.recommendModel = (ZMDNRecommend *)model;
    bigPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model.ar_type == 0) {
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


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     ZMDNRecommend *model = [self.arr objectAtIndex:indexPath.row];
    
    NSLog(@"eeeeeeeeeeeeee%d",model.ar_type);

    NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%d&type=%d",model.id,model.ar_type];
    
    
    if (model.ar_type == 4) {
            if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
                [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:model.ar_title andindexpath:indexPath];
            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = model.ar_wl;
                [self presentViewController:na animated:YES completion:nil];
            }

        
    }
    
   else if (model.ar_type == 5) {
       if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
           ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
           
           picContentVc.manyPicLink  = htmlUrl;
           picContentVc.sharetitle   = model.ar_title;
           picContentVc.picture      = model.ar_pic;
//           picContentVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
           [self presentViewController:picContentVc animated:YES completion:nil];
       }else {
           WaiLianController *wailian = [[WaiLianController alloc]init];
           UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
           wailian.urlString = model.ar_wl;
           [self presentViewController:na animated:YES completion:nil];
       }
       
    }
    else {
        
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
            if ([model.state isEqualToString:@"0"]) {
                [Manager sharedManager].jinru = @"jinruwebview";
            }
            if ([model.state isEqualToString:@"1"]) {
                [Manager sharedManager].jinru = nil;
            }
            webCtrol.userpicture = [NSString stringWithFormat:@"%@",model.ar_userpic];
            webCtrol.type =[NSString stringWithFormat:@"%d",model.ar_type];
            webCtrol.idString =[NSString stringWithFormat:@"%d",model.id];
            webCtrol.ar_cateid =[NSString stringWithFormat:@"%@",model.ar_cateid];
            [self presentViewController:na animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
       
    }
    
    
    
    
}

- (void)play:(UIButton *)sender {
    
    _indexPath = [NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
    ZMDNRecommend *model = self.arr[_indexPath.row];
     NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%d&type=%d",model.id,model.ar_type];
    [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:model.ar_title andindexpath:_indexPath];
   
}

- (void)sharebtn:(UIButton *)sender {
        tagg = sender.tag ;

}

- (void)setUpBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
//    [[Manager sharedManager].collArrKEEPID removeAllObjects];
//    [[Manager sharedManager].collArr removeAllObjects];
//    
//    [[Manager sharedManager] lodCollectionList];
}


- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:collectionchacer];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodCollectionList];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
       
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
}
- (void)hhhhhhhhhh:(id)arr {
    
    self.arr = [ZMDNRecommend mj_objectArrayWithKeyValuesArray:arr];
//    for (MineSCModel *model in [MineSCModel mj_objectArrayWithKeyValuesArray:arr]) {
//        [self.arr addObject:model];
//    }
    [self.tableView reloadData];
}



- (void)lodCollectionList {
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSString *urlstr = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/keep/index/ptuid/%@",str];
    
    [session GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:collectionchacer];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakself hhhhhhhhhh:arr];
        [weakself.tableView reloadData];
        
        //NSLog(@"收藏列表*****  %@",arr);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    

}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleatshoucang:indexPath];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     
    }
    
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"   删除";
}

- (void)deleatshoucang:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    ZMDNRecommend *model = [self.arr objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakself = self;
    NSDictionary *par = @{@"keep_id":model.keep_id};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/delkeep" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        
        NSNumber *number = [dic objectForKey:@"code"];
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            
            //NSLog(@"****  %@",[dic objectForKey:@"Message"]);
            weakself.tableView.editing = NO;
            [weakself.btn setTitle:@"编辑" forState:UIControlStateNormal];
            
            [weakself.arr removeObject:model];
            
            _isDel = !_isDel;
        }
        
        [weakself.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




//请求视频链接
-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title andindexpath:(NSIndexPath *)indexPath
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakself = self;
    
    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         
         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
         NSError *err;
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
         //NSLog(@"dianying shipin  %@",dic);
         
        
         ZMDNRecommend *model = weakself.arr[indexPath.row];
         
         weakself.playerview = [[ZMDPlayerViewController alloc]init];
         
         weakself.playerview.string = model.ar_title;
         weakself.playerview.ar_id = [NSString stringWithFormat:@"%d",model.id];
         weakself.playerview.receiveModel = (DetailsModel *)model;
         weakself.playerview.ar_pic = model.ar_pic;
         weakself.playerview.timeString = model.ar_time;
         weakself.playerview.fabu = model.ar_ly;
         weakself.playerview.ar_cateid = model.ar_cateid;
         weakself.playerview.ar_type = [NSString stringWithFormat:@"%d",model.ar_type];
         weakself.playerview.movieURL = [dic objectForKey:@"ar_movieurl"];
         
         [Manager setupclicknum:[NSString stringWithFormat:@"%d",model.ar_type] arid:[NSString stringWithFormat:@"%d",model.id]];
         
//         weakself.playerview.modalTransitionStyle = UIModalPresentationFormSheet;
         [weakself presentViewController:weakself.playerview animated:YES completion:nil];
         
         
         [MBProgressHUD hideHUDForView:weakself.view animated:YES];
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         //NSLog(@"%@",error);
     }];
    
    
}




@end
