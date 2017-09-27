//
//  FourDetailViewController.h
//  LOSBi
//
//  Created by JJT on 16/9/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//


/*
 
 
     商品排行详情页（点击商品排行TableViewcell跳转至此）
 */




#import "BaseViewController.h"
//#import "Charts.h"

@protocol  goodsViewControllDelegate;

@interface FourDetailViewController : BaseViewController

@property (nonatomic , assign) id<goodsViewControllDelegate> delegate;

@property (nonatomic,strong) NSString *productCode;        //商品排行的详情
@property (nonatomic ,strong) NSMutableArray *array1;
@property (nonatomic ,strong) NSMutableArray *array2;
@property (nonatomic,strong)NSMutableArray *chartArray;


@property (nonatomic ,strong) NSDictionary *GoodsArchivesDataDic;
@property (nonatomic ,strong) NSDictionary *StoreRankingDataDic;
@property (nonatomic ,strong) NSDictionary *CycleCurveDataDic;


@property (nonatomic,strong)NSMutableArray *dataSourceArr;
//@property (nonatomic, strong) LineChartView *chartView;
@property (nonatomic,strong) UIImage *productImg;        //商品排行的详情
@property (nonatomic,strong) NSString *productName;        //商品排行的详情
@property (nonatomic, strong) NSString *imgPureURL;

@end

//协议
@protocol goodsViewControllDelegate <NSObject>

- (void)goodsrefreshSPView;


@end
