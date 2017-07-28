//
//  CommentHuiFuViewController.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/19.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "CommentHuiFuViewController.h"
#import "CommenTableViewCell.h"
#import "NewNetWorkManager.h"
#import "ZMDUserTableViewController.h"
#import "UMSocial.h"

#define XLColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface CommentHuiFuViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UMSocialUIDelegate>{
    int height;
    UIView *commentBgview;
    UITextView *CommTextview;
    UILabel *plaseLable;
    NSString * sss;//点赞id标记
        NSString *imgString;
        NSString *shareUrl;
        
        
    
}
@property(nonatomic, strong)NSMutableArray *dateSource;
@property(nonatomic, strong)HXEasyCustomShareView *shareView;

@end

@implementation CommentHuiFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentButton.layer.masksToBounds = YES;
    self.commentButton.layer.cornerRadius = 15;
    self.commentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"CommenTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommenTableViewCellh"];
    self.myTableView.estimatedRowHeight = 10.0f;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.dateSource = [NSMutableArray arrayWithCapacity:1];
    self.myTableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    
    
    [self requestdeatai];//数据请求
    
    
    
    self.title = [NSString stringWithFormat:@"详情"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
    
    // 上拉刷新
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self shanglashuaxin];//上拉刷新
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [self.myTableView.mj_footer endRefreshing];
        });
    }];
    
    
    
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
    //创建评论view
    [self makeCommentView];
    CommTextview.delegate = self;
    //隐藏多余的cell
    self.myTableView.tableFooterView = [[UIView alloc]init];
    
    
}
//上拉刷新
-(void)shanglashuaxin{
    commentModel *model = [self.dateSource lastObject];
    NSString *pubid = [NSString stringWithFormat:@"%@",model.comid];
    
    [NewNetWorkManager requestGETWithURLStr:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comlist/id/%@/aid/%@",self.aidStr,pubid] parDic:nil finish:^(id resonbject) {
        NSNumber *inff = [resonbject objectForKey:@"code"];
        if ([inff intValue] == 200) {
            NSMutableArray *arrrr =  [resonbject objectForKey:@"list"];
            
            for (NSDictionary *detailedic in arrrr) {
                commentModel *model = [[commentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:detailedic];
                [self.dateSource addObject:model];
                
            }
            
        }
        [self.myTableView reloadData];
        [self.myTableView.mj_footer endRefreshing];
        
        
    } conError:^(NSError *error) {
        
    }];
    
    
    
    
}

//返回
- (void)Back{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestdeatai{
    [self.dateSource removeAllObjects]; 
    NSString *requestUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/comhf/id/0/pubid/%@",self.nodddel.comid];
                            
    
    [NewNetWorkManager requestGETWithURLStr:requestUrl parDic:nil finish:^(id resonbject) {
        
        if ([[resonbject objectForKey:@"code"] integerValue] == 200) {
            NSMutableArray *arr = [resonbject objectForKey:@"list"];
            for (NSDictionary *dicc in arr) {
                commentModel *model = [[commentModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dicc];
                
                [self.dateSource addObject:model];
                
                
                
            }
            
            
        }
        [self.myTableView reloadData];
        
    } conError:^(NSError *error) {
        
    }];
    
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        
        return 1;
    }else{
        return self.dateSource.count;
        
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    if (self.dateSource.count > 0) {
        return 2;
    }
    return 1;
    
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommenTableViewCellh" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        [cell showDetailWithModel:self.nodddel];
        cell.deleteButton.hidden = YES;
        //点赞
        sss = [NSString stringWithFormat:@"%@",self.nodddel.comid];
        cell.touchimage.image = [UIImage imageNamed:@"zan.png"];
 
        cell.touchBlock = ^(NSString* intex){
            
            [self dianzan:intex];
        
        
        };
        return cell;
    } else{
        cell.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
        commentModel *mod = self.dateSource[indexPath.row];
        [cell HuifushowDetailWithModel:mod];
        cell.deleteButton.hidden = YES;
        //点赞
        cell.touchimage.image = [UIImage imageNamed:@"zan.png"];

        cell.touchBlock = ^(NSString* intex){
            
            [self dianzan:intex];
   
        };
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
        //3.通过路径获取数据
        NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
        NSString *sts =[NSString stringWithFormat:@"%@",mod.userid];
        cell.deleteButton.hidden = YES;
        cell.deleteButton.userInteractionEnabled = NO;
        if ([str isEqualToString:sts]) {
            cell.deleteButton.hidden = NO;
            cell.deleteButton.userInteractionEnabled = YES;
            cell.deleteButton.tag = [mod.comid integerValue];
            
            [cell.deleteButton addTarget:self action:@selector(deletebuttonn:) forControlEvents:UIControlEventTouchUpInside];
        }

        return cell;
        
    }
    
    
    return nil;
    
}
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
            
            [weakSelf requestdeatai];
            
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
    
    if (section == 1) {
        return 40;
    }
    return 0.01;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 80, 20)];
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"热门评论";
        [bgview addSubview:label];
        bgview.backgroundColor = [UIColor whiteColor];
        return bgview;
    }
    return nil;
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
            [self requestdeatai];
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"点赞成功" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            
            [NSTimer scheduledTimerWithTimeInterval:0.5f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:YES];
            
            [promptAlert show];
            
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
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建评论view
- (void)makeCommentView{
    commentBgview = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH, ScreenW, 400 )];
    commentBgview.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:243/255.0 alpha:1];
    UIButton *connButton = [UIButton buttonWithType:UIButtonTypeCustom];
    connButton.frame = CGRectMake(ScreenW - 10 - 50 , 115, 50, 30);
    [connButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [connButton setTitle:@"评论" forState:UIControlStateNormal];
    [connButton setBackgroundColor:[UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1]];
    
    [connButton addTarget:self action:@selector(commentActio) forControlEvents:UIControlEventTouchUpInside];
    connButton.layer.masksToBounds = YES;
    connButton.layer.cornerRadius = 4;
    
    CommTextview = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, ScreenW - 20, 100)];
    
    CommTextview.font = [UIFont systemFontOfSize:17];
    
    
    [commentBgview addSubview:CommTextview];
    [commentBgview addSubview:connButton];
    [self.view addSubview:commentBgview];
    
    [self.view bringSubviewToFront:commentBgview];
    

    
}
//写评论button
- (IBAction)readCommendd:(UIButton *)sender {
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
        

    
    
    [CommTextview becomeFirstResponder];
    plaseLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 7, 200, 20)];
    plaseLable.text = @"优质评论将会优先展示";
    plaseLable.tintColor = [UIColor lightTextColor];
    
   // [CommTextview addSubview:plaseLable];
        
    CGPoint point = commentBgview.center;
        if (point.y > ScreenH) {
        
    int cc =  150 +280;
    point.y -= cc;
    
    commentBgview.center = point;
        }
    
    
    
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    

    

    
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CommTextview resignFirstResponder];
}
//评论
- (void)commentActio{
    [CommTextview resignFirstResponder];//按回车取消第一相应者
    if (CommTextview.text.length > 0) {

    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    //3.通过路径获取数据
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSString *AdocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *AtextFilePath = [AdocumentsPath stringByAppendingPathComponent:@"username.text"];
    //3.通过路径获取数据
    NSString *string = [NSString stringWithContentsOfFile:AtextFilePath encoding:NSUTF8StringEncoding error:nil];
NSString *pub = [NSString stringWithFormat:@"%@", self.nodddel.comid];
    
    NSDictionary *para = @{@"username":string,@"pubid":pub,@"aid":self.aidStr,@"userid":str,@"saytext":CommTextview.text};
    
    [NewNetWorkManager requestPOSTWithURLStr:@"http://zmdtt.zmdtvw.cn/api/Activity/comadd" parDic:para finish:^(id resonbject) {
        
        if ([[resonbject objectForKey:@"code"] integerValue] == 200) {
            [self requestdeatai];
            
        }
    } conError:^(NSError *error) {
        
    }];
    
    
    
    
    
    CGPoint point = commentBgview.center;
    if (point.y < ScreenH) {
    
    int cc = 280 + 150;
    point.y += cc;
    commentBgview.center = point;
    }
    }
}
//赞
- (IBAction)dianzanbutton:(UIButton *)sender {
    
    [self dianzan:sss];

    
}
//分享
- (IBAction)shareBUtton:(UIButton *)sender {
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
    float heightt = [self.shareView getBoderViewHeight:shareAry firstCount:7];
    self.shareView.boderView.frame = CGRectMake(0, 0, self.shareView.frame.size.width, heightt);
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
    NSString *countStr = @"驻马店广播电视台";

    shareUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/Activity/show/aid/%@", self.aidStr];
    
    self.titlee = [NSString stringWithFormat:@"%@",self.anameString];
    if ([titlee isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareUrl;
        if ([imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
    }
    if ([titlee isEqualToString:@"朋友圈"]) {
        
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareUrl;
        
        if ([imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
        
    }
    if ([titlee isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
        
        if ([imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
        
    }
    if ([titlee isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = countStr;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
        
        if ([imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:self.titlee image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    
                }
                self.shareView.hidden = YES;
            }];
        }
        
        
    }
    if ([titlee isEqualToString:@"新浪微博"]) {
        if ([imgString isEqual:[NSNull null]]) {
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titlee,shareUrl] image:[UIImage imageNamed:@"11111"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
        }else {
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                                imgString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.titlee,shareUrl] image:[UIImage imageNamed:@""] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                }
                self.shareView.hidden = YES;
            }];
            
        }
        
    }
    
}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    CGPoint point = commentBgview.center;
    if (point.y < ScreenH) {
        
        int cc = 280 + 150;
        point.y += cc;
        commentBgview.center = point;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [CommTextview resignFirstResponder];//按回车取消第一相应者

    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    plaseLable.alpha = 0;

    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];//按回车取消第一相应者
    }
    return YES;
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要停止编辑(不是第一响应者时)
    if (textView.text.length == 0) {
    //    plaseLable.alpha = 1;
    }
    return YES;
}












@end
