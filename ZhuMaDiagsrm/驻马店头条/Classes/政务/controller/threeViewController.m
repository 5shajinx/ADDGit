//
//  threeViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/13.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "threeViewController.h"
#import "ZWFUModel.h"



#import "CustomButton.h"



static NSString *fuwuwebCasher = @"FUWUCasher";
static NSString *ad = @"FUWUCasherad";

@interface threeViewController ()
{
    NSString *name;
    NSString *link;
    CGFloat height;
}
@property (nonatomic, strong)UIScrollView *scrollview;
@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation threeViewController

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"政库";
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    
    self.navigationItem.leftBarButtonItem = bar;
    
   
    
    self.scrollview = [[UIScrollView alloc]init];
    self.scrollview.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    self.scrollview.showsVerticalScrollIndicator = NO;
    self.scrollview.scrollEnabled = YES;
    
    [self.view addSubview:self.scrollview];
    
    
    
    
    
    [self getDataFromlocalAD];
    [self lodAD];
    
    [self getDataFromlocal];
    [self lodcontent];
    
    dispatch_async(dispatch_get_main_queue(), ^{        
        [self setbutton];
    });
    
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)setbutton {
    
    int b = 0;
    int hangshu;
    if (self.dataArray.count % 3 == 0 ) {
        hangshu = (int )self.dataArray.count / 3;
    } else {
        hangshu = (int )self.dataArray.count / 3 + 1;
    }
    //j是小于你设置的列数
    for (int i = 0; i < hangshu; i++) {
        for (int j = 0; j < 3; j++) {
            CustomButton *btn = [CustomButton buttonWithType:UIButtonTypeCustom];
            if ( b  < self.dataArray.count) {
                ZWFUModel *model = self.dataArray[b];
                btn.frame = CGRectMake((0  + j * ScreenW/3), (150*Kscaleh + i * 120*Kscaleh) ,ScreenW/3, 120*Kscaleh);
                btn.backgroundColor = [UIColor whiteColor];
                btn.tag = b;
                [btn setTitle:model.name forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                height = i * 120*Kscaleh + 400*Kscaleh;
                [self.scrollview setContentSize:CGSizeMake(ScreenW, height)];
                //NSLog(@"-------%lf------%lf",ScreenH,height);
                
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:model.logo]];
                UIImage *image = [[UIImage alloc]initWithData:data];
                
                [btn setImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(yejian:) forControlEvents:UIControlEventTouchUpInside];
                [btn.layer setBorderColor:[UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1].CGColor];
                [btn.layer setBorderWidth:0.5f];
                [btn.layer setMasksToBounds:YES];
                [self.scrollview addSubview:btn];
                
                if (b > self.dataArray.count   )
                {
                    [btn removeFromSuperview];
                }
            }
            b++;
            
        }
    }

   
}

- (void)yejian:(UIButton *)sender
{
    ZWFUModel *model = [self.dataArray objectAtIndex:sender.tag];
    WaiLianController *zwfw = [[WaiLianController alloc]init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:zwfw];
    zwfw.urlString = model.link;
    zwfw.titleename = model.name;
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self  presentViewController:na animated:YES completion:nil];
}




- (void)getDataFromlocal {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:fuwuwebCasher];
        NSMutableArray  *fileDic = [NSMutableArray arrayWithContentsOfFile:filewebCaches];
        //NSLog(@"%@",filewebCaches);
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodcontent];
        }else {
            [self hhhhhhhhhh:fileDic];
        }
//        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [self setbutton];
//        });
        
    });
}

- (void)hhhhhhhhhh:(id)arr{
     self.dataArray = [ZWFUModel  mj_objectArrayWithKeyValuesArray:arr];
    
     [self setbutton];
 }




- (void)lodcontent {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    session.requestSerializer = [AFJSONRequestSerializer serializer];
     //[MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    __weak typeof(self) weakSelf = self;
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/zw/zwfw" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
            NSString *filewebCaches = [file stringByAppendingPathComponent:fuwuwebCasher];
            [arr writeToFile:filewebCaches atomically:YES];
            
        });
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf hhhhhhhhhh:arr];
            
        });
        

        
        
       
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
    }];

}







- (void)getDataFromlocalAD {
    //从本地取数据
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        NSString *filewebCaches = [file stringByAppendingPathComponent:ad];
        NSMutableDictionary  *fileDic = [NSMutableDictionary dictionaryWithContentsOfFile:filewebCaches];
        //判断是否存在缓存  存在 则取数据  不存在 就请求网络
        if (fileDic == nil) {
            [self lodAD];
        }else {
            [self loddataAD:fileDic];
        }
//        //回到主线程刷新ui
//        dispatch_async(dispatch_get_main_queue(), ^{
//           
//        });
        
    });
}

- (void)lodAD{
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //[MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    __weak typeof(self) weakSelf = self;
    
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/api/ad/index?pid=402" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        if (![dic isEqual:[NSNull null]]){
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSString *file = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
                NSString *filewebCaches = [file stringByAppendingPathComponent:ad];
                [dic writeToFile:filewebCaches atomically:YES];
            });
            [weakSelf loddataAD:dic];
        }
        
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //[MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
    }];

}
- (void)loddataAD:(NSMutableDictionary *)dic{

    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 150*Kscaleh)];
//    imageview.image = [UIImage imageNamed:@"120"];
    //[imageview sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"ad_code"]]];
    
    if ([dic isEqual:[NSNull null]]){
        imageview.image = [UIImage imageNamed:@"hui"];
    }else {
        [imageview sd_setImageWithURL: [NSURL URLWithString:[dic objectForKey:@"ad_code"]] placeholderImage:[UIImage imageNamed:@"hui"]];
    }
    
    
    
    imageview.userInteractionEnabled = YES;
    imageview.contentMode = UIViewContentModeScaleAspectFill;
    imageview.clipsToBounds = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
    [imageview addGestureRecognizer:tap];
    
//     UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 150*Kscaleh)];
//    lable.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//    [imageview addSubview:lable];
    
    
    
//    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 115*Kscaleh, ScreenW-40, 30*Kscaleh)];
//    lab.text = [dic objectForKey:@"ad_name"];
//    lab.textColor = [UIColor whiteColor];
//    [imageview addSubview:lab];
    
    link = [dic objectForKey:@"ad_link"];
    name = [dic objectForKey:@"ad_name"];
    
    [self.scrollview addSubview:imageview];
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
