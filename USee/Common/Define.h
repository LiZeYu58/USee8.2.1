//
//  Define.h
//  LOSBi
//
//  Created by gufeifei on 16/8/10.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#ifndef Define_h
#define Define_h

//打印输出log，dlog只在debug模式下输出
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define DLogObject(obj) DLog(@"%@", obj)
#	define DAlert(msg) {UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; [alertView show];}

#else
#	define DLog(...)
#   define DLogObject(...)
#	define DAlert(...)
#endif

#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//对话框显示信息
#define LOSAlert(msg) {UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]; [alertView show];}


//获取屏幕 宽度、高度
#define SCREEN_FRAME ([UIScreen mainScreen].applicationFrame)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

// [[UIScreen mainScreen]bounds].size.height/667
#define SCREEN_H_SP [[UIScreen mainScreen]bounds].size.width/375
#define SCREEN_W_SP [[UIScreen mainScreen]bounds].size.width/375


//屏幕宽高
#define DeviceWidth MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define DeviceHeight MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)

//系统版本
#define  DEVICE_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] doubleValue]
// 是否为iOS7
#define isiOS7 (DEVICE_SYSTEM_VERSION >= 7.0)
#define isiOS8 (DEVICE_SYSTEM_VERSION >= 8.0)
#define isiOS9 (DEVICE_SYSTEM_VERSION >= 9.0)

//颜色
#define Color(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ColorThemeRed [UIColor colorWithHex:0xba2932]
#define ColorText Color(123, 123, 123)

//字号
#define Font_14 [UIFont systemFontOfSize:14]


//navigationBar高度
#define NavigationBarHeight 64

//notifications
#define NotificationForSelectDate @"NotificationForSelectDate"





#endif /* Define_h */
