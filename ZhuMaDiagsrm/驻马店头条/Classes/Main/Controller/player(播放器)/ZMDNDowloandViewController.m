//
//  ZMDNDowloandViewController.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/21.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDNDowloandViewController.h"

@interface ZMDNDowloandViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mytableview;
@property(nonatomic,strong)NSString *dowUrl;
@property(nonatomic,strong)NSMutableArray *dateSource;

@end

@implementation ZMDNDowloandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dateSource = [NSMutableArray arrayWithCapacity:1];
    
    
    self.mytableview = [[UITableView alloc]init];
    _mytableview.frame = self.view.frame;
    [self.view addSubview:_mytableview];
    _mytableview.delegate = self;
    _mytableview.dataSource = self;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dateSource.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    return nil;
}

- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *ghud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // Set the text mode to show only text.
    ghud.mode = MBProgressHUDModeText;
    ghud.label.text = text;
    // Move to bottm center.
    ghud.center = self.view.center;//屏幕正中心
    
    
    [ghud hideAnimated:YES afterDelay:delay];
}
@end
