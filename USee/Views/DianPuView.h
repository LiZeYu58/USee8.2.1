//
//  DianPuView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    店铺排行
 */




#import "MyView.h"

@class DianPuView;
@protocol DianPuViewDelegate <NSObject>

-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;

@end


@interface DianPuView : MyView

-(void)requestDatasWithOrgCode:(NSString *)str;

//从店铺排行详情返回后刷新页面
@property(copy) void (^refreshBlock)(NSString * dateStr,NSString *code);
-(void)refreshViewAfterPopFromStoreDetailVC;

//协议申明
@property (assign,nonatomic) id<DianPuViewDelegate> delegate;


@property (assign,nonatomic) NSString *temp; // 传过来的org——code



- (void)orgCodeToDianPu:(NSString *)orgCode;


-(void)brandTableViewToDianPu:(NSString *)orgCode;


- (void)storeRank:(NSDate *)fromDate :(NSDate *)toDate;

- (void)selectedLeftSideBar:(NSDictionary *)dict;

//- (Boolean)isWaitingAlertDisplay;

@end
