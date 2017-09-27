//
//  QuYuView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    区域看板
 */



#import "MyView.h"

@protocol QuYuViewDelegate <NSObject>

-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;

@end

@interface QuYuView : MyView

//协议申明
@property (assign,nonatomic) id<QuYuViewDelegate> delegate;

@property (nonatomic ,strong)  NSString * Code;

- (void)orgCodeToQuYu:(NSString *)orgCode;

-(void)DetailVCTitleCodeToQuYuView:(NSString *)orgCode;

- (void)regionRank:(NSDate *)fromDate :(NSDate *)toDate;

@end
