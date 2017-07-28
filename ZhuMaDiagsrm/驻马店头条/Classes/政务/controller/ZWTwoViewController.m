//
//  ZWTwoViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/22.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZWTwoViewController.h"

#import "LeftModel.h"

#import "DingYueCell.h"
#import "RightModel.h"

#import "MineDYModel.h"

#import "RightDetailsModel.h"
#import "JiGouViewController.h"

#import "ZMDUserTableViewController.h"


static NSString *jigouname = @"jigouname";
static NSString *jigouxiangqing = @"jigouxiangqing";

@interface ZWTwoViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString *takeid;
    NSIndexPath *indexpath;
}
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;

@property(nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, strong)NSMutableArray *listArray;
@property(nonatomic, strong)NSMutableArray *leftArr;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *jgidArr;
@property (nonatomic, strong)NSString *strid;
@property (nonatomic, strong)NSString *dwid;
@property (nonatomic, strong)NSMutableArray *indexArr;
@property(nonatomic, strong)NSMutableArray *idarr;
@property(nonatomic, strong)NSMutableArray *namearr;
@property (nonatomic, strong)NSString *userid;
@property (nonatomic, strong)NSString *take_id;
@property (nonatomic, strong)UILabel *lab;
@property(nonatomic, strong)NSMutableArray *dwidarr;
@property(nonatomic, strong)NSMutableArray *takeidarr;

@property(nonatomic, assign)BOOL isClick;
@end

@implementation ZWTwoViewController


- (void)setUpLeftButtonAction {
   
    NSMutableArray *array = self.leftArr;
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    
    
    for (NSInteger i = 0; i < reversedArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 61*i, 80, 60);
        button.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        [button setTitle:reversedArray[i] forState:UIControlStateNormal];
        //button.titleLabel.font = [UIFont systemFontOfSize:20];
        button.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        //[button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        
        [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        if (i == 0) {
            button.enabled = NO;
            self.selectedButton = button;
        }
    }
    
}


- (void)selected:(UIButton *)button {
    // 修改按钮状态
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    //self.selectedButton.backgroundColor = [UIColor redColor];
    
    
   [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    self.strid = self.jgidArr[button.tag];
    
    //[self getDataFromlocalRight];
    
    [self lodRightListInformation];
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:jigouname];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodleftinformation];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
        
    });
}

#pragma mark - 请求数据
- (void)lodleftinformation{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/zwjg/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSArray *arrar = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        //NSLog(@"---------------%@",arrar);
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:jigouname];
            [arrar writeToFile:filewebCaches atomically:YES];
        });
        NSMutableArray *arr = [LeftModel mj_objectArrayWithKeyValuesArray:arrar];
        
        NSMutableArray *arrr = [NSMutableArray arrayWithCapacity:1];
        
        
        for (LeftModel *model in arr) {
            [weakSelf.leftArr addObject:model.jgname];
            [arrr addObject:model.jgid];
            //[self.jgidArr addObject:model.jgid];
        }
        
        weakSelf.jgidArr = [[[arrr reverseObjectEnumerator] allObjects] mutableCopy];
        
       [weakSelf hhhhhhhhhh:weakSelf.leftArr];
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}

- (void)hhhhhhhhhh:(id)arr {
     [self setUpLeftButtonAction];
    
    if (self.jgidArr.count != 0) {
        self.strid = self.jgidArr[0];
        
        //[self getDataFromlocalRight];
        [self lodRightListInformation];
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    //CGFloat width = size.width;
    CGFloat heigh = size.height;
    
    DingYueCell *cell = [tableView dequeueReusableCellWithIdentifier:@"celll" forIndexPath:indexPath];
    
    RightModel *model = [self.listArray objectAtIndex:indexPath.row];
    [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.dwlogo] placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.imageview.layer.masksToBounds = YES;
    cell.imageview.layer.cornerRadius = 10;
    cell.titlelable.text = model.dwname;
    cell.imageview.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageview.clipsToBounds = YES;
    cell.numberlable.text = [NSString stringWithFormat:@"订阅量:%@",model.dwsub];
    cell.dingYueBtn.layer.masksToBounds = YES;
    cell.dingYueBtn.layer.cornerRadius = 5;
    [cell.dingYueBtn.layer setBorderWidth:1.0];
    cell.dingYueBtn.layer.borderColor=[UIColor redColor].CGColor;
    
    
    if (heigh == 568) {
        cell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:12.0];
        cell.numberlable.font = [UIFont  systemFontOfSize:10.0];
    }else {
        cell.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    }
    
    [cell.dingYueBtn addTarget:self action:@selector(clickdingyue:) forControlEvents:UIControlEventTouchUpInside];
    cell.dingYueBtn.tag = indexPath.row;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.dingYueBtn setTitle:@"订阅+" forState:UIControlStateNormal];
    cell.dingYueBtn.backgroundColor = [UIColor redColor];
    [cell.dingYueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.dingYueBtn.layer.masksToBounds = YES;
    cell.dingYueBtn.layer.cornerRadius = 5;
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    if (str != nil) {
        for (int i = 0; i<self.takeidarr.count; i++) {
            NSString *string = self.takeidarr[i];
            
            if ([model.dwid isEqualToString:string]) {
                [cell.dingYueBtn setTitle:@"退订" forState:UIControlStateNormal];
                cell.dingYueBtn.backgroundColor = [UIColor redColor];
                [cell.dingYueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.dingYueBtn.layer.masksToBounds = YES;
                cell.dingYueBtn.layer.cornerRadius = 5;
                model.take_id = self.dwidarr[i];
                
                break;
            }
        }
    }
    


    
    return cell;
}

- (void)clickdingyue:(UIButton *)sender {
    
    DingYueCell *cell = (DingYueCell *)[[sender superview] superview];
   
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil) {
        
        if ([[cell.dingYueBtn titleForState:UIControlStateNormal] isEqualToString:@"退订"]) {
            [self quxiaodingyue:sender];
        }else {
            [self adddingyue:sender];
        }
        
    }else {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再添加订阅" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
            
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:user animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
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
//            NSLog(@"dingyuelist******************************%@",arr);
            NSMutableArray *array = [MineDYModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf.dwidarr   removeAllObjects];
            [weakSelf.takeidarr removeAllObjects];
            for (MineDYModel *model in array) {
                [weakSelf.takeidarr addObject:model.userid];
                [weakSelf.dwidarr   addObject:model.take_id];
            }
            [weakSelf.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
    
}

/**
 *  订阅
 */

- (void)adddingyue:(UIButton *)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
   
    RightModel *model = [self.listArray objectAtIndex:sender.tag];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    if (str!= nil && model.dwid != nil) {
        NSDictionary *par = [NSDictionary dictionary];
        par = @{@"pt_uid":str,@"uid":model.dwid,@"state":@"1"};
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/adtake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
//            NSLog(@"add订阅-----------=========%@",dic);
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            if ([code isEqualToString:@"0"] ) {
//                NSLog(@"订阅===========%@",[dic objectForKey:@"Message"]);
                [self dingYueList];
            }
           
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}
- (void)quxiaodingyue:(UIButton *)sender {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    RightModel *model = [self.listArray objectAtIndex:sender.tag];
    takeid = model.take_id;
    __weak typeof(self)weakSelf = self;
    if (takeid != nil) {
        NSDictionary *par = @{@"take_id":takeid};
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/deltake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
//           NSLog(@"quxiaodingyue*******************************%@",dic);
            NSNumber *number = [dic objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            if ([code isEqualToString:@"0"] ) {
//                NSLog(@"取消订阅%@",[dic objectForKey:@"Message"]);
               [weakSelf dingYueList];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
}




- (void)getDataFromlocalRight{
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:jigouxiangqing];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //NSLog(@"%@",fileDic);
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodRightListInformation];
        }else {
            [self hhhhhhhhhhRight:fileDic];
        }
        //回到主线程刷新ui
        //dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        //});
        
    });
}

- (void)lodRightListInformation{
    //[MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"jgid":self.strid};
   // NSLog(@"***************************%@",dic);
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/zwdw" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
//        NSLog(@"RightModel*******************************   %@",arr);
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:jigouxiangqing];
            [arr writeToFile:filewebCaches atomically:YES];
        });
        
        [weakSelf hhhhhhhhhhRight:arr];
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.tableView animated:YES];
    }];
}
- (void)hhhhhhhhhhRight:(id)arr {
    [self.listArray removeAllObjects];
    for (RightModel *model in [RightModel mj_objectArrayWithKeyValuesArray:arr]) {
        [self.listArray addObject:model];
    }
    
}































- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RightModel *model = [self.listArray objectAtIndex:indexPath.row];
    self.dwid = model.dwid;
    [self lodtitles:indexPath];
    
}



- (void)lodtitles:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    JiGouViewController *jigou = [[JiGouViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *parame = @{@"dwid":self.dwid};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/zwxwcol" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arrayqq = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSMutableArray *array = (NSMutableArray *)[[arrayqq reverseObjectEnumerator] allObjects];
        
        //NSLog(@"^^^^^^^^^^^^^^^^^%@",array);
        
        weakSelf.arr = [RightDetailsModel mj_objectArrayWithKeyValuesArray:array];
        
        for (RightDetailsModel * model in weakSelf.arr)
        {
            [weakSelf.namearr addObject:model.xwcname];
            [weakSelf.idarr addObject:model.xwcid];
        }
        
        [Manager sharedManager].xwcname = weakSelf.namearr;
        [Manager sharedManager].xwcid   = weakSelf.idarr;
        
        
        RightModel *model = [weakSelf.listArray objectAtIndex:indexPath.row];
        
        [Manager sharedManager].lv = 1000;
        
        jigou.dwid = model.dwid;
        jigou.imageviewstring = model.dwlogo;
        jigou.titlestring = model.dwname;
        jigou.numstring = model.dwsub;
        
        if ([Manager sharedManager].xwcname.count != 0) {
            jigou.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:jigou animated:YES completion:nil];
        }else {
            //weakSelf.lab = [[UILabel alloc]initWithFrame:CGRectMake((ScreenW-200*Kscalew)/2, (ScreenH-30)/2, 100 , 30)];
            //weakSelf.lab.text = @"暂无数据";
            //weakSelf.lab.font = [UIFont systemFontOfSize:20];
            //weakSelf.lab.textColor = [UIColor redColor];
            //[weakSelf.tableView addSubview:weakSelf.lab];
            //[weakSelf performSelector:@selector(removeView) withObject:nil afterDelay:1.0f];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"暂无内容" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:actionsure1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"%@",error);
    }];
    
}
- (void)removeView{
    self.lab.hidden = YES;
}



- (void)setUpRightTableview {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 0, ScreenW-80, ScreenH)];
    [self.tableView registerNib:[UINib nibWithNibName:@"DingYueCell" bundle:nil] forCellReuseIdentifier:@"celll"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = YES;
    [self.view addSubview:self.tableView];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW-80, 6)];
    self.tableView.tableHeaderView = vie;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW-80, 100)];
    self.tableView.tableFooterView = view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}




- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
- (NSMutableArray *)leftArr {
    if (_leftArr == nil) {
        self.leftArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _leftArr;
}
- (NSMutableArray *)listArray {
    if (_listArray == nil) {
        self.listArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _listArray;
}
- (NSMutableArray *)jgidArr {
    if (_jgidArr == nil) {
        self.jgidArr = [NSMutableArray arrayWithCapacity:1];
    }
    return _jgidArr;
}
- (NSMutableArray *)dwidarr {
    if (_dwidarr == nil) {
        self.dwidarr = [NSMutableArray arrayWithCapacity:1];
    }
    return _dwidarr;
}
- (NSMutableArray *)takeidarr {
    if (_takeidarr == nil) {
        self.takeidarr = [NSMutableArray arrayWithCapacity:1];
    }
    return _takeidarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _indexArr = [NSMutableArray array];
    _idarr = [NSMutableArray array];
    _namearr = [NSMutableArray array];
    
    //[self getDataFromlocal];
    
    [self lodleftinformation];
    [self setUpRightTableview];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[Manager sharedManager].xwcname removeAllObjects];
    [[Manager sharedManager].xwcid removeAllObjects];
    
    [self dingYueList];
    
    [self.tableView reloadData];
}










@end
