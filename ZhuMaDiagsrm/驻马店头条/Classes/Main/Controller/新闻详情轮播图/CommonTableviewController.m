//
//  CommonTableviewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/15.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "CommonTableviewController.h"
#import "ZmdcommendCell.h"
#import "commonmodel.h"
#import "ZMDUserTableViewController.h"

@interface CommonTableviewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *deleteCommonString;
    NSInteger shanglaPage;
}

@property (nonatomic, strong)UIButton *but;
@property(nonatomic, strong)UITextField *textfield;
//@property (nonatomic, strong)UITextView *textview;
@property(nonatomic, strong)UIView *vie;
@property(nonatomic, strong)NSMutableArray *contentarr;
@property(nonatomic, strong)UITableView *tableView;
@end

@implementation CommonTableviewController
- (void)viewWillAppear:(BOOL)animated {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    deleteCommonString = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    
    
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filewebCaches = [file stringByAppendingPathComponent:@"/arr.text"];
    NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
    if (fileDic.count != 0) {
        [[WordFilter sharedInstance] initFilter:fileDic];
    }
}

- (NSMutableArray *)contentarr {
    if (_contentarr == nil) {
        self.contentarr = [NSMutableArray array];
    }
    return _contentarr;
}


//刷新数据
-(void)setUpReflashShangLa
{
    __weak typeof (self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf lodshangla];
        
    }];
    
}


- (void)lodshangla{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage]};
    
    __weak typeof(self) weakself = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
        
       
        
        for (commonmodel *model in array) {
            
            [weakself.contentarr addObject:model];
            shanglaPage = [model.plid integerValue];
        }
        
        weakself.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
        //        self.textview.frame = CGRectMake(10, 5, ScreenW - 20, 30);
        //
        weakself.textfield.text = nil;
        //        self.textfield.hidden = NO;
        //        self.textview.hidden = YES;
        //        self.but.hidden = YES;
        weakself.textfield.placeholder = @" 写评论。。。";
        
        
        [weakself.tableView reloadData];
        [weakself.tableView.mj_footer endRefreshing];
        [weakself.textfield resignFirstResponder];
        [MBProgressHUD hideHUDForView:weakself.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakself.tableView animated:YES];
    }];
}




- (void)setupButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
}
- (void)Back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发表评论";
    
    
    [self setupButton];
    
    
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

    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    UIView *vie = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
    vie.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = vie;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ZmdcommendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self setupview];
    [self commandList];
    
    
    [self setUpReflashShangLa];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contentarr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90 + [Manager sharedManager].pingLunHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.textfield resignFirstResponder];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZmdcommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    commonmodel *model = [self.contentarr objectAtIndex:indexPath.row];
    
    [cell.userimg sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"hui"]];
    cell.userlab.text = [[WordFilter sharedInstance] filter:model.nickname];
    
    cell.userlab.numberOfLines = 0;
    
    cell.timeAndCommendnumlab.text = [NSString stringWithFormat:@"%@回复",model.saytime];
    
    cell.userimg.contentMode = UIViewContentModeScaleAspectFill;
    cell.userimg.clipsToBounds = YES;
    cell.zannum.text = model.zcnum;
    
    cell.contentlab.text = model.saytext;
    
    //[Manager sharedManager].pingLunString = cell.contentlab.text;
    cell.deletebtn.hidden = YES;
    if ([model.userid isEqualToString:deleteCommonString]) {
        cell.deletebtn.hidden = NO;
        [cell.deletebtn addTarget:self action:@selector(deleteConmon:) forControlEvents:UIControlEventTouchUpInside];
        cell.deletebtn.tag = indexPath.row;
    }
    
    
    
    cell.contentlab.font = [UIFont systemFontOfSize:16];
    cell.contentlab.numberOfLines = 0;//根据最大行数需求来设置
    cell.contentlab.lineBreakMode = NSLineBreakByTruncatingTail;
    cell.contentlab.textColor =[UIColor blackColor];
    CGSize maximumLabelSize = CGSizeMake(300*Kscalew, 60);//labelsize的最大值
    //关键语句
    CGSize expectSize = [cell.contentlab sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    cell.contentlab.frame = CGRectMake(65*Kscalew, 40*Kscalew, expectSize.width, expectSize.height);
    [Manager sharedManager].pingLunHeight = expectSize.height;
    cell.contentlab.textAlignment = NSTextAlignmentLeft;
    
    
    [cell.zanbtn addTarget:self action:@selector(conmonCilckZan:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanbtn.tag = indexPath.row;
    
    if ([[Manager sharedManager].mutSet containsObject:model.plid]) {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
        cell.zannum.textColor = [UIColor redColor];
        cell.zanbtn.userInteractionEnabled = NO;
    }else {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        cell.zannum.textColor = [UIColor blackColor];
        cell.zanbtn.userInteractionEnabled = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        [weakself.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
        [weakself.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




- (void)setupview {
    self.vie = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-50, ScreenW, 50)];
    _vie.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    [self.view addSubview:self.vie];
    
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, ScreenW-80, 40)];
    self.textfield.backgroundColor = [UIColor whiteColor];
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.layer.masksToBounds = YES;
    self.textfield.layer.cornerRadius = 5;
    self.textfield.delegate  = self;
    self.textfield.placeholder = @" 写评论。。。。。。";
    [self.vie addSubview:self.textfield];
    
//    self.textview = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, ScreenW-20, 30)];
//    self.textview.layer.masksToBounds = YES;
//    self.textview.layer.cornerRadius = 10;
//    self.textview.delegate = self;
//    self.textview.textColor = [UIColor redColor];
//    self.textview.hidden = YES;
//    [self.vie addSubview:self.textview];
    
    
    self.but = [UIButton buttonWithType:UIButtonTypeCustom];
    self.but.frame = CGRectMake(ScreenW-60, 5, 50, 40);
    [self.but setTitle:@"发送" forState:UIControlStateNormal];
    self.but.backgroundColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1];
    self.but.layer.masksToBounds = YES;
    self.but.layer.cornerRadius = 5;
    [self.but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.but addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.but];
    
    [self.view bringSubviewToFront:self.vie];
}




- (void)sendMessage:(UIButton *)sender {
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    
    
    if (str != nil) {
            
            self.textfield.text = [[WordFilter sharedInstance] filter:self.textfield.text];
            [self addCommand];

    }
    
    if(str == nil){
        [self.textfield resignFirstResponder];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请登陆后再发表评论" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
//            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:user animated:YES completion:nil];
            
        }];
        [alertVC addAction:actionsure];
        [alertVC addAction:actionsure1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
    }
    
   
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        self.textfield.hidden = NO;
//        //self.textview.hidden = YES;
//        self.but.hidden = YES;
//        
//        self.textview.text = nil;
//        self.textfield.placeholder = @" 写评论。。。。。。";
//        [textView resignFirstResponder];
//        
//        return NO;
//    }
//    return YES;
//}


//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
   
    //self.textfield.hidden = YES;
    //self.textview.hidden = NO;
    //self.but.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.vie.frame = CGRectMake(0, ScreenH-50-height, ScreenW, 50);
    //self.textview.frame = CGRectMake(10, 5, ScreenW-100*Kscalew, 70);
    [self.view bringSubviewToFront:self.vie];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
//    self.textview.frame = CGRectMake(10, 5, ScreenW - 20, 30);
//    self.textview.text = nil;
//    
//    self.textfield.hidden = NO;
//    
//    self.textview.hidden = YES;
//    self.but.hidden = YES;
//    self.textfield.placeholder = @"写评论。。。。。。";
}


//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    return YES;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    NSLog(@"666");
//    self.vie.frame = CGRectMake(0, ScreenH -40, ScreenW, 40);
//    self.textview.frame = CGRectMake(10, 5, ScreenW- 20, 30);
//    
//    
//    self.textview.text = nil;
//    self.textfield.hidden = NO;
//    self.textview.hidden = YES;
//    self.but.hidden = YES;
//    self.textfield.placeholder = @"写评论。。。。。。";
//    
//    [self.textfield resignFirstResponder];
//}
//点击return键，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
        
        NSDictionary *para = @{@"username":string,@"id":self.ar_id,@"classid":self.ar_cateid,@"userid":str,@"saytext":self.textfield.text};
        
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
    
    NSDictionary *para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":@"0"};
    __weak typeof(self) weakself = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
        NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
        
        [weakself.contentarr removeAllObjects];
        NSMutableArray *arrr = [NSMutableArray arrayWithCapacity:1];
        for (commonmodel *model in array) {
            
            [arrr addObject:model];
            shanglaPage = [model.plid integerValue];
        }
        weakself.contentarr = arrr;
        weakself.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
//        self.textview.frame = CGRectMake(10, 5, ScreenW - 20, 30);
//        
        weakself.textfield.text = nil;
//        self.textfield.hidden = NO;
//        self.textview.hidden = YES;
//        self.but.hidden = YES;
        weakself.textfield.placeholder = @" 写评论。。。";
        
        
        [weakself.tableView reloadData];
        
        [weakself.textfield resignFirstResponder];
        [MBProgressHUD hideHUDForView:weakself.tableView animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakself.tableView animated:YES];
    }];
    
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




@end
