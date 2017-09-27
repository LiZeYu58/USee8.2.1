//
//  ShiDuanView.h
//  LOSBi
//
//  Created by JJT on 16/8/18.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    日历 时段 封装（暂被弃用）
 */



#import <UIKit/UIKit.h>

@interface ShiDuanView : UIView

//日历时段的封装
@property (assign, nonatomic) BOOL flog;

@property (assign, nonatomic) NSString * str;;

@property (nonatomic,strong) UITextField * uptextField;

@property (nonatomic,strong) UILabel * upLab;

@property (nonatomic,strong) UIView * upView;

@property (nonatomic,strong) UILabel * downLab;

@property (nonatomic,strong) UITextField * downtextField;

@property (nonatomic,strong) UIView * downView;

@end
