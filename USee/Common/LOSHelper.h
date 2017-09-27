//
//  LOSHelper.h
//  MKMassage
//
//  Created by gufeifei on 15/3/2.
//  Copyright (c) 2015年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, AuthorizationForApplication){
    AuthorizationForApplicationCamera = 0, //相机
    AuthorizationForApplicationPhotos = 1, //相册
    AuthorizationForApplicationContacts = 2, //联系人
};


@interface LOSHelper : NSObject
+ (NSString *)md5:(NSString *)str;
+ (BOOL)isValidText:(NSString *)inString;
+ (CGSize)sizeOfMaxSize:(CGSize)inMaxSize withScaleSize:(CGSize)inScaleSize;
//+ (UIView *)buttonViewWithFrame:(CGRect)inFrameRect logoImage:(NSString *)inImagePath title:(NSString *)inTitle isShowArrow:(BOOL)isShowArrow delegate:(id)inDelegate selector:(SEL)inSelector;
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSString *)getUniqueStrByUUID;
+ (NSString *)getUniqueStrByUUIDWithoutLine;
+ (UIImage *)imageWithColor:(UIColor *)color;

//停止的话直接这样就停止了
//[imageView.layer removeAllAnimates];
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView;

+ (NSString *)generateTradeNOWithSuffix:(NSString *)inSufFix;

+ (BOOL)isGetAuthorizationForApplication:(AuthorizationForApplication)app;

//+ (void)addLosLog:(NSString *)logString;
//+ (void)finishLosLogWithLogCode:(NSString *)inLogCode;
//+ (void)updateLosLogsForLastCount:(int)logsCount;
+ (NSString *)getCurrentDevice;

#pragma mark - encrypt password by huanghua

+ (NSString *)encryptPassowrdString:(NSString *)passwordString;

#pragma mark - date and string convert

+ (NSString *)stringFromDate:(NSDate *)inDate withFormatter:(NSString *)inFormatter;
+ (NSDate *)dateFromString:(NSString *)inString withFormatter:(NSString *)inFormatter;

#pragma mark - calculate size of string

//+ (CGSize)sizeForText:(NSString *)inText font:(UIFont *)inFont limitSize:(CGSize)inLimitSize;
//+ (CGSize)labelSizeForText:(NSString *)inText font:(UIFont *)inFont limitSize:(CGSize)inLimitSize;
//+ (CGSize)textViewSizeForText:(NSString *)inText font:(UIFont *)inFont limitSize:(CGSize)inLimitSize;
//+ (CGSize)sizeForContainer:(UIView *)inContainer limitSize:(CGSize)inLimitSize;

#pragma mark - 截屏
//截屏-window
+ (UIImage *)getSnapshotImage;
//截屏-view
+ (UIImage *)getSnapshotImageOfView:(UIView *)inView;

@end


@interface NSArray (SetSubViewsTag)

- (void)setSubViewsTag:(NSInteger)tag;

@end


@interface NSMutableDictionary (SetNilValue)

- (void)setNilPossibleObject:(id)anObject forKey:(id<NSCopying>)aKey;
- (void)setNullPossibleObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end


@interface UIButton (BgColorForState)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end

@interface NSDate (DateString)

- (NSString *)stringFromDateWithFormatyyyyMMdd;

@end


#pragma mark - GCD
static inline void GCD_GLOBAL(dispatch_block_t block)
{
//    dispatch_async(dispatch_queue_create("myThreadQueue1", DISPATCH_QUEUE_SERIAL), block);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

static inline void GCD_MAIN(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(),block);
}

static inline void GCD_AFTER(long afterSeconds, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * afterSeconds), queue, block);
}

static inline void GCD_AFTERMS(long afterMSeconds, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * afterMSeconds), queue, block);
}

static inline void GCD_MAIN_AFTERMS(long afterMSeconds, dispatch_block_t block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_MSEC * afterMSeconds), dispatch_get_main_queue(), block);
}




