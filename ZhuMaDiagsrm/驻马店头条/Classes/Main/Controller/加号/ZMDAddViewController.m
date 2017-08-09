//
//  ZMDAddViewController.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/4.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDAddViewController.h"
#import "ZJTagView.h"
#import "ZJTagItem.h"

@interface ZMDAddViewController ()<ZJTagViewDelegate>
@property (strong, nonatomic) ZJTagView *tagView;
@property (strong, nonatomic) UIButton *editBtn;


@property (strong, nonatomic) NSMutableArray *first;
@property (strong, nonatomic) NSMutableArray *secont;
@property (strong, nonatomic) NSMutableArray *newfirst;
@property (strong, nonatomic) NSMutableArray *newsecont;

@property (strong, nonatomic) NSMutableArray *newaaaaaaaary;

//@property(nonatomic,strong)NSString *iserrorStr;//标记是错乱的时候 强制 跳过来的
@property (nonatomic,assign ) NSInteger index;
@property (nonatomic,assign ) NSInteger index2;
@property (nonatomic,assign) BOOL isdo;

@end

@implementation ZMDAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAddView) name:@"addtonzhi" object:nil];

    
    NSMutableArray *selectedItems = [NSMutableArray array];
    NSMutableArray *unselectedItems = [NSMutableArray array];
    self.newfirst = [[NSMutableArray alloc]init];
   self.newsecont = [[NSMutableArray alloc]init];
 NSMutableArray *mutarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"UpArray"]];
    self.first = [[NSMutableArray alloc]init];
    self.secont = [[NSMutableArray alloc]init];

    self.newaaaaaaaary= [[NSMutableArray alloc]init];
    self.newaaaaaaaary = mutarray;
    
    
    for (NSDictionary *dic in mutarray) {
     NSString *key =  [dic objectForKey:@"cate_name"];
        
        [_first addObject:key];
 
        
    }
    
    
    
    
    
    
    
    
    // 初始化第一个section数据
    for (int i=0; i<_first.count; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"%@",_first[i]];
        [selectedItems addObject:item];
    }
    
    self.index2 = _first.count;

    
    NSMutableArray *newfirstarray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"dowArray"]];
    self.secont = newfirstarray;
    
    self.index = newfirstarray.count;
    
 //    self.secont= [[NSMutableArray alloc]init];
    
//    for (NSDictionary *dic in newfirstarray) {
//        NSString *key =  [dic objectForKey:@"cate_name"];
//        
//        [_secont addObject:key];
//        
//     //   [_newdic setObject:dic forKey:key];
//        
//    }

    
    
    // 初始化第二个section数据
    for (int i=0; i<newfirstarray.count; i++) {
        ZJTagItem *item = [ZJTagItem new];
        item.name = [NSString stringWithFormat:@"%@",newfirstarray[i]];
        [unselectedItems addObject:item];
    }
    // 初始化
    _tagView = [[ZJTagView alloc] initWithSelectedItems:selectedItems unselectedItems:unselectedItems];
    
    [self showDetaile];
    
}
- (void)showDetaile{
    
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, 20, 80, 44)];
    label.text = @"编辑频道";
    [self.view addSubview:label];

    
    _editBtn = [[UIButton alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 60 - 20), 20, 60, 44)];
   // [_editBtn setTitle:@"点击这里或者长按标签进入编辑页面" forState:UIControlStateNormal];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitle:@"完成" forState:UIControlStateSelected];
    
    [_editBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_editBtn addTarget:self action:@selector(editBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editBtn];
    
    
    UIButton *retButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:retButton];
    [retButton setImage:[UIImage imageNamed:@"blueBack"] forState:UIControlStateNormal];
    [retButton addTarget:self action:@selector(returnbutton) forControlEvents:UIControlEventTouchUpInside];
    
    [retButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(32);
        make.left.offset(20);
        make.width.height.offset(30);
    }];
    
    
    
    
    // 设置代理 可以处理点击
    _tagView.delegate = self;
    _tagView.frame = CGRectMake(0, CGRectGetMaxY(_editBtn.frame), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(_editBtn.frame));
    // 设置frame
    [self.view addSubview:_tagView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


//返回
- (void)returnbutton{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showUpTitle" object:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)editBtnOnClick:(UIButton *)editBtn {
    _tagView.inEditState = !editBtn.isSelected;
    
    NSNotification *notifi = [NSNotification notificationWithName:@"showUpTitle" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notifi];
    
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;

  
}
-(void)viewWillDisappear:(BOOL)animated{
    if (_isdo) {
        
       NSString *sst = nil;
    NSMutableArray *att = [NSMutableArray arrayWithCapacity:1];
    
    for (int i = 0; i < _newfirst.count; i++) {
        ZJTagItem *it = _newfirst[i];
        sst = [NSString stringWithFormat:@"%@",it.name];
        [att addObject:sst];
        
        
    }
    
    
    if (att.count>1) {
        
    NSString *str1 = [NSString stringWithFormat:@"%@",att[0]];
    NSString *str2 = [NSString stringWithFormat:@"%@",att[1]];
    
    if (!([str1 isEqualToString:@"推荐"] && [str2 isEqualToString:@"热点"])) {
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newfirstarray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UpArray"];
        [_first removeAllObjects];;
        [_secont  removeAllObjects];;
        [_newfirst removeAllObjects];
        [_newsecont removeAllObjects];
        [_newaaaaaaaary removeAllObjects];
        
        
        [Manager sharedManager].isErron = YES;
        self.Shuablock();
        
        return;
    }
    }
    
    //原始数组
    NSArray *arrrrsdfdsbhfgadskfr = [[NSUserDefaults standardUserDefaults] objectForKey:@"newdicc"];
        int cou = (int)_index2 + (int)_index;
        int couu = (int)arrrrsdfdsbhfgadskfr.count;

        if(cou != couu){
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newfirstarray"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UpArray"];
        [_first removeAllObjects];;
        [_secont  removeAllObjects];;
        [_newfirst removeAllObjects];
        [_newsecont removeAllObjects];
        [_newaaaaaaaary removeAllObjects];
        
        // 标题错乱 重新添加
       [self showOnleText:@"操作失败" delay:1.5];
        
        
        [Manager sharedManager].isErron = YES;
        self.Shuablock();
        
        return;
  
    }
        
        
        
        
    NSMutableDictionary *newdiccc = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:@"newdicc"]];
    NSMutableArray *finshArr = [NSMutableArray arrayWithCapacity:1];

    
    for (NSString *res in att) {
    
        [finshArr addObject:[newdiccc objectForKey:res]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showUpTitle" object:nil];
     //保存新的上边的 键值对
    if (finshArr.count >0) {

        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UpArray"];
        [[NSUserDefaults standardUserDefaults] setObject: finshArr forKey:@"UpArray"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"BiaoJiForAdd"];

    }
        
        
        NSMutableArray *removeatt = [NSMutableArray arrayWithCapacity:1];
        
        for (int i = 0; i < _newsecont.count; i++) {
            ZJTagItem *removeit = _newsecont[i];
            sst = [NSString stringWithFormat:@"%@",removeit.name];
            [removeatt addObject:sst];
            
            
        }
    
    
if (_secont.count == 0) {
        if (_newsecont.count>0) {
            //上次是0,这次是1
            //code
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
            
            for (int i = 0; i< _newsecont.count; i++) {
                
                ZJTagItem *itemmm = _newsecont[i];
                [arr addObject: itemmm.name];
            }
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"dowArray"];

        }else{
            //不做操作
        }
        
    }
    if (_secont.count >0) {
        if (_newsecont.count == 0) {
            //移除所有
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];

        }else{
            if (_newsecont>0) {
                //code
                NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
                
                for (int i = 0; i< _newsecont.count; i++) {
                    
                    ZJTagItem *itemmm = _newsecont[i];
                    [arr addObject: itemmm.name];
                    
                }
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];
                [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"dowArray"];
                
            }else{
                //移除所有
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dowArray"];

            }
        }
    }
//    
//    
//    
    

    
    
    
    }
    
    self.Shuablock();
    
    
}
#pragma mark - ZJTagViewDelegate
- (void)tagView:(ZJTagView *)tagView didChangeInEditState:(BOOL)inEditState {
    _editBtn.selected = inEditState;
  
      NSNotification *notifi = [NSNotification notificationWithName:@"showUpTitle" object:nil];

    
      [[NSNotificationCenter defaultCenter] postNotification:notifi];
}

- (void)tagView:(ZJTagView *)tagView didSelectTagWhenNotInEditState:(NSInteger)index {
    NSLog(@"点击未处于编辑状态的第一组的第%ld个tag", index);
    
    
}
- (void)tagView:(ZJTagView *)tagview SelectTagWithArray:(NSMutableArray *)SeleArray UnSelectWithArray:(NSMutableArray *)UnSelect{
    
   
        _newfirst = SeleArray;

    
 
        _newsecont = UnSelect;

  
       _isdo = YES;

    
    
    
    
}
- (void)showOnleText:(NSString *)text delay:(NSTimeInterval)delay {
    MBProgressHUD *ghud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //  [self.view bringSubviewToFront:ghud   ];
    // Set the text mode to show only text.
    ghud.mode = MBProgressHUDModeText;
    ghud.label.text = text;
    // Move to bottm center.
    ghud.center = self.view.center;//屏幕正中心
    
    
    [ghud hideAnimated:YES afterDelay:delay];
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
