//
//  ActTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/10.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ActTableViewCell.h"
@implementation ActTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /*
    self.peoImage.frame = CGRectMake(0, 2.5, 15, 15);
    self.leftlabel.frame = CGRectMake(20, 0, self.leftBgImage.frame.size.width - 20, 20 );
    [self.leftBgImage addSubview:self.peoImage];
    [self.leftBgImage addSubview:self.leftlabel];

    
    self.APPImage.frame = CGRectMake(0, 2.5, 15, 15);
    self.rightlabel.frame = CGRectMake(20, 0, self.rightBgimage.frame.size.width - 20, 20 );
    [self.leftBgImage addSubview:self.APPImage];
    [self.leftBgImage addSubview:self.rightlabel];
    
*/
    
    
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //在这里写控件额外属性的设置


    self.peoImage.frame = CGRectMake(0, 2.5, 15, 15);
    self.leftlabel.frame = CGRectMake(20, 0, self.leftBgImage.frame.size.width - 20, 20 );
    [self.leftBgImage addSubview:self.peoImage];
    [self.leftBgImage addSubview:self.leftlabel];
    
    
    self.APPImage.frame = CGRectMake(0, 2.5, 15, 15);
    self.rightlabel.frame = CGRectMake(20, 0, self.rightBgimage.frame.size.width - 20, 20 );
    [self.rightBgimage addSubview:self.APPImage];
    [self.rightBgimage addSubview:self.rightlabel];
    
    [self.contentView addSubview:self.rightBgimage];
    [self.contentView addSubview:self.leftBgImage];

 
}
- (void)showCellWithMode:(ActModel *)model {
    [self awakeFromNib];
    
[self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.apic] placeholderImage:[UIImage imageNamed:@"hui"]];
    self.dowUpLabel.text = [NSString stringWithFormat:@"%@",model.aname];
    
    if ([_timeSp integerValue] <= [model.end_time integerValue]) {
        self.upLabel.text = [NSString stringWithFormat:@"进行中"];
        self.upLabel.backgroundColor = [UIColor redColor];
    } else{
        self.upLabel.text = [NSString stringWithFormat:@"已结束"];
        self.upLabel.backgroundColor = [UIColor lightGrayColor];
        
    }
    self.upLabel.layer.masksToBounds = YES;
    self.upLabel.layer.cornerRadius = 2;
    self.rightlabel.text = @"广视融媒客户端";
    self.leftlabel.font = self.rightlabel.font = [UIFont systemFontOfSize:15];
    NSString *year = [[Manager timeWithTimeIntervalString:model.start_time] substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [[Manager timeWithTimeIntervalString:model.start_time] substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [[Manager timeWithTimeIntervalString:model.start_time] substringWithRange:NSMakeRange(8, 2)];
    
    self.downLabel.text = [NSString stringWithFormat:@"%@\n%@月%@日",year,month,day];
    
    
    self.downLabel.numberOfLines = 0;
    
    
    self.leftlabel.text = [NSString stringWithFormat:@"已参与%@/剩余%@",model.nownumber,model.anumber];
    
    self.peoImage.image = [UIImage imageNamed:@"user"];
    self.APPImage.image = [UIImage imageNamed:@"home"];

}
- (void)viewWillAppear:(BOOL)animated {
    
    //self.tabBarController.tabBar.hidden = NO;
    self.timeSp = [[NSString alloc]init];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-M-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate* date = [dateFormatter dateFromString:dateString];
    _timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
