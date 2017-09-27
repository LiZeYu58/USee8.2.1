//
//  AppDatas.m
//  LOSBi
//
//  Created by gufeifei on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.


#import "AppDatas.h"
#import "NSDate+Escort.h"

@implementation AppDatas

static AppDatas *sharedDatas;

#pragma mark - 初始化并获取默认值
+ (AppDatas *) sharedDatas {
    if (sharedDatas == nil) {
        sharedDatas = [[AppDatas alloc] init];
        
//        sharedDatas.userCode = @"18321828475";
        sharedDatas.piArray = @"";
        sharedDatas.selectFromDate = [NSDate date];
        sharedDatas.selectToDate = sharedDatas.selectFromDate;
        sharedDatas.positionDate = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate day]];
        sharedDatas.positionMonth = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate month]];
        sharedDatas.positionYear = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate year]];
        
    }
    return sharedDatas;
}

#pragma mark - 重置变量
+ (void ) restSharedData {

        sharedDatas = [[AppDatas alloc] init];
        
        sharedDatas.userCode = @"";
        sharedDatas.piArray = @"";
        sharedDatas.selectFromDate = [NSDate date];
        sharedDatas.selectToDate = sharedDatas.selectFromDate;
        sharedDatas.positionDate = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate day]];
        sharedDatas.positionMonth = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate month]];
        sharedDatas.positionYear = [NSString stringWithFormat:@"%ld", (long)[sharedDatas.selectFromDate year]];

}


@end
