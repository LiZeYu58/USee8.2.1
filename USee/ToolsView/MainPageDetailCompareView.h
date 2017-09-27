//
//  MainPageDetailCompareView.h
//  LOSBi
//
//  Created by gufeifei on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    主页详情 视图
 */




#import "BaseView.h"

@interface MainPageDetailCompareView : BaseView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIColor *chartColor;
@property (nonatomic, strong) UIColor *originBgColor;
@property (nonatomic, strong) UIColor *selectBgColor;
@property (nonatomic, strong) UIColor *originTextColor;
@property (nonatomic, strong) UIColor *selectTextColor;
@property (nonatomic, strong) NSMutableArray *compareArray;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *value;
@property (nonatomic, strong) UIView *chartColorView;

- (void)setTitle:(NSString *)title value:(NSString *)value;
- (void)setTitle:(NSString *)title value:(NSString *)value valueFont:(NSInteger)valueFont;

@end
