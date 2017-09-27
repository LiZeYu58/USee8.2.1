//
//  AppDelegate.m
//  LOSBi
//
//  Created by gufeifei on 16/8/8.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "AppDelegate.h"
#import "MainPageViewController.h"
#import "LeftSortsViewController.h"
#import "LoginViewController.h"
#import "LOSFMDB.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import "AppDatas.h"
#import "LOConst.h"
#import "LOSAFNetworking.h"
#import "LeftMenuShouShiMiMaViewController.h"
#import "PCCircleViewConst.h"
#import "GestureVerifyViewController.h"
#import "MBProgressHUD+ZW.h"
#import "NdUncaughtExceptionHandler.h"
#import <sys/utsname.h>
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate ()<GestureVerifyViewControllerDelegate,JPUSHRegisterDelegate> {
    
    NSDictionary *versionDic;
   
    NSString * newVersion;
    NSString * currentVersion;
    NSString * newVersionDownloadUrl;
    NSString * _update_type;
    
    NSMutableArray * messageArray;
    
    UIView *_backgroundView;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    @try {
        
        [NSThread sleepForTimeInterval:1.0];//设置启动页面时间
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"crashTheClassName"];
        
        
        //状态栏字体颜色
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //Required
        //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            // 可以添加自定义categories
            // NSSet<UNNotificationCategory *> *categories for iOS10 or later
            // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        }
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
        
        
        // Required
        // init Push
        // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
//        [JPUSHService setupWithOption:launchOptions appKey:@"2570d3d5bba2fd3d1f6fa292" channel:nil apsForProduction:NO];
        
        [JPUSHService setupWithOption:launchOptions appKey:@"2570d3d5bba2fd3d1f6fa292"
                              channel:@"http://update.bizvane.com/usee/v2/"
                     apsForProduction:NO
                advertisingIdentifier:nil];
        
#pragma nark  监听自定义消息
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:[self deviceModelName] forKey:@"iphoneModelLog"];
        
        [CommonTools removeFile:@"twoLinchpin"];
        [CommonTools removeFile:@"linchpinSelect"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linchpinCount"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"guanJianView"];
        
        [NdUncaughtExceptionHandler setDefaultHandler];
        
        NSMutableDictionary *errorLogDic = [CommonTools readFile:@"errorLogData.plist"];
        
        NSString *error_log = errorLogDic[@"error_log"];
        NSString *memoryWarning = [[NSUserDefaults standardUserDefaults] objectForKey:@"didReceiveMemoryWarning"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"didReceiveMemoryWarning"];
        if (error_log) {
            if ([memoryWarning isEqualToString:@"YES"]) {
                error_log = [NSString stringWithFormat:@"内存不足警告\n%@",error_log];
            }
            [self sendErrorlogWithErrorlog:error_log];
        }
        
        
        [LOSFMDB sharedLOSFMDB];
        [LOConst init];
        
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [self.window makeKeyAndVisible];
        
        
#pragma mark -  判断是否有缓存的已登录用户
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"alreadyLaunch"]) {
            
            [AppDatas sharedDatas].userCode = [[NSUserDefaults standardUserDefaults] objectForKey:@"Pusername"];
            
            //取手势密码是否设置的本地缓存
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *states = [user objectForKey:@"states"];
            
#pragma mark - 是否设置了手势密码
            if ([states isEqualToString:@"1"]) {
                
                GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
                gestureVerifyVc.isToSetNewGesture = NO;
                gestureVerifyVc.delegate = self;
                
                self.window.rootViewController = gestureVerifyVc;
                
            } else {
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewController];
                
            }
            
        }else{
            
            LoginViewController *appStartController = [[LoginViewController alloc] init];
            self.window.rootViewController = appStartController;
            [self.window addSubview:appStartController.view];
            
        }
        
#pragma mark - 微信分享
        
        [ShareSDK registerApp:@"1060cfece2d0e"
              activePlatforms:@[@(SSDKPlatformSubTypeWechatSession)]
                     onImport:^(SSDKPlatformType platformType) {
                         
                         switch (platformType)
                         {
                             case SSDKPlatformTypeWechat:
                                 [ShareSDKConnector connectWeChat:[WXApi class]];
                                 break;
                             default:
                                 break;
                         }
                         
                     }
              onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                  
                  switch (platformType)
                  {
                      case SSDKPlatformTypeWechat:
                          //设置微信应用信息
                          [appInfo SSDKSetupWeChatByAppId:@"wx6e014557acb3d8b0"
                                                appSecret:@"143773b0cd077053cbb1c8e7cc7f3bf3"];
                          break;
                      default:
                          break;
                  }
              }];
        
        return YES;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的Extras附加字段，key是自己定义的
    
   
    [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:[AppDatas sharedDatas].userCode];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CommunityPush" object:nil];
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate

#pragma mark  得到通知结果
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    
//    [[[UIAlertView alloc] initWithTitle:userInfo[@"aps"][@"alert"][@"title"] message:userInfo[@"aps"][@"alert"][@"body"] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"", nil] show];
}

#pragma 点击后台通知进入前台
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


#pragma mark 错误日志收集
- (void)sendErrorlogWithErrorlog:(NSString *)errorlog{
    
    @try {
       
        NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
        NSString *versionNum = infoDict[@"CFBundleShortVersionString"];
        
        NSMutableDictionary * dataDic = [[NSMutableDictionary alloc]init];
        
        NSString *  phoneNum   =  [[NSUserDefaults standardUserDefaults] objectForKey:@"phone_num"];
        if (!phoneNum && phoneNum.length == 0) {
            phoneNum = @"未知";
        }
        
        
        [dataDic setObject:phoneNum  forKey:@"user_code"];
        [dataDic setObject:@"1" forKey:@"app_type"];
        [dataDic setObject:errorlog forKey:@"crash_msg"];
        [dataDic setObject:versionNum forKey:@"app_version"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

        
        [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.CrashLog"
                     dataParameters:dataDic
                          withCache:YES
                            success:^(NSDictionary *responseDic) {
                                //                            DLogObject(responseDic);
                                if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                    
                                    [CommonTools removeFile:@"errorLogData.plist"];
                                    
                                }
                            }
                            failure:^(NSError *error) {
                                
                            }];

        });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark 监听网络状态
- (void)netWorkNotificationShowTips:(BOOL)showStatus{
    
    @try {
        
        //1.创建网络状态监测管理者
        AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            /*
             AFNetworkReachabilityStatusUnknown          = -1,
             AFNetworkReachabilityStatusNotReachable     = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
             */
            
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"未知网络");
                    break;
                    
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"没有网络");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3G|4G");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"WiFi");
                    break;
                    
                default:
                    break;
            }
            
            if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
            {
                if (showStatus) {
                    if(status ==AFNetworkReachabilityStatusReachableViaWWAN) {
                        [[HUDHelper getInstance] showErrorTipWithLabel:@"正在使用手机网络"];
                    }
                }
                NSLog(@"有网");
            }else
            {
                NSLog(@"没有网");
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"网络失去连接" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
        [manger startMonitoring];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}




#pragma mark - 启动 APP 时若先前有设定过手势, 会先调用手势页面, 通过后回调进入首页

- (void)gestureVerfyAccessDidPass {
    
    @try {
       
        [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewController];
    
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}



#pragma mark - APP 回到前台时调用 检查权限是否丢失, 未丢失且有设置手势密码时弹出手势密码页面

- (void)searchVersion {
    
    @try {
     
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.USeeUpdate" dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:[AppDatas sharedDatas].userCode, @"user_code", @"1", @"app_type", nil] withCache:YES
                           success:^(NSDictionary *responseDic) {
                               
                dispatch_async(dispatch_get_main_queue(), ^{
                                   
                [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                               
                if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                   
                                   NSDictionary *appInfoDictionary = [[NSBundle mainBundle] infoDictionary];
                                   currentVersion = [appInfoDictionary objectForKey:@"CFBundleShortVersionString"]; // app版本
                                   
                                   NSString *isActive = [NSString stringWithFormat:@"%@",responseDic[@"data"][@"data"][@"is_active"]];
                                   
                                   newVersion = responseDic[@"data"][@"data"][@"version"];
                                   
                                   _update_type = responseDic[@"data"][@"data"][@"update_type"];
                                   
                                   if ([isActive isEqualToString:@"N"]) {
                                       
                                       LOSAlert(@"无访问权限，请联系商帆管理人员。");
                                       
                                       [AppDatas sharedDatas].userPersonalInformation = nil;
                                       
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPersonalInformation"];
                                       
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyLaunch"];
                                       
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"funcPermission"];
                                       
                                       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Pusername"];
                                       
                                       LoginViewController *appStartController = [[LoginViewController alloc] init];
                                       
                                       self.window.rootViewController = appStartController;
                                       
                                   }
                                   else if ([isActive isEqualToString:@"false"]){
                                       
                                       LoginViewController * log = [LoginViewController new];
                                       
                                       [AppDatas restSharedData];
                                       
                                       [self.mainNavigationController presentViewController:log animated:YES completion:^{
                                           
                                           [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alreadyLaunch"];
                                           
                                       }];
                                       
                                   }
                                   
                                   NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
                                   
                                   
                                   if ([bundleID isEqualToString:@"com.BURGEON.youshu"])
                                   {
                                       NSInteger newVersionNumber = 0;
                                       NSInteger currentVersionNumber = 0;
                                       
                                       if (newVersion) {
                                           newVersionNumber = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
                                       }
                                       
                                       if (currentVersion) {
                                           currentVersionNumber = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
                                       }
                                       
                                       if (newVersionNumber > currentVersionNumber) {
                                           
                                           versionDic = responseDic;
                                           
                                           newVersionDownloadUrl = versionDic[@"data"][@"data"][@"update_url"];
                                           
                                           messageArray = [[NSMutableArray alloc] initWithArray:versionDic[@"data"][@"data"][@"update_desc"]];
                                           
                                           //版本更新
                                           if (messageArray) {
                                               [self showAlertView:messageArray];
                                               
                                           }
                                           
                                       }
                                       
                                   }
                                   
                               }
                               else {
                                   
                                   //                                   LOSAlert(responseDic[@"msg"]);
                                   
                               }
                               
                });
                           } failure:^(NSError *error) {
                               
                               //                               LOSAlert(@"无访问权限，请联系商帆管理人员。");
                               //                               [AppDatas sharedDatas].userPersonalInformation = nil;
                               //                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPersonalInformation"];
                               //                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyLaunch"];
                               //                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"funcPermission"];
                               //                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Pusername"];
                               //                               
                               //                               LoginViewController *appStartController = [[LoginViewController alloc] init];
                               //                               [self.mainNavigationController presentViewController:appStartController animated:NO completion:nil];
                               
                           }];

        });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 新版本展示弹框
- (void)showAlertView:(NSMutableArray *)messageArr {
    
    @try {
     
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backgroundView setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
        [window addSubview:_backgroundView];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 225 * SCREEN_W_SP) / 2, SCREEN_HEIGHT / 4, 225 * SCREEN_W_SP, (SCREEN_HEIGHT / 2) + 0.5)];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        [_backgroundView addSubview:alertView];
        
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertView.width, 34 * SCREEN_H_SP)];
        NSString * versionText = @"新版本";
        versionText = [versionText stringByAppendingString:newVersion];
        [versionLabel setText:versionText];
        [versionLabel setFont:[UIFont systemFontOfSize:14]];
        [versionLabel setTextColor:[UIColor colorWithHex:0x33333]];
        [versionLabel setTextAlignment:NSTextAlignmentCenter];
        [alertView addSubview:versionLabel];
        
        UIScrollView *alertScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height, alertView.width, alertView.height - versionLabel.height - 44 * SCREEN_H_SP - 0.5)];
        [alertScrollView setShowsVerticalScrollIndicator:YES];
        [alertView addSubview:alertScrollView];
        
        CGFloat labelHeightCount = 10 * SCREEN_H_SP;
        
        for (NSString *message in messageArr) {
            
            if (message && ![message isKindOfClass:[NSNull class]]) {
                
                UILabel *messageLabel = [UILabel new];
                [messageLabel setText:message];
                [messageLabel setTextColor:[UIColor colorWithHex:0x33333]];
                CGSize messageSize = [message boundingRectWithSize:CGSizeMake(alertScrollView.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                [messageLabel setFont:[UIFont systemFontOfSize:12]];
                [messageLabel setSize:messageSize];
                [messageLabel setX:10 * SCREEN_W_SP];
                [messageLabel setY:labelHeightCount];
                labelHeightCount += messageLabel.size.height + 10 * SCREEN_H_SP;
                [alertScrollView addSubview:messageLabel];
                
            }
        }
        
        [alertScrollView setContentSize:CGSizeMake(alertScrollView.width, labelHeightCount > alertScrollView.height ? labelHeightCount : alertScrollView.height)];
        
        UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height, alertView.width, 0.5)];
        [splitLine setBackgroundColor:[UIColor colorWithHex:0xdfdfdf]];
        [alertView addSubview:splitLine];
        
        
        
        if ([_update_type isEqualToString:@"1"]) {
            
            UIButton * rightDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width, 44 * SCREEN_H_SP)];
            [rightDownloadButton setTitle:@"立即下载" forState:UIControlStateNormal];
            rightDownloadButton.tag = 2;
            [[rightDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            [rightDownloadButton setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            [rightDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:rightDownloadButton];
            
        }
        else if ([_update_type isEqualToString:@"2"]){
            
            UIButton * leftDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width / 2, 44 * SCREEN_H_SP)];
            
            [leftDownloadButton setTitle:@"取消" forState:UIControlStateNormal];
            [[leftDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            leftDownloadButton.tag = 1;
            [leftDownloadButton setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            [leftDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:leftDownloadButton];
            
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertView.width / 2-1, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, 0.5, 44 * SCREEN_H_SP)];
            lineLabel.backgroundColor =  [UIColor colorWithHex:0xdfdfdf];
            [alertView addSubview:lineLabel];
            
            UIButton * rightDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(alertView.width / 2, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width / 2, 44 * SCREEN_H_SP)];
            rightDownloadButton.tag = 2;
            [rightDownloadButton setTitle:@"立即下载" forState:UIControlStateNormal];
            [[rightDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            [rightDownloadButton setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            [rightDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:rightDownloadButton];
            
        }

    } @catch (NSException *exception) {
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)jumpToDownloadPage:(UIButton *)sender {
    
    @try {
       
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
        if (sender.tag == 2){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionDownloadUrl]];
        }

        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 切换根控制器
- (void)switchRootViewController {
    
    @try {
     
        self.window.rootViewController = nil;
        
        MainPageViewController *mainVC = [[MainPageViewController alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        
        [self.LeftSlideVC setPanEnabled:NO];
        
        self.window.rootViewController = self.LeftSlideVC;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 切换根控制器
- (void)switchRootViewControllerMainPage004 {
    
    @try {
     
        self.window.rootViewController = nil;
        
        MainPageDayDetailViewController_0004 *mainVC = [[MainPageDayDetailViewController_0004 alloc] init];
        self.mainNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
        
        LeftSortsViewController *leftVC = [[LeftSortsViewController alloc] init];
        self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.mainNavigationController];
        
        [self.LeftSlideVC setPanEnabled:NO];
        
        self.window.rootViewController = self.LeftSlideVC;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    @try {
     
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
#pragma mark - 进入后台 判断是否需要调用手势密码
        //取手势密码是否设置的本地缓存
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *states = [user objectForKey:@"states"];
        
        if (![[AppDatas sharedDatas].userCode isEqualToString:@""] && [states isEqualToString:@"1"]) {
            
            
            GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
            
            gestureVerifyVc.isToSetNewGesture = NO;
            
            [self.mainNavigationController presentViewController:gestureVerifyVc animated:NO completion:nil];
            
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 通过后台进入前台时调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    @try {
     
        NSMutableDictionary *errorLogDic = [CommonTools readFile:@"errorLogData.plist"];
        
        NSString *error_log = errorLogDic[@"error_log"];
        NSString *memoryWarning = [[NSUserDefaults standardUserDefaults] objectForKey:@"didReceiveMemoryWarning"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"didReceiveMemoryWarning"];
        if (error_log) {
            if ([memoryWarning isEqualToString:@"YES"]) {
                error_log = [NSString stringWithFormat:@"内存不足警告\n%@",error_log];
            }
            [self sendErrorlogWithErrorlog:error_log];
        }
        
#pragma mark - 判断是否需要弹框版本更新
        if (![[AppDatas sharedDatas].userCode isEqualToString:@""]) {
            
            //CFShow((__bridge CFTypeRef)(infoDic));
            
            [self searchVersion];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSString*)deviceModelName
{
    @try {
       
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
        
        //iPhone 系列
        if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
        if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
        if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
        if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
        if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
        if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
        if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
        if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
        if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
        if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
        if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
        if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
        if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
        if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
        if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
        if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
        if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
        if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
        if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
        
        //iPod 系列
        if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
        if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
        if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
        if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
        if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
        
        //iPad 系列
        if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
        if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
        if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
        if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
        if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
        if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
        
        if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
        if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
        if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
        if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
        if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
        
        if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
        if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
        if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
        if ([deviceModel isEqualToString:@"i386"])         return @"模拟器Simulator";
        if ([deviceModel isEqualToString:@"x86_64"])       return @"模拟器Simulator";
        
        if ([deviceModel isEqualToString:@"iPad4,4"]
            ||[deviceModel isEqualToString:@"iPad4,5"]
            ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
        
        if ([deviceModel isEqualToString:@"iPad4,7"]
            ||[deviceModel isEqualToString:@"iPad4,8"]
            ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
        
        return deviceModel;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"入口类  AppDelegate" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
  
}


@end
