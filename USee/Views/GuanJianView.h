//
//  GuanJianView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//






/*
 
    关键指标
 */



#import "MyView.h"

@protocol GuanJianViewDelegate <NSObject>

-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;

@end

@interface GuanJianView : MyView

//协议申明
@property (assign,nonatomic) id<GuanJianViewDelegate> delegate;

@property (nonatomic ,strong)  NSString * Code;


- (void)orgCodeToGuanJian:(NSString *)orgCode;

-(void)DetailVCTitleCodeToGuanJianView:(NSString *)orgCode;


- (void)keyRank:(NSDate *)fromDate :(NSDate *)toDate;

//- (Boolean)isWaitingAlertDisplay;
@end
