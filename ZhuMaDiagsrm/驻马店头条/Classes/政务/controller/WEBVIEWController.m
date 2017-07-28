//
//  WEBVIEWController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//
#import "WEBVIEWController.h"
#import "FBDTDetailsModel.h"
#import "UMSocial.h"
#import "XGXWModel.h"
#import "MineDYModel.h"
#define JULI (ScreenW - 320)/3
#import "ZmdcommendCell.h"
#import "MineSCModel.h"
#import "commonmodel.h"
#import "ZMDUserTableViewController.h"
@interface WEBVIEWController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UMSocialUIDelegate,UITextFieldDelegate> {
   
    UILabel *httpTitle;
    CGFloat _oldy;
    CGFloat _weboldy;
    NSString *userid;
    NSString *shareUrl;
    
    
    NSString *times;
    NSString *arcateid;
    NSString *arid;
    NSString *artype;
    NSInteger mainHeight;
    
    NSInteger webHeight;
    NSString *imgString;
}
@property (nonatomic, strong) UIView* webBrowserView;

@property(nonatomic, strong)UIWebView *webView;


@property(nonatomic, strong)UIView *vie;

@property(nonatomic, strong)NSString *url;

@property(nonatomic, strong)NSString *titleweb;

@property(nonatomic, strong)NSString *source;

@property(nonatomic, strong)UITableView *tableview;
@property(nonatomic, strong)UIButton *guanzhu;
@property(nonatomic, assign)BOOL zhu;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
@property(nonatomic, assign)BOOL islocation;
@property(nonatomic, strong)UIButton *collection;
@property(nonatomic, assign)BOOL iscollection;

@property(nonatomic, strong)NSMutableArray *xgxwArray;

@property(nonatomic, strong)NSString *take_id;
@property(nonatomic, strong)NSString *keep_id;

@property (nonatomic, strong)UIButton *but;
@property(nonatomic, strong)NSMutableArray *contentarr;
@property(nonatomic, strong)UITextField *textfield;
//@property (nonatomic, strong)UITextView *textview;

@property(nonatomic, strong)UIButton *common;
@property(nonatomic, strong)UIButton *share;

@property(nonatomic, strong)NSMutableArray *dyid;
@property(nonatomic, strong)NSMutableArray *dytakeid;

@property(nonatomic, strong)NSMutableArray *scid;
@property(nonatomic, strong)NSMutableArray *sckeepid;
@property(nonatomic, strong)UILabel *titable;
@property(nonatomic, strong)UIImageView *imageview;
@property(nonatomic, strong)UILabel *timelable;
@property(nonatomic, strong)UILabel *sourcelable;
@property(nonatomic, strong)UILabel *clicknum;
@end




@implementation WEBVIEWController

- (NSMutableArray *)contentarr {
    if (_contentarr == nil) {
        self.contentarr = [NSMutableArray array];
    }
    return _contentarr;
}
- (NSMutableArray *)xgxwArray {
    if (_xgxwArray == nil) {
        self.xgxwArray = [NSMutableArray array];
    }
    return _xgxwArray;
}

- (void)back {
//    [[Manager sharedManager] dingYueList];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
   
    
    self.dyid = [NSMutableArray arrayWithCapacity:1];
    self.dytakeid = [NSMutableArray arrayWithCapacity:1];
    self.scid = [NSMutableArray arrayWithCapacity:1];
    self.sckeepid = [NSMutableArray arrayWithCapacity:1];
 
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenW, ScreenH)];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];;
    [self.view addSubview:self.webView];
    
    self.view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    self.webView.scrollView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
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
    
    
    [self.view bringSubviewToFront:self.vie];
    
//  [self dingYueList];
    [self lodCollectionList];
    [self setupview];

//    [self headViewToWebView:_webView];
}


- (void)lodnews {
     if ([ZMDNNetWorkStata isconnectedNetwork] != nil){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
    NSString *str;
    
    if ( [Manager sharedManager].jinru != nil) {
        dic = @{@"id":self.idString,@"type":self.type};
        str = @"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone";
    }else{
        dic = @{@"ar_id":self.idString};
        str = @"http://zmdtt.zmdtvw.cn/index.php/Api/zw/getone/";
    }
    
    [session GET:str parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *diction = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSLog(@"--－－－－－－－－--%@",diction);
        FBDTDetailsModel *model = [[FBDTDetailsModel alloc]init];
        weakSelf.time = [model initWithDiction:diction].ar_time;
        weakSelf.url = [diction objectForKey:@"url"];
        weakSelf.titleweb = [diction objectForKey:@"ar_title"];
        weakSelf.source = [diction objectForKey:@"dwname"];
        
        userid = [diction objectForKey:@"ar_userid"];
        shareUrl = [diction objectForKey:@"shareurl"];
        weakSelf.title = [diction objectForKey:@"ar_title"];
        times = [diction objectForKey:@"ar_time"];
        weakSelf.onclick = [diction objectForKey:@"ar_onclick"];
        weakSelf.ar_id = [diction objectForKey:@"ar_id"];
        weakSelf.type = [diction objectForKey:@"ar_type"];
        
        UIImage *image = [UIImage imageNamed:@"11111"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        if (![[diction objectForKey:@"ar_pic"] isEqual:[NSNull null]]) {
            imgString = [diction objectForKey:@"ar_pic"];
        }else {
            imgString = encodedImageStr;
        }
        
        
        if ([Manager sharedManager].jinru != nil) {
            weakSelf.ar_cateid = [diction objectForKey:@"ar_cateid"];
            weakSelf.author = [diction objectForKey:@"ar_ly"];
        }else {
            weakSelf.ar_cateid = [diction objectForKey:@"xwcid"];
            weakSelf.userpicture = [diction objectForKey:@"dwlogo"];
            weakSelf.author = [diction objectForKey:@"dwname"];
        }
        
        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        //异步函数
//        dispatch_async(queue, ^{
            if ( [Manager sharedManager].jinru != nil){
                [weakSelf lodXiangGuanNews];
            }
//        });
//        //同步函数
//        dispatch_sync(queue, ^{
            [weakSelf makeWebView];
            [weakSelf setupview];
            [weakSelf commandList];
//        });
        
        //[self.tableview reloadData];
        //[weakSelf.view bringSubviewToFront:weakSelf.vie];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}

- (void)lodXiangGuanNews {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.type != nil && self.ar_id != nil && self.ar_cateid != nil) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"type":self.type,@"ar_id":self.ar_id,@"ar_cateid":self.ar_cateid};
        
        [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/correlation" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSMutableArray *array = [XGXWModel mj_objectArrayWithKeyValuesArray:arr];
            
            [weakSelf.xgxwArray removeAllObjects];
            
            for (XGXWModel *model in array) {
                [weakSelf.xgxwArray addObject:model];
            }
            
            [weakSelf.tableview reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}

//监听结果回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self myView];
    
}
- (void)myView {
    //取消监听，因为这里会调整contentSize，避免无限递归
    [self removeObserverForWebViewContentSize];
    
    CGSize contentSize = self.webView.scrollView.contentSize;
    webHeight = contentSize.height;
    
    UIView *vi = [[UIView alloc]init];
    vi.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    vi.userInteractionEnabled = YES;
    vi.tag = 1;
    vi.frame = CGRectMake(0, contentSize.height, ScreenW, ScreenH);
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    self.tableview.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"ZmdcommendCell" bundle:nil] forCellReuseIdentifier:@"cellA"];
    
    [vi addSubview:self.tableview];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    view.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    
    self.tableview.tableFooterView = view;
    
    [self.webView.scrollView addSubview:vi];
    
//    CGFloat heightcontent;
//    if (self.tableview.contentSize.height > ScreenH-100*Kscaleh) {
//        heightcontent = self.tableview.contentSize.height;
//    }else {
//         heightcontent = ScreenH-100*Kscaleh;
//    }
    
    self.tableview.frame = CGRectMake(0, 0, ScreenW, self.tableview.contentSize.height+30);
     self.webView.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height + self.tableview.frame.size.height+30);
    
    //重新监听
    [self addObserverForWebViewContentSize];
}
//移除观察者
- (void)removeObserverForWebViewContentSize {
    UIView *viewss = [self.view viewWithTag:1];
    [viewss removeFromSuperview];
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
}
//添加监听
- (void)addObserverForWebViewContentSize {
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
- (void)makeWebView {
    
    //监听webView的滚动到何处
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
    
    [self headViewToWebView:self.webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
     
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
//    self.webView.frame = CGRectMake(0, 64, ScreenW, webHeight);
    
}


- (void)headViewToWebView:(UIWebView *)web {
    //获取UIWebBrowserView
    self.webBrowserView = web.scrollView.subviews[0];
    UIImageView * headerImageView = [[UIImageView alloc] init];
    headerImageView.backgroundColor = [UIColor whiteColor];
    //将视图添加到webView的ScrollView上
    UIView * headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    [self.webView.scrollView addSubview:headView];
    
    _titable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5,ScreenW-40, 0)];
    _titable.textAlignment = NSTextAlignmentLeft;
    _titable.font = [UIFont systemFontOfSize:24];
    _titable.text= self.title;
    _titable.numberOfLines = 0;
    _titable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(ScreenW-40, 200*Kscalew);//labelsize的最大值
    CGSize expectSize = [_titable sizeThatFits:maximumLabelSize];
    _titable.frame = CGRectMake(20, 5, ScreenW-40, expectSize.height);
    mainHeight = expectSize.height+10;
    
    headView.frame = CGRectMake(0, 0, ScreenW, mainHeight+65);
    headerImageView.frame = CGRectMake(0, 0, ScreenW, mainHeight+65);
    //2改变UIWebBrowserView的坐标
    CGRect frame = self.webBrowserView.frame;
    frame.origin.y = CGRectGetMaxY(headerImageView.frame);
    self.webBrowserView.frame = frame;
    [headView addSubview:_titable];
    
    
    _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, mainHeight +15, 40, 40)];
    _imageview.backgroundColor = [UIColor whiteColor];
    _imageview.layer.masksToBounds = YES;
    _imageview.layer.cornerRadius = 20;
    //imageview.image = [UIImage imageNamed:@"3副本"];
    [_imageview.layer setBorderWidth:1.0];
    _imageview.layer.borderColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1].CGColor;
    [_imageview sd_setImageWithURL:[NSURL URLWithString:self.userpicture]];
    [headView addSubview:_imageview];
    
    _timelable = [[UILabel alloc]initWithFrame:CGRectMake(75, mainHeight+15,150, 20)];
    _timelable.numberOfLines = 0;
    _timelable.textAlignment = NSTextAlignmentLeft;
    _timelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _timelable.text= [NSString stringWithFormat:@"%@",self.author];
    [headView addSubview:_timelable];
    
    _sourcelable = [[UILabel alloc]initWithFrame:CGRectMake(75,mainHeight+35,150, 20)];
    _sourcelable.numberOfLines = 0;
    _sourcelable.textAlignment = NSTextAlignmentLeft;
    _sourcelable.font =  [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _sourcelable.text= self.time ;
    [headView addSubview:_sourcelable];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0,mainHeight+60,ScreenW, 5)];
    lable.backgroundColor = [UIColor grayColor];
    lable.alpha = .1;
    [headView addSubview:lable];
    
    
    _clicknum = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-120*Kscaleh,mainHeight+20, 120*Kscaleh, 30)];
    _clicknum.textAlignment = NSTextAlignmentLeft;
    _clicknum.font =  [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _clicknum.text= [NSString stringWithFormat:@"点击量：%@",self.onclick];
    [headView addSubview:_clicknum];
    
    
    self.guanzhu = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanzhu.frame = CGRectMake((ScreenW - 90),mainHeight+20, 70, 30);
    self.guanzhu.layer.masksToBounds = YES;
    self.guanzhu.layer.cornerRadius = 8;
    [self.guanzhu setTitle:@"订阅＋" forState:UIControlStateNormal];
    self.guanzhu.backgroundColor = [UIColor redColor];
            int i=0;
            for (NSString *string in self.dyid) {
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *st = [numberFormatter stringFromNumber:userid];
                i++;
                if ([st isEqualToString:string]) {
                    [_guanzhu setTitle:@"已订阅" forState:UIControlStateNormal];
                    self.guanzhu.backgroundColor = [UIColor lightGrayColor];
                    self.take_id = self.dytakeid[i-1];
                    // self.guanzhu.userInteractionEnabled = NO;
                    //NSLog(@"111111");
                    self.zhu = YES;
                }
            }
    
    [self.guanzhu addTarget:self action:@selector(guanzhu:) forControlEvents:UIControlEventTouchUpInside];
    [self.guanzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //[headView addSubview:self.guanzhu];
   
    
    
}
- (void)guanzhu:(UIButton *)sender {
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    if (str != nil) {
        if (self.zhu == NO) {
            [self adddingyue];
        }else {
            [self quxiaodingyue];
        }
        _zhu = !_zhu;
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

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
    
}

/**
 *  订阅
 */
- (void)adddingyue {
     AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *par = [NSDictionary dictionary];
    if ([Manager sharedManager].jinru != nil) {
         par = @{@"pt_uid":str,@"uid":userid};
    }else {
         par = @{@"pt_uid":str,@"uid":userid,@"state":@"1"};
    }

        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/adtake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            
            self.take_id = [dic objectForKey:@"take_id"];
            
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                //NSLog(@"%@",[dic objectForKey:@"Message"]);
                [self.guanzhu setTitle:@"已订阅" forState:UIControlStateNormal];
                 self.guanzhu.backgroundColor = [UIColor lightGrayColor];
                [self dingYueList];
            }
            //[MBProgressHUD hideHUDForView:self.DINGYUE animated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //[MBProgressHUD hideHUDForView:self.DINGYUE animated:YES];
        }];
    
    
}


- (void)quxiaodingyue {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (userid != nil && self.take_id != nil) {
        NSDictionary *par = @{@"take_id":self.take_id};
       
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/deltake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            //NSLog(@"%@",dic);
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
           
            if ([code isEqualToString:@"0"] ) {
                //NSLog(@"****  %@",[dic objectForKey:@"Message"]);
                [self.guanzhu setTitle:@"订阅＋" forState:UIControlStateNormal];
                 self.guanzhu.backgroundColor = [UIColor redColor];
                [self dingYueList];
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

//- (void)blackClick {
//    [self.webView canGoBack];
//    [self removeObserverForWebViewContentSize];
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([Manager sharedManager].jinru != nil) {
        return 2;
    }
    return 1;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    
    lab.textColor = [UIColor redColor];
    
    if ([Manager sharedManager].jinru != nil) {
        if (section == 0) {
            lab.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
            lab.text = @"   🔥相关新闻";
        }else {
            //lab.text = @"   ◈全部评论";
             lab.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
        }
    }else {
           //lab.text = @"   ◈全部评论";
             lab.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    }
    return lab;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([Manager sharedManager].jinru != nil) {
        if (section == 0) {
            return 30;
        }else {
           return 5;
        }
    }else {
        return 5;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([Manager sharedManager].jinru != nil) {
        if (indexPath.section == 0) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
            XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
            cell.textLabel.text = model.ar_title;
            cell.textLabel.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
 
    }
    
    ZmdcommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellA" forIndexPath:indexPath];
    commonmodel *model = [self.contentarr objectAtIndex:indexPath.row];
    
    [cell.userimg sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.userlab.text = model.nickname;
    
    cell.userlab.numberOfLines = 0;
    
    cell.timeAndCommendnumlab.text = [NSString stringWithFormat:@"%@回复",model.saytime];
    
    cell.userimg.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.zannum.text = model.zcnum;
    
    cell.contentlab.text = model.saytext;
    
    //[Manager sharedManager].pingLunString = cell.contentlab.text;
    
    cell.contentlab.font = [UIFont systemFontOfSize:16];
    cell.contentlab.numberOfLines = 0;//根据最大行数需求来设置
    cell.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.contentlab.textColor = [UIColor blackColor];
    CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
    //关键语句
    CGSize expectSize = [cell.contentlab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    cell.contentlab.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
    [Manager sharedManager].pingLunHeight = expectSize.height;
    cell.contentlab.textAlignment = NSTextAlignmentLeft;
    
    
    [cell.zanbtn addTarget:self action:@selector(conmonCilckZan:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanbtn.tag = indexPath.row;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
        if ([code isEqualToString:@"0"] ) {
            [weakself commandList];
        }
        [weakself.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([Manager sharedManager].jinru != nil) {
        if (section == 0) {
            return self.xgxwArray.count;
        }else if (section == 1){
            return self.contentarr.count;
        }
     }
    return self.contentarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([Manager sharedManager].jinru != nil) {
        if (indexPath.section == 0) {
            return 55;
        }else if (indexPath.section == 1) {
             return 90 + [Manager sharedManager].pingLunHeight;
        }
       
    }
    return 90 + [Manager sharedManager].pingLunHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self dingYueList];
//    [self lodCollectionList];
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([Manager sharedManager].jinru != nil) {
        if (indexPath.section == 0) {
            XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
            [self removeObserverForWebViewContentSize];
            self.idString  = model.ar_id;
            self.type      = model.ar_type;
            self.ar_cateid = model.ar_cateid;
            
            [self lodnews];
           
            
        }
    }
   
    
    self.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW,50);
//    self.textview.frame = CGRectMake(10, 5, ScreenW-170, 30);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
    
    self.collection.hidden = NO;
    self.common.hidden = NO;
    self.share.hidden = NO;
    self.but.hidden = YES;
//    self.textview.text = nil;
//    self.textview.hidden = YES;
//    self.textfield.hidden = NO;
    self.textfield.text = nil;
    self.textfield.placeholder = @" 写评论。。。";
    [self.textfield resignFirstResponder];
    
    if ([Manager sharedManager].jinru != nil) {
        if (indexPath.section == 0) {
            [UIWebView animateWithDuration:0.1 animations:^{
                CGPoint offset = self.webView.scrollView.contentOffset;
                offset.y = 0;
                self.webView.scrollView.contentOffset = offset;
            }];
        }
    }
    
 }



- (void)setupview {
    self.vie = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-50, ScreenW, 50)];
    _vie.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
    [self.view addSubview:self.vie];
    
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, ScreenW-170, 40)];
    self.textfield.backgroundColor = [UIColor whiteColor];
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.layer.masksToBounds = YES;
    self.textfield.layer.cornerRadius = 5;
    self.textfield.delegate  = self;
    self.textfield.placeholder = @" 写评论。。。";
    [self.vie addSubview:self.textfield];
    
//    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, ScreenW-170, 30)];
//    self.textview.layer.masksToBounds = YES;
//    self.textview.layer.cornerRadius = 10;
//    self.textview.delegate = self;
//    self.textview.textColor = [UIColor redColor];
//    self.textview.hidden = YES;
//    [self.vie addSubview:self.textview];
    
    //self.textview.frame = CGRectMake(10, 5, ScreenW-100*Kscalew, 70);
    
    
    self.but = [UIButton buttonWithType:UIButtonTypeCustom];
    self.but.frame = CGRectMake(ScreenW-60, 5, 50, 40);
    [self.but setTitle:@"发送" forState:UIControlStateNormal];
    self.but.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.but.layer.masksToBounds = YES;
    self.but.layer.cornerRadius = 5;
    [self.but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.but addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.but.hidden = YES;
    [self.vie addSubview:self.but];
    
    
    self.common = [UIButton buttonWithType:UIButtonTypeCustom];
    self.common.frame = CGRectMake((ScreenW - 150),10, 30, 30);
    self.common.layer.masksToBounds = YES;
    self.common.layer.cornerRadius = 15;
    //common.backgroundColor = [UIColor whiteColor];
    [self.common setImage:[UIImage imageNamed:@"comm.png"] forState:UIControlStateNormal];
    [self.common addTarget:self action:@selector(common:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.common];
    
    self.collection = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collection.frame = CGRectMake((ScreenW - 100),10, 30, 30);
    self.collection.layer.masksToBounds = YES;
    self.collection.layer.cornerRadius = 15;
     [self.collection setImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
     _iscollection = NO;
    int i=0;
    for (NSString *string in self.scid) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *st = [numberFormatter stringFromNumber:self.ar_id];
        i++;
        if ([st isEqualToString:string]) {
           
            self.keep_id = self.sckeepid[i-1];
            _iscollection = YES;
             [self.collection setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
        }
        
    }
   
    [self.collection addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.collection];
    
    self.share = [UIButton buttonWithType:UIButtonTypeCustom];
    self.share.frame = CGRectMake((ScreenW - 50),10, 30, 30);
    self.share.layer.masksToBounds = YES;
    self.share.layer.cornerRadius = 15;
    //share.backgroundColor = [UIColor whiteColor];
    [self.share setImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
    [self.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.share];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20,27, 30, 30);
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

/**
 * 评论
 */

- (void)common:(UIButton *)sender {
    
    if (_islocation == NO) {
        [UIWebView animateWithDuration:0.1 animations:^{
            CGPoint offset = self.webView.scrollView.contentOffset;
            offset.y = webHeight;
            self.webView.scrollView.contentOffset = offset;
        }];
    }else {
        [UIWebView animateWithDuration:0.1 animations:^{
            CGPoint offset = self.webView.scrollView.contentOffset;
            offset.y = 0;
            self.webView.scrollView.contentOffset = offset;
        }];
    }
    _islocation = !_islocation;
}


- (void)sendMessage:(UIButton *)sender {
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil) {
        [self addCommand];
        
    }else {
        [self.textfield resignFirstResponder];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再发表评论" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:na animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
  
    
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.collection.hidden = YES;
    self.common.hidden = YES;
    self.share.hidden = YES;
//    self.textfield.hidden = YES;
//    self.textview.hidden = NO;
    self.but.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.vie.frame = CGRectMake(0, ScreenH - height-50, ScreenW, 50);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-80, 40);
    [self.view bringSubviewToFront:self.vie];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
    
    self.collection.hidden = NO;
    self.common.hidden = NO;
    self.share.hidden = NO;
//    self.textview.text = nil;
    
//    self.textfield.hidden = NO;
    
//    self.textview.hidden = YES;
    self.but.hidden = YES;
    self.textfield.text = nil;
    self.textfield.placeholder = @" 写评论。。。";
}


//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    return YES;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.vie.hidden = NO;
    
    self.vie.frame = CGRectMake(0, ScreenH -50, ScreenW, 50);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
    
    self.collection.hidden = NO;
    self.common.hidden = NO;
    self.share.hidden = NO;
    self.textfield.text = nil;
    
//    self.textfield.hidden = NO;
    
//    self.textview.hidden = YES;
    self.but.hidden = YES;
//    self.textview.text = nil;
    self.textfield.placeholder = @" 写评论。。。";
    
    [self.textfield resignFirstResponder];
}
//点击return键，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.vie.frame = CGRectMake(0, ScreenH -50, ScreenW,50);
    self.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
    
    self.collection.hidden = NO;
    self.common.hidden = NO;
    self.share.hidden = NO;
    self.textfield.text = nil;
    
//    self.textfield.hidden = NO;
//    
//    self.textview.hidden = YES;
    self.but.hidden = YES;
//    self.textview.text = nil;
    self.textfield.placeholder = @" 写评论。。。";
    
    [self.textfield resignFirstResponder];
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
    __weak typeof(self) weakself = self;
    if (str != nil && string != nil){
        NSDictionary *para = [NSMutableDictionary dictionaryWithCapacity:1];
        if ([Manager sharedManager].jinru != nil) {
            para = @{@"username":string,@"id":self.ar_id,@"classid":self.ar_cateid,@"userid":str,@"saytext":self.textfield.text};
        }else {
            para = @{@"username":string,@"id":self.ar_id,@"classid":self.ar_cateid,@"userid":str,@"saytext":self.textfield.text,@"state":@"1"};
        }
        
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
                [weakself commandList];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}


- (void)commandList {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.ar_id != nil && self.ar_cateid != nil) {
        NSDictionary *para;
        if ([Manager sharedManager].jinru != nil) {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":@"0"};
        }else {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":@"0",@"state":@"1"};
        }
    __weak typeof(self) weakself = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
        
        [self.contentarr removeAllObjects];
        
        for (commonmodel *model in array) {
            
            [weakself.contentarr addObject:model];
            
        }
        
        weakself.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
        weakself.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
        
        weakself.textfield.text = nil;
//        self.textfield.hidden = NO;
//        self.textview.hidden = YES;
        weakself.but.hidden = YES;
        weakself.textfield.placeholder = @" 写评论。。。";
        [weakself.textfield resignFirstResponder];
        
        
//        [self.webView reload];
        [weakself.tableview reloadData];
        
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
       // NSLog(@"%@^^^^^^^^^^^^^%@",weakSelf.scid,weakSelf.sckeepid);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

/**
 *  收藏
 */
- (void)collection:(UIButton *)sender {
    NSString *ddd= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *teddx= [ddd stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:teddx encoding:NSUTF8StringEncoding error:nil];
    if (str == nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再添加收藏" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:na animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else {
        if (self.iscollection == NO) {
                [self lodCollection];
        }else {
                 [self deleatcollection];
        }
        _iscollection = !_iscollection;
    }

}

- (void)deleatcollection {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    if (self.keep_id != nil) {
        NSDictionary *dic = @{@"keep_id":self.keep_id};
        
        [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/delkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            
            NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            //NSLog(@"==================%@",[dicc objectForKey:@"Message"]);
            if ([code isEqualToString:@"0"] ) {
               //
                [weakSelf.collection setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
                [weakSelf lodCollectionList];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
   
}


- (void)lodCollection {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
        NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
        NSDictionary *dic = [NSDictionary dictionary];
       if ([Manager sharedManager].jinru != nil) {
          dic = @{@"ptuid":str,@"ar_id":self.idString,@"type":self.type};
        }else {
          dic = @{@"ptuid":str,@"ar_id":self.idString,@"type":self.type,@"state":@"1"};
        }
   
        [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/addkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            weakSelf.keep_id = [dicc objectForKey:@"keep_id"];
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            //NSLog(@"----------------%@",[dicc objectForKey:@"Message"]);
            if ([code isEqualToString:@"0"] ) {
                //
                [weakSelf.collection setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
                 [weakSelf lodCollectionList];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
 }



- (void)share:(UIButton *)sender {
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
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)titlee {
    
  NSString *stttt = @"驻马店广播电视台";
    
    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = stttt;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        [UMSocialData defaultData].extConfig.title = self.title;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = stttt;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            imgString];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = self.title;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.title image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            imgString];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.title,shareUrl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
            self.shareView.hidden = YES;
        }];
    }
    
}






- (void)viewWillAppear:(BOOL)animated{
  
    
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
        [self lodnews];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self removeObserverForWebViewContentSize];
     self.shareView.hidden = YES;
//     [[Manager sharedManager] lodCollectionList];
}


@end
