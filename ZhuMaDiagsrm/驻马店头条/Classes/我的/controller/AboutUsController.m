//
//  AboutUsController.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/8/26.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "AboutUsController.h"



@interface AboutUsController ()

@end

@implementation AboutUsController
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于我们";
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnn.frame = CGRectMake(20, 20, 30, 30);
    [btnn setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [btnn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithCustomView:btnn];
    self.navigationItem.leftBarButtonItem = bar;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenW-50)/2, 120, 70, 70)];
    imageview.image = [UIImage imageNamed:@"11111.png"];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 35;
    [self.view addSubview:imageview];
    
     NSString *labelText = @"   “广视融媒”是由新华社河南分社、中共驻马店市委宣传部、驻马店广播电视台重点打造的新闻生活类城市应用客户端。迅捷的信息资讯、灵活的沟通方式、便捷的消费体验，成为无线领域的全新媒体和信息集散的主流平台。启动广视融媒客户端，即可享受“城市在您手”的乐趣！让我们一起创新驻马店、感知驻马店、 分享驻马店！";
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, ScreenW-40, 200)];
    lab.font = [UIFont systemFontOfSize:18];
    lab.numberOfLines = 0;
//    15103865136
//    zmdtvw@163.com
//    463000
//    http://www.zmdtvw.cn
    
    
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20,ScreenH-50, ScreenW-40, 20)];
    lable.text = @"@驻马店广播电视台";
    lable.font = [UIFont systemFontOfSize:14];
    lable.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lable];
    
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:10];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    lab.attributedText = attributedString;
    [lab sizeToFit];
    
    [self.view addSubview:lab];
}









@end
