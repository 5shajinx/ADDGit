//
//  LiveForthCell.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "LiveForthCell.h"
#import "PrefixHeader.pch"
#import "WebviewController.h"
#import "LiveContentViewController.h"

@implementation LiveForthCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





-(void)setRecommendModel:(LiveContentModel *)recommendModel
{
    _recommendModel = recommendModel;
    
       
    CGRect contentframe = CGRectMake(80, 5, ScreenW-90, 0);
    self.forthcontentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    contentframe.size.height = [[self class]heightWithContentText:recommendModel.depict];
    self.forthcontentlable.frame = contentframe;
    self.forthcontentlable.text = recommendModel.depict;
    self.forthcontentlable.numberOfLines = 0;
    
    
    self.forthcontentlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.forthcontentlable addGestureRecognizer:tap4];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.forthuserimage sd_setImageWithURL: [NSURL URLWithString:recommendModel.photo] placeholderImage:[UIImage imageNamed:@"30"]];
    self.forthuserimage.layer.masksToBounds = YES;
    self.forthuserimage.layer.cornerRadius = 20;
    self.forthuserimage.backgroundColor = [UIColor whiteColor];
    
    self.forthtimelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.time];
    self.forthtimelable.numberOfLines = 0;
    self.forthnamelable.text = recommendModel.hostname;
    
    self.forthimage1.frame = CGRectMake(80,contentframe.size.height+15, ScreenW-100, 220*Kscaleh);
    [self.forthimage1 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo1]];
        
    self.forthimage2.frame = CGRectMake(80,contentframe.size.height+15+225*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.forthimage2 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo2]];
 
    self.forthimage3.frame = CGRectMake(80,contentframe.size.height+15+450*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.forthimage3 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo3]];
    
    self.forthimage4.frame = CGRectMake(80,contentframe.size.height+15+675*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.forthimage4 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo4]];
    
    self.forthimage1.contentMode = UIViewContentModeRedraw;
    self.forthimage2.contentMode = UIViewContentModeRedraw;
    self.forthimage3.contentMode = UIViewContentModeRedraw;
    self.forthimage4.contentMode = UIViewContentModeRedraw;
    
    
    self.forthimage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.forthimage1 addGestureRecognizer:tap];
    
    self.forthimage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.forthimage2 addGestureRecognizer:tap1];
    
    self.forthimage3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.forthimage3 addGestureRecognizer:tap2];
    
    self.forthimage4.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.forthimage4 addGestureRecognizer:tap3];
    
    
    
    [[Manager sharedManager]zhuanhuanpic:recommendModel.photo1];
    
    
    if (recommendModel.videourl.length == 0){
        self.playbtn.hidden = YES;
        self.movieimageview.frame = CGRectMake(0, 0, 0, 0);
        self.forthlinelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+825*Kscaleh);
        self.forthlinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+950*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        
    }else {
        self.movieimageview.frame = CGRectMake(80, [[self class]heightWithContentText:recommendModel.depict]+15 +900*Kscaleh, ScreenW-100,220*Kscaleh);
        
         self.playbtn.frame = CGRectMake(80+(ScreenW-100-50)/2, [[self class]heightWithContentText:recommendModel.depict]+15 +900*Kscaleh + (220*Kscaleh-50)/2, 50,50);
        
        [self.movieimageview sd_setImageWithURL:[NSURL URLWithString:recommendModel.videoimg]];
        self.movieimageview.contentMode = UIViewContentModeRedraw;
        self.movieimageview.userInteractionEnabled = YES;
        self.forthlinelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+1020*Kscaleh);
        self.forthlinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+1155*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        
        self.botumlable.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
        [self.botumlable addGestureRecognizer:tapp2];
    }

    self.botumlable.layer.masksToBounds = YES;
    self.botumlable.layer.cornerRadius = 10;
    
}





- (void)play:(UITapGestureRecognizer *)sender {
    
    
    
    if (self.delegated && [self.delegated respondsToSelector:@selector(PassValueDelegatestring) ]) {
        [self.delegated PassValueDelegatestring];
    }
    
}




//根据content里的内容字符串的多少，来动态计算文本的高度，从而达到 自适应的目的；
+ (CGFloat )heightWithContentText:(NSString *)text {
    CGFloat height = [text boundingRectWithSize:CGSizeMake(ScreenW - 120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size.height;
    return height;//字符串动态计算之后所占的高度
}
//为cell自定义高度的方法，给外界调用方法的接口；并将cell的高度返回给外界（视图控制器）使用；
+ (CGFloat )heightForCell:(LiveContentModel *)model {
    //1.得到内容lable字符串自适应得到的高度
    CGFloat height = [self heightWithContentText:model.depict];
    if (model.videourl.length == 0) {
        return height + 975*Kscaleh;
    }else {
       return height + 1010*Kscaleh + 160*Kscaleh;
    }
    return 0;
}






@end
