//
//  CommenTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 17/4/12.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "CommenTableViewCell.h"

@implementation CommenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touAction:)];
    [self.touchimage addGestureRecognizer:tap];
    self.touchimage.userInteractionEnabled = YES;
    
}
//点赞
- (void)touAction:(UITapGestureRecognizer *)ges{
    
    self.touchimage.image = [UIImage imageNamed:@"zan-red.png"];

    self.touchBlock(self.comid);

    
    
    
}
-(void)showDetailWithModel:(commentModel *)model {
    [self.userPicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"10888"]];
    self.userPicImage.layer.masksToBounds = YES;
    self.userPicImage.layer.cornerRadius = 5;
    self.Usernamelabel.text = [NSString stringWithFormat:@"%@",model.nickname];
    self.nubOfSay.text = [NSString stringWithFormat:@"%@",model.zcnum];
    self.nummm =[NSString stringWithFormat:@"%@",model.zcnum];
    
    if ([model.count integerValue] == 0) {
        
        self.saytime.text = [NSString stringWithFormat:@"%@ · 回复",[Manager timeWithTimeIntervalString:model.saytime]];
    } else{
        NSString *str = [Manager timeWithTimeIntervalString:model.saytime];
        
        self.saytime.text = [NSString stringWithFormat:@"%@ · %@条回复",str, model.count];
        

    }
    
       
    self.detaileLabel.text = [NSString stringWithFormat:@"%@",model.saytext];
self.detaileLabel
    .tintColor = [UIColor lightGrayColor];
    self.comid = [NSString stringWithFormat:@"%@",model.comid];
    
  
}




-(void)HuifushowDetailWithModel:(commentModel *)model{
    [self.userPicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"10888"]];
    self.userPicImage.layer.masksToBounds = YES;
    self.userPicImage.layer.cornerRadius = 5;
    self.Usernamelabel.text = [NSString stringWithFormat:@"%@",model.nickname];
    self.nubOfSay.text = [NSString stringWithFormat:@"%@",model.zcnum];
    self.nummm =[NSString stringWithFormat:@"%@",model.zcnum];
    
    
    self.saytime.text = [NSString stringWithFormat:@"%@ · 回复",[Manager timeWithTimeIntervalString:model.saytime]];
    
    
    
    self.saytime.text = [NSString stringWithFormat:@"%@",[Manager timeWithTimeIntervalString:model.saytime]];
    
    self.detaileLabel.text = [NSString stringWithFormat:@"%@",model.saytext];
    self.detaileLabel
    .tintColor = [UIColor lightGrayColor];
    self.comid = [NSString stringWithFormat:@"%@",model.comid];
    
    
 
}








@end
