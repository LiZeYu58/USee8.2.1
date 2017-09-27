//
//  LeftSortsViewController.h
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//




/*
 
    侧滑栏封装（本程序引用）
*/



#import <UIKit/UIKit.h>
#import "SlideView.h"

//@class LeftSortsViewController;

@protocol LeftSortsViewControllerDelegate <NSObject>

@optional

- (void)selectedSecondLeftSideBar:(NSDictionary *)dict viewIndex:(NSInteger)viewIndex;
- (void)selectedThiredLeftSideBar:(NSDictionary *)dict viewIndex:(NSInteger)viewIndex;

@end

@interface LeftSortsViewController : UIViewController
@property (nonatomic,strong) UITableView *tableview;              //侧滑的vc
@property (nonatomic,strong) UIView *goodsRankView;
@property (nonatomic,strong) UIView *keyPointView;
@property (nonatomic,strong) UIView *storeRankView;

@property (nonatomic,strong) UIView *goodsView;

@property (nonatomic,strong) UIView *guideView;
@property (assign, nonatomic) id<LeftSortsViewControllerDelegate> delegate;
@property (nonatomic,strong) SlideView *slide;  //店铺排行
@property (nonatomic,strong) SlideView *slide1; //商品排行
@property (nonatomic,strong) SlideView *slide2; //关键指标
@property (nonatomic,strong) SlideView *slide3; //导购排行
@property (nonatomic,strong) SlideView *slide4; //商品

@end

