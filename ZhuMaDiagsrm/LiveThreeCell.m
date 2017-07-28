//
//  LiveThreeCell.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "LiveThreeCell.h"
#import "PrefixHeader.pch"
#import "WebviewController.h"
#import "LiveContentViewController.h"

@implementation LiveThreeCell

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
    self.threecontentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    contentframe.size.height = [[self class]heightWithContentText:recommendModel.depict];
    self.threecontentlable.frame = contentframe;
    self.threecontentlable.text = recommendModel.depict;
    self.threecontentlable.numberOfLines = 0;
    
    self.threecontentlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.threecontentlable addGestureRecognizer:tap4];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
  
    
    [self.threeuserimage sd_setImageWithURL: [NSURL URLWithString:recommendModel.photo] placeholderImage:[UIImage imageNamed:@"30"]];
    self.threeuserimage.layer.masksToBounds = YES;
    self.threeuserimage.layer.cornerRadius = 20;
    self.threeuserimage.backgroundColor = [UIColor whiteColor];
    
    self.threetimelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.time];
     self.threetimelable.numberOfLines = 0;
    self.threenamelable.text = recommendModel.hostname;
    self.threeimage1.frame = CGRectMake(80,contentframe.size.height+15, ScreenW-100, 220*Kscaleh);
    [self.threeimage1 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo1]];
    self.threeimage2.frame = CGRectMake(80,contentframe.size.height+15+225*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.threeimage2 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo2]];
    self.threeimage3.frame = CGRectMake(80,contentframe.size.height+15+450*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.threeimage3 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo3]];
    self.threeimage1.contentMode = UIViewContentModeRedraw;
    self.threeimage2.contentMode = UIViewContentModeRedraw;
    self.threeimage3.contentMode = UIViewContentModeRedraw;
    self.threeimage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.threeimage1 addGestureRecognizer:tap];
    self.threeimage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.threeimage2 addGestureRecognizer:tap1];
    self.threeimage3.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.threeimage3 addGestureRecognizer:tap2];
    
    if (recommendModel.videourl.length == 0) {
        self.playbtn.hidden = YES;
        self.threelinelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+620*Kscaleh );
        self.threelinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        
        self.threemovieimage.frame = CGRectMake(0, 0, 0, 0);
        
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+740*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];

        
    }else {
        self.threelinelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+790*Kscaleh );
        self.threelinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        
        self.threemovieimage.frame = CGRectMake(80, [[self class]heightWithContentText:recommendModel.depict]+15+675*Kscaleh, ScreenW-100, 220*Kscaleh);
        [self.threemovieimage sd_setImageWithURL:[NSURL URLWithString:recommendModel.videoimg]];
         self.threemovieimage.contentMode = UIViewContentModeRedraw;
        self.threemovieimage.userInteractionEnabled = YES;
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+925*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];

        self.playbtn.frame = CGRectMake(80+(ScreenW-100-50)/2, [[self class]heightWithContentText:recommendModel.depict]+15 +675*Kscaleh + (220*Kscaleh-50)/2, 50,50);
        
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
        return height + 770*Kscaleh;
    }else {
        return height + 840*Kscaleh + 100*Kscaleh;
    }
    
    return 0;
}


@end
