//
//  MainPageDayDetailViewController-0004.m
//  LOSBi
//
//  Created by gufeifei on 16/8/22.
//  Copyright © 2016年 L.O.S. All rights reserved.
//


/*
 
    主页详情页面（点击主页上半部分跳转至此页面）
 */



#import "MainPageDayDetailViewController-0004.h"
//#import "DayAxisValueFormatter.h"
#import "LOSHelper.h"
#import "NSDate+Escort.h"
#import "MainPageDetailCompareView.h"
#import "UIButton+LOSButton.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LeftSlideViewController.h"
#import "ShareMenuViewController.h"
#import "ShowView.h"
#import "LOConst.h"
#import "AnimationView.h"
#import "AppDelegate.h"
//ChartViewDelegate, IChartAxisValueFormatter,
@interface MainPageDayDetailViewController_0004 () <UIScrollViewDelegate> {
    
    
    UILabel *_timeLabel;
    UILabel *_amountTitleLabel;
    UILabel *_amountValueLabel;
    
    UIButton *_dayBtn;
    UIButton *_weekBtn;
    UIButton *_monthBtn;
    UIButton *_yearBtn;
    
    MainPageDetailCompareView *_compareView1;
    MainPageDetailCompareView *_compareView2;
    MainPageDetailCompareView *_compareView3;
    
    UIButton * calendarBtn;
    
    ShowView *sv;
    
    NSDate *startDate;
    
    NSDate *endDate;
    
    NSInteger _indexDWMY;
    
    AnimationView * animationView;
    
    //AlterView *_alert;
    
    NSInteger firstCreate;
    
    UIScrollView * scrollView1;
    
    NSMutableArray *yVals;
    
      NSInteger firstBarHeight;
    
    NSInteger entryIndex;
    
    BOOL isDefaultCompareSelected;
    
}

//@property (nonatomic, strong) BarChartView *chartView;
//@property (nonatomic, strong) CombinedChartView *chartView;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSDate *fromDate;

@property (nonatomic, strong) NSDate *toDate;

@end


@implementation MainPageDayDetailViewController_0004

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        // AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
        //    self.navigationController.navigationBar.translucent = NO;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        firstBarHeight = 1;
        
        entryIndex = BarCharMaxEntryCount - 1;
        isDefaultCompareSelected = YES;
        
        firstCreate = 1;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, DeviceHeight)];
        bg.image = [UIImage imageNamed:@"img_bg"];
        [self.view addSubview:bg];
        
        self.title = @"有数";
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xba2932];
        
        // _alert = [AlterView new];
        
        _indexDWMY = 0;
        
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        //    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
        
        calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [calendarBtn setBackgroundImage:[UIImage imageNamed:@"bg_calendar"] forState:UIControlStateNormal];
        calendarBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM dd"];
        NSString * currentDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectFromDate];
        NSString * toDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectToDate];
        if ([currentDateString isEqualToString:toDateString]) {
            
            [calendarBtn setTitle:currentDateString forState:UIControlStateNormal];
        }else{
            
            [calendarBtn setTitle:@"时 段" forState:UIControlStateNormal];
            
        }
        
        calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);//文字下移
        
        calendarBtn.frame = CGRectMake(0, 0, 44, 44);
        [calendarBtn addTarget:self action:@selector(calendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *rightBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        [rightBtnsView addSubview:shareBtn];
        [rightBtnsView addSubview:calendarBtn];
        calendarBtn.x = 0;
        shareBtn.x = 44;
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
        
        //导航栏右视图
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarButtonItem];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
        
        [self createUI];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - UI创建
-(void)createUI{
    
    @try {
       
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 124, SCREEN_WIDTH, self.view.height)];
        }
        else{
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.height)];
        }
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.userInteractionEnabled = YES;
        scrollView1.delegate =self;
        scrollView1.contentSize = CGSizeMake(0, 0);
        
        scrollView1.alwaysBounceVertical = YES;
        [self.view addSubview:scrollView1];
        
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 100)];
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        [animationView Animation];
        [animationView Animation1];
        [scrollView1 addSubview:animationView];
        
        UIView *headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 220 * SCREEN_H_SP)];
        headerViewBg.backgroundColor = [UIColor clearColor];
        [headerViewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerTapped:)]];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, DeviceWidth, 14)];
        _timeLabel.textColor = [UIColor colorWithHex:0xffffff];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.text = _timeTxt;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_timeLabel];
        
        _amountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _timeLabel.y + _timeLabel.height + 20, DeviceWidth, 17)];
        _amountTitleLabel.textColor = [UIColor colorWithHex:0xffffff];
        _amountTitleLabel.text = _amountTxt;
        _amountTitleLabel.font = [UIFont systemFontOfSize:17];
        _amountTitleLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_amountTitleLabel];
        
        _amountValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _amountTitleLabel.y + _amountTitleLabel.height + 20, DeviceWidth, 39)];
        _amountValueLabel.text = _amountValueTxt;
        _amountValueLabel.textColor = [UIColor colorWithHex:0xff3d49];
        _amountValueLabel.font = [UIFont systemFontOfSize:42];
        _amountValueLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_amountValueLabel];
        
        [scrollView1 addSubview:headerViewBg];
        
        
        //日周月年
        _dayBtn = [self buttonWithIndex:0 title:@"日"];
        [scrollView1 addSubview:_dayBtn];
        _weekBtn = [self buttonWithIndex:1 title:@"周"];
        [scrollView1 addSubview:_weekBtn];
        _monthBtn = [self buttonWithIndex:2 title:@"月"];
        [scrollView1 addSubview:_monthBtn];
        _yearBtn = [self buttonWithIndex:3 title:@"年"];
        [scrollView1 addSubview:_yearBtn];
        
        //同比增...
        _compareView1 = [[MainPageDetailCompareView alloc] initWithFrame:CGRectMake(0, 225*SCREEN_H_SP + 44*SCREEN_H_SP, DeviceWidth / 3, 65)];
        [_compareView1 setTitle:@"" value:@"" valueFont:18];
        [_compareView1 setChartColor:Color(246, 190, 106)];
        [scrollView1 addSubview:_compareView1];
        _compareView1.selectTextColor = [UIColor whiteColor];
        _compareView1.originTextColor = [UIColor whiteColor];
        _compareView1.originBgColor = Color(148, 38, 45);
        _compareView1.selectBgColor = [UIColor colorWithHex:0xb3333a];
        _compareView1.selected = isDefaultCompareSelected;
        isDefaultCompareSelected = NO;
        
        _compareView2 = [[MainPageDetailCompareView alloc] initWithFrame:CGRectMake(DeviceWidth / 3, 225*SCREEN_H_SP + 44*SCREEN_H_SP, DeviceWidth / 3, 65)];
        [_compareView2 setTitle:@"" value:@"" valueFont:18];
        [_compareView2 setChartColor:Color(134, 204, 200)];
        [scrollView1 addSubview:_compareView2];
        _compareView2.selectTextColor = [UIColor whiteColor];
        _compareView2.originTextColor = [UIColor whiteColor];
        _compareView2.originBgColor = Color(148, 38, 45);
        _compareView2.selectBgColor = [UIColor colorWithHex:0xb3333a];
        
        _compareView3 = [[MainPageDetailCompareView alloc] initWithFrame:CGRectMake(DeviceWidth / 3 * 2, 225*SCREEN_H_SP + 44*SCREEN_H_SP, DeviceWidth / 3, 65)];
        [_compareView3 setTitle:@"" value:@"" valueFont:18];
        [_compareView3 setChartColor:Color(113, 167, 95)];
        [scrollView1 addSubview:_compareView3];
        _compareView3.selectTextColor = [UIColor whiteColor];
        _compareView3.originTextColor = [UIColor whiteColor];
        _compareView3.originBgColor = Color(148, 38, 45);
        _compareView3.selectBgColor = [UIColor colorWithHex:0xb3333a];
        
        _compareView1.title.frame = CGRectMake(17 * SCREEN_W_SP, 6 * SCREEN_H_SP+6, _compareView1.frame.size.width - 15 * SCREEN_W_SP, 14);
        _compareView1.chartColorView.frame = CGRectMake(5 * SCREEN_W_SP, _compareView1.title.frame.size.height / 2 + 4 * SCREEN_H_SP+6, 8 * SCREEN_W_SP, 8 * SCREEN_H_SP);
        
        _compareView2.title.frame = CGRectMake(17 * SCREEN_W_SP, 6 * SCREEN_H_SP+6, _compareView1.frame.size.width - 15 * SCREEN_W_SP, 14);
        _compareView2.chartColorView.frame = CGRectMake(5 * SCREEN_W_SP, _compareView1.title.frame.size.height / 2 + 4 * SCREEN_H_SP+6, 8 * SCREEN_W_SP, 8 * SCREEN_H_SP);
        
        _compareView3.title.frame = CGRectMake(17 * SCREEN_W_SP, 6 * SCREEN_H_SP+6, _compareView1.frame.size.width - 15 * SCREEN_W_SP, 14);
        _compareView3.chartColorView.frame = CGRectMake(5 * SCREEN_W_SP, _compareView1.title.frame.size.height / 2 + 4 * SCREEN_H_SP+6, 8 * SCREEN_W_SP, 8 * SCREEN_H_SP);
        
        [_compareView1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compareViewTaped:)]];
        [_compareView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compareViewTaped:)]];
        [_compareView3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(compareViewTaped:)]];
        
        
        UIView * _chartView;
        
        if (SCREEN_HEIGHT == 812) {
             _chartView = [[UIView alloc] initWithFrame:CGRectMake(10, _compareView1.frame.origin.y + _compareView1.frame.size.height + 30 *SCREEN_H_SP, DeviceWidth - 10 * 2, 200*SCREEN_H_SP + 104)];
        }
        else{
          
           _chartView = [[UIView alloc] initWithFrame:CGRectMake(10, _compareView1.frame.origin.y + _compareView1.frame.size.height + 30 *SCREEN_H_SP, DeviceWidth - 10 * 2, 200*SCREEN_H_SP)];
        }
        
        _chartView.backgroundColor = [UIColor greenColor];
        [scrollView1 addSubview:_chartView];
        //图表
//        _chartView = [CombinedChartView new];
//        _chartView.frame = ;
//        [scrollView1 addSubview:_chartView];
//
//        _chartView.backgroundColor = [UIColor clearColor];
//
//        _chartView.delegate = self;
        
        //禁止缩放
//        _chartView.pinchZoomEnabled = NO;
//        _chartView.doubleTapToZoomEnabled = NO;
//
//        _chartView.noDataTextDescription = @"";
//
//
//        //x轴
//        ChartXAxis *xAxis = _chartView.xAxis;
//        xAxis.labelPosition = XAxisLabelPositionBottom;
//        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
//        xAxis.labelTextColor = [UIColor grayColor];
//        xAxis.drawGridLinesEnabled = NO;
//        xAxis.granularity = 1.0; // only intervals of 1 day
//        xAxis.axisMinValue = -0.5;
//        xAxis.valueFormatter = self;
//
//        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//
//        //左边坐标轴
//        ChartYAxis *leftAxis = _chartView.leftAxis;
//        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
//        leftAxis.forceLabelsEnabled = NO;
//        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
//        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//        //    leftAxis.spaceTop = 0.5;
//        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//        leftAxis.drawAxisLineEnabled = NO;
//        leftAxis.drawGridLinesEnabled = YES;
//        leftAxis.gridColor = [UIColor lightGrayColor];
//        leftAxis.labelTextColor = xAxis.labelTextColor;
//        [leftAxis set_customAxisMax:YES];
//
//        //右边坐标轴
//        _chartView.rightAxis.enabled = NO;
//
//        //图注
//        _chartView.legend.enabled = NO;
//
//        //delegate
//        _chartView.delegate = self;
//
//        //禁止拖拽
//        _chartView.dragEnabled = NO;
//
//        //说明
//        _chartView.descriptionText = @"";
        
        [self didSelectDayWeekMonthYear:_dayBtn];
        
        [self refreshDatasAndViews];
        
        
        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        
        [sv CreateView];
        
        [scrollView1 addSubview:sv];

    } @catch (NSException *exception) {
       
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark -
- (double)reCalculateMaxYValue:(NSInteger)yMax {
    
    @try {
     
        NSString *yMaxStr = [NSString stringWithFormat:@"%ld", (long)yMax];
        NSInteger leftMath = [[yMaxStr substringToIndex:1] integerValue];
        NSInteger maxYValue = 0;
        if (yMaxStr.length > 2) {   // 超过4位数(万)判断第二位
            NSInteger secondNum = [[yMaxStr substringWithRange:NSMakeRange(1, 1)] integerValue];
            secondNum += 1;
            if (secondNum == 10) {
                leftMath += 1;
                maxYValue = leftMath * pow(10, yMaxStr.length - 1);
            } else {
                maxYValue = leftMath * pow(10, yMaxStr.length - 1) + secondNum * pow(10, yMaxStr.length - 2);
            }
        } else if(yMaxStr.length > 1) { // 4位数以下判断第一位
            maxYValue = (leftMath + 1) * pow(10, yMaxStr.length - 1);
        } else {    //个位数单独处理
            if (yMax > 0) {
                maxYValue = 10;
            } else {
                maxYValue = 1;
            }
        }
        
        return maxYValue;
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 日历响应并刷新数据
-(void)positionCalendarLocation{
    
    @try {
     
        __block __weak id gpsObserver;
        
        gpsObserver = [[NSNotificationCenter defaultCenter]
                       addObserverForName:@"calendarBtn"
                       object:nil
                       queue:[NSOperationQueue mainQueue]
                       usingBlock:^(NSNotification *note){
                           
                           [self refreshDatasWithCache:YES];
                           
                           calendarBtn.selected = NO;
                           
                           
                           DLog(@"run once, and only once!");
                           
                           [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                           
                       }];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



-(void)leftBarBtnClicked{
    
    
}


- (void)shareBtnClicked:(UIButton *)sender {
    
    @try {
       
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
        
        //    smvc.vi =  smvc.vi = [LOSHelper getSnapshotImage];
        
        [self presentViewController:smvc animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    @try {
       
        calendarBtn.selected = !calendarBtn.selected;
        if (calendarBtn.selected) {
            
            [self positionCalendarLocation];
            
            [sv showView];
            
            [scrollView1 setScrollEnabled:NO];
            
        } if (!calendarBtn.selected) {
            [sv backView];
            
            [scrollView1 setScrollEnabled:YES];
            
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - showView消失时，重置navigationItem.selected
-(void) calendarBtn:(NSNotification *)sender{
    
    @try {
        
        [self refreshDatasWithCache:YES];
        
        calendarBtn.selected = NO;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)headerTapped:(UITapGestureRecognizer *)gesture {
    
    @try {
       
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationForSelectDate object:nil];
        // [self.navigationController popViewControllerAnimated:NO];
        [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewController];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark -  获得点击的日期/时段

- (void)selectedDates:(NSNotification *)notification {
    
    @try {
       
        startDate  = [notification object][@"fromDate"];
        endDate = [notification object][@"toDate"];
        
        [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
        [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
        
        
        //导航栏日历按钮展示日历视图内选中日期
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM dd"];
        NSString *fromDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectFromDate];
        NSString *toDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectToDate];
        if ([fromDateString isEqualToString:toDateString] == YES) {
            [calendarBtn setTitle:fromDateString forState:UIControlStateNormal];
        }else {
            [calendarBtn setTitle:[NSString stringWithFormat:@"时 段"] forState:UIControlStateNormal];
        }
        
        [sv backView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求前的过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache {
    @try {
      
        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


#pragma mark - 0004接口请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
       
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString *time_level = [NSString stringWithFormat:@"%ld",_indexDWMY + 1];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.CorpBoardTrend"
                             dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                             
                                             [AppDatas sharedDatas].userCode, @"user_code",
                                             fromDateStr, @"start_date",
                                             toDateStr, @"end_date",
                                             
                                             @"7",@"time_range",
                                             time_level,@"time_level",
                                             nil]
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                self.dataDic = responseDic;
                                                
                                                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                                
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                                                [animationView stopAnimating1];
                                                
                                                [self refreshDatasAndViews];
                                                
                                            }
                                            else{
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                            }
                                            
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                            
                                            [animationView stopAnimating1];
                                            
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
        
        [self refreshDatasWithCache:YES];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


#pragma mark - inner functions

- (UIButton *)buttonWithIndex:(int)index title:(NSString *)title {
    
    @try {
       
        float btnWidth = DeviceWidth / 4;
        float btnHeight = 44*SCREEN_H_SP;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnWidth * index, 225*SCREEN_H_SP + 64, btnWidth , btnHeight);
        [button setTitle:title];
        [button addTarget:self action:@selector(didSelectDayWeekMonthYear:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0xb3333a] forState:UIControlStateSelected];
        [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5] forState:UIControlStateSelected];
        return button;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 日周月年切换
- (void)didSelectDayWeekMonthYear:(UIButton *)inBtn {
    
    @try {
        
        _dayBtn.selected = NO;
        _weekBtn.selected = NO;
        _monthBtn.selected = NO;
        _yearBtn.selected = NO;
        
        inBtn.selected = YES;
        if (_dayBtn.selected == YES) {
            _indexDWMY = 0;
        }else if (_weekBtn.selected == YES){
            _indexDWMY = 1;
        }else if (_monthBtn.selected == YES){
            _indexDWMY = 2;
        }else{
            _indexDWMY = 3;
        }
        
        [self refreshDatasWithCache:YES];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)compareViewTaped:(UITapGestureRecognizer *)gesture {
    
    @try {
        
        MainPageDetailCompareView *mpdcv = (MainPageDetailCompareView *)gesture.view;
        mpdcv.selected = !mpdcv.selected;
        
        [self refreshDatasAndViews];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


#pragma mark - 刷新数据和页面
- (void)refreshDatasAndViews {
    @try {
       
        //重设datas
        if (self.dataDic) {
            NSArray *array;
            
            array = self.dataDic[@"data"][@"data"]; // + by luod_2016.11.25
            
            NSDictionary *dic = array[entryIndex];
            
            
            _timeLabel.text = dic[@"totalDateText"];
            
            _amountTitleLabel.text = array[entryIndex][@"totalTitle"];
            _amountValueLabel.text = array[entryIndex][@"totalValue"];
            
            //设置同比增等...
            [_compareView1 setTitle:dic[@"compareList"][0][@"compareTitle"] value:dic[@"compareList"][0][@"compareValue"]];
            [_compareView2 setTitle:dic[@"compareList"][1][@"compareTitle"] value:dic[@"compareList"][1][@"compareValue"]];
            [_compareView3 setTitle:dic[@"compareList"][2][@"compareTitle"] value:dic[@"compareList"][2][@"compareValue"]];
            
            if (_compareView1.title.text.length > 3) {
                if (SCREEN_WIDTH <= 320) {
                    [_compareView1.title setX:17 * SCREEN_W_SP+10* SCREEN_W_SP];
                    [_compareView1.chartColorView setX:5 * SCREEN_W_SP+10* SCREEN_W_SP];
                }
                else if(SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320){
                    [_compareView1.title setX:17 * SCREEN_W_SP+14* SCREEN_W_SP];
                    [_compareView1.chartColorView setX:5 * SCREEN_W_SP+14* SCREEN_W_SP];
                }
                else {
                    [_compareView1.title setX:17 * SCREEN_W_SP+18* SCREEN_W_SP];
                    [_compareView1.chartColorView setX:5 * SCREEN_W_SP+18* SCREEN_W_SP];
                        }
        
    }
    else{
        if (SCREEN_WIDTH <= 375) {
            [_compareView1.title setX:17 * SCREEN_W_SP+25* SCREEN_W_SP];
            [_compareView1.chartColorView setX:5 * SCREEN_W_SP+25* SCREEN_W_SP];
        }
        else{
            [_compareView1.title setX:17 * SCREEN_W_SP+28* SCREEN_W_SP];
            [_compareView1.chartColorView setX:5 * SCREEN_W_SP+28* SCREEN_W_SP];
        }
        
    }
    
    
    if (_compareView2.title.text.length > 3) {
        
        if (SCREEN_WIDTH <= 320) {
            [_compareView2.title setX:17 * SCREEN_W_SP+10* SCREEN_W_SP];
            [_compareView2.chartColorView setX:5 * SCREEN_W_SP+10* SCREEN_W_SP];
        }
        else if(SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320){
            [_compareView2.title setX:17 * SCREEN_W_SP+14* SCREEN_W_SP];
            [_compareView2.chartColorView setX:5 * SCREEN_W_SP+14* SCREEN_W_SP];
        }
        else {
            [_compareView2.title setX:17 * SCREEN_W_SP+18* SCREEN_W_SP];
            [_compareView2.chartColorView setX:5 * SCREEN_W_SP+18* SCREEN_W_SP];
        }
        
    }
    else{
        if (SCREEN_WIDTH <= 375) {
            [_compareView2.title setX:17 * SCREEN_W_SP+25* SCREEN_W_SP];
            [_compareView2.chartColorView setX:5 * SCREEN_W_SP+25* SCREEN_W_SP];
        }
        else{
            [_compareView2.title setX:17 * SCREEN_W_SP+28* SCREEN_W_SP];
            [_compareView2.chartColorView setX:5 * SCREEN_W_SP+28* SCREEN_W_SP];
        }
        
    }
    
    
    if (_compareView3.title.text.length > 3) {
        if (SCREEN_WIDTH <= 320) {
            [_compareView3.title setX:17 * SCREEN_W_SP+10* SCREEN_W_SP];
            [_compareView3.chartColorView setX:5 * SCREEN_W_SP+10* SCREEN_W_SP];
        }
        else if(SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320){
            [_compareView3.title setX:17 * SCREEN_W_SP+14* SCREEN_W_SP];
            [_compareView3.chartColorView setX:5 * SCREEN_W_SP+14* SCREEN_W_SP];
        }
        else {
            [_compareView3.title setX:17 * SCREEN_W_SP+18* SCREEN_W_SP];
            [_compareView3.chartColorView setX:5 * SCREEN_W_SP+18* SCREEN_W_SP];
        }
        
    }
    else{
        
        if (SCREEN_WIDTH <= 375) {
            [_compareView3.title setX:17 * SCREEN_W_SP+25* SCREEN_W_SP];
            [_compareView3.chartColorView setX:5 * SCREEN_W_SP+25* SCREEN_W_SP];
        }
        else{
            [_compareView3.title setX:17 * SCREEN_W_SP+28* SCREEN_W_SP];
            [_compareView3.chartColorView setX:5 * SCREEN_W_SP+28* SCREEN_W_SP];
        }
        
    }
    
    
    //设置chart
    [self updateChartData];
}
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

#pragma mark - 装载数据
- (void)updateChartData
{
    @try {
     
//        CombinedChartData *data = [[CombinedChartData alloc] init];
//        data.lineData = [self generateLineData];
//        data.barData = [self generateBarData];
//
//        _chartView.xAxis.axisMaximum = data.xMax + 0.25 + 0.25;
//
//        [_chartView.leftAxis resetCustomAxisMax];
        
//        CGFloat numberY;
//
//        NSString * numberYS= [NSString stringWithFormat:@"%f",[data yMax]];
//        //  NSString * numberYString = [NSString stringWithFormat:@"%ld",[numberYS integerValue]];
//        numberY = [numberYS floatValue];
//
//        if (numberY < 1) {
//            numberY = 1;
//        }
//
//        if (numberY > 1 && numberY < 10) {
//            if (numberY > 5) {
//                numberY = numberY +2;
//            }
//            else{
//                numberY = numberY +1;
//            }
//        }
//
//        else if (numberY >= 10 && numberY < 100) {
//
//            //       if (numberY < 20) {
//            //            numberY = numberY + 2;
//            //        }
//            //       else{
//            //           numberY = numberY + 5;
//            //       }
//
//            if (numberY >= 10 && numberY < 20) {
//                numberY = numberY + 2;
//            }
//            else if (numberY >= 20 && numberY < 30) {
//                numberY = numberY + 4;
//            }
//            else if (numberY >= 80 && numberY < 100){
//                numberY = numberY + 7;
//            }
//            else{
//                numberY = numberY + 5;
//            }
//
//
//
//        }
//        else if (numberY >= 100 && numberY < 1000){
//
//            if (numberY >= 100 && numberY <= 200) {
//                numberY = numberY + 10;
//            }
//            else{
//
//                if (numberY > 200 && numberY <= 300) {
//                    numberY = numberY + 20;
//                }
//                else if (numberY > 300 && numberY <= 400) {
//                    numberY = numberY + 30;
//                }
//                else if (numberY > 400 && numberY <= 500){
//                    numberY = numberY + 40;
//                }
//                else{
//                    numberY = numberY + 65;
//                }
//            }
//
//        }
//        else if (numberY >= 1000 && numberY < 10000){
//
//            if (numberY >= 1000 && numberY <= 2000) {
//                numberY = numberY + 100;
//            }
//            else if (numberY > 2000 && numberY <= 3000){
//                numberY = numberY + 140;
//            }
//            else if (numberY > 3000 && numberY <= 4000){
//                numberY = numberY + 180;
//            }
//            else if (numberY > 4000 && numberY <= 5000){
//                numberY = numberY + 220;
//            }
//            else if (numberY > 5000 && numberY <= 6000){
//                numberY = numberY + 260;
//            }
//            else if (numberY > 6000 && numberY <= 7000){
//                numberY = numberY + 340;
//            }
//            else if (numberY > 7000 && numberY <= 8000){
//                numberY = numberY + 400;
//            }
//            else{
//                numberY = numberY + 450;
//            }
//
//
//        }
//        else if (numberY >= 10000 && numberY <100000){
//
//            if (numberY >= 10000 && numberY <= 20000) {
//                numberY = numberY + 1000;
//            }
//            else if (numberY > 20000 && numberY <= 30000){
//                numberY = numberY + 1400;
//            }
//            else if (numberY > 30000 && numberY <= 40000){
//                numberY = numberY + 1800;
//            }
//            else if (numberY > 40000 && numberY <= 50000){
//                numberY = numberY + 2200;
//            }
//            else if (numberY > 50000 && numberY <= 60000){
//                numberY = numberY + 2600;
//            }
//            else if (numberY > 60000 && numberY <= 70000){
//                numberY = numberY + 3400;
//            }
//            else if (numberY > 70000 && numberY <= 80000){
//                numberY = numberY + 4000;
//            }
//            else{
//                numberY = numberY + 4500;
//            }
//        }
//        else if (numberY >= 100000 && numberY <1000000){
//
//            if (numberY >= 100000 && numberY <= 200000) {
//                numberY = numberY + 10000;
//            }
//            else if (numberY > 200000 && numberY <= 300000){
//                numberY = numberY + 14000;
//            }
//            else if (numberY > 300000 && numberY <= 400000){
//                numberY = numberY + 18000;
//            }
//            else if (numberY > 400000 && numberY <= 500000){
//                numberY = numberY + 22000;
//            }
//            else if (numberY > 500000 && numberY <= 600000){
//                numberY = numberY + 26000;
//            }
//            else if (numberY > 600000 && numberY <= 700000){
//                numberY = numberY + 34000;
//            }
//            else if (numberY > 700000 && numberY <= 800000){
//                numberY = numberY + 40000;
//            }
//            else{
//                numberY = numberY + 45000;
//            }
//        }
//        else if (numberY >= 1000000 && numberY <10000000){
//
//            numberY = numberY + 250000;
//
//        }
//        else{
//            numberY = [data yMax];
//        }
//
//        //    if (numberYString.length == 2) {
//        //        numberY = [numberYString floatValue];
//        //
//        //        if (numberY > 20) {
//        //            numberY = numberY + 3;
//        //        }
//        //
//        //    }
//        //    else if (numberYString.length == 3){
//        //        numberY = [numberYString floatValue];
//        //        if (numberY > 100 && numberY < 200) {
//        //            numberY = numberY + 20;
//        //        }
//        //        else{
//        //            if (self.view.frame.size.width == 320) {
//        //                numberY = numberY + 65;
//        //            }
//        //            else{
//        //                numberY = numberY + 45;
//        //            }
//        //        }
//        //
//        //    }
//        //    else if (numberYString.length == 4){
//        //        numberY = [numberYString floatValue];
//        //        numberY = numberY + 400;
//        //
//        //    }
//        //    else if (numberYString.length == 5){
//        //        numberY = [numberYString floatValue];
//        //        numberY = numberY + 2500;
//        //
//        //    }
//        //    else if (numberYString.length == 6){
//        //        numberY = [numberYString floatValue];
//        //        numberY = numberY + 25000;
//        //
//        //    }
//        //    else if (numberYString.length == 7){
//        //        numberY = [numberYString floatValue];
//        //        numberY = numberY + 250000;
//        //
//        //    }
//        //    else{
//        //        numberY = [data yMax];
//        //    }
//        if (numberY == 0) {
//            [_chartView.leftAxis setAxisMaxValue:[self reCalculateMaxYValue:numberY]];
//        }
//        else{
//            [_chartView.leftAxis setAxisMaxValue:numberY];
//
//        }
//        _chartView.data = data;
//
//        [_chartView setNeedsDisplay];
//
//        ChartHighlight *hl = [[ChartHighlight alloc] initWithX:entryIndex dataSetIndex:0 stackIndex:0];
//        hl.dataIndex = 1;
//
//        [_chartView highlightValue:hl];
//
//        firstBarHeight = 2;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 折线图数据
//- (LineChartData *)generateLineData
//{
//    @try {
//
//        LineChartData *d = [[LineChartData alloc] init];
//
//        if (self.dataDic) {
//            NSArray *array;
//
//            array = self.dataDic[@"data"][@"data"];
//
//            if (_compareView1.selected) {
//                NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//                for (int i = 0; i < array.count; i++) {
//                    [values addObject:@([array[i][@"chartCompareList"][0][@"chartCompareValueLine"] doubleValue])];
//                }
//                LineChartDataSet *lcd = [self lineChartDataSetWithValues:values color:_compareView1.chartColor];
//                [d addDataSet:lcd];
//            }
//
//            if (_compareView2.selected) {
//                NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//                for (int i = 0; i < array.count; i++) {
//                    [values addObject:@([array[i][@"chartCompareList"][1][@"chartCompareValueLine"] doubleValue])];
//                }
//                LineChartDataSet *lcd = [self lineChartDataSetWithValues:values color:_compareView2.chartColor];
//                [d addDataSet:lcd];
//            }
//
//            if (_compareView3.selected) {
//                NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//                for (int i = 0; i < array.count; i++) {
//                    [values addObject:@([array[i][@"chartCompareList"][2][@"chartCompareValueLine"] doubleValue])];
//                }
//                LineChartDataSet *lcd1 = [self lineChartDataSetWithValues:values color:_compareView3.chartColor];
//                [d addDataSet:lcd1];
//            }
//
//        }
//
//        return d;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}


#pragma mark - 饼状图
//- (BarChartData *)generateBarData {
//
//    @try {
//
//        BarChartData *d = [[BarChartData alloc] init];
//
//        if (self.dataDic) {
//
//            NSArray *array;
//
//            array = self.dataDic[@"data"][@"data"];
//
//            NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//            for (int i = 0; i < array.count; i++) {
//                [values addObject:@([array[i][@"chartValue"] doubleValue])];
//            }
//            BarChartDataSet *bcd = [self barChartDataSetWithValues:values];
//            [d addDataSet:bcd];
//        }
//        if (d.dataSets && d.dataSets.count > 0) {
//            return d;
//        } else {
//            return nil;
//        }
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}


#pragma mark - 折线图数据设置
//- (LineChartDataSet *)lineChartDataSetWithValues:(NSArray <NSNumber *>*)values color:(UIColor *)color {
//
//    @try {
//
//        NSMutableArray *entries = [[NSMutableArray alloc] init];
//
//        for (int index = 0; index < values.count; index++)
//        {
//            [entries addObject:[[ChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//
//            if (entries.count == values.count) {
//                [entries addObject:[[ChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//            }
//        }
//
//        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Line DataSet"];
//        [set setColor:color];
//        set.lineWidth = 1.2;
//
//        set.drawCircleHoleEnabled = YES;
//        set.drawHorizontalHighlightIndicatorEnabled=NO;  //去掉线
//        [set setHighlightEnabled:NO];
//        [set setCircleColor:color];
//        set.circleRadius = 2.0;
//        set.circleHoleRadius = 0;
//        set.fillColor = color;
//        set.mode = LineChartModeLinear;
//        set.drawValuesEnabled = YES;
//        set.valueFont = [UIFont systemFontOfSize:13*SCREEN_H_SP];
//        set.valueColors = @[color];
//        set.axisDependency = AxisDependencyLeft;
//
//        return set;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}


#pragma mark - 饼状图数据设置
//- (BarChartDataSet *)barChartDataSetWithValues:(NSArray <NSNumber *>*)values {
//
//    @try {
//        yVals = [[NSMutableArray alloc] init];
//
//        for (int index = 0; index < values.count; index++)
//        {
//            [yVals addObject:[[BarChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//        }
//
//        BarChartData *data;
//        BarChartDataSet *set = nil;
//
//        set = [[BarChartDataSet alloc] initWithValues:yVals label:@"DataSet"];
//        set.drawValuesEnabled = NO;
//        [set setColor:[[UIColor grayColor] colorWithAlphaComponent:0.7]];
//        [set setHighlightColor:[UIColor redColor]];
//
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set];
//
//        data = [[BarChartData alloc] initWithDataSets:dataSets];
//
//        data.barWidth = 0.6f;
//
//        return set;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}

#pragma mark - ChartViewDelegate

//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//
//    @try {
//
//        entryIndex = entry.x;
//
//        //刷新上部三行数据
//        if (_indexDWMY == 0) {
//            _timeLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalDateText"];
//            _amountTitleLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalTitle"];
//            _amountValueLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalValue"];
//
//            //设置同比增等...
//            [_compareView1 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareValue"]];
//            [_compareView2 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareValue"]];
//            [_compareView3 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareValue"]];
//        }else if (_indexDWMY == 1){
//            _timeLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalDateText"];
//            _amountTitleLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalTitle"];
//            _amountValueLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalValue"];
//
//            //设置同比增等...
//            [_compareView1 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareValue"]];
//            [_compareView2 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareValue"]];
//            [_compareView3 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareValue"]];
//        }else if (_indexDWMY == 2){
//            _timeLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalDateText"];
//            _amountTitleLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalTitle"];
//            _amountValueLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalValue"];
//
//            //设置同比增等...
//            [_compareView1 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareValue"]];
//            [_compareView2 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareValue"]];
//            [_compareView3 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareValue"]];
//        }else{
//            _timeLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalDateText"];
//            _amountTitleLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalTitle"];
//            _amountValueLabel.text = self.dataDic[@"data"][@"data"][entryIndex][@"totalValue"];
//
//            //设置同比增等...
//            [_compareView1 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][0][@"compareValue"]];
//            [_compareView2 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][1][@"compareValue"]];
//            [_compareView3 setTitle:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareTitle"] value:self.dataDic[@"data"][@"data"][entryIndex][@"compareList"][2][@"compareValue"]];
//
//        }
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}


#pragma mark -
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    @try {
//
//        ChartHighlight *hl = [[ChartHighlight alloc] initWithX:entryIndex dataSetIndex:0 stackIndex:0];
//        hl.dataIndex = 1;
//
//        [chartView highlightValue:hl];
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//
//}
//
//#pragma mark - IChartAxisValueFormatter
//
//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//    @try {
//
//        if (self.dataDic) {
//            NSArray *array;
//
//            array = self.dataDic[@"data"][@"data"]; // + by luod_2016.11.25
//
//
//            NSInteger index = value;
//            NSString *str = [NSString stringWithString:array[index][@"xAxis"]];
//            str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//            return str;
//            //        return @"123\n321";
//        } else {
//            NSString *str = [NSNumber numberWithDouble:value].stringValue;
//            DLogObject(str);
//            return str;
//        }
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
        
         [animationView startAnimation];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    @try {
        
        if (scrollView.contentOffset.y <= -80) {
            
            if (animationView.tag == 0) {
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    
                    
                });
                
            }
            
            animationView.tag = 1;
            
        }else{
            
            //防止用户在下拉到contentOffset.y <= -50后不松手，然后又往回滑动，需要将值设为默认状态
            
            animationView.tag = 0;
            
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
     
        [animationView stopAnimating];
        
        
        if (scrollView.contentOffset.y <= -80) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        }
        
        if (animationView.tag == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                 scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [animationView startAnimation1];
                
                [self refreshDatasWithCache:YES];
                
            }];
            
            //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    animationView.tag = 0;
                    
                }];
                
            });
            
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"次页  MainPageDayDetailViewController_0004" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


@end

