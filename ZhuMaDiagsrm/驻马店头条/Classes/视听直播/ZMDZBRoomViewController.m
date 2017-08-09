//
//  ZMDZBRoomViewController.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/10.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDZBRoomViewController.h"
#import "NewNetWorkManager.h"

@interface ZMDZBRoomViewController ()


@end

@implementation ZMDZBRoomViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
   // UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"hd_video_info_purchase_alert_foreign"]];
    
   // [self.view addSubview:image];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"本功能暂未开放,敬请期待!";
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.right.offset(0);
        make.bottom.offset(0);

    }];
    //self.view.backgroundColor = [UIColor redColor];
        // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
