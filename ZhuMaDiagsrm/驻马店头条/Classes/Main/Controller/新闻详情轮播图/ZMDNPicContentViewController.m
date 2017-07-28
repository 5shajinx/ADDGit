//
//  ZMDNPicContentViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/5/25.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZMDNPicContentViewController.h"
#import "MineSCModel.h"
#import "CommonTableviewController.h"
#import "ZMDUserTableViewController.h"
#import "UMSocial.h"

#import <Photos/Photos.h>
#import "HXEasyCustomShareView.h"


#define JULI (ScreenW - 320)/3

@interface ZMDNPicContentViewController ()<UIScrollViewDelegate, UITextViewDelegate,UITextFieldDelegate,UMSocialUIDelegate>
{
    NSString *ar_id;
    NSString *ar_cateid;
    NSString *ar_userid;
    NSString *ar_userpic;
    NSString *ar_volume;
    NSString *cname;
    NSString *shareurl;
    NSString *type;
    NSString *keep_id;
    UIImage *image;
   
}
@property(nonatomic, strong)HXEasyCustomShareView *shareView;
//图片数组
@property(nonatomic, strong) NSMutableArray *picDescArr;
@property(nonatomic, strong) NSMutableArray *titleDescArr;
//滑动的ScrollView
@property(nonatomic, strong) UIScrollView *detailScrollView;
//图片描述文字
@property(nonatomic, strong) UIView *descLabel;
@property(nonatomic, strong) UITextView *zmdTextView;
////中间图片
@property(nonatomic, strong) UIImageView *CenterimageView;
//中间图片下标
@property(nonatomic, assign) NSInteger centerIndex;
//是否显示文字
@property(nonatomic, assign) BOOL isShow;
@property(nonatomic, assign)BOOL iscollection;
@property(nonatomic, strong)UIView *vie;
@property(nonatomic, strong)UIButton *collection;

@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, strong)NSMutableArray *scid;
@property(nonatomic, strong)NSMutableArray *sckeepid;

@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)UIButton *common;
@property(nonatomic, strong)UIButton *share;

@property(nonatomic, strong)NSMutableDictionary *diction;
@property(nonatomic, strong)UIView *vii;

@end

@implementation ZMDNPicContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scid = [NSMutableArray arrayWithCapacity:1];
    self.sckeepid = [NSMutableArray arrayWithCapacity:1];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.diction = [NSMutableDictionary dictionaryWithCapacity:1];
    
    
    self.vie = [[UIView alloc]initWithFrame:CGRectMake(0, (ScreenH-45), ScreenW, 45)];
    _vie.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    //_vie.alpha = .5;
    [self.view addSubview:self.vie];
    
    [self setUpUI];
    //刚开始默认为0
    //_centerIndex = 0;
     [self lodCollectionList];
     _picDescArr = [[NSMutableArray alloc] initWithCapacity:1];
     _titleDescArr = [[NSMutableArray alloc] initWithCapacity:1];
     _isShow = YES;
    
    [self loadData];
   
    
}



//请求图片和描述。
-(void)loadData
{
//       [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        
        session.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        session.requestSerializer = [AFJSONRequestSerializer serializer];
        
        __weak typeof(self) weakSelf = self;
    
    NSString *str = [NSString stringWithFormat:@"http://zmdtt.zmdtvw.cn/index.php/Api/Index/getone?id=%@&type=%@",self.idString,self.typeString];
      NSString *string;
      if ([self.shareBiaoji isEqualToString:@"biaoji"]) {
          string = str;
      }else {
          string = self.manyPicLink;
      }
//    NSLog(@"self.manyPicLink---------%@",self.manyPicLink);
    
//         NSLog(@"ffffffffffff    %@",string);
        [session GET:string parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
//            NSLog(@"%@",dic);
            ar_id = (NSString *)[dic objectForKey:@"ar_id"];
            ar_userid = [dic objectForKey:@"ar_userid"];
            ar_userpic = [dic objectForKey:@"ar_userpic"];
            ar_volume = [dic objectForKey:@"ar_volume"];
            cname = [dic objectForKey:@"cname"];
            shareurl = [dic objectForKey:@"shareurl"];
            ar_cateid = [dic objectForKey:@"ar_cateid"];
            type = [dic objectForKey:@"ar_type"];
            
            
            NSString *picStr = [dic objectForKey:@"ar_morepic"];
            if (picStr.length != 0) {
                NSString *dd =  [picStr substringToIndex:picStr.length-6];
                NSArray *eachData =  [dd componentsSeparatedByString:@"||||||"];
                for (NSString *str in eachData)
                {
                    NSArray *picDesc =  [str componentsSeparatedByString:@"::::::"];
//                    NSLog(@"--------%@",picDesc[1]);
                   
                    
                    
                    [_picDescArr addObject:picDesc];
                }
            }
            

            if (_picDescArr.count != 0) {
                [weakSelf setUpUI];
                
                [weakSelf scrollViewDidEndDecelerating:weakSelf.detailScrollView];
            }
            
 
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            

        }];
        

}


//布局
-(void)setUpUI
{
    _detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-50* Kscaleh)];
    //_detailScrollView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:_detailScrollView];
    _detailScrollView.pagingEnabled = YES;
    _detailScrollView.showsHorizontalScrollIndicator = NO;
    _detailScrollView.bounces = NO;
    self.detailScrollView.delegate = self;
    _detailScrollView.contentSize = CGSizeMake(_picDescArr.count * ScreenW , 0);
    
    //[self.view bringSubviewToFront:self.vie];
    
    _zmdTextView = [[UITextView alloc] init];
//    _zmdTextView.scrollEnabled = NO;
    _zmdTextView.editable = NO;
    _zmdTextView.font = [UIFont systemFontOfSize:16.0];
    _zmdTextView.textAlignment = NSTextAlignmentLeft;
    _zmdTextView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.5];
    _zmdTextView.textColor = [UIColor whiteColor];
    _zmdTextView.delegate = self;
    [self.view addSubview:_zmdTextView];
    
    _zmdTextView.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:_zmdTextView];
    
    for (int i = 0; i < _picDescArr.count; i++)
    {
        self.CenterimageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenW, 0, ScreenW, ScreenH-50*Kscaleh)];
        _CenterimageView.userInteractionEnabled = YES;
        [_detailScrollView addSubview:_CenterimageView];
        _CenterimageView.contentMode = UIViewContentModeScaleAspectFit;
        _CenterimageView.tag = i + 1000;
        _CenterimageView.userInteractionEnabled = YES;
        [_CenterimageView sd_setImageWithURL:_picDescArr[i][1] placeholderImage:[UIImage imageNamed:@"hui"]];
        
        UILongPressGestureRecognizer *tapp  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savepic:)];
//        tapp.numberOfTapsRequired = 2;
//        tapp.numberOfTouchesRequired = 1;
        [_CenterimageView addGestureRecognizer:tapp];
        

        
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenText:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [_CenterimageView addGestureRecognizer:tap];
        
//        UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
//        [_CenterimageView addGestureRecognizer:pinchGesture];
//        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//        [_CenterimageView addGestureRecognizer:panGesture];
        
        
        
        
        
    }
    
    [self setupview];
}

- (void)savepic:(UILongPressGestureRecognizer *)gesture {
    NSInteger i;
    UIImageView *tempimage = (UIImageView *)gesture.view;
    [self.picDescArr objectAtIndex:tempimage.tag - 1000];
    i = tempimage.tag-1000;
    
    NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:_picDescArr[i][1]]];
    image = [[UIImage alloc]initWithData:data];
    
    //第一个参数是图片对象，第二个参数是压的系数，其值范围为0~1。
    NSData  * imageData = UIImageJPEGRepresentation(image, 0.5);
    UIImage * newImage = [UIImage imageWithData:imageData];
    
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"是否保存图片" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionsure = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            //写入图片到相册
           [PHAssetChangeRequest creationRequestForAssetFromImage:newImage];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            //NSLog(@"success = %d, error = %@", success, error);
        }];
        
    }];
    [alertVC addAction:actionsure];
    [alertVC addAction:actionsure1];
    [self presentViewController:alertVC animated:YES completion:nil];
}



- (void)handlePan:(UIPanGestureRecognizer *)sender{

    CGPoint point = [sender translationInView:sender.view];
    sender.view.transform = CGAffineTransformTranslate(sender.view.transform, point.x, point.y);
    [sender setTranslation:CGPointZero inView:sender.view];
}
- (void)handlePinch:(UIPinchGestureRecognizer *)sender {
   // NSLog(@"nie he");
    sender.view.transform = CGAffineTransformScale( sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
}














//代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger x =  scrollView.contentOffset.x /scrollView.bounds.size.width;
   // NSLog(@"%ld",(long)x);
    if (_picDescArr.count != 0) {
        CGFloat terxtHeight = [self getTheString:_picDescArr[x][2] withMaxWidth:ScreenW ];
        
        _zmdTextView.frame = CGRectMake(0, ScreenH - terxtHeight - 60*Kscaleh, ScreenW , terxtHeight+10);
        
        if (terxtHeight > (ScreenH-50*Kscaleh)/2)
        {
            
        _zmdTextView.text = [NSString stringWithFormat:@"[%ld/%ld] %@",x+1,_picDescArr.count,_picDescArr[x][2]];
            _zmdTextView.scrollEnabled = NO;
        }
        else
        {
            //NSLog(@"tupianlunboxiangqing   %@",_picDescArr);
        _zmdTextView.text = [NSString stringWithFormat:@"[%ld/%ld] %@",x+1,_picDescArr.count,_picDescArr[x][2]];
            _zmdTextView.scrollEnabled = NO;
            //        _descLabel.text = [NSString stringWithFormat:@"第%ld页",x+1];
            // [self setupview];
        }
        
       
    }
    
    
}



//textView 代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}



//自适应
-(CGFloat)getTheString:(NSString*)textString withMaxWidth:(CGFloat)maxWidth
{
    
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:16.0], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    CGSize contentSize = [textString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
    return contentSize.height;
}



-(void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
}


-(void)hiddenText:(UITapGestureRecognizer*)tap
{
    if (_isShow == NO) {
       
        _zmdTextView.hidden = YES;
        _descLabel.hidden = YES;
        self.vie.hidden = YES;
        self.vii.hidden = YES;
    }else
    {
       
        _zmdTextView.hidden = NO;
        _descLabel.hidden = NO;
        self.vie.hidden = NO;
        self.vii.hidden = NO;
    }
    
    _isShow = !_isShow;
}

- (void)setupview {
    
    
    
    
    
    
    
    self.vii = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.vii.backgroundColor = [UIColor clearColor];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.frame = CGRectMake(10,10, 50, 50);
    _btn.layer.masksToBounds = YES;
    //_btn.layer.cornerRadius = 15;
    _btn.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.01];
    _btn.userInteractionEnabled = YES;
    [_btn setTitle:@"ㄨ" forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.vii addSubview:_btn];
    [self.view addSubview:self.vii];
    
    
    self.textfield = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, ScreenW-170, 35)];
    self.textfield.backgroundColor = [UIColor colorWithRed:44/255.0 green:44/255.0 blue:44/255.0 alpha:1.0];
    self.textfield.font = [UIFont systemFontOfSize:14];
    self.textfield.layer.masksToBounds = YES;
    self.textfield.layer.cornerRadius = 10;
    self.textfield.delegate  = self;
    self.textfield.placeholder = @" 写评论。。。";
    self.textfield.textColor = [UIColor whiteColor];
    [self.textfield setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    [self.textfield setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.vie addSubview:self.textfield];
    
    
    self.common = [UIButton buttonWithType:UIButtonTypeCustom];
    self.common.frame = CGRectMake((ScreenW - 150),7.5, 30, 30);
    self.common.layer.masksToBounds = YES;
    self.common.layer.cornerRadius = 15;
    //common.backgroundColor = [UIColor whiteColor];
    [self.common setImage:[UIImage imageNamed:@"baicomm.png"] forState:UIControlStateNormal];
    [self.common addTarget:self action:@selector(common:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.common];
    
    self.collection = [UIButton buttonWithType:UIButtonTypeCustom];
    self.collection.frame = CGRectMake((ScreenW - 100),7.5, 30, 30);
    self.collection.layer.masksToBounds = YES;
    self.collection.layer.cornerRadius = 15;
     [self.collection setImage:[UIImage imageNamed:@"baicollect.png"] forState:UIControlStateNormal];
    
   // _iscollection = NO;
    
    int i=0;
    for (NSString *string in self.scid) {
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *st = [numberFormatter stringFromNumber:ar_id];
        i++;
        if ([st isEqualToString:string]) {
            [self.collection setImage:[UIImage imageNamed:@"collection.png"] forState:UIControlStateNormal];
            keep_id = self.sckeepid[i-1];
            self.iscollection = YES;
         }
     }
   
    [self.collection addTarget:self action:@selector(collection:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.collection];
    
    
    self.share = [UIButton buttonWithType:UIButtonTypeCustom];
    self.share.frame = CGRectMake((ScreenW - 50),7.5, 30, 30);
    self.share.layer.masksToBounds = YES;
    self.share.layer.cornerRadius = 15;
    //share.backgroundColor = [UIColor whiteColor];
    [self.share setImage:[UIImage imageNamed:@"baishare.png"] forState:UIControlStateNormal];
    [self.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [self.vie addSubview:self.share];
    
    
   
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)common:(UIButton *)sender {
    CommonTableviewController *common = [[CommonTableviewController alloc]init];
    common.ar_id = ar_id;
    common.ar_cateid = ar_cateid;
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:common];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.textfield resignFirstResponder];
    
    CommonTableviewController *common = [[CommonTableviewController alloc]init];
    common.ar_id = ar_id;
    common.ar_cateid = ar_cateid;
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:common];
     na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:na animated:YES completion:nil];
    
    return NO;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
    UITouch *oneTouch = [touches anyObject];
    if (oneTouch.tapCount == 1) {
        
        self.vie.hidden = NO;
    }

}



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
        //NSLog(@"%@^^^^^^^^^^^^^%@",weakSelf.scid,weakSelf.sckeepid);
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
    
    NSDictionary *dic = @{@"keep_id":keep_id};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/delkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        
        NSError *err;
        
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            [weakSelf.collection setImage:[UIImage imageNamed:@"baicollect"] forState:UIControlStateNormal];
            // [self lodCollectionList];
            weakSelf.iscollection = NO;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


- (void)lodCollection {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    __weak typeof(self) weakSelf = self;
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = @{@"ptuid":str,@"ar_id":ar_id,@"type":type};
    
    [session GET:@"http://zmdtt.zmdtvw.cn/api/keep/addkeep" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        keep_id = [dicc objectForKey:@"keep_id"];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
            [weakSelf.collection setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            // [self lodCollectionList];
              weakSelf.iscollection = YES;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




- (void)share:(UIButton *)sender{
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
- (void)easyCustomShareViewButtonAction:(HXEasyCustomShareView *)shareView title:(NSString *)title {
    //NSLog(@"tagg =======  %ld",tagg);
    NSString *strTitle = @"驻马店广播电视台";

    if ([title isEqualToString:@"微信"]) {
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.wechatSessionData.url = shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.picture];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:self.sharetitle image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
            self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"朋友圈"]) {
        [UMSocialData defaultData].extConfig.title = self.sharetitle;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.picture];
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareurl image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
             self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"QQ"]) {
        [UMSocialData defaultData].extConfig.title = strTitle;
        [UMSocialData defaultData].extConfig.qqData.url = shareurl;
        
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.picture];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:self.sharetitle image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
             self.shareView.hidden = YES;
        }];
    }
    if ([title isEqualToString:@"QQ空间"]) {
        [UMSocialData defaultData].extConfig.title = self.sharetitle;
        [UMSocialData defaultData].extConfig.qzoneData.url = shareurl;
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.picture];
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareurl image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                
            }
             self.shareView.hidden = YES;
        }];
    }
    
    
    
    if ([title isEqualToString:@"新浪微博"]) {
        UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:
                                            self.picture];

        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",self.sharetitle,shareurl] image:[UIImage imageNamed:@"11111"] location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
            if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            }
             self.shareView.hidden = YES;
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
     self.shareView.hidden = YES;
}




@end
