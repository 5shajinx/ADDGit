//
//  ZhiXunController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "ZhiXunController.h"
#import "BMLBTableViewController.h"

@interface ZhiXunController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UITextField *received;
@property(nonatomic, strong)UITextView  *textview;

@property(nonatomic, strong)NSString *strid;
@property(nonatomic, strong)UIImage *image;


@end

@implementation ZhiXunController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"咨询投诉";
    [self setupbutton];
    
    self.titleTextfield.delegate = self;
    self.detailsTextview.delegate = self;
    self.bumenTextfield.delegate = self;
    self.phoneTextfield.delegate = self;
    self.nameTextfield.delegate = self;
    

    self.phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    self.nameTextfield.borderStyle = UITextBorderStyleNone;
    self.phoneTextfield.borderStyle = UITextBorderStyleNone;
    self.bumenTextfield.borderStyle = UITextBorderStyleNone;
    
    self.received.delegate = self;
    self.textview.delegate = self;
    
    self.selectimageLable.userInteractionEnabled = YES;
    
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


- (IBAction)onClickButtonCommit:(id)sender {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/selected.png"];
    UIImage * image =  [UIImage imageNamed:fullPathToFile];
    if (self.titleTextfield.text != nil && self.detailsTextview.text != nil && self.strid != nil && self.phoneTextfield.text != nil && self.nameTextfield.text != nil && image != nil) {
        
        if ([Manager valiMobile:self.phoneTextfield.text] == nil) {
            [self commitUserInformation];
        }else {
            // NSLog(@"++++++++++++++%@",[Manager valiMobile:self.shouJITextField.text]);
        }
    }
}

- (void)commitUserInformation {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //__weak typeof(self) weakSelf = self;
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/selected.png"];
    __weak typeof(self) weakSelf = self;
    // 二进制的数据就可以进行上传
    //NSData * dataa  =  [NSData dataWithContentsOfFile:fullPathToFile];
    UIImage * image =  [UIImage imageNamed:fullPathToFile];
    NSDictionary *dic = @{@"title":self.titleTextfield.text,@"content":self.detailsTextview.text,@"dwid":self.strid,@"tel":self.phoneTextfield.text,@"username":self.nameTextfield.text};
    
    [session POST:@"http://wlwz.zmdtvw.cn/api/api.php?sign=d8fh8343&cmd=units_ask_post" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData * data   =  UIImagePNGRepresentation(image);
        
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        [formData appendPartWithFileData:data name:@"pic" fileName:fileName mimeType:@"image/png"];
        
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *base64Decoded = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData *madata = [[NSData alloc] initWithData:[base64Decoded dataUsingEncoding:NSUTF8StringEncoding ]] ;
        NSError *err;
        
       NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:madata options:NSJSONReadingAllowFragments error:&err];
     
        if ([[dic objectForKey:@"items"] isEqualToString:@"提交成功！"]) {
            
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提交成功" message:@"是否退出" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionsure1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            UIAlertAction *actionsure2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertVC addAction:actionsure1];
            [alertVC addAction:actionsure2];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
}





- (IBAction)clickSelectedImage:(id)sender {
    [self pickerPictureFromAlbum];
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
#pragma mark - UIImagePickerControllerDelegate
//当得到选中的图片或视频时触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSData * imageData = UIImagePNGRepresentation(_image);
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    NSString * fullPathToFile = [documentsDirectory stringByAppendingString:@"/selected.png"];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    //模态退出界面
    [self dismissViewControllerAnimated:YES completion:nil];
    self.selectimageLable.text = @" 图片已选择";
}












-(void)viewWillAppear:(BOOL)animated {
    
    if ([self.biaoshi isEqualToString:@"zxts"]) {
        self.bumenTextfield.placeholder = @"请选择部门";
        
    }
    
    if ([Manager sharedManager].bmlbtitle != nil) {
        
        self.bumenTextfield.text = [NSString stringWithFormat:@" %@",[Manager sharedManager].bmlbtitle];
        self.strid = [Manager sharedManager].bmlbid;
        
    }
    
    
    self.tabBarController.tabBar.hidden = YES;
    
}



//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    if ([self.received isEqual:self.phoneTextfield] || [self.received isEqual:self.nameTextfield]) {
        //获取键盘的高度
        NSDictionary *userInfo = [aNotification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        self.bottomView.frame = CGRectMake(0, 20-height, ScreenW, ScreenH-64);
    }
    
 
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
   self.bottomView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    
}


//触摸回收键盘
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.received = textField;
    
    if ([textField isEqual:self.bumenTextfield]) {
        BMLBTableViewController *BMLB = [[BMLBTableViewController alloc]init];
        [self.navigationController pushViewController:BMLB animated:YES];
        return NO;
    }
    
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.received resignFirstResponder];
    [self.detailsTextview resignFirstResponder];
    if (self.detailsTextview == nil) {
        [self.detailsTextview addSubview:self.shuomingLable];
    }
}
//点击return键，回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//UITextView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        if (self.detailsTextview == nil) {
            [self.detailsTextview addSubview:self.shuomingLable];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.textview = textView;
    [self.shuomingLable removeFromSuperview];
    return YES;
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupbutton {
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
}

@end
