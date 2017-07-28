//
//  UserMessageTableViewController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/4.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "UserMessageTableViewController.h"
#import "Manager.h"
#import "UserTableViewController.h"
#import "UMSocial.h"
#import "RKAlertView.h"




@interface UserMessageTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation UserMessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //隐藏电池条
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.scrollEnabled = NO;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
- (IBAction)returnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}














- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        
        [[UMSocialDataService defaultDataService] requestUnOauthWithType:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
            
            NSString *dom= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            //2.获取text.text文件路径
            NSString *tex= [dom stringByAppendingPathComponent:@"text1.text"];
            //3.通过路径获取数据
            NSFileManager * fileManager = [[NSFileManager alloc]init];
            [fileManager removeItemAtPath:tex error:nil];
            
            
            NSString *doucmentsFilePat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPat = [doucmentsFilePat stringByAppendingPathComponent:@"pic.text"];
            NSFileManager * file = [[NSFileManager alloc]init];
                [file removeItemAtPath:textPat error:nil];
             
           
            NSString *aPath3=[NSString stringWithFormat:@"%@/Documents/%@.png",NSHomeDirectory(),@"test"];
            NSFileManager * ff = [[NSFileManager alloc]init];
            [ff removeItemAtPath:aPath3 error:nil];
            NSString *doucmentsFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textPath = [doucmentsFilePath stringByAppendingPathComponent:@"text.text"];
            NSFileManager * fi = [[NSFileManager alloc]init];
            [fi removeItemAtPath:textPath error:nil];
        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self selectedImage];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        [RKAlertView showAlertPlainTextWithTitle:@"" message:@"请输入您的昵称" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            NSLog(@"更换昵称，确认了输入：%@",[alertView textFieldAtIndex:0].text);
        } cancelBlock:^{
            NSLog(@"取消了");
        }];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        [RKAlertView showAlertPlainTextWithTitle:@"" message:@"请输入您的签名" cancelTitle:@"取消" confirmTitle:@"确认" alertViewStyle:UIAlertViewStylePlainTextInput confrimBlock:^(UIAlertView *alertView) {
            NSLog(@"更改签名，确认了输入：%@",[alertView textFieldAtIndex:0].text);
        } cancelBlock:^{
            NSLog(@"取消了");
        }];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        NSLog(@"---------++++++++++绑定手机号");
    }
}





- (void)selectedImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
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
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:@"selectedImage.png"];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(imagesave) writeToFile:imagePath atomically:YES];
    //模态退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
}
































- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else if (section == 1){
        return 3;
    }else {
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
    NSString *tex= [dom stringByAppendingPathComponent:@"text1.text"];
    [Manager sharedManager].sssss = [NSString stringWithContentsOfFile:tex encoding:NSUTF8StringEncoding error:nil];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 20, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-75, 5, 40, 40)];
        imageview.layer.masksToBounds = YES;
        imageview.layer.cornerRadius = 20;
        
        if ([[Manager sharedManager].sssss isEqualToString:@"2222"]) {
            NSString *documentsPat = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
            NSString *textFilePat = [documentsPat stringByAppendingPathComponent:@"pic.text"];
            NSString *picstr = [NSString stringWithContentsOfFile:textFilePat encoding:NSUTF8StringEncoding error:nil];
            [imageview sd_setImageWithURL:[NSURL URLWithString:picstr]];
        }
        if ([[Manager sharedManager].sssss isEqualToString:@"1111"]) {
            
            NSString *path_sandox = NSHomeDirectory();
            NSString *imagePath = [path_sandox stringByAppendingString:@"/Documents/test.png"];
           

            imageview.image = [UIImage imageNamed:imagePath];
        }
        if ([[Manager sharedManager].sssss isEqualToString:@"0000"]) {
            imageview.image = [UIImage imageNamed:@"image.png"];
        }
        
        [cell.contentView addSubview:imageview];
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = @"昵称";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
        NSString *textFilePath = [documentsPath stringByAppendingPathComponent:@"text.text"];
        NSString *userstring = [NSString stringWithContentsOfFile:textFilePath encoding:NSUTF8StringEncoding error:nil];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 175, 10, 140, 20)];
        titleLable.textAlignment = NSTextAlignmentRight;
        titleLable.font = [UIFont systemFontOfSize:12];
        if ([[Manager sharedManager].sssss isEqualToString:@"0000"]) {
            titleLable.text = @"sui ji";
        }else {
        titleLable.text = userstring;
        }
        [cell.contentView addSubview:titleLable];
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        cell.textLabel.text = @"签名";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 215, 10, 180, 20)];
        titleLable.textAlignment = NSTextAlignmentRight;
        
        if ([Manager sharedManager].sssss != nil) {
             titleLable.text = @"这个人很懒，什么也没有留下";
        }
        
        
        titleLable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:titleLable];
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        cell.textLabel.text = @"手机号";
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 30, 10, 20, 20)];
        UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jian"]];
        [lable setBackgroundColor:color];
        [cell.contentView addSubview:lable];
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW - 175, 10, 140, 20)];
        titleLable.textAlignment = NSTextAlignmentRight;
        if ([Manager sharedManager].sssss != nil) {
           titleLable.text = @"绑定手机号";
        }
       
        titleLable.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:titleLable];
    }
    
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"微信";
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW -60, 5, 40, 20)];
        [cell.contentView addSubview:swit];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = @"腾讯QQ";
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW - 60, 5, 40, 20)];
        [cell.contentView addSubview:swit];
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        cell.textLabel.text = @"新浪微博";
        UISwitch *swit = [[UISwitch alloc]initWithFrame:CGRectMake(ScreenW - 60, 5, 40, 20)];
        [cell.contentView addSubview:swit];
    }
    
    if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"退出登录";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;
}




@end
