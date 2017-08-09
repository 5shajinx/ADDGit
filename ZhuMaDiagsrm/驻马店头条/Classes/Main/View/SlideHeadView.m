//
//  SlideHeadView.m
//  slideNavDemo
//
//  Created by 冯学杰 on 16/3/31.
//  Copyright © 2016年 冯学杰. All rights reserved.
//

#import "SlideHeadView.h"
#import "UIView+Extension.h"
#import "SDWebImageManager.h"
#import "ZMDUserTableViewController.h"
#import "ZMDNSearchTableViewController.h"
#import "CityViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RandomColor Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))/** 随机色  */
static CGFloat const titleH = 44;/** 文字高度  */

static CGFloat const MaxScale = 1.0;/** 选中文字放大  */


@implementation SlideHeadView




- (NSMutableArray *)buttons
{
    if (!_buttons)
    {

        _buttons = [NSMutableArray array];
    }
    return _buttons;
}


-(void)shuxin{
    
      [self.userPicButton setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    //读
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)firstObject];
    NSString *imageurl = [documentsPath stringByAppendingPathComponent:@"imageurl.text"];
    NSString *ssss = [NSString stringWithContentsOfFile:imageurl encoding:NSUTF8StringEncoding error:nil];
    if (ssss.length > 8) {
            [self.userPicButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", ssss]] forState:UIControlStateNormal];
    }


}



-(void)setSlideHeadView{

    
    
    
    
    
    
    
    [self setTitleScrollView];        /** 添加文字标签  */
    
    [self setContentScrollView];      /** 添加scrollView  */
    
    [self setupTitle];                     /** 设置标签按钮 文字 背景图  */
    
    self.contentScrollView.contentSize = CGSizeMake(self.titlesArr.count * ScreenW, 0);
    
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator  = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;

    [self shuxin];
    
}

- (BOOL )islocationButonWithButton:(UIButton *)button{
    
    //判断是否是定位button
    NSArray *townArr = @[@"驻马店",@"遂平",@"西平",@"上蔡",@"汝南",@"平舆",@"确山",@"正阳",@"泌阳",@"地区"];
    
    NSString *str = [NSString stringWithFormat:@"%@",button.titleLabel.text];
   // NSLog(@"77777%@",str);
   
    for (int i = 0; i< townArr.count; i++) {
        if ([str isEqualToString:townArr[i]]) {
            return YES;
        }
        
    }
    
//    
//    
//    if ([townArr containsObject:str]) {
//        boo = YES;
//    }else{
//        boo = NO;
//        
//    }
    
    
    return NO;
    
    
}

- (UIViewController *)findViewController:(UIView *)sourceView
{
    
    
    
    
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}



#pragma mark - PRIVATE

-(void)addChildViewController:(UIViewController *)childVC title:(NSString *)vcTitle{
    
    
    UIViewController *superVC = [self findViewController:self];
    childVC.title = vcTitle;
    [superVC addChildViewController:childVC];
    
    
    
}

-(void)setTitleScrollView{
    //通知传值和时机改变定位图位置
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"city22" object:nil];
    //通知传值和时机改变定位图位置
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"dingweicity" object:nil];
    //刷新界面
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuxin) name:@"shuaxinjiemian" object:nil];
    
    UIViewController *superVC = [self findViewController:self];
    superVC.view.backgroundColor = [UIColor whiteColor];
    CGRect rect  = CGRectMake(0 , 20 +40 , ScreenW - 28, titleH  );
   // CGRect rect  = CGRectMake(35, 20 , ScreenW-70, titleH);

    self.titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    self.titleScrollView.backgroundColor = [UIColor whiteColor];
    self.userPicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.userPicButton.frame = CGRectMake(8, 28, 25, 25);
    //self.userPicButton.frame = CGRectMake(8, 28 +40, 25, 25);

    [self.userPicButton addTarget:self action:@selector(mindrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.userPicButton setImage:[UIImage imageNamed:@"4"] forState:UIControlStateNormal];
    
    
    NSString *pic = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userheadpic"]];
    if (pic.length > 0) {
        self.userPicButton.layer.masksToBounds = YES;
        self.userPicButton.layer.cornerRadius = 25/2;
        
[self.userPicButton sd_setImageWithURL:[NSURL URLWithString:pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"4"]];
    }
    [superVC.view addSubview:self.userPicButton];
    UIButton *search = [UIButton buttonWithType:UIButtonTypeCustom];
    //搜索
    //search.frame = CGRectMake(ScreenW-33, 32 + 40, 20, 20);
    search.frame = CGRectMake(ScreenW-28, 32, 22, 22);
    [search addTarget:self action:@selector(searchContent:) forControlEvents:UIControlEventTouchUpInside];
    [search setImage:[UIImage imageNamed:@"Search"] forState:UIControlStateNormal];
    [superVC.view addSubview:search];
    [superVC.view addSubview:self.titleScrollView];
    
    //加号
    self.AddButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _AddButton.frame = CGRectMake(ScreenW-28, 28 + 40, 28, 28);
    [_AddButton addTarget:self action:@selector(AddButtonActin:) forControlEvents:UIControlEventTouchUpInside];
    [_AddButton setImage:[UIImage imageNamed:@"addPindao"] forState:UIControlStateNormal];
    [superVC.view addSubview:_AddButton];
    
    
    
    //添加线
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 63 + 40 - 1, ScreenW, 1)];
    line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    [superVC.view addSubview:line];
    
    
    
    
    
    
   //添加的图标
    //self.tuBiaoImagr = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-33, 32 + 40, 20, 20)];
    self.tuBiaoImagr = [[UIImageView alloc]init];
    [superVC.view addSubview:_tuBiaoImagr];

    [self.tuBiaoImagr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.centerX.mas_equalTo(superVC.view);
        make.width.offset(100);
        make.height.offset(50);

        
    }];
    
    _tuBiaoImagr.image = [UIImage imageNamed:@"GSRMUPtubiao"];
    
    
  
    [superVC.view addSubview:_tuBiaoImagr];
    
   
}
//加号
- (void)AddButtonActin:(UIButton *)but{
    //NSLog(@"加号");
    
    NSNotification *addnotiofion = [NSNotification notificationWithName:@"addtonzhi" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:addnotiofion];
    
    
}



- (void)mindrawer:(UIButton *)sender {
    UIViewController *superVC = [self findViewController:self];
    ZMDUserTableViewController *user = [[ZMDUserTableViewController alloc]init];
//    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:user];
    user.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [superVC presentViewController:user animated:YES completion:nil];
    
}


-(void)searchContent:(UIBarButtonItem*)search
{
    UIViewController *superVC = [self findViewController:self];
    ZMDNSearchTableViewController *searchVc = [[ZMDNSearchTableViewController alloc] init];
    UINavigationController *na = [[UINavigationController alloc]initWithRootViewController:searchVc];
    na.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [superVC presentViewController:na animated:YES completion:nil];
}


-(void)setContentScrollView{
    UIViewController *superVC = [self findViewController:self];
    CGFloat y  = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect  = CGRectMake(0, y, ScreenW, ScreenH - titleH);
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    [superVC.view addSubview:self.contentScrollView];
    
}
- (void)remove{
    UIViewController *superVC = [self findViewController:self];
    while (superVC.childViewControllers.count) {
    UIViewController *vc = [superVC.childViewControllers lastObject];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    }
}
-(void)setupTitle{
    [self.buttons removeAllObjects];
    
    UIViewController *superVC = [self findViewController:self];
    NSUInteger count = superVC.childViewControllers.count;
    
    
    
    
    
    CGFloat x = 0;
    CGFloat w = 80;
    CGFloat h = titleH ;
    self.imageBackView  = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 80-10, titleH-10)];
    //self.imageBackView.image = [UIImage imageNamed:@"b1"];
    self.imageBackView.backgroundColor = [UIColor whiteColor];
    self.imageBackView.userInteractionEnabled = YES;
   
    self.imageBackView.layer.cornerRadius = 4;
    
    self.imageBackView.layer.masksToBounds = YES;
    [self.titleScrollView addSubview:self.imageBackView];

    for (int i = 0; i < count ; i++)
    {
        
    UIViewController *vc = superVC.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0 , w, h);
        //CGRect rect = CGRectMake(x, 0, w, h);

        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        btn.tag = i;

        BOOL boo = [self islocationButonWithButton:btn];
        
//        if (i == 2) {
        if (boo) {

            NSString *str = [NSString stringWithFormat:@"%@",vc.title];
         
            [btn addObserver:self forKeyPath:str options:NSKeyValueObservingOptionNew context:nil];
            if ([str isEqualToString:@"驻马店"]) {
                
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.imageEdgeInsets = UIEdgeInsetsMake(10, 60, 10, 0);
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
                [btn setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
                
            } else{
                
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.imageEdgeInsets = UIEdgeInsetsMake(10, 52.5, 10, 7.5);
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, -76, 0, 0);
                
                [btn setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
                
                
            }
}
 
        
      //  btn.tag = i;
       

        
        
        
        
        
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //btn.titleLabel.font = [UIFont systemFontOfSize:20];
    btn.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:20.0];
        
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        
        
        [self.titleScrollView addSubview:btn];
        
       
        
        
        
        if (i == 0)
        {
            [self click:btn];
        }
        
    }
    
    self.titleScrollView.contentSize = CGSizeMake(count * w , 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
    

    
}



-(void)tongzhi:(NSNotification *)sender{
    
   // [self setupTitle];
 
    NSString *string = sender.userInfo[@"name"];
    
    if ([string isEqualToString:@"驻马店"]) {
        
        self.selectedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 60, 10, 0);
        self.selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
        // [self.selectedBtn setImage:[UIImage imageNamed:@"city"] forState:UIControlStateNormal];
        [self.selectedBtn setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
  
    } else{
        
        self.selectedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.selectedBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 52.5, 10, 7.5);
        self.selectedBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -76, 0, 0);
        // [self.selectedBtn setImage:[UIImage imageNamed:@"city"]forState:UIControlStateNormal];
        [self.selectedBtn setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
        
    
    }


}



-(void)click:(UIButton *)sender{
    [self selectTitleBtn:sender];
    NSInteger i = sender.tag;
    CGFloat x  = i *ScreenW;
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
    [self setUpOneChildController:i];
    
    
    
    
}




-(void)selectTitleBtn:(UIButton *)btn{
    
    BOOL bb = [self islocationButonWithButton:btn];
    
    if (bb) {
      
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        if ([[btn currentTitle] isEqualToString:@"驻马店"]) {
            btn.imageEdgeInsets = UIEdgeInsetsMake(10, 60, 10, 0);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -80, 0, 0);
    
        } else{
            btn.imageEdgeInsets = UIEdgeInsetsMake(10, 52.5, 10, 7.5);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -76, 0, 0);
 
        }
       // [btn setImage:[UIImage imageNamed:@"city"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"dingweitu"] forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        NSString *sttt = [NSString stringWithFormat:@"%ld",(long)btn.tag];
        
        if ( [[Manager sharedManager].numbbb isEqualToString:sttt]){
            
            [self selectedzone];
        }
        
    }
    
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.transform = CGAffineTransformMakeScale(MaxScale, MaxScale);
    self.selectedBtn = btn;
    
    [self setupTitleCenter:btn];
    
    for (UIButton *button in self.buttons) {
        if (![button isEqual:btn]) {
           [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
           button.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:20.0];
        }
    }
   
    
    
    
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"two",@"one", nil];
        //创建通知
        NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    if (bb) {
        
        NSString * positionStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位"];
        NSString * positionStrid = [[NSUserDefaults standardUserDefaults] objectForKey:@"定位id"];
        
        if (positionStr != nil && positionStrid != nil) {
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:positionStr, @"name",positionStrid,@"areaid",nil];
            
            NSNotification *notification =[NSNotification notificationWithName:@"city" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
    }
    //点击button给[Manager sharedManager].numbbb赋每个button的teg值,所以连点两次2才会触发定位的通知
    [Manager sharedManager].numbbb = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
   
    
}



- (void)selectedzone
{

    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"chuanshiji",@"textOne", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi2" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}






-(void)setupTitleCenter:(UIButton *)sender
{
    
    CGFloat offset = sender.center.x - ScreenW * 0.5;
    if (offset < 0) {
        offset = 0;
    }
    
    CGFloat maxOffset  = self.titleScrollView.contentSize.width - ScreenW+60;
    if (offset > maxOffset && maxOffset>0) {
        offset = maxOffset;
    }

//    NSLog(@"%lf,%lf,%ld",offset,maxOffset,sender.tag);
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}

-(void)setUpOneChildController:(NSInteger)index{
    UIViewController *superVC = [self findViewController:self];
    
    CGFloat x  = index * ScreenW;
    UIViewController *vc  =  superVC.childViewControllers[index];
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0 , ScreenW, ScreenH - self.contentScrollView.frame.origin.y);
    [self.contentScrollView addSubview:vc.view];
    

}


#pragma mark - UIScrollView  delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    NSInteger i  = self.contentScrollView.contentOffset.x / ScreenW;
    [self selectTitleBtn:self.buttons[i]];
    [self setUpOneChildController:i];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
 
    scrollView.pagingEnabled = YES;
    CGFloat offsetX  = scrollView.contentOffset.x;
    NSInteger leftIndex  = offsetX / ScreenW;
    NSInteger rightIdex  = leftIndex + 1;
    
    UIButton *leftButton = self.buttons[leftIndex];
    UIButton *rightButton  = nil;
    if (rightIdex < self.buttons.count) {
        rightButton  = self.buttons[rightIdex];
    }
    CGFloat scaleR  = offsetX / ScreenW - leftIndex;
    CGFloat scaleL  = 1 - scaleR;
    CGFloat transScale = MaxScale - 1;
    
    self.imageBackView.transform  = CGAffineTransformMakeTranslation((offsetX*(self.titleScrollView.contentSize.width / self.contentScrollView.contentSize.width)), 0);
    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
   // NSLog(@"pppppppppp%@%@",leftButton.titleLabel.text,rightButton.titleLabel.text);
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    rightButton.titleLabel.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:20.0];
    
    
    
}








@end
