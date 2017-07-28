//
//  LiveTwoCell.m
//  ZMDLiveBroadcast
//
//  Created by Mac10.11.4 on 16/10/12.
//  Copyright © 2016年 吕哈哈. All rights reserved.
//

#import "LiveTwoCell.h"
#import "PrefixHeader.pch"
#import "WebviewController.h"
#import "LiveContentViewController.h"

@implementation LiveTwoCell

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
     self.twocontentlable.font = [UIFont  fontWithName:@"STHeitiSC-Light" size:16.0];
    contentframe.size.height = [[self class]heightWithContentText:recommendModel.depict];
    self.twocontentlable.frame = contentframe;
    self.twocontentlable.text = recommendModel.depict;
    self.twocontentlable.numberOfLines = 0;
   
    self.twocontentlable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.twocontentlable addGestureRecognizer:tap4];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.twouserimage sd_setImageWithURL: [NSURL URLWithString:recommendModel.photo] placeholderImage:[UIImage imageNamed:@"30"]];
    self.twouserimage.layer.masksToBounds = YES;
    self.twouserimage.layer.cornerRadius = 20;
    self.twouserimage.backgroundColor = [UIColor whiteColor];
    self.twotimelable.text = [Manager othertimeWithTimeIntervalString:recommendModel.time];
     self.twotimelable.numberOfLines = 0;
    self.twonamelable.text = recommendModel.hostname;
    self.twoimage1.frame = CGRectMake(80,contentframe.size.height+15, ScreenW-100, 220*Kscaleh);
    [self.twoimage1 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo1]];
    self.twoimage2.frame = CGRectMake(80,contentframe.size.height+15+225*Kscaleh, ScreenW-100, 220*Kscaleh);
    [self.twoimage2 sd_setImageWithURL:[NSURL URLWithString:recommendModel.photo2]];
    self.twoimage1.contentMode = UIViewContentModeRedraw;
    self.twoimage2.contentMode = UIViewContentModeRedraw;
    self.twoimage1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.twoimage1 addGestureRecognizer:tap];
    self.twoimage2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)];
    [self.twoimage2 addGestureRecognizer:tap1];
    
    if (recommendModel.videourl.length == 0){
        self.twolinelable.frame = CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+360*Kscaleh);
        self.twolinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        self.twomovieimage.frame = CGRectMake(0, 0, 0,0);
        self.playbtn.hidden = YES;
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+490*Kscaleh);
        self.botumlable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
    }else {
        self.twolinelable.frame =CGRectMake(40, 115, 1, [[self class]heightWithContentText:recommendModel.depict]+585*Kscaleh);
        self.twolinelable.backgroundColor = [UIColor colorWithWhite:0.7f alpha:0.5];
        self.twomovieimage.frame = CGRectMake(80, [[self class]heightWithContentText:recommendModel.depict]+15+450*Kscaleh, ScreenW-100, 220*Kscaleh);
        
        self.playbtn.frame = CGRectMake(80+(ScreenW-100-50)/2, [[self class]heightWithContentText:recommendModel.depict]+15 +450*Kscaleh + (220*Kscaleh-50)/2, 50,50);
        
        [self.twomovieimage sd_setImageWithURL:[NSURL URLWithString:recommendModel.videoimg]];
        self.twomovieimage.contentMode = UIViewContentModeRedraw;
        self.twomovieimage.userInteractionEnabled = YES;
        self.playbtn.hidden = NO;
        self.botumlable.frame =CGRectMake(70, 5, ScreenW-80, [[self class]heightWithContentText:recommendModel.depict]+710*Kscaleh);
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
        return height + 515*Kscaleh;
    }else {
        return height + 650*Kscaleh + 80*Kscaleh;
    }
    
    return 0;
}

@end
