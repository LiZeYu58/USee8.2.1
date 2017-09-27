//
//  GuideDetailViewController.m
//  LOSBi
//
//  Created by JJT on 16/11/10.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "GuideDetailViewController.h"
#import "AppDelegate.h"
#import "ShowView.h"
#import "LOSHelper.h"
#import "NSDate+Escort.h"
#import "AppDatas.h"
#import "TableViewCellForDaoGouCell.h"
//#import "DayAxisValueFormatter.h"
#import "GuideDetailMoreViewController.h"
#import "DetailViewController.h"
#import "LOSAFNetworking.h"
#import "MBProgressHUD.h"
#import "AnimationView.h"
#import "GuideDetailMoreViewController.h"
#import "ShareMenuViewController.h"

//IChartAxisValueFormatter,ChartViewDelegate,
@interface GuideDetailViewController ()<UITableViewDelegate,UITableViewDataSource, UIScrollViewDelegate, MBProgressHUDDelegate>
{
    
    UIButton * calendarBtn;
    UIButton *titleBtn;
    UIButton *imageBtn;
    ShowView *sv;
    UIView * topview;
    NSArray<NSString *> *activities;  //雷达图外环数据名称
    UIImageView * headImage; // 头像
    UITableView * informationTab; // 个人信息tableview
    NSDictionary * empPIStr;   // 对应模块的字典
    NSDictionary * empInfoStr;
    NSDictionary * totPIStr;
    NSDictionary * storePIStr;
    NSDictionary * maxPIStr;
//    RadarChartDataSet *set1;  //雷达图数据
//    RadarChartDataSet *set2;
//    RadarChartDataSet *set3;
    UIButton * StoreBtn;  //店铺按钮
    UIButton * totBtn;  // 公司按钮
    UIColor * cl1;   // 颜色
    UIColor * cl2;
    UIScrollView * scrollView1;   //整体下拉的滚动试图
    MBProgressHUD *HUD;
    AnimationView * animationView;  // 下拉动画
    NSInteger firstCreate;   //第一次走创建ui
}
//@property (nonatomic, strong) RadarChartView *chartView;   //雷达图
@property (nonatomic ,strong) NSDictionary *dataDic;  // json返回的数据
@end

@implementation GuideDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        self.view.backgroundColor = [UIColor colorWithHex:0xffffff];
        
        firstCreate = 1;
        
        cl1 = [UIColor colorWithHex:0xd9424c];
        cl2 = [UIColor clearColor];
        
        titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 0, 100, 44)];
        [titleBtn setTitle:self.dimName forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        titleBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        
        self.navigationItem.titleView = titleBtn;
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xba2932];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 0, 30, 44);
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
        [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarButtonItem];
        
        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        [sv CreateView];
        [self.view addSubview:sv];
        
        calendarBtn.hidden = YES;

        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
    
}

#pragma mark - 接口请求
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
       [self refreshDatasWithCache:YES];
    
}

#pragma mark - 接口请求过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache {
    
    @try {
        
        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 接口请求方法
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                
            NSDictionary * requestDic  = [NSDictionary dictionaryWithObjectsAndKeys:
                 [AppDatas sharedDatas].userCode,@"user_code",
                 self.dimCode,@"dim_code",
                 nil];
                
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.EmpSummary"
                            dataParameters:requestDic
                                 withCache:YES
                                   success:^(NSDictionary *responseDic) {
                                       
                                       DLogObject(responseDic);
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
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
                                               
                                               [self refreshDataAndViews];
                                               
                                           } else {
                                               
                                               HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                                           [self createUI];
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框    
                                           
                                           
                                           if (error.code == -1001) {
                                               
                                               [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                               
                                               
                                           }else{
                                               
                                               [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];                           }
                                       });
                                   }];
            });
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
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

#pragma mark -  刷新界面
- (void)refreshDataAndViews {
    
    @try {
     
        if (self.dataDic) {
            
            empPIStr = self.dataDic[@"data"][@"empPI"];
            empInfoStr = self.dataDic[@"data"][@"empInfo"];
            totPIStr = self.dataDic[@"data"][@"totPI"];
            storePIStr = self.dataDic[@"data"][@"storePI"];
            maxPIStr = self.dataDic[@"data"][@"maxPI"];
            
            
          //  if (!empInfoStr[@"empImg"]) {
                
                
//                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:empInfoStr[@"empImg"]]];
//                headImage.image = [UIImage imageWithData:data];;
                
            [headImage sd_setImageWithURL:[NSURL URLWithString:empInfoStr[@"empImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                
        //    }else{
                
        //        headImage.image = [UIImage imageNamed:@"默认头像"];
                
        //    }
            
            [informationTab reloadData];
            
            NSArray * empPIArray = @[empPIStr[@"numTrade"],empPIStr[@"numNewVip"],empPIStr[@"amtDiscount"],empPIStr[@"amtTrade"],empPIStr[@"numRate"],empPIStr[@"numSales"]];
            NSArray * totPIArray = @[totPIStr[@"numTrade"],totPIStr[@"numNewVip"],totPIStr[@"amtDiscount"],totPIStr[@"amtTrade"],totPIStr[@"numRate"],totPIStr[@"numSales"]];
            NSArray * storePIArray = @[storePIStr[@"numTrade"],storePIStr[@"numNewVip"],storePIStr[@"amtDiscount"],storePIStr[@"amtTrade"],storePIStr[@"numRate"],storePIStr[@"numSales"]];
            NSArray * maxPIArray = @[maxPIStr[@"numTrade"],maxPIStr[@"numNewVip"],maxPIStr[@"amtDiscount"],maxPIStr[@"amtTrade"],maxPIStr[@"numRate"],maxPIStr[@"numSales"]];
            
            NSString * s1;
            
            if ([empPIArray[0] length] == 1) {
                s1 = [NSString stringWithFormat:@"%@\n      %@",@"零售笔数",empPIArray[0]];
            }
            else if ([empPIArray[0] length] == 2){
                s1 = [NSString stringWithFormat:@"%@\n      %@",@"零售笔数",empPIArray[0]];
            }
            else if ([empPIArray[0] length] == 3){
                s1 = [NSString stringWithFormat:@"%@\n     %@",@"零售笔数",empPIArray[0]];
            }
            else if ([empPIArray[0] length] == 4){
                s1 = [NSString stringWithFormat:@"%@\n   %@",@"零售笔数",empPIArray[0]];
            }
            else{
                s1 = [NSString stringWithFormat:@"%@\n  %@",@"零售笔数",empPIArray[0]];
            }
            
            
            NSString * s2;
            
            if ([empPIArray[1] length] == 1) {
                s2 = [NSString stringWithFormat:@"%@\n      %@",@"会销人数",empPIArray[1]];
            }
            else if ([empPIArray[1] length] == 2){
                s2 = [NSString stringWithFormat:@"%@\n      %@",@"会销人数",empPIArray[1]];
            }
            else if ([empPIArray[1] length] == 3){
                s2 = [NSString stringWithFormat:@"%@\n     %@",@"会销人数",empPIArray[1]];
            }
            else if ([empPIArray[1] length] == 4){
                s2 = [NSString stringWithFormat:@"%@\n   %@",@"会销人数",empPIArray[1]];
            }
            else{
                s2 = [NSString stringWithFormat:@"%@\n  %@",@"会销人数",empPIArray[1]];
            }
            
            
            NSString * s3 = [NSString stringWithFormat:@"%@\n %@",@"折扣",empPIArray[2]];
            NSString * s4;
            
            if ([empPIArray[3] length] == 1) {
                s4 = [NSString stringWithFormat:@"%@\n      %@",@"零售金额",empPIArray[3]];
            }
            else if ([empPIArray[3] length] == 2){
                s4 = [NSString stringWithFormat:@"%@\n      %@",@"零售金额",empPIArray[3]];
            }
            else if ([empPIArray[3] length] == 3){
                s4 = [NSString stringWithFormat:@"%@\n     %@",@"零售金额",empPIArray[3]];
            }
            else if ([empPIArray[3] length] == 4){
                s4 = [NSString stringWithFormat:@"%@\n   %@",@"零售金额",empPIArray[3]];
            }
            else{
                s4 = [NSString stringWithFormat:@"%@\n  %@",@"零售金额",empPIArray[3]];
            }
            
            
            
            NSString * s5;
            
            if ([empPIArray[4] length] == 1) {
                s5 = [NSString stringWithFormat:@"%@\n     %@",@"连带率",empPIArray[4]];
            }
            else if ([empPIArray[4] length] == 2) {
                s5 = [NSString stringWithFormat:@"%@\n  %@",@"连带率",empPIArray[4]];
            }
            else if ([empPIArray[4] length] == 3) {
                s5 = [NSString stringWithFormat:@"%@\n   %@",@"连带率",empPIArray[4]];
            }
            else{
                s5 = [NSString stringWithFormat:@"%@\n %@",@"连带率",empPIArray[4]];
            }
            
            NSString * s6;
            
            if ([empPIArray[5] length] == 1) {
                s6 = [NSString stringWithFormat:@"%@\n      %@",@"零售件数",empPIArray[5]];
            }
            else if ([empPIArray[5] length] == 2){
                s6 = [NSString stringWithFormat:@"%@\n     %@",@"零售件数",empPIArray[5]];
            }
            else if ([empPIArray[5] length] == 3){
                s6 = [NSString stringWithFormat:@"%@\n     %@",@"零售件数",empPIArray[5]];
            }
            else if ([empPIArray[5] length] == 4){
                s6 = [NSString stringWithFormat:@"%@\n    %@",@"零售件数",empPIArray[5]];
            }
            else{
                s6 = [NSString stringWithFormat:@"%@\n  %@",@"零售件数",empPIArray[5]];
            }
            
            activities = @[s1,s2,s3,s4,s5,s6];
            
            if (StoreBtn) {
                
                [self updateChartDataWithempPIArray:empPIArray color:cl1 WithtotPIArray:totPIArray WithstorePIArray:storePIArray WithmaxPIArray:maxPIArray color:cl2];
                
            }
            
            if (totBtn) {
                
                [self updateChartDataWithempPIArray:empPIArray color:cl1 WithtotPIArray:totPIArray WithstorePIArray:storePIArray WithmaxPIArray:maxPIArray color:cl2];
                
            }
            
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];

        
    } @finally {
        
    }
    
}

#pragma mark -  刷新雷达图
- (void)updateChartDataWithempPIArray:(NSArray *)empPIArray color:(UIColor *)StoreBtnColor WithtotPIArray:(NSArray *)totPIArray WithstorePIArray:(NSArray *)storePIArray WithmaxPIArray:(NSArray *)maxPIArray color:(UIColor *)totBtnColor
{
    
    @try {
        NSMutableArray *entries1 = [[NSMutableArray alloc] init];
        NSMutableArray *entries2 = [[NSMutableArray alloc] init];
        NSMutableArray *entries3 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < empPIArray.count; i++)
        {
            
            if (maxPIArray[i] == 0 || [maxPIArray[i]isEqualToString:@"0"]) {
                
//                [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
            }else{
                
                 double empPercentageDouble  = [empPIArray[i] doubleValue] / [maxPIArray[i] doubleValue];
                
//                if (empPercentageDouble < 0) {
//
//                    [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
//                }
//                else if (empPercentageDouble > 0.9){
//
//                    [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:0.9]];
//                }
//                else{
//
//                      [entries1 addObject:[[RadarChartDataEntry alloc] initWithValue:empPercentageDouble]];
//                }
                
            }
            
        }
        for (int i = 0; i < storePIArray.count; i++)
        {
            if (maxPIArray[i] == 0 || [maxPIArray[i]isEqualToString:@"0"]) {
                
//                [entries2 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
            }else{
                
                double storePIPercentageDouble  = [storePIArray[i] doubleValue] / [maxPIArray[i] doubleValue];
//
//                if (storePIPercentageDouble < 0) {
//
//                    [entries2 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
//                }
//                else if (storePIPercentageDouble > 0.9){
//
//                    [entries2 addObject:[[RadarChartDataEntry alloc] initWithValue:0.9]];
//                }
//                else{
//
//                    [entries2 addObject:[[RadarChartDataEntry alloc] initWithValue:storePIPercentageDouble]];
//                }
            }
            
        }
        for (int i = 0; i < totPIArray.count; i++)
        {
            if (maxPIArray[i] == 0 || [maxPIArray[i]isEqualToString:@"0"]) {
                
//                [entries3 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
            }else{
                
                
                double totPIPercentageDouble  = [totPIArray[i] doubleValue] / [maxPIArray[i] doubleValue];
                
                if (totPIPercentageDouble < 0) {
                    
//                    [entries3 addObject:[[RadarChartDataEntry alloc] initWithValue:0]];
                }
                else if (totPIPercentageDouble > 0.9){
                    
//                    [entries3 addObject:[[RadarChartDataEntry alloc] initWithValue:0.9]];
                }
                else{
                    
//                    [entries3 addObject:[[RadarChartDataEntry alloc] initWithValue:totPIPercentageDouble]];
                }

            }
        }
        
//        set1 = [[RadarChartDataSet alloc] initWithValues:entries1 label:@"This Week"];
//        [set1 setColor:Color(218, 148, 153)];
//        set1.fillColor = [UIColor redColor];
//        set1.drawFilledEnabled = YES;
//        set1.fillAlpha = 0.5;
//        set1.lineWidth = 1.0;
//        set1.drawHighlightCircleEnabled = NO;
//        [set1 setDrawHighlightIndicators:NO];
//
//        set2 = [[RadarChartDataSet alloc] initWithValues:entries2 label:@"Last Week"];
//        [set2 setColor: StoreBtnColor];
//        set2.fillColor = [UIColor clearColor];
//        set2.drawFilledEnabled = YES;
//        set2.fillAlpha = 0.7;
//        set2.lineWidth = 1.0;
//        set2.drawHighlightCircleEnabled = NO;
//        [set2 setDrawHighlightIndicators:NO];
//
//        set3 = [[RadarChartDataSet alloc] initWithValues:entries3 label:@"Next Week"];
//        [set3 setColor:totBtnColor];
//        set3.fillColor = [UIColor clearColor];
//        set3.drawFilledEnabled = YES;
//        set3.fillAlpha = 0.7;
//        set3.lineWidth = 1.0;
//        set3.drawHighlightCircleEnabled = NO;
//        [set3 setDrawHighlightIndicators:NO];
//
//        RadarChartData *data = [[RadarChartData alloc] initWithDataSets:@[set1, set2,set3]];
//        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:8.f]];
//        [data setDrawValues:NO];
//        data.valueTextColor = UIColor.whiteColor;
//
//        _chartView.data = data;
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];

    } @finally {
        
    }
    
}


#pragma mark -  创建UI
-(void)createUI{
    
    @try {
        
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
            
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, self.view.height)];
        }
        else{
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.height)];
        }
        scrollView1.delegate =self;
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.contentSize = CGSizeMake(0, 0);
        scrollView1.alwaysBounceVertical = YES;
        [self.view addSubview:scrollView1];
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 100)];
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        [animationView Animation];
        [animationView Animation1];
        [scrollView1 addSubview:animationView];
        
        topview = [[UIView alloc]initWithFrame:CGRectMake(5 * SCREEN_W_SP, 5 * SCREEN_H_SP, SCREEN_WIDTH - 10 * SCREEN_W_SP, 244 * SCREEN_H_SP)];
        topview.backgroundColor = [UIColor whiteColor];
        [scrollView1 addSubview:topview];
        
        UIView * basicView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topview.frame.size.width, 44 * SCREEN_H_SP)];
        basicView.backgroundColor = [UIColor colorWithHex:0xba2932];
        [topview addSubview:basicView];
        
        UILabel * basicLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 44 * SCREEN_H_SP)];
        basicLab.text = @"基础信息";
        basicLab.textColor = [UIColor colorWithHex:0xffffff];
        basicLab.font = [UIFont systemFontOfSize:14];
        [basicView addSubview:basicLab];
#pragma mark 打电话按钮   目前先注释
//        UIButton * phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(basicView.frame.size.width - 44 * SCREEN_W_SP, 0, 44 * SCREEN_W_SP, 44 * SCREEN_H_SP)];
//        [phoneBtn setImage:[UIImage imageNamed:@"icon_phone_d"] forState:UIControlStateNormal];
//        [phoneBtn setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateSelected];
//        
//        [phoneBtn addTarget:self action:@selector(phoneBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [basicView addSubview:phoneBtn];
        
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, basicView.frame.origin.y + basicView.frame.size.height + 10 * SCREEN_H_SP, 130 * SCREEN_W_SP, 180 * SCREEN_H_SP)];
    
        [topview addSubview:headImage];
        
        informationTab = [[UITableView alloc]initWithFrame:CGRectMake(headImage.frame.origin.x + headImage.frame.size.width + 10 * SCREEN_W_SP, basicView.frame.origin.y + basicView.frame.size.height + 10 * SCREEN_H_SP, topview.frame.size.width - 30 * SCREEN_W_SP - headImage.frame.size.width, topview.frame.size.height - 20 * SCREEN_H_SP - basicView.frame.size.height)];
        informationTab.dataSource = self;
        informationTab.delegate = self;
        informationTab.rowHeight = 30 * SCREEN_H_SP;
        informationTab.scrollEnabled = NO;
        [topview addSubview:informationTab];
        informationTab.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        [informationTab registerClass:[TableViewCellForDaoGouCell class] forCellReuseIdentifier:@"TableViewCellForDaoGouCell"];
        
        [self downView];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark - 下方视图
-(void)downView{
    
    @try {
     
        UIView *downView = [[UIView alloc]initWithFrame:CGRectMake(5, topview.frame.origin.y + topview.frame.size.height + 10 * SCREEN_W_SP, SCREEN_WIDTH - 10, SCREEN_HEIGHT - 25 * SCREEN_H_SP - topview.frame.size.height - 64)];
        downView.backgroundColor = [UIColor blackColor];
        [scrollView1 addSubview:downView];
        
        UIView * abilityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, topview.frame.size.width, 44 * SCREEN_H_SP)];
        abilityView.backgroundColor = [UIColor colorWithHex:0xba2932];
        [downView addSubview:abilityView];
        
        UILabel * abilityLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 44 * SCREEN_H_SP)];
        abilityLab.text = @"日均业绩";
        abilityLab.textColor = [UIColor colorWithHex:0xffffff];
        abilityLab.font = [UIFont systemFontOfSize:14];
        [abilityView addSubview:abilityLab];
        
        
        StoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (SCREEN_HEIGHT == 812) {
            StoreBtn.frame = CGRectMake(downView.frame.size.width / 4 * 3, downView.frame.size.height - 75 * SCREEN_H_SP - 30, downView.frame.size.width / 4 - 10 * SCREEN_W_SP, 30 * SCREEN_H_SP);
        }
        else{
            StoreBtn.frame = CGRectMake(downView.frame.size.width / 4 * 3, downView.frame.size.height - 75 * SCREEN_H_SP, downView.frame.size.width / 4 - 10 * SCREEN_W_SP, 30 * SCREEN_H_SP);
        }
        
        [StoreBtn.layer setMasksToBounds:YES];
        StoreBtn.layer.cornerRadius = 3;
        [StoreBtn setBackgroundColor:[UIColor colorWithHex:0xd9424c] forState:UIControlStateSelected];
        [StoreBtn setTitle:@"店铺平均" forState:UIControlStateNormal];
        StoreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [StoreBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
        [StoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        StoreBtn.selected = YES;
        [StoreBtn addTarget:self action:@selector(StoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        totBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        totBtn.frame = CGRectMake(StoreBtn.frame.origin.x, StoreBtn.frame.origin.y + 35 * SCREEN_H_SP, downView.frame.size.width / 4 - 10 * SCREEN_W_SP, 30 * SCREEN_H_SP);
        [totBtn.layer setMasksToBounds:YES];
        totBtn.layer.cornerRadius = 3;
        [totBtn setBackgroundColor:[UIColor colorWithHex:0xe4e4e4] forState:UIControlStateNormal];
        [totBtn setTitle:@"公司平均" forState:UIControlStateNormal];
        totBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [totBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
        [totBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [totBtn addTarget:self action:@selector(totBtn:) forControlEvents:UIControlEventTouchUpInside];
        
      UIView * _chartView = [[UIView alloc] init];
        
        
      if (SCREEN_HEIGHT == 812) {
            _chartView.frame = CGRectMake(abilityView.frame.origin.x + 10 * SCREEN_W_SP, abilityView.frame.size.height, downView.frame.size.width - 15 * SCREEN_W_SP, downView.frame.size.height - abilityView.frame.size.height - 50);
        }
      else{
      
         _chartView.frame = CGRectMake(abilityView.frame.origin.x + 10 * SCREEN_W_SP, abilityView.frame.size.height, downView.frame.size.width - 15 * SCREEN_W_SP, downView.frame.size.height - abilityView.frame.size.height);
      }
        
     _chartView.backgroundColor = [UIColor redColor];
     [downView addSubview:_chartView];
//        _chartView = [[RadarChartView alloc]initWithFrame:CGRectMake(abilityView.frame.origin.x + 10 * SCREEN_W_SP, abilityView.frame.size.height, downView.frame.size.width - 15 * SCREEN_W_SP, downView.frame.size.height - abilityView.frame.size.height)];
//        [downView addSubview:_chartView];
//        _chartView.delegate = self;
//        //图注
//        _chartView.legend.enabled = NO;
//        _chartView.rotationEnabled = NO;
//        _chartView.descriptionText = @"";
//        _chartView.webLineWidth = 1;
//        _chartView.innerWebLineWidth = 1;
//        _chartView.webColor = [UIColor colorWithHex:0xe4e4e4];
//        _chartView.innerWebColor = [UIColor colorWithHex:0xe4e4e4];
//        _chartView.webAlpha = 1.0;
//        _chartView.rotationAngle = 60;
//        //_chartView.requiredLegendOffset
//        //@property (nonatomic, readonly) CGFloat requiredLegendOffset;
//        //@property (nonatomic, readonly) CGFloat requiredBaseOffset;
//
//        ChartXAxis *xAxis = _chartView.xAxis;
//        xAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//        xAxis.labelPosition = XAxisLabelPositionBottomInside;
//        xAxis.avoidFirstLastClippingEnabled = YES;
//        xAxis.valueFormatter = self;
//        xAxis.labelTextColor = [UIColor colorWithHex:0x888888];
//
//        ChartYAxis *yAxis = _chartView.yAxis;
//        yAxis.labelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
//
//        yAxis.axisMinValue = 0.0;//最小值
//        yAxis.axisMaxValue = 0.9;//最大值
//
//        [yAxis setLabelCount:6 force:YES];
//        yAxis.drawLabelsEnabled = NO;
//        [yAxis needsOffset];
        
        [downView addSubview:StoreBtn];
        [downView addSubview:totBtn];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - ChartViewDelegate
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    DLog(@"chartValueSelected");
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    DLog(@"chartValueNothingSelected");
//}
//
//#pragma mark - IAxisValueFormatter
//
//- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
//{
//    @try {
//
//        int ww = (int) value % activities.count;
//
//         return activities[ww];
//
//    } @catch (NSException *exception) {
//
//        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
//
//        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//}

#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
       return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        TableViewCellForDaoGouCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForDaoGouCell"];
        
        switch (indexPath.row) {
            case 0:
                
                cell.nameLab.text = empInfoStr[@"sexEmp"];
                
                cell.numLab.text = empInfoStr[@"age"];
                
                break;
            case 1:
                
                cell.nameLab.text = _dimStoreName;
                
                cell.numLab.text = empInfoStr[@"empType"];
                
                
                break;
            case 2:
                
                cell.nameLab.text = self.dimBrandName;
                
                cell.numLab.text = @"";
                
                
                break;
            case 3:
            {
                cell.nameLab.text = @"在职";
                
                NSString * days = [NSString stringWithFormat:@"%@%@",empInfoStr[@"days"],@"天"];
                
                cell.numLab.text = days;
            }
                
                break;
                
                //        case 4:
                //        {
                //            cell.nameLab.text = @"打开爱秀";
                //
                //            NSString * counts = [NSString stringWithFormat:@"%@%@",empInfoStr[@"openIShow"],@"次"];
                //
                //
                //            cell.numLab.text = counts;
                //        }
                //            break;
                //
                //        case 5:
                //        {
                //            
                //            cell.nameLab.text = @"联系顾客";
                //            
                //            NSString * contact = [NSString stringWithFormat:@"%@%@",empInfoStr[@"contactVips"],@"次"];
                //            
                //            cell.numLab.text = contact;
                //            
                //        }
                // 
                //            break;
            default:
                break;
        }
        
        return cell;

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return 160/4;
}

#pragma mark - 拨打电话
-(void)phoneBtn:(UIButton *)sender{
    
    @try {
     
        NSString * phoneNum = self.dataDic[@"data"][@"empInfo"][@"phoneNum"];
        
        if (phoneNum == nil) {
            
            phoneNum = @"空号";
        }
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:phoneNum
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"呼叫"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              NSURL *callUrl = [NSURL URLWithString:
                                                                                [@"tel://" stringByAppendingString:phoneNum]];
                                                              if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                                                                  [[UIApplication sharedApplication] openURL:callUrl];
                                                              }
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                          }]];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)moreBtn:(UIButton *)sender{

    @try {
     
        GuideDetailMoreViewController * guideDetailMore = [GuideDetailMoreViewController new];
        
        guideDetailMore.dimName = self.dimName;
        
        [self.navigationController pushViewController:guideDetailMore animated:YES];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 店铺平均按钮
-(void)StoreBtn:(UIButton *)sender{
    
    @try {
       
        sender.selected = !sender.selected;
        
        if (sender.selected) {
            
            [sender setBackgroundColor:[UIColor colorWithHex:0xd9424c] forState:UIControlStateSelected];
            
            cl1 = [UIColor colorWithHex:0xd9424c];
            
            
        }else{
            
            [sender setBackgroundColor:[UIColor colorWithHex:0xe4e4e4] forState:UIControlStateNormal];
            
            cl1 = [UIColor clearColor];
        }
        
        
        [self refreshDataAndViews];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 公司平均按钮
-(void)totBtn:(UIButton *)sender{
    
    @try {
       
        sender.selected = !sender.selected;
        if (sender.selected) {
            
            [totBtn setBackgroundColor:Color(253,173, 59) forState:UIControlStateSelected];
            cl2 = Color(253,173, 59);
            
        }else{
            
            [sender setBackgroundColor:[UIColor colorWithHex:0xe4e4e4] forState:UIControlStateNormal];
            cl2 = [UIColor clearColor];
        }
        
        [self refreshDataAndViews];

        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    
    @try {
        
        calendarBtn.selected = !calendarBtn.selected;
        if (calendarBtn.selected) {
            
            //[self hehe];
            
            [sv showView];
        }if (!calendarBtn.selected) {
            [sv backView];
        }
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)shareBtnClicked:(UIButton *)sender {
    
    @try {
       
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
        
        //        smvc.vi = [LOSHelper getSnapshotImage];
        
        
        [self presentViewController:smvc animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark -  返回按钮
-(void)leftBarBtnClicked{
    
    @try {
     
        [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
        [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark -  下拉刷新回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [animationView startAnimation];
    
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
            
            animationView.tag = 0;
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
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
                
                [animationView startAnimation1];
                
                [self refreshDatasWithCache:YES];
                
                scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    animationView.tag = 0;
                }];
            });
        }
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"导购详情  GuideDetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


@end
