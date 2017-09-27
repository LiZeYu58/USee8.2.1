//
//  LOConst.m
//  LOSBi
//
//  Created by Mac on 07/11/2016.
//  Copyright © 2016 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+LOSHexColor.h"
#import "LOConst.h"

//显示定义
NSInteger const BarCharMaxEntryCount = 7;
NSInteger const CompareMaxCount = 3;

//颜色定义
//NSArray *compareColorArray = @[@"0xf29c9f", @"0xf88f57", @"0xa8a8a8"];
//NSString * const RadioColor = @"RadioColor";

NSString * const CompareRadioColor = @"CompareRadioColor";
NSString * const CompareTextColor = @"CompareTextColor";
NSString * const CompareBackgroundColor = @"CompareBackgroundColor";
NSString * const CompareSelectionTextColor = @"CompareSelectionTextColor";
NSString * const CompareSelectionBackgroundColor = @"CompareSelectionBackgroundColor";

long const ModulOneFirstRadioColorCode = 0xf29c9f;
long const ModulOneSencendRadioColorCode = 0xf88f57;
long const ModulOneThirdRadioColorCode = 0xa8a8a8;
long const ModulOneTextColorCode = 0xa8a8a8;
long const ModulOneBackgroundColorCode = 0xdfdfdf;
long const ModulOneTextSelectionColorCode = 0xba2932;
long const ModulOneBackgroundSelectionColorCode = 0xffffff;

long const ModulTwoFirstRadioColorCode = 0xffffff;
long const ModulTwoSencendRadioColorCode = 0xffffff;
long const ModulTwoThirdRadioColorCode = 0xffffff;
long const ModulTwoTextColorCode = 0xba2932;
long const ModulTwoBackgroundColorCode = 0xffffff;
long const ModulTwoTextSelectionColorCode = 0xba2932;
long const ModulTwoBackgroundSelectionColorCode = 0xffffff;

@implementation LOConst

static LOConst *contDatas;

+ (LOConst *)init {
    
    contDatas = [[LOConst alloc] init];
    
    return contDatas;
    
}

+ (LOConst *)getCompareComponentColorSet {
    
    contDatas == nil ? contDatas = [[LOConst alloc] init] : contDatas;
    
    if (contDatas.compareColorArray == nil) {
        
        contDatas.compareColorArray = [NSMutableArray new];
        
        NSMutableDictionary * dic = [NSMutableDictionary new];
        [dic setObject:@[[UIColor colorWithHex:ModulOneFirstRadioColorCode], [UIColor colorWithHex:ModulOneSencendRadioColorCode], [UIColor colorWithHex:ModulOneThirdRadioColorCode]] forKey:CompareRadioColor];
        [dic setObject:[UIColor colorWithHex:ModulOneTextColorCode] forKey:CompareTextColor];
        [dic setObject:[UIColor colorWithHex:ModulOneBackgroundColorCode] forKey:CompareBackgroundColor];
        [dic setObject:[UIColor colorWithHex:ModulOneTextSelectionColorCode] forKey:CompareSelectionTextColor];
        [dic setObject:[UIColor colorWithHex:ModulOneBackgroundSelectionColorCode] forKey:CompareSelectionBackgroundColor];
        [contDatas.compareColorArray addObject:dic];
        
        dic = [NSMutableDictionary new];
        [dic setObject:@[[UIColor colorWithHex:ModulTwoFirstRadioColorCode], [UIColor colorWithHex:ModulTwoSencendRadioColorCode], [UIColor colorWithHex:ModulTwoThirdRadioColorCode]] forKey:CompareRadioColor];
        [dic setObject:[UIColor colorWithHex:ModulTwoTextColorCode] forKey:CompareTextColor];
        [dic setObject:[UIColor colorWithHex:ModulTwoBackgroundColorCode] forKey:CompareBackgroundColor];
        [dic setObject:[UIColor colorWithHex:ModulTwoTextSelectionColorCode] forKey:CompareSelectionTextColor];
        [dic setObject:[UIColor colorWithHex:ModulTwoBackgroundSelectionColorCode] forKey:CompareSelectionBackgroundColor];
        [contDatas.compareColorArray addObject:dic];
        
    }
    
    return contDatas;
    
}

+ (CGFloat)refX:(UIView *)view {
    
    return view.frame.origin.x;
    
}

+ (CGFloat)refX:(UIView *)view p:(CGFloat)point {
    
    return view.frame.origin.x + point * SCREEN_W_SP;
    
}

+ (CGFloat)refW:(UIView *)view {
    
    return view.frame.size.width;
    
}

+ (CGFloat)refW:(UIView *)view p:(CGFloat)point {
    
    return view.frame.size.width + point * SCREEN_W_SP;
    
}

+ (CGFloat)refXW:(UIView *)view p:(CGFloat)point {
    
    return view.frame.origin.x + view.frame.size.width + point * SCREEN_W_SP;
    
}

+ (CGFloat)refY:(UIView *)view {
    
    return view.frame.origin.y;
    
}

+ (CGFloat)refY:(UIView *)view p:(CGFloat)point {
    
    return view.frame.origin.y + point * SCREEN_H_SP;
    
}

+ (CGFloat)refH:(UIView *)view {
    
    return view.frame.size.height;
    
}

+ (CGFloat)refH:(UIView *)view p:(CGFloat)point {
    
    return view.frame.size.height + point * SCREEN_H_SP;
    
}

+ (CGFloat)refYH:(UIView *)view p:(CGFloat)point {
    
    return view.frame.origin.y + view.frame.size.height + point * SCREEN_H_SP;
    
}

@end
