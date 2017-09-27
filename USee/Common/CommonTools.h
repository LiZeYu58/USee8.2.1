//
//  CommonTools.h
//  USee
//
//  Created by 李泽雨 on 2017/3/7.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonTools : NSObject

#pragma mark 收集崩溃日志
+(void)collectErrolLogWriteFile:(NSString *)errolExprion;

#pragma mark 写入文件
+(void)writeFile:(NSMutableDictionary *)dic toFile:(NSString *)str;

#pragma mark  读取文件
+(NSMutableDictionary *)readFile:(NSString *)str;
#pragma mark 删除文件
+(void)removeFile:(NSString *)str;

#pragma mark  字典转json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

#pragma 正则匹配url
+ (BOOL)checkUrlSrting : (NSString *) url;


+(BOOL)isConnectionAvailable:(id)showView;

#pragma mark 获取字符串宽度
+(CGFloat)huoQuZiFuString:(NSString *)string  font:(NSInteger)font;

+(NSMutableArray *)rgbColorArray;

@end
