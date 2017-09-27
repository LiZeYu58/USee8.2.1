//
//  AppDelegate.h
//  LOSBi
//
//  Created by gufeifei on 16/8/8.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"


#pragma mark 上架bundleID :  com.Bizvane.USee

#pragma mark 企业打包bundleID :  com.BURGEON.youshu

@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;

- (void)switchRootViewController;
- (void)switchRootViewControllerMainPage004;

#pragma mark 监听网络状态
- (void)netWorkNotificationShowTips:(BOOL)showStatus;

@end

