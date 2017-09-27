//
//  MBProgressHUD+ZW.h
//
//  Created by Thomas on 13-4-18.
//  Copyright (c) 2013年 Thomas. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZW)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;


+ (MBProgressHUD *)showTipForView:(UIView *)view :(NSString *)message;


+ (void)hideHUD;

@end
