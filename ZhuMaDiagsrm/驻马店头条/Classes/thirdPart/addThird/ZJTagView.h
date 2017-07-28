//
//  ZJTagView.h
//  ZJTagView
//
//  Created by ZeroJ on 16/9/27.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJTagItem.h"

@class ZJTagView;
@protocol ZJTagViewDelegate <NSObject>

- (void)tagView:(ZJTagView *)tagView didChangeInEditState:(BOOL)inEditState;
- (void)tagView:(ZJTagView *)tagView didSelectTagWhenNotInEditState:(NSInteger)index;
- (void)tagView:(ZJTagView *)tagview SelectTagWithArray:(NSMutableArray*)SeleArray UnSelectWithArray:(NSMutableArray *)UnSelect;


@end

@interface ZJTagView : UIView

- (instancetype)initWithSelectedItems:(NSArray<ZJTagItem *> *)selectedItems unselectedItems:(NSArray<ZJTagItem *> *)unselectedItems;

@property (strong, nonatomic) NSString *unselctedSectionTitle;
@property (strong, nonatomic) NSString *undidselctedSectionTitle;


@property (assign, nonatomic) BOOL inEditState;

@property (weak, nonatomic) id<ZJTagViewDelegate> delegate;
@end
