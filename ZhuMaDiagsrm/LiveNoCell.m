//
//  LiveNoCell.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "LiveNoCell.h"
#import "PrefixHeader.pch"
#import "WebviewController.h"
#import "LiveContentViewController.h"

@implementation LiveNoCell

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
    self.contentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    contentframe.size.height = [[self class]heightWithContentText:recommendModel.depict];
    self.contentlable.frame = contentframe;
    self.contentlable.text = recommendModel.depict;
    self.contentlable.numberOfLines = 0;
    
    self.contentlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.contentlable addGestureRecognizer:tap4];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.userimageview sd_setImageWithURL: [NSURL URLWithString:recommendModel.photo] placeholderImage:[UIImage imageNamed:@"30"]];
    self.userimageview.layer.masksToBounds = YES;
    self.userimageview.layer.cornerRadius = 20;
    self.userimageview.backgroundColor = [UIColor whiteColor];
    self.usernamelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.time];
    self.usernamelable.numberOfLines = 0;
    self.timelable.text = recommendModel.hostname;
    if (recommendModel.videourl.length == 0 ) {
        self.nomovieimage.frame = CGRectMake(0, 0, 0, 0);
        self.playbtn.hidden = YES;
        CGFloat heightt = [[self class]heightWithContentText:recommendModel.depict];
        if (heightt >= 100) {
            self.linelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]-90);
        }else {
            self.linelable.frame =CGRectMake(40, 115, 1, 0);
        }
        self.linelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+25*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
    }else {
        self.nomovieimage.frame = CGRectMake(80, contentframe.size.height+15, ScreenW-100, 220*Kscaleh);
        [self.nomovieimage sd_setImageWithURL:[NSURL URLWithString:recommendModel.videoimg]];
        self.nomovieimage.userInteractionEnabled = YES;
        self.nomovieimage.contentMode = UIViewContentModeRedraw;
        
        self.playbtn.frame = CGRectMake(80+(ScreenW-100-50)/2, [[self class]heightWithContentText:recommendModel.depict]+15 + (220*Kscaleh-50)/2, 50,50);
        self.linelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+150*Kscaleh);
        self.linelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+270*Kscaleh);
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
        return height + 55*Kscaleh;
    }else {
        return height + 220*Kscaleh + 100*Kscaleh;
    }
    return 0;
}

@end
