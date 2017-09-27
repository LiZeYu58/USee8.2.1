//
//  LOConst.h
//  LOSBi
//
//  Created by Mac on 07/11/2016.
//  Copyright © 2016 L.O.S. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ColorModul) {
    
    ColorModulOne,
    ColorModulTwo
    
};

typedef NS_ENUM(long, Theme) {
    
    ColorMain = 0xff3d49,
    ColorSub = 0x654329
    
};

extern NSInteger const BarCharMaxEntryCount;
extern NSInteger const CompareMaxCount;
extern NSString * const CompareRadioColor;
extern NSString * const CompareTextColor;
extern NSString * const CompareBackgroundColor;
extern NSString * const CompareSelectionTextColor;
extern NSString * const CompareSelectionBackgroundColor;

@interface LOConst : NSObject

@property (nonatomic, strong) NSMutableArray<NSMutableDictionary *> *compareColorArray;
@property (nonatomic, strong) NSMutableArray *secondLevelViewArray;
@property (nonatomic, strong) NSMutableArray *thiredLevelViewArray;

+ (LOConst *)init;
+ (LOConst *)getCompareComponentColorSet;
+ (CGFloat)refX:(UIView *)view;
+ (CGFloat)refX:(UIView *)view p:(CGFloat)point;
+ (CGFloat)refW:(UIView *)view p:(CGFloat)point;
+ (CGFloat)refXW:(UIView *)view p:(CGFloat)point;
+ (CGFloat)refY:(UIView *)view;
+ (CGFloat)refY:(UIView *)view p:(CGFloat)point;
+ (CGFloat)refH:(UIView *)view p:(CGFloat)point;
+ (CGFloat)refYH:(UIView *)view p:(CGFloat)point;

@end
