//
//  CommonTools.m
//  USee
//
//  Created by 李泽雨 on 2017/3/7.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import "CommonTools.h"

@implementation CommonTools

#pragma mark 收集崩溃日志
+(void)collectErrolLogWriteFile:(NSString *)errolExprion{
   
    if (errolExprion.length == 0) {
        
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *phone_num = [defaults objectForKey:@"phone_num"];
    NSString * DeviceModel      = [defaults objectForKey:@"iphoneModelLog"];
    NSDictionary *infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = infoDict[@"CFBundleShortVersionString"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 设置日期格式，以字符串表示的日期形式的格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 格式化日期，GMT 时间，NSDate 转 NSString
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    
    NSString *errorStr = [NSString stringWithFormat:@"tryCatch收集  系统版本:%.2f,设备型号:%@,设备名称:%@,时间:%@,\n导致崩溃的类名%@\n%@,%@,%@,%@\nreason:\n%@",SystemVersion,DeviceModel,DeviceName,str,[defaults objectForKey:@"crashTheClassName"],iShowUUIDString,SystemName,phone_num,versionNum,errolExprion];
    
    NSMutableDictionary *errorLogDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:errorStr,@"error_log", nil];
    [CommonTools writeFile:errorLogDic toFile:@"errorLogData.plist"];
}

#pragma mark 写入文件
+(void)writeFile:(NSMutableDictionary *)dic toFile:(NSString *)str{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *plistPath = [path stringByAppendingPathComponent:str];
    [dic writeToFile:plistPath atomically:YES];
}

#pragma mark 读取文件
+(NSMutableDictionary *)readFile:(NSString *)str{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = paths[0];
    NSString *plistPath=[path stringByAppendingPathComponent: str];
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    
    return  dic;
}

#pragma mark 删除文件
+(void)removeFile:(NSString *)str{
    
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *removePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:str];
    [fileMger removeItemAtPath:removePath error:nil];
    
}

#pragma mark 判断是否有网络
+(BOOL)isConnectionAvailable:(id)showView{
    BOOL isExistenceNetwork=YES;
    //判断跟指定网址是否联通
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork=NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork=YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork=YES;
            break;
    }
    return isExistenceNetwork;
}

#pragma mark  字典转json格式
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:nil error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma 正则匹配url
+ (BOOL)checkUrlSrting : (NSString *) url
{
    NSString *pattern = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pattern];
    BOOL isMatch = [pred evaluateWithObject:url];
    
    return isMatch;
}

#pragma mark 字符串宽度
+(CGFloat)huoQuZiFuString:(NSString *)string  font:(NSInteger)font
{
  
   CGSize  size =  [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 26) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    
//    CGRect rect = [string boundingRectWithSize:CGSizeMake(120, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return size.width;
}



+(NSMutableArray *)rgbColorArray{
   NSMutableArray * lineBarcolors = [[NSMutableArray alloc] init];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];

    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];

    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];

    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];

    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];

    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];

    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF69B4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6347]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF4500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF3E96]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAFAD2]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFAEBD7]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFA8072]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF5DEB3]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEED1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEDC82]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CED1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEC591]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEAEEE]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF4A460]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xF08080]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xF0E68C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEEE00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE9BF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xEEE685]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFACD]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF68F]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFF5EE]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEFDB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFFF00]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEC8B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFEBCD]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4E1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE4B5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFE1FF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDEAD]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFDAB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD700]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFD39B]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC1C1]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC125]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFC0CB]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFBBFF]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB90F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB6C1]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFB5C5]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFAEB9]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA54F]];
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFFA07A]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8C69]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF83FA]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF82AB]];
    
    
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF8247]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF7256]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6EB4]];
    [lineBarcolors addObject:[UIColor colorWithHex:0xFF6A6A]];
   
    return lineBarcolors;
}
@end
