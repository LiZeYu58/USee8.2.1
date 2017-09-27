//
//  YeJiView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    业绩看板
 */



#import "MyView.h"

@protocol YeJiViewDelegate <NSObject>

-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;


@end

@interface YeJiView : MyView

@property (assign,nonatomic) id<YeJiViewDelegate> delegate;

- (void)orgCodeToYeJi:(NSString *)orgCode;

- (void)brandToYeJi:(NSString *)orgCode;

- (void)renjia1:(NSDate *)fromDate :(NSDate *)toDate;

//- (Boolean)isWaitingAlertDisplay;

@end
