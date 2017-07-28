//
//  ZMDDSNewTableViewCell.m
//  驻马店头条
//
//  Created by 孙满 on 2017/7/11.
//  Copyright © 2017年 zmdtvw. All rights reserved.
//

#import "ZMDDSNewTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation ZMDDSNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   [self.mySilder  setThumbImage:[UIImage imageNamed:@"66666666666666"] forState:UIControlStateNormal];
    // Initialization code
}
-(void)showdetilewithModel:(TVModel *)model{
    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.leftnameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    [self.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.img]]];
    
    
    
    
    
    
    
    
}
////暂停
//- (IBAction)suspend:(UIButton *)sender {
//    // 设置选中状态, 从而改变按钮图片
//    sender.selected = !sender.selected;
//    if (sender.selected) {
//        //播放
//        [[CustomMusicPlayer shareMusicPlayer] playMusic];
//        
//        //添加计时器, 让滑竿跟播放进去一起走
//        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setSliderCurrentValue) userInfo:nil repeats:YES];
//        
//        
//    } else{
//        //暂停
//        [[CustomMusicPlayer shareMusicPlayer] pauseMusic];
//        
//    }
//    
//}
//// 计时器执行的方法
//- (void)setSliderCurrentValue{
//    //1 获取当前播放的时间
//    NSTimeInterval currentTime = [CustomMusicPlayer shareMusicPlayer].player.currentTime;
//    // 给显示当前时间的label 赋值,
//    int time = (int)currentTime;
//    int minute = time / 60;
//    int secont = time % 60;
//    
//    self.leftTime.text = [NSString stringWithFormat:@"%02d:%02d", minute, secont];
//    // 给滑竿赋值
//    self.sliderOfSong.value = currentTime / [CustomMusicPlayer shareMusicPlayer].player.duration;
//    
//}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
