//
//  HXView.h
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.




/*
 
    店铺排行详情-汇销
 */



#import "MyView.h"

@interface HXView : MyView

@property (nonatomic ,strong) NSString * storeCode;

-(void)receiveHuiXiaoCode:(NSString *)orgCode;

- (void)huixiao:(NSDate *)fromDate :(NSDate *)toDate;

@end
