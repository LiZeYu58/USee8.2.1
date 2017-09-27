//
//  NdUncaughtExceptionHandler.m
//  iShow
//
//  Created by zhang on 15/11/2.
//  Copyright © 2015年 Bizvane. All rights reserved.
//

#import "NdUncaughtExceptionHandler.h"
#import "sys/utsname.h"

NSString *applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception) {
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *exceptionArr = [exception callStackSymbols];
    /*
     有关错误日志分析的方法参照
     http://blog.sina.com.cn/s/blog_950f3dd90102wvcx.html
     */
    
    NSString *reason = @"";
    if (exception.reason) {
        reason  = [exception reason];
    }
    NSString *name = @"";
    if (exception.name) {
        name = [exception name];
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *DeviceModel;
    @try {
        DeviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    } @catch (NSException *exception) {
        DeviceModel = @"";
    }
    
    NSString *phone_num = [defaults objectForKey:@"phone_num"];
    DeviceModel      = [defaults objectForKey:@"iphoneModelLog"];
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = infoDict[@"CFBundleShortVersionString"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 设置日期格式，以字符串表示的日期形式的格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 格式化日期，GMT 时间，NSDate 转 NSString
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    
    NSString *errorStr = [NSString stringWithFormat:@"系统版本:%.2f,设备型号:%@,设备名称:%@,时间:%@,\n导致崩溃的地方：%@\n%@,%@,%@,%@\nname:\n%@\nreason:\n%@\n%@",SystemVersion,DeviceModel,DeviceName,str,[defaults objectForKey:@"crashTheClassName"],iShowUUIDString,SystemName,phone_num,versionNum,name,reason,exceptionArr];
    
    NSMutableDictionary *errorLogDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:errorStr,@"error_log", nil];
    [CommonTools writeFile:errorLogDic toFile:@"errorLogData.plist"];
    
    
//    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
//    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
}


@implementation NdUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

@end
