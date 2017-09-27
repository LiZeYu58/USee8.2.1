//
//  DaoGouView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    导购排行页面
 */



#import "MyView.h"

@protocol shoppingViewDelegate <NSObject>

-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString;

@end


@interface DaoGouView : MyView

@property (nonatomic ,strong) UITextField *tfText;

//协议申明
@property (assign,nonatomic) id<shoppingViewDelegate> delegate;


- (void)orgCodeToQuYu:(NSString *)orgCoded :(NSString *)orgNamed;


- (void)DetailVCTitleCodeToGuideSaleClick:(NSString *)OrgCode;


- (void)guideSaleRank:(NSDate *)fromDate :(NSDate *)toDate;




@end
