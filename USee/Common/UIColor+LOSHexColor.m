//
//  UIColor+LOSHexColor.m
//  LOSXX
//
//  Created by gufeifei on 15/6/17.
//  Copyright (c) 2015年 L.O.S. All rights reserved.
//

#import "UIColor+LOSHexColor.h"

@implementation UIColor (LOSHexColor)

+ (UIColor*)colorWithHex:(long)hexColor;
{
    return [UIColor colorWithHex:hexColor alpha:1.];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (UIColor *)colorWithLOSR:(float)r G:(float)g B:(float)b {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

@end
