//
//  SPView.h
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    店铺排行详情 - 商品页面
 */




#import "MyView.h"

@interface SPView : MyView

@property (nonatomic ,strong) NSString * storeCode;
@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic ,strong)NSDictionary *secondDic;

@property (nonatomic ,strong) UITextField *tfText;

//数组
@property (nonatomic ,strong) NSMutableArray *dataSourceArr;
@property (nonatomic ,strong) NSMutableArray *sortTitleNameArray;
@property (nonatomic ,strong) NSMutableArray *orderTypesArray;
@property (nonatomic ,strong) NSMutableArray *piCodeArray;

@property (nonatomic ,strong) NSString *order_arrayStr;
@property (nonatomic ,strong) NSString *orderPir;

@property (nonatomic,strong) NSString *pia_code;

-(void)receiveGoodsCode:(NSString *)orgCode WithTitleCode:(NSString *)titleCode;

- (void)selectedLeftSideBar:(NSDictionary *)dict;

- (void)goods:(NSDate *)fromDate :(NSDate *)toDate;


-(void)shangpin:(NSString *)piacode :(NSString *)slideIndex;

@end
