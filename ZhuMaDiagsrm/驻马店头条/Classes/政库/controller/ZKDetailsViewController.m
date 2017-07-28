//
//  ZKDetailsViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/16.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZKDetailsViewController.h"
#import "LeftCell.h"
#import "LVLIModel.h"

#import "XGNewsModel.h"
#import "XGNEWSCell.h"
#import "NewsDetailsTableviewController.h"
#import "WEBVIEWController.h"
#import "ZKNoPicCell.h"


static NSString *gerenlvli = @"gerenlvli";
static NSString *xiangguannews = @"xiangguannews";

@interface ZKDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger zknopicheight;
}
@property(nonatomic, strong)UIView *vie;
@property(nonatomic, strong)UIImageView *imageview;
@property(nonatomic, strong)UILabel *alable;
@property(nonatomic, strong)UILabel *blable;
@property(nonatomic, strong)UIButton *btn1;
@property(nonatomic, strong)UIButton *btn2;

@property(nonatomic, strong)UITableView *LeftTableView;
@property(nonatomic, strong)UITableView *RightTableView;

@property(nonatomic, strong)NSMutableArray *array;

@property(nonatomic, strong)NSMutableArray *rightarray;
@end




@implementation ZKDetailsViewController

- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray array];
    }
    return _array;
}
- (NSMutableArray *)rightarray {
    if (_rightarray == nil) {
        self.rightarray = [NSMutableArray array];
    }
    return _rightarray;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationItem.title = self.nameStr;
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    [self setupheader];
    
//if (self.isop == YES) {
//        self.btn1.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//        self.btn2.backgroundColor = [UIColor redColor];
//        [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//         self.btn1.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
//        [self.btn1.layer setBorderWidth:1.0];
//        self.btn1.layer.borderColor=[UIColor redColor].CGColor;
        [self setUpRightContent];
    
        [self lodxiangguanNews];
//    }else {
//        self.btn2.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
//        self.btn1.backgroundColor = [UIColor redColor];
//        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        self.btn2.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
//        [self.btn2.layer setBorderWidth:1.0];
//        self.btn2.layer.borderColor=[UIColor redColor].CGColor;
//        [self setUpLeftContent];
//
//        [self loadGeRenLvLi];
//    }
    
   [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
     self.tabBarController.tabBar.hidden = YES;
    
}
- (void)setupheader
{
    self.vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 132)];
    self.vie.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.vie];
    
    self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 100, 100)];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.imageStr]];
    self.imageview.layer.cornerRadius = 50;
    self.imageview.layer.masksToBounds = YES;
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    [self.vie addSubview:self.imageview];
    
    self.alable = [[UILabel alloc]initWithFrame:CGRectMake(120, 20, 80, 20)];
    self.alable.text = self.nameStr;
    self.alable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    [self.vie addSubview:self.alable];
    
    NSString *str = self.jobStr;
    self.blable = [[UILabel alloc] init];
    self.blable.font = [UIFont systemFontOfSize:14];
    self.blable.text = str;
    self.blable.alpha = 0.5;
    self.blable.textAlignment = NSTextAlignmentLeft;
   // self.blable.backgroundColor = [UIColor redColor];
    self.blable.numberOfLines = 0;//根据最大行数需求来设置
    self.blable.adjustsFontSizeToFitWidth = YES;
    self.blable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(270*Kscalew, 60);//labelsize的最大值
    //关键语句
    CGSize expectSize = [self.blable sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    self.blable.frame = CGRectMake(120, 45, expectSize.width, expectSize.height);
    [self.vie addSubview:self.blable];
   
//    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn1.frame = CGRectMake(40, 130, ScreenW/2-80, 30);
////    self.btn1.backgroundColor = [UIColor redColor];
//    self.btn1.layer.masksToBounds = YES;
//    self.btn1.layer.cornerRadius = 4;
//    [self.btn1 setTitle:@"个人履历" forState:UIControlStateNormal];
//    [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.btn1 addTarget:self action:@selector(gerenlvli:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vie addSubview:self.btn1];
    
//    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn2.frame = CGRectMake(ScreenW/2+40, 130, ScreenW/2-80, 30);
//    self.btn2.layer.masksToBounds = YES;
//    self.btn2.layer.cornerRadius = 4;
//    [self.btn2 setTitle:@"相关新闻" forState:UIControlStateNormal];
//    [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.btn2 addTarget:self action:@selector(xiangguanxinwen:) forControlEvents:UIControlEventTouchUpInside];
//    [self.vie addSubview:self.btn2];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, ScreenW, 2)];
    lable.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.vie addSubview:lable];
    
}
- (void)gerenlvli:(UIButton *)sender {
    self.isop = YES;
    self.btn1.backgroundColor = [UIColor redColor];
    self.btn2.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    
    [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
     self.btn2.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    [self.btn2.layer setBorderWidth:1.0];
    self.btn2.layer.borderColor=[UIColor redColor].CGColor;
    [self setUpLeftContent];
    //[self getDataFromlocal];
    [self loadGeRenLvLi];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)xiangguanxinwen:(UIButton *)sender {
    self.isop = NO;
    self.btn1.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    self.btn2.backgroundColor = [UIColor redColor];
    
    [self.btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn1.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    [self.btn1.layer setBorderWidth:1.0];
    self.btn1.layer.borderColor=[UIColor redColor].CGColor;
    [self setUpRightContent];
    //[self getDataFromlocalNews];
    [self lodxiangguanNews];
    
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}







- (void)setUpLeftContent
{
    self.RightTableView.hidden = YES;
    self.LeftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 180, ScreenW, ScreenH)];
    [self.LeftTableView registerClass:[LeftCell class] forCellReuseIdentifier:@"leftCell"];
    self.LeftTableView.delegate = self;
    self.LeftTableView.dataSource = self;
    self.LeftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.LeftTableView];
     self.LeftTableView.hidden = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 250)];
    self.LeftTableView.tableFooterView = view;
}

- (void)setUpRightContent
{
   
    self.LeftTableView.hidden = YES;
    self.RightTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 135, ScreenW, ScreenH)];
    [self.RightTableView registerNib:[UINib nibWithNibName:@"XGNEWSCell" bundle:nil] forCellReuseIdentifier:@"rightCell"];
    [self.RightTableView registerNib:[UINib nibWithNibName:@"ZKNoPicCell" bundle:nil] forCellReuseIdentifier:@"rightNOCell"];
    self.RightTableView.delegate = self;
    self.RightTableView.dataSource = self;
    //self.RightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.RightTableView];
    self.RightTableView.hidden = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 250)];
    self.RightTableView.tableFooterView = view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.RightTableView]) {
         XGNewsModel *model = self.rightarray[indexPath.row];
        
            if ([model.ar_wl isEqual:[NSNull null]] || model.ar_wl == nil || [model.ar_wl isEqualToString:@""]) {
        //WEBVIEWController
        NewsDetailsTableviewController *webCtrol = [[NewsDetailsTableviewController alloc] init];
        UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:webCtrol];
        [Manager sharedManager].jinru = @"jinruwebview";
        webCtrol.userpicture     = [NSString stringWithFormat:@"%@",model.ar_userpic];
        webCtrol.type     = [NSString stringWithFormat:@"%@",model.ar_type];
        webCtrol.idString  = [NSString stringWithFormat:@"%@",model.ar_id];
        webCtrol.ar_cateid = [NSString stringWithFormat:@"%@",model.ar_cateid];
                
        webCtrol.userpicture = [NSString stringWithFormat:@"%@",model.ar_userpic];
        webCtrol.titlee =[NSString stringWithFormat:@"%@",model.ar_title];
        webCtrol.author =[NSString stringWithFormat:@"%@",model.cname];
        webCtrol.time =[NSString stringWithFormat:@"%@",model.ar_time];
                
//        na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    if ([tableView isEqual:self.LeftTableView]) {
//        LeftCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        LVLIModel *model = _array[indexPath.row];
//        cell.yearLable.text = [NSString stringWithFormat:@"%@年",model.zk_year];
//        
//        cell.monthLable.text = [NSString stringWithFormat:@"%@月",model.zk_month];
//        //cell.monthLable.textColor = [UIColor lightGrayColor];
//        cell.contentLable.text = model.zk_lvli_jj;
//        cell.contentLable.lineBreakMode = NSLineBreakByTruncatingTail;
//        CGSize maximumLabelSize = CGSizeMake( ScreenW -125*Kscalew, 120);//labelsize的最大值
//        //关键语句
//        CGSize expectSize = [cell.contentLable sizeThatFits:maximumLabelSize];
//        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
//        cell.contentLable.frame = CGRectMake(115*Kscalew, 5, expectSize.width, expectSize.height);
//        [Manager sharedManager].lvliHeight = expectSize.height;
//        
//        if ([Manager sharedManager].lvliHeight >= 50) {
//            cell.lineLable.frame = CGRectMake(104.5*Kscalew, 0, 1, 10+[Manager sharedManager].lvliHeight);
//        }else {
//             cell.lineLable.frame = CGRectMake(104.5*Kscalew, 0, 1, 50);
//        }
//        
//       
//        cell.yearLable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
//        cell.monthLable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
//        cell.contentLable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
//        return cell;
//    }
    
    
    XGNewsModel *model = self.rightarray[indexPath.row];
    
    if ([model.ar_pic isEqualToString:@""] || [model.ar_pic isEqual:[NSNull null]] || model.ar_pic == nil) {
        ZKNoPicCell *nocell = [tableView dequeueReusableCellWithIdentifier:@"rightNOCell" forIndexPath:indexPath];
        nocell.titlelable.text = model.ar_title;
        nocell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:17.0];
        nocell.titlelable.numberOfLines = 0;
        nocell.titlelable.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(ScreenW-20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [nocell.titlelable sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        nocell.titlelable.frame = CGRectMake(10, 5, ScreenW-20, expectSize.height);
        zknopicheight = expectSize.height;
        [nocell.hotimage sd_setImageWithURL:[NSURL URLWithString:model.ar_userpic]];
        nocell.selectionStyle = UITableViewCellSelectionStyleNone;
        nocell.sourcelable.text   = model.cname;
        nocell.timalable.text = [Manager othertimeWithTimeIntervalString:model.ar_time];
        
        return nocell;
    }
        XGNEWSCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rightCell" forIndexPath:indexPath];
        [cell.imageviewNews sd_setImageWithURL:[NSURL URLWithString:model.ar_pic]placeholderImage:[UIImage imageNamed:@"hui"]];
        
        cell.imageviewNews.contentMode = UIViewContentModeScaleAspectFill;
        
        [cell.userpicNews sd_setImageWithURL:[NSURL URLWithString:model.ar_userpic]];
        cell.userpicNews.layer.masksToBounds = YES;
        cell.userpicNews.layer.cornerRadius = 10;
        
        cell.titleNews.text = model.ar_title;
        cell.titleNews.numberOfLines = 0;
        cell.titleNews.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:17.0];
        cell.sourceNews.text = model.cname;
        cell.commonNews.text = [NSString stringWithFormat:@"评论:%@",model.ar_volume];
        cell.timeNews.text = [Manager othertimeWithTimeIntervalString:model.ar_time];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([tableView isEqual:self.LeftTableView]) {
//        return _array.count;
//    }
    return self.rightarray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XGNewsModel *model = self.rightarray[indexPath.row];
//    if ([tableView isEqual:self.LeftTableView]) {        
//        if ([Manager sharedManager].lvliHeight >= 50) {
//            return [Manager sharedManager].lvliHeight+10;
//        }else {
//            return 60;
//        }
//    }else {
        if ([model.ar_pic isEqualToString:@""] || [model.ar_pic isEqual:[NSNull null]] || model.ar_pic == nil) {
            return zknopicheight + 45;
        }
        return 100;
//    }
    
    
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:gerenlvli];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self loadGeRenLvLi];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.LeftTableView reloadData];
        });
        
    });
}

- (void)hhhhhhhhhh:(id)arr{
    self.array = [LVLIModel mj_objectArrayWithKeyValuesArray:arr];
}

-(void)loadGeRenLvLi
{
    //[MBProgressHUD showHUDAddedTo:self.LeftTableView animated:YES];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *par = @{@"zk_id":self.idStr,@"zk_lvli_id":@"0"};
    
    [session GET:lvliuel parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:gerenlvli];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhh:arr];
        
        [weakSelf.LeftTableView reloadData];
        
        [weakSelf.LeftTableView.mj_header endRefreshing];
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}




- (void)getDataFromlocalNews {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:xiangguannews];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodxiangguanNews];
        }else {
            [self hhhhhhhhhhnews:fileDic];
        }
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.RightTableView reloadData];
        });
        
    });
}

- (void)hhhhhhhhhhnews:(id)arr{
  self.rightarray =  [XGNewsModel mj_objectArrayWithKeyValuesArray:arr];
//    NSMutableArray *array = [XGNewsModel mj_objectArrayWithKeyValuesArray:arr];
//    
//    for (XGNewsModel *model in array) {
//        [self.rightarray addObject:model];
//    }
}


-(void)lodxiangguanNews
{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
     session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *par = @{@"ar_id":@"0",@"zk_id":self.idStr};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/zk/news" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
     
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:xiangguannews];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhhnews:arr];
        
        [weakSelf.RightTableView reloadData];
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}








@end






























