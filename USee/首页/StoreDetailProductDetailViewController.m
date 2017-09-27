//
//  FourDetailViewController.m
//  LOSBi
//
//  Created by JJT on 16/9/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "StoreDetailProductDetailViewController.h"
#import "AppDelegate.h"
#import "ShowView.h"
#import "ShareMenuViewController.h"
#import "BigBtnView.h"
//#import "Charts.h"
#import "LOSHelper.h"
#import "AppDatas.h"
#import "LOSAFNetworking.h"
#import "TableViewCellForDetailStoreRank.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
#import "DianPuView.h"

#define colorText  Color(123, 123, 123)
//ChartViewDelegate,IChartAxisValueFormatter,
@interface StoreDetailProductDetailViewController ()<BigBtnViewDelegate,UIScrollViewDelegate, MBProgressHUDDelegate>

{
    
    UIButton * calendarBtn;
    
    UIView *_middleAndBelowView;
    BOOL _UIIsCreated;
    
    ShowView *sv;
    UIImageView * image;
    UIButton * upBtn;
    UIButton * downBtn;
    
    UIView *_storeRank;
    BOOL _storeRankIsCreated;
    UITableView *_tableView;
    
//    LineChartDataSet *set1, *set2, *set3, *set4;
    NSMutableArray *_dataSets;
//    LineChartData *_data;
    MBProgressHUD *HUD;
    NSMutableArray *countArray;
    
    UIScrollView * scrollView1;
    
    AnimationView * animationView;
    
    NSInteger firstCreate;
    
    
    
    UILabel * jgLab;
    
    UILabel *jgNum;
    
    UILabel * khLab;
    
    UILabel * nfLab;
    
    UILabel * jjLab;
    UILabel * bdLab;
    
    UILabel *_chartTitle;

    
}

@property (nonatomic ,strong) NSMutableArray *array1;
@property (nonatomic ,strong) NSMutableArray *array2;
@property (nonatomic ,strong) NSMutableArray *chartArray;

@property (nonatomic ,strong) NSDictionary *dataDic;
@property (nonatomic,strong)NSMutableArray *dataSourceArr;

//@property (nonatomic, strong) LineChartView *chartView;


@end



@implementation StoreDetailProductDetailViewController


-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray new];
    }
    return _dataSourceArr;
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
     firstCreate = 1;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


#pragma mark -  获得点击的日期/时段

- (void)selectedDates:(NSNotification *)notification {
    
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
        [calendarBtn setTitle:[NSString stringWithFormat:@"时段"] forState:UIControlStateNormal];
    }
    [sv backView];
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

- (void)refreshDatasWithCache:(BOOL)isUseCache {
    [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                        toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                        withCache:isUseCache];
}

#pragma mark - 接口请求
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreshDatasWithCache:YES];
    
    
    
    //这里是对应你的方法，但一般不要这么直接设置，会没有良好的过度动画效果，但隐藏效果是对的
    //（很多开发者只会这么设置，殊不知他们根本就不懂UI层更和谐的方式，就是下一种更好的系统带animated的动态隐藏）
    self.navigationController.navigationBarHidden = YES;
    
}


#pragma mark - 接口请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    
    //此数据由上级页面传输过来
    NSString *store_code = _storeCode;
    
    NSString *product_code = self.productCode;
    
    [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.StoreDetailProductDetail"
                dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                [AppDatas sharedDatas].userCode,@"user_code",
                                store_code,@"store_code",
                                product_code,@"product_code",
                                fromDateStr, @"startDate",
                                toDateStr, @"endDate",
                                nil]
                     withCache:YES
                       success:^(NSDictionary *responseDic) {

                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
                              
                               [[HUDHelper getInstance] hideHUD];//隐藏提示框
                               
                               self.dataDic = responseDic;
                               
                               [UIView animateWithDuration:.4 animations:^{
                                   
                                   
                                   [animationView stopAnimating1];
                                   
                                   scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                   
                               }];
                               if (!_UIIsCreated) {
                                   //数据请求成功后创建UI
                                   
                                   if (firstCreate == 1) {
                                       
                                       [self createMiddleViewUI];
                                       
                                       firstCreate = 2;
                                       
                                   }else{
                                       
                                       [self relfeshViewDanDates];
                                       
                                   }
                                   
                                   _UIIsCreated = YES;
                               }else{
                                   
                                   if (firstCreate == 1) {
                                       
                                       [self createMiddleViewUI];
                                       
                                       firstCreate = 2;
                                       
                                   }else{
                                       
                                       [self relfeshViewDanDates];
                                       
                                   }
   
                               }

   
                           } else {
                               
                               HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                               HUD.delegate = self;
                               HUD.mode = MBProgressHUDModeText;
                               HUD.labelText = responseDic[@"msg"];
                               HUD.margin = 10.f;
                               HUD.removeFromSuperViewOnHide = YES;
                               [HUD hide:YES afterDelay:2];
                               
                               [self navc];
                               
                           }
                           
                       }
                       failure:^(NSError *error) {
                         
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

                       }];
    
    
}

#pragma mark - 刷新
-(void)relfeshViewDanDates{
    
    if (!self.dataDic) {
        return;
    }
    if (self.dataDic) {
        
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataDic[@"data"][@"productImage"]]];
        image.image = [UIImage imageWithData:data];
        
        if (self.dataDic[@"data"][@"name1"]) {
            jgLab.text = self.dataDic[@"data"][@"name1"];
        }
        
        if (self.dataDic[@"data"][@"value1"]) {
            jgNum.text = self.dataDic[@"data"][@"value1"];
        }
        if (self.dataDic[@"data"][@"name2"] && self.dataDic[@"data"][@"value2"]) {
            khLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name2"],self.dataDic[@"data"][@"value2"]];
        }
        if (self.dataDic[@"data"][@"name3"] && self.dataDic[@"data"][@"value3"]) {
            nfLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name3"],self.dataDic[@"data"][@"value3"]];
        }
        if (self.dataDic[@"data"][@"value4"] && self.dataDic[@"data"][@"name4"]) {
            jjLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name4"],self.dataDic[@"data"][@"value4"]];
        }
        if (self.dataDic[@"data"][@"value5"] && self.dataDic[@"data"][@"name5"]) {
            bdLab.text = [NSString stringWithFormat:@"%@  第%@波段",self.dataDic[@"data"][@"name5"],self.dataDic[@"data"][@"value5"]];
        }
        
        _chartTitle.text = self.dataDic[@"data"][@"chartTitle"];


        NSArray *arr1 = @[self.dataDic[@"data"][@"chart"][0][@"theme"],self.dataDic[@"data"][@"chart"][1][@"theme"],self.dataDic[@"data"][@"chart"][2][@"theme"]];


        for (int i =0; i < 3; i ++) {
            
            if (arr1) {
                [upBtn setTitle:arr1[i] forState:UIControlStateNormal];
            }
    
        }
        
         [self loadChartData];
        
        NSMutableArray *arr2 = [NSMutableArray new];
        NSArray *compareTitleArr = self.dataDic[@"data"][@"chart"][0][@"compareTitle"];
        if (compareTitleArr) {
            for (int i = 0; i < compareTitleArr.count; i ++) {
                if ([compareTitleArr[i][@"site"] isEqualToString:[NSString stringWithFormat:@"%d",i + 1]]) {
                    
                    [arr2 addObject:compareTitleArr[i][@"name"]];
                }
            }
        }
        
        
        NSArray * arr3 = @[@"img_图表指示点_粉",@"img_图表指示点_橙",@"img_图表指示点_灰"];
        
        for (int j =0; j < 3; j ++) {
            
            [downBtn setImage:[UIImage imageNamed:arr3[j]] forState:UIControlStateNormal];
            
            [downBtn setTitle:arr2[j] forState:UIControlStateNormal];

        }

    }
    
}


#pragma mark - 创建中部视图
-(void)createMiddleViewUI{
    
    
    [scrollView1 removeFromSuperview];
    scrollView1 = nil;
    
    scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
    scrollView1.showsVerticalScrollIndicator = NO;
    scrollView1.userInteractionEnabled = YES;
    scrollView1.delegate =self;
    scrollView1.contentSize = CGSizeMake(0, self.view.height);
    
    scrollView1.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView1];
    
    animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 100)];
    
    animationView.layer.borderColor = [UIColor redColor].CGColor;
    
    
    [animationView Animation];
    
    [animationView Animation1];
    
    [scrollView1 addSubview:animationView];
    


    image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 300*SCREEN_H_SP - 44)];
//    image.image = [UIImage imageNamed:@"img_bg"];
    image.clipsToBounds = YES;
    image.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView1 addSubview:image];
    

#pragma mark - 赋图
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataDic[@"data"][@"productImage"]]];
    image.image = [UIImage imageWithData:data];

    
    
#pragma mark - 承载middle及其以下视图的view
    _middleAndBelowView = [[UIView alloc]initWithFrame:CGRectMake(0, image.y + image.height, SCREEN_WIDTH, SCREEN_HEIGHT - (image.y + image.height))];
    [scrollView1 addSubview:_middleAndBelowView];
    
    
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 65 *SCREEN_H_SP)];
    middleView.backgroundColor = Color(218, 218, 218);
    [_middleAndBelowView addSubview:middleView];
    
    UIView * secondView = [[UIView alloc]initWithFrame:CGRectMake(0,5 *SCREEN_H_SP, SCREEN_WIDTH, 65 *SCREEN_H_SP)];
    secondView.backgroundColor = [UIColor whiteColor];
    secondView.tag = 222;
    [middleView addSubview:secondView];
    
    jgLab = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 10 *SCREEN_H_SP, 50 *SCREEN_W_SP, 20 * SCREEN_H_SP)];
    if (self.dataDic[@"data"][@"name1"]) {
        jgLab.text = self.dataDic[@"data"][@"name1"];
    }
    jgLab.font = [UIFont systemFontOfSize:14];
    jgLab.textColor = colorText;
    [secondView addSubview:jgLab];
    
#pragma mark - 价格
    jgNum = [[UILabel alloc]initWithFrame:CGRectMake(60 *SCREEN_W_SP, 0 , 100 *SCREEN_W_SP, 30 *SCREEN_H_SP)];
    if (self.dataDic[@"data"][@"value1"]) {
        jgNum.text = self.dataDic[@"data"][@"value1"];
    }

    
    jgNum.font = [UIFont systemFontOfSize:24];
    //副文本
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc]initWithString:jgNum.text];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0,1)];
    jgNum.attributedText = attrString;
    
    jgNum.textColor = ColorThemeRed;
    [secondView addSubview:jgNum];
    
    
    
#pragma mark - 款号
    khLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 10 *SCREEN_W_SP, 10 *SCREEN_H_SP, SCREEN_WIDTH / 2 - 10 *SCREEN_W_SP, 20 * SCREEN_H_SP)];
    khLab.textAlignment = NSTextAlignmentRight;
    if (self.dataDic[@"data"][@"name2"] && self.dataDic[@"data"][@"value2"]) {
        khLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name2"],self.dataDic[@"data"][@"value2"]];
    }
    khLab.font = [UIFont systemFontOfSize:14];
    khLab.textColor = colorText;
    [secondView addSubview:khLab];
    
    
    nfLab = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 40 *SCREEN_H_SP, (SCREEN_WIDTH - 10 * 2) / 3, 20 * SCREEN_H_SP)];
    nfLab.textAlignment = NSTextAlignmentLeft;
    if (self.dataDic[@"data"][@"name3"] && self.dataDic[@"data"][@"value3"]) {
        nfLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name3"],self.dataDic[@"data"][@"value3"]];
    }
    nfLab.textColor = colorText;
    nfLab.font = [UIFont systemFontOfSize:14];
    [secondView addSubview:nfLab];
    
    
    jjLab = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP + SCREEN_WIDTH / 3, 40 *SCREEN_H_SP, (SCREEN_WIDTH - 10 * 2) / 3 - 20 *SCREEN_W_SP, 20 * SCREEN_H_SP)];
    jjLab.textAlignment = NSTextAlignmentLeft;
    if (self.dataDic[@"data"][@"value4"] && self.dataDic[@"data"][@"name4"]) {
        jjLab.text = [NSString stringWithFormat:@"%@  %@",self.dataDic[@"data"][@"name4"],self.dataDic[@"data"][@"value4"]];
    }
    jjLab.textColor = colorText;
    jjLab.font = [UIFont systemFontOfSize:14];
    [secondView addSubview:jjLab];
    
    bdLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - SCREEN_WIDTH / 3  - 15 *SCREEN_W_SP, 40 *SCREEN_H_SP, SCREEN_WIDTH / 3 - 5 *SCREEN_W_SP, 20 * SCREEN_H_SP)];
    bdLab.textAlignment = NSTextAlignmentRight;
    if (self.dataDic[@"data"][@"value5"] && self.dataDic[@"data"][@"name5"]) {
        bdLab.text = [NSString stringWithFormat:@"%@  第%@波段",self.dataDic[@"data"][@"name5"],self.dataDic[@"data"][@"value5"]];
    }
    bdLab.textColor = colorText;
    //    bdLab.backgroundColor = [UIColor orangeColor];
    bdLab.font = [UIFont systemFontOfSize:14];
    [secondView addSubview:bdLab];
    
    
    //下部视图上的 1 label + 3 button
    [self createHeadControlsInBottomView];
    
#pragma mark - 周销曲线图
    [self createWeekSaleCurves];
    
#pragma mark - 创建底部 3 个按钮
    [self createBottomButtons];
    
    [self navc];
    
}


#pragma mark - 导航栏
-(void)navc{
    
    
    UIView * navgatView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    
    navgatView.backgroundColor = Color(195, 71, 79);
    
    
    [self.view addSubview:navgatView];
    
    
    
    //返回键
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    
    [self.view addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UILabel * nameLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 20, SCREEN_WIDTH / 2, 44)];
    nameLab.textColor = [UIColor whiteColor];
    //标题赋值的tag
    nameLab.tag = 1111;
    nameLab.text = self.title;
    nameLab.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:nameLab];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    shareBtn.frame = CGRectMake(SCREEN_WIDTH - 50 * SCREEN_W_SP, 20, 44, 44);
    [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareBtn];
    
    
    
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
    
    
    //    NSString * currentDateString = [dateFormatter stringFromDate:[NSDate date]];
    calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);//文字下移
    //    [calendarBtn setTitle:currentDateString forState:UIControlStateNormal];
    calendarBtn.frame = CGRectMake(SCREEN_WIDTH - 90 * SCREEN_W_SP, 20, 44, 44);
    [calendarBtn addTarget:self action:@selector(calendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendarBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calendarBtn:) name:@"calendarBtn" object:nil];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    sv = [[ShowView alloc]initWithFrame:self.view.bounds];
    [sv CreateView];
    [window addSubview:sv];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
    
    
    //标题赋值
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:1111];
    titleLabel.text = self.dataDic[@"data"][@"porductName"];
    
}


#pragma mark -  折线图
-(void)createWeekSaleCurves{
    
    _chartTitle = (UILabel *)[self.view viewWithTag:777];
    
//    _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, _chartTitle.frame.origin.y + _chartTitle.height + 5 *SCREEN_H_SP, SCREEN_WIDTH - 18 * SCREEN_W_SP, 170 * SCREEN_H_SP)];
//
//    _chartView.backgroundColor = [UIColor clearColor];
//
//    [_middleAndBelowView addSubview:_chartView];
    //加一条分割线
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, _chartView.y - 2, SCREEN_WIDTH - 10 * 2, 1)];
//    lineView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
//
//    _chartView.legend.enabled = NO;
//
//    _chartView.delegate = self;
//
//    _chartView.descriptionText = @"";
//    _chartView.noDataTextDescription = @"You need to provide data for the chart.";
//
//    _chartView.dragEnabled = NO;
//    [_chartView setScaleEnabled:NO];
//    _chartView.drawGridBackgroundEnabled = NO;
//    _chartView.pinchZoomEnabled = NO;
//
//    _chartView.legend.form = ChartLegendFormLine;
//    _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
//    _chartView.legend.textColor = UIColor.whiteColor;
//    _chartView.legend.position = ChartLegendPositionBelowChartLeft;
//
//    ChartXAxis *xAxis = _chartView.xAxis;
//    xAxis.labelFont = [UIFont systemFontOfSize:11];
//    xAxis.labelPosition = XAxisLabelPositionBottom; // x轴下方显示数字
////    xAxis.labelCount = 2;
//    [xAxis setLabelCount:2 force:YES];
//    xAxis.labelTextColor = [UIColor colorWithHex:0x8d8d8d];
//    xAxis.drawGridLinesEnabled = NO;
//    xAxis.drawAxisLineEnabled = NO;
//    xAxis.valueFormatter = self;
//
//
//    ChartYAxis *leftAxis = _chartView.leftAxis;
//    //左边数字颜色
//    leftAxis.labelTextColor = Color(145, 145, 145);
//    leftAxis.labelCount = 4;
////    leftAxis.axisMaximum = 7000.0;
////    leftAxis.axisMinimum = 0.0;
//    leftAxis.drawGridLinesEnabled = YES;
//    leftAxis.drawZeroLineEnabled = NO;
//    leftAxis.drawAxisLineEnabled = NO;//去掉左轴竖线
//    leftAxis.granularityEnabled = YES;
//
//    ChartYAxis *rightAxis = _chartView.rightAxis;
//    rightAxis.labelTextColor = UIColor.redColor;
////    rightAxis.axisMaximum = 900.0;
////    rightAxis.axisMinimum = -200.0;
//    rightAxis.drawGridLinesEnabled = NO;
//    rightAxis.granularityEnabled = NO;
//
//    //    _chartView.leftAxis.enabled = NO;
//    _chartView.rightAxis.enabled = NO; //去除右边线
    
    [self loadChartData];
    
#pragma mark - 展示首次进入页面数据
    [self showFirstView];
    
}

-(void)showFirstView{

    [self showChartWith:YES];
}

#pragma mark - 折线图数据
-(void)loadChartData{
    
    _chartArray = [NSMutableArray new];
    
    NSMutableArray *tempArr;
    
    //按钮切换改变折线数据
    NSMutableArray *yVals1;    //第一条折线
    NSMutableArray *yVals2;    //第二条折线
    NSMutableArray *yVals3;    //第三条折线
    NSMutableArray *yVals4;    //第四条折线
    
    NSArray *chartArr = self.dataDic[@"data"][@"chart"];
    
    
    
    //底部三个按钮随着折线图上方的三个按钮切换而变化
    for (int j = 0; j < 3; j ++) {
        tempArr = [NSMutableArray new];
        
        //进入界面，默认取第一组数据：金额
        countArray = [NSMutableArray new];
        countArray = chartArr[j][@"value"];
        
        if (countArray) {
            
            yVals1 = [[NSMutableArray alloc] init];
            yVals2 = [[NSMutableArray alloc] init];
            yVals3 = [[NSMutableArray alloc] init];
            yVals4 = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < countArray.count ; i ++) {
                
//                [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i  y:[countArray[i][@"chartValue"] intValue]]];
//
//                [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][@"1"]  intValue]]];
//
//                [yVals3 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][@"2"]  intValue]]];
//
//                [yVals4 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][@"3"]  intValue]]];
            }
            
//            set1 = [[LineChartDataSet alloc] initWithValues:yVals1];
//            set1.axisDependency = AxisDependencyLeft;
//            //折线颜色
//            [set1 setColor:ColorThemeRed];
//            [set1 setCircleColor:ColorThemeRed];
//            set1.lineWidth = 1.0;
//            set1.circleRadius = 3.0;
//            set1.fillAlpha = 65/255.0;
//            set1.fillColor = [UIColor blueColor];
//            set1.highlightColor = [UIColor greenColor];
//            set1.drawHorizontalHighlightIndicatorEnabled=NO;  //去掉线
//            set1.drawCircleHoleEnabled = NO;
//            set1.drawVerticalHighlightIndicatorEnabled = NO;
//            //                [_dataSets addObject:set1];
//            [tempArr addObject:set1];
//
//            set2 = [[LineChartDataSet alloc] initWithValues:yVals2];
//            set2.axisDependency = AxisDependencyLeft;
//            set2.lineWidth = 1.0;
//            set2.circleRadius = 3.0;
//            set2.fillAlpha = 65/255.0;
//            set2.fillColor = UIColor.redColor;
//            //折线颜色
//            [set2 setColor:Color(242, 156, 159)];
//            [set2 setCircleColor:Color(242, 156, 159)];
//            set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set2.drawCircleHoleEnabled = NO;
//            set2.drawVerticalHighlightIndicatorEnabled = NO;
//            set2.drawHorizontalHighlightIndicatorEnabled = NO;  //去掉线
//            //                [_dataSets addObject:set2];
//            [tempArr addObject:set2];
//
//
//            set3 = [[LineChartDataSet alloc] initWithValues:yVals3];
//            set3.axisDependency = AxisDependencyLeft;
//            set3.lineWidth = 1.0;
//            set3.circleRadius = 3.0;
//            set3.fillAlpha = 65/255.0;
//            set3.fillColor = [UIColor redColor];
//            //折线颜色
//            [set3 setColor:Color(243, 143, 87)];
//            [set3 setCircleColor:Color(243, 143, 87)];
//            set3.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set3.drawCircleHoleEnabled = NO;
//            set3.drawVerticalHighlightIndicatorEnabled = NO;
//            set3.drawHorizontalHighlightIndicatorEnabled=NO;
//            //                [_dataSets addObject:set3];
//            [tempArr addObject:set3];
//
//
//            set4 = [[LineChartDataSet alloc] initWithValues:yVals4];
//            set4.axisDependency = AxisDependencyLeft;
//            set4.lineWidth = 1.0;
//            set4.circleRadius = 3.0;
//            set4.fillAlpha = 65/255.0;
//            set4.fillColor = [UIColor purpleColor];
//            //折线颜色
//            [set4 setColor:Color(183, 183, 183)];
//            [set4 setCircleColor:Color(183, 183, 183)];
//            set4.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//            set4.drawCircleHoleEnabled = NO;
//            set4.drawVerticalHighlightIndicatorEnabled = NO;
//            set4.drawHorizontalHighlightIndicatorEnabled=NO;
//            //                [_dataSets addObject:set4];
//            [tempArr addObject:set4];
//
            
            [_chartArray addObject:tempArr];
        }
        
    }
    
}

#pragma mark - 按钮 金额、数量、进销
-(void)upBtn:(UIButton *)button{
    
    button.selected = !button.selected;
    
    for (UIButton *btn in _array1) {
        
        btn.selected = NO;
        
        btn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    }
    
    UIButton *btn = button;
    
    btn.selected = YES;
    
    btn.layer.borderColor=ColorThemeRed.CGColor;
    
    
    //    _chartArray = 3 x 4
    [self showChartWith:NO];
    
    
}

#pragma mark - 品牌均值、区域均值、品类均值
-(void)downBtn:(UIButton *)button{
    button.selected = !button.selected;
    
    [self showChartWith:NO];
    
    
}

-(void)showChartWith:(BOOL)firstLoadChart{
    
    NSMutableArray *tempArray = [NSMutableArray new];
    _dataSets = [NSMutableArray new];
    
#pragma mark - 判断上面按钮选中项
    UIButton *upButton;
    UIButton *downButton;
    
    if (!firstLoadChart) {
        
        for (int i = 0; i < 3; i ++) {
            
            upButton = (UIButton *)[self.view viewWithTag:10 + i];
            
            if (upButton.selected) {
                
                [_dataSets addObject: _chartArray[i][0]];
                
                tempArray = _chartArray[i];
                
                break;
            }
        }
        
        for (int i = 0; i < 3; i ++) {
            
            downButton = (UIButton *)[self.view viewWithTag:20 + i];
            
            if (downButton.selected) {
                
                [_dataSets addObject:tempArray[i + 1]];
                
            }
        }
        
    }else{
        
        [_dataSets addObject:_chartArray[0][0]];
        
        
    }
    
//    _data = [[LineChartData alloc] initWithDataSets:_dataSets];
//#pragma mark - 每条折线左侧的数字
//    [_data setValueTextColor:UIColor.clearColor];
//    [_data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//    _chartView.data = _data;
    
}

#pragma mark - 按钮 周销曲线名 + 金额+数量+进销
-(void)createHeadControlsInBottomView{
    
    UIView *secondView = (UIView *)[self.view viewWithTag:222];
    UILabel *back = [[UILabel alloc]initWithFrame:CGRectMake(0, secondView.y + secondView.height, SCREEN_WIDTH, 5 *SCREEN_H_SP)];
    back.backgroundColor = Color(218, 218, 218);
    [_middleAndBelowView addSubview:back];
    
#pragma mark - 周销曲线名
    _chartTitle = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, back.y +back.height + 35 *SCREEN_H_SP, SCREEN_WIDTH - 20 *SCREEN_H_SP, 30 *SCREEN_H_SP)];
    _chartTitle.text = self.dataDic[@"data"][@"chartTitle"];
    _chartTitle.textColor = ColorThemeRed;
    _chartTitle.tag = 777;
    _chartTitle.font = [UIFont systemFontOfSize:14];
    _chartTitle.backgroundColor = [UIColor whiteColor];
    [_middleAndBelowView addSubview:_chartTitle];
    
    
    //    NSArray * arr1 = @[@"金额",@"数量",@"进销"];
    NSArray *arr1 = @[self.dataDic[@"data"][@"chart"][0][@"theme"],self.dataDic[@"data"][@"chart"][1][@"theme"],self.dataDic[@"data"][@"chart"][2][@"theme"]];
    
    _array1 = [NSMutableArray new];
    for (int i =0; i < 3; i ++) {
        
        upBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * i +15 * SCREEN_W_SP, back.y + back.height + 6*SCREEN_H_SP , (SCREEN_WIDTH - 30 *SCREEN_W_SP)/3 - 25 * SCREEN_W_SP , 25 *SCREEN_H_SP)];
        
        if (arr1) {
            [upBtn setTitle:arr1[i] forState:UIControlStateNormal];
        }
        
        [upBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [upBtn setTitleColor:ColorThemeRed forState:UIControlStateSelected];
        
        upBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        upBtn.layer.cornerRadius = 5;
        
        upBtn.clipsToBounds = YES;
        
        upBtn.layer.borderWidth = 0.5;
        
        upBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        [upBtn addTarget:self action:@selector(upBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        upBtn.tag = 10 + i;
        
        if (i == 0) {
            
            upBtn.selected = YES;
            
            upBtn.layer.borderColor=ColorThemeRed.CGColor;
            
            //            [self upBtn:upBtn];
        }
        
        [_array1 addObject:upBtn];
        
        [_middleAndBelowView addSubview:upBtn];
        
    }
    
    
}

#pragma mark - 底部三个按钮
-(void)createBottomButtons{
    
    //    NSArray * arr2 = @[@"品牌均值",@"区域均值",@"品类均值"];
    
    NSMutableArray *arr2 = [NSMutableArray new];
    NSArray *compareTitleArr = self.dataDic[@"data"][@"chart"][0][@"compareTitle"];
    if (compareTitleArr) {
        for (int i = 0; i < compareTitleArr.count; i ++) {
            if ([compareTitleArr[i][@"site"] isEqualToString:[NSString stringWithFormat:@"%d",i + 1]]) {
                
                [arr2 addObject:compareTitleArr[i][@"name"]];
            }
        }
    }
    
    _array2 = [NSMutableArray new];
    
    NSArray * arr3 = @[@"img_图表指示点_粉",@"img_图表指示点_橙",@"img_图表指示点_灰"];
    
    for (int j =0; j < 3; j ++) {
        
        downBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * j +10 * SCREEN_W_SP, _middleAndBelowView.height - (55 - 10)*SCREEN_H_SP , (SCREEN_WIDTH - 20 *SCREEN_W_SP)/3 - 12 * SCREEN_W_SP , 35 *SCREEN_H_SP)];
        
        [downBtn setImage:[UIImage imageNamed:arr3[j]] forState:UIControlStateNormal];
        
        
        [downBtn setTitle:arr2[j] forState:UIControlStateNormal];
        
        [downBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [downBtn setBackgroundColor:[UIColor colorWithHex:0xd8d8d8] forState:UIControlStateNormal];
        
        [downBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
        
        downBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        downBtn.layer.cornerRadius = 3;
        
        downBtn.clipsToBounds = YES;
        
        [downBtn addTarget:self action:@selector(downBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        downBtn.tag = 20 + j;
        
        [_array2 addObject:downBtn];
        
        [_middleAndBelowView addSubview:downBtn];
        
    }
}

#pragma mark - 横坐标展示之前的修改
//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis{
//
//    NSInteger index = value;
//
//    NSString *str = [NSString stringWithString:countArray[index][@"xAxis"]];
//
//    return str;
//}

#pragma mark - 图表中值的点击事件
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    DLog(@"chartValueSelected");
//
//    [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//
//}
//
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    DLog(@"chartValueNothingSelected");
//}

#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    
    calendarBtn.selected = !calendarBtn.selected;
    if (calendarBtn.selected) {
        [sv showView];
    }if (!calendarBtn.selected) {
        [sv backView];
    }
}


#pragma mark - 日历按钮点击事件
-(void) calendarBtn:(NSNotification *)sender{
    
        id vc = [UIApplication sharedApplication ].keyWindow.rootViewController;
    
        if( [vc isMemberOfClass:[LeftSlideViewController class]]){
            LeftSlideViewController* lsvc= (LeftSlideViewController*)vc;
    
            id curvc=lsvc.mainVC;
            if ([curvc isMemberOfClass:[UINavigationController class]]) {
                UINavigationController* navs=(UINavigationController*)lsvc.mainVC;
                curvc=navs.visibleViewController;
            }
    
            if(curvc ==self){
                [self refreshDatasWithCache:YES];
            }
        }
    
        else  if (vc == self) {
            
            [self refreshDatasWithCache:YES];
        }

    calendarBtn.selected = NO;
    
}


- (void)shareBtnClicked:(UIButton *)sender {
    
    ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
    
//    smvc.vi = [LOSHelper getSnapshotImage];

    [self presentViewController:smvc animated:YES completion:^{
        
        
    }];
}


-(void)backBtn:(UIButton *)sender{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoods];
    
    [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark - 切换周销曲线和店铺排行
- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index{

    
}


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
        
       [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中  
    }
    
    if (animationView.tag == 1) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            [animationView startAnimation1];
            
            [self refreshDatasWithCache:YES];

            
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
