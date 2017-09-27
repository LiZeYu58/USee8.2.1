//
//  KLView.h
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    店铺排行详情-客流
 */



#import "MyView.h"

@interface KLView : MyView


@property (nonatomic ,strong) NSString * storeCode;

-(void)receiveKeLiuCode:(NSString *)orgCode;


- (void)keliu:(NSDate *)fromDate :(NSDate *)toDate;


@end
