//
//  AppDatas.h
//  LOSBi
//
//  Created by gufeifei on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.


#import <Foundation/Foundation.h>

@interface AppDatas : NSObject

+ (AppDatas *)sharedDatas;            // post上传内容

+ (void) restSharedData; //重置用户信息

//社区所需用户信息
@property (nonatomic, strong) NSString *userPersonalInformation;

//程序各个页面所需全局变量
@property (nonatomic, strong) NSString *userCode;
@property (nonatomic, strong) NSDate *selectFromDate;
@property (nonatomic, strong) NSDate *selectToDate;

@property (nonatomic, strong) NSString *positionDate;
@property (nonatomic, strong) NSString *positionYear;
@property (nonatomic, strong) NSString *positionMonth;
//@property (nonatomic, assign) NSInteger remarkDateIndex;
@property (nonatomic, strong) NSString *piArray;


/*
 {
 "brand_code" = B0114;
 "brand_iamge" = "http//:";
 "brand_name" = "\U5c39\U9ed8";
 "org_sn" = 1;
 "org_value" = 0;
 }
 */

@property (nonatomic, strong) NSDictionary *currentBrandDic;
@property (nonatomic, strong) NSArray <NSDictionary *>*BrandDicArray;

@end
