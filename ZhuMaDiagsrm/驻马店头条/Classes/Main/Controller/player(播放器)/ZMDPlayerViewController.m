//
//  ZMDPlayerViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/2.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDPlayerViewController.h"
#import "PrefixHeader.pch"
#import "UMSocial.h"
#import "zmdmodel.h"
#import "ZmdmovieViewCell.h"
#import "ZmdcommendCell.h"
#import "MineSCModel.h"
#import "DataBaseManager.h"
#import "MineDYModel.h"
#import "DetailsModel.h"
#import "ZMDUserTableViewController.h"
#import "AppDelegate.h"
#import "commonmodel.h"

#import "ZMDNNewfirstMoviewTableViewCell.h"

#import "ZMDNNewMovieTableViewCell.h"
#import "ZMDNNewCommendTableViewCell.h"
#define JULI (ScreenW - 320)/3

@interface ZMDPlayerViewController ()<UMSocialUIDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

{
    NSString *ding;
    NSString *cai;
    NSInteger tagg;
    int biaoshi;
    int i ;
    
    NSString *deleteCommonString;
    NSInteger shanglaPage;
}
@property(nonatomic, strong)NSIndexPath *indexPath;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonatomic, strong)AppDelegate *delegate;
@property (weak, nonatomic) IBOutlet UIView *fuZhuView;
@property (weak, nonatomic) IBOutlet UILabel *currentLable;

@property (weak, nonatomic) IBOutlet UILabel *durctionLable;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *fullButton;

@property (nonatomic, assign)BOOL iscollection;
@property (nonatomic, assign)BOOL isViewHidden;
@property (nonatomic, assign)BOOL isFull;
@property (nonatomic, assign)BOOL isPlay;
@property (nonatomic, assign)BOOL isZhNKAI;

@property (nonatomic, assign)CGFloat totalTime;
@property (nonatomic, strong)AVPlayerItem *item;
@property (nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong)AVPlayerLayer *layer;

@property (nonatomic, strong)UIView *toolView;//底部评论分享view
//@property (nonatomic, strong)UITextView *textview;
@property (nonatomic, strong)UIButton *but;
@property (nonatomic, strong)UIButton *but1;
@property (nonatomic, strong)UIButton *but2;
@property (nonatomic, strong)UIButton *but3;

@property (nonatomic, strong)UIView *headervie;
@property (nonatomic, strong)UILabel *numlable;
@property (nonatomic, strong)UIButton *dingbtn;
@property (nonatomic, strong)UILabel *dinglable;
@property (nonatomic, strong)UIButton *caibtn;
@property (nonatomic, strong)UILabel *cailable;
@property (nonatomic, strong)UIButton *DINGYUE;
@property(nonatomic, strong)NSString *topTime;

@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, assign)NSInteger zannum;
@property (nonatomic, assign)NSInteger cainum;
@property(nonatomic, strong)NSMutableArray *contentarr;
@property(nonatomic, strong)NSMutableArray *collectionArr;
@property(nonatomic, strong)DataBaseManager *manager;
@property(nonatomic , strong)UILabel *lab;
@property (nonatomic, assign)BOOL DingYue;

@property(nonatomic, strong)NSString *dddd;
@property(nonatomic, strong)NSString *step;
@property(nonatomic, strong)NSString *onclick;
@property(nonatomic, strong)NSString *volume;
@property(nonatomic, strong)NSString *userid;
@property(nonatomic, strong)NSString *artitle;
@property(nonatomic, strong)NSString *shareurl;
@property(nonatomic, strong)NSString *userpic;
@property(nonatomic, strong)NSString *aronclicing;
@property(nonatomic, strong)NSString *arly;
@property (nonatomic, assign)BOOL shangxia;
@property(nonatomic, strong)UIButton *sxbtn;
@property(nonatomic, strong)UILabel *titlelable;
@property(nonatomic, strong)UIButton *BackButton;
//@property(nonatomic, strong)UIView *touview;
@property(nonatomic, strong)UIImageView *touimage;
@property(nonatomic, strong)UILabel *toulable;
@property(nonatomic, strong)NSString *take_id;
@property(nonatomic, strong)NSString *keep_id;
@property(nonatomic, strong)UITextField *textfield;

@property(nonatomic, strong)NSMutableArray *dyid;
@property(nonatomic, strong)NSMutableArray *dytakeid;
@property(nonatomic, assign)BOOL islocation;
@property(nonatomic, strong)NSMutableArray *scid;
@property(nonatomic, strong)NSMutableArray *sckeepid;

@property(nonatomic, strong)UIView *commitBgviw;
@property(nonatomic, strong)UIView *writeCommitBgviw;
@property(nonatomic, strong)UIView *dowCommitBgviw;


@property(nonatomic, strong)UITableView *commitTableView;
@property(nonatomic, strong)UITextView *commitTextView;


@end



@implementation ZMDPlayerViewController

- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)collectionArr {
    if (_collectionArr == nil) {
        self.collectionArr = [NSMutableArray array];
    }
    return _collectionArr;
}
- (NSMutableArray *)contentarr {
    if (_contentarr == nil) {
        self.contentarr = [NSMutableArray array];
    }
    return _contentarr;
}

- (void)returnToList:(UIButton *)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dyid = [NSMutableArray arrayWithCapacity:1];
    self.dytakeid = [NSMutableArray arrayWithCapacity:1];
    self.scid = [NSMutableArray arrayWithCapacity:1];
    self.sckeepid = [NSMutableArray arrayWithCapacity:1];
    [self setupToolBar];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    
    self.BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.BackButton.frame = CGRectMake(10, 20, 40, 40);
    [self.BackButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [self.BackButton addTarget:self action:@selector(returnToList:) forControlEvents:UIControlEventTouchUpInside];
    self.BackButton.hidden = NO;
    [self.view addSubview:self.BackButton];
  //  NSLog(@"000000000000%@",self.movieURL);
    [Manager sharedManager].movieURL = self.movieURL;
    
//    NSLog(@"self.movieURL ========    %@",self.movieURL);
    
    self.item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[Manager sharedManager].movieURL]];
    self.player=[AVPlayer playerWithPlayerItem:self.item];
    self.layer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    self.layer.videoGravity=AVLayerVideoGravityResizeAspect;
    self.layer.backgroundColor=[[UIColor blackColor]CGColor];//给框一个颜色
    [self.avPlayer.layer addSublayer:self.layer];//添加到视图上
    
    [self addCurrentTimeTimer];
    
    [self addObserverToPlayerItem:self.item];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    
    [self nstime];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isNotHidden:)];
    [self.avPlayer addGestureRecognizer:tap];
    
    [self.player play];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   
    if (self.ar_id != nil) {
        [self lodDetailsInformation];
    }
    
    [self request];
    
    [self commandList];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    vie.backgroundColor = [UIColor whiteColor];
    self.tableview.tableFooterView = vie;
    
    [self lodCollectionList];
    [self dingYueList];
    [self.avPlayer bringSubviewToFront:self.fuZhuView];
    [self.view bringSubviewToFront:self.BackButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movie:) name:@"movie" object:nil];
    
    [self setUpReflashShangLa];
    //展示评论view
    [self showCommitView];
    //写评论的view
    [self writeCommitBgView];
}
- (void)movie:(NSNotification *)text {
   
    [self addObserverToPlayerItem:self.item];
}

//隐藏电池条
- (void)viewWillAppear:(BOOL)animated {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filewebCaches = [file stringByAppendingPathComponent:@"/arr.text"];
    NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
    if (fileDic.count != 0) {
        [[WordFilter sharedInstance] initFilter:fileDic];
    }
    
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _delegate.allowRotation = 1;
    
    [self.player play];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    deleteCommonString = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    
    
    
}
-(void)showCommitView{
    self.commitBgviw = [[UIView alloc]init];
   // _commitBgviw .backgroundColor = [UIColor redColor];
    [self.view addSubview:_commitBgviw];
    _commitBgviw.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 265);

    
//    [_commitBgviw mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.offset(0);
//        make.height.mas_equalTo(self.view.mas_height).offset(-230);
//        make.top.mas_equalTo(self.view.bottom);
//        
//    }];
}
//写评论
-(void)writeCommitBgView{
    //大背景图
    self.writeCommitBgviw = [[UIView alloc]init];
    _writeCommitBgviw.backgroundColor = [UIColor colorWithRed:107/255.0 green:107/255.0 blue:107/255.0 alpha:0.3];
    _writeCommitBgviw.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_writeCommitBgviw];
    
    //小背景图
    self.dowCommitBgviw = [[UIView alloc]init];
    _dowCommitBgviw.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    _dowCommitBgviw.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    [_writeCommitBgviw addSubview:_dowCommitBgviw];
    
    
    //输入框
    _commitTextView  = [[UITextView alloc]init];
    _commitTextView.delegate = self;
    [_dowCommitBgviw addSubview:_commitTextView];
    _commitTextView.font = [UIFont systemFontOfSize:16];
    _commitTextView.layer.borderWidth = 1;
    _commitTextView.layer.borderColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1]);
   //取消
    UIButton *QuXiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dowCommitBgviw addSubview:QuXiao];
    [QuXiao setTitle:@"取消" forState:UIControlStateNormal];
    
   
    [QuXiao setTitleColor:[UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1]forState:UIControlStateNormal];
    
    [QuXiao addTarget:self action:@selector(quxiaoButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *comLabel = [[UILabel alloc]init];
    comLabel.font = [UIFont systemFontOfSize:19];
    
    comLabel.text = @"评论";
    comLabel.tintColor = [UIColor blackColor];
    [_dowCommitBgviw addSubview:comLabel];
    //发送
UIButton *senderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dowCommitBgviw addSubview:senderbutton];
    [senderbutton setTitle:@"发送" forState:UIControlStateNormal];
       [senderbutton setTitleColor:[UIColor colorWithRed:93/255.0 green:93/255.0 blue:93/255.0 alpha:1]forState:UIControlStateNormal];
    [senderbutton addTarget:self action:@selector(senderbutton:) forControlEvents:UIControlEventTouchUpInside];

    
    [QuXiao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(15);
        make.width.offset(40);
        make.height.offset(22);
        
    }];
    
    [comLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(QuXiao.mas_centerY);
        make.centerX.mas_equalTo(_dowCommitBgviw.mas_centerX);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    [senderbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(QuXiao.mas_centerY);
        make.right.offset(-15);
        make.width.offset(40);
        make.height.offset(20);
    }];
    
    [_commitTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(QuXiao.mas_bottom).offset(10);
        make.bottom.offset(-20);
        make.left.offset(10);
        make.right.offset(-10);

        
    }];
    
}

//取消
- (void)quxiaoButton{
    _commitTextView.text = @"";
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.writeCommitBgviw.transform = CGAffineTransformMakeTranslation(0, 0);
        self.dowCommitBgviw.transform = CGAffineTransformMakeTranslation(0, 0);
        
    }];
    
    
}
//确定发送
-(void)senderbutton:(UIButton *)butt{
    [self.commitTextView resignFirstResponder];
    [self sendMessage:butt];
}

- (BOOL)prefersStatusBarHidden

{
    return YES;//隐藏为YES，显示为NO
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //设置播放器大小
    self.layer.frame = self.avPlayer.frame;
}

- (void)hiddenFuZhuView
{
    if (self.isViewHidden == NO) {
        self.fuZhuView.hidden = YES;
    }
    self.isViewHidden = YES;
}
- (void)isNotHidden:(UITapGestureRecognizer *)tap
{
    if (self.isViewHidden == YES) {
        self.fuZhuView.hidden = NO;
        [self nstime];
    }else {
        self.fuZhuView.hidden = YES;
    }
    _isViewHidden = !_isViewHidden;
}

- (void)nstime {
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hiddenFuZhuView) userInfo:nil repeats:NO];
}


// 实现定时器方法
- (void)addCurrentTimeTimer
{
    // block循环引用
    __weak typeof(self)weakSelf = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:nil usingBlock:^(CMTime time) {
        // 更新slider进度条
        [weakSelf.slider setValue:CMTimeGetSeconds(weakSelf.player.currentItem.currentTime) / CMTimeGetSeconds(weakSelf.player.currentItem.duration) animated:YES];
        // 设置的播放时间的倒计时
        int currentTime = CMTimeGetSeconds(weakSelf.player.currentTime);
        // 获取分钟
        int currentMin = currentTime / 60;
        // 获取秒
        int currentSec = currentTime % 60;
        // 判断条件
        if (currentTime != 0) {
            // 给label赋值时间
            weakSelf.currentLable.text = [NSString stringWithFormat:@"%.2d:%.2d",currentMin,currentSec];
        } else {
            // 初始时间
            weakSelf.currentLable.text = @"00:00";
        }
        // 如果当前的时间 != 0 和 当前的时间 == 总时间时,播放完成
        if (CMTimeGetSeconds(weakSelf.player.currentItem.currentTime) != 0 && CMTimeGetSeconds(weakSelf.player.currentItem.currentTime) == CMTimeGetSeconds(weakSelf.player.currentItem.duration)) {
            // 暂停歌曲,未来可以在这里切换下一首歌曲
            [weakSelf.player pause];
        }
    }];
}

// 添加观察者
- (void)addObserverToPlayerItem:(AVPlayerItem *)avplayerItem
{
    // 监控状态属性 注意AVPlayer有一个status属性,通过监控它可以获得音乐的播放状态
    [avplayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监控网络加载情况的属性
    [avplayerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
//移除管擦着
- (void)removeObserverFromeAvplayerItem:(AVPlayerItem *)avplayerItem {
    [avplayerItem removeObserver:self forKeyPath:@"status"];
    [avplayerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}



//观察者的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //获取item
    AVPlayerItem *avPlayerItem = object;
    // 判断
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        // 判断
        if (status == AVPlayerStatusReadyToPlay) {
            // 获取歌曲总时间
            CMTime time = avPlayerItem.duration;
            // 因为slider的值是小数,要转成float, 当前的时间 / 总时间 才能得到小数 s
            self.totalTime = (CGFloat)time.value / time.timescale;
            // 计算分钟
            int musicM = self.totalTime / 60;
            // 计算秒
            int musicS = (int)self.totalTime % 60;
            // 适应label
            self.durctionLable.adjustsFontSizeToFitWidth = YES;
            // 添加时间
            self.durctionLable.text = [NSString stringWithFormat:@"%.2d:%.2d",musicM,musicS];
        }
    }
}

- (void)sliderChange:(UISlider *)slider
{
    // 首先暂停音乐的播放
    [self.player pause];
    // 获得slider的value值
    float currentValue = (float)(self.totalTime *slider.value);
    // CMTimeMake(a,b) a: 当前第几帧,b:每秒多少帧 当前的播放时间就是  a/b
    // CMTime 是表示电影时间信息的结构体,第一个参数表示是视频第几秒,第二个参数是每秒帧数,(如果要获得某一秒的第几帧可以使用 CMTimeMake方法)
    CMTime currentTime = CMTimeMake(currentValue, 1);
    __weak typeof(self)weakSelf = self;
    // 给avplayer设置进度
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
    // 播放
    [weakSelf.player play];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.isZhNKAI = YES;
    
    [self.player pause];
    [self removeObserverFromeAvplayerItem:self.item];
    
    self.shareView.hidden = YES;
  
    _delegate.allowRotation = 0;
//    [[Manager sharedManager] lodCollectionList];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [self.player play];
//    [self addObserverToPlayerItem:self.item
//}



- (IBAction)playButton:(id)sender
{
    if (self.isPlay == NO) {
        [self.player pause];
        [sender setImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
    }else {
        [self.player play];
        [sender setImage:[UIImage imageNamed:@"zanting"] forState:UIControlStateNormal];
    }
    
    _isPlay = !_isPlay;
}

- (IBAction)fullScreenButton:(id)sender
{
    if (self.isFull) {
        
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        self.navigationController.navigationBar.hidden = NO;
         self.isFull = NO;
         self.BackButton.hidden = NO;
         self.toolView.hidden = NO;
        
        [self.fullButton setImage:[UIImage imageNamed:@"quanping"] forState:UIControlStateNormal];
    }else{
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeLeft) forKey:@"orientation"];
        self.navigationController.navigationBar.hidden = YES;
        self.toolView.hidden = YES;
        self.isFull = YES;
        self.BackButton.hidden = YES;
        
        [self.fullButton setImage:[UIImage imageNamed:@"tuichu"] forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - 请求数据 相关视频
- (void)request{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    if (self.ar_id != nil) {
        [MBProgressHUD showHUDAddedTo:self.tableview animated:YES];
       
        NSDictionary *par = @{@"type":self.ar_type,@"ar_cateid":self.ar_cateid,@"ar_id":self.ar_id};
       
        [session GET:colutionMovie parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            
            //NSLog(@"相关视频%@",arr);
            
            weakSelf.array = [zmdmodel mj_objectArrayWithKeyValuesArray:arr];
 
            
            [weakSelf.tableview reloadData];
            
            [weakSelf.tableview.mj_header endRefreshing];
            
            [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:weakSelf.tableview animated:YES];
        }];
    }
    

    
}




- (void)setupToolBar {
     self.toolView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - 50, ScreenW, 50)];
     self.toolView.backgroundColor = [UIColor colorWithRed:224/256.0 green:224/256.0 blue:224/256.0 alpha:1];
    
//    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, 180*Kscalew, 30)];
//    self.textview.layer.masksToBounds = YES;
//    self.textview.layer.cornerRadius = 5;
//    self.textview.delegate = self;
//    self.textview.textColor = [UIColor blackColor];
//    self.textview.hidden = YES;
//    [self.toolView addSubview:self.textview];
    
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, ScreenW-170, 40)];
    self.textfield.layer.masksToBounds = YES;
    self.textfield.layer.cornerRadius = 5;
    self.textfield.delegate = self;
    self.textfield.backgroundColor = [UIColor whiteColor];
    self.textfield.textColor = [UIColor blackColor];
    self.textfield.hidden = NO;
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.placeholder = @" 写评论。。。";
    [self.toolView addSubview:self.textfield];
    
    
    self.but = [UIButton buttonWithType:UIButtonTypeCustom];
    self.but.frame = CGRectMake((ScreenW - 150),10, 30, 30);
    [self.but setImage:[UIImage imageNamed:@"comm"] forState:UIControlStateNormal];
    [self.but addTarget:self action:@selector(commendNumber:) forControlEvents:UIControlEventTouchUpInside];
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(240*Kscalew, 6, 30*Kscalew, 10)];
    self.lab.backgroundColor = [UIColor redColor];
    self.lab.layer.masksToBounds = YES;
    self.lab.layer.cornerRadius = 5;
    self.lab.font = [UIFont systemFontOfSize:12];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.text = [NSString stringWithFormat:@"%@",self.volume];
//    [self.toolView addSubview:self.lab];
    [self.toolView addSubview:self.but];
    
    self.but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.but1.frame = CGRectMake((ScreenW - 100),10, 30, 30);
    [self.but1 setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
    self.iscollection = NO;
    
    int m=0;
    for (NSString *string in self.scid) {
         NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *st = [numberFormatter stringFromNumber:self.ar_id];
        m++;
        if ([st isEqualToString:string]) {
            self.keep_id = self.sckeepid[m-1];
            self.iscollection = YES;
            [self.but1 setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
        }
    }
    
    [self.but1 addTarget:self action:@selector(collectMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.but1];
    
    self.but2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.but2.frame = CGRectMake((ScreenW - 50),10, 30, 30);
    [self.but2 setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.but2 addTarget:self action:@selector(shareMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.but2];
    
   // self.textview.frame = CGRectMake(10, 5, ScreenW-100*Kscalew, 70);
    
    self.but3 = [UIButton buttonWithType:UIButtonTypeCustom];
    //self.but3.frame = CGRectMake(ScreenW-100*Kscalew+15, 10, 80*Kscalew, 60*Kscalew);
    self.but3.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    [self.but3 setTitle:@"发送" forState:UIControlStateNormal];
    [self.but3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.but3 addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.but3.hidden = YES;
    self.but3.layer.masksToBounds = YES;
    self.but3.layer.cornerRadius = 3;
    [self.toolView addSubview:self.but3];
    
   // [self.view addSubview:self.toolView];
    
    
}

//点击return键，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    
    
    self.but.hidden = YES;
    self.but1.hidden = YES;
    self.but2.hidden = YES;
    self.lab.hidden = YES;
    self.but3.hidden = NO;
    //self.textfield.hidden = YES;
    //self.textview.hidden = NO;
    [self.view bringSubviewToFront:self.toolView];

    self.textfield = textField;
    return YES;
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.but.hidden = YES;
    self.but1.hidden = YES;
    self.but2.hidden = YES;
    self.lab.hidden = YES;
    self.but3.hidden = NO;
    //self.textfield.hidden = YES;
    //self.textview.hidden = NO;
    [self.view bringSubviewToFront:self.toolView];
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}




//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    //一旦键盘遮挡了输入框,那么就抬起来
    
    NSDictionary* info = [aNotification userInfo];
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    
    
    if (CGRectGetMaxY(self.dowCommitBgviw.frame)>(self.view.height - kbSize.height)) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            CGFloat h = CGRectGetMaxY(self.dowCommitBgviw.frame) - (self.view.height - kbSize.height);
            
            self.dowCommitBgviw.transform = CGAffineTransformMakeTranslation(0, -h);
            
        }];
        
    }
    

    
    
    
    
    
    
    
    
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.toolView.frame = CGRectMake(0, ScreenH - height-50, ScreenW, 50);
    self.but3.frame = CGRectMake(ScreenW- 60, 5, 50, 40);
    self.textfield.frame =  CGRectMake(10, 5, ScreenW-80, 40);
    self.but.hidden = YES;
    self.but1.hidden = YES;
    self.but2.hidden = YES;
    self.lab.hidden = YES;
    self.but3.hidden = NO;
    //self.textfield.hidden = YES;
    //self.textview.hidden = NO;
    [self.view bringSubviewToFront:self.toolView];
    //[self.textview becomeFirstResponder];
    
    
    
    
    
    
    
    
//    if (self.dowCommitBgviw) {
//        
//        if (self.dowCommitBgviw.center.y > (ScreenH - 200)) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:1];
//            [UIView setAnimationDelegate:self];
//            [UIView setAnimationDelay:0];
//            [UIView setAnimationBeginsFromCurrentState:YES];
//            [UIView setAnimationRepeatAutoreverses:NO];
//            [UIView setAnimationRepeatCount:0];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
//            CGPoint center = self.dowCommitBgviw.center;
//            center.y -= height;
//            self.dowCommitBgviw.center = center;
//            //提交动画
//            [UIView commitAnimations];
//            
//        }
//
//       
//    }
    
    
    
    
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.toolView.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
    self.but.hidden = NO;
    self.but1.hidden = NO;
    self.but2.hidden = NO;
    self.lab.hidden = NO;
    self.but3.hidden = YES;
    //self.textview.text = nil;
    //self.textfield.hidden = NO;
    //self.textview.hidden = YES;
    
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    
  
    

        
        [UIView animateWithDuration:0.5 animations:^{
            
  

            self.dowCommitBgviw.transform = CGAffineTransformMakeTranslation(0, 0);
            
       }];
        
    
    
    
    

}

- (void)collectMessage:(UIButton *)sender {
    NSString *ddd= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *teddx= [ddd stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:teddx encoding:NSUTF8StringEncoding error:nil];
    if (str == nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再添加收藏" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
//            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            user.moviedetails = @"movie";
            [self presentViewController:user animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];

        
    }else {
        if (self.iscollection == NO) {
            /////11111
            [self lodCollection:sender];
        }else {
            [self deleatcollection:sender];
        }
        _iscollection = !_iscollection;
    }
    
}

- (void)deleatcollection:(UIButton *)buttt {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *dic = @{@"keep_id":self.keep_id};
    [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/delkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
             // NSLog(@"%@",[dicc objectForKey:@"Message"]);
             [buttt setImage:[UIImage imageNamed:@"newSC"] forState:UIControlStateNormal];
              [weakSelf lodCollectionList];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//shoucang  list
- (void)lodCollectionList {
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    __weak typeof(self) weakSelf = self;
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *urlstr = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/keep/index/ptuid/%@",str];
    
    [session GET:urlstr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        NSMutableArray *array = [MineSCModel mj_objectArrayWithKeyValuesArray:arr];
        
        [weakSelf.scid removeAllObjects];
        [weakSelf.sckeepid removeAllObjects];
        
        for (MineSCModel *model in array) {
            [weakSelf.scid addObject:model.id];
            [weakSelf.sckeepid addObject:model.keep_id];
        }
         [weakSelf setupToolBar];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
/////11111
- (void)lodCollection:(UIButton *)buttt {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = @{@"ptuid":str,@"ar_id":self.ar_id,@"type":self.ar_type};
   
    [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/addkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        weakSelf.keep_id = [dicc objectForKey:@"keep_id"];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            [buttt setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            [weakSelf lodCollectionList];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



- (void)shareMessage:(UIButton *)sender {
//    self.vie.hidden = NO;
//    [self.view bringSubviewToFront:self.vie];
    [self addGuanjiaShareView];
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
    
   self.shareView = [[HXEasyCustomShareView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.shareView.backView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.shareView.headerView = headerView;
    float height = [self.shareView getBoderViewHeight:shareAry firstCount:7];
    self.shareView.boderView.frame = CGRectMake(0, 0, self.shareView.frame.size.width, height);
    self.shareView.middleLineLabel.hidden = YES;
    [self.shareView.cancleButton addSubview:lineLabel1];
    self.shareView.cancleButton.frame = CGRectMake(self.shareView.cancleButton.frame.origin.x, self.shareView.cancleButton.frame.origin.y, self.shareView.cancleButton.frame.size.width, 54);
    self.shareView.cancleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareView.cancleButton setTitleColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.shareView setShareAry:shareAry delegate:self];
    [self.view addSubview:self.shareView];
    
    [self.tabBarController.tabBar bringSubviewToFront:headerView];
}
#pragma mark HXEasyCustomShareViewDelegate
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    
    NSString *strr = @"驻马店广播电视台";
    if ([title isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = strr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.ar_pic];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.artitle image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [self.player play];
               
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [UMSocialData defaultData].extConfig.title = self.artitle;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.ar_pic];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.shareurl image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [self.player play];
                }
            self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = strr;
        [UMSocialData defaultData].extConfig.qqData.url = self.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.ar_pic];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.artitle image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [self.player play];
                
            }
            self.shareView.hidden = YES;
        }];

    }
    if ([title isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = self.artitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = self.shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.ar_pic];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.artitle image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [self.player play];
               
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"新浪微博"]) {
        UMSocialUrlResource *result = [[UMSocialUrlResource alloc]initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.ar_pic];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@ %@",self.artitle,self.shareurl] image:[UIImage imageNamed:@"11111"] location:nil urlResource:result presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                [self.player play];
            }
            self.shareView.hidden = YES;
        }];
    }
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 99876) {
        return 2;
    } //else if(tableView.tag == 99875){
        return 1;
    //}
   // return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 99876) {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.array.count;
    }
    } //else if (tableView.tag == 99875){
    
    return _contentarr.count;
   // }
   // return 0;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textfield resignFirstResponder];
    //[self.textview resignFirstResponder];
    
    if (indexPath.section == 1) {
    zmdmodel *model = [self.array objectAtIndex:indexPath.row];
    [Manager sharedManager].movieURL = model.ar_movieurl;
    self.ar_id = model.ar_id;
        
        [self removeObserverFromeAvplayerItem:self.item];
        [self.layer removeFromSuperlayer];
        
        self.item=[AVPlayerItem playerItemWithURL:[NSURL URLWithString:[Manager sharedManager].movieURL]];
        self.player=[AVPlayer playerWithPlayerItem:self.item];
        self.layer=[AVPlayerLayer playerLayerWithPlayer:self.player];
        self.layer.videoGravity=AVLayerVideoGravityResizeAspect;
        self.layer.backgroundColor=[[UIColor blackColor]CGColor];//给框一个颜色
        [self.avPlayer.layer addSublayer:self.layer];//添加到视图上
        
        [self addCurrentTimeTimer];
        
        [self addObserverToPlayerItem:self.item];
        
        [self.slider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        [self.slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
        
        [self nstime];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(isNotHidden:)];
        [self.avPlayer addGestureRecognizer:tap];
        
        [self.player play];
        
        //增加监听，当键盘出现或改变时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        //增加监听，当键退出时收出消息
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        if (self.ar_id != nil) {
            
            [self lodDetailsInformation];
        }
        
        [self request];
        
       
        
        [self commandList];
        [self lodCollectionList];
        
        [self.avPlayer bringSubviewToFront:self.fuZhuView];
       
        [Manager setupclicknum:model.ar_type arid:model.ar_id];
    }
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return 5;
//    }
//    return 0;
//}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 5)];
//    lab.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.5];
//    lab.textColor = [UIColor redColor];
//    if (section == 0) {
//       
//        //lab.text = @"   ◈相关新闻";
//        return nil;
//    }else if (section == 1) {
//        
//        //lab.text = @"   ◈评论列表";
//        //lab.textAlignment = NSTextAlignmentCenter;
//    }
//    return lab;
    
    if (tableView.tag == 99876) {
        return nil;
        
    } else{
        //评论header
        UIView *headerView = [[UIView alloc]init];
        headerView.backgroundColor = [UIColor whiteColor];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"commitpic"]];
        [headerView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(5);
            make.width.height.offset(30);
            
        }];
        
//        self.commitTextView = [[UITextView alloc]init];
//        [headerView addSubview:_commitTextView];
//        
//        [_commitTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(42);
//            make.top.bottom.right.offset(5);
//        }];
//        _commitTextView.delegate = self;
//        _commitTextView.text = @"我来说两句";
//        _commitTextView.textColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc]init];
        [headerView addSubview:label];
        label.text = @"我来说两句";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(42);
            make.top.offset(10);
            make.right.offset(-20);
            make.height.offset(40);
        }];
        label.textColor = [UIColor grayColor];
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commitPerform)];
        [label addGestureRecognizer:ges];
        
        
        return headerView;
    }
}
//跳转到写评论界面
- (void)commitPerform{
    [self.view bringSubviewToFront:_writeCommitBgviw];
    CGFloat bian = ([UIScreen mainScreen].bounds.size.height);

    [UIView animateWithDuration:0.5 animations:^{
        self.writeCommitBgviw.transform = CGAffineTransformMakeTranslation(0, -bian);
        
    }];
    
    
    
//    CGFloat sss = _writeCommitBgviw.frame.origin.y;
//    CGFloat viewsss = [UIScreen mainScreen].bounds.size.height / 2;
//    
//    CGFloat bian = ([UIScreen mainScreen].bounds.size.height);
//    
//  
//        if (sss>viewsss) {
//            CGPoint centerDian = self.writeCommitBgviw.center;
//            centerDian.y -= bian;
//            self.writeCommitBgviw.center = centerDian;
//        }
//        if (sss<viewsss) {
//            // _commitBgviw.centerY = 230;
//            CGPoint centerDian = self.commitBgviw.center;
//            centerDian.y += bian;
//            self.commitBgviw.center = centerDian;
//            
//        }
    
        

    
    
//    
//    ZMDCommitDetaileViewController *com = [[ZMDCommitDetaileViewController alloc]init];
//    
// [self presentViewController:com animated:YES completion:nil];
//

}
#pragma mark - UITextViewDelegate


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 99876) {
        return 0.01;
        
    } else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 99876) {
 
     
    if (indexPath.section == 1) {
        ZMDNNewfirstMoviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellC" forIndexPath:indexPath];
        zmdmodel *model = [self.array objectAtIndex:indexPath.row];

        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:model.ar_pic]placeholderImage:[UIImage imageNamed:@"hui"]];
        cell.titLablel.text = [NSString stringWithFormat:@"%@",model.ar_title];
        
  //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 0){
        ZMDNNewMovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellB" forIndexPath:indexPath];
        cell.commitLabel.text = [NSString stringWithFormat:@"%@",self.commitNumber];
        cell.titleNameLabel.text = [NSString stringWithFormat:@"%@",self.string];
        if (_commitBgviw.frame.origin
            .y == ([UIScreen mainScreen].bounds.origin.y + [UIScreen mainScreen].bounds.size.height)) {
             [cell.commitButton setImage:[UIImage imageNamed:@"dowJT.png"] forState:UIControlStateNormal];
        }
       
        [cell.commitButton addTarget:self action:@selector(showCommit:) forControlEvents:UIControlEventTouchUpInside];
        [cell.downloadButton addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    //   [cell.shouCangButton addTarget:self action:@selector(shouCangButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    

        self.iscollection = NO;
        int m=0;
        for (NSString *string in self.scid) {
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *st = [numberFormatter stringFromNumber:self.ar_id];
            m++;
            if ([st isEqualToString:string]) {
                self.keep_id = self.sckeepid[m-1];
                self.iscollection = YES;
                [cell.shouCangButton setImage:[UIImage imageNamed:@"selecterSC.png"] forState:UIControlStateNormal];
            }
        }

        
       [cell.shouCangButton addTarget:self action:@selector(collectMessage:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
        
    }
   // else if (tableView.tag == 99875){
    ZMDNNewCommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commitcffffell" forIndexPath:indexPath];
    commonmodel *model = [self.contentarr objectAtIndex:indexPath.row];
   // NSLog(@"uuuuuuu%@",model.nickname);
    
//    [cell.userimg sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"hui"]];
//    cell.userlab.text = [[WordFilter sharedInstance] filter:model.nickname];
//    
//    cell.userlab.numberOfLines = 0;
//    
//    cell.timeAndCommendnumlab.text = [NSString stringWithFormat:@"%@ .回复",model.saytime];
//    
//    cell.userimg.contentMode = UIViewContentModeScaleAspectFill;
//    
//    cell.zannum.text = model.zcnum;
//    
//    cell.contentlab.text = model.saytext;
//    
//    //[Manager sharedManager].pingLunString = cell.contentlab.text;
//    cell.deletebtn.hidden = YES;
//    if ([model.userid isEqualToString:deleteCommonString]) {
//        cell.deletebtn.hidden = NO;
//        [cell.deletebtn addTarget:self action:@selector(deleteConmon:) forControlEvents:UIControlEventTouchUpInside];
//        cell.deletebtn.tag = indexPath.row;
//    }
//    
//    
//    cell.contentlab.font = [UIFont systemFontOfSize:16];
//    cell.contentlab.numberOfLines = 0;//根据最大行数需求来设置
//    cell.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
//    //关键语句
//    CGSize expectSize = [cell.contentlab sizeThatFits:maximumLabelSize];
//    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//    cell.contentlab.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
//    [Manager sharedManager].pingLunHeight = expectSize.height;
//    cell.contentlab.textAlignment = NSTextAlignmentLeft;
//    
//    [cell.zanbtn addTarget:self action:@selector(conmonCilckZan:) forControlEvents:UIControlEventTouchUpInside];
//    cell.zanbtn.tag = indexPath.row;
//    
//    if ([[Manager sharedManager].mutSet containsObject:model.plid]) {
//        [cell.zanbtn setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
//        cell.zannum.textColor = [UIColor redColor];
//        cell.zanbtn.userInteractionEnabled = NO;
//    }else {
//        [cell.zanbtn setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
//        cell.zannum.textColor = [UIColor blackColor];
//        cell.zanbtn.userInteractionEnabled = YES;
//    }
    
    [cell.userImage sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.nameLabel.text = [[WordFilter sharedInstance] filter:model.nickname];
    
    
    
    
    cell.commitDetailLabel.text = model.saytext;

    cell.commitDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
        //关键语句
        CGSize expectSize = [cell.commitDetailLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        cell.commitDetailLabel.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
        [Manager sharedManager].pingLunHeight = expectSize.height;
        cell.commitDetailLabel.textAlignment = NSTextAlignmentLeft;
        

    cell.commitDetailLabel.numberOfLines = 0;
    
    cell.timrLabel.text = [NSString stringWithFormat:@"%@",model.saytime];
    
    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.zanNumberLabel.text = [NSString stringWithFormat:@"%@",model.zcnum];
    
    
    //[Manager sharedManager].pingLunString = cell.contentlab.text;
    cell.deleteButton.hidden = YES;
    if ([model.userid isEqualToString:deleteCommonString]) {
        cell.deleteButton.hidden = NO;
        [cell.deleteButton addTarget:self action:@selector(deleteConmon:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row;
    }
    
    
    cell.commitDetailLabel.font = [UIFont systemFontOfSize:16];
    cell.commitDetailLabel.numberOfLines = 0;//根据最大行数需求来设置
//    cell.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
//    CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
//    //关键语句
//    CGSize expectSize = [cell.contentlab sizeThatFits:maximumLabelSize];
//    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//    cell.contentlab.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
//    [Manager sharedManager].pingLunHeight = expectSize.height;
    cell.commitDetailLabel.textAlignment = NSTextAlignmentLeft;
    
    [cell.zanButton addTarget:self action:@selector(conmonCilckZan:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanButton.tag = indexPath.row;
    
    if ([[Manager sharedManager].mutSet containsObject:model.plid]) {
        [cell.zanButton setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
        cell.zanNumberLabel.textColor = [UIColor redColor];
        cell.zanButton.userInteractionEnabled = NO;
    }else {
        [cell.zanButton setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        cell.zanNumberLabel.textColor = [UIColor blackColor];
        cell.zanButton.userInteractionEnabled = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    //}
   // return nil;
}


- (void)deleteConmon:(UIButton *)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    commonmodel *model = [self.contentarr objectAtIndex:sender.tag];
    
    __weak typeof(self) weakself = self;
    NSDictionary *par = @{@"plid":model.plid};
    //NSLog(@"-----%@",par);
    [session GET:@"http://zmdtt.zmdtvw.cn/api/pl/pldel" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        
        
        NSNumber *number = [dic objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            [weakself commandList];
        }
        [weakself.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 99876) {

    if (indexPath.section == 0) {
        return 160;
    }else if(indexPath.section == 1){
        return 100;
 
    }
    }
    return 100*Kscaleh + [Manager sharedManager].pingLunHeight +  20
    ;
    
}

- (void)conmonCilckZan:(UIButton *)sender
{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    commonmodel *model = [self.contentarr objectAtIndex:sender.tag];
    
    __weak typeof(self) weakself = self;
    NSDictionary *par = @{@"plid":model.plid};
    //NSLog(@"-----%@",par);
    [session GET:@"http://zmdtt.zmdtvw.cn/api/pl/plding" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        
        NSNumber *number = [dic objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        [[Manager sharedManager].mutSet addObject:model.plid];
        
        
        if ([code isEqualToString:@"0"] ) {
            //NSLog(@"评论顶66666");
            [weakself commandList];
        }
        [weakself.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)setUpComm {
    [self.tableview registerNib:[UINib nibWithNibName:@"ZmdmovieViewCell" bundle:nil] forCellReuseIdentifier:@"cellA"];
    
    [self.tableview registerNib:[UINib nibWithNibName:@"ZMDNNewMovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellB"];
    
    
    
  
    
    [self.tableview registerClass:[ZMDNNewfirstMoviewTableViewCell class] forCellReuseIdentifier:@"cellC"];
   [self.tableview registerNib:[UINib nibWithNibName:@"ZmdcommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    self.tableview.tag = 99876;

    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.estimatedRowHeight = 100;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
    
    
    self.commitTableView.tag = 99875;
    self.commitTableView = [[UITableView alloc]init];
    self.commitTableView.delegate = self;
    self.commitTableView.dataSource = self;
    [self.commitBgviw addSubview:_commitTableView];
    [self.commitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
        
        
        
    }];
    
    [self.commitTableView registerClass:[ZMDNNewCommendTableViewCell class] forCellReuseIdentifier:@"commitcffffell"];
    
self.commitTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    
//    _headervie = [[UIView alloc]init];
//    if (_shangxia == NO) {
//         _headervie.frame = CGRectMake(0, 0, ScreenW, 140) ;
//    }else {
//         _headervie.frame = CGRectMake(0, 0, ScreenW, 150) ;
//    }
//    _headervie.backgroundColor = [UIColor whiteColor];
//    
//    self.titlelable = [[UILabel alloc]initWithFrame:CGRectMake(17, 0, ScreenW-50, 60)];
//    self.titlelable.text = self.artitle;
//    self.titlelable.numberOfLines = 0;
//    [self.headervie addSubview:self.titlelable];
//    
////    self.sxbtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    self.sxbtn.frame = CGRectMake(ScreenW-40, 20, 20, 20);
////    [self.sxbtn setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
////    [self.sxbtn addTarget:self action:@selector(shangxia:) forControlEvents:UIControlEventTouchUpInside];
////    [self.headervie addSubview: self.sxbtn];
//    
//   UILabel *timelable  = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, ScreenW-150, 20)];
//    //_numlable.text = [NSString stringWithFormat:@"%@发布 | %@次播放",self.timeString,self.aronclicing];
//    timelable.text = [NSString stringWithFormat:@"%@",self.topTime];
//    timelable.textColor = [UIColor lightGrayColor];
//    timelable.font = [UIFont systemFontOfSize:14];
//    [self.headervie addSubview:timelable];
//    
//    
//    _dingbtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _dingbtn.frame = CGRectMake(ScreenW-70, 60, 20, 20);
//    if ([[Manager sharedManager].MovieMutSet containsObject:self.ar_id]) {
//        [_dingbtn setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
//        _dingbtn.userInteractionEnabled = NO;
//    }else {
//        [_dingbtn setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
//        _dingbtn.userInteractionEnabled = YES;
//    }
//    [_dingbtn addTarget:self action:@selector(ding) forControlEvents:UIControlEventTouchUpInside];
//    [self.headervie addSubview:_dingbtn];
//    
//    _dinglable  = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-45, 60, 45,20)];
//    _dinglable.text = [NSString stringWithFormat:@"%@",self.dddd];
//    _dinglable.font = [UIFont systemFontOfSize:14];
//    if ([[Manager sharedManager].MovieMutSet containsObject:self.ar_id]) {
//        _dinglable.textColor = [UIColor redColor];
//    }else {
//        _dinglable.textColor = [UIColor blackColor];
//    }
//    _dinglable.textAlignment = NSTextAlignmentLeft;
//    _dinglable.textColor = [UIColor lightGrayColor];
//    [self.headervie addSubview:_dinglable];
//    
//    _caibtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _caibtn.frame = CGRectMake(ScreenW-70, 60, 20, 20);
//    [_caibtn setImage:[UIImage imageNamed:@"Unknown"] forState:UIControlStateNormal];
//    [_caibtn addTarget:self action:@selector(cai) forControlEvents:UIControlEventTouchUpInside];
////    [self.headervie addSubview:_caibtn];
//    _cailable  = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-50, 60, 50,20)];
//    _cailable.text = [NSString stringWithFormat:@"%@",self.step];
//    _cailable.font = [UIFont systemFontOfSize:14];
//    _cailable.textColor = [UIColor lightGrayColor];
//    [self.headervie addSubview:_cailable];
    
//    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, ScreenW, 2)];
//    line.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
//    [self.headervie addSubview:line];
//    
//    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 138, ScreenW, 2)];
//    line1.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
//    [self.headervie addSubview:line1];
//
//   
//    self.touimage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 110, 20, 20)];
//    self.touimage.layer.masksToBounds = YES;
//    self.touimage.layer.cornerRadius = 10;
//    [self.touimage sd_setImageWithURL:[NSURL URLWithString:self.userpic]];
//    [self.headervie addSubview:self.touimage];
//    
//    self.toulable = [[UILabel alloc]initWithFrame:CGRectMake(40, 105, 150, 30)];
//    self.toulable.text = [NSString stringWithFormat:@"%@",self.arly];
//    self.toulable.font = [UIFont systemFontOfSize:16];
//   
//    [self.headervie addSubview:self.toulable];
//    
//    _DINGYUE = [UIButton buttonWithType:UIButtonTypeCustom];
//    _DINGYUE.frame = CGRectMake(ScreenW-80, 105, 70, 30);
//    [_DINGYUE setTitle:@"订阅＋" forState:UIControlStateNormal];
//    _DINGYUE.backgroundColor = [UIColor redColor];
//    int k=0;
//    for (NSString *string in self.dyid) {
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        NSString *st = [numberFormatter stringFromNumber:self.userid];
//        k++;
//        if ([st isEqualToString:string]) {
//            self.take_id = self.dytakeid[k-1];
//            self.DingYue = YES;
//             [_DINGYUE setTitle:@"已订阅" forState:UIControlStateNormal];
//            _DINGYUE.backgroundColor = [UIColor lightGrayColor];
//        }
//    }
//     [_DINGYUE addTarget:self action:@selector(dingyue:) forControlEvents:UIControlEventTouchUpInside];
//    
//    _DINGYUE.layer.masksToBounds = YES;
//    _DINGYUE.layer.cornerRadius = 8;
//    [_DINGYUE setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    _DINGYUE.titleLabel.textAlignment = NSTextAlignmentCenter;
//    _DINGYUE.titleLabel.font = [UIFont systemFontOfSize:16];
//   
//    [self.headervie addSubview:_DINGYUE];
    
    
   // CGRectMake(20, 60, ScreenW-150, 20)
    
//    _numlable  = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-130, 105, 115, 30)];
//    //_numlable.text = [NSString stringWithFormat:@"%@发布 | %@次播放",self.timeString,self.aronclicing];
//    _numlable.text = [NSString stringWithFormat:@"%@次播放",self.aronclicing];
//    _numlable.textColor = [UIColor lightGrayColor];
//    _numlable.textAlignment  = NSTextAlignmentRight;
//    _numlable.font = [UIFont systemFontOfSize:14];
//    [self.headervie addSubview:_numlable];
    
  //  self.tableview.tableHeaderView = self.headervie;

}

//- (void)shangxia:(UIButton *)sender {
//    if (_shangxia == NO) {
//        [self.sxbtn setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
//        //_headervie.frame = CGRectMake(0, 0, ScreenW, 150) ;
////        self.tableview.frame = CGRectMake(0, 280, ScreenW, ScreenH);
//        
//    }else{
//        [self.sxbtn setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
//         //_headervie.frame = CGRectMake(0, 0, ScreenW, 90) ;
////         self.tableview.frame = CGRectMake(0, 220, ScreenW, ScreenH);
//       
//
//    }
//    _shangxia = !_shangxia;
//}

- (void)ding {
    
    [[Manager sharedManager].MovieMutSet addObject:self.ar_id];
    
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
     __weak typeof(self) weakself = self;
        NSDictionary *par = @{@"ar_id":self.ar_id};
        [session GET:@"http://zmdtt.zmdtvw.cn/api/index/movieding" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            if ([code isEqualToString:@"0"] ) {
             //NSLog(@"顶66666");
                
                
                [weakself lodClickZanAndCaiNum];
            }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    
}

- (void)lodClickZanAndCaiNum {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",self.ar_id,self.ar_type];
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err] ;
        weakSelf.dddd = [dic objectForKey:@"ar_ding"];
        
        weakSelf.step = [dic objectForKey:@"ar_step"];
        
        //self.onclick = [dic objectForKey:@"ar_onclick"];
        
        
        
        //self.aronclicing = [dic objectForKey:@"ar_onclick"];
        
        weakSelf.volume = [dic objectForKey:@"ar_volume"];
        weakSelf.userid = [dic objectForKey:@"ar_userid"];
        weakSelf.artitle = [dic objectForKey:@"ar_title"];
        weakSelf.shareurl = [dic objectForKey:@"shareurl"];
        weakSelf.userpic = [dic objectForKey:@"ar_userpic"];
        weakSelf.arly = [dic objectForKey:@"ar_ly"];
        weakSelf.movieURL = [dic objectForKey:@"ar_movieurl"];
        weakSelf.ar_pic = [dic objectForKey:@"ar_pic"];
        weakSelf.ar_cateid = [dic objectForKey:@"ar_cateid"];
        weakSelf.ar_id = [dic objectForKey:@"ar_id"];
        weakSelf.topTime = [Manager timeWithTimeIntervalString:[dic objectForKey:@"ar_time"]];
        
        [weakSelf setupToolBar];
        
        [weakSelf setUpComm];
        
        // NSLog(@"   ///////////    %@",self.artitle);
        [weakSelf.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)cai {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakself = self;
    NSDictionary *par = @{@"ar_id":self.ar_id};
    [session GET:@"http://zmdtt.zmdtvw.cn/api/index/moviestep" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        NSNumber *number = [dic objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
             //NSLog(@"踩6666");
            
            [weakself lodClickZanAndCaiNum];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}



- (void)lodDetailsInformation {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
 
    
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",self.ar_id,self.ar_type];
   __weak typeof(self) weakself = self;
    
     [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err] ;
         
        //NSLog(@"dic======%@",dic);
         
        weakself.dddd = [dic objectForKey:@"ar_ding"];
         
        weakself.step = [dic objectForKey:@"ar_step"];
         
        weakself.onclick = [dic objectForKey:@"ar_onclick"];
         
        
         
         weakself.aronclicing = [dic objectForKey:@"ar_onclick"];
         
        weakself.volume = [dic objectForKey:@"ar_volume"];
        weakself.userid = [dic objectForKey:@"ar_userid"];
        weakself.artitle = [dic objectForKey:@"ar_title"];
        weakself.shareurl = [dic objectForKey:@"shareurl"];
        weakself.userpic = [dic objectForKey:@"ar_userpic"];
        weakself.arly = [dic objectForKey:@"ar_ly"];
        weakself.movieURL = [dic objectForKey:@"ar_movieurl"];
        weakself.ar_pic = [dic objectForKey:@"ar_pic"];
        weakself.ar_cateid = [dic objectForKey:@"ar_cateid"];
        weakself.ar_id = [dic objectForKey:@"ar_id"];
        weakself.topTime = [Manager timeWithTimeIntervalString:[dic objectForKey:@"ar_time"]];
         
        [weakself setupToolBar];
        
        [weakself setUpComm];
         
       // NSLog(@"   ///////////    %@",self.artitle);
        [weakself.tableview reloadData];
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



- (void)dingyue:(UIButton *)sender {
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil) {
        if (self.DingYue == NO) {
            [self adddingyue];
        }else {
            [self quxiaodingyue];
        }
        _DingYue = !_DingYue;
    }else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再添加订阅" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

}




//dingyue list
- (void)dingYueList {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil) {
        NSDictionary *par = @{@"uid":str};
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/index" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            
            NSMutableArray *array = [MineDYModel mj_objectArrayWithKeyValuesArray:arr];
            
            [weakSelf.dyid removeAllObjects];
            [weakSelf.dytakeid removeAllObjects];
            for (MineDYModel *model in array) {
                [weakSelf.dyid addObject:model.userid];
                [weakSelf.dytakeid addObject:model.take_id];
            }
             [weakSelf setUpComm];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
}

/**
 *  订阅
 *
 */

- (void)adddingyue {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    if (str != nil) {
        NSDictionary *par = @{@"pt_uid":str,@"uid":self.userid};
        
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/adtake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            //NSLog(@"****dingyue*** %@",dic );
            
            self.take_id = [dic objectForKey:@"take_id"];
            
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                //NSLog(@"**** 88888 %@",[dic objectForKey:@"Message"]);
                 [_DINGYUE setTitle:@"已订阅" forState:UIControlStateNormal];
                _DINGYUE.backgroundColor = [UIColor lightGrayColor];
                 [self dingYueList];
            }
            //[MBProgressHUD hideHUDForView:self.DINGYUE animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //[MBProgressHUD hideHUDForView:self.DINGYUE animated:YES];
        }];
    }
    
}



- (void)quxiaodingyue {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
   
    if (self.userid != nil) {
        NSDictionary *par = @{@"take_id":self.take_id};
        
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/deltake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            if ([code isEqualToString:@"0"] ) {
                //NSLog(@"****  %@",[dic objectForKey:@"Message"]);
                [_DINGYUE setTitle:@"订阅＋" forState:UIControlStateNormal];
                _DINGYUE.backgroundColor = [UIColor redColor];
                [self dingYueList];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}



- (void)sendMessage:(UIButton *)sender {
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    
//    if (str != nil) {
//        
//        self.textfield.text = [[WordFilter sharedInstance] filter:self.textfield.text];
//        [self addCommand];
//        
//    }else {
//        [self.textfield resignFirstResponder];
//        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再发表评论" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }];
//        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
////            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
//            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            user.moviedetails = @"movie";
//            [self presentViewController:user animated:YES completion:nil];
//            
//        }];
//        [alertVC addAction:actionsure];
//        [alertVC addAction:actionsure1];
//        [self presentViewController:alertVC animated:YES completion:nil];
//    }
    
    
    if (str != nil) {
        
        self.commitTextView.text = [[WordFilter sharedInstance] filter:self.commitTextView.text];
        [self addCommand];
        
    }else {
        [self.commitTextView resignFirstResponder];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再发表评论" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
            //            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            user.moviedetails = @"movie";
            [self presentViewController:user animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

    
    
}


- (void)commendNumber:(UIButton *)sender {
    
    if (self.islocation == NO) {
        if (self.contentarr.count != 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [[self tableview] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else {
        if (self.array.count != 0) {
            NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [[self tableview] scrollToRowAtIndexPath:scrollIndexPath
                                    atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }
    _islocation = !_islocation;
}


/**
 *  评论
 */
- (void)addCommand {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *AdocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *AtextFilePath = [AdocumentsPath stringByAppendingPathComponent:@"username.text"];
    //3.通过路径获取数据
    NSString *string = [NSString stringWithContentsOfFile:AtextFilePath encoding:NSUTF8StringEncoding error:nil];
    __weak typeof(self) weakSelf = self;
    if (str != nil && string != nil){
        
        NSDictionary *para = @{@"username":string,@"id":self.ar_id,@"classid":self.ar_cateid,@"userid":str,@"saytext":self.commitTextView.text};
        
        [session POST:@"http://zmdtt.zmdtvw.cn/Api/Pl/add/" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            if ([code isEqualToString:@"0"] ){
                [weakSelf commandList];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}


- (void)commandList {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    if (self.ar_id != nil && self.ar_cateid != nil) {
        NSDictionary *para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":@"0"};
        
        [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
            
            [weakSelf.contentarr removeAllObjects];
            NSMutableArray *arrrr = [NSMutableArray arrayWithCapacity:1];
            for (commonmodel *model in array) {
                [arrrr addObject:model];
                shanglaPage = [model.plid integerValue];
            }
            weakSelf.contentarr = arrrr;
            [weakSelf.tableview reloadData];
            weakSelf.textfield.text = nil;
            weakSelf.textfield.placeholder = @" 写评论。。。";
            [weakSelf.textfield resignFirstResponder];
            [self quxiaoButton];
            
            
                        [weakSelf.commitTableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    
}


//刷新数据
-(void)setUpReflashShangLa
{
    __weak typeof (self) weakSelf = self;
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf lodshangla];
        
    }];
    
}


- (void)lodshangla{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    if (self.ar_id != nil && self.ar_cateid != nil) {
        NSDictionary *para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage]};
        [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
            
            for (commonmodel *model in array) {
                [weakSelf.contentarr addObject:model];
                shanglaPage = [model.plid integerValue];
            }
            
            [weakSelf.tableview reloadData];
            [weakSelf.tableview.mj_footer endRefreshing];
            weakSelf.textfield.text = nil;
            weakSelf.textfield.placeholder = @" 写评论。。。";
            [weakSelf.textfield resignFirstResponder];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

- (void)answercommand{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *para = @{@"pubid":@"",@"plid":@"0"};
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/hf" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


//展示评论
-(void)showCommit:but{
    CGFloat sss = _commitBgviw.frame.origin.y;
    CGFloat viewsss = [UIScreen mainScreen].bounds.size.height / 2;
    
    CGFloat bian = ([UIScreen mainScreen].bounds.size.height - 265);
    

    if (!_isZhNKAI) {
        _isZhNKAI = !_isZhNKAI;
        [but setImage:[UIImage imageNamed:@"NewCha"] forState:UIControlStateNormal];
      //  NSLog(@"展示评论");
      //  NSLog(@"9999999u%fuuu%f",sss,viewsss);
      //  [self.commitTableView reloadData];
        if (sss>viewsss) {
            CGPoint centerDian = self.commitBgviw.center;
            centerDian.y -= bian;
             self.commitBgviw.center = centerDian;
        }
        
        
    } else {
        _isZhNKAI = !_isZhNKAI;
        [but setImage:[UIImage imageNamed:@"dowJT"] forState:UIControlStateNormal];
     //   NSLog(@"关闭评论");
        if (sss<viewsss) {
           // _commitBgviw.centerY = 230;
            CGPoint centerDian = self.commitBgviw.center;
            centerDian.y += bian;
            self.commitBgviw.center = centerDian;
            
        }
        

    }
}

//下载
-(void)downloadAction{
    NSLog(@"下载");
    
    
    
      
    
    
    
    
    
    
    
    
    
    
}
//收藏
- (void)shouCangButtonAction:(UIButton *)but{
    //[but setImage:[UIImage imageNamed:@"newSC.png"] forState:UIControlStateNormal];
    self.iscollection = NO;
    int m=0;
    for (NSString *string in self.scid) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *st = [numberFormatter stringFromNumber:self.ar_id];
        m++;
        if ([st isEqualToString:string]) {
            self.keep_id = self.sckeepid[m-1];
            self.iscollection = YES;
            [self.but1 setImage:[UIImage imageNamed:@"selecterSC.png"] forState:UIControlStateNormal];
        }
    }
    
    [but addTarget:self action:@selector(collectMessage:) forControlEvents:UIControlEventTouchUpInside];
}
//分享
- (void)shareButtonAction:(UIButton *)but{
    //NSLog(@"分享");
    [self shareMessage:but];
    
}
@end
