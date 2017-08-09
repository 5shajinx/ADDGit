//
//  NewsDetailsTableviewController.m
//  驻马店头条
//
//  Created by 孙满 on 16/11/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//
//16进制RGB的颜色转换
#define XLColorFromHex(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "NewsDetailsTableviewController.h"
#import "FBDTDetailsModel.h"
#import "UMSocial.h"
#import "XGXWModel.h"
#import "MineDYModel.h"
#define JULI (ScreenW - 320)/3
#import "ZmdcommendCell.h"
#import "MineSCModel.h"
#import "commonmodel.h"
#import "ZMDUserTableViewController.h"
#import "XGNEWTableViewCell.h"
#import "UMSocial.h"
//有图的相关新闻
#import "XGImageTableViewCell.h"

#import <AVFoundation/AVFoundation.h>
#import "NewNetWorkManager.h"


@interface NewsDetailsTableviewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UMSocialUIDelegate,AVSpeechSynthesizerDelegate>
{
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
    CGFloat height;
    NSString *deleteCommonString;
    NSInteger shanglaPage;
    
    AVSpeechSynthesizer*av;
    UIButton *bbtion;
    NSString *bobaoString;
    NSString *heightcell;//区分不同的cell的高度
}
@property(nonatomic,strong)UIView * headView;

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

@implementation NewsDetailsTableviewController
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
- (UIWebView *)webView {
    
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
        self.webView.delegate = self;
        self.webView.scrollView.scrollEnabled = NO;
        self.webView.scalesPageToFit=YES;
    }
    return _webView;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.view.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.dyid = [NSMutableArray arrayWithCapacity:1];
    self.dytakeid = [NSMutableArray arrayWithCapacity:1];
    self.scid = [NSMutableArray arrayWithCapacity:1];
    self.sckeepid = [NSMutableArray arrayWithCapacity:1];
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerNib:[UINib nibWithNibName:@"ZmdcommendCell" bundle:nil] forCellReuseIdentifier:@"cellA"];
    [self.tableview registerNib:[UINib nibWithNibName:@"XGNEWTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellB"];
    
     [self.tableview registerNib:[UINib nibWithNibName:@"XGImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellC"];
    
self.tableview.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:self.tableview];
    
//    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    
//    [self.view addSubview:self.webView];
    
    UIView *vieee = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    vieee.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
    self.tableview.tableFooterView = vieee;
    NSString *urlString;
    
    if ([Manager sharedManager].jinru != nil) {
        urlString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/showinfo?id=%@",self.idString];
    }else {
        urlString = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/showinfo?id=%@",self.idString];
    }
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]]];
    
      
    NSString *webString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:nil];
    NSString *pageStart=@"<p>";
    NSString *pageEnd=@"</div>";
    NSInteger startOffset = [webString rangeOfString:pageStart].location + pageStart.length;
    NSInteger endOffset = [webString rangeOfString:pageEnd].location;
    NSString *htmlstring = [webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
    NSArray *eachData =  [htmlstring componentsSeparatedByString:@"<p>"];
    NSString *stringk = @"";
    for (NSString *str in eachData)
    {
        NSString *str2 = [str substringToIndex:1];
        if (![str2 isEqualToString:@"<"]) {
            NSString *str3 = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
            NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
            stringk = [NSString stringWithFormat:@"%@%@",stringk,str4];
        }
    }
    bobaoString = stringk;
    
    
    
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
    
    [self lodCollectionList];
    [self setupview];
    

    [self setUpReflashShangLa];
    
    self.tableview.estimatedRowHeight = 100.0f;
    self.tableview.rowHeight = UITableViewAutomaticDimension;
}
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//       CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        CGRect newFrame       = self.webView.frame;
//        newFrame.size.height  = webViewHeight;
//        self.webView.frame = newFrame;
//    }
//}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = _webView.frame;
        frame.size = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
        _webView.frame = frame;
        [self.tableview reloadData];
    }
}
-(void)viewWillDisappear:(BOOL)antimated{
    [super viewWillDisappear:antimated];
    [self.webView.scrollView removeObserver:self
                                    forKeyPath:@"contentSize" context:nil];
    
    [av stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];//暂停
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filewebCaches = [file stringByAppendingPathComponent:@"/arr.text"];
    NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
    if (fileDic.count != 0) {
        [[WordFilter sharedInstance] initFilter:fileDic];
    }
    
    
    
   
        if ([ZMDNNetWorkStata isconnectedNetwork] != nil) {
            [self lodnews];
        }
    
    
    
    
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    deleteCommonString = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    
    
    
    
}






#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
//    NSLog(@"self.webView.frame.size.height-------%lf",self.webView.frame.size.height);
    if ([Manager sharedManager].jinru != nil) {
        if(indexPath.section == 0){
            return self.webView.frame.size.height;
        }else if(indexPath.section == 1){
            if ([heightcell isEqualToString:@"yespic"]) {
                return 90;
            }else{
            return 60;
            }
        }else {
            return [Manager sharedManager].pingLunHeight+90;
        }
    }else {
        if(indexPath.section == 0){
            return self.webView.frame.size.height;
        }else{
            return [Manager sharedManager].pingLunHeight+90;
        }
    }
 
    return 0;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([Manager sharedManager].jinru != nil){
        return 3;
    }else {
        return 2;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if ([Manager sharedManager].jinru != nil) {
//        if(section == 0){
//            return 1;
//        }else if(section == 1){
//            return self.xgxwArray.count;
//        }else {
//            return self.contentarr.count;
//        }
//    }else {
//        if(section == 0){
//            return 1;
//        }else {
//            return self.contentarr.count;
//        }
//    }
    
    if(section == 0){
        return 1;
    }else if(section == 1){
        return self.xgxwArray.count;
    }else {
        return self.contentarr.count;
    }
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0){
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            [cell.contentView addSubview:self.webView];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
        }
        return cell;
    }
    
    if (YES) {

        if (indexPath.section == 1 ){
    //  XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
            XGXWModel *model = self.xgxwArray[indexPath.row];
    //有图的cell
            if (model.ar_pic.length >0) {
                heightcell = @"yespic";
                XGImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellC" forIndexPath:indexPath];
                
                cell.detailLabel.textAlignment = NSTextAlignmentLeft;
                cell.detailLabel.textColor = [UIColor colorWithRed:97/255.0 green:98/255.0 blue:99/255.0 alpha:1.0];
                cell.detailLabel.font = [UIFont systemFontOfSize:16];
                cell.detailLabel.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
                cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
            
                 cell.detailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.detailLabel.text = model.ar_title;
             cell.detailLabel.lineBreakMode = UILineBreakModeClip;
           cell.detailLabel.text = [model.ar_title stringByAppendingString:@"\n\n\n\n"];
        [cell.newsImage sd_setImageWithURL:[NSURL URLWithString:model.ar_pic]];
                
                return cell;

                
            } else{
                //纯文字的cell
                heightcell = @"nopic";

            XGNEWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellB" forIndexPath:indexPath];
            XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
            cell.titlelable.font = [UIFont systemFontOfSize:16];
                cell.titlelable.textColor = [UIColor colorWithRed:97/255.0 green:98/255.0 blue:99/255.0 alpha:1.0];

            cell.titlelable.text = model.ar_title;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titlelable.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
            cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
            return cell;
        }
        
    }
    }
    
        ZmdcommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellA" forIndexPath:indexPath];
        commonmodel *model = [self.contentarr objectAtIndex:indexPath.row];
        [cell.userimg sd_setImageWithURL:[NSURL URLWithString:model.photo]placeholderImage:[UIImage imageNamed:@"hui"]];
        cell.userlab.text = [[WordFilter sharedInstance] filter:model.nickname];
        
        cell.userlab.numberOfLines = 0;
        
        cell.timeAndCommendnumlab.text = [NSString stringWithFormat:@"%@ .回复",model.saytime];
        
        cell.userimg.contentMode = UIViewContentModeScaleAspectFill;
        
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

    if ([[Manager sharedManager].mutSet containsObject:model.plid]) {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
        cell.zannum.textColor = [UIColor redColor];
        cell.zanbtn.userInteractionEnabled = NO;
    }else {
        [cell.zanbtn setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        cell.zannum.textColor = [UIColor blackColor];
        cell.zanbtn.userInteractionEnabled = YES;
    }
    
        
//    cell.zanbtn.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
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
            [weakself lodCommandList];
        }
        [weakself.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        

    }];
    
}














- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //不同的id 区分开
   if ([Manager sharedManager].jinru != nil) {
        if (indexPath.section == 1) {
            
            [av stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];//暂停
            
            XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
            self.idString  = model.ar_id;
            self.type      = model.ar_type;
            self.ar_cateid = model.ar_cateid;
            [Manager sharedManager].jinru = @"jinruwebview";
            [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/showinfo?id=%@",model.ar_id]]]];
            
            
            NSString *webString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/showinfo?id=%@",model.ar_id]] encoding:NSUTF8StringEncoding error:nil];
            NSString *pageStart=@"<p>";
            NSString *pageEnd=@"</div>";
            NSInteger startOffset = [webString rangeOfString:pageStart].location + pageStart.length;
            NSInteger endOffset = [webString rangeOfString:pageEnd].location;
            NSString *htmlstring = [webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
            NSArray *eachData =  [htmlstring componentsSeparatedByString:@"<p>"];
            NSString *stringk = @"";
            for (NSString *str in eachData)
            {
                NSString *str2 = [str substringToIndex:1];
                if (![str2 isEqualToString:@"<"]) {
                    NSString *str3 = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                    NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
                    stringk = [NSString stringWithFormat:@"%@%@",stringk,str4];
                }
            }
            bobaoString = stringk;
            
            [self lodnews];
            
        }
   }else{
       if (indexPath.section == 1) {
           
           [av stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];//暂停
           
           XGXWModel *model = [self.xgxwArray objectAtIndex:indexPath.row];
           self.idString  = model.ar_id;
           self.type      = model.ar_type;
           self.ar_cateid = model.ar_cateid;
           [Manager sharedManager].jinru = nil;
           [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/showinfo?id=%@",model.ar_id]]]];
           
           
           NSString *webString = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/showinfo?id=%@",model.ar_id]] encoding:NSUTF8StringEncoding error:nil];
           NSString *pageStart=@"<p>";
           NSString *pageEnd=@"</div>";
           NSInteger startOffset = [webString rangeOfString:pageStart].location + pageStart.length;
           NSInteger endOffset = [webString rangeOfString:pageEnd].location;
           NSString *htmlstring = [webString substringWithRange:NSMakeRange(startOffset, endOffset-startOffset)];
           NSArray *eachData =  [htmlstring componentsSeparatedByString:@"<p>"];
           NSString *stringk = @"";
           for (NSString *str in eachData)
           {
               NSString *str2 = [str substringToIndex:1];
               if (![str2 isEqualToString:@"<"]) {
                   NSString *str3 = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
                   NSString *str4 = [str3 stringByReplacingOccurrencesOfString:@"&nbsp" withString:@""];
                   stringk = [NSString stringWithFormat:@"%@%@",stringk,str4];
               }
           }
           bobaoString = stringk;
           
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
        if (indexPath.section == 1) {
            [UIWebView animateWithDuration:0.1 animations:^{
                CGPoint offset = self.tableview.contentOffset;
                offset.y = -100;
                self.tableview.contentOffset = offset;
                
            }];
        }
    }else{
        if (indexPath.section == 1) {
            [UIWebView animateWithDuration:0.1 animations:^{
                CGPoint offset = self.tableview.contentOffset;
                offset.y = -100;
                self.tableview.contentOffset = offset;
                
            }];
        }
    }
}

- (void)conmonCilckZan:(UIButton *)sender
{
//    UIButton *myButton = (UIButton *)[self.view viewWithTag:sender.tag];
//    [myButton setImage:[UIImage imageNamed:@"zan-red.png"] forState:UIControlStateNormal];
    
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
            [weakself lodCommandList];
        }
        [weakself.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return 165;
//    }
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 165;
    }
    return 0.5;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSArray *arr = [NSArray arrayWithObjects:@"QQShareTB.png",@"weixinsha.png",@"WeiBoShaerTb.png", @"moreimage.png",nil];
    NSArray *labelarr = [NSArray arrayWithObjects:@"QQ",@"微信",@"微博",@"更多", nil];
   // if (section == 0 && (self.xgxwArray.count > 0)) {
        if (section == 0 ) {

        UIView *footview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 100)];
            footview.hidden = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                footview.hidden = NO;
            });
        footview.backgroundColor = XLColorFromHex(0xf7f7f7);
        
        
        for (int i = 0; i<4; i++) {
            
            UIButton *butt = [UIButton buttonWithType:UIButtonTypeCustom];
            butt.frame = CGRectMake((ScreenW-160) / 5*(i+1) + 40 * i, 40, 40, 40);
            
            UILabel *labe = [[UILabel alloc]init];
            labe.frame = CGRectMake((ScreenW-160) / 5*(i+1) + 40 * i, 90, 40, 20);
            labe.text = [NSString stringWithFormat:@"%@",labelarr[i]];
            labe.textAlignment = NSTextAlignmentCenter;
            labe.textColor = XLColorFromHex(0xbebebe);
            labe.font = [UIFont systemFontOfSize:15];
            
            [butt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",arr[i]]] forState:UIControlStateNormal];
            //  butt.layer.masksToBounds = YES;
            //  butt.layer.cornerRadius = 40;
            butt.tag = 6754 +i;
            [butt addTarget:self action:@selector(qqShareee:) forControlEvents:UIControlEventTouchUpInside];
            [footview addSubview:labe];
            [footview addSubview:butt];
            
            
        }
        UILabel *leftlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, ScreenW, 1)];
        leftlabel.backgroundColor = [UIColor lightGrayColor];
        UILabel *centerLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW/2 - 40, -10, 80, 20)];
        centerLabel.textColor = [UIColor lightGrayColor];
        centerLabel.text = @"分享到";
        centerLabel.backgroundColor = XLColorFromHex(0xf7f7f7);
        centerLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *dowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, ScreenW , 25)];
     //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:@"    热点推荐"];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            //定义图片内容及位置和大小
            attch.image = [UIImage imageNamed:@"redian"];
            attch.bounds = CGRectMake(10, -0.5, 2.5, 12);
            //创建带有图片的富文本
            NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
            [attri insertAttributedString:string atIndex:0];
            
            dowLabel.attributedText = attri;
            dowLabel.font = [UIFont systemFontOfSize:15];
        dowLabel.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
            
            
          
        [footview addSubview:dowLabel];
        // [footview addSubview:leftlabel];
        [footview addSubview:centerLabel];
        
        
        
        
        return footview;
    }
    
    
    return nil;

}
//第二分区区头加分享按钮
//qq微信微博分享
- (void)qqShareee:(UIButton *)imageview{
    
    int  a = (int)imageview.tag - 6754;
    NSString *sharetitl = @"驻马店广播电视台";
    switch (a) {
        case 0:
        {
            //QQ
            [UMSocialData defaultData].extConfig.title = sharetitl;
            
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
            break;
        case 1:
        {
            //微信
            [UMSocialData defaultData].extConfig.title = sharetitl;
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
            break;
        case 2:
        {
            //微博
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
            break;
            
        default:{
            [self addGuanjiaShareView];

        }
            break;
    }
    
  
    
    
}
#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
//    NSLog(@"------%lf",[[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue]);
//    NSLog(@"webViewDidFinishLoad-------size: %lf",fittingSize.height);
//   
    //修改百分比即可
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '120%'"];
  
    
    [self.tableview reloadData];
    
   
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}



- (void)lodnews {
   if ([ZMDNNetWorkStata isconnectedNetwork] != nil){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   }
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = [[NSDictionary alloc]init];
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
        
        FBDTDetailsModel *model = [[FBDTDetailsModel alloc]init];
        weakSelf.time = [model initWithDiction:diction].ar_time;
        weakSelf.url = [diction objectForKey:@"url"];
        weakSelf.titleweb = [diction objectForKey:@"ar_title"];
        weakSelf.source = [diction objectForKey:@"dwname"];
        
        userid = [diction objectForKey:@"ar_userid"];
    
                    
         weakSelf.titlee = [diction objectForKey:@"ar_title"];
   shareUrl = [diction objectForKey:@"shareurl"];
        
        times = [diction objectForKey:@"ar_time"];
        weakSelf.onclick = [diction objectForKey:@"ar_onclick"];
        weakSelf.ar_id = [diction objectForKey:@"ar_id"];
        weakSelf.type = [diction objectForKey:@"ar_type"];
        
       
//        NSLog(@"^^^^^^^^^^^^^^%@",shareUrl);
        
        imgString = [diction objectForKey:@"ar_pic"];
       // NSLog(@"55555555%@",imgString);
        if ([Manager sharedManager].jinru != nil) {
            weakSelf.ar_cateid = [diction objectForKey:@"ar_cateid"];
            weakSelf.author = [diction objectForKey:@"ar_ly"];
            weakSelf.userpicture = [diction objectForKey:@"ar_userpic"];
        }else {
            weakSelf.ar_cateid = [diction objectForKey:@"xwcid"];
            weakSelf.userpicture = [diction objectForKey:@"dwlogo"];
            weakSelf.author = [diction objectForKey:@"dwname"];
        }
        
        
        [weakSelf setupheaderview];
//
       // if ( [Manager sharedManager].jinru != nil){
            [weakSelf lodXiangGuanNews];
      //  }
        
        [weakSelf lodCommandList];
        [weakSelf setupview];
        
        [weakSelf.tableview reloadData];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 7.5, ScreenW, 20)];
//    lab.backgroundColor = [UIColor colorWithWhite:0.85 alpha:0.5];
//    lab.textColor = [UIColor redColor];
//    if (section == 0) {
//        
//        //lab.text = @"   ◈相关新闻";
//        
//    }else {
//        lab.text = @"   ◈评论列表";
//        //lab.textAlignment = NSTextAlignmentCenter;
//    }
//    return lab;
//}





- (void)lodXiangGuanNews {
    if ([Manager sharedManager].jinru != nil) {
 
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.type != nil && self.ar_id != nil && self.ar_cateid != nil) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dic = @{@"type":self.type,@"ar_id":self.ar_id,@"ar_cateid":self.ar_cateid};
//        NSLog(@"$$$$$$$$$$   %@",dic);
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
    }else{
        [self lodzhengwuxiangguanxinwen];
    }
    
}

- (void)lodzhengwuxiangguanxinwen{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.type != nil && self.ar_id != nil && self.ar_cateid != nil) {
        __weak typeof(self) weakSelf = self;
        // NSDictionary *dic = @{@"type":self.type,@"ar_id":self.ar_id,@"ar_cateid":self.ar_cateid};
        NSString *urlstt = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/api/zw/correlation/ar_id/%@/xwcid/%@",self.ar_id,self.ar_cateid];
        
        [session GET:urlstt parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            NSMutableArray *array = [XGXWModel mj_objectArrayWithKeyValuesArray:arr];
            
            [weakSelf.xgxwArray removeAllObjects];
            if (array.count >0) {
                for (XGXWModel *model in array) {
                    [weakSelf.xgxwArray addObject:model];
                }
                
            }
            [weakSelf.tableview reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self.tableview.mj_footer endRefreshing];
            
        }];
    }
    
 
}
- (void)lodCommandList {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.ar_id != nil && self.ar_cateid != nil) {
        shanglaPage = 0;
        NSDictionary *para;
        if ([Manager sharedManager].jinru != nil) {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage]};
        }else {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage],@"state":@"1"};
        }
        
        __weak typeof(self) weakself = self;
        [session GET:@"http://zmdtt.zmdtvw.cn/Api/Pl/index" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding]] ;
            NSError *err;
            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingMutableLeaves error:&err];
            NSMutableArray *array = [commonmodel mj_objectArrayWithKeyValuesArray:arr];
            
            [self.contentarr removeAllObjects];
            NSMutableArray *arrr = [NSMutableArray arrayWithCapacity:1];
            for (commonmodel *model in array) {
                [arrr addObject:model];
                shanglaPage = [model.plid integerValue];
            }
            weakself.contentarr = arrr;
            weakself.vie.frame = CGRectMake(0, ScreenH - 50, ScreenW, 50);
            weakself.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
            
            weakself.textfield.text = nil;
            // self.textfield.hidden = NO;
            // self.textview.hidden = YES;
            weakself.but.hidden = YES;
            weakself.textfield.placeholder = @" 写评论。。。";
            
            [weakself.tableview reloadData];
            
            [weakself.textfield resignFirstResponder];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

//刷新数据
-(void)setUpReflashShangLa
{
    if (self.xgxwArray.count > 0) {
        
    __weak typeof (self) weakSelf = self;
    
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
           [weakSelf lodshangla];
        
    }];
    }
    
}


- (void)lodshangla{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    if (self.ar_id != nil && self.ar_cateid != nil) {
    NSDictionary *para;
        if ([Manager sharedManager].jinru != nil) {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage]};
        }else {
            para = @{@"id":self.ar_id,@"classid":self.ar_cateid,@"plid":[NSString stringWithFormat:@"%ld",shanglaPage],@"state":@"1"};
        }
        
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
            weakself.textfield.frame = CGRectMake(10, 5, ScreenW-170, 40);
            weakself.textfield.text = nil;
            //        self.textfield.hidden = NO;
            //        self.textview.hidden = YES;
            weakself.but.hidden = YES;
            weakself.textfield.placeholder = @" 写评论。。。";
            [weakself.tableview.mj_footer endRefreshing];
            [weakself.tableview reloadData];
            
            
            [weakself.textfield resignFirstResponder];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
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
   
    
}


- (void)common:(UIButton *)sender {
    
    if (_islocation == NO) {
        if ( [Manager sharedManager].jinru != nil) {
            if (self.xgxwArray.count != 0) {
                [UITableView animateWithDuration:0.1 animations:^{
                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [[self tableview] scrollToRowAtIndexPath:scrollIndexPath
                                            atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }];
            }
        }else {
            if (self.contentarr.count != 0) {
                [UITableView animateWithDuration:0.1 animations:^{
                    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
                    [[self tableview] scrollToRowAtIndexPath:scrollIndexPath
                                            atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }];
            }
        }
        
    }else {
        [UIWebView animateWithDuration:0.1 animations:^{
            CGPoint offset = self.tableview.contentOffset;
            offset.y = -mainHeight;
            self.tableview.contentOffset = offset;
        }];
    }
    _islocation = !_islocation;
}




- (void)sendMessage:(UIButton *)sender {
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    NSString *str = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (str != nil) {
        
        self.textfield.text = [[WordFilter sharedInstance] filter:self.textfield.text];
        [self addCommand];
    }else {
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
    int heightt = keyboardRect.size.height;
    self.vie.frame = CGRectMake(0, ScreenH - heightt-50, ScreenW, 50);
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
  
        NSDictionary *para;
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
            
            
           // NSLog(@"8888888%@",dic);
            if ([code isEqualToString:@"0"] ){
                [weakself lodCommandList];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
    
    
    
    
    //写评论的时候 保存当前时间 如果跟上次保存的一样 则不保存 不加积分 如果不一样 测保存 并加积分
    //获取当前时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStrv = [formatter stringFromDate:[NSDate date]];
    
    NSUserDefaults *user  = [NSUserDefaults standardUserDefaults];
    
    NSString *nowTime = [user objectForKey:@"meitianyici"];
    if ([nowTime isEqualToString:dateStrv]) {
        
    } else{
        [user setObject:dateStrv forKey:@"meitianyici"];
        NSString *stringUrl = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/api/Sign/comment_in?ptuid=%@",str];
        
        [NewNetWorkManager requestGETWithURLStr:stringUrl parDic:nil finish:^(id resonbject) {
            
        } conError:^(NSError *error) {
            
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
//            UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
            user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [Manager sharedManager].hiddenlogin = @"nohidden";
            [self presentViewController:user animated:YES completion:nil];
            
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
        
        [UMSocialData defaultData].extConfig.title = self.titlee;
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


- (void)setupheaderview {
    
    self.headView = [[UIView alloc]init];
    self.headView.backgroundColor = [UIColor colorWithRed:246/255.0 green:245/255.0 blue:246/255.0 alpha:1.0];
    
    _titable = [[UILabel alloc]initWithFrame:CGRectMake(20, 15,ScreenW-40, 0)];
    _titable.textAlignment = NSTextAlignmentLeft;
    _titable.font = [UIFont systemFontOfSize:24];
    _titable.text= self.titlee;
    _titable.numberOfLines = 0;
    _titable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake(ScreenW-40, 200*Kscalew);//labelsize的最大值
    CGSize expectSize = [_titable sizeThatFits:maximumLabelSize];
    _titable.frame = CGRectMake(20, 15, ScreenW-40, expectSize.height);
    mainHeight = expectSize.height;
    
    self.headView.frame = CGRectMake(0, 0, ScreenW, mainHeight+80);
   
   
    
    [self.headView addSubview:_titable];
    
    
    _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(20, mainHeight +55, 20, 20)];
    _imageview.backgroundColor = [UIColor whiteColor];
    _imageview.layer.masksToBounds = YES;
    _imageview.layer.cornerRadius = 10;
    //imageview.image = [UIImage imageNamed:@"3副本"];
    [_imageview.layer setBorderWidth:1.0];
    _imageview.layer.borderColor=[UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1].CGColor;
    [_imageview sd_setImageWithURL:[NSURL URLWithString:self.userpicture]];
    [self.headView addSubview:_imageview];
    
    _timelable = [[UILabel alloc]initWithFrame:CGRectMake(45, mainHeight+55,165, 20)];
    _timelable.numberOfLines = 0;
    _timelable.textAlignment = NSTextAlignmentLeft;
    _timelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _timelable.text= [NSString stringWithFormat:@"%@",self.author];
    [self.headView addSubview:_timelable];
    
    
    
    
    
    _sourcelable = [[UILabel alloc]initWithFrame:CGRectMake(20,mainHeight+25,150, 20)];
    _sourcelable.numberOfLines = 0;
    _sourcelable.textAlignment = NSTextAlignmentLeft;
    _sourcelable.font =  [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _sourcelable.text= [Manager timeWithTimeIntervalString:times];
    [self.headView addSubview:_sourcelable];


    
    
    _clicknum = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW-130*Kscalew,mainHeight+25, 120*Kscalew, 30)];
    _clicknum.textAlignment = NSTextAlignmentCenter;
    _clicknum.font =  [UIFont  fontWithName:@"STHeitiSC-Light" size:14.0];
    _clicknum.text= [NSString stringWithFormat:@"点击量:%@",self.onclick];
    [self.headView addSubview:_clicknum];
    
    
    bbtion = [UIButton buttonWithType:UIButtonTypeCustom];
    bbtion.frame = CGRectMake(ScreenW-120*Kscalew,mainHeight+55, 100*Kscalew, 20);
    bbtion.layer.masksToBounds = YES;
    bbtion.layer.cornerRadius = 8;
    [bbtion.layer setBorderWidth:0.5];
    bbtion.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [bbtion setTitle:@"🔊语音播报"forState:UIControlStateNormal];
    [bbtion setTitle:@"🔊播报中..."forState:UIControlStateSelected];
    [bbtion setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    bbtion.showsTouchWhenHighlighted=YES;
    bbtion.titleLabel.font = [UIFont systemFontOfSize:14];
    [bbtion addTarget:self action:@selector(start:)forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:bbtion];
    
    
   
//    self.guanzhu = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.guanzhu.frame = CGRectMake((ScreenW - 90),mainHeight+20, 70, 30);
//    self.guanzhu.layer.masksToBounds = YES;
//    self.guanzhu.layer.cornerRadius = 8;
//    [self.guanzhu setTitle:@"订阅＋" forState:UIControlStateNormal];
//    self.guanzhu.backgroundColor = [UIColor redColor];
//    int i=0;
//    for (NSString *string in self.dyid) {
//        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
//        
//        NSString *st = [numberFormatter stringFromNumber:userid];
//        
//        
//        i++;
//        if ([st isEqualToString:string]) {
//            [_guanzhu setTitle:@"已订阅" forState:UIControlStateNormal];
//            self.guanzhu.backgroundColor = [UIColor lightGrayColor];
//            self.take_id = self.dytakeid[i-1];
//            // self.guanzhu.userInteractionEnabled = NO;
//            //NSLog(@"111111");
//            self.zhu = YES;
//        }
//    }
//    
//    [self.guanzhu addTarget:self action:@selector(guanzhu:) forControlEvents:UIControlEventTouchUpInside];
//    [self.guanzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.tableview.tableHeaderView = self.headView;
}

-(void)start:(UIButton*)sender{
   
    if(sender.selected==NO) {
        if([av isPaused]) {
            //如果暂停则恢复，会从暂停的地方继续
            [av continueSpeaking];
            sender.selected = !sender.selected;
        }else{
            //初始化对象
            av = [[AVSpeechSynthesizer alloc]init];
            av.delegate = self;
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:[NSString stringWithFormat:@"%@,%@",self.titlee,bobaoString]];//需要转换的文字
            utterance.rate = 0.5;//设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
            AVSpeechSynthesisVoice *voicetype = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置发音，这是中文普通话en-US
            utterance.voice = voicetype;
            [av speakUtterance:utterance];//开始
            sender.selected = !sender.selected;
        }
    }else{
        //[av stopSpeakingAtBoundary:AVSpeechBoundaryWord];//感觉效果一样，对应代理>>>取消
        [av pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];//暂停
        sender.selected=!sender.selected;
    }
    
    
}


- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    [bbtion setTitle:@"🔊播报中..."forState:UIControlStateNormal];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    [bbtion removeFromSuperview];
    bbtion = [UIButton buttonWithType:UIButtonTypeCustom];
    bbtion.frame = CGRectMake(ScreenW-120*Kscalew,mainHeight+55, 100*Kscalew, 20);
    bbtion.layer.masksToBounds = YES;
    bbtion.layer.cornerRadius = 8;
    [bbtion.layer setBorderWidth:0.5];
    bbtion.layer.borderColor=[UIColor lightGrayColor].CGColor;
    [bbtion setTitle:@"🔊语音播报"forState:UIControlStateNormal];
    [bbtion setTitle:@"🔊播报中..."forState:UIControlStateSelected];
    [bbtion setTitleColor:[UIColor lightGrayColor]forState:UIControlStateNormal];
    bbtion.showsTouchWhenHighlighted=YES;
    bbtion.titleLabel.font = [UIFont systemFontOfSize:14];
    [bbtion addTarget:self action:@selector(start:)forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:bbtion];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    [bbtion setTitle:@"🔊暂停"forState:UIControlStateNormal];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    [bbtion setTitle:@"🔊播报中..."forState:UIControlStateNormal];
}
- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    [bbtion setTitle:@"🔊语音播报"forState:UIControlStateNormal];
}




@end
