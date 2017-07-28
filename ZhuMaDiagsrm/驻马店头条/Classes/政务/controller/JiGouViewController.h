//
//  JiGouViewController.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/30.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "TYTabButtonPagerController.h"

@interface JiGouViewController : TYTabButtonPagerController
@property (nonatomic, assign) BOOL showNavBar;

@property(nonatomic, strong)NSString *dwid;

@property(nonatomic, strong)NSString *imageviewstring;
@property(nonatomic, strong)NSString *titlestring;
@property(nonatomic, strong)NSString *numstring;



@end
