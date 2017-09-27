//
//  HXView.m
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.



    // 店铺排行详情页 －－会销



#import "HXView.h"
//#import "Charts.h"
#import "TableViewCellForHuiXiaoCell.h"
#import "TimeView.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "AnimationView.h"
#import "AppDelegate.h"

//ChartViewDelegate,,IChartAxisValueFormatter
@interface HXView ()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,TimeViewDelegate,UIScrollViewDelegate>
{
    UIScrollView * scrollView1;
    UIView * leftView;
    UIView * rightView;
    UIView * secondView;
    UIView * threeView;
    UITableView * tableViews ;
    NSInteger selectedBtnIndex;  //区分点击日周月年
    NSInteger selectedViewIndex; // 点击最上面两个view区分
    NSInteger index1;    //默认选择第一个单元格
    NSInteger highlighterX; //点击下半部图表的x轴
    TimeView * timeView; //日周月年
    UILabel * leftUpLab; //爱秀打开次数
    UILabel * leftDownLab;//同期
    UILabel * tsLab1;//爱秀打开次数
    UILabel * tsLab2;//同期值
    UILabel * tsLab3;//爱秀打开次数
    UILabel * tsLab4;//同期值
    UILabel * rightUpLab;//联系次数(生日/非生日)
    UILabel * rightDownLab;//同期
    UILabel * leftrLab;//左view右上
    UILabel * leftrLab1;//左view右下
    UILabel * rightrLab;//右view右上
    UILabel * rightrLab1;//右view右下
    
    
    TableViewCellForHuiXiaoCell *cell;
    
    AnimationView * animationView;
    

   // AlterView *_alert;

    NSInteger firstCreate;
    
    
    UIView * line;
    
    UIView * line1;

    
    
    
}
//@property (nonatomic, strong) LineChartView *chartView;
//@property (nonatomic, strong) LineChartView *chartView1;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *upTitleArr;
@property (nonatomic, strong) NSMutableArray *downTitleArr;
@property (nonatomic, strong) NSMutableArray *upNumArr;
@property (nonatomic, strong) NSMutableArray *downNumArr;

@end

@implementation HXView

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

#pragma mark - 初始化
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        selectedViewIndex = 0;
        selectedBtnIndex = 0;
        index1 = 0;
        
        //_alert = [AlterView new];
        
        firstCreate = 1;
        
        
        // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(huixiao111:) name:@"huixiao111" object:nil];
        
        //日历
        
         //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jjt3:) name:@"jjt3" object:nil];
        
        
        
        //orgCode
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HuiXiao:) name:@"HuiXiao" object:nil];

        
        
    }
    return self;
}


//通知方法
- (void)HuiXiao:(NSNotification *)notification {
    
    _storeCode = [notification object];
    
//       [self refreshDatasWithCache:YES];
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];
    
    
}


//orgCode 通知方法
-(void)receiveHuiXiaoCode:(NSString *)orgCode{
    
    _storeCode = orgCode;

    [self refreshDatasWithCache:YES WithCode:_storeCode];
    
    
    
}

//通知方法
- (void)jjt3:(NSNotification *)notification {
    
    [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
    [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];
    
//    [self refreshDatasWithCache:YES];
    
}

//通知方法
- (void)huixiao:(NSDate *)fromDate :(NSDate *)toDate{
    
    [AppDatas sharedDatas].selectFromDate = fromDate;
    [AppDatas sharedDatas].selectToDate = toDate;
    
    [self refreshDatasWithCache:YES WithCode:_storeCode];
    
}


#pragma mark - 接口请求过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache WithCode:Code{
    [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                        toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                        withCache:isUseCache
                        WithCode:Code
                        ];
}


//弃用
-(void)huixiao111:(NSNotification *)notif{
    
    
}


#pragma mark - 创建UI
-(void)createUI{
    

    [scrollView1 removeFromSuperview];
    scrollView1 = nil;
    
    scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.userInteractionEnabled = YES;
    scrollView1.delegate =self;
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
    leftView.backgroundColor = [UIColor colorWithHex:0xffffff];
    [scrollView1 addSubview:leftView];

    UITapGestureRecognizer* leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [leftView addGestureRecognizer:leftTap];
    leftTap.delegate = self;
    leftTap.cancelsTouchesInView = NO;
    
    leftUpLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 6 * SCREEN_H_SP, SCREEN_WIDTH / 2, 14 * SCREEN_H_SP)];
    leftUpLab.textAlignment = NSTextAlignmentLeft;
    leftUpLab.textColor = [UIColor colorWithHex:0x555555];
    leftUpLab.font = [UIFont systemFontOfSize:14];
    [leftView addSubview:leftUpLab];
    
    leftDownLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, leftUpLab.frame.origin.y + 24 * SCREEN_H_SP, 50 * SCREEN_W_SP, 14 * SCREEN_H_SP)];
    leftDownLab.textAlignment = NSTextAlignmentLeft;
    leftDownLab.textColor = [UIColor colorWithHex:0x999999];
    leftDownLab.font = [UIFont systemFontOfSize:13];
    [leftView addSubview:leftDownLab];
    
    leftrLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 70* SCREEN_W_SP, leftUpLab.frame.origin.y + 24 * SCREEN_H_SP, 60 * SCREEN_W_SP, 14 * SCREEN_H_SP)];
//    leftrLab.text = @"假数据";
    leftrLab.textAlignment = NSTextAlignmentRight;
    leftrLab.textColor = [UIColor colorWithHex:0x555555];
    leftrLab.font = [UIFont systemFontOfSize:16];
    [leftView addSubview:leftrLab];
    
    leftrLab1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150* SCREEN_W_SP, leftrLab.frame.origin.y + 20 * SCREEN_H_SP, 140 * SCREEN_W_SP, 14 * SCREEN_H_SP)];
//    leftrLab1.text = @"假数据";
    leftrLab1.textAlignment = NSTextAlignmentRight;
    leftrLab1.textColor = [UIColor colorWithHex:0x888888];
    leftrLab1.font = [UIFont systemFontOfSize:13];
    [leftView addSubview:leftrLab1];
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, timeView.frame.origin.y + timeView.frame.size.height, SCREEN_WIDTH / 2, 70 * SCREEN_H_SP)];
    rightView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [scrollView1 addSubview:rightView];
    
    UITapGestureRecognizer* rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [rightView addGestureRecognizer:rightTap];
    rightTap.delegate = self;
    rightTap.cancelsTouchesInView = NO;
    
    rightUpLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 6 * SCREEN_H_SP, (SCREEN_WIDTH -20 * SCREEN_W_SP)  / 2, 14 * SCREEN_H_SP)];
    rightUpLab.textColor = [UIColor colorWithHex:0x555555];
    rightUpLab.textAlignment = NSTextAlignmentLeft;
    rightUpLab.font = [UIFont systemFontOfSize:14];
    [rightView addSubview:rightUpLab];
    
    rightDownLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, rightUpLab.frame.origin.y + 24 * SCREEN_H_SP, 50 * SCREEN_W_SP, 20 * SCREEN_H_SP)];
    rightDownLab.textAlignment = NSTextAlignmentLeft;
    rightDownLab.textColor = [UIColor colorWithHex:0x999999];
    rightDownLab.font = [UIFont systemFontOfSize:13];
    [rightView addSubview:rightDownLab];
    
    rightrLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 100* SCREEN_W_SP, rightUpLab.frame.origin.y + 24 * SCREEN_H_SP, 90 * SCREEN_W_SP, 14 * SCREEN_H_SP)];
//    rightrLab.text = @"假数据";
    rightrLab.textAlignment = NSTextAlignmentRight;
    rightrLab.textColor = [UIColor colorWithHex:0x555555];
    rightrLab.font = [UIFont systemFontOfSize:15];
    [rightView addSubview:rightrLab];
    
    rightrLab1 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 150* SCREEN_W_SP, rightrLab.frame.origin.y + 20 * SCREEN_H_SP, 140 * SCREEN_W_SP, 14 * SCREEN_H_SP)];
//    rightrLab1.text = @"假数据";
    rightrLab1.textAlignment = NSTextAlignmentRight;
    rightrLab1.textColor = [UIColor colorWithHex:0x888888];
    rightrLab1.font = [UIFont systemFontOfSize:13];
    [rightView addSubview:rightrLab1];
    
    secondView = [[UIView alloc]initWithFrame:CGRectMake(0, leftView.frame.origin.y + leftView.frame.size.height, SCREEN_WIDTH, 150 * SCREEN_H_SP)];
    [scrollView1 addSubview: secondView];
    
    UIImageView *imag1 = [[UIImageView alloc]initWithFrame:CGRectMake(10 *SCREEN_H_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag1.image = [UIImage imageNamed:@"icon_会销客流图表指示点_红"];
    [secondView addSubview:imag1];
    
    tsLab1 = [[UILabel alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 100 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab1.textAlignment = NSTextAlignmentLeft;
    tsLab1.textColor = [UIColor colorWithHex:0xaf2a33];
    tsLab1.font = [UIFont systemFontOfSize:12];
    [secondView addSubview:tsLab1];
    
    UIImageView *imag2 = [[UIImageView alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 115 * SCREEN_W_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag2.image = [UIImage imageNamed:@"icon_会销客流图表指示点_灰"];
    [secondView addSubview:imag2];
    
    tsLab2 = [[UILabel alloc]initWithFrame:CGRectMake(imag2.frame.origin.x + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 100 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab2.textAlignment = NSTextAlignmentLeft;
    tsLab2.textColor = [UIColor colorWithHex:0x999999];
    tsLab2.font = [UIFont systemFontOfSize:12];
    [secondView addSubview:tsLab2];
    
//    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 30 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, secondView.frame.size.height - 40 * SCREEN_H_SP)];
//    [secondView addSubview:_chartView];
//
//    line = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31 * SCREEN_W_SP, 10,0.4, _chartView.frame.size.height - 25 * SCREEN_H_SP)];
//
//    line.backgroundColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//
//    [_chartView addSubview:line];
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
////    rightAxis.axisMaximum = 900.0;
////    rightAxis.axisMinimum = -200.0;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.granularityEnabled = NO;
//     _chartView.rightAxis.enabled = NO; //去除右边线
//
    NSArray * cellArr = self.dataDic[@"data"][@"tail"];

    tableViews = [[UITableView alloc]initWithFrame:CGRectMake(0, secondView.frame.origin.y + secondView.frame.size.height, SCREEN_WIDTH ,cellArr.count * 50 * SCREEN_H_SP) style:UITableViewStylePlain];
    tableViews.dataSource = self;
    tableViews.delegate = self;
    tableViews.scrollEnabled = NO;
    tableViews.rowHeight = 50 * SCREEN_H_SP;
    tableViews.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [tableViews registerClass:[TableViewCellForHuiXiaoCell class] forCellReuseIdentifier:@"TableViewCellForHuiXiaoCell"];
    [scrollView1 addSubview:tableViews];
    
    threeView = [[UIView alloc]initWithFrame:CGRectMake(0, tableViews.frame.origin.y + tableViews.frame.size.height, SCREEN_WIDTH, 150 * SCREEN_H_SP)];
    [scrollView1 addSubview: threeView];
    UIImageView *imag3 = [[UIImageView alloc]initWithFrame:CGRectMake(10 *SCREEN_H_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag3.image = [UIImage imageNamed:@"icon_会销客流图表指示点_红"];
    [threeView addSubview:imag3];
    
    tsLab3 = [[UILabel alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 100 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab3.textAlignment = NSTextAlignmentLeft;
    tsLab3.textColor = [UIColor colorWithHex:0xaf2a33];
    tsLab3.font = [UIFont systemFontOfSize:12];
    [threeView addSubview:tsLab3];
    
    UIImageView *imag4 = [[UIImageView alloc]initWithFrame:CGRectMake(imag1.frame.size.width + 115 * SCREEN_W_SP, 13 * SCREEN_H_SP, 5, 5)];
    imag4.image = [UIImage imageNamed:@"icon_会销客流图表指示点_灰"];
    [threeView addSubview:imag4];
    
    tsLab4 = [[UILabel alloc]initWithFrame:CGRectMake(imag2.frame.origin.x + 15 *SCREEN_W_SP,10 * SCREEN_H_SP, 100 * SCREEN_W_SP, 10 * SCREEN_H_SP)];
    tsLab4.textAlignment = NSTextAlignmentLeft;
    tsLab4.textColor = [UIColor colorWithHex:0x999999];
    tsLab4.font = [UIFont systemFontOfSize:12];
    [threeView addSubview:tsLab4];
    [self createChart1];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
    
}

#pragma mark - 创建第二个表
-(void)createChart1{
    
//    _chartView1 = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 30 * SCREEN_H_SP, SCREEN_WIDTH - 20 * SCREEN_W_SP, secondView.frame.size.height - 40 * SCREEN_H_SP)];
//    [threeView addSubview:_chartView1];
//
//
//    line1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 31 * SCREEN_W_SP, 10,0.4, _chartView.frame.size.height - 25 * SCREEN_H_SP)];
//
//    line1.backgroundColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//
//    [_chartView1 addSubview:line1];
//
//
//
//
//    _chartView1.scaleXEnabled = NO;
//    _chartView1.scaleYEnabled = NO;
//    _chartView1.legend.enabled = NO;
//    _chartView1.delegate = self;
//    _chartView1.descriptionText = @"";
//    _chartView1.noDataTextDescription = @"没有数据.";
//
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
////    rightAxis.axisMaximum = 900.0;
////    rightAxis.axisMinimum = -200.0;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.granularityEnabled = NO;
//    _chartView1.rightAxis.enabled = NO; //去除右边线
//
}

#pragma mark - 数据请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:Code{
    
     [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    com.bizvane.sun.usee.method.news.StoreDetailVIP
    [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreDetailVIP"
                 dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                 [AppDatas sharedDatas].userCode, @"user_code",
                                 Code,@"store_code",
                                 fromDateStr, @"startDate",
                                 toDateStr, @"endDate",
                                 nil]
                      withCache:YES
                        success:^(NSDictionary *responseDic) {
                            DLogObject(responseDic);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                
                            self.dataDic = responseDic;
                            
                            [UIView animateWithDuration:.4 animations:^{
                                
                                
                                [animationView stopAnimating1];
                                
                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                
                            }];

                            
                            
                            if (firstCreate == 1) {
                                 [self createUI];
                                
                                firstCreate = 2;
                            }
                            
                            [self refreshUpDatasAndViews];
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

#pragma mark - 刷新上部界面
- (void)refreshUpDatasAndViews {
    if (!self.dataDic) {
        return;
    }
    if (self.dataDic){
        
        NSDictionary *dic;
        if (selectedBtnIndex == 0) {
            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataDay"];
        } else if (selectedBtnIndex == 1) {
            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataWeek"];
        } else if (selectedBtnIndex == 2) {
            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataMonth"];
        } else if (selectedBtnIndex == 3) {
            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataYear"];
        }
        
        leftUpLab.text = self.dataDic[@"data"][@"head"][0][@"compareTitle"][0][@"piName"];
        leftDownLab.text = self.dataDic[@"data"][@"head"][0][@"compareTitle"][1][@"piName"];
        
        
        NSDictionary *dic1;
        if (selectedBtnIndex == 0) {
            dic1 = self.dataDic[@"data"][@"head"][0][@"dataDay"];
        } else if (selectedBtnIndex == 1) {
            dic1 = self.dataDic[@"data"][@"head"][0][@"dataWeek"];
        } else if (selectedBtnIndex == 2) {
            dic1 = self.dataDic[@"data"][@"head"][0][@"dataMonth"];
        } else if (selectedBtnIndex == 3) {
            dic1 = self.dataDic[@"data"][@"head"][0][@"dataYear"];
        }
        
        NSArray * a = dic1[@"compareList"];

        
        
        leftrLab.text = [NSString stringWithFormat:@"%@",dic1[@"compareList"][a.count - 1][@"valueList"][0][@"value"]];  //  默认显示一条
        leftrLab1.text = [NSString stringWithFormat:@"%@",dic1[@"compareList"][a.count - 1][@"valueList"][1][@"value"]];   //  默认显示一条
        
        rightUpLab.text = self.dataDic[@"data"][@"head"][1][@"compareTitle"][0][@"piName"];
        rightDownLab.text = self.dataDic[@"data"][@"head"][1][@"compareTitle"][1][@"piName"];
        
       
        NSDictionary *dic2;
        if (selectedBtnIndex == 0) {
            dic2 = self.dataDic[@"data"][@"head"][1][@"dataDay"];
        } else if (selectedBtnIndex == 1) {
            dic2 = self.dataDic[@"data"][@"head"][1][@"dataWeek"];
        } else if (selectedBtnIndex == 2) {
            dic2 = self.dataDic[@"data"][@"head"][1][@"dataMonth"];
        } else if (selectedBtnIndex == 3) {
            dic2 = self.dataDic[@"data"][@"head"][1][@"dataYear"];
        }
    
        NSArray * b = dic1[@"compareList"];
        
        rightrLab.text = [NSString stringWithFormat:@"%@",dic2[@"compareList"][b.count - 1][@"valueList"][0][@"value"]];   //  默认显示一条
        rightrLab1.text = [NSString stringWithFormat:@"%@",dic2[@"compareList"][b.count - 1][@"valueList"][1][@"value"]];   //  默认显示一条
        
        tsLab1.text = self.dataDic[@"data"][@"head"][selectedViewIndex][@"chartTitle"][0][@"piName"];
        tsLab2.text = self.dataDic[@"data"][@"head"][selectedViewIndex][@"chartTitle"][1][@"piName"];
        
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

#pragma mark - 上部表数据
- ( void)UplineChartDataSetWithValues1:(NSArray <NSNumber *>*)values1 WithValues2:(NSArray <NSNumber *>*)values2 WithXvalues3:(NSArray <NSNumber *>*)values3{
    
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values1.count; index++)
    {
//        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:index + 1 y:values1[index].doubleValue]];
    }
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values2.count; index++)
    {
//        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:index + 1 y:values2[index].doubleValue]];
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
//        set1.fillColor = [UIColor greenColor];
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        set1.drawCircleHoleEnabled = NO;
//        set1.drawValuesEnabled = NO;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//        set1.mode = LineChartModeLinear;
//        set1.axisDependency = AxisDependencyLeft;
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
//        set2.mode = LineChartModeLinear;
//        set2.axisDependency = AxisDependencyLeft;
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
//
    
}

#pragma mark - 刷新下面数据
-(void)refreshDownDatasAndViews{
    
    if (!self.dataDic) {
        return;
    }
    if (self.dataDic){
        
        //刷新Cell
        
//        NSDictionary *dic;
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
                upNum = [NSString  stringWithFormat:@"%@",upNum];
                downNum = [NSString  stringWithFormat:@"%@",downNum];

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
                upNum = [NSString  stringWithFormat:@"%@",upNum];
                downNum = [NSString  stringWithFormat:@"%@",downNum];
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
                upNum = [NSString  stringWithFormat:@"%@",upNum];
                downNum = [NSString  stringWithFormat:@"%@",downNum];
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
                upNum = [NSString  stringWithFormat:@"%@",upNum];
                downNum = [NSString  stringWithFormat:@"%@",downNum];

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
        
        [self refreshSomeView];

        [tableViews reloadData];
        
        
    }
}


#pragma mark - 单元格以外的下部刷新
-(void)refreshSomeView{
    
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

#pragma mark - UITableViewDataSource & UITabBarDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _downTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForHuiXiaoCell"];
    cell.upNameLab.text = _upTitleArr[indexPath.row];
    cell.downNameLab.text = _downTitleArr[indexPath.row];
//    cell.upNumLab.text = _upNumArr[indexPath.row];
    cell.downNumLab.text = _downNumArr[indexPath.row];
    
    
    NSString * str1 =_upNumArr[indexPath.row];
    
    NSRange range1 = [str1 rangeOfString:@","];
    
    if (range1.length == 0) {
        
        cell.upNumLab1.text = str1;
        
        cell.upNumLab1.textAlignment = NSTextAlignmentRight;
        
        cell.upNumLab1.textColor = [UIColor colorWithHex:0xaf2a33];
        
        
    }else{
    
    str1 = [str1 substringToIndex:range1.location];
    
    NSMutableAttributedString * attrString1 = [[NSMutableAttributedString alloc]initWithString:str1];
    
    [attrString1 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,str1.length)];
    
    [attrString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,str1.length)];
    
    
    cell.upNumLab.attributedText = attrString1;
        
    NSString * str2 =_upNumArr[indexPath.row];
    
    NSRange range2 = [str2 rangeOfString:@","];
    
    str2 = [str2 substringFromIndex:range2.location];
    
    NSMutableAttributedString * attrString2 = [[NSMutableAttributedString alloc]initWithString:str2];
    
    [attrString2 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,str2.length)];
    
    [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,str2.length)];
    

    cell.upNumLab1.attributedText = attrString2;
        
    }
    
    if (indexPath.row == index1) {
        
        [cell.imgBtn setImage:[UIImage imageNamed:@"icon_店铺详情_会销客流指标选中箭头"] forState:UIControlStateNormal];
        
        cell.upNumLab.textColor = [UIColor colorWithHex:0xcb2e3d];
        
        
        NSString * str = _upTitleArr[indexPath.row];
        
        NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithString:str];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:0xcb2e3d] range:NSMakeRange(0,4)];
        
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0,4)];
        
        cell.upNameLab.attributedText = attrString;
        
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
    
    [self refreshSomeView];
    
    [tableView reloadData];
    
}

#pragma mark - 日周月年点击事件
- (void)TimeView:(TimeView *)timeView index:(NSInteger)index{
    
    selectedBtnIndex = index;
    
    [self refreshUpDatasAndViews];
     [self refreshDownDatasAndViews];
}

#pragma mark - 下部表刷新
- ( void)downLineChartDataSetWithValues1:(NSArray <NSNumber *>*)values1 WithValues2:(NSArray <NSNumber *>*)values2 WithXvalues3:(NSArray <NSNumber *>*)values3{

    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values1.count; index++)
    {
//        [yVals1 addObject:[[ChartDataEntry alloc] initWithX:index + 1 y:values1[index].doubleValue]];
    }
    
    NSMutableArray *yVals2 = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < values2.count; index++)
    {
//        [yVals2 addObject:[[ChartDataEntry alloc] initWithX:index + 1 y:values2[index].doubleValue]];
    }
    
//    LineChartDataSet *set1 = nil, *set2 = nil;
//
//    if (_chartView1.data.dataSetCount > 0)
//    {
//        set1 = (LineChartDataSet *)_chartView1.data.dataSets[0];
//        set2 = (LineChartDataSet *)_chartView1.data.dataSets[1];
//        set1.values = yVals1;
//        set2.values = yVals2;
//        [_chartView1.data notifyDataChanged];
//        [_chartView1 notifyDataSetChanged];
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
//        set1.fillColor = [UIColor greenColor];
//        set1.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//        set1.drawCircleHoleEnabled = NO;
//        set1.drawValuesEnabled = NO;
//        set1.drawHorizontalHighlightIndicatorEnabled = NO;
//
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
//        _chartView1.data = data;
//    }
//
}


//- (ChartHighlight * _Nullable)closestHighlightWithIndex:(NSInteger)index x:(CGFloat)x y:(CGFloat)y{
//
//    return 0;
//
//}

#pragma mark - 上部两个view点击手势回调
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    
    if (sender.view == leftView) {
        
        selectedViewIndex = 0;
        leftView.backgroundColor = [UIColor whiteColor];
        rightView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [self refreshUpDatasAndViews];
        
    }else if (sender.view == rightView){
        
        selectedViewIndex =1;
        rightView.backgroundColor = [UIColor whiteColor];
        leftView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [self refreshUpDatasAndViews];
    }
}


//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//
//    if (chartView == _chartView) {
//
//
//        line.hidden = YES;
//
//
//        NSDictionary *dic1;
//        if (selectedBtnIndex == 0) {
//            dic1 = self.dataDic[@"data"][@"head"][0][@"dataDay"];
//        } else if (selectedBtnIndex == 1) {
//            dic1 = self.dataDic[@"data"][@"head"][0][@"dataWeek"];
//        } else if (selectedBtnIndex == 2) {
//            dic1 = self.dataDic[@"data"][@"head"][0][@"dataMonth"];
//        } else if (selectedBtnIndex == 3) {
//            dic1 = self.dataDic[@"data"][@"head"][0][@"dataYear"];
//        }
//
//            NSArray * a = dic1[@"compareList"];
//
//            int h = highlight.x;
//
//
//            leftrLab.text = [NSString stringWithFormat:@"%@",a[h -1][@"valueList"][0][@"value"]];
//            leftrLab1.text = [NSString stringWithFormat:@"%@",a[h -1][@"valueList"][1][@"value"]];
//
//
//
//        NSDictionary *dic2;
//        if (selectedBtnIndex == 0) {
//            dic2 = self.dataDic[@"data"][@"head"][1][@"dataDay"];
//        } else if (selectedBtnIndex == 1) {
//            dic2 = self.dataDic[@"data"][@"head"][1][@"dataWeek"];
//        } else if (selectedBtnIndex == 2) {
//            dic2 = self.dataDic[@"data"][@"head"][1][@"dataMonth"];
//        } else if (selectedBtnIndex == 3) {
//            dic2 = self.dataDic[@"data"][@"head"][1][@"dataYear"];
//        }
//
//
//
//            NSArray * a1 = dic2[@"compareList"];
//
//            int h1 = highlight.x;
//
//
//
//            rightrLab.text = [NSString stringWithFormat:@"%@",a1[h1 - 1][@"valueList"][0][@"value"]];
//            rightrLab1.text = [NSString stringWithFormat:@"%@",a1[h1 - 1][@"valueList"][1][@"value"]];
//
//
//    }else if (chartView == _chartView1){
//
//        line1.hidden = YES;
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
//         int h = highlight.x;
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
//                upNum = array2[h - 1][@"valueList"][0][@"value"];
//                downNum = array2[h - 1][@"valueList"][1][@"value"];
//
//                upNum = [NSString stringWithFormat:@"%@",upNum];
//                downNum = [NSString stringWithFormat:@"%@",downNum];
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
//                upNum = array2[h-1][@"valueList"][0][@"value"];
//                downNum = array2[h-1][@"valueList"][1][@"value"];
//
//                upNum = [NSString stringWithFormat:@"%@",upNum];
//                downNum = [NSString stringWithFormat:@"%@",downNum];
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
//                upNum = array2[h-1][@"valueList"][0][@"value"];
//                downNum = array2[h-1][@"valueList"][1][@"value"];
//
//                upNum = [NSString stringWithFormat:@"%@",upNum];
//                downNum = [NSString stringWithFormat:@"%@",downNum];
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
//
//                upNum = array2[h-1][@"valueList"][0][@"value"];
//                downNum = array2[h-1][@"valueList"][1][@"value"];
//
//                upNum = [NSString stringWithFormat:@"%@",upNum];
//                downNum = [NSString stringWithFormat:@"%@",downNum];
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
//
//        [tableViews reloadData];
//
//
//    DLog(@"chartValueSelected");
//    }
//}
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
//            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataDay"];
//        } else if (selectedBtnIndex == 1) {
//            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataWeek"];
//        } else if (selectedBtnIndex == 2) {
//            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataMonth"];
//        } else if (selectedBtnIndex == 3) {
//            dic = self.dataDic[@"data"][@"head"][selectedViewIndex][@"dataYear"];
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
//     if (self.dataDic) {
//
//            NSInteger index = value - 1;
//            NSString *str = [NSString stringWithString:chartListArr[index][@"xAxis"]];
//                    str = [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
//            return str;
//
//        } else {
//            NSString *str = [NSNumber numberWithDouble:value].stringValue;
//            DLogObject(str);
//            return str;
//        }
//
//
//}


#pragma mark - scrollView回调
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
