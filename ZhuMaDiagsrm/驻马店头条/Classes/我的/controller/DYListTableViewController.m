//
//  DYListTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/19.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "DYListTableViewController.h"
#import "UserDingYCell.h"
#import "MineDYModel.h"
#import "JiGouViewController.h"
#import "RightDetailsModel.h"

static NSString *dingyueList = @"dingyueList";
@interface DYListTableViewController ()
{
    NSIndexPath *indexpath;
}
@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, assign)BOOL isDel;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)NSMutableArray *idarr;
@property(nonatomic, strong)NSMutableArray *namearr;
@end

@implementation DYListTableViewController
- (NSMutableArray *)arr {
    if (_arr == nil) {
        self.arr = [NSMutableArray arrayWithCapacity:1];
    }
    return _arr;
}
- (NSMutableArray *)namearr {
    if (_namearr == nil) {
        self.namearr = [NSMutableArray arrayWithCapacity:1];
    }
    return _namearr;
}
- (NSMutableArray *)idarr {
    if (_idarr == nil) {
        self.idarr = [NSMutableArray arrayWithCapacity:1];
    }
    return _idarr;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [[Manager sharedManager].xwcname removeAllObjects];
    [[Manager sharedManager].xwcid removeAllObjects];
    
    [self dingYueList];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的订阅";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    [self setUpBackButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UserDingYCell" bundle:nil] forCellReuseIdentifier:@"UserDingYCell"];
   
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 0, 40, 20) ;
    [self.btn setTitle:@"编辑" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(deleatDingYue) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:self.btn];
    self.navigationItem.rightBarButtonItem = bar;
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    self.tableView.tableFooterView = footerView;
    [self getDataFromlocal];
    [self dingYueList];
}

- (void)deleatDingYue {
 
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserDingYCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDingYCell"];
    
    MineDYModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [cell.dyImageview sd_setImageWithURL:[NSURL URLWithString:model.photo]];
//    cell.dyImageview.layer.masksToBounds = YES;
//    cell.dyImageview.layer.cornerRadius = 10;
    [cell.dyImageview.layer setBorderWidth:1.0];
    cell.dyImageview.layer.borderColor=[UIColor clearColor].CGColor;
    
    cell.dyTitle.text = @"";
    cell.dyContent.text = model.cname;
    cell.dyContent.numberOfLines = 0;
    
    indexpath = indexPath;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self lodtitles:indexPath];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}



- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:dingyueList];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self dingYueList];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
        
        //回到主线程刷新ui
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}
- (void)hhhhhhhhhh:(id)arr {
    
    self.dataArray = [MineDYModel mj_objectArrayWithKeyValuesArray:arr];
//    for (MineDYModel *model in [MineDYModel mj_objectArrayWithKeyValuesArray:arr]) {
//        [self.dataArray addObject:model];
//    }
}


- (void)dingYueList {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    __weak typeof(self) weakself = self;
    if (str != nil) {
        NSDictionary *par = @{@"uid":str};
        [session GET:@"http://zmdtt.zmdtvw.cn/api/take/index" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            
//            NSLog(@"订阅列表*****  %@",arr);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:dingyueList];
                [arr writeToFile:filewebCaches atomically:YES];
            });
            
            [weakself hhhhhhhhhh:arr];
           
            [weakself.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }

}



- (void)setUpBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
}
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleatdingyue:indexPath];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
}


- (void)deleatdingyue:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    MineDYModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakself = self;
    NSDictionary *par = @{@"take_id":model.take_id};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/api/take/deltake" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        
        NSNumber *number = [dic objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
           // NSLog(@"****  %@",[dic objectForKey:@"Message"]);
            weakself.tableView.editing = NO;
            [weakself.btn setTitle:@"编辑" forState:UIControlStateNormal];
    
            [weakself.dataArray removeObject:model];
              _isDel = !_isDel;
           
        }
        
        [weakself.tableView reloadData];
//        [[Manager sharedManager].dyArray removeAllObjects];
//        [[Manager sharedManager] dingYueList];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)lodtitles:(NSIndexPath *)indexPath {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    MineDYModel *model = [self.dataArray objectAtIndex:indexPath.row];
    JiGouViewController *jigou = [[JiGouViewController alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    NSDictionary *parame = @{@"dwid":model.userid};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/zwxwcol" parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arrayqq = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
         NSMutableArray *array = (NSMutableArray *)[[arrayqq reverseObjectEnumerator] allObjects];
        // NSLog(@"%@",array);
        weakSelf.arr = [RightDetailsModel mj_objectArrayWithKeyValuesArray:array];
        
        for (RightDetailsModel * model in weakSelf.arr)
        {
            [weakSelf.namearr addObject:model.xwcname];
            [weakSelf.idarr addObject:model.xwcid];
        }
        
        [Manager sharedManager].xwcname = weakSelf.namearr;
        [Manager sharedManager].xwcid   = weakSelf.idarr;
        
        
        MineDYModel *model = [weakSelf.dataArray objectAtIndex:indexPath.row];
        [Manager sharedManager].lv = 1000;
        
        jigou.dwid = model.userid;
        jigou.imageviewstring = model.photo;
        jigou.titlestring = model.cname;
        jigou.numstring = model.dwsub;
        
        
        
        
        if ([Manager sharedManager].xwcname.count != 0 && [Manager sharedManager].xwcid.count != 0) {
            jigou.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [weakSelf presentViewController:jigou animated:YES completion:nil];
        }else {
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


@end
