//
//  UIColor+LOSHexColor.h
//  LOSXX
//
//  Created by gufeifei on 15/6/17.
//  Copyright (c) 2015年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LOSHexColor)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (UIColor *)colorWithLOSR:(float)r G:(float)g B:(float)b;

@end
