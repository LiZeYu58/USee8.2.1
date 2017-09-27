//
//  LOSHelper.m
//  MKMassage
//
//  Created by gufeifei on 15/3/2.
//  Copyright (c) 2015年 L.O.S. All rights reserved.
//

#import "LOSHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <string.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
//#import "LosLog.h"
//#import "AppDocument.h"
//#import "User.h"
#include <sys/sysctl.h>
//#import "Reachability.h"
//#import "LogService.h"

@implementation LOSHelper

static NSMutableString *_logString;

// md5 16位加密 （大写）

+ (NSString *)md5:(NSString *)str {

  const char *cStr = [str UTF8String];
  
  unsigned char result[16];
  
  CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
  
  return [NSString
      stringWithFormat:
      
          @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
          
          result[0], result[1], result[2], result[3],
          
          result[4], result[5], result[6], result[7],
          
          result[8], result[9], result[10], result[11],
          
          result[12], result[13], result[14], result[15]
          
  ];
}

+ (BOOL)isValidText:(NSString *)inString {
  BOOL isValid = YES;
  NSString *validString =
      @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
  for (int i = 0; i < inString.length; i++) {
    NSRange range = [validString
        rangeOfString:[inString substringWithRange:NSMakeRange(i, 1)]];
    if (range.length == 0) {
      isValid = NO;
      break;
    }
  }
  return isValid;
}

+ (CGSize)sizeOfMaxSize:(CGSize)inMaxSize withScaleSize:(CGSize)inScaleSize {
  float width = inMaxSize.width;
  float height = inMaxSize.height;
  if (inMaxSize.width / inScaleSize.width >=
      inMaxSize.height / inScaleSize.height) {
    //宽大于等于高
    width = inScaleSize.width / inScaleSize.height * inMaxSize.height;
  } else {
    //宽小于高
    height = inScaleSize.height / inScaleSize.width * inMaxSize.width;
  }
  return CGSizeMake(width, height);
}
//
//+ (UIView *)buttonViewWithFrame:(CGRect)inFrameRect logoImage:(NSString
//*)inImagePath title:(NSString *)inTitle isShowArrow:(BOOL)isShowArrow
// delegate:(id)inDelegate selector:(SEL)inSelector {
//
//    UIView *view = [[UIView alloc] initWithFrame:inFrameRect];
//    view.backgroundColor = [UIColor whiteColor];
//    view.clipsToBounds = YES;
////    view.layer.shadowColor = [UIColor blackColor].CGColor;
////    view.layer.shadowOffset = CGSizeMake(0, 1);
////    view.layer.shadowOpacity = 0.1;
//
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1,
//    inFrameRect.size.width + 2, inFrameRect.size.height + 1)];
//    lineView.layer.borderColor = [UIColor colorWithRed:238/255.0
//    green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//    lineView.layer.borderWidth = 1.0;
//    [view addSubview:lineView];
//
//    float contentHeight = 30;
//    float contentSpace = 10;
//
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage
//    imageNamed:inImagePath]];
//    imageView.frame = CGRectMake(contentSpace, (inFrameRect.size.height -
//    contentHeight) / 2, contentHeight, contentHeight);
//    [view addSubview:imageView];
//
//    UILabel *label = [[UILabel alloc]
//    initWithFrame:CGRectMake(imageView.frame.origin.x +
//    imageView.frame.size.width + contentSpace, imageView.frame.origin.y,
//    inFrameRect.size.width - imageView.frame.origin.x -
//    imageView.frame.size.width - contentSpace - 50,
//    imageView.frame.size.height)];
//    label.text = inTitle;
//    label.textColor = kValue_TextGrayColor;
//    label.textAlignment = NSTextAlignmentLeft;
//    label.font = [UIFont systemFontOfSize:imageView.frame.size.height * 0.6];
//    [view addSubview:label];
//
//    if (isShowArrow) {
//
//        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage
//        imageNamed:@"列表右键头@3x"]];
//        arrowImage.frame = CGRectMake(inFrameRect.size.width - 10 -
//        contentSpace, (inFrameRect.size.height - 18) / 2, 10, 18);
//        [view addSubview:arrowImage];
//    }
//
//    UIControl *control = [[UIControl alloc] initWithFrame:view.bounds];
//    [control addTarget:inDelegate action:inSelector
//    forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:control];
//
//
//    return view;
//}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {

  // Create a graphics image context
  UIGraphicsBeginImageContext(newSize);
  
  // Tell the old image to draw in this new context, with the desired
  // new size
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  
  // Get the new image from the context
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // End the context
  UIGraphicsEndImageContext();
  
  // Return the new image.
  return newImage;
}

+ (NSString *)getUniqueStrByUUID {

  CFUUIDRef uuidObj = CFUUIDCreate(nil); // create a new UUID
  
  // get the string representation of the UUID
  
  NSString *uuidString =
      (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
      
  CFRelease(uuidObj);
  
  return uuidString;
}

+ (NSString *)getUniqueStrByUUIDWithoutLine {

  CFUUIDRef uuidObj = CFUUIDCreate(nil); // create a new UUID
  
  // get the string representation of the UUID
  
  NSString *uuidString =
      (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
      
  CFRelease(uuidObj);
  
  return
      [[uuidString stringByReplacingOccurrencesOfString:@"-"
                                             withString:@""] lowercaseString];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView {
  CABasicAnimation *animation =
      [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  
  //围绕Z轴旋转，垂直与屏幕
  animation.toValue = [NSValue
      valueWithCATransform3D:CATransform3DMakeRotation(M_PI / 2, 0.0, 0.0, 1)];
  animation.duration = 5;
  //旋转效果累计，先转180度，接着再旋转180度，从而实现360旋转
  animation.cumulative = YES;
  animation.repeatCount = 9999999999; //要想一直旋转，设置一个无穷大就得了
  
  //在图片边缘添加一个像素的透明区域，去图片锯齿
  //    CGRect imageRrect = CGRectMake(0, 0,imageView.frame.size.width,
  //    imageView.frame.size.height);
  //    UIGraphicsBeginImageContext(imageRrect.size);
  //    [imageView.image
  //    drawInRect:CGRectMake(1,1,imageView.frame.size.width-2,imageView.frame.size.height-2)];
  //    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  [imageView.layer addAnimation:animation forKey:nil];
  return imageView;
}
//停止的话直接这样就停止了
//[imageView.layer removeAllAnimates];

+ (NSString *)generateTradeNOWithSuffix:(NSString *)inSufFix {
  static int kNumber = 5;
  
  NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  NSMutableString *resultStr = [[NSMutableString alloc] init];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
  
  [resultStr appendString:[dateFormatter stringFromDate:[NSDate date]]];
  
  [resultStr appendString:@"-"];
  
  srand((unsigned)time(0)); // gffTemp 突然看到，未知玩意儿
  
  for (int i = 0; i < kNumber; i++) {
    unsigned index = rand() % [sourceStr length];
    NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
    [resultStr appendString:oneStr];
  }
  if (inSufFix) {
    [resultStr appendString:inSufFix];
  }
  return resultStr;
}

+ (BOOL)isGetAuthorizationForApplication:(AuthorizationForApplication)app {
  BOOL isGet = NO;
  
  if (app == AuthorizationForApplicationCamera) {
    //判断相机是否能够使用
    AVAuthorizationStatus status =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
      // authorized
      isGet = YES;
    } else if (status == AVAuthorizationStatusDenied) {
      // denied

      isGet = NO;
    } else if (status == AVAuthorizationStatusNotDetermined) {
      // not determined
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                               completionHandler:^(BOOL granted) {
                                 if (granted) {
                                 
                                 } else {
                                   return;
                                 }
                               }];
      isGet = YES;
    } else {
      //未知权限
      isGet = NO;
    }
  } else if (app == AuthorizationForApplicationPhotos) {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusAuthorized) {
      // authorized
      isGet = YES;
    } else if (status == ALAuthorizationStatusDenied) {
      // denied

      isGet = NO;
    } else if (status == ALAuthorizationStatusNotDetermined) {
      // not determined
      [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                               completionHandler:^(BOOL granted) {
                                 if (granted) {
                                 
                                 } else {
                                   return;
                                 }
                               }];
      isGet = YES;
    } else {
      //未知权限
      isGet = NO;
    }
  } else if (app == AuthorizationForApplicationContacts) {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusAuthorized) {
      // authorized
      isGet = YES;
    } else if (status == kABAuthorizationStatusDenied) {
      // denied

      isGet = NO;
    } else if (status == kABAuthorizationStatusNotDetermined) {
      // not determined
      ABAddressBookRef addressBookRef =
          ABAddressBookCreateWithOptions(NULL, nil);
      ABAddressBookRequestAccessWithCompletion(
          addressBookRef, ^(bool granted, CFErrorRef error){
          
          });
      CFRelease(addressBookRef);
      
      isGet = YES;
    } else {
      //未知权限
      isGet = NO;
    }
  }
  
  return isGet;
}

#pragma mark - about log
//
//+ (void)addLosLog:(NSString *)logString {
//    if (!_logString) {
//        _logString = [NSMutableString string];
//    }
//    [_logString appendString:logString];
//    [_logString appendString:@"\n"];
//}
//
//+ (void)finishLosLogWithLogCode:(NSString *)inLogCode {
//
//    //network
//    NSString *network = @"notConnect";
//    Reachability *reach = [Reachability
//    reachabilityWithHostName:@"baidu.com"];
//    if (reach.isReachable) {
//        network = @"connect";
//        if (reach.isReachableViaWiFi) {
//            network = @"wifi";
//        } else if (reach.isReachableViaWWAN) {
//            network = @"gprs";
//        }
//    }
//
//    LosLog *log = [[LosLog alloc] init];
//    log.LogCode = inLogCode;
//    log.Description = @"错误说明";//gffTemp
//    log.OS = [[UIDevice currentDevice] systemName];
//    log.UserID = [AppDocument sharedDocument].currentUserId;
//    log.ULogin = [AppDocument sharedDocument].currentULogin;
//    log.Device = [LOSHelper getCurrentDevice];
//    log.Network = network;
//    log.IsRoot = @"N";
//    log.OS_Version = [[UIDevice currentDevice] systemVersion];
//    log.BluetoothVersion = @"4.0";
//    log.AppVersion = [[LOSsqlite3 sharedSQLite] getAppVersion];
//    log.MfrsCode = [AppDocument sharedDocument].currentChairModelByte;
//    log.LogInfo = [NSString stringWithString:_logString];
//    log.Remark = @"";
//
//    _logString = nil;
//
//    [[LOSsqlite3 sharedSQLite] saveLosLog:log];
//
//    if (reach.isReachableViaWiFi) {
//        LogService *service = [[LogService alloc] init];
//        [service updateLosLogsArray:@[log] needCallBack:NO withDelegate:self];
//    }
//}
//
//+ (void)updateLosLogsForLastCount:(int)logsCount {
//    LogService *service = [[LogService alloc] init];
//    [service updateLosLogsArray:[[LOSsqlite3 sharedSQLite]
//    getLogsAtLast:logsCount] needCallBack:YES withDelegate:self];
//}

+ (NSString *)getCurrentDevice {
  int mib[2];
  size_t len;
  char *machine;
  
  mib[0] = CTL_HW;
  mib[1] = HW_MACHINE;
  sysctl(mib, 2, NULL, &len, NULL, 0);
  machine = malloc(len);
  sysctl(mib, 2, machine, &len, NULL, 0);
  
  NSString *platform =
      [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
  free(machine);
  
  if ([platform isEqualToString:@"iPhone1,1"])
    return @"iPhone 2G (A1203)";
  if ([platform isEqualToString:@"iPhone1,2"])
    return @"iPhone 3G (A1241/A1324)";
  if ([platform isEqualToString:@"iPhone2,1"])
    return @"iPhone 3GS (A1303/A1325)";
  if ([platform isEqualToString:@"iPhone3,1"])
    return @"iPhone 4 (A1332)";
  if ([platform isEqualToString:@"iPhone3,2"])
    return @"iPhone 4 (A1332)";
  if ([platform isEqualToString:@"iPhone3,3"])
    return @"iPhone 4 (A1349)";
  if ([platform isEqualToString:@"iPhone4,1"])
    return @"iPhone 4S (A1387/A1431)";
  if ([platform isEqualToString:@"iPhone5,1"])
    return @"iPhone 5 (A1428)";
  if ([platform isEqualToString:@"iPhone5,2"])
    return @"iPhone 5 (A1429/A1442)";
  if ([platform isEqualToString:@"iPhone5,3"])
    return @"iPhone 5c (A1456/A1532)";
  if ([platform isEqualToString:@"iPhone5,4"])
    return @"iPhone 5c (A1507/A1516/A1526/A1529)";
  if ([platform isEqualToString:@"iPhone6,1"])
    return @"iPhone 5s (A1453/A1533)";
  if ([platform isEqualToString:@"iPhone6,2"])
    return @"iPhone 5s (A1457/A1518/A1528/A1530)";
  if ([platform isEqualToString:@"iPhone7,1"])
    return @"iPhone 6 Plus (A1522/A1524)";
  if ([platform isEqualToString:@"iPhone7,2"])
    return @"iPhone 6 (A1549/A1586)";
    
  if ([platform isEqualToString:@"iPod1,1"])
    return @"iPod Touch 1G (A1213)";
  if ([platform isEqualToString:@"iPod2,1"])
    return @"iPod Touch 2G (A1288)";
  if ([platform isEqualToString:@"iPod3,1"])
    return @"iPod Touch 3G (A1318)";
  if ([platform isEqualToString:@"iPod4,1"])
    return @"iPod Touch 4G (A1367)";
  if ([platform isEqualToString:@"iPod5,1"])
    return @"iPod Touch 5G (A1421/A1509)";
    
  if ([platform isEqualToString:@"iPad1,1"])
    return @"iPad 1G (A1219/A1337)";
    
  if ([platform isEqualToString:@"iPad2,1"])
    return @"iPad 2 (A1395)";
  if ([platform isEqualToString:@"iPad2,2"])
    return @"iPad 2 (A1396)";
  if ([platform isEqualToString:@"iPad2,3"])
    return @"iPad 2 (A1397)";
  if ([platform isEqualToString:@"iPad2,4"])
    return @"iPad 2 (A1395+New Chip)";
  if ([platform isEqualToString:@"iPad2,5"])
    return @"iPad Mini 1G (A1432)";
  if ([platform isEqualToString:@"iPad2,6"])
    return @"iPad Mini 1G (A1454)";
  if ([platform isEqualToString:@"iPad2,7"])
    return @"iPad Mini 1G (A1455)";
    
  if ([platform isEqualToString:@"iPad3,1"])
    return @"iPad 3 (A1416)";
  if ([platform isEqualToString:@"iPad3,2"])
    return @"iPad 3 (A1403)";
  if ([platform isEqualToString:@"iPad3,3"])
    return @"iPad 3 (A1430)";
  if ([platform isEqualToString:@"iPad3,4"])
    return @"iPad 4 (A1458)";
  if ([platform isEqualToString:@"iPad3,5"])
    return @"iPad 4 (A1459)";
  if ([platform isEqualToString:@"iPad3,6"])
    return @"iPad 4 (A1460)";
    
  if ([platform isEqualToString:@"iPad4,1"])
    return @"iPad Air (A1474)";
  if ([platform isEqualToString:@"iPad4,2"])
    return @"iPad Air (A1475)";
  if ([platform isEqualToString:@"iPad4,3"])
    return @"iPad Air (A1476)";
  if ([platform isEqualToString:@"iPad4,4"])
    return @"iPad Mini 2G (A1489)";
  if ([platform isEqualToString:@"iPad4,5"])
    return @"iPad Mini 2G (A1490)";
  if ([platform isEqualToString:@"iPad4,6"])
    return @"iPad Mini 2G (A1491)";
    
  if ([platform isEqualToString:@"i386"])
    return @"iPhone Simulator";
  if ([platform isEqualToString:@"x86_64"])
    return @"iPhone Simulator";
  return platform;
}

#pragma mark - encrypt password by huanghua

+ (NSString *)encryptPassowrdString:(NSString *)passwordString {
  NSMutableString *encryptString = [[NSMutableString alloc] init];
  
  //加密
  @try {
    long length = passwordString.length;
    Byte bs[length];
    [passwordString getBytes:&bs
                   maxLength:passwordString.length
                  usedLength:Nil
                    encoding:NSASCIIStringEncoding
                     options:NSStringEncodingConversionAllowLossy
                       range:NSMakeRange(0, length)
              remainingRange:Nil];
    for (int i = 0; i < length; i++) {
      [encryptString appendString:[NSString stringWithFormat:@"%x", bs[i]]];
      
      //添加随机数,代表中间包含0-3个随机值
      int n = arc4random() % (3);
      [encryptString appendString:[NSString stringWithFormat:@"%d", n]];
      for (int j = 0; j < n; j++) {
        [encryptString
            appendString:[NSString
                             stringWithFormat:@"%x", arc4random() % (15)]];
      }
      //            DLogObject(encryptString);
    }
  } @catch (NSException *e) {
    // TODO Auto-generated catch block
    ;
  }
  
  return encryptString;
}

#pragma mark - date and string convert

+ (NSString *)stringFromDate:(NSDate *)inDate
               withFormatter:(NSString *)inFormatter {
  NSString *dateString = nil;
  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:inFormatter];
  [df setLocale:[NSLocale currentLocale]]; //[[NSLocale alloc]
  // initWithLocaleIdentifier:@"en_US"]
  [df setTimeZone:[NSTimeZone systemTimeZone]]; //[NSTimeZone
  // timeZoneForSecondsFromGMT:8 *
  // 3600]];
  dateString = [df stringFromDate:inDate];
  return dateString;
}

+ (NSDate *)dateFromString:(NSString *)inString
             withFormatter:(NSString *)inFormatter {
  NSDate *date = nil;
  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:inFormatter];
  [df setLocale:[NSLocale currentLocale]];
  [df setTimeZone:[NSTimeZone systemTimeZone]]; //[NSTimeZone
  // timeZoneForSecondsFromGMT:8 *
  // 3600]];
  date = [df dateFromString:inString];
  return date;
}

#pragma mark - calculate size of string

+ (CGSize)sizeForText:(NSString *)inText
                 font:(UIFont *)inFont
            limitSize:(CGSize)inLimitSize {
  NSDictionary *attribute = @{NSFontAttributeName : inFont};
  CGRect rect =
      [inText boundingRectWithSize:inLimitSize
                           options:NSStringDrawingTruncatesLastVisibleLine |
                                   NSStringDrawingUsesLineFragmentOrigin |
                                   NSStringDrawingUsesFontLeading
                        attributes:attribute
                           context:nil];
  return rect.size;
}


#pragma mark - 截屏
//截屏-window
+ (UIImage *)getSnapshotImage {
    UIView *window = [UIApplication sharedApplication].keyWindow;
    return [LOSHelper getSnapshotImageOfView:window];
}

//截屏-view
+ (UIImage *)getSnapshotImageOfView:(UIView *)inView {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(inView.frame), CGRectGetHeight(inView.frame)), NO, 2.0);
 
    [inView drawViewHierarchyInRect:CGRectMake(0, 0, CGRectGetWidth(inView.frame), CGRectGetHeight(inView.frame)) afterScreenUpdates:NO];
    UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshot;
}

@end

@implementation NSArray (SetSubViewsTag)

- (void)setSubViewsTag:(NSInteger)tag {
  for (id obj in self) {
    if ([obj isKindOfClass:[UIView class]]) {
      UIView *view = (UIView *)obj;
      view.tag = tag;
    }
  }
}

@end

@implementation NSMutableDictionary (SetNilValue)

- (void)setNilPossibleObject:(id)anObject forKey:(id<NSCopying>)aKey {
  if (anObject) {
    [self setObject:anObject forKey:aKey];
  } else {
    //        [self setObject:@"" forKey:aKey];
    }
}

- (void)setNullPossibleObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!anObject || anObject == [NSNull null]) {
        [self setObject:[NSNull null] forKey:aKey];
    }
}

@end


@implementation UIButton (BgColorForState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[LOSHelper imageWithColor:backgroundColor] forState:state];
}

@end

@implementation NSDate (DateString)

- (NSString *)stringFromDateWithFormatyyyyMMdd {
    return [LOSHelper stringFromDate:self withFormatter:@"yyyyMMdd"];
}

@end
