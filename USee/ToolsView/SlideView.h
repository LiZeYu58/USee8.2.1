//
//  SlideView.h
//  LOSBi
//
//  Created by JJT on 16/8/26.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    侧滑视图汇总
 */



#import "BaseView.h"

typedef enum{
    LeftViewTypeGoodsRank1,
    LeftViewTypeKeyPoint1,
    LeftViewTypeStoreRank1,
    LeftViewTypeGoods1,
    LeftViewTypeGuide1,
    
}LeftViewType1;


@class SlideView;
@protocol SlideViewDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)piecewiseView:(SlideView *)slideView index:(NSInteger)index;         //侧滑界面


@end

@interface SlideView : BaseView


/**
 *  按钮标题
 */
@property(nonatomic,strong)NSArray *titleArray;

/**
 *  文字大小
 */
@property(nonatomic,strong)UIFont *textFont;

/**
 *  显示类型
 */
@property (nonatomic, assign) LeftViewType1 type;

@property(assign, nonatomic) id<SlideViewDelegate> delegate;

@property(nonatomic) NSInteger GoodsIndex;
@property(nonatomic) NSInteger StoreRankIndex;

@property(nonatomic) NSInteger GoodIndex;

/**
 *  加载标题显示的方法
 */
- (void)loadTitleArray:(NSArray *)titleArray;

- (void)loadTitleArray:(NSArray *)titleArray arr:(NSInteger)index;

-(void)loadGoodsRankView;
-(void)loadStoreRankView;
-(void)loadGoodsView;

@end
