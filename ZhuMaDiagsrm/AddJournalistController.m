//
//  AddJournalistController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/10.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "AddJournalistController.h"
#import "PrefixHeader.pch"


@interface AddJournalistController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSString *typeid;
}

@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)NSMutableArray *array;

@property(nonatomic, strong)UIImage *userImage;
@end

@implementation AddJournalistController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加记者";
    self.array = [NSMutableArray arrayWithCapacity:1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    if ([Manager sharedManager].edit != nil) {
        self.nameTextfield.text    = self.xingming;
        self.miaotextfield.text    = self.miaoshu;
        self.shenfentextfield.text = self.shenfen;
        [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.fengmian]];
        
    
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.fengmian]];
            UIImage *image = [[UIImage alloc]initWithData:data];
            //if (data != nil) {
                //dispatch_async(dispatch_get_main_queue(), ^{
                    //在这里做UI操作(UI操作都要放在主线程中执行)
                    self.userImage = image;
               // });
            //}
        //});
        
        
    }
    
    
    self.nameTextfield.delegate = self;
    self.miaotextfield.delegate = self;
    self.shenfentextfield.delegate = self;
    
    [self lodtype];
    
}




- (void)lodeditjizhe {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

    __weak typeof(self) weakSelf = self;
    
    UIImage * image =  self.userImage;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    if (self.nameTextfield.text.length != 0 && self.miaotextfield.text.length != 0 && self.leixingid != nil && self.jizheid != nil && image) {
        
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"uphost",@"hostname":self.nameTextfield.text,@"depict":self.miaotextfield.text,@"typeid":self.leixingid,@"hostid":self.jizheid};
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(image);
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMdd-HHmmss";
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
                // NSLog(@"%@",[dicc objectForKey:@"message"]);
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



- (void)lodlist {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer  = [AFJSONRequestSerializer serializer];
    
    session.responseSerializer.acceptableContentTypes = nil;
    session.securityPolicy = [AFSecurityPolicy defaultPolicy];
    session.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    session.securityPolicy.validatesDomainName = NO;//是否验证域名
    

    __weak typeof(self) weakSelf = self;
   
    UIImage * image =  self.userImage;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSDate* date = [dateFormatter dateFromString:dateString];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSString *single = [NSString stringWithFormat:@"app_key%@",timeSp];
    
    
//    NSLog(@"tttttt-------－%@－－－－－－－%@",typeid,[Manager sharedManager].userid);
    
    if (self.nameTextfield.text.length != 0 && self.miaotextfield.text.length != 0 && typeid != nil && [Manager sharedManager].userid != nil && image) {
        
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"addhost",@"hostname":self.nameTextfield.text,@"depict":self.miaotextfield.text,@"typeid":typeid,@"userid":[Manager sharedManager].userid};
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSData * data   =  UIImagePNGRepresentation(image);
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMdd=HHmmss";
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
                //NSLog(@"%@",[dicc objectForKey:@"message"]);
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



- (void)viewWillAppear:(BOOL)animated
{
    
    self.miaotextfield.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:0.5]CGColor];
    self.miaotextfield.layer.borderWidth = 1.0;
    self.miaotextfield.layer.cornerRadius = 3.0f;
    [self.miaotextfield.layer setMasksToBounds:YES];
    
    
    
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
    
    if ([textField isEqual:self.shenfentextfield]) {
        if (self.array.count != 0) {
            NSString *str1 = [self.array[0] objectForKey:@"typename"];
            NSString *str2 = [self.array[1] objectForKey:@"typename"];
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择身份" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *vc1 = [UIAlertAction actionWithTitle:str1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.shenfentextfield.text = str1;
                //NSLog(@"0000");
                typeid = [self.array[0] objectForKey:@"typeid"];
                self.leixingid = typeid;
                //NSLog(@"%@",[self.array[0] objectForKey:@"typeid"]);
            }];
            UIAlertAction *vc2 = [UIAlertAction actionWithTitle:str2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.shenfentextfield.text = str2;
                //NSLog(@"1111");
                typeid = [self.array[1] objectForKey:@"typeid"];
                self.leixingid = typeid;
                //NSLog(@"%@",[self.array[1] objectForKey:@"typeid"]);
            }];
            UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:vc1];
            [alertVC addAction:vc2];
            [alertVC addAction:actioncancle];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
         return NO;
    }
    
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
    [self.miaotextfield resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}






- (IBAction)selectedimage:(id)sender {
    
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
    BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
    if (!isCamera) {
        //提示框
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"摄像头不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *vc1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *actioncancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertVC addAction:vc1];
        [alertVC addAction:actioncancle];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;//如果不存在摄像头，直接返回即可，不需要做调用相机拍照的操作；
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
    
    self.imageview.image = imagesave;
    

    self.userImage = imagesave;
        
     //模态退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickFaBu:(id)sender {
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([Manager sharedManager].edit != nil) {
        //NSLog(@"%@==%@===%@",self.xingming,self.miaoshu,self.shenfen);
        [self lodeditjizhe];
        
    }
    if ([Manager sharedManager].edit == nil){
        [self lodlist];
        // NSLog(@"2edi");
    }
    
}


- (void)leftClickAction {
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
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index?key=app_key&sign=%@&cmd=hosttype",[[Manager sharedManager] md5:single]];
    
    [session GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
            
            weakSelf.array =  [dicc objectForKey:@"data"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}





@end
