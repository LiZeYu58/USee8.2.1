//
//  Line.h
//  LOSBi
//
//  Created by JJT on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    手势密码线的封装
 */



#import <Foundation/Foundation.h>

@interface Line : NSObject

@property (nonatomic) CGPoint begin;                        //手势密码线的封装
@property (nonatomic) CGPoint end;
@property (nonatomic, retain) UIColor *color;

@end
