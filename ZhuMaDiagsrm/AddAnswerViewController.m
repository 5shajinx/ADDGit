//
//  AddAnswerViewController.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/11.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "AddAnswerViewController.h"
#import "ADTableViewController.h"
#import "PrefixHeader.pch"
#import "TwoModel.h"

@interface AddAnswerViewController ()<UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSString *zhiboid;
    NSString *zhuchirenid;
    NSString *imagename;
}
@property(nonatomic, strong)UITextField *textfield;
@property(nonatomic, strong)NSMutableArray *imageArray;

@property(nonatomic, strong)UIImage *image1;
@property(nonatomic, strong)UIImage *image2;
@property(nonatomic, strong)UIImage *image3;
@property(nonatomic, strong)UIImage *image4;
@end

@implementation AddAnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加回复";
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageArray = [NSMutableArray arrayWithCapacity:1];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(leftClickAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    
    
    if ([[Manager sharedManager].biaoji isEqualToString:@"editzbcontent"]) {
        self.wenzitextview.text = self.wenzi;
        self.zhuchirentextfiel.text = self.zhuchiren;
        self.wailiantextfield.text = self.wailian;
        
        [self.imageone   sd_setImageWithURL:[NSURL URLWithString:self.pic1]];
        [self.imagetwo   sd_setImageWithURL:[NSURL URLWithString:self.pic2]];
        [self.imagethree sd_setImageWithURL:[NSURL URLWithString:self.pic3]];
        [self.imageforth sd_setImageWithURL:[NSURL URLWithString:self.pic4]];
        
        zhuchirenid = self.jizheid;
        
        //NSLog(@"-----------%@",zhuchirenid);
        if (self.pic1 == nil ) {
            self.imageone.image = [UIImage imageNamed:@"add"];
        }
        if (self.pic2 == nil ) {
            self.imagetwo.image = [UIImage imageNamed:@"add"];
        }
        if (self.pic3 == nil ) {
            self.imagethree.image = [UIImage imageNamed:@"add"];
        }
        if (self.pic4 == nil ) {
            self.imageforth.image = [UIImage imageNamed:@"add"];
        }
        
        if (self.pic1 != nil ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pic1]];
                self.image1 = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //在这里做UI操作(UI操作都要放在主线程中执行)
                        [self.imageArray addObject:self.image1];
                    });
                }
            });
        }
        if (self.pic2 != nil ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pic2]];
                self.image2 = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //在这里做UI操作(UI操作都要放在主线程中执行)
                        [self.imageArray addObject:self.image2];
                    });
                }
            });
        }
        if (self.pic3 != nil ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pic3]];
                self.image3 = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //在这里做UI操作(UI操作都要放在主线程中执行)
                        [self.imageArray addObject:self.image3];
                    });
                }
            });
        }
        if (self.pic4 != nil ) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData * data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:self.pic4]];
                self.image4 = [[UIImage alloc]initWithData:data];
                if (data != nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //在这里做UI操作(UI操作都要放在主线程中执行)
                        [self.imageArray addObject:self.image4];
                    });
                }
            });
        }
        

        
        
        
    }
    
    
    self.wenzitextview.delegate = self;
    self.zhuchirentextfiel.delegate = self;
    self.wailiantextfield.delegate = self;
    [self lodjizhelist];
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
            if ([weakSelf.jizheid isEqualToString:model.hostid]) {
                weakSelf.zhuchirentextfiel.text = model.hostname;
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




- (void)viewWillAppear:(BOOL)animated {
    
    self.wenzitextview.layer.borderColor = [[UIColor colorWithWhite:0.8f alpha:0.5]CGColor];
    self.wenzitextview.layer.borderWidth = 1.0;
    self.wenzitextview.layer.cornerRadius = 3.0f;
    [self.wenzitextview.layer setMasksToBounds:YES];
    
    if ([Manager sharedManager].biaoji == nil) {
        zhuchirenid =  [Manager sharedManager].jizheid;
    }
    if ([Manager sharedManager].editjizheidbiaoji != nil) {
        zhuchirenid = [Manager sharedManager].jizheid;
    }
    self.zhuchirentextfiel.text = [Manager sharedManager].zhuchiren;
    zhiboid     =  [Manager sharedManager].zhiboid;
}



- (IBAction)tapone:(id)sender {
    [self clickimage];
    imagename = @"one";
}
- (IBAction)taptwo:(id)sender {
    imagename = @"two";
    [self clickimage];
}
- (IBAction)tapthree:(id)sender {
    imagename = @"three";
    [self clickimage];
}
- (IBAction)tapforth:(id)sender {
    imagename = @"forth";
    [self clickimage];
}

- (void)clickimage {
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


- (IBAction)clickluyin:(id)sender {
    
}
- (IBAction)clickcommit:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([Manager sharedManager].biaoji == nil) {
        [self lodShangChuanLiveContent];
    }
    if ([Manager sharedManager].biaoji != nil) {
        [self lodxiugaicontent];
        //NSLog(@"66666666666");
    }
    
}


- (void)lodxiugaicontent {
   
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
    
    if (self.wenzitextview.text.length != 0 && zhuchirenid != nil) {
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"uplivenr",@"depict":self.wenzitextview.text,@"presenter":zhuchirenid,@"hrefer":self.wailiantextfield.text,@"zbxq_id":self.zbcontentid};
//        NSLog(@"修改直播内容para===========%@",para);
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int i = 0;
            for (UIImage *image in weakSelf.imageArray) {
                // 可以在上传时使用当前的系统事件作为文件名
               
                //UIImage *image = [Manager imageData:imag];
         
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photo%d",i+1] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
                i++;
            }
            
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
                [Manager sharedManager].editjizheidbiaoji = nil;
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }else{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
    }
  
}



//从手机相册选取图片功能
- (void)pickerPictureFromAlbum {
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagepicker.allowsEditing = YES;
    imagepicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagepicker.delegate = self;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

//拍照--照相机是否可用
- (void)pictureFromCamera {

    
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
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    
    
}

#pragma mark - UIImagePickerControllerDelegate
//当得到选中的图片或视频时触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //NSLog(@"666666666");
    //拿到图片
    UIImage *imagesave = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImageOrientation imageOrientation = imagesave.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(imagesave.size);
        [imagesave drawInRect:CGRectMake(0, 0, imagesave.size.width, imagesave.size.height)];
        imagesave = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    
    if ([imagename isEqualToString:@"one"]) {
        
        self.imageone.image = imagesave;
        [self saveimage:@"/oneimage" image:imagesave];
        
            for(int i = 0;i<self.imageArray.count;i++){
                if ([self.imageArray[i] isEqual:self.image1]) {
                    [self.imageArray removeObjectAtIndex:i];
                }
            }
        
    }
    if ([imagename isEqualToString:@"two"]) {
        self.imagetwo.image = imagesave;
        [self saveimage:@"/twoimage" image:imagesave];
            for(int i = 0;i<self.imageArray.count;i++){
                if ([self.imageArray[i] isEqual:self.image2]) {
                    [self.imageArray removeObjectAtIndex:i];
                }
            }
    }
    if ([imagename isEqualToString:@"three"]) {
        self.imagethree.image = imagesave;
        [self saveimage:@"/threeimage" image:imagesave];
            for(int i = 0;i<self.imageArray.count;i++){
                if ([self.imageArray[i] isEqual:self.image3]) {
                    [self.imageArray removeObjectAtIndex:i];
                }
            }
    }
    if ([imagename isEqualToString:@"forth"]) {
        self.imageforth.image = imagesave;
        [self saveimage:@"/forthimage" image:imagesave];
            for(int i = 0;i<self.imageArray.count;i++){
                if ([self.imageArray[i] isEqual:self.image4]) {
                    [self.imageArray removeObjectAtIndex:i];
                }
            }
    }
    
    [self.imageArray addObject:imagesave];
    
}
- (void)saveimage:(NSString *)str image:(UIImage *)imagesave {
        NSData * imageData = UIImagePNGRepresentation(imagesave);
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documentsDirectory = [paths objectAtIndex:0];
        NSString * fullPathToFile = [documentsDirectory stringByAppendingString:str];
    
        [imageData writeToFile:fullPathToFile atomically:NO];
        [self dismissViewControllerAnimated:YES completion:nil];
}



- (void)lodShangChuanLiveContent {
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
    
    if (self.wenzitextview.text.length != 0 && zhuchirenid != nil) {
        NSDictionary *para = @{@"key":@"app_key",@"sign":[[Manager sharedManager] md5:single],@"cmd":@"addlivenr",@"depict":self.wenzitextview.text,@"presenter":zhuchirenid,@"hrefer":self.wailiantextfield.text,@"zb_id":zhiboid,@"userid":[Manager sharedManager].userid};
//        NSLog(@"－－－－－－－－－－－－－－%@",para);
        [session POST:@"http://zmdzb.zmdtvw.cn/index.php/api/index/index" parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            int i = 0;
            for (UIImage *image in weakSelf.imageArray) {
                // 可以在上传时使用当前的系统事件作为文件名
                
                //UIImage *image = [Manager imageData:imag];
              
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                // 设置时间格式
                formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
                
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
                
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"photo%d",i+1] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//                NSLog(@"%lf----%lf",image.size.width,image.size.height);
                i++;
            }
            
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
                [Manager sharedManager].editjizheidbiaoji = nil;
                // NSLog(@"%@",[dicc objectForKey:@"Message"]);
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        }];
    }else{
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
       
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
   
    if ([textField isEqual:self.zhuchirentextfiel]) {
        ADTableViewController *zhuchiren = [[ADTableViewController alloc]init];
        [self.navigationController pushViewController:zhuchiren animated:YES];
        return NO;
    }
    return YES;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.textfield resignFirstResponder];
    [self.wenzitextview resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)leftClickAction {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
