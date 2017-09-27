//
//  BigAndTimeView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    搜索框 及以上部分的封装（三块）
 */



#import "BaseView.h"


@class BigAndTimeView;
@protocol BigAndTimeViewDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index;     //店铺排行上方整体的自定义

- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index;


@optional
- (void)searchView:(BigAndTimeView *)bigAndTimeView text:(NSString *)text;

- (void)clearAllTextStringButton;
@end



@interface BigAndTimeView : BaseView


-(void)showBigAndTimeView:(NSArray *)arr WithState:(BOOL)bol Withplaceholder:(NSString *)placeholder WithTimeArray:(NSArray *)timeArr withIndexOfSubheadBar:(NSInteger)indexOfSubHeadBar withIndexOfTime:(NSInteger)indexOfTime scrollViewTag:(NSInteger)tag;

-(void)showRegionAndShoppingGuideBigAndTimeView:(NSArray *)arr WithState:(BOOL)bol Withplaceholder:(NSString *)placeholder WithTimeArray:(NSArray *)timeArr withIndexOfSubheadBar:(NSInteger)indexOfSubHeadBar withIndexOfTime:(NSInteger)indexOfTime  scrollViewTag:(NSInteger)tag;

//合计按钮以及日周月年按钮的封装


@property(assign, nonatomic) id<BigAndTimeViewDelegate> delegate;
@property(nonatomic) BOOL checkUserType;
@property (nonatomic,strong) UIView *upView;

@property (nonatomic ,strong) UIScrollView *ScrollView;

@property (nonatomic ,strong) UIButton * upBtn;

@property (nonatomic ,strong) UIButton * downBtn;

@property (nonatomic ,strong) NSMutableArray *array;

@property (nonatomic ,strong) NSMutableArray *downArr;

@property (nonatomic , strong) UIButton * rightBtn;

@property (nonatomic , strong) UIButton * lefttBtn;


@property (nonatomic ,strong) NSArray *numArr;


@end
