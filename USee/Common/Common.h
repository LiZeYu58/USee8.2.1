//
//  Common.h
//  LOSBi
//
//  Created by JJT on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

+ (BOOL)color:(UIColor *)color1                   //手势密码颜色封装
isEqualToColor:(UIColor *)color2
withTolerance:(CGFloat)tolerance;

@end
