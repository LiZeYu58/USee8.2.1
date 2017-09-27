//
//  QuYuView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //区域看板（二级页面）



#import "QuYuView.h"
#import "BigBtnView.h"
#import "LOSHelper.h"
//#import "DayAxisValueFormatter.h"
#import "TableViewBarCells.h"
#import "QuYuCollectionViewCell.h"
#import "AppDatas.h"
#import "LOSAFNetworking.h"
#import "AnimationView.h"
#import "MBProgressHUD.h"
//ChartViewDelegate,ChartViewDelegate,
@interface QuYuView ()<BigAndTimeViewDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, MBProgressHUDDelegate>

{
    NSInteger _bigSelectIndex;
    NSInteger _smailSelectIndex;
    
    NSInteger _subheadBarIndex;
    
    UIView * amountView;
    UILabel * nameLab;
    UILabel * numLab;
  
    UICollectionView * collectView;
    BigAndTimeView * _bigview;
    
    UIButton * btn;
    NSString * PirCode1;
    
    NSString * _valueForBtnString;
    NSString * _UnitForBtnString;
    
    NSString * _regionDrill_typeString;
    
    NSMutableArray * colors;
    NSMutableArray * lineBarcolors;
    NSInteger cellSelect;
    AnimationView * animationView;
    UIScrollView * scrollView1;
    UIButton * amountBtn;
    
    UIButton * _regionDrillUpButton;
    UIButton * _regionDrillDownButton;
    
    NSInteger firstRequest1;
    NSInteger firstRequest2;
    NSInteger firstRequest3;
    NSInteger firstRequest4;
    
    NSInteger _regionInteger;
    
    MBProgressHUD *HUD;
    UIView  * line;
    
    NSMutableArray* _regionTitArray;
    NSMutableArray*  _regionCodeArray;
    
    BOOL SsuccessRequest;
    
    BOOL FsuccessRequest;
    
    BOOL _firsrtRequestBool;
}

@property (nonatomic , strong) UIScrollView *ScrollView;
@property (nonatomic , strong) UIButton * rightBtn;
@property (nonatomic , strong) UIButton * lefttBtn;
@property (nonatomic , strong) NSMutableArray * array;
@property (nonatomic , strong) NSMutableArray * PISelectbarunitArray;
@property (nonatomic , strong) NSMutableArray * PISelectbarcodeArray;
@property (nonatomic , strong) NSMutableArray * PISelectbarnameArray;
@property (nonatomic , strong) NSMutableArray * orgNameArray;
@property (nonatomic , strong) NSMutableArray * valueArray;
@property (nonatomic , strong) NSMutableArray * orgCodeArray;
@property (nonatomic , strong) NSMutableArray * SSorgNameArray;
@property (nonatomic , strong) NSMutableArray * SSvalueArray;
@property (nonatomic, strong) NSDictionary *PISelectbardataDic;
@property (nonatomic, strong) NSDictionary *FSScreendataDic;
@property (nonatomic, strong) NSDictionary *SScreendataDic;
//@property (nonatomic, strong) PieChartView *pieChartView;
@property (nonatomic, strong) UITableView *tabView;

@end

@implementation QuYuView

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        firstRequest1 = 1;
        firstRequest2 = 1;
        firstRequest3 = 1;
        firstRequest4 = 1;
        
        _regionInteger = 1;
        
        _subheadBarIndex = 0;
        
        _regionDrill_typeString = @"0";
        
        lineBarcolors = nil;
        colors = nil;
        
        lineBarcolors = [[NSMutableArray alloc] initWithArray:[CommonTools rgbColorArray]];
        colors = [[NSMutableArray alloc] initWithArray:lineBarcolors];
        
        self.PISelectbarunitArray = nil;
        
        self.PISelectbarunitArray = [NSMutableArray new];
        
         self.PISelectbarcodeArray = nil;
        
        self.PISelectbarcodeArray = [NSMutableArray new];
       
        self.PISelectbarnameArray = nil;
        
        self.PISelectbarnameArray = [NSMutableArray new];

        cellSelect = -1;
        _bigSelectIndex = 1;
        _smailSelectIndex = 0;
        
        _firsrtRequestBool = NO;
       
       
        
    }
    
    return self;
}

//通知方法
-(void)DetailVCTitleCodeToQuYuView:(NSString *)orgCode{
    
    @try {
        
        _regionInteger = 1;

        _Code = orgCode;
        [self refreshLeftSidebarDatasWithCache:YES WithCode:_Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

//通知方法
- (void)regionRank:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        [self refreshLeftSidebarDatasWithCache:YES WithCode:_Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 点击底部bar请求
- (void)orgCodeToQuYu:(NSString *)orgCode{
    
    @try {
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        _regionInteger = 1;
        _Code = orgCode;
        //LeftSidebar
        [self refreshLeftSidebarDatasWithCache:YES WithCode:_Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 区域看板页面 点击扇形块接口请求
- (void)refreshLeftSidebarDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)Code{
    
    @try {
        
        [self refreshLeftSidebarFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                                  toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                                  withCache:isUseCache
                                   WithCode:Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)refreshLeftSidebarFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)org_code {
    
    @try {
        
        //  [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.PISelectBar"
                             dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                             [AppDatas sharedDatas].userCode, @"user_code",
                                             
                                             nil]
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                    dispatch_async(dispatch_get_main_queue(), ^{
                                            
                    if ([responseDic[@"status"] isEqualToString:@"success"]) {
                    
                    [[HUDHelper getInstance] hideHUD];
                                                
                    self.PISelectbardataDic = responseDic;
                        
                    if (firstRequest1 == 1) {
                                                    
                    [self createUI];
                    firstRequest1 = 2;
                    
                    }
                                                
                    [self refreshPISelectbarDataAndView];
                    
                    PirCode1 = self.PISelectbarcodeArray[_smailSelectIndex];
                                                //SScreen
                                                
                                                //FSScreen
                    _firsrtRequestBool = YES;
                    [self refreshFSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
                                                
                                                
                                                
                    } else {
                                                
                    [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                                
                    HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    HUD.delegate = self;
                    HUD.mode = MBProgressHUDModeText;
                    HUD.labelText = responseDic[@"msg"];
                    HUD.margin = 10.f;
                    HUD.removeFromSuperViewOnHide = YES;
                    [HUD hide:YES afterDelay:2];
                                                
                    }
                });
                }
                failure:^(NSError *error) {
                                        
                   dispatch_async(dispatch_get_main_queue(), ^{
                                            
                    [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                    [UIView animateWithDuration:.4 animations:^{
                        
                    [animationView stopAnimating1];
                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                    }];
                                            
                    if (error.code == -1001) {
                                                
                        [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                                
                    }else{
                                                
                    [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                    }
                                        });
                                    }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


- (void)refreshPISelectbarDataAndView {
    
    @try {
      
        if (!self.PISelectbardataDic) {
            
            return;
            
        }
        
        if (self.PISelectbardataDic) {
            
            NSArray * leftSidebarArray = self.PISelectbardataDic[@"data"][@"leftSidebar"];
            
            self.PISelectbarunitArray = nil;
            
            self.PISelectbarcodeArray = nil;
            
            self.PISelectbarnameArray = nil;
            
            self.PISelectbarunitArray = [NSMutableArray new];
            self.PISelectbarcodeArray = [NSMutableArray new];
            self.PISelectbarnameArray = [NSMutableArray new];
            
            for (int i = 0; i < leftSidebarArray.count; i ++) {
                
                [self.PISelectbarunitArray addObject:leftSidebarArray[i][@"unitArray"]];
                [self.PISelectbarcodeArray addObject:leftSidebarArray[i][@"codeArray"]];
                [self.PISelectbarnameArray addObject:leftSidebarArray[i][@"nameArray"]];
                
            }
            
            for (int i=0; i<self.PISelectbarnameArray.count; i++) {
                
                [self.array[i] setTitle:self.PISelectbarnameArray[i] forState:UIControlStateNormal];
                
            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)refreshFSScreenDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)Code WithPirCode:(NSString *)pirCode{
    
    @try {
        
        [self requestFSScreenDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                                    toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                                    withCache:isUseCache
                                     WithCode:Code
                                  WithPirCode:pirCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 区域看板接口请求
- (void)requestFSScreenDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)org_code WithPirCode:(NSString *)pirCode {
    
    @try {
      
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString * time_type = [NSString stringWithFormat:@"%ld",(long)_bigSelectIndex];
             
            NSDictionary * dataDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                 [AppDatas sharedDatas].userCode,@"user_code",
                 org_code,@"org_code",
                 pirCode,@"pir_code",
                 fromDateStr,@"start_date",
                 toDateStr,@"end_date",
                 time_type,@"time_level",_regionDrill_typeString,@"drill_type",
                 nil];
                
                
            [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news2.FSScreen"
                             dataParameters:dataDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                    
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                FsuccessRequest = YES;
                                            
                if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                    [self btnSelect];
                    cellSelect = -1;
                   
                    [UIView animateWithDuration:.4 animations:^{
                                                    
                    [animationView stopAnimating1];
                                                    
                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                    
                    }];
                                                
                    self.FSScreendataDic = responseDic;
                    
                    if (_regionInteger == 1) {
                        
                       _subheadBarIndex = 0;
                       [self RefreshBigAndTimeView];
                       [self refreshRegionUpdrill_typeAndDowndrill_type];
                       _regionInteger = 2;
                    }
                    
           
        if ([_regionDrill_typeString isEqualToString:@"1"] || [_regionDrill_typeString isEqualToString:@"2"]) {
                
         if ([responseDic[@"data"][@"subheadSidebar"] count] == 0) {
                    
                    _regionDrill_typeString = @"0";
                    return;
          }
                
            [self.delegate transMitheadTitle:responseDic[@"data"][@"subheadSidebar"][0][@"code"] nameString:responseDic[@"data"][@"subheadSidebar"][0][@"name"]];
            
            _subheadBarIndex = 0;
            [self RefreshBigAndTimeView];
            
            [self refreshRegionUpdrill_typeAndDowndrill_type];
         }
                   
                [self refreshFSScreenDataAndView];
                    
                if (_firsrtRequestBool == YES) {
                        
                [self refreshSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
                                                    
                _firsrtRequestBool = NO;
                
               }
                                                
                 } else {
                                                
                    HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    HUD.delegate = self;
                    HUD.mode = MBProgressHUDModeText;
                    HUD.labelText = responseDic[@"msg"];
                    HUD.margin = 10.f;
                    HUD.removeFromSuperViewOnHide = YES;
                    [HUD hide:YES afterDelay:2];
                                                
                    }
                    
                    _regionDrill_typeString = @"0";
                });
            }
            failure:^(NSError *error) {
                                        
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _regionDrill_typeString = @"0";

                    [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                    FsuccessRequest = NO;
                                            
                    [self refreshFSScreenDataAndView];
                                            
                    [UIView animateWithDuration:.4 animations:^{
                    
                    [animationView stopAnimating1];
                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                    }];
                                            
                if (error.code == -1001) {
                                                
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                                
                }else{
                                                
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                }
            });
        }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)refreshRegionUpdrill_typeAndDowndrill_type{
    
    amountView.frame = CGRectMake(80 * SCREEN_W_SP, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 160 * SCREEN_W_SP + 10* SCREEN_W_SP, 28 * SCREEN_H_SP);
    _regionDrillUpButton.hidden = YES;
    _regionDrillDownButton.hidden = YES;

}

#pragma mark - 刷新整个页面和数据
-(void)refreshFSScreenDataAndView{
    
    @try {
        
        NSString * drawType =[NSString stringWithFormat:@"%@",self.FSScreendataDic[@"data"][@"drawType"]] ;
        NSMutableArray * PieArray = [[NSMutableArray alloc] initWithArray:self.FSScreendataDic[@"data"][@"ratioBar"][0]];
        
        self.orgNameArray = nil;
        
        self.orgCodeArray = nil;
        
        self.valueArray = nil;
        
        self.orgNameArray = [NSMutableArray new];
        self.orgCodeArray = [NSMutableArray new];
        self.valueArray = [NSMutableArray new];
        
        if (FsuccessRequest && PieArray.count > 0) {
            
            NSString * nameForBtn = self.FSScreendataDic[@"data"][@"totalBar"][@"titleHead"];
             _valueForBtnString  = self.FSScreendataDic[@"data"][@"totalBar"][@"data"][0];
            _UnitForBtnString = self.PISelectbardataDic[@"data"][@"leftSidebar"][_smailSelectIndex][@"unitArray"];
            
            nameLab.text = nameForBtn;
            
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",_valueForBtnString,_UnitForBtnString]];
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:20.0 * SCREEN_W_SP]
             
                                  range:NSMakeRange(0, _valueForBtnString.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor whiteColor]
             
                                  range:NSMakeRange(0, _valueForBtnString.length)];
            
            
            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:16.0 * SCREEN_W_SP]
             
                                  range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor whiteColor]
             
                                  range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
            
            
            numLab.attributedText = AttributedStr;
           // unitLab.text = UnitForBtn;
            
            for (int i = 0; i < PieArray.count; i++) {
                
                [self.valueArray addObject: PieArray[i][@"value"]];
                [self.orgCodeArray addObject: PieArray[i][@"orgCode"]];
                [self.orgNameArray addObject: PieArray[i][@"orgName"]];
                
            }
            
        } else {
            
            nameLab.text = @"";
            numLab.text = @"";
            
        }
        
        if ([drawType isEqualToString:@"1"]) {
            
            [_tabView removeFromSuperview];
            _tabView = nil;
            
//            [_pieChartView removeFromSuperview];
//            _pieChartView = nil;
//            
//            _pieChartView =  _pieChartView == nil ? [self createPieDateUI] : _pieChartView;
//            //        [_pieChartView setHidden:NO];
//            //        [_tabView setHidden:YES];
//            [scrollView1 bringSubviewToFront:_pieChartView];
            [self refreshPieData];
            
            
            
        } else {
            
            [_tabView removeFromSuperview];
            _tabView = nil;
            
//            [_pieChartView  removeFromSuperview];
//            _pieChartView  =  nil;
            
            _tabView =  _tabView == nil ? [self createBarDateUI] : _tabView;
            //        [_tabView setHidden:NO];
            //        [_pieChartView setHidden:YES];
            
            [scrollView1 bringSubviewToFront:_tabView];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 刷新饼状图
-(void)refreshPieData{
   
    @try {
      
//        NSArray * PieArray = self.FSScreendataDic[@"data"][@"ratioBar"][0];
//
//        if (PieArray.count > 10) {
////            [_pieChartView removeFromSuperview];
////            _pieChartView = nil;
//            [_tabView removeFromSuperview];
//            _tabView = nil;
//            _tabView =  _tabView == nil ? [self createBarDateUI] : _tabView;
//            //        [_tabView setHidden:NO];
//            //        [_pieChartView setHidden:YES];
//
//            [scrollView1 bringSubviewToFront:_tabView];
//        }
//        else{
//
//            NSMutableArray *values = [[NSMutableArray alloc] init];
//
//            double minValve = 1000000000000000.0;
//
//
//            for (int i = 0; i < PieArray.count; i++ ) {
//
//                double xValued = [PieArray[i][@"value"] doubleValue] ;
//
//                if (xValued > 0) {
//
//                    if (xValued < minValve) {
//
//                        minValve = xValued;
//
//                    }else{
//
//                        minValve = minValve;
//
//                    }
//
//                }
//
//            }
        
//            for (int i = 0; i < PieArray.count; i++)
//            {
//                NSString * lab = [NSString stringWithFormat:@"%@ %@",PieArray[i][@"orgName"], PieArray[i][@"value"]];
//
//                double xValued = [PieArray[i][@"value"] doubleValue];
//
//                if (xValued < 0 ||xValued == 0 ) {
//
//                    xValued = minValve / 2;
//                }else{
//
//                    xValued =[PieArray[i][@"value"] doubleValue];
//
//                }
//
//                [values addObject:[[PieChartDataEntry alloc] initWithValue:xValued label:lab]];
//            }
            
//            PieChartDataSet * dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
//            dataSet.sliceSpace = 3.0 * SCREEN_H_SP;   //间距
//            dataSet.valueLineColor = [UIColor grayColor];
//            dataSet.valueLinePart1OffsetPercentage = 0.8;
//            dataSet.valueLinePart1Length = 0.2;
//            dataSet.valueLinePart2Length = 0.4;
//            dataSet.drawValuesEnabled = NO;
//            dataSet.xValuePosition =  PieChartValuePositionOutsideSlice;
//            dataSet.colors = colors;
//
//            PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
//            NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
//            pFormatter.numberStyle = NSNumberFormatterPercentStyle;
//            pFormatter.maximumFractionDigits = 1;
//            pFormatter.multiplier = @1.f;
//            pFormatter.percentSymbol = @" ";
//
//            [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
//
//            if (SCREEN_WIDTH <= 320 ) {
//                [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.2f]];
//            }
//            else if(SCREEN_WIDTH > 320 && SCREEN_WIDTH <= 375 ){
//                [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.7f]];
//            }
//            else if(SCREEN_WIDTH > 375 && SCREEN_WIDTH <= 414){
//                [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:9.2f]];
//            }
//
//
//            [data setValueTextColor:UIColor.grayColor];
//
//            if (data.entryCount) {
//                _pieChartView.data = data;
//            } else {
//                _pieChartView = [self createPieDateUI];
//            }
//
//            [_pieChartView highlightValues:nil];
//        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 请求接口前的过渡方法
- (void)refreshSScreenDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)Code WithPirCode:(NSString *)pirCode{
    
    @try {
     
        [self refreshSScreenFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                              toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                              withCache:isUseCache
                               WithCode:Code
                            WithPirCode:pirCode];
   
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 页面内请求接口
- (void)refreshSScreenFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)org_code WithPirCode:(NSString *)pirCode{
   
    @try {
     
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            if (_firsrtRequestBool == NO) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString * time_type = [NSString stringWithFormat:@"%ld",(long)_bigSelectIndex];
                
              NSDictionary * dataDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                 [AppDatas sharedDatas].userCode, @"user_code",
                 org_code,@"org_code",
                 pirCode,@"pir_code",
                 fromDateStr, @"start_date",
                 toDateStr, @"end_date",
                 time_type, @"time_level",
                 nil];

                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.SScreen"
                             dataParameters:dataDic                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            SsuccessRequest = YES;
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                                                [UIView animateWithDuration:.4 animations:^{
                                                    
                                                    [animationView stopAnimating1];
                                                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                }];
                                                
                                                self.SScreendataDic = responseDic;
                                                [self refreshSScreenDataAndView];
                                                
                                            } else {
                                                
                                                HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
                                                HUD.delegate = self;
                                                HUD.mode = MBProgressHUDModeText;
                                                HUD.labelText = responseDic[@"msg"];
                                                HUD.margin = 10.f;
                                                HUD.removeFromSuperViewOnHide = YES;
                                                [HUD hide:YES afterDelay:2];
                                                
                                            }
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            SsuccessRequest = NO;
                                            
                                            [self refreshSScreenDataAndView];
                                            
                                            [UIView animateWithDuration:.4 animations:^{
                                                
                                                [animationView stopAnimating1];
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                            }];
                                            
                                            if (error.code == -1001) {
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                                
                                                
                                            }else{
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                                
                                            }
                                        });
                                    }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 刷新
-(void)refreshSScreenDataAndView{
    
    @try {

        self.SSorgNameArray = nil;
        
        self.SSvalueArray = nil;
        self.SSorgNameArray = [NSMutableArray new];
        self.SSvalueArray = [NSMutableArray new];
        
        if (SsuccessRequest == NO) {
            
            [collectView reloadData];
          //   [self createCollectionView];
            return;
        }
        if (SsuccessRequest == YES) {
            
            
            NSArray * PieArray;
            
            if ([self.SScreendataDic[@"data"][@"data"] count] > 0) {
                PieArray = self.SScreendataDic[@"data"][@"data"][0];
            }
            
            for (int i = 0; i < PieArray.count; i ++) {
                [self.SSorgNameArray addObject:PieArray[i][@"orgName"]];
                [self.SSvalueArray addObject:PieArray[i][@"value"]];
            }
            
            if (firstRequest2 == 1 || PieArray.count == 0) {
                [self createCollectionView];
                firstRequest2 = 2;
            }
            
         //    [self createCollectionView];
            [collectView reloadData];
            [_tabView reloadData];
            
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 创建页面底部 collectionView
-(void)createCollectionView{
    
    @try {
        
        [line removeFromSuperview];
        line = nil;
        [collectView removeFromSuperview];
        collectView = nil;
        line = [[UIView alloc]initWithFrame:CGRectMake(10, amountView.frame.origin.y + 280 *SCREEN_H_SP, SCREEN_WIDTH - 20, 1)];
        line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [scrollView1 addSubview:line];
        
        UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection=UICollectionViewScrollDirectionVertical;
        
        
        if (SCREEN_WIDTH == 320) {
            collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10 * SCREEN_W_SP, line.frame.origin.y + 10 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, 90 * SCREEN_H_SP) collectionViewLayout:flowlayout];
        }
        else{
            
            if (SCREEN_HEIGHT == 812) {
                collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10 * SCREEN_W_SP, line.frame.origin.y + 10 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, 100 * SCREEN_H_SP + 100) collectionViewLayout:flowlayout];
                
            }
            else{
                
                collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(10 * SCREEN_W_SP, line.frame.origin.y + 10 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, 100 * SCREEN_H_SP) collectionViewLayout:flowlayout];
            }
            
        }
        
        collectView.showsHorizontalScrollIndicator=NO;
        collectView.showsVerticalScrollIndicator=NO;
        collectView.backgroundColor=[UIColor whiteColor];
        [collectView registerClass:NSClassFromString(@"QuYuCollectionViewCell") forCellWithReuseIdentifier:@"QuYuCollection"];
        collectView.delegate=self;
        collectView.dataSource=self;
        [scrollView1 addSubview:collectView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - subheadBar 切换
- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
        
        if (index > 0) {
            if (SCREEN_WIDTH == 320) {
                
                amountView.frame = CGRectMake(10 * SCREEN_W_SP, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 160 * SCREEN_W_SP + 10* SCREEN_W_SP, 28 * SCREEN_H_SP);
            }
            else if(SCREEN_WIDTH > 320){
                
                amountView.frame = CGRectMake(10 * SCREEN_W_SP, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 160 * SCREEN_W_SP + 20 * SCREEN_W_SP, 28 * SCREEN_H_SP);
            }
            
            _regionDrillUpButton.hidden = NO;
            _regionDrillDownButton.hidden = NO;
        }
        else if (index == 0){
             amountView.frame = CGRectMake(80 * SCREEN_W_SP, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 160 * SCREEN_W_SP + 10* SCREEN_W_SP, 28 * SCREEN_H_SP);
            _regionDrillUpButton.hidden = YES;
            _regionDrillDownButton.hidden = YES;
        }
        
       // cellSelect = -1;
        
        _Code = _regionCodeArray[index];
        _subheadBarIndex = index;
        _firsrtRequestBool = YES;
         PirCode1 = self.PISelectbarcodeArray[_smailSelectIndex];
        
        [self refreshFSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
        
    } @catch (NSException *exception) {
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 切换日周月年
- (void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    
    @try {
        
        cellSelect = -1;
        _bigSelectIndex = index + 1;
        _firsrtRequestBool = YES;
        [self refreshFSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
    //  [self refreshDatasAndViews];
    
}



#pragma mark - 页面主UI创建
-(void)createUI{
    
    @try {
    
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, self.height)];
        }
        else{
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.height)];
        }
        scrollView1.delegate =self;
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.contentSize = CGSizeMake(0, self.height);
        scrollView1.alwaysBounceVertical = YES;
        [self addSubview:scrollView1];
        
        [animationView  removeFromSuperview];
        animationView  = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 100)];
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        [animationView Animation];
        [animationView Animation1];
        [scrollView1 addSubview:animationView];
        
      
        self.array = [NSMutableArray new];
        
        NSArray * leftSidebarArray = self.PISelectbardataDic[@"data"][@"leftSidebar"];
        //    NSArray *title = @[@"件数",@"单数",@"开店",@"关店",@"折率",@"客单价",@"客单价2"];
        
        [self.ScrollView  removeFromSuperview];
        self.ScrollView  = nil;
        
        self.ScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,120 * SCREEN_H_SP , SCREEN_WIDTH,30 * SCREEN_H_SP)];
        self.ScrollView.backgroundColor = [UIColor whiteColor];
        for (int i=0; i<leftSidebarArray.count; i++) {
            btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * i + 5,0, (SCREEN_WIDTH - 10) / 5, 30* SCREEN_H_SP)];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btn setBackgroundColor:[UIColor colorWithHex:0xdfdfdf] forState:UIControlStateNormal];
            [btn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            //        [btn setTitle:title[i] forState:UIControlStateNormal];
            btn.tag = 10 + i;
            if (i == 0) {
                btn.selected=YES;
            }
            [self.array addObject:btn];
            
            [btn addTarget:self action:@selector(btn_Selectd:) forControlEvents:UIControlEventTouchUpInside];
            [self.ScrollView addSubview:btn];
        }
        
        self.ScrollView.contentSize=CGSizeMake(SCREEN_WIDTH * leftSidebarArray.count / 5,0);
        
        if (leftSidebarArray.count <= 5) {
            
            self.ScrollView.scrollEnabled = NO;
        }
        self.ScrollView.delegate = self;
        self.ScrollView.showsHorizontalScrollIndicator=NO;
        self.ScrollView.showsVerticalScrollIndicator=NO;
        [scrollView1 addSubview:self.ScrollView];
        
        
        [self.rightBtn  removeFromSuperview];
        self.rightBtn  = nil;
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.rightBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_R"] forState:UIControlStateNormal];
        self.rightBtn.frame = CGRectMake(SCREEN_WIDTH - 20, 120 * SCREEN_H_SP , 20, 30* SCREEN_H_SP);
        //    self.rightBtn.backgroundColor = [UIColor whiteColor];
        
        if (leftSidebarArray.count <= 5) {
            
            self.rightBtn.hidden = YES;
        }
        [scrollView1 addSubview:self.rightBtn];
        
        [self.lefttBtn  removeFromSuperview];
        self.lefttBtn  = nil;
        
        self.lefttBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.lefttBtn setImage:[UIImage imageNamed:@"icon_滚动箭头_L"] forState:UIControlStateNormal];
        self.lefttBtn.frame = CGRectMake(0,120 * SCREEN_H_SP , 20, 30* SCREEN_H_SP);
        self.lefttBtn.hidden = YES;
        //    self.lefttBtn.backgroundColor = [UIColor whiteColor];
        [scrollView1 addSubview:self.lefttBtn];
        
        
        [_regionDrillUpButton removeFromSuperview];
        _regionDrillUpButton = nil;
        
        _regionDrillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _regionDrillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_regionDrillUpButton];
        if (SCREEN_WIDTH == 320) {
            _regionDrillUpButton.frame = CGRectMake(SCREEN_WIDTH - 140 + 30, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414){
            _regionDrillUpButton.frame = CGRectMake( SCREEN_WIDTH - 140 + 20, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28* SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH >= 414){
            _regionDrillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 145, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28* SCREEN_H_SP);
        }
        
        _regionDrillUpButton.hidden = YES;
        [_regionDrillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
        _regionDrillUpButton.layer.masksToBounds = YES;
        _regionDrillUpButton.layer.cornerRadius = 5;
        [_regionDrillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        _regionDrillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_regionDrillUpButton addTarget:self action:@selector(regionDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_regionDrillDownButton removeFromSuperview];
        _regionDrillDownButton = nil;
        
        _regionDrillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _regionDrillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_regionDrillDownButton];
        _regionDrillDownButton.hidden = YES;
        [_regionDrillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        
        if (SCREEN_WIDTH == 320) {
            _regionDrillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 25 + 40, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28*SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH >= 375 && SCREEN_WIDTH < 414){
            
            _regionDrillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 70,self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28*SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH >= 414){
            _regionDrillDownButton.frame = CGRectMake(SCREEN_WIDTH - 140 + 10 + 10 + 50,self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, 50, 28*SCREEN_H_SP);
        }
        
        [_regionDrillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
        _regionDrillDownButton.layer.masksToBounds = YES;
        _regionDrillDownButton.layer.cornerRadius = 5;
        _regionDrillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_regionDrillDownButton addTarget:self action:@selector(regionDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [amountView  removeFromSuperview];
        amountView  =  nil;
        
        amountView = [[UIView alloc]init];
        
        amountView.frame = CGRectMake(80 * SCREEN_W_SP, self.ScrollView.frame.origin.y + 50 * SCREEN_H_SP, SCREEN_WIDTH - 160 * SCREEN_W_SP + 10 * SCREEN_W_SP, 28 * SCREEN_H_SP);
            
        amountView.backgroundColor = [UIColor colorWithHex:0xba2932];
        amountView.layer.cornerRadius = 3;
        [scrollView1 addSubview:amountView];
        
        [nameLab removeFromSuperview];
        nameLab  =  nil;
        
        nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 1, 40 * SCREEN_W_SP, 28 * SCREEN_H_SP)];
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:15 * SCREEN_W_SP];
        nameLab.textColor = [UIColor whiteColor];
        [amountView addSubview:nameLab];
        
        [numLab removeFromSuperview];
        numLab  =  nil;
        
        numLab = [[UILabel alloc]initWithFrame:CGRectMake(nameLab.frame.size.width, 0, amountView.width - 40 * SCREEN_W_SP - 10 * SCREEN_W_SP, 28 * SCREEN_H_SP)];
        numLab.textAlignment = NSTextAlignmentCenter;
        numLab.textColor = [UIColor whiteColor];
        [amountView addSubview:numLab];
        
//        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"今天天气不错呀"];
//        
//        [AttributedStr addAttribute:NSFontAttributeName
//         
//                              value:[UIFont systemFontOfSize:16.0]
//         
//                              range:NSMakeRange(2, 2)];
//        
//        [AttributedStr addAttribute:NSForegroundColorAttributeName
//         
//                              value:[UIColor redColor]
//         
//                              range:NSMakeRange(2, 2)];
//        
//        testLabel.attributedText = AttributedStr;

        
//        [unitLab removeFromSuperview];
//        unitLab  =  nil;
//        
//        unitLab = [[UILabel alloc]initWithFrame:CGRectMake(numLab.frame.size.width + numLab.frame.origin.x, 0, 60 * SCREEN_W_SP, 30 * SCREEN_H_SP)];
//        unitLab.textAlignment = NSTextAlignmentLeft;
//        unitLab.textColor = [UIColor whiteColor];
//        [amountView addSubview:unitLab];
        
        
        [amountBtn  removeFromSuperview];
        amountBtn  =  nil;
        
        amountBtn = [[UIButton alloc]initWithFrame:amountView.bounds];
        amountBtn.selected = YES;
        [amountView addSubview:amountBtn];
        [amountBtn addTarget:self action:@selector(amountBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)RefreshBigAndTimeView{
    NSArray *arr = @[@"日",@"周",@"月",@"年",];
    
    NSArray * titNum = self.FSScreendataDic[@"data"][@"subheadSidebar"];
    
    _regionTitArray = nil;
    _regionTitArray = [NSMutableArray new];
    
    _regionCodeArray = nil;
    _regionCodeArray = [NSMutableArray new];
    
    for (int i =0; i < titNum.count; i++) {
        
        NSString * str = titNum[i][@"name"];
        
        NSString * codeStr = titNum[i][@"code"];
        
        [_regionCodeArray addObject:codeStr];
        
        [_regionTitArray addObject:str];
    }
    
    
    [_bigview removeFromSuperview];
    _bigview = nil;
    
    _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 *SCREEN_H_SP)];
    _bigview.delegate =self;
    _bigview.checkUserType = YES;
    
    [_bigview showRegionAndShoppingGuideBigAndTimeView:_regionTitArray WithState:NO Withplaceholder:@"" WithTimeArray:arr withIndexOfSubheadBar:_subheadBarIndex withIndexOfTime:_bigSelectIndex-1 scrollViewTag:1];
    
    
    //        btnView.delegate =self;
    //        [btnView showBigBtnView:arr];
    [scrollView1 addSubview:_bigview];

    _Code = _regionCodeArray[0];
    
}

#pragma mark 点击上钻按钮
-(void)regionDrillUpTounchButton{
    
    cellSelect = -1;
    _firsrtRequestBool = YES;
    _regionDrill_typeString = @"1";
    
    [self refreshFSScreenDatasWithCache:YES WithCode:_regionCodeArray[_subheadBarIndex] WithPirCode:PirCode1];
}

#pragma mark 点击下钻按钮
-(void)regionDrillDownTounchButton{
    
    cellSelect = -1;
    _firsrtRequestBool = YES;
    _regionDrill_typeString = @"2";
    
    [self refreshFSScreenDatasWithCache:YES WithCode:_regionCodeArray[_subheadBarIndex] WithPirCode:PirCode1];
}

#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    @try {
        
        return self.SSorgNameArray.count;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        QuYuCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"QuYuCollection" forIndexPath:indexPath];
        cell.nameLab.text = [NSString stringWithFormat:@"%@",self.SSorgNameArray[indexPath.row]];
        cell.numLab.text =  [NSString stringWithFormat:@"%@",self.SSvalueArray[indexPath.row]];
        
        NSString * drawType =[NSString stringWithFormat:@"%@", self.FSScreendataDic[@"data"][@"drawType"]] ;
        
        if ([drawType isEqualToString:@"1"]) {
            if (self.SSorgNameArray.count <= lineBarcolors.count) {
                cell.colorLab.backgroundColor = colors[indexPath.row];
            }else{
                if (indexPath.row <= lineBarcolors.count -1) {
                    cell.colorLab.backgroundColor = colors[indexPath.row];
                }else{
                    cell.colorLab.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                }
            }
        }else{
            if (indexPath.row < lineBarcolors.count) {
                cell.colorLab.backgroundColor = lineBarcolors[indexPath.row];
            }else{
                cell.colorLab.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
            }
        }
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
     
        return CGSizeMake((SCREEN_WIDTH - 20 * SCREEN_W_SP) / 2, 40 * SCREEN_H_SP);
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
   
    @try {
        
       return 0;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    @try {
      
         return 0;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


#pragma mark - 创建饼状图
//-(PieChartView *)createPieDateUI{
//
//    @try {
//
//        [_pieChartView  removeFromSuperview];
//        _pieChartView  =  nil;
//
//        _pieChartView = [PieChartView new];
//        _pieChartView.frame = CGRectMake(0, amountView.frame.origin.y + 40 * SCREEN_H_SP, SCREEN_WIDTH, 230 *SCREEN_H_SP);
//        _pieChartView.holeRadiusPercent = 0.7;
//        _pieChartView.backgroundColor = [UIColor whiteColor];
//        [scrollView1 addSubview:_pieChartView];
//        _pieChartView.rotationEnabled = NO;
//        _pieChartView.legend.enabled = NO;
//        _pieChartView.delegate = self;
//        _pieChartView.descriptionText = @"";
//        _pieChartView.noDataText = @"";
//        _pieChartView.noDataTextDescription = @"";
//        ChartLegend *l = _pieChartView.legend;
//        l.position = ChartLegendPositionRightOfChart;
//        l.xEntrySpace = 7.0;
//        l.yEntrySpace = 0.0;
//        l.yOffset = 0.0;
//        _pieChartView.entryLabelColor = UIColor.whiteColor;
//        _pieChartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//        [_pieChartView animateWithXAxisDuration:1 easingOption:ChartEasingOptionEaseOutBack];
//
//        return _pieChartView;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}
//

#pragma mark - 创建柱状图

-(UITableView *)createBarDateUI{

    @try {
        
        [_tabView  removeFromSuperview];
        _tabView  =  nil;
        
        _tabView = [[UITableView alloc]initWithFrame:CGRectMake(0, amountView.frame.origin.y + 40 * SCREEN_H_SP, SCREEN_WIDTH, 230 *SCREEN_H_SP) style:UITableViewStylePlain];
        _tabView.delegate =self;
        _tabView.dataSource =self;
        _tabView.bounces = NO;
        _tabView.showsHorizontalScrollIndicator=NO;
        _tabView.showsVerticalScrollIndicator=NO;
        _tabView.rowHeight = 60 * SCREEN_H_SP;
        _tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [scrollView1 addSubview:_tabView];
        [_tabView registerClass:[TableViewBarCells class] forCellReuseIdentifier:@"TableViewBarCells"];
        
        return _tabView;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    @try {
    
        return self.orgCodeArray.count;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        double d;
        double rr;
        double maxLength = SCREEN_WIDTH - 145 * SCREEN_W_SP;
        
        if ([self.valueArray[indexPath.row] doubleValue] != 0 &&[self.valueArray[0] doubleValue] != 0) {
            
            double w = [self.valueArray[indexPath.row] doubleValue];
            if (w < 0) {
                w = 0;
            }
            d = w / [self.valueArray[0] doubleValue];
            rr = d * maxLength;
        }else{
            
            rr = 0;
        }
        
        NSMutableArray * smallWithArray = [NSMutableArray new];
        if (indexPath.row == cellSelect) {
            
            double sum = 0.0;
            for (int j = 0; j < self.SSvalueArray.count;  j ++) {
                
                double oneSum  = [self.SSvalueArray[j] doubleValue];
                
                if (oneSum < 0) {
                    oneSum = 0;
                }
                
                sum += oneSum;
            }
            
            for (int i = 0; i < self.SSvalueArray.count; i ++) {
                double ss = [self.SSvalueArray[i] doubleValue];
                if (ss < 0) {
                    
                    ss = 0;
                }
                
                double ds = ss / sum * rr;
                NSString * smallStr = [NSString stringWithFormat:@"%f",ds];
                [smallWithArray addObject: smallStr];
            }
            
        }
        
        TableViewBarCells *cell = [[TableViewBarCells alloc] initWithStyle:UITableViewCellStyleDefault
                                                           reuseIdentifier:@"TableViewBarCells" WithWidth:rr WithsmallWith:smallWithArray WithColors:lineBarcolors];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if ([self.SScreendataDic[@"data"][@"data"] count] == 0) {
//            
//            if (cellSelect == indexPath.row) {
//               cell.amountNum.backgroundColor = [UIColor colorWithHex:0xba2932];
//            }
//            else{
//                
//                cell.amountNum.backgroundColor = [UIColor grayColor];
//            }
//        }
//        else{
//            
//        }
        
        cell.nameLab.text = [NSString stringWithFormat:@"%@",self.orgNameArray[indexPath.row]];
        cell.nameLab.numberOfLines = 2;
        cell.valueLabel.text = [NSString stringWithFormat:@"%@",self.valueArray[indexPath.row]];
        cell.nameLab.textAlignment = NSTextAlignmentCenter;
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        
        if (indexPath.row == cellSelect) {
        
            cell.backgroundColor = [UIColor colorWithHex:0xe8e8e8];
        }else{
        
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        [self btnDisSelect];
        cellSelect = indexPath.row;
        NSString * s =  self.orgCodeArray[indexPath.row];
        [self refreshSScreenDatasWithCache:YES WithCode:s WithPirCode:PirCode1];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}


#pragma mark - 数字按钮点击事件
-(void)amountBtn:(UIButton *)sender{
    
    @try {
     
        sender.selected = !sender.selected;
        if (sender.selected) {
            
            [self btnSelect];
            
            cellSelect = -1;
            _firsrtRequestBool = YES;
            [self refreshFSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
        }else {
            
            amountBtn.selected = YES;
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)btnSelect{
    
    @try {
    
        amountBtn.selected = YES;
        amountView.backgroundColor = [UIColor colorWithHex:0xba2932];
        nameLab.textColor = [UIColor whiteColor];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",_valueForBtnString,_UnitForBtnString]];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:20.0 * SCREEN_W_SP]
         
                              range:NSMakeRange(0, _valueForBtnString.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor whiteColor]
         
                              range:NSMakeRange(0, _valueForBtnString.length)];
        
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:16.0 * SCREEN_W_SP]
         
                              range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor whiteColor]
         
                              range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
        
        
        numLab.attributedText = AttributedStr;
      //  unitLab.textColor = [UIColor whiteColor];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)btnDisSelect{
    
    @try {
        
        amountBtn.selected = NO;
        amountView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
        nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",_valueForBtnString,_UnitForBtnString]];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:20.0 * SCREEN_W_SP]
         
                              range:NSMakeRange(0, _valueForBtnString.length)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithHex:0xba2932]
         
                              range:NSMakeRange(0, _valueForBtnString.length)];
        
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:16.0 * SCREEN_W_SP]
         
                              range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithHex:0x888888]
         
                              range:NSMakeRange(_valueForBtnString.length+1, _UnitForBtnString.length)];
        
        
        numLab.attributedText = AttributedStr;
        
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)amountBtnValueWithIndex:(NSInteger)index{
    
    @try {
     
        NSString * nameForBtn = self.orgNameArray[index];
        _valueForBtnString = self.valueArray[index];
        _UnitForBtnString = self.PISelectbardataDic[@"data"][@"leftSidebar"][_smailSelectIndex][@"unitArray"];
        nameLab.text = nameForBtn;
      
        numLab.text = [NSString stringWithFormat:@"%@%@",_valueForBtnString,_UnitForBtnString];
       // unitLab.text = _UnitForBtnString;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 按钮事件函数
-(void)btn_Selectd:(UIButton *)sender{
    
    @try {
     
        cellSelect = -1;
        _smailSelectIndex = sender.tag - 10;
        NSInteger num = sender.tag;
        for (UIButton *btns in self.array) {
            
            btns.selected = NO;
        }
        
        UIButton *btns = (UIButton *)[self.ScrollView viewWithTag:num];
        btns.selected = YES;
        PirCode1 = self.PISelectbarcodeArray[_smailSelectIndex];
        //FSScreen
        _firsrtRequestBool = YES;
        [self refreshFSScreenDatasWithCache:YES WithCode:_Code WithPirCode:PirCode1];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    @try {
     
        if (self.ScrollView == scrollView) {
            [self scrollViewEnd];
        }
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
    
    }
}


-(void)scrollViewEnd{
    
    @try {
     
        if (self.ScrollView) {
            
            NSArray * leftSidebarArray = self.PISelectbardataDic[@"data"][@"leftSidebar"];
            double d1 = self.ScrollView.contentOffset.x ;
            double d2 = SCREEN_WIDTH / 5;
            int s1 = ((int)roundf(d1 / d2)) * d2;
            
            [self.ScrollView setContentOffset:CGPointMake(s1, 0)animated:YES];
            
            if (self.rightBtn.hidden == NO || self.lefttBtn.hidden == NO) {
                
                if (s1 > d2 * (leftSidebarArray.count-1) - SCREEN_WIDTH) {
                    
                    self.rightBtn.hidden = YES;
                    self.lefttBtn.hidden = NO;
                    
                }
                
                if (s1 < d2) {
                    
                    self.rightBtn.hidden = NO;
                    self.lefttBtn.hidden = YES;
                    
                }
                
                if (s1 >= d2 && s1 <= d2 * (leftSidebarArray.count-1) - SCREEN_WIDTH) {
                    
                    self.rightBtn.hidden = NO;
                    self.lefttBtn.hidden = NO;
                    
                }
                
            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {

    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    @try {
     
        if (self.ScrollView == scrollView) {
            
            [self scrollViewEnd];
            
            if (self.rightBtn.hidden == NO || self.lefttBtn.hidden == NO) {
                
                NSArray * leftSidebarArray = self.PISelectbardataDic[@"data"][@"leftSidebar"];
                
                if (self.ScrollView.contentOffset.x <= 0) {
                    
                    self.rightBtn.hidden = NO;
                    self.lefttBtn.hidden = YES;
                    
                    
                } else if (self.ScrollView.contentOffset.x + self.ScrollView.contentSize.width >= (SCREEN_WIDTH / 5) * leftSidebarArray.count) {
                    
                    self.rightBtn.hidden = YES;
                    self.lefttBtn.hidden = NO;
                    
                }
                
            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
     
         [animationView startAnimation];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    if (self.ScrollView == scrollView) {
//        
//        self.lefttBtn.hidden = YES;
//        self.rightBtn.hidden = YES;
//        
//        
//    }
    
    @try {
        
        if (scrollView.contentOffset.y <= -80) {
            
            if (animationView.tag == 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                });
            }
            animationView.tag = 1;
            
        }else{
            
            animationView.tag = 0;
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 页面下拉刷新－－即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
        [animationView stopAnimating];
        
        if (scrollView.contentOffset.y <= -80) {
            
            
            
        }
        
        if (animationView.tag == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [animationView startAnimation1];
                
                [self refreshLeftSidebarDatasWithCache:YES WithCode:_Code];
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    animationView.tag = 0;
                    
                }];
            });
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - ChartViewDelegate
//- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight
//{
//    @try {
//
//        [self btnDisSelect];
//        int high = highlight.x;
//        NSString * s =  self.orgCodeArray[high];
//        [self refreshSScreenDatasWithCache:YES WithCode:s WithPirCode:PirCode1];
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//
//}

//- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView
//{
//    DLog(@"%@.................",chartView);
//
//}

@end
