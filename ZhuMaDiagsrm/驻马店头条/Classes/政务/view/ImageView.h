//
//  ImageView.h
//  驻马店头条
//
//  Created by Mac10.11.4 on 16/7/29.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//
@class ImageView;

#import <Foundation/Foundation.h>

@protocol clickfbdtpic <NSObject>
//点击图片加载网页
-(void)circulationView:(ImageView *)circulationView clickThePictureWithTitle:(NSString*)title andUrl:(NSString*)url andInter:(NSString *)arid andwl:(NSString *)arwl;
@end


#import <UIKit/UIKit.h>

@class FBDTModel;


@interface ImageView : UIView< UIScrollViewDelegate >

@property(nonatomic,weak) id<clickfbdtpic> clickDelege;


@property(nonatomic,strong) UIScrollView * imageScroll ;

@property(nonatomic,strong) UIPageControl *imagePageControl;

@property(nonatomic,strong) UIView * descView ;

@property(nonatomic,strong) UILabel * imageTitle;

@property(nonatomic,strong) UILabel * pageLable;

@property(nonatomic, assign) NSUInteger currentImageIndex;

@property(nonatomic,strong) FBDTModel * ImageCirModel ;

@property(nonatomic,strong) NSString *httpUrl;




@end
