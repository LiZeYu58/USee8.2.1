//
//  LOSFMDB.m
//  LOSBi
//
//  Created by gufeifei on 16/8/28.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "LOSFMDB.h"
#import "FMDB.h"

@interface LOSFMDB () {
    FMDatabaseQueue *dbq;
}

@end

@implementation LOSFMDB

static LOSFMDB *sharedLOSFMDB;
static NSDateFormatter *_dateFormatter;

+ (LOSFMDB *)sharedLOSFMDB {
    if (sharedLOSFMDB == nil) {
        sharedLOSFMDB = [[LOSFMDB alloc] init];
        
        _dateFormatter = [NSDateFormatter new];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter
         setTimeZone:[NSTimeZone systemTimeZone]]; //[NSTimeZone
        //timeZoneForSecondsFromGMT:8
        //* 3600]];
    }
    
    return sharedLOSFMDB;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self openDB:@"Cache.db"];
    }
    return self;
}

- (BOOL)openDB:(NSString *)dbName {
    
    if (dbq) {
        [dbq close];
        dbq = nil;
    }
    
    if (![dbName hasSuffix:@".db"]) {
        dbName = [dbName stringByAppendingString:@".db"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *dbPath = [NSString stringWithFormat:@"%@/%@", documentDirectory, dbName];
    DLog(@"db path:%@", dbPath);
    
    BOOL isDbExist = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
    
    dbq = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (dbq) {
        if (!isDbExist) {
            [self initDB];
        } else {

        }
        return YES;
    } else {
        DAlert(@"打开数据库失败");
        return NO;
    }
}

- (void)initDB {
    
    BOOL isSuccess = YES;
    
    isSuccess &= [self initCacheTable];
//
//    isSuccess &= [self initUserTable];
//    
//    isSuccess &= [self initAppInfoTable];
//    
//    isSuccess &= [self initTipTable];
//    
//    isSuccess &= [self initTipToUserStatusTable];
//    
//    isSuccess &= [self initTipExecTable];
//    
//    isSuccess &= [self initTipReplyTable];
//    
//    isSuccess &= [self initNotificationTable];
//    
//    isSuccess &= [self initActivityTable];
//    
//    isSuccess &= [self initApplicationTable];
//    
//    isSuccess &= [self initInvitedPhoneNumberTable];
//    
//    isSuccess &= [self initUploadedPhoneNumberTable];
//    
//    isSuccess &= [self initItemToAuthToOrgTable];
//    
//    isSuccess &= [self initDBVersionTableWithVersionString:kValue_CurrentDbVersion];
    
    if (!isSuccess) {
        LOSAlert(@"本地数据库初始化失败");
    }
}

- (BOOL)initCacheTable {
    __block BOOL isSuccess = NO;
    [dbq inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Cache (localId INTEGER PRIMARY KEY AUTOINCREMENT, requestId text, requestMethod text, requestData text, responseTime datetime, responseData text);"];
    }];
    return isSuccess;
}

- (BOOL)saveCacheWithRequestId:(NSString *)requestId
                 requestMethod:(NSString *)requestMethod
                   requestData:(NSString *)requestData
                  responseTime:(NSDate *)responseTime
                  responseData:(NSString *)responseData {
    __block BOOL isSuccess = NO;
    [dbq inDatabase:^(FMDatabase *db) {
        isSuccess = [db executeUpdate:@"INSERT INTO Cache (requestId, requestMethod, requestData, responseTime, responseData) VALUES(?, ?, ?, ?, ?);", requestId, requestMethod, requestData, responseTime, responseData];
    }];
    return isSuccess;
}

- (NSDictionary *)getCacheWithRequestMethod:(NSString *)requestMethod
                                requestData:(NSString *)requestData {

    __block NSDictionary *dic = [NSDictionary dictionary];
    [dbq inDatabase:^(FMDatabase *fmdb) {
        FMResultSet *resultSet = [fmdb executeQuery:@"SELECT responseTime, responseData FROM Cache WHERE requestMethod = ? AND requestData = ? ORDER BY responseTime DESC LIMIT 1;", requestMethod, requestData];
        if (!resultSet) {

        } else {
            if ([resultSet next]) {
                dic = [resultSet resultDictionary];
            }
            [resultSet close];
        }
    }];
    return dic;
}

@end
