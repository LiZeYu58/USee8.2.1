//
//  YJView.h
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    店铺排行详情 - 业绩
 */



#import "MyView.h"

@interface YJView : MyView


@property (nonatomic ,strong) NSString * storeCode;

-(void)receiveYeJiCode:(NSString *)orgCode;

- (void)renjia1:(NSDate *)fromDate :(NSDate *)toDate;

@end
