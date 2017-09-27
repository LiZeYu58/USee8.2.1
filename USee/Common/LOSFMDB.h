//
//  LOSFMDB.h
//  LOSBi
//
//  Created by gufeifei on 16/8/28.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOSFMDB : NSObject

+ (LOSFMDB *)sharedLOSFMDB;                        //数据库

- (BOOL)openDB:(NSString *)dbName;

- (BOOL)saveCacheWithRequestId:(NSString *)requestId
                 requestMethod:(NSString *)requestMethod
                   requestData:(NSString *)requestData
                  responseTime:(NSDate *)responseTime
                  responseData:(NSString *)responseData;

- (NSDictionary *)getCacheWithRequestMethod:(NSString *)requestMethod
                                requestData:(NSString *)requestData;

@end
