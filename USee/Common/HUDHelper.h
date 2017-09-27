//
//  HUDHelper.h
//  USee
//
//  Created by 李泽雨 on 2017/3/27.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUDHelper : NSObject

@property (nonatomic, strong) MBProgressHUD *HUD;//加载提示器

+ (HUDHelper *) getInstance;

- (void) showLabelHUDOnScreen:(NSString*)label enabled:(BOOL)enabled;

- (void)showErrorTipWithLabel:(NSString*)label;

- (void)showInformationWithoutImage:(NSString*)label;

- (void) hideHUD;
@end
