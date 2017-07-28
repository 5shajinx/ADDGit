//
//  movieCell.m
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/6/16.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//

#import "movieCell.h"

@implementation movieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imageview.contentMode = UIViewContentModeScaleAspectFill;
        self.imageview.clipsToBounds = YES;
    }
    return self;
}



@end
