//
//  hudongViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/14.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "hudongViewController.h"

#import "RTTableViewController.h"
#import "JRSegmentViewController.h"
#import "BuMenOneTableViewController.h"
#import "BuMenTwoTableViewController.h"

#import "BMFLModel.h"
#import "RTModel.h"

#import "DWAnswerController.h"
#import "ZhiXunController.h"

static NSString *adString = @"ADSTRING";

@interface hudongViewController ()<UITextFieldDelegate>
{
    NSString *link;
    NSString *name;
}
@property(nonatomic, strong)UIButton *lable;
@property(nonatomic, strong)UITapGestureRecognizer *tap;
@property(nonatomic, strong)NSArray *arr;
@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)NSMutableArray *idarray;
@property(nonatomic, strong)NSMutableArray *namearray;
@property(nonatomic, strong)NSMutableArray *rtarr;


@property(nonatomic, strong)UIScrollView *scrollview;
@end

@implementation hudongViewController


- (void)viewWillAppear:(BOOL)animated{
   self.tabBarController.tabBar.hidden=NO;
}
- (NSMutableArray *)array {
    if (_array == nil) {
        self.array = [NSMutableArray arrayWithCapacity:1];
    }
    return _array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"网络问政";
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _idarray = [NSMutableArray arrayWithCapacity:1];
    _namearray = [NSMutableArray arrayWithCapacity:1];
     _rtarr = [NSMutableArray arrayWithCapacity:1];
    
//    if ([ZMDNNetWorkStata isconnectedNetwork] == nil) {
//         [self setupview];
//         [self Information];
//         [self getDataFromlocalAD];
//         [self lodAD];
//    }
    self.scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.contentSize = CGSizeMake(ScreenW, ScreenH*1.1);
    [self.view addSubview: self.scrollview];
    
    
    
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil){
        [self lodinformation];
        
        [self getDataFromlocalAD];
        [self lodAD];
    }
    
}



- (void)setupview {
    //咨询投诉
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, 120*Kscaleh, 20, 20*Kscaleh)];
    imageview.image = [UIImage imageNamed:@"zx.png"];
    [self.scrollview addSubview:imageview];
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(50, 120*Kscaleh, 80, 20*Kscaleh)];
    lable.text = @"咨询投诉";
    lable.textColor = [UIColor redColor];
    [self.scrollview addSubview:lable];
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(20, 160*Kscaleh, ScreenW - 120, 30*Kscaleh)];
    [self.textfield.layer setBorderWidth:1.0];
    self.textfield.delegate = self;
    self.textfield.layer.borderColor = [UIColor orangeColor].CGColor;
    self.textfield.placeholder = @"  点击进行问题咨询";
    self.textfield.font = [UIFont systemFontOfSize:14];
    [self.scrollview addSubview:self.textfield];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(ScreenW-120, 160*Kscaleh, 100, 30*Kscaleh);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"我要咨询" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(zhixuntousu) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:btn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 200*Kscaleh, ScreenW, 5*Kscaleh)];
    line.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:line];
    
    
    //热帖
    UIImageView *imageview1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 225*Kscaleh, 20, 20*Kscaleh)];
    imageview1.image = [UIImage imageNamed:@"retie.png"];
    [self.scrollview addSubview:imageview1];
    UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(50, 225*Kscaleh, 80, 20*Kscaleh)];
    lable1.text = @"热帖";
    lable1.textColor = [UIColor redColor];
    [self.scrollview addSubview:lable1];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(ScreenW-40, 220*Kscaleh, 30, 30*Kscaleh);
    [btn1 setImage:[UIImage imageNamed:@"cell.png"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(retie) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:btn1];
    
    UIButton *rt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rt1.frame = CGRectMake(20, 250*Kscaleh, ScreenW-40, 50*Kscaleh);
    RTModel *model = self.rtarr[0];
    NSString *string ;
    if ([model.reply isEqualToString:@"0"]) {
        string = @"【未回复】";
    }else {
        string = @"【已回复】";
    }
    [rt1 setTitle:[NSString stringWithFormat:@"%@ %@",string,model.title] forState:UIControlStateNormal];
    [rt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //rt1.titleLabel.font = [UIFont systemFontOfSize:14];
    rt1.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    rt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rt1 addTarget:self action:@selector(rt1) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:rt1];
    UILabel *linert1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 300*Kscaleh, ScreenW-40, 2*Kscaleh)];
    linert1.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:linert1];
    
    UIButton *rt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rt2.frame = CGRectMake(20, 302*Kscaleh, ScreenW-40, 50*Kscaleh);
     RTModel *model1 = self.rtarr[1];
    NSString *string1 ;
    if ([model.reply isEqualToString:@"0"]) {
        string1 = @"【未回复】";
    }else {
        string1 = @"【已回复】";
    }
    [rt2 setTitle:[NSString stringWithFormat:@"%@ %@",string1,model1.title] forState:UIControlStateNormal];
    [rt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //rt2.titleLabel.font = [UIFont systemFontOfSize:14];
    rt2.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
     rt2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rt2 addTarget:self action:@selector(rt2) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:rt2];
    UILabel *linert2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 352*Kscaleh, ScreenW-40, 2*Kscaleh)];
    linert2.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:linert2];
    
    UIButton *rt3 = [UIButton buttonWithType:UIButtonTypeCustom];
    rt3.frame = CGRectMake(20, 354*Kscaleh, ScreenW-40, 50*Kscaleh);
    RTModel *model2 = self.rtarr[2];
    NSString *string2 ;
    if ([model.reply isEqualToString:@"0"]) {
        string2 = @"【未回复】";
    }else {
        string2 = @"【已回复】";
    }
    [rt3 setTitle:[NSString stringWithFormat:@"%@ %@",string2,model2.title] forState:UIControlStateNormal];
    [rt3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //rt3.titleLabel.font = [UIFont systemFontOfSize:14];
    rt3.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    rt3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [rt3 addTarget:self action:@selector(rt3) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:rt3];
    UILabel *linert3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 404*Kscaleh, ScreenW-40, 2*Kscaleh)];
    linert3.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:linert3];
    
    UIButton *lookmore = [UIButton buttonWithType:UIButtonTypeCustom];
    lookmore.frame = CGRectMake(0, 406*Kscaleh, ScreenW, 50*Kscaleh);
    [lookmore setTitle:@"查看更多" forState:UIControlStateNormal];
    [lookmore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [lookmore addTarget:self action:@selector(retie) forControlEvents:UIControlEventTouchUpInside];
    lookmore.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.scrollview addSubview:lookmore];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 456*Kscaleh, ScreenW, 5*Kscaleh)];
    line1.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:line1];
 
    
    //部门列表
    UIImageView *imageviewbm = [[UIImageView alloc]initWithFrame:CGRectMake(20, 481*Kscaleh, 20, 20*Kscaleh)];
    imageviewbm.image = [UIImage imageNamed:@"bmlb.png"];
    [self.scrollview addSubview:imageviewbm];
    UILabel *lablebm = [[UILabel alloc]initWithFrame:CGRectMake(50, 481*Kscaleh, 80, 20*Kscaleh)];
    lablebm.text = @"部门列表";
    lablebm.textColor = [UIColor redColor];
    [self.scrollview addSubview:lablebm];
    
    UIButton *btnbm = [UIButton buttonWithType:UIButtonTypeCustom];
    btnbm.frame = CGRectMake(ScreenW-40, 476*Kscaleh,30, 30*Kscaleh);
    [btnbm setImage:[UIImage imageNamed:@"cell.png"] forState:UIControlStateNormal];
    [btnbm addTarget:self action:@selector(bumenliebiao) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:btnbm];
    
    UIButton *bm1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bm1.frame = CGRectMake(20, 501*Kscaleh, (ScreenW-40)/2, 50*Kscaleh);
    [bm1 setTitle:@"政府部门" forState:UIControlStateNormal];
    [bm1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //bm1.titleLabel.font = [UIFont systemFontOfSize:14];
    bm1.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    [bm1 addTarget:self action:@selector(exitzfbm) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:bm1];
    UILabel *linebm1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2-1, 516*Kscaleh, 2, 20*Kscaleh)];
    linebm1.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:linebm1];
    
    UIButton *bm2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bm2.frame = CGRectMake(ScreenW/2, 501*Kscaleh, (ScreenW-40)/2, 50*Kscaleh);
    [bm2 setTitle:@"公共服务行业" forState:UIControlStateNormal];
    [bm2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //bm2.titleLabel.font = [UIFont systemFontOfSize:14];
    bm2.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    [bm2 addTarget:self action:@selector(exitggfwhy) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:bm2];
    
    UILabel *linebm2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 551*Kscaleh, ScreenW-40, 2*Kscaleh)];
    linebm2.backgroundColor =  [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
    [self.scrollview addSubview:linebm2];
    
    UIButton *bmlookmore = [UIButton buttonWithType:UIButtonTypeCustom];
    bmlookmore.frame = CGRectMake(0, 553*Kscaleh, ScreenW, 50*Kscaleh);
    [bmlookmore setTitle:@"查看更多" forState:UIControlStateNormal];
    bmlookmore.titleLabel.font = [UIFont systemFontOfSize:14];
    [bmlookmore setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [bmlookmore addTarget:self action:@selector(bumenliebiao) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollview addSubview:bmlookmore];
}






- (void)rt1 {
    
    DWAnswerController *details = [[DWAnswerController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    RTModel *model = self.rtarr[0];
    details.wenti = model.title;
    details.time = model.time;
    details.username = model.username;
    details.content = model.content;
    details.detID = model.id;
    details.reply = model.reply;
    
    [self presentViewController:na animated:YES completion:nil];

}
- (void)rt2 {
    DWAnswerController *details = [[DWAnswerController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    RTModel *model = self.rtarr[1];
    details.wenti = model.title;
    details.time = model.time;
    details.username = model.username;
    details.content = model.content;
    details.detID = model.id;
    details.reply = model.reply;
    [self presentViewController:na animated:YES completion:nil];

}
- (void)rt3 {
    DWAnswerController *details = [[DWAnswerController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    RTModel *model = self.rtarr[2];
    details.wenti = model.title;
    details.time = model.time;
    details.username = model.username;
    details.content = model.content;
    details.detID = model.id;
    details.reply = model.reply;
    [self presentViewController:na animated:YES completion:nil];

}


- (void)exitzfbm {
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
        BuMenOneTableViewController  *one  = [[BuMenOneTableViewController alloc]init];
        if (self.idarray.count != 0)  {
            one.cateid = self.idarray[0];
            BuMenTwoTableViewController *two = [[BuMenTwoTableViewController alloc]init];
            two.cateid = self.idarray[1];
            JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
            vc.segmentBgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            vc.indicatorViewColor = [UIColor redColor];
            vc.titleColor = [UIColor redColor];
            [vc setViewControllers:@[one,two]];
            [vc setTitles:self.namearray];
            [Manager sharedManager].jrStr = @"jrsegment";
            [self.navigationController pushViewController:vc animated:YES];
        }
       
        
    }
   
}
- (void)exitggfwhy {
    if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
        BuMenOneTableViewController  *one  = [[BuMenOneTableViewController alloc]init];
        if (self.idarray.count != 0)  {
            one.cateid = self.idarray[0];
            BuMenTwoTableViewController *two = [[BuMenTwoTableViewController alloc]init];
            two.cateid = self.idarray[1];
            JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
            
            vc.segmentBgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
            vc.indicatorViewColor = [UIColor redColor];
            vc.titleColor = [UIColor redColor];
            [vc setViewControllers:@[one,two]];
            [vc setTitles:self.namearray];
            
            [Manager sharedManager].jrStr = @"jrsegment";
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        

    }
}



- (void)zhixuntousu {
    
    ZhiXunController *details = [[ZhiXunController alloc]init];
    details.str = self.arr[0];
    details.biaoshi = @"zxts";
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    [self presentViewController:na animated:YES completion:nil];

    
}
- (void)retie {
    RTTableViewController *RT = [[RTTableViewController alloc]init];
    RT.str = self.arr[1];
   
    [self.navigationController pushViewController:RT animated:YES];
}
- (void)bumenliebiao {
     if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
        BuMenOneTableViewController  *one  = [[BuMenOneTableViewController alloc]init];
         if (self.idarray.count != 0) {
             one.cateid = self.idarray[0];
             BuMenTwoTableViewController *two = [[BuMenTwoTableViewController alloc]init];
             two.cateid = self.idarray[1];
             JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
             vc.segmentBgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
             vc.indicatorViewColor = [UIColor redColor];
             vc.titleColor = [UIColor redColor];
             [vc setViewControllers:@[one,two]];
             
             [vc setTitles:self.namearray];
             
             [Manager sharedManager].jrStr = @"jrsegment";
             
            
             
             [self.navigationController pushViewController:vc animated:YES];
         }
        
    }

}
- (BOOL )textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    
    
    ZhiXunController *details = [[ZhiXunController alloc]init];
    details.str = self.arr[0];
    details.biaoshi = @"zxts";
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:details];
    [self presentViewController:na animated:YES completion:nil];
    [textField resignFirstResponder];
    return NO;
}


- (void)Information {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_category" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSMutableArray *arr = [dic objectForKey:@"items"];
        
        weakSelf.array = [BMFLModel mj_objectArrayWithKeyValuesArray:arr];
     
        for (BMFLModel *model in weakSelf.array) {
            [weakSelf.namearray addObject:model.title];
            [weakSelf.idarray   addObject:model.cateid];
        }
        weakSelf.arr = @[@"咨询投诉",@"热帖",@"部门列表"];
         [weakSelf setupview];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}



- (void)lodinformation {
     AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [NSDictionary dictionary];
        dic = @{@"&start":@"0"};
        [session GET:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_list&status=1&count=15" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            NSMutableArray *arr = [dic objectForKey:@"items"];
            
            weakSelf.rtarr = [RTModel mj_objectArrayWithKeyValuesArray:arr];
            [weakSelf Information];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           
        }];
}




//广告
- (void)getDataFromlocalAD {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:adString];
        NSMutableDictionary  *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodAD];
        }else {
            [self hhhhhAD:fileDic];
        }
        
        
    });
}

- (void)lodAD{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //[MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/api/ad/index?pid=403" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        if (![dic isEqual:[NSNull null]]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:adString];
                [dic writeToFile:filewebCaches atomically:YES];
            });
            
            [weakSelf hhhhhAD:dic];
        }
        
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
    }];
    
}
- (void)hhhhhAD:(NSMutableDictionary *)dic{
    
    
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100*Kscaleh)];
    //[imageview sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"ad_code"]]];
    if ([dic isEqual:[NSNull null]]){
        imageview.image = [UIImage imageNamed:@"hui"];
    }else {
        [imageview sd_setImageWithURL: [NSURL URLWithString:[dic objectForKey:@"ad_code"]] placeholderImage:[UIImage imageNamed:@"hui"]];
    }
    
    
    [imageview setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageview.contentMode =  UIViewContentModeScaleAspectFill;
    imageview.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageview.clipsToBounds  = YES;
    
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [imageview addGestureRecognizer:tap];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 70*Kscaleh, ScreenW-40, 30*Kscaleh)];
    lab.text = [dic objectForKey:@"ad_name"];
    lab.textColor = [UIColor whiteColor];
//    [imageview addSubview:lab];
    
    link = [dic objectForKey:@"ad_link"];
    name = [dic objectForKey:@"ad_name"];
    
    [self.self.scrollview addSubview:imageview];
}

- (void)clickAction:(UITapGestureRecognizer *)sender {
    WaiLianController *zwfw = [[WaiLianController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
    zwfw.urlString = link;
    zwfw.titleename = name;
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self  presentViewController:na animated:YES completion:nil];
}








@end
