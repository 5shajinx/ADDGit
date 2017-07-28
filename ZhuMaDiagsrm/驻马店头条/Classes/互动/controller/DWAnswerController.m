//
//  DWAnswerController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/31.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "DWAnswerController.h"

@interface DWAnswerController ()
{
    UILabel *lable;
    UILabel *lable1;
    UILabel *lable2;
    UILabel *lable3;
    UIImageView *imageview1;
    UILabel *tou1;
    UILabel *tou2;
    UILabel *tou3;
    UIScrollView *scrollview;
    
    UILabel *contentlable;
    UILabel *linecontent1;
    UILabel *linecontent2;
    UILabel *linecontent3;
    
    UILabel *wei2;
    UILabel *wei3;
    UILabel *huifuContent;
    
    NSInteger heightt;
     UILabel *huilab1;
     UILabel *huilab2;
    
    
    
    
}

@property(nonatomic, strong)NSString *HFid;
@property(nonatomic, strong)NSString *goodOrBad;
@property(nonatomic, strong)NSString *HFtime;
@property(nonatomic, strong)NSString *HFgood;
@property(nonatomic, strong)NSString *HFbad;
@property(nonatomic, strong)NSString *HFcontent;

@property(nonatomic, strong)UIButton *toolBtn1;
@property(nonatomic, strong)UIButton *toolBtn2;
@property(nonatomic, strong)UIView  *toollable;

@end

@implementation DWAnswerController

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"问题回复";
     self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    [self setupview];
    
    self.toollable = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH-55*Kscaleh, ScreenW, 55*Kscaleh)];
    self.toollable.hidden = YES;
    [self.view addSubview:self.toollable];
    
    if ([self.reply isEqualToString:@"1"]) {
        self.toollable.hidden = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self req];
        
    }else {
        self.toollable.hidden = YES;
        wei2.text = @" 暂无回复";
    }
    
    
   [self setuptoolview];
}


- (void)setuptoolview {
    self.toollable.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.2];
    
    self.toolBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolBtn1.frame = CGRectMake((ScreenW-280*Kscalew)/3 , 15/2*Kscaleh, 140*Kscalew, 40*Kscaleh);
    [self.toolBtn1 setTitle:@"点赞" forState:UIControlStateNormal];
    self.toolBtn1.backgroundColor = [UIColor redColor];
    self.toolBtn1.layer.masksToBounds = YES;
    self.toolBtn1.layer.cornerRadius = 5;
    [self.toolBtn1 addTarget:self action:@selector(clickGood:) forControlEvents:UIControlEventTouchUpInside];
    [self.toollable addSubview:self.toolBtn1];
    
    self.toolBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.toolBtn2.frame = CGRectMake((ScreenW-280*Kscalew)/3*2+140*Kscaleh , 15/2*Kscaleh, 140*Kscalew, 40*Kscaleh);
    [self.toolBtn2 setTitle:@"吐槽" forState:UIControlStateNormal];
    self.toolBtn2.backgroundColor = [UIColor redColor];
    self.toolBtn2.layer.masksToBounds = YES;
    self.toolBtn2.layer.cornerRadius = 5;
    [self.toolBtn2 addTarget:self action:@selector(clickBad:) forControlEvents:UIControlEventTouchUpInside];
    [self.toollable addSubview:self.toolBtn2];
    
    
    [self.toollable bringSubviewToFront:self.toolBtn1];
    [self.toollable bringSubviewToFront:self.toolBtn2];
}

- (void)clickGood:(UIButton *)sender {
    if (self.HFid != nil) {
        self.goodOrBad = @"good";
        [self lodGoogAndBad];
    }
}

- (void)clickBad:(UIButton *)sender {
    if (self.HFid != nil) {
        self.goodOrBad = @"bad";
        [self lodGoogAndBad];
    }

}

- (void)setupview
{
    
    scrollview = [[UIScrollView alloc]init];
    scrollview.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    scrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollview];

    [self setline1];
    
    //NSLog(@"-----%@",self.content);
    contentlable = [[UILabel alloc]init];
    contentlable.text = [NSString stringWithFormat:@"    %@",self.content];
    contentlable.numberOfLines = 0;
    
    
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   %@",self.content]];
    NSMutableParagraphStyle *paragr = [[NSMutableParagraphStyle alloc] init];
    [paragr setLineSpacing:8];
    [att addAttribute:NSParagraphStyleAttributeName value:paragr range:NSMakeRange(0, [NSString stringWithFormat:@"   %@",self.content].length)];
    contentlable.attributedText = att;
    
    
    contentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    contentlable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(ScreenW-50, CGFLOAT_MAX);//labelsize的最大值
    CGSize expectSize = [contentlable sizeThatFits:maximumLabelSize];
    contentlable.frame = CGRectMake(25, 95, ScreenW-50, expectSize.height);
    [Manager sharedManager].fabuheight = expectSize.height;
    [scrollview addSubview:contentlable];
    
    linecontent1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 90, 1, expectSize.height+20)];
    linecontent1.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:linecontent1];
    linecontent2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-15, 90, 1, expectSize.height+20)];
    linecontent2.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:linecontent2];
    
    linecontent3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90+expectSize.height+20,ScreenW, 1)];
    linecontent3.backgroundColor = [UIColor lightGrayColor];
    [scrollview addSubview:linecontent3];
    
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 90+expectSize.height+20, 1, 80)];
    lab1.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 15, 90+expectSize.height+20, 1, 80)];
    lab2.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:lab2];
//    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(15, 90+expectSize.height+100, ScreenW-30, 1)];
//    lab3.backgroundColor = [UIColor lightGrayColor];
//    [scrollview addSubview:lab3];
    
    heightt = expectSize.height;
    
    UIImageView *weiimageview = [[UIImageView alloc]initWithFrame:CGRectMake(25,expectSize.height+140, 20, 20)];
    weiimageview.image = [UIImage imageNamed:@"tu2"];
    [scrollview addSubview:weiimageview];
    
    wei2 = [[UILabel alloc]initWithFrame:CGRectMake(60, expectSize.height+135, 80, 30)];
    //wei2.text = [NSString stringWithFormat:@"%@",self.username];
    wei2.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    [scrollview addSubview:wei2];
    
    wei3 = [[UILabel alloc]initWithFrame:CGRectMake(140, expectSize.height+135, ScreenW-165, 30)];
    //wei3.text = [NSString stringWithFormat:@"%@",self.time];
    wei3.textAlignment = NSTextAlignmentRight;
    wei3.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    [scrollview addSubview:wei3];
    
    if (![self.reply isEqualToString:@"1"]) {
         scrollview.contentSize = CGSizeMake(ScreenW, heightt+100);
    }
    
   
}









- (void)req {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *par = @{@"id":self.detID};
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_answer_show" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",par);
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"200"]) {
            NSMutableArray *arr = [dic objectForKey:@"items"];
            NSDictionary *diction = [arr firstObject];
            weakSelf.HFtime = [diction objectForKey:@"time"];
            weakSelf.HFcontent = [diction objectForKey:@"content"];
            weakSelf.HFgood = [diction objectForKey:@"good"];
            weakSelf.HFbad = [diction objectForKey:@"bad"];
            weakSelf.HFid = [diction objectForKey:@"id"];
        }
        
        
        wei2.text = @" 留言回复";
        wei3.text = [NSString stringWithFormat:@"%@",weakSelf.HFtime];
        
        huifuContent = [[UILabel alloc]init];
        //huifuContent.text = [NSString stringWithFormat:@"   %@",weakSelf.HFcontent];
        huifuContent.numberOfLines = 0;
        
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"   %@",weakSelf.HFcontent]];
        NSMutableParagraphStyle *paragr = [[NSMutableParagraphStyle alloc] init];
        [paragr setLineSpacing:8];
        [att addAttribute:NSParagraphStyleAttributeName value:paragr range:NSMakeRange(0, [NSString stringWithFormat:@"   %@",weakSelf.HFcontent].length)];
        huifuContent.attributedText = att;
        
        
        huifuContent.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
        huifuContent.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(ScreenW-50, CGFLOAT_MAX);//labelsize的最大值
        CGSize expectSize = [huifuContent sizeThatFits:maximumLabelSize];
        huifuContent.frame = CGRectMake(25, heightt+170, ScreenW-50, expectSize.height);
        [scrollview addSubview:huifuContent];
        
        huilab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, heightt+170, 1, expectSize.height)];
        huilab1.backgroundColor = [UIColor redColor];
    //    [scrollview addSubview:huilab1];
        huilab2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-15, heightt+170, 1, expectSize.height)];
        huilab2.backgroundColor = [UIColor redColor];
    //    [scrollview addSubview:huilab2];
        
        scrollview.contentSize = CGSizeMake(ScreenW, expectSize.height+heightt+220);
        
        
        [weakSelf.toolBtn1 setTitle:[NSString stringWithFormat:@"好棒(%@)",weakSelf.HFgood] forState:UIControlStateNormal];
        [weakSelf.toolBtn2 setTitle:[NSString stringWithFormat:@"吐槽(%@)",weakSelf.HFbad] forState:UIControlStateNormal];
        
        
        
        
        
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
    
}



- (void)lodGoogAndBad {
    // NSLog(@"****** %@",self.HFid);
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *par = [NSDictionary dictionary];
    __weak typeof(self) weakSelf = self;
    if ([self.goodOrBad isEqualToString:@"good"]) {
        par = @{@"id":self.HFid,@"type":@"good"};
    }else {
        par = @{@"id":self.HFid,@"type":@"bad"};
    }
    [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_answer_vote" parameters:par progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        if ([[dic objectForKey:@"status"] isEqualToString:@"200"]) {
            if ([weakSelf.reply isEqualToString:@"1"]) {
                [weakSelf req];
            }
            // NSLog(@"^^^^^^^^^^^^");
        }
        else if([[dic objectForKey:@"status"] isEqualToString:@"400"]) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"您已投过票了" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:actionsure1];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}


- (void)setline1 {
    lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, ScreenW-30, 1)];
    lable.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:lable];
    lable1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 1, 80)];
    lable1.backgroundColor = [UIColor redColor];
 //   [scrollview addSubview:lable1];
    lable2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-15, 10, 1, 80)];
    lable2.backgroundColor = [UIColor redColor];
  //  [scrollview addSubview:lable2];
    lable3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 90, ScreenW, 1)];
    lable3.backgroundColor = [UIColor lightGrayColor];
    [scrollview addSubview:lable3];
    
    tou1 = [[UILabel alloc]initWithFrame:CGRectMake(25, 15, ScreenW-50, 25)];
    tou1.text = [NSString stringWithFormat:@"问题提要：%@",self.wenti];
    tou1.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    [scrollview addSubview:tou1];
    imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(25, 50, 30, 30)];
    imageview1.image = [UIImage imageNamed:@"2"];
    [scrollview addSubview:imageview1];
    tou2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 50, 80, 30)];
    tou2.text = [NSString stringWithFormat:@"%@",self.username];
    tou2.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    [scrollview addSubview:tou2];
    tou3 = [[UILabel alloc]initWithFrame:CGRectMake(140, 50, ScreenW-165, 30)];
    tou3.text = [NSString stringWithFormat:@"%@",self.time];
    tou3.textAlignment = NSTextAlignmentRight;
    tou3.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    [scrollview addSubview:tou3];
}


- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}

@end
