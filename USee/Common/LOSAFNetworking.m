//
//  LOSAFNetworking.m
//  LOSBi
//
//  Created by gufeifei on 16/8/25.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "LOSAFNetworking.h"
#import "LOSFMDB.h"
#import "LOSHelper.h"


#pragma mark - json helper


@interface NSString(JSONCategories)
- (id)jsonValue;
@end

@implementation NSString(JSONCategories)
- (id)jsonValue {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error != nil) {
        return nil;
    } else {
        return result;
    }
}
@end


@interface NSObject (JSONCategories)
- (NSData *)jsonData;
- (NSString *)jsonString;
@end

@implementation NSObject (JSONCategories)
- (NSData *)jsonData {
    NSError *error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self
                                                options:NSJSONWritingPrettyPrinted error:&error];
    if (error != nil) {
        return nil;
    } else {
        return result;
    }
}
- (NSString *)jsonString {
    return [[NSString alloc] initWithData:self.jsonData encoding:NSUTF8StringEncoding];
}
@end



#pragma mark - LOSAFNetworking

@interface LOSAFNetworking () {
//    AFHTTPRequestOperationManager *_manager;
    AFHTTPSessionManager *_manager;
    NSMutableDictionary *_postDic;
    
    long long requestId;

}

@end

static long long requestCountId = 0;
static long cacheTimeSecond = 9999999;//5 * 60;//缓存5分钟
#pragma mark  测试环境
static  NSString * serviceUrl = @"http://api.dev.bizvane.com/app/usee";

#pragma mark  正式环境
//static NSString *serviceUrl = @"https://api.app.bizvane.com/app/usee/";

@implementation LOSAFNetworking

- (instancetype)init {
    self = [super init];
    if (self) {
  //      _manager = [AFHTTPRequestOperationManager manager];
       // [_manager.operationQueue cancelAllOperations];
        @try {
            
            _manager = nil;
            _postDic = nil;
            
            _manager = [AFHTTPSessionManager manager];
            _manager.requestSerializer = [AFJSONRequestSerializer serializer];
            _manager.requestSerializer.timeoutInterval = 15;
            
            _postDic = [NSMutableDictionary dictionary];
        } @catch (NSException *exception) {
            [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        }
      
        
//        [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [_manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//        
//        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    }
    return self;
}

- (void)        POST:(NSString *)method
      dataParameters:(NSDictionary *)parameters
             success:(void (^)(NSDictionary *))success
//             failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure {
             failure:(void (^)(NSError *))failure {
    @try {
        requestId++;
        
        requestCountId = requestId;
        
        //自增长id
        [_postDic setObject:[NSNumber numberWithLongLong:requestCountId].stringValue forKey:@"id"];
        
        //传入参数
        [_postDic setObject:method forKey:@"method"];
        [_postDic setObject:parameters forKey:@"data"];
        
        //自动计算参数
        [_postDic setObject:@"UAnDEwzPtRLU1uJom6QRD7cGRgW8SJoz" forKey:@"access_key"];
        [_postDic setObject:@"41bfa82252f31bef46ccffca4ec22b5e" forKey:@"sign"];
        [_postDic setObject:@"1469257687" forKey:@"timestamp"];
        
        [_manager POST:serviceUrl
            parameters:_postDic
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   
                   @try {
                       
                       NSDate *responseTime = [NSDate date];
                       NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                       [mDic setObject:[self stringFromDate:responseTime] forKey:@"responseTime"];
                       
                       success((NSDictionary *)mDic);
                       
                       if ([mDic[@"status"] isEqualToString:@"success"]) {
                           //写入缓存
                           //                       [[LOSFMDB sharedLOSFMDB] saveCacheWithRequestId:[NSNumber numberWithLongLong:requestCountId].stringValue
                           //                                                         requestMethod:method
                           //                                                           requestData:parameters.jsonString
                           //                                                          responseTime:responseTime
                           //                                                          responseData:mDic.jsonString];
                       }
                       
                   } @catch (NSException *exception) {
                       
                       [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
                   } @finally {
                       
                      
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   failure(error);
               }];
        
    } @catch (NSException *exception) {
        
    }
    
//    [_manager POST:serviceUrl
//        parameters:_postDic
//           success:^(AFHTTPRequestOperation *operation, id responseObject) {
//               NSDate *responseTime = [NSDate date];
//               NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
//               [mDic setObject:[self stringFromDate:responseTime] forKey:@"responseTime"];
//               success((NSDictionary *)mDic);
//               
//               if ([mDic[@"status"] isEqualToString:@"success"]) {
//                   //写入缓存
//                   [[LOSFMDB sharedLOSFMDB] saveCacheWithRequestId:[NSNumber numberWithLongLong:requestCountId].stringValue
//                                                     requestMethod:method
//                                                       requestData:parameters.jsonString
//                                                      responseTime:responseTime
//                                                      responseData:mDic.jsonString];
//               }
//           }
//           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//               failure(operation, error);
//           }];
}

- (void)                    POST:(NSString *)method
                  dataParameters:(NSDictionary *)parameters
                       withCache:(BOOL)isUseCache
                         success:(void (^)(NSDictionary *responseDic))success
//                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
                         failure:(void (^)(NSError *error))failure {
//    if (isUseCache) {
//        //使用缓存
//        NSDictionary *cacheDic = [[LOSFMDB sharedLOSFMDB] getCacheWithRequestMethod:method requestData:parameters.jsonString];
//        NSDate *date = [self dateFromString:cacheDic[@"responseTime"]];
//        if (date && -date.timeIntervalSinceNow < cacheTimeSecond) {
//            //有缓存，直接返回樊村
//            success([cacheDic[@"responseData"] jsonValue]);
//            return;
//        } else {
//            //没有可用缓存
//        }
//    }
    @try {
        
         [self POST:method dataParameters:parameters success:success failure:failure];
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}

- (NSDate *)dateFromString:(NSString *)inString {
    
    @try {
        
        NSDate *date = nil;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setLocale:[NSLocale currentLocale]];
        [df setTimeZone:[NSTimeZone systemTimeZone]];
        date = [df dateFromString:inString];
        return date;

    } @catch (NSException *exception) {
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

- (NSString *)stringFromDate:(NSDate *)inDate {
    
    @try {
     
        NSString *dateString = nil;
        NSDateFormatter *df = [NSDateFormatter new];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [df setLocale:[NSLocale currentLocale]]; //[[NSLocale alloc]
        [df setTimeZone:[NSTimeZone systemTimeZone]]; //[NSTimeZone
        dateString = [df stringFromDate:inDate];
        return dateString;
        
    } @catch (NSException *exception) {
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

@end


