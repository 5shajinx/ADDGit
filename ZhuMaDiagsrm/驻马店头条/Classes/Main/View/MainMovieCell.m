//
//  MainMovieCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/10/20.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "MainMovieCell.h"

@implementation MainMovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRecommendModel:(ZMDNRecommend *)recommendModel
{
    _recommendModel = recommendModel;
    self.titlelable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:18.0];
    self.titlelable.text = _recommendModel.ar_title;
    
    CGSize size = [self getTheLableSize: self.titlelable withMaxWidth:ScreenW - 20];
    
    [self.userimage sd_setImageWithURL:[NSURL URLWithString:_recommendModel.ar_userpic]];
    self.userimage.layer.masksToBounds = YES;
    self.userimage.layer.cornerRadius = 10;
    self.userimage.backgroundColor = [UIColor whiteColor];
    self.userimage.contentMode = UIViewContentModeScaleToFill;
    [self.titlelable sizeThatFits:size];
    
    //self.commonlable.text = [NSString stringWithFormat:@"%d",recommendModel.ar_volume];
    self.commonlable.hidden = YES;
    
    
    
    [self.imageview sd_setImageWithURL: [NSURL URLWithString:_recommendModel.ar_pic] placeholderImage:[UIImage imageNamed:@"hui"]];
    //    if (recommendModel.ar_type != 4) {
    self.imageview.layer.masksToBounds = YES;
    //self.imageview.layer.cornerRadius = 15;
    //    }
    self.imageview.contentMode = UIViewContentModeScaleAspectFill;
    self.imageview.clipsToBounds = YES;
    
    
    
    //    if (recommendModel.ar_type == 4)
    //    {
    //        UIImageView *vedioImage = [[UIImageView alloc] init];
    //        vedioImage.image = [UIImage imageNamed:@"play"];
    //        [self.bigPic addSubview:vedioImage];
    //        [vedioImage mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.center.equalTo(self.bigPic);
    //            make.size.mas_equalTo(CGSizeMake(30, 30));
    //        }];
    //
    //
    //     }
    if ([_recommendModel.ar_length isEqualToString:@"0"]) {
        self.timeLength.hidden = YES;
    }else {
        self.timeLength.text = _recommendModel.ar_length;
    }
    
    
    
    self.timelable.layer.masksToBounds = YES;
    self.timelable.layer.cornerRadius = 5;
    
    self.sourcelable.text = _recommendModel.ar_ly;
    self.timelable.text = [Manager othertimeWithTimeIntervalString:_recommendModel.ar_time];
    [self layoutIfNeeded];
    
    self.cellHeight = CGRectGetMaxY(self.commonlable.frame) + 10;
    
}


-(CGSize)getTheLableSize:(UILabel*)showLable withMaxWidth:(CGFloat)maxWidth
{
    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 2;
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"STHeitiSC-Medium" size:18.0], NSParagraphStyleAttributeName:paraStyle};
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    
    CGSize contentSize = [showLable.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin  attributes:attributes context:nil].size;
    
    showLable.size = contentSize;
    
    return contentSize;
}

@end
