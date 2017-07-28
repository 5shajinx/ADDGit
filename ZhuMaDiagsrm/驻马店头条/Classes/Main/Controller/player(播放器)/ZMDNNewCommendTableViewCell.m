//
//  ZMDNNewCommendTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/13.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDNNewCommendTableViewCell.h"

@implementation ZMDNNewCommendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self showDetaileWithLI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [self showDetaileWithLI];
    // Configure the view for the selected state
}
- (void)showDetaileWithLI{
    

    
    if(!_bgView){
        self.userImage = [[UIImageView alloc]init];
        [self.contentView addSubview:_userImage];
        self.userImage.layer.cornerRadius = 15;
        self.userImage.layer.masksToBounds = YES;
        
      [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.offset(10);
          make.left.offset(5);
          make.width.height.offset(30);
          
      }];
        
        
        self.bgView = [[UIView alloc]init];
        [self.contentView addSubview:_bgView];
       // _bgView.backgroundColor = [UIColor grayColor];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.offset(5);
            make.left.mas_equalTo(_userImage.mas_right).offset(10);
            
        }];
        
        self.timrLabel = [[UILabel alloc]init];
        [_bgView addSubview:_timrLabel];
        _timrLabel.font = [UIFont systemFontOfSize:13];
        _timrLabel.textColor = [UIColor lightGrayColor];
        
        [_timrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(7);
            make.right.offset(2);
            make.height.offset(15);
            make.width.offset(100);
            
        }];
        self.nameLabel = [[UILabel alloc]init];
        [_bgView addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor lightGrayColor];

        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(5);
            make.left.offset(2);
            make.height.offset(20);
            make.right.mas_equalTo(_timrLabel.mas_left).offset(-2);
        }];
        //隐藏评论内回复
//        self.huifuButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_huifuButton setImage:[UIImage imageNamed:@"Nwepinglun"] forState:UIControlStateNormal];
//        [_bgView addSubview:_huifuButton];
//        [_huifuButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.offset(22);
//            make.height.offset(22);
//            make.bottom.offset(-10);
//            make.right.mas_equalTo(_bgView.mas_right).offset(-10);
//        }];
        self.zanNumberLabel = [[UILabel alloc]init];
        [_bgView addSubview:_zanNumberLabel];
        _zanNumberLabel.font = [UIFont systemFontOfSize:15];
        _zanNumberLabel.textColor = [UIColor lightGrayColor];
        [_zanNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.offset(40);
//            make.height.offset(22);
//            make.bottom.offset(-10);
//            make.right.mas_equalTo(_huifuButton.mas_left).offset(-2);
            
            
            make.width.offset(22);
            make.height.offset(22);
            make.bottom.offset(-10);
            make.right.mas_equalTo(_bgView.mas_right).offset(-20);
            
        }];
        
        self.zanButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgView addSubview:_zanButton];
        [_zanButton setImage:[UIImage imageNamed:@"zan"] forState:UIControlStateNormal];
        [_zanButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(22);
            make.bottom.offset(-10);
            make.right.mas_equalTo(_zanNumberLabel.mas_left).offset(-2);
            
        }];
        
        self.commitDetailLabel = [[UILabel alloc]init];
        [_bgView addSubview:_commitDetailLabel];
       // _commitDetailLabel.backgroundColor = [UIColor redColor];
        [_commitDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(27);
            make.bottom.offset(-25);
            make.left.offset(7);
            make.right.mas_equalTo(_zanButton.mas_left).offset(-15);
            
        }];
        
    
        self.deleteButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [_bgView addSubview:_deleteButton];
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_deleteButton setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-10);
            make.height.offset(25);
            make.width.offset(46);
            make.left.mas_equalTo(_bgView.mas_left).offset(10);
            
        }];
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
}
@end
