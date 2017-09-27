//
//  UIButton+LOSButton.h
//  LOSBi
//
//  Created by gufeifei on 16/8/24.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LOSButton)                //按钮扩展

- (void)setTitle:(NSString *)title;

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end