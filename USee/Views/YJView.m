//
//  YJView.m
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //店铺排行详情 －－ 业绩看板



#import "YJView.h"
#import "BigBtnView.h"
//#import "Charts.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "MyCollectionViewCell.h"
#import "AppDelegate.h"
#import "AnimationView.h"
//#import "AlterView.h"
#import "MBProgressHUD.h"
#import "TableViewChartCell.h"

//ChartViewDelegate,IChartAxisValueFormatter,
@interface YJView ()<BigBtnViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate, MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _selectedBtnIndex;
    NSInteger _selectPieIndex;
    NSInteger _selectChartIndex;
    
    UILabel * nameLab;
    UILabel * numLab;
    UILabel * bossLab;
    UILabel * tbLab;
    UILabel * dcLab;
    UILabel * pxLab;
    UILabel * leftNumLab;
    UILabel * rxLab;
    UILabel * righNumLab;
    UICollectionView * collectView;
    
    UIScrollView * scrollView1;
    UIScrollView * _containerScrollview;
    
    UITableView *  _storeBarTableView;
    
//    PieChartView * _pieChartView;
    
    AnimationView * animationView;

    NSMutableArray * lineBarcolors;
    NSMutableArray * colors;
    NSMutableArray * _PieCountDataArray;
    
    
    NSMutableDictionary * _pieDataDic;
    
  //  AlterView *_alert;
    
    NSInteger firstCreate;
    
    NSInteger _selectRow;
    
    NSInteger firstHeight;
    MBProgressHUD *HUD;
    int numOf;
    
}

//@property (nonatomic, strong) BarChartView *chartView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong)  NSMutableArray *dateArray;
@property (nonatomic, strong)  NSMutableArray *naArray;

@end
@implementation YJView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        @try {
          
            _selectPieIndex = 0;
            _selectChartIndex = 6;
            
            _selectRow = 0;
            
            _selectedBtnIndex = 0;
            
            firstHeight = 1;
            
            firstCreate = 1;
            
            // _alert = [AlterView new];
            numOf = 6;
            
            lineBarcolors = nil;
            lineBarcolors = [[NSMutableArray alloc] init];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xba2932]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xff782f]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xffae28]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xdd5130]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xff932c]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xffd693]];
            
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD9B1D]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD853F]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD8500]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD8162]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD7054]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD69C9]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD6889]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD6839]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD3333]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD3278]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD2990]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD2626]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD1076]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD00CD]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCD0000]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xCAFF70]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xC1FFC1]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xC0FF3E]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xBF3EFF]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xBC8F8F]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xBDB76B]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xBCEE68]];
            
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xBA55D3]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xB03060]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xAB82FF]];
            [lineBarcolors addObject:[UIColor colorWithHex:0xA2CD5A]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0xA0522D]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x9F79EE]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x9B30FF]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0x90EE90]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8FBC8F]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8E8E38]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8B668B]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0x8B6508]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8B4789]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x87CEFA]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x8470FF]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0x7FFF00]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x7CCD7C]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x7B68EE]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x6A5ACD]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0x00FF7F]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x00FA9A]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x1E90FF]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x218868]];
            
            [lineBarcolors addObject:[UIColor colorWithHex:0x00CD00]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x00B2EE]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x009ACD]];
            [lineBarcolors addObject:[UIColor colorWithHex:0x008B8B]];
            
            colors = nil;
            colors = [[NSMutableArray alloc] initWithArray:lineBarcolors];
            
        } @catch (NSException *exception) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
            
             [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
            
        } @finally {
            
        }
               //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jjt1:) name:@"jjt1" object:nil];
        
        
        
        //orgCode
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YeJi:) name:@"YeJi" object:nil];
        
        
        
    }
    return self;
}

#pragma mark - 懒加载
-(NSMutableArray *)naArray{
    if (!_naArray) {
        _naArray = nil;
        _naArray = [NSMutableArray new];
    }
    return _naArray;
}


//通知方法
-(void)receiveYeJiCode:(NSString *)orgCode{
 
    @try {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情业绩 YJView" forKey:@"crashTheClassName"];
        
        _storeCode = orgCode;
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


//通知方法
- (void)jjt1:(NSNotification *)notification {

    @try {
     
        [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
        [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
        
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


//通知方法
- (void)renjia1:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        
        //  [self refreshDatasWithCache:YES WithCode:_storeCode];
        if (_containerScrollview.contentOffset.x == 0) {
            if (_storeBarTableView) {
                [_storeBarTableView removeFromSuperview];
                _storeBarTableView = nil;
            }
//
//            if (_pieChartView) {
//                [_pieChartView removeFromSuperview];
//                _pieChartView = nil;
//            }
//
//            _chartView.hidden = NO;
            
            [self refreshDatasWithCache:YES WithCode:_storeCode];
        }
        else if (_containerScrollview.contentOffset.x == SCREEN_WIDTH){
            
            
            [self requestAnnularChartData];
//            _chartView.hidden = YES;
            
        }
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)refreshDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)storeCode{
    
    @try {

        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache
                             WithCode:storeCode
         ];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 创建 UI
-(void)createUI{
    
    @try {
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, self.height)];
    
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.userInteractionEnabled = YES;
        scrollView1.delegate =self;
        scrollView1.contentSize = CGSizeMake(0, 0);
        
        scrollView1.alwaysBounceVertical = YES;
        [self addSubview:scrollView1];
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        
        UIView * firstView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120*SCREEN_H_SP)];
        firstView.backgroundColor = Color(156, 40, 48);
        [scrollView1 addSubview:firstView];
        
        [nameLab removeFromSuperview];
        nameLab = nil;
        
        nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 10 * SCREEN_H_SP, 120*SCREEN_W_SP, 14)];
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.textColor = [UIColor whiteColor];
        [firstView addSubview:nameLab];
        
        [numLab removeFromSuperview];
        numLab = nil;
        
        numLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45 *SCREEN_H_SP, SCREEN_WIDTH, 36)];
        //    numLab.center = CGPointMake(SCREEN_WIDTH /2, 50 *SCREEN_H_SP);
        //    numLab.bounds = CGRectMake(0, 0, 200 *SCREEN_W_SP, 70* SCREEN_H_SP );
        numLab.textColor = [UIColor whiteColor];
        numLab.font = [UIFont systemFontOfSize:36];
        numLab.textAlignment = NSTextAlignmentCenter;
        [firstView addSubview:numLab];
        
        [tbLab removeFromSuperview];
        tbLab = nil;
        tbLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * SCREEN_W_SP, 10 *  SCREEN_H_SP, 90 * SCREEN_W_SP, 12)];
        tbLab.font = [UIFont systemFontOfSize:12];
        tbLab.textAlignment = NSTextAlignmentRight;
        tbLab.textColor = [UIColor whiteColor];
        [firstView addSubview:tbLab];
        
        [dcLab removeFromSuperview];
        dcLab = nil;
        dcLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 100 * SCREEN_W_SP, tbLab.frame.origin.y + tbLab.frame.size.height,90 * SCREEN_W_SP, 12)];
        dcLab.font = [UIFont systemFontOfSize:12];
        dcLab.textAlignment = NSTextAlignmentRight;
        dcLab.textColor = [UIColor whiteColor];
        [firstView addSubview:dcLab];
        
        
        
        UIView * threeView = [[UIView alloc]initWithFrame:CGRectMake(0, firstView.frame.origin.y + firstView.frame.size.height, SCREEN_WIDTH, 50 * SCREEN_H_SP)];
        threeView.backgroundColor = Color(130, 33, 39);
        [scrollView1 addSubview:threeView];
        
        [pxLab removeFromSuperview];
        pxLab = nil;
        
        pxLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 3* SCREEN_H_SP, SCREEN_WIDTH / 2, 20 * SCREEN_H_SP)];
        pxLab.textAlignment = NSTextAlignmentCenter;
        pxLab.font = [UIFont systemFontOfSize:12];
        pxLab.textColor = [UIColor colorWithHex:0xffffff];
        [threeView addSubview:pxLab];
        
        [leftNumLab removeFromSuperview];
        leftNumLab = nil;
        
        leftNumLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20 * SCREEN_H_SP, SCREEN_WIDTH / 2, 30 * SCREEN_H_SP)];
        leftNumLab.textAlignment = NSTextAlignmentCenter;
        leftNumLab.font = [UIFont systemFontOfSize:16];
        leftNumLab.textColor = [UIColor colorWithHex:0xffffff];
        [threeView addSubview:leftNumLab];
        
        [rxLab removeFromSuperview];
        rxLab = nil;
        
        rxLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 3 * SCREEN_H_SP, SCREEN_WIDTH / 2, 20 * SCREEN_H_SP)];
        rxLab.textAlignment = NSTextAlignmentCenter;
        rxLab.font = [UIFont systemFontOfSize:12];
        rxLab.textColor = [UIColor colorWithHex:0xffffff];
        [threeView addSubview:rxLab];
        
        [righNumLab removeFromSuperview];
        righNumLab = nil;
        righNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 20 * SCREEN_H_SP, SCREEN_WIDTH / 2, 30 * SCREEN_H_SP)];
        righNumLab.textAlignment = NSTextAlignmentCenter;
        righNumLab.font = [UIFont systemFontOfSize:16];
        righNumLab.textColor = [UIColor colorWithHex:0xffffff];
        [threeView addSubview:righNumLab];
        
        UIView *fourView = [[UIView alloc]initWithFrame:CGRectMake(0, threeView.frame.origin.y + threeView.frame.size.height, SCREEN_WIDTH, 100 * SCREEN_H_SP)];
        fourView.backgroundColor = [UIColor blackColor];
        [scrollView1 addSubview:fourView];
        
//        UICollectionViewFlowLayout *flowlayout=[[UICollectionViewFlowLayout alloc] init];
//        flowlayout.scrollDirection=UICollectionViewScrollDirectionVertical;
//        collectView = [[UICollectionView alloc] initWithFrame:[fourView bounds] collectionViewLayout:flowlayout];
//        collectView.scrollEnabled = NO;
//        collectView.backgroundColor=[UIColor whiteColor];
//        [collectView registerClass:NSClassFromString(@"MyCollectionViewCell") forCellWithReuseIdentifier:@"collection"];
//        collectView.delegate=self;
//        collectView.dataSource=self;
//        [fourView addSubview:collectView];
        //日周月年 btns
        NSArray *arr = @[@"日",@"周",@"月",@"年",];
        BigBtnView *btnView = [[BigBtnView alloc]initWithFrame:CGRectMake(0, fourView.frame.origin.y + fourView.frame.size.height, SCREEN_WIDTH, 54* SCREEN_H_SP)];
        btnView.delegate = self;
        [btnView showBigBtnView:arr];
        [scrollView1 addSubview:btnView];
        
        NSString * storeDetailsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeDetailsString"];
        
        if ([storeDetailsString isEqualToString:@"StoreDetailBrand"]) {
            
            [_containerScrollview removeFromSuperview];
            _containerScrollview = nil;
            
            _containerScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0,btnView.frame.origin.y + btnView.frame.size.height + 17 * SCREEN_H_SP, SCREEN_WIDTH, SCREEN_HEIGHT - firstView.frame.size.height - 64 -threeView.frame.size.height -fourView.frame.size.height - btnView.frame.size.height - 88 * SCREEN_H_SP)];
            _containerScrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
            _containerScrollview.showsVerticalScrollIndicator = NO;
            _containerScrollview.showsHorizontalScrollIndicator = NO;
            _containerScrollview.bounces = NO;
            _containerScrollview.pagingEnabled = YES;
            _containerScrollview.delegate = self;
            [scrollView1 addSubview:_containerScrollview];
//
//            [_chartView removeFromSuperview];
//            _chartView = nil;
    UIView   *     _chartView = [[UIView alloc]initWithFrame:CGRectMake(20 * SCREEN_W_SP, 0, SCREEN_WIDTH - 39 * SCREEN_W_SP, SCREEN_HEIGHT - firstView.frame.size.height - 64 -threeView.frame.size.height -fourView.frame.size.height - btnView.frame.size.height - 88 * SCREEN_H_SP)];
            
            _chartView.backgroundColor = [UIColor redColor];
           [_containerScrollview addSubview:_chartView];
        }
        
        else{
            
            UIView   *     _chartView = [[UIView alloc]initWithFrame:CGRectMake(20 * SCREEN_W_SP, btnView.frame.origin.y + btnView.frame.size.height + 17 * SCREEN_H_SP, SCREEN_WIDTH - 39 * SCREEN_W_SP, SCREEN_HEIGHT - firstView.frame.size.height - 64 -threeView.frame.size.height -fourView.frame.size.height - btnView.frame.size.height - 88 * SCREEN_H_SP)];
            
            _chartView.backgroundColor = [UIColor redColor];
            [scrollView1 addSubview:_chartView];
        
            
            //图表
//            [_chartView removeFromSuperview];
//            _chartView = nil;
//
//            _chartView = [[BarChartView alloc]initWithFrame:CGRectMake(20 * SCREEN_W_SP, btnView.frame.origin.y + btnView.frame.size.height + 17 * SCREEN_H_SP, SCREEN_WIDTH - 39 * SCREEN_W_SP, SCREEN_HEIGHT - firstView.frame.size.height - 64 -threeView.frame.size.height -fourView.frame.size.height - btnView.frame.size.height - 88 * SCREEN_H_SP)];
//
//            [scrollView1 addSubview:_chartView];
        }
        
//        _chartView.tag = 1;
//
//
//        _chartView.backgroundColor = [UIColor whiteColor];
//        _chartView.descriptionText = @"";
//        _chartView.noDataTextDescription = @"You need to provide data for the chart.";
//        _chartView.drawGridBackgroundEnabled = NO;
//        _chartView.dragEnabled = NO;
//        _chartView.doubleTapToZoomEnabled = NO;
//        [_chartView setScaleEnabled:YES];
//        _chartView.pinchZoomEnabled = NO;
//        _chartView.scaleXEnabled = NO;
//        _chartView.scaleYEnabled = NO;  // 禁止放大
//        _chartView.rightAxis.enabled = NO;
//        _chartView.legend.enabled = NO;
//        _chartView.delegate = self;
//        _chartView.drawBarShadowEnabled = NO;
//        _chartView.drawValueAboveBarEnabled = YES;
//        _chartView.maxVisibleCount = 60;
//        //_chartView.xAxis.axisMinimum = 0.5;
//
//        //右边坐标轴
//        _chartView.rightAxis.enabled = NO;
//        //图注
//        _chartView.legend.enabled = NO;
//        //delegate
//        _chartView.delegate = self;
//        //禁止拖拽
//        _chartView.dragEnabled = NO;
//        //说明
//        _chartView.descriptionText = @"";
//
//        ChartXAxis *xAxis = _chartView.xAxis;
//        xAxis.labelPosition = XAxisLabelPositionBottom;
//        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
//        xAxis.labelTextColor = [UIColor grayColor];
//        xAxis.drawGridLinesEnabled = NO;
//        //xAxis.labelCount = 7;
//        //xAxis.granularity = 1.0; // only intervals of 1 day
//        xAxis.axisMinValue = -0.5;
//        xAxis.valueFormatter = self;
//
//        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//        leftAxisFormatter.minimumFractionDigits = 0;
//        leftAxisFormatter.maximumFractionDigits = 1;
//        ChartYAxis *leftAxis = _chartView.leftAxis;
//        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
//        [leftAxis set_customAxisMax:YES];
//        //    leftAxis.labelCount = 3;
//        [leftAxis setLabelCount:3 force:YES];
//        leftAxis.labelTextColor = [UIColor grayColor];
//        leftAxis.drawAxisLineEnabled = NO;
//        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
//        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//        leftAxis.spaceTop = 0.15;
//        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//
//        _chartView.legend.position = ChartLegendPositionBelowChartLeft;
//        _chartView.legend.form = ChartLegendFormSquare;
//        _chartView.legend.formSize = 9.0;
//        _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//        _chartView.legend.xEntrySpace = 4.0;
        
          [self creatBarTableView];
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)creatBarTableView{
    
    @try {
     
        [_storeBarTableView removeFromSuperview];
        _storeBarTableView = nil;
        
      //  _chartView.height  11
        _storeBarTableView = [[UITableView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, DeviceWidth,200) style:UITableViewStylePlain];
        _storeBarTableView.bounces = NO;
        _storeBarTableView.delegate =self;
        _storeBarTableView.dataSource =self;
        _storeBarTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_containerScrollview addSubview: _storeBarTableView];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    @try {
        
      return  [_PieCountDataArray count];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
     
        double unitWidth, maxLength = SCREEN_WIDTH / 4 - 10 * SCREEN_W_SP;
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithArray:_PieCountDataArray];
        
        if ([dataArray[indexPath.row][@"chartValue"] doubleValue] > 0) {
            
            unitWidth = [dataArray[indexPath.row][@"chartValue"] doubleValue] / [dataArray[0][@"chartValue"] doubleValue] * maxLength;
            unitWidth = unitWidth > maxLength ? maxLength : unitWidth;
            
        } else {
            
            unitWidth = 0;
            
        }
        
        TableViewChartCell *cell = [[TableViewChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewChartCellFor" WithWidth:unitWidth];
        [cell.rankBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1 ] forState:UIControlStateNormal];
        cell.nameLab.text = dataArray[indexPath.row][@"brandName"];
        cell.countLab.text = [NSString stringWithFormat:@"%@",dataArray[indexPath.row][@"chartValue"]];
        UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
        cellBackView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
        cell.selectedBackgroundView = cellBackView;
        
        if (_storeBarTableView != nil && indexPath.row == _selectRow) {
            
            [cell.numBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            
        } else {
            
            [cell.numBtn setBackgroundColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
            
        }
        
        switch (indexPath.row) {
                
            case 0:
                
                [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
                [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                break;
                
            case 1:
                
                [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xff782f] forState:UIControlStateNormal];
                [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                break;
                
            case 2:
                
                [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xffae28] forState:UIControlStateNormal];
                [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                break;
                
            default:
                
                [cell.rankBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
                [cell.rankBtn setTitleColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
                
                break;
                
        }
        return cell;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
     
        _selectRow = indexPath.row;
        NSIndexSet * selctIndexSet = [[NSIndexSet alloc]initWithIndex:0];
        
        [_storeBarTableView reloadSections:selctIndexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - collection回调方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    @try {
     
        return 8;
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        MyCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
        cell.nameLab.text = self.naArray[indexPath.row];
        cell.numLab.text = self.dateArray[indexPath.row];
        return cell;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
     
         return CGSizeMake(SCREEN_WIDTH / 4, 40 * SCREEN_H_SP);
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCREEN_H_SP;
}


#pragma mark - 接口请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)StoreCode{
    
    @try {
        //  [_alert alterShow];
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                
                NSDictionary * dataDic  =  [NSDictionary dictionaryWithObjectsAndKeys:
                                            [AppDatas sharedDatas].userCode, @"user_code",
                                            StoreCode,@"store_code",
                                            fromDateStr, @"start_date",
                                            toDateStr, @"end_date",[NSString stringWithFormat:@"%ld",_selectedBtnIndex + 1],@"time_level",
                                            nil];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreDetailTrend"
                             dataParameters:dataDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        DLogObject(responseDic);
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            self.dataDic = responseDic;
                                            
                                            [UIView animateWithDuration:.4 animations:^{
                                                
                                                
                                                [animationView stopAnimating1];
                                                
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                                            }];
                                            
                                            
                                            if (firstCreate == 1) {
                                                
                                                [self createUI];
                                                
                                                
                                                firstCreate = 2;
                                            }
                                            
                                            
                                            [self refreshDatasAndViews];
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [UIView animateWithDuration:.4 animations:^{
                                                
                                                
                                                [animationView stopAnimating1];
                                                
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                                            }];
                                            
                                            
                                            //     [_alert alterDisMiss];
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            
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

          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}




#pragma mark - 接口请求成功后刷新数据和页面
- (void)refreshDatasAndViews {
    
    @try {
     
        if (!self.dataDic) {
            return;
        }
        
        if (self.dataDic){
            NSArray *arr1;
            if (_selectedBtnIndex == 0) {
                arr1 = self.dataDic[@"data"][@"dataDay"];
            } else if (_selectedBtnIndex == 1) {
                arr1 = self.dataDic[@"data"][@"dataWeek"];
            } else if (_selectedBtnIndex == 2) {
                arr1 = self.dataDic[@"data"][@"dataMonth"];
            } else if (_selectedBtnIndex == 3) {
                arr1 = self.dataDic[@"data"][@"dataYear"];
            }
            
            //        nameLab.text = arr1[numOf][@"totalTitle"];
            //        numLab.text = [NSString stringWithFormat:@"%@",arr1[numOf][@"totalValue"]];
            //        bossLab.text = arr1[numOf][@"storeManager"];
            //
            //        NSArray * arr2 = arr1[numOf][@"headCompareList"];
            //
            //        tbLab.text = [NSString stringWithFormat:@"%@ %@",arr2[0][@"compareTitle"],arr2[0][@"compareValue"]];
            //        CGSize tbLabSize = [tbLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            //        [tbLab setSize:tbLabSize];
            //
            //        dcLab.text = [NSString stringWithFormat:@"%@ %@",arr2[1][@"compareTitle"],arr2[1][@"compareValue"]];
            //        CGSize dcLabSize = [dcLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
            //        [dcLab setSize:dcLabSize];
            //
            //        CGFloat reWidth = tbLab.size.width > dcLab.size.width ? tbLab.size.width : dcLab.size.width;
            //        [tbLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
            //        [dcLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
            //
            //        pxLab.text = arr2[2][@"compareTitle"];
            //        leftNumLab.text = [NSString stringWithFormat:@"%@",arr2[2][@"compareValue"]];
            //        rxLab.text = arr2[3][@"compareTitle"];
            //        righNumLab.text = [NSString stringWithFormat:@"%@",arr2[3][@"compareValue"]];
            //
            //        NSArray * arr3 = arr1[numOf][@"CompareList"];
            //
            //           _dateArray = [NSMutableArray new];
            //
            //        for (int i= 0; i < arr3.count ; i++) {
            //
            //            NSString * valueStr = [NSString stringWithFormat:@"%@",arr3[i][@"compareValue"]];
            //            NSString * nameStr = arr3[i][@"compareTitle"];
            //            [self.naArray addObject:nameStr];
            //            [self.dateArray addObject:valueStr];
            //        }
            //
            //        [collectView reloadData];
            
//            NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//            for (int i = 0; i < arr1.count; i++) {
//                [values addObject:arr1[i][@"chartValue"]];
//            }
//            [self barChartDataSetWithValues:values];
            
        }
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}


#pragma mark - charts 柱状图数据设置

- (void)barChartDataSetWithValues:(NSArray <NSNumber *>*)values {
    
    @try {
     
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        
        for (int index = 0; index < values.count; index++)
        {
//            [yVals addObject:[[BarChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
        }
        
//        BarChartDataSet *set1 = nil;
//        set1 = [[BarChartDataSet alloc] initWithValues:yVals label:@"The year 2017"];
//
//        [set1 setColor:[[UIColor colorWithHex:0xdfdfdf] colorWithAlphaComponent:1.0]];
//        [set1 setHighlightColor:[UIColor colorWithHex:0xc82d37]];
//        set1.drawValuesEnabled = NO;
//
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//
//        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
//        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
//
//        data.barWidth = 0.7f;
//        _chartView.xAxis.axisMaximum = data.xMax + 0.25 + 0.25;
//
//        [_chartView.leftAxis resetCustomAxisMax];
//        [_chartView.leftAxis setAxisMaxValue:[self reCalculateMaxYValue:set1.yMax]];
//
//        _chartView.data = data;
//
//
//        // if (firstHeight == 1) {
//
//        ChartHighlight *hl = [[ChartHighlight alloc] initWithX:_selectChartIndex dataSetIndex:0 stackIndex:0];
//        hl.dataIndex = 1;
//        [_chartView highlightValueWithHighlight:hl callDelegate:YES];
//        [_chartView setNeedsDisplay];
        
        // [_chartView highlightValueWithX: dataSetIndex:0 stackIndex:0];
        
        //    firstHeight = 2;
        
        //  }
        
        [[HUDHelper getInstance] hideHUD];//隐藏提示框
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - IChartAxisValueFormatter : 图表展示前横坐标的处理（比如每年最后一周为52，下一年第一周为1）

//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//    @try {
//        if (self.dataDic){
//            NSArray *arr1;
//            if (_selectedBtnIndex == 0) {
//                arr1 = self.dataDic[@"data"][@"dataDay"];
//            } else if (_selectedBtnIndex == 1) {
//                arr1 = self.dataDic[@"data"][@"dataWeek"];
//            } else if (_selectedBtnIndex == 2) {
//                arr1 = self.dataDic[@"data"][@"dataMonth"];
//            } else if (_selectedBtnIndex == 3) {
//                arr1 = self.dataDic[@"data"][@"dataYear"];
//            }
//            NSInteger index = value;
//            NSString *str = [NSString stringWithString:arr1[index][@"xAxis"]];
//
//            return str;
//
//        } else {
//            NSString *str = [NSNumber numberWithDouble:value].stringValue;
//            DLogObject(str);
//            return str;
//        }
//
//    } @catch (NSException *exception) {
//
//          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}

-(void)messageBtn:(UIButton *)sender{
    
}

-(void)phoneBtn:(UIButton *)sender{
    
    @try {
     
        NSString * phoneStr = self.dataDic[@"data"][@"dataDay"][0][@"storePhone"];
        
        if (phoneStr.length != 0) {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.dataDic[@"data"][@"dataDay"][0][@"storePhone"]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self addSubview:callWebview];
            
            
        }else{
            
            HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
            HUD.delegate = self;
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"号码为空";
            HUD.margin = 10.f;
            HUD.removeFromSuperViewOnHide = YES;
            [HUD hide:YES afterDelay:2];
            
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
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

#pragma mark 点击日、周、月、年响应方法
- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index{
    
    @try {
        
        _selectedBtnIndex = index;
        
        _selectRow = 0;
        
        if (_containerScrollview.contentOffset.x == 0) {
//            _chartView.hidden = NO;
            // [self refreshDatasAndViews];
            
            [self refreshDatasWithCache:YES WithCode:_storeCode];
        }
        else if (_containerScrollview.contentOffset.x == SCREEN_WIDTH){
            
//            _chartView.hidden = YES;
            [self requestAnnularChartData];
            
            
        }
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - ChartViewDelegate 点击图标回调事件

//- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight
//{
//
//    @try {
//
//        if (chartView.tag == 1) {
//            DLog(@"%@*********************************",highlight);
//
//            numOf = highlight.x;
//            _selectChartIndex = numOf;
//
//            if (self.dataDic){
//                NSArray *arr1;
//                if (_selectedBtnIndex == 0) {
//                    arr1 = self.dataDic[@"data"][@"dataDay"];
//                } else if (_selectedBtnIndex == 1) {
//                    arr1 = self.dataDic[@"data"][@"dataWeek"];
//                } else if (_selectedBtnIndex == 2) {
//                    arr1 = self.dataDic[@"data"][@"dataMonth"];
//                } else if (_selectedBtnIndex == 3) {
//                    arr1 = self.dataDic[@"data"][@"dataYear"];
//                }
//
//                nameLab.text = arr1[numOf][@"totalTitle"];
//                numLab.text = arr1[numOf][@"totalValue"];
//                bossLab.text = arr1[numOf][@"storeManager"];
//
//
//                NSArray * arr2 = arr1[numOf][@"headCompareList"];
//
//                tbLab.text = [NSString stringWithFormat:@"%@ %@",arr2[0][@"compareTitle"],arr2[0][@"compareValue"]];
//                CGSize tbLabSize = [tbLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//                [tbLab setSize:tbLabSize];
//
//                dcLab.text = [NSString stringWithFormat:@"%@ %@",arr2[1][@"compareTitle"],arr2[1][@"compareValue"]];
//                CGSize dcLabSize = [dcLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//                [dcLab setSize:dcLabSize];
//
//                CGFloat reWidth = tbLab.size.width > dcLab.size.width ? tbLab.size.width : dcLab.size.width;
//                [tbLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
//                [dcLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
//
//
//                pxLab.text = arr2[2][@"compareTitle"];
//                leftNumLab.text = arr2[2][@"compareValue"];
//                rxLab.text = arr2[3][@"compareTitle"];
//                righNumLab.text = arr2[3][@"compareValue"];
//
//                NSArray * arr3 = arr1[numOf][@"CompareList"];
//
//                _dateArray = nil;
//                self.naArray = nil;
//                _dateArray = [NSMutableArray new];
//                self.naArray = [NSMutableArray new];
//                for (int i= 0; i < arr3.count ; i++) {
//
//                    NSString * valueStr = arr3[i][@"compareValue"];
//                    NSString * nameStr = arr3[i][@"compareTitle"];
//                    [self.naArray addObject:nameStr];
//                    [self.dateArray addObject:valueStr];
//                }
//
//                [collectView reloadData];
//
//                //   NSLog(@"名字  %@",self.naArray);
//            }
//
//            DLog(@"chartValueSelected");
//        }
//        else if (chartView.tag == 2){
//
//            numOf = highlight.x;
//            _selectPieIndex = numOf;
//
//            NSDictionary * dataDic = _PieCountDataArray[numOf];
//            if (dataDic){
//                NSArray *arr1;
//                if (_selectedBtnIndex == 0) {
//                    arr1 = dataDic[@"dataDay"];
//                } else if (_selectedBtnIndex == 1) {
//                    arr1 = dataDic[@"dataWeek"];
//                } else if (_selectedBtnIndex == 2) {
//                    arr1 = dataDic[@"dataMonth"];
//                } else if (_selectedBtnIndex == 3) {
//                    arr1 = dataDic[@"dataYear"];
//                }
//
//                nameLab.text = [NSString stringWithFormat:@"%@",arr1[0][@"totalTitle"]];
//                numLab.text = [NSString stringWithFormat:@"%@",arr1[0][@"totalValue"]];
//                bossLab.text = [NSString stringWithFormat:@"%@",arr1[0][@"storeManager"]];
//
//                NSArray * arr2 = arr1[0][@"headCompareList"];
//
//                tbLab.text = [NSString stringWithFormat:@"%@ %@",arr2[0][@"compareTitle"],arr2[0][@"compareValue"]];
//                CGSize tbLabSize = [tbLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//                [tbLab setSize:tbLabSize];
//
//                dcLab.text = [NSString stringWithFormat:@"%@ %@",arr2[1][@"compareTitle"],arr2[1][@"compareValue"]];
//                CGSize dcLabSize = [dcLab.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
//                [dcLab setSize:dcLabSize];
//
//                CGFloat reWidth = tbLab.size.width > dcLab.size.width ? tbLab.size.width : dcLab.size.width;
//                [tbLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
//                [dcLab setX:SCREEN_WIDTH - (10 * SCREEN_W_SP + reWidth)];
//
//
//                pxLab.text = [NSString stringWithFormat:@"%@",arr2[2][@"compareTitle"]];
//                leftNumLab.text = [NSString stringWithFormat:@"%@",arr2[2][@"compareValue"]];
//                rxLab.text = [NSString stringWithFormat:@"%@",arr2[3][@"compareTitle"]];
//                righNumLab.text = [NSString stringWithFormat:@"%@",arr2[3][@"compareValue"]];
//
//                NSArray * arr3 = arr1[0][@"CompareList"];
//
//                _dateArray = nil;
//                self.naArray = nil;
//                _dateArray = [NSMutableArray new];
//                self.naArray = [NSMutableArray new];
//
//                for (int i= 0; i < arr3.count ; i++) {
//
//                    NSString * valueStr = [NSString stringWithFormat:@"%@",arr3[i][@"compareValue"]];
//                    NSString * nameStr = [NSString stringWithFormat:@"%@",arr3[i][@"compareTitle"]];
//                    [self.naArray addObject:nameStr];
//                    [self.dateArray addObject:valueStr];
//                }
//
//                [collectView reloadData];
//            }
//
//        }
//
//    } @catch (NSException *exception) {
//
//          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
     
         [animationView startAnimation];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark  切换柱状图和环形图（条形图）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    @try {
        if (scrollView == _containerScrollview) {
            
            _selectPieIndex = 0;
            _selectChartIndex = 6;
            
            if (_containerScrollview.contentOffset.x == 0) {
                if (_storeBarTableView) {
                    [_storeBarTableView removeFromSuperview];
                    _storeBarTableView = nil;
                }
                
//                if (_pieChartView) {
//                    [_pieChartView removeFromSuperview];
//                    _pieChartView = nil;
//                }
//
//                _chartView.hidden = NO;
                
                [self refreshDatasWithCache:YES WithCode:_storeCode];
            }
            else if (_containerScrollview.contentOffset.x == SCREEN_WIDTH){
                
                
                [self requestAnnularChartData];
//                _chartView.hidden = YES;
                
            }
        }
 
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 请求环形图数据
-(void)requestAnnularChartData{
    
    @try {
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        RequestInterfceViewController * RequestInterfceVC = [[RequestInterfceViewController alloc]init];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[AppDatas sharedDatas].userCode forKey:@"user_code"];
        [dic setObject:_storeCode forKey:@"store_code"];
        [dic setObject:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"] forKey:@"start_date"];
        [dic setObject:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"] forKey:@"end_date"];
        [dic setObject:[NSString stringWithFormat:@"%ld",_selectedBtnIndex+1] forKey:@"time_level"];
        
        [RequestInterfceVC requestEnrollInterface:@"com.bizvane.sun.usee.method.news.StoreDetailBrand" requestDic:dic];
        
        RequestInterfceVC.successBlock = ^(NSDictionary * dataDic){
            
            [[HUDHelper getInstance] hideHUD];
            
            [UIView animateWithDuration:.4 animations:^{
                
                [animationView stopAnimating1];
                
                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }];
            
            _pieDataDic = [[NSMutableDictionary alloc] initWithDictionary:dataDic];
            
            [self createPieDateUI];
            
            [self refreshStoreYJPieData];
            
        };
        
        RequestInterfceVC.errolBlock = ^(NSInteger errorCode){
            [[HUDHelper getInstance] hideHUD];
            [UIView animateWithDuration:.4 animations:^{
                
                
                [animationView stopAnimating1];
                
                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }];
            
            if (errorCode == -1001) {
                
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
            }else{
                
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                
            }
            
        };
        
        RequestInterfceVC.noNetworkBlock = ^(){
            
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        };
        
        
        RequestInterfceVC = nil;
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 刷新饼状图
-(void)refreshStoreYJPieData{
    
    @try {
     
        _PieCountDataArray = _pieDataDic[@"data"][@"data"];
        
        if (_PieCountDataArray.count >= 10) {
//            if (_pieChartView) {
//
//                [_pieChartView removeFromSuperview];
//                _pieChartView = nil;
//            }
//            else if (_storeBarTableView){

                [_storeBarTableView removeFromSuperview];
                _storeBarTableView = nil;
//            }
            
            [self creatBarTableView];
            //        [_tabView setHidden:NO];
            //        [_pieChartView setHidden:YES];
            
        }
        else{
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            
            double minValve = 1000000000000000.0;
            
            
            for (int i = 0; i < _PieCountDataArray.count; i++ ) {
                
                double xValued = 10;//[_PieCountDataArray[i][@"chartValue"] doubleValue] ;
                
                if (xValued > 0) {
                    
                    if (xValued < minValve) {
                        
                        minValve = xValued;
                        
                    }else{
                        
                        minValve = minValve;
                        
                    }
                    
                }
                
            }
            
            for (int i = 0; i < _PieCountDataArray.count; i++)
            {
                NSString * chartValueString;
                if (_selectedBtnIndex == 0) {
                    chartValueString =  _PieCountDataArray[i][@"dataDay"][0][@"chartValue"];
                }
                else if (_selectedBtnIndex == 1){
                    chartValueString =  _PieCountDataArray[i][@"dataWeek"][0][@"chartValue"];
                }
                else if (_selectedBtnIndex == 2){
                    chartValueString =  _PieCountDataArray[i][@"dataMonth"][0][@"chartValue"];
                }
                else if (_selectedBtnIndex == 3){
                    chartValueString =  _PieCountDataArray[i][@"dataYear"][0][@"chartValue"];
                }
                
                NSString * lab = [NSString stringWithFormat:@"%@ %@",_PieCountDataArray[i][@"brand_name"],chartValueString];
                
                double xValued = [chartValueString doubleValue];
                
                if (xValued < 0 ||xValued == 0 ) {
                    
                    xValued = minValve / 2;
                }else{
                    
                    xValued = [chartValueString doubleValue];
                    
                }
                
//                [values addObject:[[PieChartDataEntry alloc] initWithValue:xValued label:lab]];
            }
            
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
//            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
//            [data setValueTextColor:UIColor.grayColor];
//
//            if (data.entryCount) {
//                _pieChartView.data = data;
//            } else {
//                // _pieChartView = [self createPieDateUI];
//            }
//
//            ChartHighlight *hl = [[ChartHighlight alloc] initWithX:_selectPieIndex dataSetIndex:0 stackIndex:0];
//            hl.dataIndex = 1;
//            [_pieChartView highlightValueWithHighlight:hl callDelegate:YES];
//            [_pieChartView setNeedsDisplay];
            
        }
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 创建饼状图
-(void)createPieDateUI{
    
    @try {

        if (_storeBarTableView){
            
            [_storeBarTableView removeFromSuperview];
            _storeBarTableView = nil;
        }
        
//        if (!_pieChartView) {
//
//            _pieChartView = [PieChartView new];
//            _pieChartView.tag = 2;
//            _pieChartView.frame = CGRectMake(DeviceWidth, 0, DeviceWidth,_chartView.height);
//            _pieChartView.holeRadiusPercent = 0.7;
//            _pieChartView.backgroundColor = [UIColor whiteColor];
//            [scrollView1 addSubview:_pieChartView];
//            _pieChartView.rotationEnabled = NO;
//            _pieChartView.legend.enabled = NO;
//            _pieChartView.delegate = self;
//            _pieChartView.descriptionText = @"";
//            _pieChartView.noDataText = @"";
//            _pieChartView.noDataTextDescription = @"没数据";
//            ChartLegend *l = _pieChartView.legend;
//            l.position = ChartLegendPositionRightOfChart;
//            l.xEntrySpace = 7.0;
//            l.yEntrySpace = 0.0;
//            l.yOffset = 0.0;
//            _pieChartView.entryLabelColor = UIColor.whiteColor;
//            _pieChartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//            [_pieChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//            [_containerScrollview addSubview:_pieChartView];
//        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
        [animationView stopAnimating];
        
        if (scrollView.contentOffset.y <= -80) {
            
            
        }
        
        if (animationView.tag == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                
                [animationView startAnimation1];
                
                if (_containerScrollview.contentOffset.x == 0) {
                    if (_storeBarTableView) {
                        [_storeBarTableView removeFromSuperview];
                        _storeBarTableView = nil;
                    }
                    
//                    if (_pieChartView) {
//                        [_pieChartView removeFromSuperview];
//                        _pieChartView = nil;
//                    }
//
//                    _chartView.hidden = NO;
                    
                    [self refreshDatasWithCache:YES WithCode:_storeCode];
                }
                else if (_containerScrollview.contentOffset.x == SCREEN_WIDTH){
                    
                    
                    [self requestAnnularChartData];
//                    _chartView.hidden = YES;
                    
                }
                
               scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
            }];
            
            //数据加载成功后执行；这里为了模拟加载效果，一秒后执行恢复原状代码
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    animationView.tag = 0;
                    
                    
                }];
                
            });
        }
  
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中业绩 YJView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



@end
