//
//  UserMessageTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/4.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "UserMessageTableViewController.h"
#import "Manager.h"

#import "UMSocial.h"
#import "RKAlertView.h"




@interface UserMessageTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property(nonatomic, strong)UILabel *titleLable;
@property(nonatomic, strong)UILabel *qianmingLable;
@end



@implementation UserMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"账号管理";
    [self setUpBackButton];
    
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
    
    
    NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
    [Manager sharedManager].sssss = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if ([Manager sharedManager].sssss == nil) {
        self.tableview.hidden = YES;
    }else {
        self.tableview.hidden = NO;
    }
    
}
- (IBAction)returnBack:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 20, 30, 30);
    [btn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = bar;
}
- (void)back {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 && indexPath.row == 0) {
            NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            //2.获取text.text文件路径
            NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
            //3.通过路径获取数据
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:tex error:nil];
        
            NSString *doucmentsFilePat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPat = [doucmentsFilePat stringByAppendingPathComponent:@"imageurl.text"];
            NSFileManager * file = [[NSFileManager alloc]init];
                [file removeItemAtPath:textPat error:nil];
             
           
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *aPath3 = [documentsPath stringByAppendingPathComponent:@"username.text"];
            NSFileManager * ff = [[NSFileManager alloc]init];
            [ff removeItemAtPath:aPath3 error:nil];
        
        
            NSString *adocumentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *aaPath3 = [adocumentsPath stringByAppendingPathComponent:@"usid.text"];
            NSFileManager * aff = [[NSFileManager alloc]init];
           [aff removeItemAtPath:aaPath3 error:nil];
        
            [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self selectedImage];
       
       
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [RKAlertView showAlertPlainTextWithTitle:@"" message:@"请输入您的昵称" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            [self lodUserName:[alertView textFieldAtIndex:0].text];
            
        } cancelBlock:^{
           
        }];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        [RKAlertView showAlertPlainTextWithTitle:@"" message:@"请输入您的签名" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            [self lodUserSignature:[alertView textFieldAtIndex:0].text];
        } cancelBlock:^{
           
        }];
    }
//    if (indexPath.section == 0 && indexPath.row == 3) {
//        //NSLog(@"---------++++++++++绑定手机号");
//    }
    
}





- (void)selectedImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择获取路径" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionA = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pickerPictureFromAlbum];
    }];
    UIAlertAction *actionB = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pictureFromCamera];
    }];
    UIAlertAction *actionC = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:actionA];
    [alert addAction:actionB];
    [alert addAction:actionC];
    [self presentViewController:alert animated:YES completion:nil];
    
    
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"摄像头不可用" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
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
    NSData * imageData = UIImagePNGRepresentation(imagesave);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/userselected.png"];
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    //模态退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
    //NSLog(@"+++++++++%@",fullPathToFile);
    [self lodUserPicture];
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }
//    else if (section == 1){
//        return 3;
//    }
    else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
     NSString *tex= [dom stringByAppendingPathComponent:@"yzmlogin.text"];
     [Manager sharedManager].sssss = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    //头像
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 20, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-75, 5, 40, 40)];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 20;
        if ([[Manager sharedManager].sssss isEqualToString:@"login"]) {
            NSString *documentsPat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textFilePat = [documentsPat stringByAppendingPathComponent:@"imageurl.text"];
            NSString *picstr = [NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil];
            if (picstr.length == 0) {
                imageview.image = [UIImage imageNamed:@"yonghu"];
            }else {
                [imageview sd_setImageWithURL:[NSURL URLWithString:picstr]];
            }
            
//            if ([[NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil] isEqualToString:@"nil"]) {
//               imageview.image = [UIImage imageNamed:@"wechat"];
//            }
        }
        [cell.contentView addSubview:imageview];
    }
    //昵称
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"username.text"];
        NSString *userstring = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
        
        self.titleLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 175, 10, 140, 20)];
        self.titleLable.textAlignment = NSTextAlignmentRight;
        self.titleLable.font = [UIFont systemFontOfSize:12];
        if ([[Manager sharedManager].sssss isEqualToString:@"login"]) {
            
            self.titleLable.text = [[WordFilter sharedInstance] filter:userstring];
            
        }
        [cell.contentView addSubview:self.titleLable];
        
    }
    //签名
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.text = @"签名";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        self.qianmingLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 215, 10, 180, 20)];
        self.qianmingLable.textAlignment = NSTextAlignmentRight;
        
        if ([Manager sharedManager].sssss != nil) {
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"Signature.text"];
            NSString *text = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
             self.qianmingLable.text = [[WordFilter sharedInstance] filter:text];
        }
        
        self.qianmingLable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:self.qianmingLable];
    }
//    //绑定手机号
//    if (indexPath.section == 0 && indexPath.row == 3) {
//        cell.textLabel.text = @"手机号";
//        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
//        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
//        [lable setBackgroundColor:color];
//        [cell.contentView addSubview:lable];
//        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 175, 10, 140, 20)];
//        titleLable.textAlignment = NSTextAlignmentRight;
//        if ([Manager sharedManager].sssss != nil) {
//           titleLable.text = @"绑定手机号";
//        }
//        titleLable.font = [UIFont systemFontOfSize:12];
//        [cell.contentView addSubview:titleLable];
//    }
//   
//    
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        cell.textLabel.text = @"微信";
//        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW -60, 5, 40, 20)];
//        [cell.contentView addSubview:swit];
//    }
//    if (indexPath.section == 1 && indexPath.row == 1) {
//        cell.textLabel.text = @"腾讯QQ";
//        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW - 60, 5, 40, 20)];
//        [cell.contentView addSubview:swit];
//    }
//    if (indexPath.section == 1 && indexPath.row == 2) {
//        cell.textLabel.text = @"新浪微博";
//        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW - 60, 5, 40, 20)];
//        [cell.contentView addSubview:swit];
//    }
//    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}





- (void)lodUserName:(NSString *)username {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *ptuid = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"ptuid":ptuid,@"nickname":username};
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/ptuser/upnick" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
         // NSLog(@" 更换用户名%@",dicc);
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
           // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *aPath3 = [documentsPath stringByAppendingPathComponent:@"username.text"];
            NSFileManager * ff = [[NSFileManager alloc]init];
            [ff removeItemAtPath:aPath3 error:nil];
            
            NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"username.text"];
            NSString *string = username;
            [string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            weakSelf.titleLable.text = nil;
            
            [weakSelf.tableview reloadData];
        }
        if ([code isEqualToString:@"1"]) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        if ([code isEqualToString:@"2"]) {
           // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        [weakSelf.tableview reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)lodUserPicture {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/userselected.png"];
    UIImage * image =  [UIImage imageNamed:fullPathToFile];
    //NSLog(@"******  %@",image);
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *str = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = @{@"ptuid":str};
    __weak typeof(self) weakSelf = self;
    [session POST:@"http://zmdtt.zmdtvw.cn/index.php/Api/ptuser/upphoto" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      
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
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        // NSLog(@" 更换头像 %@",dic);
        NSNumber *number = [dic objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ){
            NSString *doucmentsFilePat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPat = [doucmentsFilePat stringByAppendingPathComponent:@"imageurl.text"];
            NSFileManager * file = [[NSFileManager alloc]init];
            [file removeItemAtPath:textPat error:nil];
            
            NSString *FilePat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *Pat = [FilePat stringByAppendingPathComponent:@"imageurl.text"];
            NSString *st = [dic objectForKey:@"photo"];
            [st writeToFile:Pat atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
       [weakSelf.tableview reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
}

- (void)lodUserSignature:(NSString *)msg {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"ptuid.text"];
    NSString *ptuid = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *dic = @{@"ptuid":ptuid,@"msg":msg};
    __weak typeof(self) weakSelf = self;
    [session GET:@"http://zmdtt.zmdtvw.cn/index.php/Api/ptuser/upmsg" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        NSMutableDictionary *dicc = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
        
        //NSLog(@" ^^^^^0^^^0 0^^^0^^^^^^^  %@",dicc);
        NSNumber *number = [dicc objectForKey:@"code"];
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        NSString *code = [numberFormatter stringFromNumber:number];
        
        if ([code isEqualToString:@"0"] ) {
           // NSLog(@"%@",[dicc objectForKey:@"Message"]);
            
            NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *aPath3 = [documentsPath stringByAppendingPathComponent:@"Signature.text"];
            NSFileManager * ff = [[NSFileManager alloc]init];
            [ff removeItemAtPath:aPath3 error:nil];
            
            NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"Signature.text"];
            NSString *string = msg;
            [string writeToFile:textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
             weakSelf.qianmingLable.text = nil;
            [weakSelf.tableview reloadData];
        }
        if ([code isEqualToString:@"1"]) {
            //NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        if ([code isEqualToString:@"2"]) {
           // NSLog(@"%@",[dicc objectForKey:@"Message"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}













@end
