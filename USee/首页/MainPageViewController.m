//
//  MainPageViewController.m
//  LOSBi
//
//  Created by gufeifei on 16/8/11.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



/*
 
    主页（登陆成功后跳转的页面）
 */



#import "MainPageViewController.h"
#import "LOSHelper.h"
#import "NSDate+Escort.h"
#import "TableViewCellForMainPage.h"
#import "AppDelegate.h"
#import "CalendarView.h"
#import "ShareMenuViewController.h"
#import "UIDatePickerView.h"
#import "ShiDuanView.h"
#import "MainPageDayDetailViewController-0004.h"
#import "ShowView.h"
#import "DetailViewController.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "LOSAFNetworking.h"
#import "ThreeDetailViewController.h"
#import "LOConst.h"
#import "StoreDetailProductDetailViewController.h"
#import "AnimationView.h"
#import "GuideDetailViewController.h"
#import "MBProgressHUD.h"

#import "UIImageView+WebCache.h"

#import "JPUSHService.h"

@interface MainPageViewController () <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate, MBProgressHUDDelegate,UIWebViewDelegate> {
    
    UILabel *_timeLabel;
    UILabel *_amountTitleLabel;
    UILabel *_amountValueLabel;
    UIButton * calendarBtn;
    UIScrollView * scrollView1;
    UITableView *brandTableView;
    
    UIWebView * mainPageLocalWebView;
    
    BOOL  _viewAppearBool;
    NSInteger calendarCreat;
    NSInteger firstCreate;
    NSString *shiJianDuan; //时间段
    NSString *str1;
    NSString *str2;
    NSDate *startDate; // 获得点击的日期
    NSDate *endDate;
    NSDictionary *dataDic;
    
    NSString *returnData;
    
    NSString * mainPageCurrentURL;
    
    MBProgressHUD *HUD;
    ShowView *sv;
    ShiDuanView *shiDuanView;
    AnimationView * animationView;
    
}

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            if (resCode == 0) {
                [JPUSHService setAlias:[AppDatas sharedDatas].userCode callbackSelector:nil object:nil];
            }
        }];
        
       
        
#pragma mark 清理图片缓存
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        
        
        [self setUserInfoData];
        
        [self createWebUI];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
        
        firstCreate = 1;
        calendarCreat = 1;
      
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *resourcePath = [bundle resourcePath];
        
         UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, DeviceWidth, DeviceHeight)];
        
        if (SystemVersion >= 8.0) {
            
           bg.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"img_bg"]];
        }
        else{
            
           bg.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"img_bg@2x.png"]];
        }
       
        
        [self.view addSubview:bg];
        
        self.title = @"有数";
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xba2932];
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (SystemVersion >= 8.0) {
            
            [shareBtn setImage:[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"icon_share"]] forState:UIControlStateNormal];
        }
        else{
            
            [shareBtn setImage:[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"icon_share@2x.png"]] forState:UIControlStateNormal];
        }
       
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if (SystemVersion >= 8.0) {
            
             [calendarBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"bg_calendar"]] forState:UIControlStateNormal];
        }
        else{
            
            [calendarBtn setBackgroundImage:[UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"bg_calendar@2x.png"]] forState:UIControlStateNormal];
        }

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
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
        
        [self createView];
#pragma mark - 导航栏右视图
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButton];
        
        
#pragma mark - 周月年按钮通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectWeekMonthYear) name:@"weekMonthYearBtn" object:nil];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    @try {
        
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
    
}

#pragma mark -  UI

-(void)createView{
    
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
        
        [animationView removeFromSuperview];
        animationView = nil;
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 100)];
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        [animationView Animation];
        [animationView Animation1];
        [scrollView1 addSubview:animationView];
        
        //    if (calendarCreat == 1) {
        //
        //        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        //        [sv CreateView];
        //        [scrollView1 addSubview:sv];
        //        calendarCreat = 2;
        //
        //    }
        
        UIView *headerViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 220 * SCREEN_H_SP)];
        headerViewBg.backgroundColor = [UIColor clearColor];
        
        [scrollView1 addSubview:headerViewBg];
#pragma mark - 品牌墙：点击tableView以上区域
        [headerViewBg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterDetail)]];
        
        [_timeLabel removeFromSuperview];
        _timeLabel = nil;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, DeviceWidth, 14)];
        _timeLabel.textColor = [UIColor colorWithHex:0xffffff];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_timeLabel];
        
        [_amountTitleLabel removeFromSuperview];
        _amountTitleLabel = nil;
        
        _amountTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _timeLabel.y + _timeLabel.height + 20, DeviceWidth, 17)];
        _amountTitleLabel.textColor = [UIColor colorWithHex:0xffffff];
        _amountTitleLabel.font = [UIFont systemFontOfSize:17];
        _amountTitleLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_amountTitleLabel];
        
        
        [_amountValueLabel removeFromSuperview];
        _amountValueLabel = nil;
        
        _amountValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _amountTitleLabel.y + _amountTitleLabel.height + 20, DeviceWidth, 39)];
        _amountValueLabel.textColor = [UIColor colorWithHex:ColorMain];
        _amountValueLabel.font = [UIFont systemFontOfSize:42];
        _amountValueLabel.textAlignment = NSTextAlignmentCenter;
        [headerViewBg addSubview:_amountValueLabel];
        
        
        [brandTableView removeFromSuperview];
        brandTableView = nil;
       
        if (SCREEN_HEIGHT == 812) {
            brandTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225 * SCREEN_H_SP, DeviceWidth, SCREEN_HEIGHT - headerViewBg.frame.size.height - 134) style:UITableViewStylePlain];
        }
        else{
             brandTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 225 * SCREEN_H_SP, DeviceWidth, SCREEN_HEIGHT - NavigationBarHeight - headerViewBg.frame.size.height) style:UITableViewStylePlain];
        }
        
        brandTableView.backgroundColor = [UIColor clearColor];
        brandTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        brandTableView.delegate = self;
        brandTableView.dataSource = self;
        brandTableView.showsVerticalScrollIndicator = NO;
        [scrollView1 addSubview:brandTableView];
        
        [brandTableView registerClass:[TableViewCellForMainPage class] forCellReuseIdentifier:@"TableViewCellForMainPage"];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
    
}


#pragma mark - 请求接口前的过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache {
    
    @try {
     
        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 接口请求
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache {
    
    @try {
        
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
            NSDictionary * requestDataDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                 [AppDatas sharedDatas].userCode, @"user_code",
                 fromDateStr, @"start_date",
                 toDateStr, @"end_date",
                 nil];

                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.CorpBoardBrand"
                             dataParameters:requestDataDic                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        DLogObject(responseDic);
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                dataDic = responseDic;
                                                
                                                
                                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"brandStringLength"];
                                                
                                                NSMutableArray  * brandArray =  [[NSMutableArray alloc]initWithArray:       dataDic[@"data"][@"brand"]];
                                                
                                                NSInteger  twoBrandInt = 0;
                                                
                                                NSInteger brandInt = [dataDic[@"data"][@"brand"][0][@"org_name"] length];
                                                
                                                for (NSInteger i = 0; i < brandArray.count; i ++) {
                                                    
                                                    NSString * brandString = brandArray[i][@"org_name"];
                                                    if (brandString.length > brandInt) {
                                                        brandInt = brandString.length;
                                                        twoBrandInt = i;
                                                    }
                                                    
                                                }
                                                
                                                CGFloat brandFloat = [CommonTools huoQuZiFuString:brandArray[twoBrandInt][@"org_name"] font:26];
                                                
                                                if (brandFloat > 220 * SCREEN_W_SP) {
                                                    [[NSUserDefaults standardUserDefaults] setObject:@"aa" forKey:@"brandStringLength"];
                                                }
                                                
                                                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                                
                                                [animationView stopAnimating1];
                                                
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                                                [self createView];
                                                [self refreshDatasAndViews];
                                                
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
                                            
                                            [self createView];
                                            
                                            //                            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                            //                            HUD.delegate = self;
                                            //                            HUD.mode = MBProgressHUDModeText;
                                            //                            HUD.labelText = error.userInfo[@"NSLocalizedDescription"];
                                            //                            HUD.margin = 10.f;
                                            //                            HUD.removeFromSuperViewOnHide = YES;
                                            //                            [HUD hide:YES afterDelay:2];
                                            
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
            
            [animationView stopAnimating1];
            
            scrollView1.contentOffset = CGPointMake(0, 0);
            //   [self createView];
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
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

- (void)transit {
    
    @try {
     
        __block __weak id gpsObserver;
        
        gpsObserver = [[NSNotificationCenter defaultCenter]
                       addObserverForName:@"calendarBtn"
                       object:nil
                       queue:[NSOperationQueue mainQueue]
                       usingBlock:^(NSNotification *note){
                           
                           [self refreshDatasWithCache:YES];
                           
                           calendarBtn.selected = NO;
                           
                           //                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                           //                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
                           //                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
                           
                           
                           DLog(@"run once, and only once!");
                           
                           [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                           
                       }];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    @try {
     
        _viewAppearBool = NO;
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @try {
        
        _viewAppearBool = YES;
        
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
        
        NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"MM dd"];
        NSString * currentDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectFromDate];
        NSString * toDateString = [dateFormatter stringFromDate:[AppDatas sharedDatas].selectToDate];
        
        if ([currentDateString isEqualToString:toDateString]) {
            
            [calendarBtn setTitle:currentDateString forState:UIControlStateNormal];
            
        }else{
            
            [calendarBtn setTitle:@"时 段" forState:UIControlStateNormal];
            
        }
        
        
        
         [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
        
        [self refreshDatasWithCache:YES];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - UITableView datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    @try {
     
        return [dataDic[@"data"][@"brand"] count];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
      
        TableViewCellForMainPage *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForMainPage"];
        [cell setBackgroundHidden:indexPath.row % 2 == 0 ? NO : YES];
        [cell setAmountValue:dataDic[@"data"][@"brand"][indexPath.row][@"org_value"]];
        cell.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.25];
        
        // [self downloadImage:indexPath];
        
      //  NSString * headViewUrlString = dataDic[@"data"][@"brand"][indexPath.row][@"org_img"];
//        NSData *headData = [NSData dataWithContentsOfURL:headViewUrl];
//        UIImage *image = [UIImage imageWithData:headData];
//        if (headViewUrlString.length > 0) {
//            
//            [cell.logoImageView sd_setImageWithURL:[NSURL URLWithString:headViewUrlString]];
//            [cell setNameView:@""];
//            
//        } else {
        
            [cell setNameView:dataDic[@"data"][@"brand"][indexPath.row][@"org_name"]];
//        }
        
        return cell;

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70 *SCREEN_H_SP;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
     
        NSString * funcPermission = [[NSUserDefaults standardUserDefaults] objectForKey:@"funcPermission"];
        
        if (funcPermission != nil) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeContentOffsetX"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"goodsContentOffsetX"];
            [AppDatas sharedDatas].BrandDicArray = dataDic[@"data"][@"brand"];
            [AppDatas sharedDatas].currentBrandDic = [AppDatas sharedDatas].BrandDicArray[indexPath.row];
            
            
            _viewAppearBool = NO;
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
            
             [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationForSelectDate object:nil];
            
            NSMutableArray *nameArr = [NSMutableArray new];
            NSMutableArray *orgCodeArr = [NSMutableArray new];
            NSArray *brandArr = dataDic[@"data"][@"brand"];
            for (int i = 0; i < brandArr.count; i ++) {
                
                [nameArr addObject:brandArr[i][@"org_name"]];
                [orgCodeArr addObject:brandArr[i][@"org_code"]];
            }
            
            DetailViewController * detail = [DetailViewController new];
            detail.orgCodeArr = orgCodeArr;
            detail.titleNameArr = nameArr;
            detail.titleName = dataDic[@"data"][@"brand"][indexPath.row][@"org_name"];
            detail.org_code = dataDic[@"data"][@"brand"][indexPath.row][@"org_code"];
            detail.drillTitleName = dataDic[@"data"][@"brand"][indexPath.row][@"org_name"];
            detail.drillOrgCode = dataDic[@"data"][@"brand"][indexPath.row][@"org_code"];
            
            [tempAppDelegate.mainNavigationController pushViewController:detail animated:YES];
            
        } else {
            
            LOSAlert(@"你没有任何权限，请联系商帆工作人员");
            
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - inner functions

- (void)enterDetail {
    
    @try {
     
        [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewControllerMainPage004];
        
        //    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        //    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        //
        //    MainPageDayDetailViewController_0004 * detail = [MainPageDayDetailViewController_0004 new];
        //
        //    detail.timeTxt = [NSString stringWithFormat:@"%@", dataDic[@"data"][@"date"]];
        //    detail.amountTxt = dataDic[@"data"][@"totalTitle"];
        //
        //    CGFloat totalValue = [dataDic[@"data"][@"totalValue"] doubleValue];
        //    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        //    [numberFormatter setPositiveFormat:@"0.0"];
        //    detail.amountValueTxt = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalValue]];
        //        
        //    [self.navigationController pushViewController:detail animated:NO];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 刷新数据和页面
- (void)refreshDatasAndViews {
    
    @try {
       
        _timeLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"data"][@"date"]];
        _amountTitleLabel.text = dataDic[@"data"][@"totalTitle"];
        
//        CGFloat totalValue = [dataDic[@"data"][@"totalValue"] doubleValue];
//        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//        [numberFormatter setPositiveFormat:@"0.0"];
//        NSString * valueString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalValue]];
//        
//        NSArray *array = [valueString componentsSeparatedByString:@"."]; //从字符A中分隔成2个元素的数组
//        if ([array[1] isEqualToString:@"0"]) {
//            
//            _amountValueLabel.text  = array[0];
//        }
//        else{
//             _amountValueLabel.text  = valueString;
//        }
        
        _amountValueLabel.text  = [NSString stringWithFormat:@"%@",dataDic[@"data"][@"totalValue"]];
        
        [brandTableView reloadData];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)selectWeekMonthYear{
    
    @try {
        
         [calendarBtn setTitle:[NSString stringWithFormat:@"时 段"] forState:UIControlStateNormal];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
    
}

- (void)leftBarBtnClicked {
    
    @try {
     
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        
        
        GuideDetailViewController *guide = [GuideDetailViewController new];
        
        [tempAppDelegate.mainNavigationController pushViewController:guide animated:YES];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)shareBtnClicked:(UIButton *)sender {
    
    @try {
       
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
        
        //    smvc.vi = [LOSHelper getSnapshotImage];
        
        [self presentViewController:smvc animated:YES completion:^{
            
        }];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark -  获得点击的日期/时段

- (void)selectedDates:(NSNotification *)notification {
    
    @try {
    
        if (_viewAppearBool == YES) {
            
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
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
            [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
            
            [sv backView];
            
        }
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - showView消失时，重置navigationItem.selected
-(void) calendarBtn:(NSNotification *)sender{
    
    @try {
        
         calendarBtn.selected = NO;
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
    
}

#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    @try {
     
        calendarBtn.selected = !calendarBtn.selected;
        
        if (calendarBtn.selected) {
            
            [sv removeFromSuperview];
            sv = nil;
            
            sv = [[ShowView alloc]initWithFrame:self.view.bounds];
            
            [sv CreateView];
            
            [self.view addSubview:sv];
            
            calendarCreat = 2;
            
            [self transit];
            
            [sv showView];
            
            [scrollView1 setScrollEnabled:NO];
            [brandTableView setScrollEnabled:NO];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
            [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:LeftViewTypeMain];
            
        } if (!calendarBtn.selected) {
            
            [sv backView];
            
            [scrollView1 setScrollEnabled:YES];
            [brandTableView setScrollEnabled:YES];
            
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeMain];
            [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
            
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - scrollView回调
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
       
         [animationView startAnimation];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
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
                
                scrollView1.contentOffset = CGPointMake(0, 80);
                
                [animationView startAnimation1];
                
                [self refreshDatasWithCache:YES];
                
                
                
                
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                
                [UIView animateWithDuration:.3 animations:^{
                    
                    animationView.tag = 0;
                    
                }];
                
            });
            
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"首页  MainPageViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}




#pragma mark 创建UIWebView  使用户在本社区为登录状态
-(void)createWebUI{
    
    [mainPageLocalWebView removeFromSuperview];
    mainPageLocalWebView = nil;
   
    mainPageLocalWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -  0 - 50 * SCREEN_H_SP)];
    
    mainPageLocalWebView.delegate = self;
    mainPageLocalWebView.hidden = YES;
    mainPageLocalWebView.scrollView.delegate = self;
    mainPageLocalWebView.backgroundColor = [UIColor clearColor];
    [mainPageLocalWebView setScalesPageToFit:YES];
    NSURL *url = [[NSURL alloc]initWithString:formalSheQu_Html5];
    [mainPageLocalWebView loadRequest:[NSURLRequest requestWithURL:url]];
    mainPageLocalWebView.scrollView.showsVerticalScrollIndicator = NO;
        
    [self.view addSubview:mainPageLocalWebView];
    
}

#pragma mark JS方法

- (void)JSContextMethod{
    
    @try {
        JSContext *context = [mainPageLocalWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        context[@"NSReturnUserInfo"] = ^() {
            //返回用户个人信息
            
            return returnData;
        };
        
        context[@"NSReadFileJumpToWebViewForWeb"] = ^() {
            NSArray *args = [JSContext currentArguments];
            if (args.count > 0) {
                NSString *argsString = [NSString stringWithFormat:@"%@",args[0]];
                
                NSData *jsonData = [argsString dataUsingEncoding:NSUTF8StringEncoding];
                
                NSError *err;
                
                NSDictionary * getFileInfo = [NSJSONSerialization JSONObjectWithData:jsonData
                                              
                                                                             options:NSJSONReadingMutableContainers
                                              
                                                                               error:&err];
                
                NSString *url = getFileInfo[@"url"];
                if (!url) {
                    url = @"";
                }
                NSString *title = getFileInfo[@"title"];
                if (!title) {
                    title = @"";
                }
                
            }
            
        };
        
        context[@"NSRefreshWebView"] = ^() {
            [self reloadWebView];
        };
        
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
        
        
    }
}

//网页开始加载代理方法调用
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    @try {
        
        [self JSContextMethod];
        
    } @catch (NSException *exception) {
        
    }
}

//网页加载完成代理方法调用
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    @try {
        
        [self JSContextMethod];
        mainPageCurrentURL = webView.request.URL.absoluteString;
        //    [self setGoBackBtn];
        
    } @catch (NSException *exception) {
        
    }
}


-(void)reloadWebView{
    
    @try {
        
        if (mainPageCurrentURL.length > 0) {
            //获取并重新加载当前页面的URL
            [mainPageLocalWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:mainPageCurrentURL]]];
        }
        else{
            [mainPageLocalWebView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:formalSheQu_Html5]]];
        }
        
    } @catch (NSException *exception) {
        
    }
}

- (void)setUserInfoData {
    
    @try {
        NSMutableDictionary *user_info = [CommonTools readFile:@"user_info.plist"];
        NSString *corp_code = user_info[@"corp_code"];
        NSString *company_name = user_info[@"company_name"];
        NSString *phone = user_info[@"phone"];
        NSString *sex = user_info[@"sex"];
        NSString *user_id = user_info[@"user_id"];
        NSString *user_name = user_info[@"user_name"];
        NSString *user_tag = user_info[@"user_tag"];
        NSString *avatar = user_info[@"avatar"];
        
        
        NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                          corp_code,@"corp_code",
                                          company_name,@"company_name",
                                          phone,@"phone",
                                          sex,@"sex",
                                          user_id,@"user_id",
                                          user_name,@"user_name",
                                          user_tag,@"user_tag", nil];
        if ([CommonTools checkUrlSrting:avatar]) {
            [returnDic setValue:avatar forKey:@"avatar"];
        }
        returnData = [CommonTools dictionaryToJson:(NSDictionary *)returnDic];
        
    } @catch (NSException *exception) {
        
    }
}

@end
