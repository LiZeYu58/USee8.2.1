//
//  ShangPinView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    商品排行
 */



#import "MyView.h"

@protocol ShangPinViewDelegate <NSObject>


-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;

@end

@interface ShangPinView : MyView

//协议申明
@property (assign,nonatomic) id<ShangPinViewDelegate> delegate;

-(void)receiveTitleCode:(NSString *)orgCode;

- (void)orgCodeToShsngPin:(NSString *)orgCode;

- (void)goodsRank:(NSDate *)fromDate :(NSDate *)toDate;

- (void)selectedLeftSideBar:(NSDictionary *)dict;

//跳转至详情之前
@property (copy) void (^RefreshSPBlock)(NSString *dateStr);
-(void)refreshSPViewAfterPop;

//- (Boolean)isWaitingAlertDisplay;

@end
