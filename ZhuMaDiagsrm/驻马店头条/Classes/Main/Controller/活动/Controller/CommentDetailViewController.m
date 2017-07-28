//
//  CommentDetailViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//
//16进制RGB的颜色转换
#define XLColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "CommentDetailViewController.h"
#import "CommenTableViewCell.h"
#import "commentModel.h"
#import "CommenTableViewCell.h"
#import "ZMDUserTableViewController.h"
#import "NewNetWorkManager.h"
#import "CommentHuiFuViewController.h"
@interface CommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *mytableView;
@property (nonatomic,strong) NSString *userid;

@property (nonatomic, strong) UILabel *Uplabel;//区头
@property (nonatomic, strong) UILabel *dowLabe;//区头
//@property (nonatomic, strong) UILabel *linglabel;//区头
@property (nonatomic, strong) UIView *readView;//输入框view
@property (nonatomic, strong)UITextView *textView;//输入框
@property(nonatomic, strong)NSMutableArray *dataSourc;
@property(nonatomic, assign)NSInteger pubid;


@end
@implementation CommentDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableArray *)dataSourc{
    if (_dataSourc == nil ) {
        self.dataSourc = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSourc;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //展示控件
    [self showdetaile];
    //创建输入
    [self drowImage];
    [self requestDate];
    ///写评论
    // Do any additional setup after loading the view.
    /*
    // 下拉刷新
    self.mytableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [self requestDate];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.mytableView.mj_header endRefreshing];
        });
         
        
    }];
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    // 上拉刷新
    self.mytableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self shanglashuaxin];//上拉刷新

        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
       // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
        //    [self.mytableView.mj_footer endRefreshing];
        //});
    }];
    self.mytableView.tableFooterView = [[UIView alloc]init];

    
}
//上拉刷新
-(void)shanglashuaxin{
    commentModel *model = [self.dataSourc lastObject];
    NSString *pubid = [NSString stringWithFormat:@"%@",model.comid];
    [NewNetWorkManager requestGETWithURLStr:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comlist/id/%@/aid/%@",self.aidStr,pubid] parDic:nil finish:^(id resonbject) {
        NSNumber *inff = [resonbject objectForKey:@"code"];
        if ([inff intValue] == 200) {
            NSMutableArray *arrrr =  [resonbject objectForKey:@"list"];
            
            for (NSDictionary *detailedic in arrrr) {
                commentModel *model = [[commentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:detailedic];
                [self.dataSourc addObject:model];
                
            }
            
        }
        [self.mytableView reloadData];
        [self.mytableView.mj_footer endRefreshing];

        
    } conError:^(NSError *error) {
        
    }];
    
    
    
    
}
- (void)showdetaile{
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,ScreenW,1)];
    line.backgroundColor = [UIColor lightGrayColor];
    UIButton *retButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retButton.frame = CGRectMake(10, 6, 35, 35);
    
    [retButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [retButton addTarget:self action:@selector(retAction) forControlEvents:UIControlEventTouchUpInside];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH - 41, ScreenW, 41)];

    UIButton *readButton = [UIButton buttonWithType:UIButtonTypeCustom];
    readButton.layer.borderWidth = 1;
    readButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [readButton setTitle:@"写评论" forState:UIControlStateNormal];
    [readButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    readButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    readButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    readButton.frame = CGRectMake(50, 6, ScreenW - 55, 31);
    [readButton addTarget:self action:@selector(testfildAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH -41)];
    _mytableView.delegate = self;
    _mytableView.dataSource = self;
    [self.mytableView registerNib:[UINib nibWithNibName:@"CommenTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommenTableVie"];
    self.mytableView.estimatedRowHeight = 10.0f;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    self.mytableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [bgview addSubview:readButton];
    [bgview addSubview:line];
    [bgview addSubview:retButton];
    [self.view addSubview:_mytableView];
    [self.view addSubview:bgview];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourc.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mytableView.estimatedRowHeight = 10.0f;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    CommenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommenTableVie" forIndexPath:indexPath];
    commentModel *model = [self.dataSourc objectAtIndex:indexPath.row];
    cell.detaileLabel.text = [NSString stringWithFormat:@"%@",model.saytext];
    
    [cell showDetailWithModel:model];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    NSString *sts =[NSString stringWithFormat:@"%@",model.userid];
    cell.deleteButton.hidden = YES;
    cell.deleteButton.userInteractionEnabled = NO;
    if ([str isEqualToString:sts]) {
        cell.deleteButton.hidden = NO;
        cell.deleteButton.userInteractionEnabled = YES;
        cell.deleteButton.tag = [model.comid integerValue];
        
        [cell.deleteButton addTarget:self action:@selector(deletebuttonn:) forControlEvents:UIControlEventTouchUpInside];
    }
    //点赞
    
    cell.touchBlock = ^(NSString* intex){
        
        [self dianzan:intex];
    };
    self.mytableView.estimatedRowHeight = 10.0f;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    //模拟点击cell
    
   // cell.didSelsCterGesture.
    cell.didseleButtonnn.tag = indexPath.row + 555;
    
    [cell.didseleButtonnn addTarget:self action:@selector(didselesender:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
- (void)didselesender:(UIButton *)sender{
    long index = sender.tag - 555;
    CommentHuiFuViewController *huiVC = [[CommentHuiFuViewController alloc]init];
    huiVC.nodddel = self.dataSourc[index];
    huiVC.aidStr = [NSString stringWithFormat:@"%@",self.aidStr];
    huiVC.anameString = [NSString stringWithFormat:@"%@",self.anameString];
    
    [self.navigationController pushViewController:huiVC animated:YES];
    
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
//点赞
-(void)dianzan:(NSString *)intex{

 
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comding/id/%@",intex];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *diic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSNumber *inff = [diic objectForKey:@"code"];
        if ([inff intValue] == 200) {
        UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"点赞成功" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:YES];
            
            [promptAlert show];
                        [weakSelf requestDate];
            
            [weakSelf.mytableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"服务器开小差请稍后再试" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];
        

        
    }];
    
    
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
 */

//删除
- (void)deletebuttonn:(UIButton *)button{
    NSString *strr = [NSString stringWithFormat:@"%ld",(long)button.tag];
    
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comdel/id/%@",strr];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
  
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *diic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSNumber *inff = [diic objectForKey:@"code"];
        if ([inff intValue] == 200) {
      
            [weakSelf requestDate];

            [weakSelf.mytableView reloadData];
        }
  
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"服务器开小差请稍后再试" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          
            }];
            [alertVC addAction:actionsure];
            [alertVC addAction:actionsure1];
            [self presentViewController:alertVC animated:YES completion:nil];
        
    }];
   
    
    
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 80)];
    
    self.Uplabel = [[UILabel alloc]initWithFrame:CGRectMake(10,20, ScreenW, 20)];
    _Uplabel.text = @"广视融媒客户端";
    _Uplabel.font = [UIFont systemFontOfSize:20];
    self.dowLabe = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, 70, 19)];
    self.dowLabe.tintColor = [UIColor redColor];
    if (self.dataSourc.count > 0) {
        self.dowLabe.text = @"最新评论";
    } else{
        
        self.dowLabe.text = @"暂无评论";
    }
    UILabel *linLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 79, 70, 1)];
    linLabel.backgroundColor = [UIColor redColor];
    
     UILabel *linBGLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 79, ScreenW, 1)];
    linBGLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    [bgview addSubview:linLabel];
    [bgview addSubview:linBGLabel];
    [bgview addSubview:_dowLabe];
    [bgview addSubview:_Uplabel];
    
    return bgview;
}
//网络请求
- (void)requestDate{
       NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comlist/id/%@/aid/%@",@"0",self.aidStr];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *diic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSNumber *inff = [diic objectForKey:@"code"];
        if ([inff intValue] == 200) {
            NSMutableArray *arrrr =  [diic objectForKey:@"list"];
            [self.dataSourc removeAllObjects];
            
            for (NSDictionary *detailedic in arrrr) {
                commentModel *model = [[commentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:detailedic];
                [self.dataSourc addObject:model];

            }

        }
        /*
        if (arr.count != 0) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:@"ttttt"];
                [arr writeToFile:filewebCaches atomically:YES];
            });
        }
        */
        // [weakSelf getNoNilArr:arr];
        [weakSelf.mytableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}
- (void)requestDaterrrrr{
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comhf/id/0/pubid/1",@"0",self.aidStr];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self)weakSelf = self;
    [session GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *diic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSNumber *inff = [diic objectForKey:@"code"];
        if ([inff intValue] == 200) {
            NSMutableArray *arrrr =  [diic objectForKey:@"list"];
            [self.dataSourc removeAllObjects];
            
            for (NSDictionary *detailedic in arrrr) {
                commentModel *model = [[commentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:detailedic];
                [self.dataSourc addObject:model];
                
            }
            
        }
   
        [weakSelf.mytableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}

//写评论
- (void)testfildAction{
 
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if(str == nil){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再发表评论" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
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
    } else{
        
        
        [self.textView becomeFirstResponder];
        [self.view bringSubviewToFront:self.readView];
        if (self.readView.center.y > ScreenH) {
            ;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDelay:0];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationRepeatCount:0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            CGPoint center = self.readView.center;
            center.y -= ScreenH;
            self.readView.center = center;
            [UIView commitAnimations];
            
        }

        
    }

    
    
    
    
    
    
    
}
- (void)drowImage{
    self.readView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, ScreenH)];
     self.readView .backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:243/255.0 alpha:1];
    UIButton *quxiao = [UIButton buttonWithType:UIButtonTypeCustom];
    quxiao.frame = CGRectMake(20, 30, 50, 20);
    [quxiao setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [quxiao setTitle:@"取消" forState:UIControlStateNormal];
    [quxiao addTarget:self action:@selector(quxiaobutton) forControlEvents:UIControlEventTouchUpInside];
    UIButton *tijiao = [UIButton buttonWithType:UIButtonTypeCustom];
    tijiao.frame = CGRectMake(ScreenW - 50, 30,50, 20);
    [tijiao setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [tijiao setTitle:@"提交" forState:UIControlStateNormal];
    [tijiao addTarget:self action:@selector(tijiaobutton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2 - 30, 30, 60, 20)];
    label.text = @"写评论";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor redColor];
    
    UILabel *bglabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 59, ScreenW, 1)];
    bglabel.backgroundColor = [UIColor lightGrayColor];
    
    //
    self.textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 100, ScreenW - 30, 200)];
    
    self.textView.font = [UIFont systemFontOfSize:17];

    [self.readView addSubview:quxiao];
    [self.readView addSubview:tijiao];
    [self.readView addSubview:label];
    [self.readView addSubview:bglabel];
    [self.readView addSubview:_textView];
    [self.view addSubview:_readView];
 //   [self.view bringSubviewToFront:self.readView];
    
    
}
//输入取消
- (void)quxiaobutton{
    [self.textView resignFirstResponder];
    
    if (self.readView.center.y < ScreenH) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDelay:0];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        CGPoint center = self.readView.center;
        center.y += ScreenH;
        self.readView.center = center;
        //提交动画
        [UIView commitAnimations];
        
    }
    
    
    
    
}
//提交输入
- (void)tijiaobutton{
    [self.textView resignFirstResponder];
    if (self.textView.text.length > 0) {

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
         
    //commentModel *model = self.dataSource[0];
        __weak typeof(self) weakself = self;
        if (str != nil && string != nil){
            
            NSDictionary *para = @{@"username":string,@"pubid":@"0",@"aid":self.aidStr,@"userid":str,@"saytext":self.textView.text};
            
            [session POST:@"http://zmdtt.zmdtvw.cn/api/Activity/comadd" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
                
                NSNumber *number = [dic objectForKey:@"code"];
                NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
                NSString *code = [numberFormatter stringFromNumber:number];
                if ([code isEqualToString:@"200"] ){
                    [weakself requestDate];
                    [weakself.mytableView reloadData];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
    [self  quxiaobutton];
    }
    

}
- (void)retAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentHuiFuViewController *huiVC = [[CommentHuiFuViewController alloc]init];
    huiVC.nodddel = self.dataSourc[indexPath.row];
    huiVC.aidStr = [NSString stringWithFormat:@"%@",self.aidStr];
    huiVC.anameString = [NSString stringWithFormat:@"%@",self.anameString];

    [self.navigationController pushViewController:huiVC animated:YES];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];//按回车取消第一相应者
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
