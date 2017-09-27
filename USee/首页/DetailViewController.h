//
//  DetailViewController.h
//  LOSBi
//
//  Created by JJT on 16/8/22.
//  Copyright © 2016年 L.O.S. All rights reserved.
//


/*
 
 
 二级页面ViewController（点击主页下半部分的tableViewCell跳转至此ViewController）
 */



#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MyView.h"


@class DetailViewController;
@protocol DetailViewControllerDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)detailView:(DetailViewController *)detailView orgCode:(NSString *)orgCode;

@end

@interface DetailViewController : BaseViewController

@property(assign, nonatomic) id<DetailViewControllerDelegate> delegate;



//二级界面总汇
@property (nonatomic ,strong) NSString * org_code;
@property (nonatomic ,strong) NSMutableArray *titleNameArr;
@property (nonatomic ,strong) NSString *titleName;
@property (nonatomic ,strong) NSMutableArray *orgCodeArr;

@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (nonatomic, strong) NSMutableArray <MyView *> *viewArray;
@property (nonatomic ,strong) NSMutableArray *dataSourceArr;
@property (nonatomic ,strong) NSMutableArray *titleCodeArr;
@property (nonatomic, strong) NSDictionary *titleDataDic;
@property (nonatomic, strong) NSDictionary *guanJianDataDic;
@property (nonatomic, strong) NSDictionary *QuYuDataDic;

//业绩看板专用
@property (nonatomic ,strong) NSString *drillTitleName;
@property (nonatomic ,strong) NSArray *drillTitleNameArr;
@property (nonatomic ,strong) NSArray *drillTitleCodeArr;
@property (nonatomic ,strong) NSString * drillOrgCode;



@end
