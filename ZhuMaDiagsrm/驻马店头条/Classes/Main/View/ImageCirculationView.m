//
//  ImageCirculationView.m
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/6.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ImageCirculationView.h"
#import "ZMDNcirculationModel.h"
#import "ZMDNCommonClass.h"
#import "ZMDNNetWorkStata.h"
#import "ZMDNPicContentViewController.h"
#import "ZMDPlayerViewController.h"

static NSString *shouyeimageCasher = @"SYlunboCasher";

@interface ImageCirculationView ()

{
    BOOL timeUp;
}


@property(nonatomic, strong) NSArray * circulateModelArr;

@property(nonatomic,strong) UIImageView * leftImageView ;

@property(nonatomic,strong) UIImageView * centerImageView ;

@property(nonatomic,strong) UIImageView * rightImageView ;

@property(nonatomic, strong) NSTimer *timer;






@end

@implementation ImageCirculationView


- (instancetype)init {
    if (self = [super init]) {
        self.descView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        
        
        [self getDataFromlocal];
        
        [self downLoadImage];
        
        
        [self addImageScroll];
        [self addImageViews];
        [self addDescView];
       //[self addImagePageControl];
        [self addImageTitle];
        [self addPageTag];
        
        
        
        timeUp = NO;
        
    }
    return self;
}





//设置滚动视图
-(void)addImageScroll
{
   
    
    CGRect bouns = self.bounds;
    
    self.imageScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, bouns.size.height)];
    
    [self addSubview:_imageScroll];
    
    self.imageScroll.bounces = NO;
    // 拖动时没有线条
    self.imageScroll.showsHorizontalScrollIndicator = NO;
    
    self.imageScroll.showsVerticalScrollIndicator = NO;
    
    //一次滚动一页和下面的方法一起使用
    self.imageScroll.pagingEnabled = NO;
    
    //当前显示区域的顶点相对于frame顶点的偏移量
    self.imageScroll.contentOffset = CGPointMake(ScreenW, 0);
    
    // 滚动的区域的大小
    self.imageScroll.contentSize = CGSizeMake(ScreenW * 3, bouns.size.height);
    
    //代理
    self.imageScroll.delegate = self;
    
    
}



-(NSArray *)circulateModelArr
{
    if (!_circulateModelArr)
    {
        _circulateModelArr = [[NSArray alloc] init];
    }
    
    return _circulateModelArr;
}


-(void)addImagePageControl
{
    
    _imagePageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
    
    [self addSubview:_imagePageControl];
    
    _imagePageControl.numberOfPages = _circulateModelArr.count;
    
    _imagePageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    _imagePageControl.pageIndicatorTintColor = [UIColor redColor];
    
    _currentImageIndex = 0;
    //设置当前页
    _imagePageControl.currentPage = _currentImageIndex;
}




-(void)addDescView
{
    _descView = [[UIView alloc] initWithFrame:CGRectMake(0,  self.bounds.size.height -40, ScreenW, 40)];
    _descView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
    
    [self  addSubview:_descView];
}





-(void)addImageTitle
{
    _imageTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0 , ScreenW - 55, 40)];
    _imageTitle.textColor = [UIColor whiteColor];
    _imageTitle.font = [UIFont systemFontOfSize:18.0];
    _imageTitle.textAlignment = NSTextAlignmentLeft;
    [self.descView  addSubview:_imageTitle];
}




//添加图片视图
-(void)addImageViews
{
        _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 250*Kscaleh)];
        _leftImageView.contentMode=UIViewContentModeScaleAspectFill;
        _leftImageView.clipsToBounds = YES;
        _rightImageView.userInteractionEnabled = YES;
        //_rightImageView.image = [UIImage imageNamed:@"image"];
        [self.imageScroll addSubview:_leftImageView];
        
        
        _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenW , 0, ScreenW, 250*Kscaleh)];
        _centerImageView.contentMode= UIViewContentModeScaleAspectFill;
        _centerImageView.clipsToBounds = YES;
        _centerImageView.userInteractionEnabled = YES;
        //_centerImageView.image = [UIImage imageNamed:@"image"];
        [self.imageScroll addSubview:_centerImageView];
        
        
        _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*ScreenW, 0, ScreenW, 250*Kscaleh)];
        _rightImageView.contentMode=UIViewContentModeScaleAspectFill;
        _rightImageView.clipsToBounds = YES;
        _rightImageView.userInteractionEnabled = YES;
        // _rightImageView.image = [UIImage imageNamed:@"image"];
        [self.imageScroll addSubview:_rightImageView];
        
    
}




//下一页
-(void)nextPage
{
    
    [self.imageScroll setContentOffset:CGPointMake(ScreenW * 2, 0) animated:YES];
    
    timeUp = YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:shouyeimageCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self downLoadImage];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
            [self.timer fire];
            
        });
        
    });
}

- (void)hhhhhhhhhh:(id)imageArr{
    
    NSArray *circulateImageArr = [ZMDNcirculationModel mj_objectArrayWithKeyValuesArray:imageArr];
    self.circulateModelArr = circulateImageArr;
    
}



-(void)downLoadImage
{
    
    
    //[MBProgressHUD showHUDAddedTo:self animated:YES];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    [session GET:CIRCULATIONIMAGEURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *imageArr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
        
       // NSLog(@"^^^^^^^%@",imageArr);
       // [ZMDNCommonClass savePlistDataWithArr:imageArr andPlistName:@"loopImage.plist"];
      
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:shouyeimageCasher];
            
            [imageArr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhh:imageArr];
        
        
        [MBProgressHUD hideHUDForView:self animated:YES];
            
           
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
             [MBProgressHUD hideHUDForView:self animated:YES];
        });
      
        //NSLog(@"%@",error);
    }];
    
}









//显示当前图片页数
-(void)addPageTag
{
    _pageLable = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW -40, 5, 40, 30)];
    [ self.descView addSubview:_pageLable];
    
    _pageLable.font = [UIFont systemFontOfSize:17.0];
    _pageLable.textAlignment = NSTextAlignmentCenter;
    [_pageLable setTextColor:[UIColor whiteColor]];
}


#pragma mark --UIScrollView的代理

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.circulateModelArr.count != 0) {
        
         [self reloadImage];
        
    }
   
    //移动到中间
    [self.imageScroll setContentOffset:CGPointMake(ScreenW, 0) animated:NO];
    
}





// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [self.timer fire];
    
    
}




//重新加载图片

-(void)reloadImage
{
    NSInteger leftImageIndex, rightImageIndex;
    
    NSInteger imagecount = _circulateModelArr.count;
    
    CGPoint offset = [self.imageScroll contentOffset];
    
    if (offset.x > ScreenW)
    {//向右滑动
        if (imagecount != 0) {
            _currentImageIndex = (_currentImageIndex+1)%imagecount;
        }
    }
    else if (offset.x < ScreenW)
    {
        //向左滑动
        self.imageScroll.pagingEnabled = NO;
        _currentImageIndex=(_currentImageIndex+imagecount-1)%imagecount;
        
    }
    
    
    ZMDNcirculationModel *currentImageModel = _circulateModelArr[_currentImageIndex];
    
    
    _imageTitle.text = currentImageModel.ar_title;
    
    _pageLable.text = [NSString stringWithFormat:@"%lu/%lu", (_currentImageIndex+1),(unsigned long)_circulateModelArr.count];
    
    self.imagePageControl.currentPage = _currentImageIndex;
    
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:currentImageModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail)];
    tap.numberOfTouchesRequired =1;
    tap.numberOfTapsRequired = 1;
    [_centerImageView addGestureRecognizer:tap];
    
    //重新设置左右图片
    leftImageIndex=(_currentImageIndex+imagecount-1)%imagecount;
    rightImageIndex=(_currentImageIndex+1)%imagecount;
    
    ZMDNcirculationModel *leftModel = _circulateModelArr[leftImageIndex];
    ZMDNcirculationModel *rightModel = _circulateModelArr[rightImageIndex];
    
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:leftModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
    
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:rightModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
}




////请求视频链接
//-(void)loadTheMovieUrlWithMovieUrl:(NSString *)htmlUrl withTitle:(NSString *)title
//{
//    
//    
//    ZMDPlayerViewController *zmdPlayer = [[ZMDPlayerViewController alloc] init];
//    
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    
//    session.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    session.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    __weak typeof(self) weakself = self;
//    __weak typeof (zmdPlayer) weakPlayer =  zmdPlayer;
//    
//    [session GET:htmlUrl parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
//     {
//         
//         NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//         NSData* madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
//         NSError *err;
//         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableContainers error:&err];
//         zmdPlayer.string = title;
//         zmdPlayer.movieURL = [dic objectForKey:@"ar_movieurl"];
//         UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:weakPlayer];
//        
//         
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         
//        //NSLog(@"%@",error);
//     }];
//    
//    
//}



-(void)showDetail
{
    
    ZMDNcirculationModel *clickModel = _circulateModelArr[_currentImageIndex];
    NSString *htmlUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%ld&type=%ld",(long)clickModel.id,(long)clickModel.ar_type];
    
//    if ((long)clickModel.ar_type == 4)
//    {
//        [self loadTheMovieUrlWithMovieUrl:htmlUrl withTitle:(long)clickModel.ar_type];
//    }
//    
//    else if ((long)clickModel.ar_type == 5)
//    {
//        ZMDNPicContentViewController *picContentVc = [[ZMDNPicContentViewController alloc] init];
//        picContentVc.manyPicLink = htmlUrl;
//       
//    }
    
    
    if (self.clickDelege && [self.clickDelege respondsToSelector:@selector(circulationView:clickThePhotoWithTitle:andUrl:andInter:anid:andareid:anduserpic:andwl:andtime:andcname:andpicture:andstate:)])
    {
        
        
        
        [self.clickDelege circulationView:self clickThePhotoWithTitle:clickModel.ar_title andUrl:htmlUrl andInter:(long)clickModel.ar_type anid:(long)clickModel.id andareid:(long)clickModel.ar_id anduserpic:clickModel.ar_userpic andwl:clickModel.ar_wl andtime:clickModel.ar_time andcname:clickModel.cname andpicture:clickModel.ar_pic andstate:clickModel.state];
        
    }
    
}










@end
