//
//  AddLiveBroadcastController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/10.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "AddLiveBroadcastController.h"
#import "PrefixHeader.pch"
#import "ADTableViewController.h"
#import "AddjizheModel.h"
#import "CuiPickerView.h"
#import "TwoModel.h"
@interface AddLiveBroadcastController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CuiPickViewDelegate>
{
    NSString *classid;
    NSString *zhuchiid;
}
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)NSMutableArray *array;
@property(nonatomic, strong)UIImage *liveImage;

@property (nonatomic, strong) CuiPickerView *cuiPickerView;
@property (nonatomic, strong) NSString *dataString;


@property(nonatomic, strong)NSMutableArray *namearray;
@property(nonatomic, strong)NSMutableArray *idarray;
@end

@implementation AddLiveBroadcastController

- (NSString *)timeWithTimeIntervalString:(NSString *)str {
    NSTimeInterval time =[str doubleValue];
    
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd H:mm"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加直播";
    
    self.array = [NSMutableArray arrayWithCapacity:1];
    self.namearray = [NSMutableArray arrayWithCapacity:1];
    self.idarray = [NSMutableArray arrayWithCapacity:1];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    self.fenleiTextfield.delegate = self;
    self.zhuchirenTextField.delegate = self;
    self.biaotiTextfield.delegate = self;
    self.miaoshuTextView.delegate = self;
    self.startTIME.delegate = self;
    self.endTIME.delegate = self;
    
    
   
    
    _cuiPickerView = [[CuiPickerView alloc]init];
    _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height+140, self.view.frame.size.width, 200);
    //这一步很重要
    _cuiPickerView.myTextField = self.textfield;
    _cuiPickerView.delegate = self;
    _cuiPickerView.curDate=[NSDate date];
    [self.view addSubview:_cuiPickerView];
    
    
    if ([Manager sharedManager].zhibobiaoji != nil) {
        self.fenleiTextfield.text    = self.fenlei;
        self.zhuchirenTextField.text = self.zhuchiren;
        self.biaotiTextfield.text    = self.biaoti;
        self.miaoshuTextView.text    = self.miaoshu;
        [self.selectedImage sd_setImageWithURL:[NSURL URLWithString:self.tupian]];
        
        self.startTIME.text    =   self.kaishi;
        
        self.endTIME.text      =   self.jieshu;
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.tupian]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            //if (data != nil) {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    //在这里做UI操作(UI操作都要放在主线程中执行)
                    self.liveImage = image;
                //});
            //}
        //});
    }
    
    [self lodtype];
    [self lodjizhelist];
    
    
    
    self.botummonView.userInteractionEnabled = YES;
    [self.view sendSubviewToBack:self.botummonView];
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
    
}

- (void)lodjizhelist {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    
    
    __weak typeof(self) weakSelf = self;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=host&userid=%@",[[Manager sharedManager] md5:single],[Manager sharedManager].userid];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        NSMutableArray  *arr   = [NSMutableArray arrayWithCapacity:1];
        arr = [dicc objectForKey:@"data"];
        for (TwoModel *model in [TwoModel mj_objectArrayWithKeyValuesArray:arr]) {
            if ([weakSelf.zhuchirenid isEqualToString:model.hostid]) {
                weakSelf.zhuchirenTextField.text = model.hostname;
            }
        }
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        if ([code isEqualToString:@"0"] ) {
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}



//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    if (self.miaoshuTextView && !self.biaotiTextfield) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        self.botummonView.frame = CGRectMake(0, 60-height, ScreenW, ScreenH);
    }
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    self.botummonView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    
}



- (void)viewWillAppear:(BOOL)animated {
         
        self.miaoshuTextView.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:0.5]CGColor];
        self.miaoshuTextView.layer.borderWidth = 1.0;
        self.miaoshuTextView.layer.cornerRadius = 3.0f;
        [self.miaoshuTextView.layer setMasksToBounds:YES];
//    NSLog(@"%@----%@------%@",self.zhuchirenid,[Manager sharedManager].zhuchirenid,[Manager sharedManager].zhibobiaoji);
    
    if ([Manager sharedManager].zhibobiaoji == nil) {
        self.zhuchirenTextField.text = [Manager sharedManager].zhuchiren;
        classid     =  [Manager sharedManager].classifyid;
        zhuchiid    =  [Manager sharedManager].zhuchirenid;
    }
    
    if ([Manager sharedManager].zhibobiaoji != nil) {
        self.zhuchirenTextField.text = [Manager sharedManager].zhuchiren;
        
        [Manager sharedManager].editjizheid = [Manager sharedManager].zhuchirenid;
        [Manager sharedManager].zhuchirenid = self.zhuchirenid;
        [Manager sharedManager].classifyid  = self.zhibotypeid;
        
        if ([Manager sharedManager].editjizheidbiaoji != nil) {
            [Manager sharedManager].zhuchirenid = [Manager sharedManager].editjizheid;
        }
    }
    
//    NSLog(@"=====%@",self.zhuchirenTextField.text);
    
    
}




- (void)lodeditzhibo {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

    __weak typeof(self) weakSelf = self;
   
    UIImage * image =  self.liveImage;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY-M-dd H:mm"];
    NSDate* date1 = [dateFormatter1 dateFromString:self.startTIME.text];
    NSString *timeSp1 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-M-dd H:mm"];
    NSDate* date2 = [dateFormatter2 dateFromString:self.endTIME.text];
    NSString *timeSp2 = [NSString stringWithFormat:@"%ld", (long)[date2 timeIntervalSince1970]];
    
//     NSLog(@"修改直播-------－%@－－－%@－－－－%@",[Manager sharedManager].classifyid,[Manager sharedManager].zhuchirenid,self.zhiboid);
    
    if ([Manager sharedManager].classifyid != nil && [Manager sharedManager].zhuchirenid != nil && self.biaotiTextfield.text.length != 0 &&self.miaoshuTextView.text.length != 0 && self.zhiboid != nil && image) {
        
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"uplive",@"classify":[Manager sharedManager].classifyid,@"presenter":[Manager sharedManager].zhuchirenid,@"title":self.biaotiTextfield.text,@"depict":self.miaoshuTextView.text,@"zb_id":self.zhiboid,@"starttime":timeSp1,@"endtime":timeSp2};
        
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(image);
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            //NSLog(@" addjizhe  ======  %@",dicc );
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                [Manager sharedManager].zhuchirenid = nil;
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
        }];
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"数据不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }

 
}

- (void)addlodlist {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

    
    __weak typeof(self) weakSelf = self;
    
    UIImage * image =  self.liveImage;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
   
  
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"YYYY-M-dd H:mm"];
    NSDate* date1 = [dateFormatter1 dateFromString:self.startTIME.text];
    NSString *timeSp1 = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
    
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"YYYY-M-dd H:mm"];
    NSDate* date2 = [dateFormatter2 dateFromString:self.endTIME.text];
    NSString *timeSp2 = [NSString stringWithFormat:@"%ld", (long)[date2 timeIntervalSince1970]];

    
   // NSLog(@"startTIME==%@----------endTIME==%@",timeSp1,timeSp2);
//    NSLog(@"tttttt-------－%@－－－%@－－－－  %@",classid,[Manager sharedManager].userid,[Manager sharedManager].zhuchirenid);
    
    
    if (classid != nil && [Manager sharedManager].zhuchirenid != nil && self.biaotiTextfield.text.length != 0 &&self.miaoshuTextView.text.length != 0 && classid != nil && image){
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"addlive",@"classify":classid,@"presenter":[Manager sharedManager].zhuchirenid,@"title":self.biaotiTextfield.text,@"depict":self.miaoshuTextView.text,@"userid":[Manager sharedManager].userid,@"starttime":timeSp1,@"endtime":timeSp2};
//        NSLog(@"tttttt-------===－－－－－－－－  %@",para);
        
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(image);
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/png"];
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
            NSError *err;
            NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
            
            //NSLog(@" addjizhe  ======  %@",dicc );
            
            NSNumber *number = [dicc objectForKey:@"code"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            NSString *code = [numberFormatter stringFromNumber:number];
            
            if ([code isEqualToString:@"0"] ) {
                [Manager sharedManager].zhuchirenid = nil;
                //NSLog(@"%@",[dicc objectForKey:@"Message"]);
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
        }];
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"数据不能为空" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
        
    
    
    
}




- (IBAction)clickFuBuButton:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([Manager sharedManager].zhibobiaoji != nil) {
        [self lodeditzhibo];
    }
    if ([Manager sharedManager].zhibobiaoji == nil) {
        [self addlodlist];
    }
    
}
 


- (IBAction)tapgesture:(id)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *vc1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pictureFromCamera];
    }];
    UIAlertAction *vc2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickerPictureFromAlbum];
    }];
    UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:vc1];
    [alertVC addAction:vc2];
    [alertVC addAction:actioncancle];
    [self presentViewController:alertVC animated:YES completion:nil];
}


//从手机相册选取图片功能
- (void)pickerPictureFromAlbum {
    //1.创建图片选择器对象
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagepicker.allowsEditing = YES;
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
    
}

//拍照--照相机是否可用
- (void)pictureFromCamera {
    
    //照相机是否可用
    
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!isCamera) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *vc1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:vc1];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    
    //创建图片选择器对象
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置图片选择器选择图片途径
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;//从照相机拍照选取
    //设置拍照时下方工具栏显示样式
    imagePicker.allowsEditing = YES;
    //设置代理对象
    imagePicker.delegate = self;
    //最后模态退出照相机即可
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
//当得到选中的图片或视频时触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //拿到图片
    UIImage *imagesave = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.selectedImage.image = imagesave;
    
    
    self.liveImage = [[Manager sharedManager] thumbnailWithImageWithoutScale:imagesave size:CGSizeMake(500, 500)];
     
    
    //模态退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
 
}



- (void)lodtype {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

     __weak typeof(self) weakSelf = self;
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=classify",[[Manager sharedManager] md5:single]];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        
        NSMutableArray *arr =  [dicc objectForKey:@"data"];
        weakSelf.array = [AddjizheModel mj_objectArrayWithKeyValuesArray:arr];
        
        for (AddjizheModel *model in weakSelf.array) {
            [self.namearray addObject:model.classifyname];
            [self.idarray addObject:model.classifyid];
            
            
            if ([self.zhibotypeid isEqualToString:model.classifyid]) {
                self.fenleiTextfield.text = model.classifyname;
               
            }
        }
        
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
      
        
        
        
        if ([code isEqualToString:@"0"] ) {
            
            
            
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}


////开始编辑
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
//    [_cuiPickerView showInView:self.view];
//}



//赋值给textField
-(void)didFinishPickView:(NSString *)date
{
    self.dataString = date;
    
    if ([_textfield isEqual:self.startTIME]) {
        self.startTIME.text = date;
        
    }
    if ([_textfield isEqual:self.endTIME]) {
        self.endTIME.text = date;
       

    }
    
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
         return NO;
    }
    return YES;
}



//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.textfield = textField;
    //AddjizheModel *model = [self.array objectAtIndex:indexPath.row];
    //self.fenleiTextfield.text = cell.textLabel.text;
    //[Manager sharedManager].classifyid = model.classifyid;
    
    
    if ([textField isEqual:self.fenleiTextfield] ) {
        //self.vie.hidden = NO;
        if (self.namearray.count != 0) {
            NSString *str  =  self.namearray[0];
            NSString *str1 =  self.namearray[1];
           NSString *str2 =  self.namearray[2];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择分类" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *vc1 = [UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.fenleiTextfield.text = str;
                [Manager sharedManager].classifyid = self.idarray[0];
            }];
            
            UIAlertAction *vc2 = [UIAlertAction actionWithTitle:str1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.fenleiTextfield.text = str1;
                [Manager sharedManager].classifyid = self.idarray[1];
            }];
            UIAlertAction *vc3 = [UIAlertAction actionWithTitle:str2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.fenleiTextfield.text = str2;
                [Manager sharedManager].classifyid = self.idarray[2];
            }];
            UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertVC addAction:vc1];
            [alertVC addAction:vc2];
            [alertVC addAction:vc3];
            [alertVC addAction:actioncancle];
            [self presentViewController:alertVC animated:YES completion:nil];
            
           
        }
         return NO;
    }
    if ([textField isEqual:self.zhuchirenTextField]) {
        ADTableViewController *zhuchiren = [[ADTableViewController alloc]init];
        [self.navigationController pushViewController:zhuchiren animated:YES];
        return NO;
    }
    
    if ([textField isEqual:self.startTIME]) {
        [self.textfield resignFirstResponder];
       self.textfield = self.startTIME;
        textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        [_cuiPickerView showInView:self.view];
        
        [self.view bringSubviewToFront:self.cuiPickerView];
        return NO;
    }
    if ([textField isEqual:self.endTIME]) {
        [self.textfield resignFirstResponder];
        self.textfield = self.endTIME;
        textField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
        [_cuiPickerView showInView:self.view];
        [self.view bringSubviewToFront:self.cuiPickerView];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
    [self.miaoshuTextView resignFirstResponder];
    
    [_cuiPickerView hiddenPickerView];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)leftClickAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
