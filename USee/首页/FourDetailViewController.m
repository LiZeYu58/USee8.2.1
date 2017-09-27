//
//  FourDetailViewController.m
//  LOSBi
//
//  Created by JJT on 16/9/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //商品排行详情页面



#import "FourDetailViewController.h"
#import "AppDelegate.h"
#import "ShowView.h"
#import "ShareMenuViewController.h"
#import "BigBtnView.h"
//#import "Charts.h"
#import "LOSHelper.h"
#import "AppDatas.h"
#import "LOSAFNetworking.h"
#import "TableViewCellForDetailStoreRank.h"
#import "MBProgressHUD.h"

#import "AnimationView.h"
#import "ShangPinView.h"
#import "LeftSortsViewController.h"

#define colorTitle [UIColor colorWithHex:0x888888]
#define colorText  [UIColor colorWithHex:0x8d8d8d]
//ChartViewDelegate,IChartAxisValueFormatter,
@interface FourDetailViewController ()<BigBtnViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, MBProgressHUDDelegate> {
    
    BOOL _UIIsCreated;
    BOOL _storeRankIsCreated;
    
    NSInteger firstCreate;
    NSInteger CycleCurveFirstCreate;
    NSInteger _selectIndex;
    
    NSInteger _firstinside;
    
    NSMutableArray *_dataSets;
    NSMutableArray *countArray;
    
    UIView *_middleAndBelowView;
    UILabel *jgLab;
    UILabel *jgNum;
    UILabel *khLab;
    UILabel *nfLab;
    UILabel *jjLab;
    UILabel *bdLab;
    UIImageView *image;
    UIButton *upBtn;
    UIButton *downBtn;
    UIButton *calendarBtn;
    UIScrollView *scrollView1;
    UITableView *_tableView;
    
    BigBtnView *btnView;
    ShowView *sv;
    MBProgressHUD *HUD;
    AnimationView *animationView;
//    LineChartDataSet *set1, *set2, *set3, *set4;
//    LineChartData *_data;
    
}

@end

@implementation FourDetailViewController


-(NSMutableArray *)dataSourceArr{
    
    @try {
       
        if (!_dataSourceArr) {
            _dataSourceArr = nil;
            _dataSourceArr = [NSMutableArray new];
        }
        return _dataSourceArr;
        
    } @catch (NSException *exception) {
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];

    @try {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
        
        _firstinside = 1;
        firstCreate = 1;
        CycleCurveFirstCreate = 1;
        
        _selectIndex  = 0;
        self.view.backgroundColor = [UIColor whiteColor];
        
#pragma mark - 导航栏内容
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 0, 30, 44);
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [leftBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
        
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
        
        UIView *rightBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
        [rightBtnsView addSubview:shareBtn];
        [rightBtnsView addSubview:calendarBtn];
        calendarBtn.x = 28;
        shareBtn.x = 70;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
        
        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        [sv send:^(NSInteger sendInt) {
            
            if (sendInt == 1) {
                AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:LeftViewTypeMain];
                
            }
            
        }];
        [sv CreateView];
        [self.view addSubview:sv];
        
        
#pragma mark  检查网络
        //接口请求
        [self refreshGoodsArchivesWithCache:YES];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)leftBarBtnClicked{
    
    @try {
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
        
        [tempAppDelegate.mainNavigationController popToRootViewControllerAnimated:YES];

        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark -  获得点击的日期/时段

- (void)selectedDates:(NSNotification *)notification {
    
    @try {
        
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
        
//        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        
//        [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:LeftViewTypeMain];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求商品档案接口前的过渡方法
- (void)refreshGoodsArchivesWithCache:(BOOL)isUseCache {
    
    @try {
        
        [self requestGoodsArchivesDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                                         toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                                         withCache:isUseCache];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 请求店铺排行接口前的过渡方法
- (void)refreshStoreRankingWithCache:(BOOL)isUseCache{
    
    @try {
     
        [self requestStoreRankingDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                                        toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                                        withCache:isUseCache];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 请求周销曲线接口前的过渡方法
- (void)refreshCycleCurveWithCache:(BOOL)isUseCache{
    
    @try {
     
        [self requestCycleCurveDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                                      toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                                      withCache:isUseCache];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
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

#pragma mark - 接口请求
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @try {
        

        
       
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 商品详情接口请求
- (void)requestGoodsArchivesDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
         //   [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news2.ProductDetail"
                            dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                            
                                            [AppDatas sharedDatas].userCode,@"user_code",
                                            _productCode,@"product_code",
                                            [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd, @"start_date",
                                            [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd, @"end_date",
                                            nil]
                                 withCache:YES
                                   success:^(NSDictionary *responseDic) {
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                           //                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           DLogObject(responseDic);
                                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                               self.GoodsArchivesDataDic = responseDic;
                                               
                                               self.title = self.GoodsArchivesDataDic[@"data"][@"porductName"];
                                               
                                               [animationView stopAnimating1];
                                               
                                               scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                               
                                               
                           
                                               
                                               if (firstCreate == 1) {
                                                   [self createGoodsArchivesMiddleViewUI];
                                                   firstCreate = 2;
                                               }
                                               else{
                                                   [self refershGoodsArchivesViewAndData];
                                               }
                                        
                            if (_firstinside == 1) {
                              
                                if (_selectIndex == 0) {
                                    
                                    
                                    [self refreshStoreRankingWithCache:YES];
                                }
                                else{
                                    
                                    [self refreshCycleCurveWithCache:YES];
                                }

                                _firstinside = 2;
                            }
                                               
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
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           [animationView stopAnimating1];
                                           
                                           scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                           
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 店铺排行接口请求
- (void)requestStoreRankingDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
             NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                 
                 [AppDatas sharedDatas].userCode,@"user_code",
                 _productCode,@"product_code",
                 [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd, @"start_date",
                 [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd, @"end_date",
                 
                                       nil];

                
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news2.ProductDetailStoreSort"
                            dataParameters:dataDic                                 withCache:YES
                                   success:^(NSDictionary *responseDic) {
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                               self.StoreRankingDataDic = responseDic;
                                               
                                               [animationView stopAnimating1];
                                               
                                               scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                               
                                               [self createDianPu];
                                               
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
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           [animationView stopAnimating1];
                                           
                                           scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                           
                                           
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 周销曲线接口请求
-(void)requestCycleCurveDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news2.ProductDetailTrend"
                            dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                            
                                            [AppDatas sharedDatas].userCode,@"user_code",
                                            _productCode,@"product_code",
                                            [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd, @"start_date",
                                            [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd, @"end_date",
                                            
                                            nil]
                                 withCache:YES
                                   success:^(NSDictionary *responseDic) {
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                               self.CycleCurveDataDic = responseDic;
                                               
                                               [animationView stopAnimating1];
                                               
                                               scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                               
                                               if (CycleCurveFirstCreate == 1) {
                                                   [self creatCycleCurveMiddleViewUI];
                                                   
                                                   CycleCurveFirstCreate = 2;
                                               }
                                               else{
                                                   [self refreshCycleCurveData];
                                               }
                                               
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
                                           
                                           
                                           [animationView stopAnimating1];
                                           
                                           scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                           
                                           
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark - 刷新本页视图和数据
-(void)refershGoodsArchivesViewAndData{
    
    @try {
        
        if (!self.GoodsArchivesDataDic) {
            return;
            
        }
        
        if (self.GoodsArchivesDataDic) {
            
            //    赋图
            //        NSURL *url = [NSURL URLWithString:self.dataDic[@"data"][@"productImage"]];
            //        NSData * data = [NSData dataWithContentsOfURL:url];
            
            [image sd_setImageWithURL:[NSURL URLWithString:_imgPureURL]placeholderImage:[UIImage imageNamed:@"img_商品详情默认图"]];
            
            
            //        if (self.productImg) {
            //
            //            image.image = [self resizeImageToSpecifiedSize:image.size image:self.productImg];
            //
            //        } else {
            //
            //            image.image = [UIImage imageNamed:@"img_商品详情默认图"];
            //
            //        }
            
            if (self.GoodsArchivesDataDic[@"data"][@"name1"]) {
                jgLab.text = self.GoodsArchivesDataDic[@"data"][@"name1"];
            }
            
            if (self.GoodsArchivesDataDic[@"data"][@"value1"]) {
                jgNum.text =[NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value1"]];
            }
            
            if (self.GoodsArchivesDataDic[@"data"][@"name2"] && self.GoodsArchivesDataDic[@"data"][@"value2"]) {
                khLab.text = [NSString stringWithFormat:@"%@  %@",self.GoodsArchivesDataDic[@"data"][@"name2"],self.GoodsArchivesDataDic[@"data"][@"value2"]];
            }
            if (self.GoodsArchivesDataDic[@"data"][@"name3"] && self.GoodsArchivesDataDic[@"data"][@"value3"]) {
                nfLab.text = [NSString stringWithFormat:@"%@   %@",self.GoodsArchivesDataDic[@"data"][@"name3"],self.GoodsArchivesDataDic[@"data"][@"value3"]];
            }
            if (self.GoodsArchivesDataDic[@"data"][@"value4"] && self.GoodsArchivesDataDic[@"data"][@"name4"]) {
                jjLab.text = [NSString stringWithFormat:@"%@   %@",self.GoodsArchivesDataDic[@"data"][@"name4"],self.GoodsArchivesDataDic[@"data"][@"value4"]];
            }
            if (self.GoodsArchivesDataDic[@"data"][@"value5"] && self.GoodsArchivesDataDic[@"data"][@"name5"]) {
                bdLab.text = [NSString stringWithFormat:@"%@   第%@波段",self.GoodsArchivesDataDic[@"data"][@"name5"],self.GoodsArchivesDataDic[@"data"][@"value5"]];
            }
            
        }
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark 刷新周销曲线数据
-(void)refreshCycleCurveData{
    
    @try {
     
        NSArray *arr1 = @[self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"theme"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][1][@"theme"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][2][@"theme"]];
        
        for (int i =0; i < 3; i ++) {
            
            if (arr1) {
                [upBtn setTitle:arr1[i] forState:UIControlStateNormal];
            }
        }
        
        [self loadChartData];
        //默认展示折线图
        [self showChartWith:NO];
        NSArray *arr2 = @[self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][0][@"name"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][1][@"name"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][2][@"name"]];
        
        for (int j =0; j < 3; j ++) {
            
            [downBtn setTitle:arr2[j] forState:UIControlStateNormal];
            
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 图片的处理
-(UIImage *) resizeImageToSpecifiedSize:(CGSize)size image:(UIImage *)originImage {
    
    @try {
       
        UIImage *scaledImage = [self scaleImageCloserToSpecifiedSize:size image:originImage];
        
        return [self subtractImageToSpecifiedSize:size image:scaledImage];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(UIImage *) scaleImageCloserToSpecifiedSize:(CGSize)size image:(UIImage *)originImage {
    
    @try {
        
        CGSize originImageSize = [originImage size];
        Boolean bigerThanView = originImageSize.width >= size.width || originImageSize.height >= size.height ? YES : NO;
        CGFloat widthRatio = originImageSize.width / size.width;
        CGFloat heightRatio = originImageSize.height / size.height;
        //图片宽或高大于UIView，取长宽比小的做缩放基准，小于则反之
        CGFloat scaleRatio = bigerThanView ? (widthRatio < heightRatio ? widthRatio : heightRatio) : (widthRatio < heightRatio ? heightRatio : widthRatio);
        CGFloat scaleWidth = originImageSize.width / scaleRatio;
        CGFloat scaleHeight = originImageSize.height / scaleRatio;
        
        //图片缩放至最接近UIView宽高比
        UIGraphicsBeginImageContext(CGSizeMake(scaleWidth, scaleHeight));
        [originImage drawInRect:CGRectMake(0, 0, scaleWidth, scaleHeight)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return scaledImage;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(UIImage *) subtractImageToSpecifiedSize:(CGSize)size image:(UIImage *)originImage {
    
    @try {
     
        //取图片中间区域，裁切成UIView宽高
        CGFloat newX = (originImage.size.width - size.width) / 2;
        CGFloat newY = (originImage.size.height - size.height) / 2;
        CGImageRef imageRef = CGImageCreateWithImageInRect([originImage CGImage], CGRectMake(newX, newY, size.width, size.height));
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        
        return croppedImage;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 创建中部视图
-(void)createGoodsArchivesMiddleViewUI
{
    @try {
     
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, self.view.height)];
        }
        else{
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.view.height)];
        }
        
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.userInteractionEnabled = YES;
        scrollView1.delegate =self;
        scrollView1.contentSize = CGSizeMake(0, self.view.height);
        
        scrollView1.alwaysBounceVertical = YES;
        [self.view addSubview:scrollView1];
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300 * SCREEN_H_SP - 64)];
        image.contentMode = UIViewContentModeScaleAspectFit;
        
        [scrollView1 addSubview:image];
        
        [image sd_setImageWithURL:[NSURL URLWithString:_imgPureURL]placeholderImage:[UIImage imageNamed:@"img_商品详情默认图"]];
        //    if (self.productImg) {
        //
        //        image.image = [self resizeImageToSpecifiedSize:image.size image:self.productImg];
        //
        //    } else {
        //
        //        image.image = [UIImage imageNamed:@"img_商品详情默认图"];
        //
        //    }
        
        //承载middle及其以下视图的view
        _middleAndBelowView = [[UIView alloc]initWithFrame:CGRectMake(0, image.y + image.height, SCREEN_WIDTH, SCREEN_HEIGHT - (image.y + image.height))];
        [scrollView1 addSubview:_middleAndBelowView];
        
        
        
        UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 65 *SCREEN_H_SP)];
        middleView.tag = 222;
        middleView.backgroundColor = Color(218, 218, 218);
        [_middleAndBelowView addSubview:middleView];
        
        UIView * secondView = [[UIView alloc]initWithFrame:CGRectMake(0,5 *SCREEN_H_SP, SCREEN_WIDTH, 60 *SCREEN_H_SP)];
        secondView.backgroundColor = [UIColor whiteColor];
        [middleView addSubview:secondView];
        
        //价格
        jgLab = [[UILabel alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 15 *SCREEN_H_SP, 35 *SCREEN_W_SP, 14)];
        if (self.GoodsArchivesDataDic[@"data"][@"name1"]) {
            jgLab.text = self.GoodsArchivesDataDic[@"data"][@"name1"];
        }
        jgLab.font = [UIFont systemFontOfSize:14];
        jgLab.textColor = colorTitle;
        [secondView addSubview:jgLab];
        
        jgNum = [[UILabel alloc]initWithFrame:CGRectMake(48, 15 *SCREEN_H_SP, 100 *SCREEN_W_SP, 14)];
        if (self.GoodsArchivesDataDic[@"data"][@"value1"]) {
            jgNum.text = [NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value1"]];
        }
        jgNum.font = [UIFont systemFontOfSize:14];
        
        jgNum.textColor = ColorThemeRed;
        [secondView addSubview:jgNum];
        
        
        //款号
        khLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 -  25, 15 *SCREEN_H_SP, SCREEN_WIDTH / 2 -10, 14)];
        khLab.textAlignment = NSTextAlignmentLeft;
        if (self.GoodsArchivesDataDic[@"data"][@"name2"]) {
            
            NSString * value2String = [NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value2"]];
            
            if (value2String.length == 0 || [value2String isEqualToString:@"(null)"] || [value2String isEqualToString:@"null"]) {
                value2String = @"";
            }
            
            khLab.text = [NSString stringWithFormat:@"%@  %@",self.GoodsArchivesDataDic[@"data"][@"name2"],value2String];
        }
        khLab.font = [UIFont systemFontOfSize:14];
        khLab.textColor = colorTitle;
        [secondView addSubview:khLab];
        
        //年份
        nfLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 40 *SCREEN_H_SP, (SCREEN_WIDTH - 10 * 2) / 3, 14)];
        nfLab.textAlignment = NSTextAlignmentLeft;
        if (self.GoodsArchivesDataDic[@"data"][@"name3"]) {
            NSString * value3String = [NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value3"]];
            
            if (value3String.length == 0 || [value3String isEqualToString:@"(null)"] || [value3String isEqualToString:@"null"]) {
                value3String = @"";
            }
            
            nfLab.text = [NSString stringWithFormat:@"%@  %@",self.GoodsArchivesDataDic[@"data"][@"name3"],value3String];
        }
        nfLab.textColor = colorTitle;
        nfLab.font = [UIFont systemFontOfSize:14];
        [secondView addSubview:nfLab];
        
        
        //季节
        jjLab = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth - 10 *2) / 3 + 10, 40 * SCREEN_H_SP, (DeviceWidth - 10 * 2) / 3, 14)];
        jjLab.textAlignment = NSTextAlignmentCenter;
        if (self.GoodsArchivesDataDic[@"data"][@"name4"]) {
            NSString * value4String = [NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value4"]];
            
            if (value4String.length == 0 || [value4String isEqualToString:@"(null)"] || [value4String isEqualToString:@"null"]) {
                value4String = @"";
            }
            
            
            jjLab.text = [NSString stringWithFormat:@"%@  %@",self.GoodsArchivesDataDic[@"data"][@"name4"],value4String];
        }
        jjLab.textColor = colorTitle;
        jjLab.font = [UIFont systemFontOfSize:14];
        [secondView addSubview:jjLab];
        
        
        //波段
        bdLab = [[UILabel alloc]initWithFrame:CGRectMake((DeviceWidth - 10 *2) / 3 * 2 + 10, 40 *SCREEN_H_SP, (DeviceWidth - 10 * 2 *SCREEN_W_SP) / 3, 14)];
        bdLab.textAlignment = NSTextAlignmentCenter;
        if (self.GoodsArchivesDataDic[@"data"][@"name5"]) {
            
            NSString * value5String = [NSString stringWithFormat:@"%@",self.GoodsArchivesDataDic[@"data"][@"value5"]];
            if (value5String.length == 0 || [value5String isEqualToString:@"(null)"] || [value5String isEqualToString:@"null"]) {
                value5String = @"";
            }
            
            bdLab.text = [NSString stringWithFormat:@"%@  %@",self.GoodsArchivesDataDic[@"data"][@"name5"],value5String];
        }
        bdLab.textColor = colorTitle;
        //    bdLab.backgroundColor = [UIColor orangeColor];
        bdLab.font = [UIFont systemFontOfSize:14];
        [secondView addSubview:bdLab];
        
        //下部视图上的 2 + 3 按钮
        [self createHeadControlsInBottomView];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 创建周销曲线视图
-(void)creatCycleCurveMiddleViewUI{
    
    @try {
        
        //周销曲线图
        [self createWeekSaleCurves];
        
        //创建底部 3 个按钮
        [self createBottomButtons];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 折线图
-(void)createWeekSaleCurves{
    
    @try {
        
//        _chartView = [[LineChartView alloc]init];
//
        UIView * _chartView = [UIView new];
        
        if (SCREEN_HEIGHT == 812) {
            _chartView.frame = CGRectMake(10 * SCREEN_W_SP, upBtn.frame.origin.y + 40 *SCREEN_H_SP, SCREEN_WIDTH - 18 * SCREEN_W_SP, 140 * SCREEN_H_SP + 100);
        }
        else{
            _chartView.frame = CGRectMake(10 * SCREEN_W_SP, upBtn.frame.origin.y + 40 *SCREEN_H_SP, SCREEN_WIDTH - 18 * SCREEN_W_SP, 140 * SCREEN_H_SP);
        }
        _chartView.backgroundColor = [UIColor redColor];
        
         [_middleAndBelowView addSubview:_chartView];
//        if (self.view.frame.size.width == 320) {
//            _chartView.frame = CGRectMake(10 * SCREEN_W_SP, upBtn.frame.origin.y + 40 *SCREEN_H_SP, SCREEN_WIDTH - 18 * SCREEN_W_SP, 120);
//        }
//        else{
//            _chartView.frame = CGRectMake(10 * SCREEN_W_SP, upBtn.frame.origin.y + 40 *SCREEN_H_SP, SCREEN_WIDTH - 18 * SCREEN_W_SP, 140 * SCREEN_H_SP);
//        }
//
//        _chartView.backgroundColor = [UIColor whiteColor];
//
//      [_middleAndBelowView addSubview:_chartView];
//
//        _chartView.legend.enabled = NO;
//
//        _chartView.delegate = self;
//
//        _chartView.descriptionText = @"";
//        _chartView.noDataTextDescription = @"You need to provide data for the chart.";
//
//        _chartView.dragEnabled = NO;
//        [_chartView setScaleEnabled:NO];
//        _chartView.drawGridBackgroundEnabled = NO;
//        _chartView.pinchZoomEnabled = NO;
//
//        _chartView.legend.form = ChartLegendFormLine;
//        _chartView.legend.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
//        _chartView.legend.textColor = UIColor.whiteColor;
//        _chartView.legend.position = ChartLegendPositionBelowChartLeft;
//
//
//        ChartXAxis *xAxis = _chartView.xAxis;
//        xAxis.labelFont = [UIFont systemFontOfSize:11];
//        xAxis.labelPosition = XAxisLabelPositionBottom;     // x轴下方显示数字
//        xAxis.labelTextColor = [UIColor colorWithHex:0x8d8d8d];    //横轴数字颜色
//        //    xAxis.labelCount = 6; //横轴数字默认至少三个(设置比三小无效)
//        //    [xAxis setLabelCount:2 force:YES];
//        xAxis.drawGridLinesEnabled = NO;
//        xAxis.drawAxisLineEnabled = NO;
//        xAxis.valueFormatter = self;
//
//
//        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//        leftAxisFormatter.minimumFractionDigits = 0.0;
//        leftAxisFormatter.maximumFractionDigits = 1.0;
//        leftAxisFormatter.minimumIntegerDigits = 1;
//        ChartYAxis *leftAxis = _chartView.leftAxis;
//        //左边数字颜色
//        leftAxis.labelTextColor = Color(145, 145, 145);
//        // [leftAxis setLabelCount:5 force:YES];
//        leftAxis.forceLabelsEnabled = NO;
//        [leftAxis set_customAxisMax:YES];
//        //    leftAxis.axisMaximum = 7000.0;
//        //    leftAxis.axisMinimum = 0.0;
//        leftAxis.drawGridLinesEnabled = YES;
//        leftAxis.drawZeroLineEnabled = NO;
//        leftAxis.drawAxisLineEnabled = NO;//去掉左轴竖线
//        leftAxis.granularityEnabled = YES;
//        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//        leftAxis.spaceTop = 0.15;
//        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
//        //  leftAxis.valueFormatter = self;
//
//        ChartYAxis *rightAxis = _chartView.rightAxis;
//        rightAxis.labelTextColor = UIColor.redColor;
//        //    rightAxis.axisMaximum = 900.0;
//        //    rightAxis.axisMinimum = -200.0;
//        rightAxis.drawGridLinesEnabled = NO;
//        rightAxis.granularityEnabled = NO;
//
//        //    _chartView.leftAxis.enabled = NO;
//        _chartView.rightAxis.enabled = NO; //去除右边线
//
        //加载折线图数据
        [self loadChartData];
        
        //默认展示折线图
        [self showFirstView];
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 折线图数据
-(void)showFirstView{
    
    @try {
     
         [self showChartWith:YES];
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 加载折线图数据
-(void)loadChartData{

    @try {
       
        _chartArray = [NSMutableArray new];
        
        NSMutableArray *tempArr;
        
        //按钮切换改变折线数据
        NSMutableArray *yVals1;    //第一条折线
        NSMutableArray *yVals2;    //第二条折线
        NSMutableArray *yVals3;    //第三条折线
        NSMutableArray *yVals4;    //第四条折线
        
        NSArray *badyArray = self.CycleCurveDataDic[@"data"][@"trend"][@"body"];
        
        //底部三个按钮随着折线图上方的三个按钮切换而变化
        for (int j = 0; j < 3; j ++) {
            tempArr = [NSMutableArray new];
            
            //进入界面，默认取第一组数据：金额
            countArray = [NSMutableArray new];
            countArray = badyArray[j][@"value"];
            
            if (countArray) {
                yVals1 = [[NSMutableArray alloc] init];
                yVals2 = [[NSMutableArray alloc] init];
                yVals3 = [[NSMutableArray alloc] init];
                yVals4 = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < countArray.count ; i ++) {
                    
                    
//                    [yVals1 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"chartValue"] doubleValue]]];
//
//                    [yVals2 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][0][@"value"]  doubleValue]]];
//
//                    [yVals3 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][1][@"value"]  doubleValue]]];
//                    //
//                    [yVals4 addObject:[[ChartDataEntry alloc] initWithX:i y:[countArray[i][@"compareList"][2][@"value"]  doubleValue]]];
                    
                }
                
//                set1 = [[LineChartDataSet alloc] initWithValues:yVals1];
//                set1.axisDependency = AxisDependencyLeft;
//                //折线颜色
//                [set1 setColor:ColorThemeRed];
//                [set1 setCircleColor:ColorThemeRed];
//                set1.lineWidth = 1.0;
//                set1.circleRadius = 3.0;
//                set1.fillAlpha = 65/255.0;
//                set1.fillColor = [UIColor blueColor];
//                set1.highlightColor = [UIColor greenColor];
//                set1.drawHorizontalHighlightIndicatorEnabled=NO;  //去掉线
//                set1.drawCircleHoleEnabled = NO;
//                set1.drawVerticalHighlightIndicatorEnabled = NO;
//                //                [_dataSets addObject:set1];
//                [tempArr addObject:set1];
//
//
//                set2 = [[LineChartDataSet alloc] initWithValues:yVals2];
//                set2.axisDependency = AxisDependencyLeft;
//                set2.lineWidth = 1.0;
//                set2.circleRadius = 3.0;
//                set2.fillAlpha = 65/255.0;
//                set2.fillColor = UIColor.redColor;
//                //折线颜色
//                [set2 setColor:Color(242, 156, 159)];
//                [set2 setCircleColor:Color(242, 156, 159)];
//                set2.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//                set2.drawCircleHoleEnabled = NO;
//                set2.drawVerticalHighlightIndicatorEnabled = NO;
//                set2.drawHorizontalHighlightIndicatorEnabled = NO;  //去掉线
//                //                [_dataSets addObject:set2];
//                [tempArr addObject:set2];
//
//
//                set3 = [[LineChartDataSet alloc] initWithValues:yVals3];
//                set3.axisDependency = AxisDependencyLeft;
//                set3.lineWidth = 1.0;
//                set3.circleRadius = 3.0;
//                set3.fillAlpha = 65/255.0;
//                set3.fillColor = [UIColor redColor];
//                //折线颜色
//                [set3 setColor:Color(243, 143, 87)];
//                [set3 setCircleColor:Color(243, 143, 87)];
//                set3.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//                set3.drawCircleHoleEnabled = NO;
//                set3.drawVerticalHighlightIndicatorEnabled = NO;
//                set3.drawHorizontalHighlightIndicatorEnabled=NO;
//                //                [_dataSets addObject:set3];
//                [tempArr addObject:set3];
//
//
//                set4 = [[LineChartDataSet alloc] initWithValues:yVals4];
//                set4.axisDependency = AxisDependencyLeft;
//                set4.lineWidth = 1.0;
//                set4.circleRadius = 3.0;
//                set4.fillAlpha = 65/255.0;
//                set4.fillColor = [UIColor purpleColor];
//                //折线颜色
//                [set4 setColor:Color(183, 183, 183)];
//                [set4 setCircleColor:Color(183, 183, 183)];
//                set4.highlightColor = [UIColor colorWithRed:244/255.f green:117/255.f blue:117/255.f alpha:1.f];
//                set4.drawCircleHoleEnabled = NO;
//                set4.drawVerticalHighlightIndicatorEnabled = NO;
//                set4.drawHorizontalHighlightIndicatorEnabled=NO;
//                //                [_dataSets addObject:set4];
//                [tempArr addObject:set4];
//
                
                [_chartArray addObject:tempArr];
            }
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 金额、数量、折扣
-(void)upBtn:(UIButton *)button{
    
    @try {
        
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

        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 品牌均值、区域均值、品类均值
-(void)downBtn:(UIButton *)button{
    @try {
     
        button.selected = !button.selected;
        
        [self showChartWith:NO];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 切换周销曲线 上方3个 ＋ 下方3个按钮 时调用的方法
-(void)showChartWith:(BOOL)firstLoadChart{
    
    @try {
     
        if (_chartArray.count == 0) {
            return;
        }
        
        NSMutableArray *tempArray = [NSMutableArray new];
        _dataSets = [NSMutableArray new];
        
        //判断上面按钮选中项
        UIButton *upButton;
        UIButton *downButton;
        
        if (!firstLoadChart) {
            
            for (int i = 0; i < 3; i ++) {
                
                upButton = (UIButton *)[self.view viewWithTag:5000 + i];
                
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
            [_dataSets addObject:_chartArray[0][1]];
            
        }
        
//        _data = [[LineChartData alloc] initWithDataSets:_dataSets];
//        //每条折线左侧的数字
//        [_data setValueTextColor:UIColor.clearColor];
//        [_data setValueFont:[UIFont systemFontOfSize:9.f]];
//
//        [_chartView.leftAxis resetCustomAxisMax];
//
//        _chartView.leftAxis.forceLabelsEnabled = NO;
//        CGFloat numberY;
//
//        NSString * numberYS= [NSString stringWithFormat:@"%f",[_data yMax]];
//        numberY = [numberYS floatValue];
//
//        if (numberY < 1) {
//            if (numberY >= 0.1 && numberY < 0.2)
//            {
//                numberY = numberY +0.03;
//            }
//
//            else  if (numberY >= 0.2 && numberY < 0.3)
//            {
//                numberY = numberY +0.04;
//            }
//
//            else  if (numberY >= 0.3 && numberY < 0.4)
//            {
//                numberY = numberY +0.05;
//            }
//
//            else  if (numberY >= 0.4 && numberY < 0.5)
//            {
//                numberY = numberY +0.06;
//            }
//            else  if (numberY >= 0.5 && numberY < 1)
//            {
//                numberY = numberY +0.07;
//            }
//
//
//        }
//
//        if (numberY >= 1 && numberY < 10) {
//
//            if (numberY >= 1 && numberY < 2)
//            {
//                numberY = numberY +0.1;
//            }
//
//            else  if (numberY >= 2 && numberY < 3)
//            {
//                numberY = numberY +0.3;
//            }
//
//            else  if (numberY >= 3 && numberY < 7)
//            {
//                numberY = numberY +0.4;
//            }
//
//            else  if (numberY >= 7 && numberY < 10)
//            {
//                numberY = numberY +0.8;
//            }
//
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
//                numberY = numberY + 1;
//            }
//            else if (numberY >= 20 && numberY < 30) {
//                numberY = numberY + 2;
//            }
//            else if (numberY >= 80 && numberY < 100){
//                numberY = numberY + 5;
//            }
//            else if (numberY >= 70 && numberY < 80){
//                numberY = numberY + 4;
//            }
//            else{
//                numberY = numberY + 3;
//            }
//
//
//
//        }
//        else if (numberY >= 100 && numberY < 1000){
//
//            if (numberY >= 100 && numberY <= 200) {
//                numberY = numberY + 8;
//            }
//            else{
//
//                if (numberY > 200 && numberY <= 300) {
//                    numberY = numberY + 12;
//                }
//                else if (numberY > 300 && numberY <= 400) {
//                    numberY = numberY + 20;
//                }
//                else if (numberY > 400 && numberY <= 500){
//                    numberY = numberY + 25;
//                }
//                else if (numberY > 500 && numberY <= 600){
//                    numberY = numberY + 30;
//                }
//                else if (numberY > 600 && numberY <= 700){
//                    numberY = numberY + 35;
//                }
//                else{
//                    numberY = numberY + 45;
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
//            numberY = [_data yMax];
//        }
//
//
//        if ( numberY <= 10 &&  numberY > 0) {
//            [_chartView.leftAxis  setLabelCount:5 force:YES];
//        }
//
//        if ([_data yMax] == 0)
//        {
//
//            [_chartView.leftAxis setAxisMaxValue:[self reCalculateMaxYValue:[_data yMax]]];
//        }
//        else
//        {
//            [_chartView.leftAxis setAxisMaxValue:numberY];
//        }
//
//        _chartView.data = _data;
//
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 默认选中线的位置
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 按钮 周销曲线+店铺排行+金额+数量+进销
-(void)createHeadControlsInBottomView{
    
    @try {
     
        NSArray *arr = @[@"店铺排行",@"周销曲线"];
        
        UIView *middleView = (UIView *)[self.view viewWithTag:222];
        btnView = [[BigBtnView alloc]initWithFrame:CGRectMake(0, middleView.frame.origin.y + middleView.frame.size.height, SCREEN_WIDTH, 55 * SCREEN_H_SP)];
        btnView.delegate =self;
        [_middleAndBelowView addSubview:btnView];
        
        [btnView showBigBtnView:arr];
        
        for (UIButton *btn in btnView.arr) {
            
            [btn setY:5 * SCREEN_H_SP];
        }
        
        NSArray * arr1 = @[@"金额",@"数量",@"折扣"];
        //   NSArray *arr1 = @[self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"theme"], self.CycleCurveDataDic[@"data"][@"trend"][@"body"][1][@"theme"], self.CycleCurveDataDic[@"data"][@"trend"][@"body"][2][@"theme"]];
        
        _array1 = [NSMutableArray new];
        for (int i =0; i < 3; i ++) {
            
            upBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * i +15 * SCREEN_W_SP, btnView.frame.origin.y + btnView.height + 5 * SCREEN_H_SP , (SCREEN_WIDTH - 30 *SCREEN_W_SP)/3 - 25 * SCREEN_W_SP , 25 *SCREEN_H_SP)];
            
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
            
            upBtn.tag = 5000 + i;
            
            if (i == 0) {
                
                upBtn.selected = YES;
                
                upBtn.layer.borderColor=ColorThemeRed.CGColor;
                
                //            [self upBtn:upBtn];
            }
            
            [_array1 addObject:upBtn];
            
            [_middleAndBelowView addSubview:upBtn];
            
        }
        
        for (UIButton * threebutton in _array1) {
            threebutton.hidden = YES;
        }
        
        
        //加一条分割线
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, upBtn.y + upBtn.height + 5, SCREEN_WIDTH - 10 * 2, 1)];
        lineView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [_middleAndBelowView addSubview:lineView];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 底部三个按钮
-(void)createBottomButtons{

    @try {
        
        //    NSArray * arr2 = @[@"品牌均值",@"区域均值",@"品类均值"];
        
        NSArray *arr2 = @[self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][0][@"name"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][1][@"name"],self.CycleCurveDataDic[@"data"][@"trend"][@"body"][0][@"compareTitle"][2][@"name"]];
        
        _array2 = [NSMutableArray new];
        
        //    NSArray *arr3 = @[@"img_图表指示点_粉",@"img_图表指示点_橙",@"img_图表指示点_灰"];
        NSArray *arr3 = @[Color(242, 156, 159),Color(248, 143, 87),Color(168, 168, 168)];
        
        for (int j =0; j < 3; j ++) {
            
//            downBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 * j +10 * SCREEN_W_SP, _chartView.y + _chartView.height + 10 *SCREEN_H_SP , (SCREEN_WIDTH - 20 *SCREEN_W_SP)/3 - 12 * SCREEN_W_SP , 35 *SCREEN_H_SP)];
            
            //若按钮内文字为空或不存在，按钮不可点击
//            if ([arr2[j] isEqualToString:@""] || !arr2[j]) {
//                downBtn.enabled = NO;
//            }
//
//            //默认选中第一个按钮
//            if (j == 0) {
//                downBtn.selected = YES;
//            }
//
//
//            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(7 *SCREEN_W_SP, downBtn.height / 2 - 5 *SCREEN_H_SP, 10 *SCREEN_W_SP, 10 *SCREEN_H_SP)];
//            label.layer.cornerRadius = label.width / 2;
//            label.clipsToBounds = YES;
//            label.backgroundColor = arr3[j];
//            [downBtn addSubview:label];
//
            
            //        UIImageView *downBtnImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5 *SCREEN_W_SP, downBtn.height / 2 - 4.5, 9, 9)];
            //        downBtnImageView.image = [UIImage imageNamed: arr3[j]];
            //        [downBtn addSubview:downBtnImageView];
            //        [downBtn setImage:[UIImage imageNamed:arr3[j]] forState:UIControlStateNormal];
            
            
            downBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
            
            [downBtn setTitle:arr2[j] forState:UIControlStateNormal];
            
            [downBtn setTitleColor:[UIColor colorWithHex:0x8d8d8d] forState:UIControlStateNormal];
            [downBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [downBtn setBackgroundColor:[UIColor colorWithHex:0xf0f0f0] forState:UIControlStateNormal];
            
            [downBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
            
            downBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            
            downBtn.layer.cornerRadius = 3;
            
            downBtn.clipsToBounds = YES;
            
            [downBtn addTarget:self action:@selector(downBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            downBtn.tag = 20 + j;
            
            
            [_array2 addObject:downBtn];
            
            [_middleAndBelowView addSubview:downBtn];
            
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 切换周销曲线和店铺排行
- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index{

    @try {
     
        _selectIndex = index;
        
#pragma mark  检查网络
        
        //店铺排行
        if (index == 1) {
            [_tableView removeFromSuperview];
            _tableView = nil;
            for (UIButton * threebutton in _array1) {
                threebutton.hidden = NO;
            }
//            _chartView.hidden = NO;
            for (UIButton * downThreeButton in _array2) {
                downThreeButton.hidden = NO;
            }
            
            [self refreshCycleCurveWithCache:YES];
            _storeRankIsCreated = NO;
            
            
        }else if (index == 0){
            
            for (UIButton * threebutton in _array1) {
                threebutton.hidden = YES;
            }
//            _chartView.hidden = YES;
            for (UIButton * downThreeButton in _array2) {
                downThreeButton.hidden = YES;
            }
            
            if (_storeRankIsCreated) {
                
                return;
            }
            
            [self refreshStoreRankingWithCache:YES];
            _storeRankIsCreated = YES;
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 创建店铺页
-(void)createDianPu{
    
    @try {
     
        //获取中间view的frame
        UIView *middliView = (UIView *)[self.view viewWithTag:222];
        if (_tableView) {
            [_tableView removeFromSuperview];
            _tableView = nil;
        }
       
        if (SCREEN_HEIGHT == 812) {
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, middliView.y + middliView.height + 55 *SCREEN_H_SP, SCREEN_WIDTH, SCREEN_HEIGHT - 470 * SCREEN_H_SP) style:UITableViewStylePlain];
        }
        else{
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, middliView.y + middliView.height + 55 *SCREEN_H_SP, SCREEN_WIDTH, SCREEN_HEIGHT - 420 * SCREEN_H_SP) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 1, 0, 10);
        _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _dataSourceArr = self.StoreRankingDataDic[@"data"][@"store"][@"body"][@"valueList"];
        [_tableView registerClass:[TableViewCellForDetailStoreRank class] forCellReuseIdentifier:@"TableViewCellForDetailStoreRankCell"];
        [_middleAndBelowView addSubview: _tableView];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    @try {
     
        return 34 * SCREEN_H_SP;
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

// custom view for header. will be adjusted to default or specified header height
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    @try {
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(10 * SCREEN_H_SP, 8 *SCREEN_H_SP, SCREEN_WIDTH - 10 * 2 * SCREEN_W_SP, 34 * SCREEN_H_SP)];
        headView.backgroundColor = [UIColor colorWithHex:0xf0f0f0];
        
        NSArray *subheadListArr = self.StoreRankingDataDic[@"data"][@"store"][@"body"][@"subheadList"];
        
        if (!subheadListArr) {
            
            return headView;
            
        }
        
        for (int i = 0; i < subheadListArr.count; i ++) {
            
            //根据接口数据个数创建label
            UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake((headView.width / subheadListArr.count * i) + 10 * SCREEN_H_SP, 0, headView.width / subheadListArr.count, headView.height)];
            [headView addSubview:headLabel];
            headLabel.textColor = Color(141, 141, 141);
            headLabel.font = [UIFont systemFontOfSize:14];
            headLabel.textAlignment = NSTextAlignmentCenter;
            headLabel.text = subheadListArr[i][@"name"];
            
            if (i == 0 || i == 1) {
                
                headLabel.textAlignment = NSTextAlignmentLeft;
            }
            
        }
        
        return headView;
   
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    @try {
        if (_dataSourceArr) {
            
            return _dataSourceArr.count;
        }
        
        return 0;
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44 * SCREEN_H_SP;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        TableViewCellForDetailStoreRank *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForDetailStoreRankCell" forIndexPath:indexPath];
        
        NSArray *subheadListArr = self.StoreRankingDataDic[@"data"][@"store"][@"body"][@"subheadList"];
        CGFloat lineRoomWidth = 0.0;
        if (subheadListArr.count != 0) {
            lineRoomWidth = (SCREEN_WIDTH - 10 * 2 *SCREEN_W_SP) / subheadListArr.count;
        }
        
        //第一列
        if (indexPath.row > 98) {
        
           cell.firstLab.frame = CGRectMake(8 *SCREEN_W_SP, cell.height / 2 - 10, 27, 20);
        }
        else{
           cell.firstLab.frame = CGRectMake(8 *SCREEN_W_SP, cell.height / 2 - 10, 20, 20);
        }
        
        cell.firstLab.layer.cornerRadius = cell.firstLab.height / 2;
        cell.firstLab.clipsToBounds = YES;
        cell.firstLab.font = [UIFont systemFontOfSize:14];
        cell.firstLab.textAlignment = NSTextAlignmentCenter;
        cell.firstLab.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        //    [NSString stringWithFormat:@"%@",_dataSourceArr[indexPath.row][@"value"][0][@"value"]];
        
        if (indexPath.row == 0) {
            cell.firstLab.backgroundColor = Color(177, 36, 44);
            cell.firstLab.textColor = [UIColor whiteColor];
        }else if (indexPath.row == 1) {
            cell.firstLab.backgroundColor = Color(255, 108, 42);
            cell.firstLab.textColor = [UIColor whiteColor];
        }else if (indexPath.row == 2) {
            cell.firstLab.backgroundColor = Color(255, 164, 36);
            cell.firstLab.textColor = [UIColor whiteColor];
        }else{
            cell.firstLab.textColor = Color(123, 123, 123);//第四行及以下
            cell.firstLab.backgroundColor = [UIColor clearColor];
        }
        //第二列
        if (1 < subheadListArr.count) {
            
            cell.secondLab.frame = CGRectMake(lineRoomWidth * 1 - 10 *SCREEN_W_SP, 0, lineRoomWidth * 1.5, cell.height);
            cell.secondLab.font = [UIFont systemFontOfSize:14];
            cell.secondLab.textColor = colorText;
            cell.secondLab.text = [NSString stringWithFormat:@"%@",_dataSourceArr[indexPath.row][@"value"][1][@"value"]];
        }
        //第三列
        if (2 < subheadListArr.count) {
            
            cell.thirdLab.frame = CGRectMake(lineRoomWidth * 2 + 10 *SCREEN_W_SP, 0, lineRoomWidth, cell.height);
            cell.thirdLab.font = [UIFont systemFontOfSize:14];
            cell.thirdLab.textColor = colorText;
            cell.thirdLab.textAlignment = NSTextAlignmentCenter;
            cell.thirdLab.text = _dataSourceArr[indexPath.row][@"value"][2][@"value"];
        }
        //第四列
        if (3 < subheadListArr.count) {
            
            cell.fourthLab.frame = CGRectMake(lineRoomWidth * 3 + 10 *SCREEN_W_SP, 0, lineRoomWidth, cell.height);
            cell.fourthLab.font = [UIFont systemFontOfSize:14];
            cell.fourthLab.textAlignment = NSTextAlignmentCenter;
            cell.fourthLab.textColor = colorText;
            cell.fourthLab.text = _dataSourceArr[indexPath.row][@"value"][3][@"value"];
        }
        //第五列
        if (4 < subheadListArr.count) {
            
            cell.fifthLab.frame = CGRectMake(lineRoomWidth * 4 + 10 *SCREEN_W_SP, 0, lineRoomWidth, cell.height);
            cell.fifthLab.font = [UIFont systemFontOfSize:14];
            cell.fifthLab.textAlignment = NSTextAlignmentCenter;
            cell.fifthLab.textColor = colorText;
            cell.fifthLab.text = _dataSourceArr[indexPath.row][@"value"][4][@"value"];
        }
        //第六列
        if (5 < subheadListArr.count) {
            
            cell.sixthLab.frame = CGRectMake(lineRoomWidth * 5 + 15 * SCREEN_W_SP, 0, lineRoomWidth, cell.height);
            cell.sixthLab.font = [UIFont systemFontOfSize:14];
            cell.sixthLab.textAlignment = NSTextAlignmentCenter;
            cell.sixthLab.textColor = colorText;
            cell.sixthLab.text = _dataSourceArr[indexPath.row][@"value"][5][@"value"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 折线图回调
//- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
//{
//    @try {
//
//        DLog(@"chartValueSelected");
//
//        [_chartView centerViewToAnimatedWithXValue:entry.x yValue:entry.y axis:[_chartView.data getDataSetByIndex:highlight.dataSetIndex].axisDependency duration:1.0];
//
//    } @catch (NSException *exception) {
//
//          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//
//}
//
//- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
//{
//    DLog(@"chartValueNothingSelected");
//}
//
//
//#pragma mark - IChartAxisValueFormatter
//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//    @try {
//
//        NSInteger index = value;
//        NSString *returnStr = [NSString stringWithString:countArray[index][@"xAxis"]];
//
//        return returnStr;
//    } @catch (NSException *exception) {
//
//          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    } @finally {
//
//    }
//
//}


#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    
    @try {
        
        calendarBtn.selected = !calendarBtn.selected;
        if (calendarBtn.selected) {
            
            [self positionCalendarLocation];
            
            [sv showView];
        }if (!calendarBtn.selected) {
            [sv backView];
        }

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
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
                           
#pragma mark 刷新本页数据
                          
                           
                           if (_selectIndex == 0) {
                               
                               _firstinside = 1;
                               
                               [self refreshGoodsArchivesWithCache:YES];
                               
                             //  [self refreshStoreRankingWithCache:YES];
                           }
                           else{
                               
                              [self refreshGoodsArchivesWithCache:YES];
                               
                               [self refreshCycleCurveWithCache:YES];
                           }
                           
                           calendarBtn.selected = NO;
                           
                           
                           [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                           
                       }];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark - 日历按钮点击事件
-(void) calendarBtn:(NSNotification *)sender{
    
    @try {
        id vc = [UIApplication sharedApplication ].keyWindow.rootViewController;
        
        
        if( [vc isMemberOfClass:[LeftSlideViewController class]]){
            LeftSlideViewController* lsvc= (LeftSlideViewController*)vc;
            
            id curvc=lsvc.mainVC;
            if ([curvc isMemberOfClass:[UINavigationController class]]) {
                UINavigationController* navs=(UINavigationController*)lsvc.mainVC;
                curvc=navs.visibleViewController;
            }
            
            if(curvc ==self){
                
#pragma mark 刷新本页数据
                
            //    [self refreshGoodsArchivesWithCache:YES];
                if (_selectIndex == 0) {
                    [self refreshStoreRankingWithCache:YES];
                }
                else{
                    [self refreshCycleCurveWithCache:YES];
                }
                
            }
        }
        
        else  if (vc == self) {
#pragma mark 刷新本页数据
            
       //     [self refreshGoodsArchivesWithCache:YES];
            if (_selectIndex == 0) {
                [self refreshStoreRankingWithCache:YES];
            }
            else{
                [self refreshCycleCurveWithCache:YES];
            }
            
        }
        
        
        calendarBtn.selected = NO;
   
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 分享按钮点击事件
- (void)shareBtnClicked:(UIButton *)sender {
    
    @try {
        
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
        
        //    smvc.vi = [LOSHelper getSnapshotImage];
        
        [self presentViewController:smvc animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)backBtn:(UIButton *)sender{
    
    @try {
     
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoodsRank];
        
        [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
        
        //    ShangPinView *shangPinView = [ShangPinView new];
        //    [shangPinView goodsRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
        
        //    [NSNotificationCenter defaultCenter]postNotificationName:@"backDateToShangPinView" object:<#(nullable id)#>];
        
        
        __block ShangPinView *shangPinView = [ShangPinView new];
        __weak ShangPinView *shangPin = shangPinView;
        
        shangPin.RefreshSPBlock= ^(NSString *dateStr){
            
            if (![dateStr isEqualToString:[AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"在商品详情中切换日期后返回商品排行" forKey:@"crashTheClassName"];

                [[NSUserDefaults standardUserDefaults] setObject:@"a" forKey:@"goodsRefresh"];
                [self.delegate goodsrefreshSPView];
            }
        };
        [shangPin refreshSPViewAfterPop];
        
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
       
        [animationView startAnimation];
    } @catch (NSException *exception) {
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
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
                
#pragma mark 刷新本页数据
            //    [self refreshGoodsArchivesWithCache:YES];
                if (_selectIndex == 0) {
                    [self refreshStoreRankingWithCache:YES];
                }
                else{
                    [self refreshCycleCurveWithCache:YES];
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
        
          [[NSUserDefaults standardUserDefaults] setObject:@"商品详情  FourDetailViewController" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


@end
