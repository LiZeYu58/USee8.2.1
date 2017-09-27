//
//  SegmentView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    排行、收藏夹 控件封装
 */




#import "BaseView.h"

@class SegmentView;
@protocol SegmentViewDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)piecewiseView:(SegmentView *)piecewiseView index:(NSInteger)index;     //排行收藏夹按钮切换自定义

@end


@interface SegmentView : BaseView

/**
 *  按钮标题
 */
@property(nonatomic,strong)NSArray *titleArray;

/**
 *  选中状态背景颜色
 */
@property(nonatomic,strong)UIColor *backgroundSeletedColor;

/**
 *  默认状态背景颜色
 */
@property(nonatomic,strong)UIColor *backgroundNormalColor;

/**
 *  下划线的颜色
 */
@property(nonatomic,strong)UIColor *linColor;

/**
 *  文字大小
 */
@property(nonatomic,strong)UIFont *textFont;

/**
 *  文字默认状态颜色
 */
@property(nonatomic,strong)UIColor *textNormalColor;

/**
 *  文字选中状态颜色
 */
@property(nonatomic,strong)UIColor *textSeletedColor;


@property(assign, nonatomic) id<SegmentViewDelegate> delegate;


/**
 *  加载标题显示的方法
 */
- (void)loadTitleArray:(NSArray *)titleArray;



@end
