//
//  BigBtnView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.





/*
 
    日周月年按钮块单独封装
 */



#import "BaseView.h"

typedef NS_ENUM(NSInteger, BigBtnViewInit) {
    BigBtnViewInitSelectedIndex
};

@class BigBtnView;

@protocol BigBtnViewDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index;//日周月年按钮封装(单独)

@end

@interface BigBtnView : BaseView

@property(assign, nonatomic) id<BigBtnViewDelegate> delegate;
@property (nonatomic ,strong) UIButton * btn;
@property (nonatomic ,strong) NSMutableArray *arr;

- (void) showBigBtnView:(NSArray *)array;
- (void) generateComponentViewWith:(NSInteger)columnCount;
- (void)setBtnSelectedWithIndex:(NSInteger)index;
- (void) setTitleWith:(NSArray *)dataList;

@end
