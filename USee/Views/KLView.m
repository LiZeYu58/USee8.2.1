//
//  KLView.m
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



        // 店铺排行详情 －－ 客流



#import "KLView.h"
//#import "Charts.h"
#import "TableViewCellForKeLiuCell.h"
#import "TimeView.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "AnimationView.h"
#import "AppDelegate.h"
//ChartViewDelegate,,IChartAxisValueFormatter
@interface KLView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,TimeViewDelegate,UIScrollViewDelegate>
{
    
    UIScrollView * scrollView1;
    
    UIView * leftView;
    UIView * rightView;
    UIView * secondView;
    UITableView * tableViews ;
    
    TimeView * timeView;
    int index1;
    
    UIView *threeView;
    
    UILabel *tsLab1;
    
    UILabel *tsLab2;
    
    UILabel *tsLab3;
    
    UILabel *tsLab4;
    
    NSInteger selectedBtnIndex;  //区分点击日周月年
    
    
    UILabel * leftUpLab; //爱秀打开次数
    UILabel * leftDownLab;//同期
    
    UILabel * rightUpLab;
    
    UILabel * rightrDownLab;
    
    UILabel * rightDownLab;
    
    TableViewCellForKeLiuCell *cell;
    
    AnimationView * animationView;
    
   // AlterView *_alert;
    
    NSInteger firstCreate;
    
    UIView *lineup;
    
    UIView *linedown;
    
    
}

//@property (nonatomic, strong) LineChartView *chartView;
//
//@property (nonatomic, strong) LineChartView *chartView1;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSMutableArray *upTitleArr;
@property (nonatomic, strong) NSMutableArray *downTitleArr;

@property (nonatomic, strong) NSMutableArray *upNumArr;
@property (nonatomic, strong) NSMutableArray *downNumArr;

@end

@implementation KLView

#pragma mark - 懒加载
-(NSMutableArray *)upTitleArr{
    if (!_upTitleArr) {
        _upTitleArr = [NSMutableArray new];
    }
    return _upTitleArr;
}

-(NSMutableArray *)downTitleArr{
    if (!_downTitleArr) {
        _downTitleArr = [NSMutableArray new];
    }
    return _downTitleArr;
}

-(NSMutableArray *)upNumArr{
    if (!_upNumArr) {
        _upNumArr = [NSMutableArray new];
    }
    return _upNumArr;
}

-(NSMutableArray *)downNumArr{
    if (!_downNumArr) {
        _downNumArr = [NSMutableArray new];
    }
    return _downNumArr;
}


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
          index1 = 0;
        selectedBtnIndex = 0;
        
       // _alert = [AlterView new];
        
        firstCreate = 1;
        
        
         //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keliu111:) name:@"keliu111" object:nil];
        
//       [self refreshDatasWithCache:YES];
        
        //日历
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jjt4:) name:@"jjt4" object:nil];
    
    
        //orgCode
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeLiu:) name:@"KeLiu" object:nil];

    
    
    }
    return self;
}


//通知方法
- (void)KeLiu:(NSNotification *)notification {
    
    _storeCode = [notification object];
    
    //       [self refreshDatasWithCache:YES];
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];
    
    
}


#pragma mark - orgCode
-(void)receiveKeLiuCode:(NSString *)orgCode{
    
    _storeCode = orgCode;
 
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];

    
}

//通知方法
- (void)jjt4:(NSNotification *)notification {
    
    [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
    [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];

    
}

//通知方法
- (void)keliu:(NSDate *)fromDate :(NSDate *)toDate{
    
    [AppDatas sharedDatas].selectFromDate = fromDate;
    [AppDatas sharedDatas].selectToDate = toDate;
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];

    
}


#pragma mark - 接口请求前的过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)Codes{
    [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                        toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                        withCache:isUseCache
                        WithCode:Codes
                        ];
}

//弃用
-(void)keliu111:(NSNotification *)notif{
    

}


-(void)createUI{
    
   [scrollView1 removeFromSuperview];
    scrollView1 = nil;
    
    scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
    
    scrollView1.delegate =self;
    
    scrollView1.showsVerticalScrollIndicator = NO;
    
    scrollView1.contentSize = CGSizeMake(0, SCREEN_HEIGHT + 20 * SCREEN_H_SP);
    
       [self addSubview:scrollView1];
    
    
    animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 100)];
    
    animationView.layer.borderColor = [UIColor redColor].CGColor;
    
    
    [animationView Animation];
    
    [animationView Animation1];
    
    [scrollView1 addSubview:animationView];
    


    
    timeView = [[TimeView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50 *SCREEN_H_SP)];
    
    timeView.delegate = self;
    
    [timeView showTimeBtn];
    
    [scrollView1 addSubview:timeView];

    
    
 
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(0, timeView.frame.origin.y + timeView.frame.size.height, SCREEN_WIDTH / 2, 70 * SCREEN_H_SP)];
    
    leftView.backgroundColor = [UIColor whiteColor];
    
    [scrollView1 addSubview:leftView];
    
    leftUpLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 10 *SCREEN_H_SP, 150, 20 *SCREEN_H_SP)];

    
    leftUpLab.textColor = [UIColor colorWithHex:0x555555];
    
    leftUpLab.font = [UIFont systemFontOfSize:14];
    
    leftUpLab.textAlignment = NSTextAlignmentLeft;
    
    [leftView addSubview:leftUpLab];
    
    
    leftDownLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 40 *SCREEN_H_SP, 150, 20 *SCREEN_H_SP)];
    
    
    leftDownLab.textColor = [UIColor colorWithHex:0xba2932];
    
    leftDownLab.font = [UIFont systemFontOfSize:16];
    
    leftDownLab.textAlignment = NSTextAlignmentLeft;
    
    [leftView addSubview:leftDownLab];
    
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, timeView.frame.origin.y + timeView.frame.size.height, SCREEN_WIDTH / 2, 70 * SCREEN_H_SP)];
    
    rightView.backgroundColor = [UIColor whiteColor];
    
    [scrollView1 addSubview:rightView];
    

    rightUpLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 10 *SCREEN_H_SP, 80, 20 *SCREEN_H_SP)];
    
    
    rightUpLab.textColor = [UIColor colorWithHex:0x555555];
    
    rightUpLab.font = [UIFont systemFontOfSize:14];

    
    rightUpLab.textAlignment = NSTextAlignmentLeft;
    
    [rightView addSubview:rightUpLab];
    
    
    
    rightDownLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 40 *SCREEN_H_SP, 80, 20 *SCREEN_H_SP)];
    
    
    rightDownLab.font = [UIFont systemFontOfSize:16];
    
    rightDownLab.textColor = [UIColor colorWithHex:0xaf2a33];
    
    rightDownLab.textAlignment = NSTextAlignmentLeft;
    
    [rightView addSubview:rightDownLab];


    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 15 *SCREEN_H_SP, 1 * SCREEN_W_SP, 40 *SCREEN_H_SP)];
    
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    
    [rightView addSubview:line];

    secondView = [[UIView alloc]initWithFrame:CGRectMake(0, leftView.frame.origin.y + leftView.frame.size.height, SCREEN_WIDTH, 150 * SCREEN_H_SP)];
    
    [scrollView1 addSubview: secondView];
    
    UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 *SCREEN_H_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag1.image = [UIImage imageNamed:@"icon_会销客流图表指示点_红"];
    [secondView addSubview:imag1];
    
    tsLab1 = [[UILabel alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 60 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab1.textAlignment = NSTextAlignmentLeft;
    tsLab1.textColor = [UIColor colorWithHex:0xaf2a33];
    tsLab1.font = [UIFont systemFontOfSize:12];
    [secondView addSubview:tsLab1];
    
    UIImageView *imag2 = [[UIImageView alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 75 * SCREEN_W_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag2.image = [UIImage imageNamed:@"icon_会销客流图表指示点_灰"];
    [secondView addSubview:imag2];
    
    tsLab2 = [[UILabel alloc]initWithFrame:CGRectMake(imag2.frame.origin.x + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 60 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab2.textAlignment = NSTextAlignmentLeft;
    tsLab2.textColor = [UIColor colorWithHex:0x999999];
    tsLab2.font = [UIFont systemFontOfSize:12];
    [secondView addSubview:tsLab2];

    
    
//    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 30 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, secondView.frame.size.height - 40 * SCREEN_H_SP)];
//
//
//    [secondView addSubview:_chartView];
//
//
//    lineup = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31 * SCREEN_W_SP, 10,0.4, _chartView.frame.size.height - 25 * SCREEN_H_SP)];
//
//    lineup.backgroundColor = [UIColor redColor];
//
//    [_chartView addSubview:lineup];
//
//
//    _chartView.scaleXEnabled = NO;
//    _chartView.scaleYEnabled = NO;
//    _chartView.legend.enabled = NO;
//    _chartView.delegate = self;
//    _chartView.descriptionText = @"";
//    _chartView.noDataTextDescription = @"没有数据.";
//    _chartView.dragEnabled = NO;
//    [_chartView setScaleEnabled:NO];
//    _chartView.drawGridBackgroundEnabled = NO;
//    _chartView.pinchZoomEnabled = NO;
//    _chartView.backgroundColor = [UIColor whiteColor];
//    _chartView.legend.form = ChartLegendFormLine;
//    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//    _chartView.legend.textColor = UIColor.whiteColor;
//    _chartView.legend.position = ChartLegendPositionBelowChartLeft;
//
//    ChartXAxis *xAxis = _chartView.xAxis;
//    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
//    xAxis.labelPosition = XAxisLabelPositionBottom; // x轴下方显示数字
//    xAxis.valueFormatter =self;
//    xAxis.labelTextColor = [UIColor grayColor];
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.drawAxisLineEnabled = NO;
//
//    ChartYAxis *leftAxis = _chartView.leftAxis;
//    leftAxis.labelTextColor = [UIColor grayColor];
//    leftAxis.labelCount = 4;
//    leftAxis.axisMinimum = 0.0;
//    leftAxis.drawGridLinesEnabled = YES;
//    leftAxis.drawZeroLineEnabled = NO;
//    leftAxis.granularityEnabled = YES;
//    leftAxis.drawAxisLineEnabled = NO; //去掉left线
//
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.labelTextColor = UIColor.redColor;
//    //    rightAxis.axisMaximum = 900.0;
//    //    rightAxis.axisMinimum = -200.0;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.granularityEnabled = NO;
//    _chartView.rightAxis.enabled = NO; //去除右边线
    
     NSArray * cellArr = self.dataDic[@"data"][@"tail"];
    

    tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, secondView.frame.origin.y + secondView.frame.size.height, SCREEN_WIDTH, cellArr.count *50 * SCREEN_H_SP) style:UITableViewStylePlain];
    
    tableViews.dataSource = self;
    
    tableViews.delegate = self;
    
    tableViews.scrollEnabled = NO;
    
    tableViews.rowHeight = 50 * SCREEN_H_SP;
    
    [tableViews registerClass:[TableViewCellForKeLiuCell class] forCellReuseIdentifier:@"TableViewCellForKeLiuCell"];
    
    [scrollView1 addSubview:tableViews];
    
    
    
    threeView = [[UIView alloc]initWithFrame:CGRectMake(0, tableViews.frame.origin.y + tableViews.frame.size.height, SCREEN_WIDTH, 150 * SCREEN_H_SP)];
    [scrollView1 addSubview: threeView];
    UIImageView *imag3 = [[UIImageView alloc]initWithFrame:CGRectMake(10 *SCREEN_H_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag3.image = [UIImage imageNamed:@"icon_会销客流图表指示点_红"];
    [threeView addSubview:imag3];
    
    tsLab3 = [[UILabel alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 60 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab3.textAlignment = NSTextAlignmentLeft;
    tsLab3.textColor = [UIColor colorWithHex:0xaf2a33];
    tsLab3.font = [UIFont systemFontOfSize:12];
    [threeView addSubview:tsLab3];
    
    UIImageView *imag4 = [[UIImageView alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 75 * SCREEN_W_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag4.image = [UIImage imageNamed:@"icon_会销客流图表指示点_灰"];
    [threeView addSubview:imag4];
    
    tsLab4 = [[UILabel alloc]initWithFrame:CGRectMake(imag2.frame.origin.x + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 60 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab4.textAlignment = NSTextAlignmentLeft;
    tsLab4.textColor = [UIColor colorWithHex:0x999999];
    tsLab4.font = [UIFont systemFontOfSize:12];
    [threeView addSubview:tsLab4];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
    
    [self createChart1];
    
}

#pragma mark - 创建折线图1
-(void)createChart1{
    
//    _chartView1 = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 30 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, secondView.frame.size.height - 40 * SCREEN_H_SP)];
//
//    [threeView addSubview:_chartView1];
//
//    linedown = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31 * SCREEN_W_SP, 10,0.4, _chartView1.frame.size.height - 25 * SCREEN_H_SP)];
//
//    linedown.backgroundColor = [UIColor redColor];
//
//    [_chartView1 addSubview:linedown];
//
//    _chartView1.scaleXEnabled = NO;
//    _chartView1.scaleYEnabled = NO;
//    _chartView1.legend.enabled = NO;
//    _chartView1.delegate = self;
//    _chartView1.descriptionText = @"";
//    _chartView1.noDataTextDescription = @"没有数据.";
//
//    _chartView1.dragEnabled = NO;
//    [_chartView1 setScaleEnabled:NO];
//    _chartView1.drawGridBackgroundEnabled = NO;
//    _chartView1.pinchZoomEnabled = NO;
//    _chartView1.backgroundColor = [UIColor whiteColor];
//    _chartView1.legend.form = ChartLegendFormLine;
//    _chartView1.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//    _chartView1.legend.textColor = UIColor.whiteColor;
//    _chartView1.legend.position = ChartLegendPositionBelowChartLeft;
//
//    ChartXAxis *xAxis = _chartView1.xAxis;
//    xAxis.labelFont = [UIFont systemFontOfSize:11.f];
//    xAxis.labelPosition = XAxisLabelPositionBottom; // x轴下方显示数字
//    xAxis.valueFormatter = self;
//    xAxis.labelTextColor = [UIColor grayColor];
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.drawAxisLineEnabled = NO;
//
//    ChartYAxis *leftAxis = _chartView1.leftAxis;
//    leftAxis.labelTextColor = [UIColor grayColor];
//    leftAxis.labelCount = 4;
//    leftAxis.axisMinimum = 0.0;
//    leftAxis.drawGridLinesEnabled = YES;
//    leftAxis.drawZeroLineEnabled = NO;
//    leftAxis.granularityEnabled = YES;
//    leftAxis.drawAxisLineEnabled = NO; //去掉left线
//
//    ChartYAxis *rightAxis = _chartView1.rightAxis;
//    rightAxis.labelTextColor = UIColor.redColor;
//    //    rightAxis.axisMaximum = 900.0;
//    //    rightAxis.axisMinimum = -200.0;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.granularityEnabled = NO;
//    _chartView1.rightAxis.enabled = NO; //去除右边线
//
}

#pragma mark - 数据请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)Codesd{
    
     [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

    [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.StoreDetailPassengerFlow"
                 dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppDatas sharedDatas].userCode, @"user_code",
                                 Codesd, @"store_code",
                                 fromDateStr, @"startDate",
                                 toDateStr, @"endDate",
                                 nil]
                      withCache:YES
                        success:^(NSDictionary *responseDic) {
                            DLogObject(responseDic);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.dataDic = responseDic;
                            
                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                            
                            [UIView animateWithDuration:.4 animations:^{
                                
                                
                                [animationView stopAnimating1];
                                
                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                
                            }];
                            
                            if (firstCreate == 1) {
                                [self createUI];
                                
                                firstCreate = 2;
                                
                            }
 
                            
                            [self refreshDatasAndViews];
                            [self refreshDownDatasAndViews];
                            
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

-(void)refreshDatasAndViews{
    
#pragma mark - 刷新上部界面
    
    if (!self.dataDic) {
        return;
    }
    if (self.dataDic){
        
        NSDictionary *dic;
        if (selectedBtnIndex == 0) {
            dic = self.dataDic[@"data"][@"head"][0][@"dataDay"];
        } else if (selectedBtnIndex == 1) {
            dic = self.dataDic[@"data"][@"head"][0][@"dataWeek"];
        } else if (selectedBtnIndex == 2) {
            dic = self.dataDic[@"data"][@"head"][0][@"dataMonth"];
        } else if (selectedBtnIndex == 3) {
            dic = self.dataDic[@"data"][@"head"][0][@"dataYear"];
        }
        
        leftUpLab.text = self.dataDic[@"data"][@"head"][0][@"compareTitle"][0][@"piName"];
        
        NSArray * a = dic[@"compareList"];

        leftDownLab.text = dic[@"compareList"][a.count - 1][@"valueList"][0][@"value"];

        
        rightUpLab.text = self.dataDic[@"data"][@"head"][0][@"compareTitle"][1][@"piName"];
        
        NSString * str = dic[@"compareList"][0][@"valueList"][1][@"value"];
        
        
        
        
        NSRange range = [str rangeOfString:@","];
        
        
        
        if (range.length == 0) {
            
            rightDownLab.text = str;
                        
            rightDownLab.textColor = [UIColor colorWithHex:0xaf2a33];
            
            
        }else{

       
       str = [str substringToIndex:range.location];
       
        rightDownLab.text = str;
        
        
        NSString * str1 = dic[@"compareList"][a.count - 1][@"valueList"][1][@"value"];
        
        NSRange range1 = [str1 rangeOfString:@","];
        
        str1 = [str1 substringFromIndex:range1.location + 1];
        
        rightrDownLab.text = str1;
        
        }
        
        tsLab1.text = self.dataDic[@"data"][@"head"][0][@"chartTitle"][0][@"piName"];
        tsLab2.text = self.dataDic[@"data"][@"head"][0][@"chartTitle"][1][@"piName"];
        
        NSMutableArray <NSNumber *>* values1 = [NSMutableArray array];
        NSMutableArray <NSNumber *>* values2 = [NSMutableArray array];
        NSMutableArray <NSNumber *>* values3 = [NSMutableArray array];
        NSArray *chartListArr = dic[@"chartList"];
        
        
        for (int i = 0; i < chartListArr.count ; i ++) {
            [values1 addObject:@([dic[@"chartList"][i][@"valueList"][0][@"value"] doubleValue])];
            [values2 addObject:@([dic[@"chartList"][i][@"valueList"][1][@"value"] doubleValue])];
            [values3 addObject:@([dic[@"chartList"][i][@"xAxis"] doubleValue])];
        }
        [self UplineChartDataSetWithValues1:values1 WithValues2:values2 WithXvalues3:values3];
    }

}

#pragma mark -  上部表刷新
- ( void)UplineChartDataSetWithValues1:(NSArray <NSNumber *>*)values1 WithValues2:(NSArray <NSNumber *>*)values2 WithXvalues3:(NSArray <NSNumber *>*)values3{
    
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values1.count; index++)
    {
//        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:index y:values1[index].doubleValue]];
    }
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values2.count; index++)
    {
//        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:index y:values2[index].doubleValue]];
    }
    
//    LineChartDataSet *set1 = nil, *set2 = nil;
//
//    if (_chartView.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
//        set2 = (LineChartDataSet *)_chartView.data.dataSets[1];
//        set1.values = yVals1;
//        set2.values = yVals2;
//        [_chartView.data notifyDataChanged];
//        [_chartView notifyDataSetChanged];
//    }
//    else
//    {
//        set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
//        set1.axisDependency = AxisDependencyLeft;
//        [set1 setColor:[UIColor colorWithHex:0xba2932]];
//        [set1 setCircleColor:[UIColor colorWithHex:0xba2932]];
//        set1.lineWidth = 1.0;
//        set1.circleRadius = 3.0;
//        set1.fillAlpha = 65/255.0;
//        set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        set1.drawCircleHoleEnabled = NO;
//        set1.drawValuesEnabled = NO;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//
//        set2 = [[LineChartDataSet alloc] initWithValues:yVals2 label:@"DataSet 2"];
//        set2.axisDependency = AxisDependencyLeft;
//        [set2 setColor:[UIColor colorWithHex:0x999999]];
//        [set2 setCircleColor:[UIColor colorWithHex:0x999999]];
//        set2.lineWidth = 1.0;
//        set2.circleRadius = 3.0;
//        set2.fillAlpha = 65/255.0;
//        set2.fillColor = UIColor.redColor;
//        set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        set2.drawCircleHoleEnabled = NO;
//        set2.drawValuesEnabled = NO;
//        set2.drawHorizontalHighlightIndicatorEnabled = NO;
//
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//        [dataSets addObject:set2];
//
//        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//        [data setValueTextColor:UIColor.whiteColor];
//        [data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//        _chartView.data = data;
//    }
    
}


#pragma mark - 刷新下面数据
-(void)refreshDownDatasAndViews{
    if (!self.dataDic) {
        return;
    }
    if (self.dataDic){
        
        //刷新Cell
        NSArray *arr1;
        NSString * upNum;
        NSString * downNum;
        NSString * upTitle;
        NSString * downTitle;
        self.upNumArr = [NSMutableArray new];
        self.downNumArr = [NSMutableArray new];
        self.upTitleArr = [NSMutableArray new];
        self.downTitleArr = [NSMutableArray new];
        
        arr1 = self.dataDic[@"data"][@"tail"];
        
        for (int i = 0; i < arr1.count; i++) {
            NSDictionary * dic2 = arr1[i];
            
            upTitle = dic2[@"compareTitle"][0][@"piName"];
            downTitle = dic2[@"compareTitle"][1][@"piName"];
            [self.upTitleArr addObject:upTitle];
            [self.downTitleArr addObject:downTitle];
            
            if (selectedBtnIndex == 0) {
                NSArray * array2 = dic2[@"dataDay"][@"compareList"];
                
                NSDictionary * dic3 = array2.lastObject;
                
                upNum = dic3[@"valueList"][0][@"value"];
                downNum = dic3[@"valueList"][1][@"value"];
                
                if (upNum.length == 0) {
                    upNum = @"0";
                }
                
                if (downNum.length == 0) {
                    downNum = @"0";
                }
                
                [self.upNumArr addObject:upNum];
                [self.downNumArr addObject:downNum];
            } else if (selectedBtnIndex == 1) {
                NSArray * array2 = dic2[@"dataWeek"][@"compareList"];
                
                NSDictionary * dic3 = array2.lastObject;
                
                upNum = dic3[@"valueList"][0][@"value"];
                downNum = dic3[@"valueList"][1][@"value"];
                
                if (upNum.length == 0) {
                    upNum = @"0";
                }
                
                if (downNum.length == 0) {
                    
                    downNum = @"0";
                }
                
                
                [self.upNumArr addObject:upNum];
                [self.downNumArr addObject:downNum];
            } else if (selectedBtnIndex == 2) {
                NSArray * array2 = dic2[@"dataMonth"][@"compareList"];
                
                NSDictionary * dic3 = array2.lastObject;
                
                upNum = dic3[@"valueList"][0][@"value"];
                downNum = dic3[@"valueList"][1][@"value"];
                
                if (upNum.length == 0) {
                    upNum = @"0";
                }
                
                if (downNum.length == 0) {
                    downNum = @"0";
                }
                
                
                [self.upNumArr addObject:upNum];
                [self.downNumArr addObject:downNum];
            } else if (selectedBtnIndex == 3) {
                NSArray * array2 = dic2[@"dataYear"][@"compareList"];
                
                NSDictionary * dic3 = array2.lastObject;
                
                upNum = dic3[@"valueList"][0][@"value"];
                downNum = dic3[@"valueList"][1][@"value"];
                
                if (upNum.length == 0) {
                    upNum = @"0";
                }
                
                if (downNum.length == 0) {
                    downNum = @"0";
                }
                
                [self.upNumArr addObject:upNum];
                [self.downNumArr addObject:downNum];
            }
        }
        
        [self refreshSomeViews];
        
        [tableViews reloadData];
    }
}


#pragma mark - 单元格以外的下部刷新
-(void)refreshSomeViews{
        
        tsLab3.text = self.dataDic[@"data"][@"tail"][index1][@"chartTitle"][0][@"piName"];
        tsLab4.text = self.dataDic[@"data"][@"tail"][index1][@"chartTitle"][1][@"piName"];
        
        NSDictionary *dic;
        if (selectedBtnIndex == 0) {
            dic = self.dataDic[@"data"][@"tail"][index1][@"dataDay"];
        } else if (selectedBtnIndex == 1) {
            dic = self.dataDic[@"data"][@"tail"][index1][@"dataWeek"];
        } else if (selectedBtnIndex == 2) {
            dic = self.dataDic[@"data"][@"tail"][index1][@"dataMonth"];
        } else if (selectedBtnIndex == 3) {
            dic = self.dataDic[@"data"][@"tail"][index1][@"dataYear"];
        }

        NSMutableArray <NSNumber *>* values1 = [NSMutableArray array];
        NSMutableArray <NSNumber *>* values2 = [NSMutableArray array];
        NSMutableArray <NSNumber *>* values3 = [NSMutableArray array];
        NSArray *chartListArr = dic[@"chartList"];
        
        for (int i = 0; i < chartListArr.count ; i ++) {
            [values1 addObject:@([dic[@"chartList"][i][@"valueList"][0][@"value"] doubleValue])];
            [values2 addObject:@([dic[@"chartList"][i][@"valueList"][1][@"value"] doubleValue])];
            [values3 addObject:@([dic[@"chartList"][i][@"xAxis"] doubleValue])];
        }
        [self downLineChartDataSetWithValues1:values1 WithValues2:values2 WithXvalues3:values3];
}

#pragma mark - 下部表刷新
- ( void)downLineChartDataSetWithValues1:(NSArray <NSNumber *>*)values1 WithValues2:(NSArray <NSNumber *>*)values2 WithXvalues3:(NSArray <NSNumber *>*)values3{
        
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values1.count; index++)
    {
//        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:index y:values1[index].doubleValue]];
    }
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values2.count; index++)
    {
//        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:index y:values2[index].doubleValue]];
    }
    
//        LineChartDataSet *set1 = nil, *set2 = nil;
//
//        if (_chartView1.data.dataSetCount > 0)
//        {
//            set1 = (LineChartDataSet *)_chartView1.data.dataSets[0];
//            set2 = (LineChartDataSet *)_chartView1.data.dataSets[1];
//            set1.values = yVals1;
//            set2.values = yVals2;
//            [_chartView1.data notifyDataChanged];
//            [_chartView1 notifyDataSetChanged];
//        }
//        else
//        {
//            set1 = [[LineChartDataSet alloc] initWithValues:yVals1 label:@"DataSet 1"];
//            set1.axisDependency = AxisDependencyLeft;
//            [set1 setColor:[UIColor colorWithHex:0xba2932]];
//            [set1 setCircleColor:[UIColor colorWithHex:0xba2932]];
//            set1.lineWidth = 1.0;
//            set1.circleRadius = 3.0;
//            set1.fillAlpha = 65/255.0;
//            set1.fillColor = [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f];
//            set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set1.drawCircleHoleEnabled = NO;
//            set1.drawValuesEnabled = NO;
//
//            set2 = [[LineChartDataSet alloc] initWithValues:yVals2 label:@"DataSet 2"];
//            set2.axisDependency = AxisDependencyLeft;
//            [set2 setColor:[UIColor colorWithHex:0x999999]];
//            [set2 setCircleColor:[UIColor colorWithHex:0x999999]];
//            set2.lineWidth = 1.0;
//            set2.circleRadius = 3.0;
//            set2.fillAlpha = 65/255.0;
//            set2.fillColor = UIColor.redColor;
//            set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set2.drawCircleHoleEnabled = NO;
//            set2.drawValuesEnabled = NO;
//
//            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//            [dataSets addObject:set1];
//            [dataSets addObject:set2];
//
//            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//            [data setValueTextColor:UIColor.whiteColor];
//            [data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//            _chartView1.data = data;
//        }
   
}


#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _upTitleArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForKeLiuCell"];
    cell.upNameLab.text = _upTitleArr[indexPath.row];
    cell.downNameLab.text = _downTitleArr[indexPath.row];
    cell.upNumLab.text = _upNumArr[indexPath.row];
    cell.downNumLab.text = _downNumArr[indexPath.row];
    if (indexPath.row == index1) {
        
        [cell.imgBtn setImage:[UIImage imageNamed:@"icon_店铺详情_会销客流指标选中箭头"] forState:UIControlStateNormal];
        
        
        cell.upNameLab.textColor = [UIColor colorWithHex:0xcb2e3d];
        
        
        cell.upNumLab.textColor = [UIColor colorWithHex:0xcb2e3d];
        
        cell.backgroundColor = [UIColor whiteColor];
        
    }else{
        
        [cell.imgBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        cell.upNameLab.textColor = [UIColor colorWithHex:0x555555];
        
        cell.upNumLab.textColor = [UIColor colorWithHex:0x555555];
        
        cell.backgroundColor = [UIColor colorWithHex:0xededed];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    index1 =(int)indexPath.row;
    
    [self refreshSomeViews];
    
     [tableView reloadData];
    
    //icon_店铺详情_会销客流指标选中箭头@2x
    
}


#pragma mark - 日周月年回调
- (void)TimeView:(TimeView *)timeView index:(NSInteger)index{
    
    selectedBtnIndex = index;
    
    [self refreshDatasAndViews];
    [self refreshDownDatasAndViews];
    
}

#pragma mark - 选中折线图值的回调
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    DLog(@"%ld-------------------------------",(long)highlight.dataSetIndex);
//
//    if (chartView == _chartView) {
//
//        lineup.hidden = YES;
//
//
//        if (self.dataDic){
//
//
//            NSDictionary *dic1;
//            if (selectedBtnIndex == 0) {
//                dic1 = self.dataDic[@"data"][@"head"][0][@"dataDay"];
//            } else if (selectedBtnIndex == 1) {
//                dic1 = self.dataDic[@"data"][@"head"][0][@"dataWeek"];
//            } else if (selectedBtnIndex == 2) {
//                dic1 = self.dataDic[@"data"][@"head"][0][@"dataMonth"];
//            } else if (selectedBtnIndex == 3) {
//                dic1 = self.dataDic[@"data"][@"head"][0][@"dataYear"];
//            }
//
//            NSArray * a = dic1[@"compareList"];
//
//            int h = highlight.x;
//
//
//            leftDownLab.text = a[h][@"valueList"][0][@"value"];
//            rightDownLab.text = a[h][@"valueList"][1][@"value"];
//
//
//        }
//    }else if (chartView == _chartView1){
//
//        linedown.hidden = YES;
//
//        NSArray *arr1;
//        NSString * upNum;
//        NSString * downNum;
//        NSString * upTitle;
//        NSString * downTitle;
//        self.upNumArr = [NSMutableArray new];
//        self.downNumArr = [NSMutableArray new];
//        self.upTitleArr = [NSMutableArray new];
//        self.downTitleArr = [NSMutableArray new];
//
//        arr1 = self.dataDic[@"data"][@"tail"];
//
//        int h = highlight.x;
//
//        for (int i = 0; i < arr1.count; i++) {
//            NSDictionary * dic2 = arr1[i];
//
//            upTitle = dic2[@"compareTitle"][0][@"piName"];
//            downTitle = dic2[@"compareTitle"][1][@"piName"];
//            [self.upTitleArr addObject:upTitle];
//            [self.downTitleArr addObject:downTitle];
//
//            if (selectedBtnIndex == 0) {
//                NSArray * array2 = dic2[@"dataDay"][@"compareList"];
//
//
//            upNum = array2[h][@"valueList"][0][@"value"];
//            downNum = array2[h][@"valueList"][1][@"value"];
//
//                if (upNum.length == 0) {
//                    upNum = @"0";
//                }
//
//                if (downNum.length == 0) {
//                    downNum = @"0";
//                }
//
//                [self.upNumArr addObject:upNum];
//                [self.downNumArr addObject:downNum];
//            } else if (selectedBtnIndex == 1) {
//                NSArray * array2 = dic2[@"dataWeek"][@"compareList"];
//
//                upNum = array2[h][@"valueList"][0][@"value"];
//                downNum = array2[h][@"valueList"][1][@"value"];
//
//
//                if (upNum.length == 0) {
//                    upNum = @"0";
//                }
//
//                if (downNum.length == 0) {
//
//                    downNum = @"0";
//                }
//
//
//                [self.upNumArr addObject:upNum];
//                [self.downNumArr addObject:downNum];
//            } else if (selectedBtnIndex == 2) {
//                NSArray * array2 = dic2[@"dataMonth"][@"compareList"];
//
//                upNum = array2[h][@"valueList"][0][@"value"];
//                downNum = array2[h][@"valueList"][1][@"value"];
//
//                if (upNum.length == 0) {
//                    upNum = @"0";
//                }
//
//                if (downNum.length == 0) {
//                    downNum = @"0";
//                }
//
//
//                [self.upNumArr addObject:upNum];
//                [self.downNumArr addObject:downNum];
//            } else if (selectedBtnIndex == 3) {
//                NSArray * array2 = dic2[@"dataYear"][@"compareList"];
//
//                upNum = array2[h][@"valueList"][0][@"value"];
//                downNum = array2[h][@"valueList"][1][@"value"];
//
//                if (upNum.length == 0) {
//                    upNum = @"0";
//                }
//
//                if (downNum.length == 0) {
//                    downNum = @"0";
//                }
//
//                [self.upNumArr addObject:upNum];
//                [self.downNumArr addObject:downNum];
//            }
//        }
//
//        [tableViews reloadData];
//
//    }
//
//    DLog(@"chartValueSelected");
//}
//
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//
//    if (chartView == _chartView1){
//
//    }
//
//    DLog(@"chartValueNothingSelected");
//}
//
//
//#pragma mark - IChartAxisValueFormatter
//
//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//
//    NSArray *chartListArr;
//
//    if (_chartView) {
//
//        NSDictionary *dic;
//        if (selectedBtnIndex == 0) {
//            dic = self.dataDic[@"data"][@"head"][0][@"dataDay"];
//        } else if (selectedBtnIndex == 1) {
//            dic = self.dataDic[@"data"][@"head"][0][@"dataWeek"];
//        } else if (selectedBtnIndex == 2) {
//            dic = self.dataDic[@"data"][@"head"][0][@"dataMonth"];
//        } else if (selectedBtnIndex == 3) {
//            dic = self.dataDic[@"data"][@"head"][0][@"dataYear"];
//        }
//
//        chartListArr = dic[@"chartList"];
//
//    }else if (_chartView1){
//
//        NSDictionary *dic;
//        if (selectedBtnIndex == 0) {
//            dic = self.dataDic[@"data"][@"tail"][index1][@"dataDay"];
//        } else if (selectedBtnIndex == 1) {
//            dic = self.dataDic[@"data"][@"tail"][index1][@"dataWeek"];
//        } else if (selectedBtnIndex == 2) {
//            dic = self.dataDic[@"data"][@"tail"][index1][@"dataMonth"];
//        } else if (selectedBtnIndex == 3) {
//            dic = self.dataDic[@"data"][@"tail"][index1][@"dataYear"];
//        }
//
//        chartListArr = dic[@"chartList"];
//
//
//    }
//
//    if (self.dataDic) {
//
//        NSInteger index = value ;
//        NSString *str = [NSString stringWithString:chartListArr[index][@"xAxis"]];
//        str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//        return str;
//        //        return @"123\n321";
//    } else {
//        NSString *str = [NSNumber numberWithDouble:value].stringValue;
//        DLogObject(str);
//        return str;
//    }
//
//}


#pragma mark - scrollView 回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [animationView startAnimation];
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
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
}

#pragma mark - 即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    [animationView stopAnimating];
    
    
    if (scrollView.contentOffset.y <= -80) {

    }
    
    if (animationView.tag == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            [animationView startAnimation1];
            
            [self refreshDatasWithCache:YES WithCode:_storeCode];

            
            scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
            
        }];
        
        //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:.3 animations:^{
                
                animationView.tag = 0;
                
                
            }];
            
        });
        
    }
    
}



@end
