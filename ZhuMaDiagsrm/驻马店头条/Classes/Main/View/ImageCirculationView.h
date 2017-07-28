//
//  ImageCirculationView.h
//  ZmdtvNews
//
//  Created by Mac10.11.4 on 16/4/6.
//  Copyright © 2016年 zmdtvw. All rights reserved.
//


@class ImageCirculationView;

#import <Foundation/Foundation.h>

@protocol clickPhoto <NSObject>
//点击图片加载网页
-(void)circulationView:(ImageCirculationView *)circulationView clickThePhotoWithTitle:(NSString*)title andUrl:(NSString*)url andInter:(NSInteger )type anid:(NSInteger )id andareid:(NSInteger )ar_id anduserpic:(NSString *)ar_userpic andwl:(NSString *)arwl andtime:(NSString *)time andcname:(NSString *)cname andpicture:(NSString *)picture andstate:(NSString *)state;
@end




#import <UIKit/UIKit.h>

@class ZMDNcirculationModel;

@interface ImageCirculationView : UIView< UIScrollViewDelegate >

@property(nonatomic,weak) id<clickPhoto> clickDelege;

//@property(nonatomic,strong)  * <#name#> ;

@property(nonatomic,strong) UIScrollView * imageScroll ;

@property(nonatomic,strong) UIPageControl *imagePageControl;

@property(nonatomic,strong) UIView * descView ;

@property(nonatomic,strong) UILabel * imageTitle;

@property(nonatomic,strong) UILabel * pageLable;

@property(nonatomic, assign) NSUInteger currentImageIndex;

@property(nonatomic,strong) ZMDNcirculationModel* ImageCirModel ;

@property(nonatomic,strong) NSString *httpUrl;


@end














