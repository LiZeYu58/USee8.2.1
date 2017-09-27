//
//  GestureVerifyViewController.h
//  LOSBi
//
//  Created by JJT on 16/8/31.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



/*
  
    手势密码验证页面
 
 */



#import "BaseViewController.h"

@protocol GestureVerifyViewControllerDelegate <NSObject>

@optional

- (void)gestureVerfyAccessDidPass;

@end

@interface GestureVerifyViewController : BaseViewController

@property (nonatomic, assign) BOOL isToSetNewGesture;    // 手势密码的封装

@property (nonatomic, assign) BOOL isSwitchClose;  //按钮关闭手势

@property (nonatomic, assign) BOOL isChangeGesture;  //修改手势密码

@property (nonatomic, assign) id<GestureVerifyViewControllerDelegate> delegate;

@end
