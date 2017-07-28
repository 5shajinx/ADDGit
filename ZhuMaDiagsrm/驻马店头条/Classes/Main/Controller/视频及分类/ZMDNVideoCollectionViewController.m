//
//  ZMDNVideoCollectionViewController.m
//  cqzmd
//
//  Created by Mac10.11.4 on 16/4/15.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNVideoCollectionViewController.h"
#import "ZMDNVedioType.h"

#import "UIImageView+WebCache.h"
#import "ZMDNNetWorkStata.h"


#import "XLVideoPlayer.h"
#import "XLVideoItem.h"
#import "movieCell.h"
#import "DetailsModel.h"
#import "ZMDPlayerViewController.h"
#import "UMSocial.h"


#define JULI (ScreenW - 320)/3
static NSString *zymovies = @"ZYMOVIES";
@interface ZMDNVideoCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate>

{
    NSInteger page;
    NSInteger str;
    NSInteger currentPage;
    NSInteger pageNum;
    NSInteger listNum;
    XLVideoPlayer *_player;
    CGRect _currentPlayCellRect;
    
    NSInteger tagg;
    
}
@property(nonatomic, strong)DetailsModel *model;

@property (nonatomic, weak) UILabel *label;

@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonatomic, strong)NSMutableArray *recommendArr;
@property(nonatomic, strong)NSMutableArray *arr;
/**
 *  mytableView 可以根据自己需求替换成自己的视图.
 */
@property(nonatomic, strong) ZMDPlayerViewController *playerview;

@property(nonatomic, strong)NSIndexPath *indexPath;

@property(nonatomic, strong) UITableView *tableview;



@end




@implementation ZMDNVideoCollectionViewController



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [_player destroyPlayer];
    _player = nil;
    self.shareView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}




- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

     _recommendArr = [NSMutableArray arrayWithCapacity:1];
     _arr = [NSMutableArray arrayWithCapacity:1];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [self.tableview registerNib:[UINib nibWithNibName:@"movieCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
   
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    self.tableview.tableFooterView = view;
     self.tableview.separatorStyle = UITableViewCellSelectionStyleNone;
//    [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
    [self request];
    
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil){
         [self setUpReflash];
    }
    if ([ZMDNNetWorkStata isconnectedNetwork] == nil) {
        [self getDataFromlocal];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topTitlearr:) name:@"hidbtn" object:nil];
}
- (void)topTitlearr:(NSNotification *)text {
    self.shareView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}




- (void)tongzhi:(NSNotification *)text{
//    NSLog(@"%@",text.userInfo[@"one"]);
    //NSLog(@"－－－－－接收到通知------");
    [_player destroyPlayer];
    _player = nil;
    self.shareView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    movieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DetailsModel *model = [self.recommendArr objectAtIndex:indexPath.row];
     
    [cell.playbtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.sharebtn addTarget:self action:@selector(sharebtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showVideoPlayer:)];
    cell.imageview.userInteractionEnabled = YES;
    [cell.imageview addGestureRecognizer:tap];
    
//    NSLog(@"-----%@",model.ar_pic);
    cell.titlelable.text = model.ar_title;
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.ar_pic]placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageview.clipsToBounds = YES;
    cell.sourcelable.text = model.ar_ly;
    cell.imageview.tag = indexPath.row + 100;
    cell.commonlable.text = [NSString stringWithFormat:@"评论量：%@",model.ar_volume];
    [cell.userimageview sd_setImageWithURL:[NSURL URLWithString:model.ar_userpic]];
    
    if ([model.ar_length isEqualToString:@"0"]) {
        cell.timeLength.hidden = YES;
    }else {
        cell.timeLength.text = model.ar_length;
    }
    
    
    
    cell.timelable.layer.masksToBounds = YES;
    cell.timelable.layer.cornerRadius = 5;
    
//    if (model.ar_time != nil) {
        cell.timelable.text  = model.ar_time;
   
//    }else {
//        cell.timelable.text  = @"2016-07-15";
//    }
    
    cell.playbtn.tag = indexPath.row + 100;
    
    cell.sharebtn.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 255;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommendArr.count;
}



#pragma mark - 网络请求
- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:zymovies];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self request];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
        
    });
}

#pragma mark - 请求数据
- (void)request{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *par = @{@"ar_cateid":[NSString stringWithFormat:@"%@",@"20"],@"ar_id":[NSNumber numberWithInteger:currentPage]};
    
    [session GET:DTURL parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        //本地取数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:zymovies];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhh:arr];
        
        [weakSelf.tableview reloadData];
        [weakSelf.tableview.mj_header endRefreshing];
        
//        [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
    }];
    
    
}
- (void)hhhhhhhhhh:(NSMutableArray *)arr {
    
    for (DetailsModel *model in [DetailsModel mj_objectArrayWithKeyValuesArray:arr]) {
        [self.recommendArr addObject:model];
    }
    
    DetailsModel *model =  [[DetailsModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
    
    page = [model.ar_id integerValue];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    DetailsModel *model = [self.recommendArr objectAtIndex:indexPath.row];
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            
            self.playerview = [[ZMDPlayerViewController alloc]init];
            self.playerview.string = model.ar_title;
            self.playerview.movieURL = model.ar_movieurl;
            self.playerview.ar_id = model.ar_id;
            self.playerview.clicknum = model.ar_onclick;
            self.playerview.receiveModel = model;
            self.playerview.ar_pic = model.ar_pic;
            self.playerview.timeString = model.ar_time;
            self.playerview.fabu = model.ar_ly;
            self.playerview.ar_cateid = model.ar_cateid;
            self.playerview.ar_type = model.ar_type;
            
            [Manager setupclicknum:model.ar_type arid:model.ar_id];
            
           
            self.playerview.modalTransitionStyle = UIModalPresentationFormSheet;
            [self presentViewController:self.playerview animated:YES completion:nil];
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
   
}


- (void)sharebtn:(UIButton *)sender {
    tagg = sender.tag ;
   
    [self addGuanjiaShareView];
    self.tabBarController.tabBar.hidden = YES;
}


- (void)addGuanjiaShareView {
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
    
    self.shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-20*Kscaleh)];
    self.shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.shareView.headerView = headerView;
    float height = [self.shareView getBoderViewHeight:shareAry firstCount:7];
    self.shareView.boderView.frame = CGRectMake(0, 0, self.shareView.frame.size.width, height);
    self.shareView.middleLineLabel.hidden = YES;
//    [self.shareView.cancleButton addSubview:lineLabel1];
    self.shareView.cancleButton.frame = CGRectMake(self.shareView.cancleButton.frame.origin.x, self.shareView.cancleButton.frame.origin.y, self.shareView.cancleButton.frame.size.width, 54);
    self.shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.shareView setShareAry:shareAry delegate:self];
    [self.view addSubview:self.shareView];
    
    [self.tabBarController.tabBar bringSubviewToFront:headerView];
}
#pragma mark HXEasyCustomShareViewDelegate
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    //NSLog(@"tagg =======  %ld",tagg);
    
    NSString *strTitle = @"驻马店广播电视台";
    if ([title isEqualToString:@"微信"]) {
        _indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = model.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            model.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:model.ar_title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
            self.shareView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        _indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        [UMSocialData defaultData].extConfig.title = model.ar_title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = model.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            model.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:model.shareurl image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
             self.shareView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }
    if ([title isEqualToString:@"QQ"]) {
        _indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.qqData.url = model.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            model.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:model.ar_title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                // NSLog(@"分享成功！");
            }
             self.shareView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }
    if ([title isEqualToString:@"QQ空间"]) {
        _indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        [UMSocialData defaultData].extConfig.title = model.ar_title;
        [UMSocialData defaultData].extConfig.qzoneData.url = model.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            model.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:model.shareurl image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                //NSLog(@"分享成功！");
            }
             self.shareView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }
    if ([title isEqualToString:@"新浪微博"]) {
        _indexPath = [NSIndexPath indexPathForRow:tagg inSection:0];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:model.ar_pic];
         UMSocialUrlResource *result = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:model.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@",model.ar_title,model.shareurl] image:nil location:nil urlResource:result presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
             self.shareView.hidden = YES;
            self.tabBarController.tabBar.hidden = NO;
        }];
    }
}





- (void)showVideoPlayer:(UITapGestureRecognizer *)tapGesture {
    
    NSString *iscollect = [ZMDNNetWorkStata isconnectedNetwork];
    if ([iscollect isEqualToString:@"3g"] || iscollect == nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"当前为非wifi状态是否播放" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionPlay = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_player destroyPlayer];
            _player = nil;
            UIView *view = tapGesture.view;
            _indexPath = [NSIndexPath indexPathForRow:view.tag - 100 inSection:0];
            movieCell *cell = [self.tableview cellForRowAtIndexPath:_indexPath];
            DetailsModel *model = self.recommendArr[_indexPath.row];
            
            if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
                if (model.ar_movieurl != nil) {
                    _player = [[XLVideoPlayer alloc] init];
                    _player.videoUrl =  model.ar_movieurl;
//                    NSLog(@"-----%@",model.ar_movieurl);
                    [_player playerBindTableView:self.tableview currentIndexPath:_indexPath];
                    _player.frame = cell.imageview.frame;
                    [cell.contentView addSubview:_player];
                    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
                        [player destroyPlayer];
                        _player = nil;
                    };
                    [Manager setupclicknum:model.ar_type arid:model.ar_id];
                }
            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = model.ar_wl;
                wailian.titleename    = model.ar_title;
                [self presentViewController:na animated:YES completion:nil];
            }
            
           
        }];
        [alertVC addAction:actioncancle];
        [alertVC addAction:actionPlay];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [_player destroyPlayer];
        _player = nil;
        UIView *view = tapGesture.view;
        _indexPath = [NSIndexPath indexPathForRow:view.tag - 100 inSection:0];
        movieCell *cell = [self.tableview cellForRowAtIndexPath:_indexPath];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            if (model.ar_movieurl != nil) {
                _player = [[XLVideoPlayer alloc] init];
                _player.videoUrl =  model.ar_movieurl;
                [_player playerBindTableView:self.tableview currentIndexPath:_indexPath];
//                NSLog(@"-----%@",model.ar_movieurl);
                _player.frame = cell.imageview.frame;
                [cell.contentView addSubview:_player];
                _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
                    [player destroyPlayer];
                    _player = nil;
                };
                [Manager setupclicknum:model.ar_type arid:model.ar_id];
            }
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
        

    }
 
    
}







#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableview]) {
        
        [_player playerScrollIsSupportSmallWindowPlay:YES];
    }
}




- (void)play:(UIButton *)sender {
    
    NSString *iscollect = [ZMDNNetWorkStata isconnectedNetwork];
    if ([iscollect isEqualToString:@"3g"] || iscollect == nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"当前为非wifi状态是否播放" message:@"温馨提示" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionPlay = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [_player destroyPlayer];
            _player = nil;
            _indexPath = [NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
            movieCell *cell = [self.tableview cellForRowAtIndexPath:_indexPath];
            DetailsModel *model = self.recommendArr[_indexPath.row];
            if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
                if (model.ar_movieurl != nil) {
                    _player = [[XLVideoPlayer alloc] init];
                    _player.videoUrl =  model.ar_movieurl;
                    [_player playerBindTableView:self.tableview currentIndexPath:_indexPath];
                    _player.frame = cell.imageview.frame;
                    [cell.contentView addSubview:_player];
                    _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
                        [player destroyPlayer];
                        _player = nil;
                    };
                    [Manager setupclicknum:model.ar_type arid:model.ar_id];
                }

            }else {
                WaiLianController *wailian = [[WaiLianController alloc]init];
                UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
                wailian.urlString = model.ar_wl;
                wailian.titleename    = model.ar_title;
                [self presentViewController:na animated:YES completion:nil];
            }
    }];
        [alertVC addAction:actioncancle];
        [alertVC addAction:actionPlay];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [_player destroyPlayer];
        _player = nil;
         _indexPath = [NSIndexPath indexPathForRow:sender.tag - 100 inSection:0];
        movieCell *cell = [self.tableview cellForRowAtIndexPath:_indexPath];
        DetailsModel *model = self.recommendArr[_indexPath.row];
        if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
            if (model.ar_movieurl != nil) {
                _player = [[XLVideoPlayer alloc] init];
                _player.videoUrl =  model.ar_movieurl;
                [_player playerBindTableView:self.tableview currentIndexPath:_indexPath];
                _player.frame = cell.imageview.frame;
                [cell.contentView addSubview:_player];
                _player.completedPlayingBlock = ^(XLVideoPlayer *player) {
                    [player destroyPlayer];
                    _player = nil;
                    
                };
                [Manager setupclicknum:model.ar_type arid:model.ar_id];
            }
        }else {
            WaiLianController *wailian = [[WaiLianController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:wailian];
            wailian.urlString = model.ar_wl;
            wailian.titleename    = model.ar_title;
            [self presentViewController:na animated:YES completion:nil];
        }
        
    }
    
}






//刷新数据
-(void)setUpReflash
{
    
    __weak typeof (self) weakSelf = self;
    
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf loadMovievideos];
        
    }];
    
    [self.tableview.mj_header beginRefreshing];
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreMovievideos];
        
    }];
    
}

//下拉刷新
-(void)loadMovievideos
{
    [self.tableview.mj_footer endRefreshing];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof (self) weakSelf = self;
    currentPage = 0;
    
    NSDictionary *par = @{@"ar_cateid":@"20",@"ar_id":[NSNumber numberWithInteger:currentPage]};
    
    [session GET:DTURL parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
       // NSLog(@"----%@",arr);
        weakSelf.recommendArr = [DetailsModel mj_objectArrayWithKeyValuesArray:arr];
        
        DetailsModel *model =  [[DetailsModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        page = [model.ar_id integerValue];
        
        [weakSelf.tableview reloadData];
        
        [weakSelf.tableview.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 *  上啦刷新
 */
-(void)loadMoreMovievideos
{
    
    [self.tableview.mj_header endRefreshing];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof (self) weakSelf = self;
    currentPage = page;
    
    NSDictionary *par = @{@"ar_cateid":@"20",@"ar_id":[NSNumber numberWithInteger:currentPage]};
    
    [session GET:DTURL parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *arrar = [NSMutableArray arrayWithCapacity:1];
        arrar = [DetailsModel mj_objectArrayWithKeyValuesArray:arr];
        
        //[self.recommendArr addObject: [DetailsModel mj_objectArrayWithKeyValuesArray:arr]];
        
        
        for (DetailsModel *model in arrar) {
            [weakSelf.recommendArr addObject:model];
        }
        
        DetailsModel *model =  [[DetailsModel mj_objectArrayWithKeyValuesArray:arr] lastObject];
        
        page = [model.ar_id integerValue];
        
        
        [weakSelf.tableview reloadData];
        
        [weakSelf.tableview.mj_footer endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}









@end
