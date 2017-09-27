//
//  ThreeDetailViewController.m
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "ThreeDetailViewController.h"
#import "LeftSortsViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "AppDatas.h"
#import "ShowView.h"
#import "ShareMenuViewController.h"
#import "MyView.h"
#import "DetailViewController.h"
#import "LOSAFNetworking.h"
#import "LOSHelper.h"
//#import "AlterView.h"
#import "YJView.h"
#import "SPView.h"
#import "HXView.h"
#import "KLView.h"
#import "DianPuView.h"

@interface ThreeDetailViewController ()<UIScrollViewDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    
    UIButton * calendarBtn;

    UIView * tempview;

    ShowView *sv;
    
    NSMutableArray * arr;
    
    UIView *s;//标题
    UIScrollView *scrollview;//内容
    
    MyView *view;
    
    NSString *tempTitle;
    
    UIButton * nameBtn;
    
    NSInteger num;
    
    NSString * PiaCode;
    
    NSString * IndexOfLeft;

    UIView * line;
    UIButton *previousSelectedBtn;
    UIButton *currentSelectedBtn;
    UIAlertView *freeUserAlertView;
}

@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray <MyView *> *viewArray;


@end


@implementation ThreeDetailViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    @try {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
        [self requestDatasWithOrgCode:_orgCode];
        
        self.title = _storeName;
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
        
        LeftSortsViewController *lvc = (LeftSortsViewController *)tempAppDelegate.LeftSlideVC.leftVC;
        [lvc.slide4 loadGoodsView];
        
        
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
        
        [calendarBtn removeFromSuperview];
        calendarBtn = nil;
        
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
        
        [tempview removeFromSuperview];
        tempview = nil;
        
        tempview = [[UIView alloc]initWithFrame:self.view.bounds];
        
        [self.view addSubview:tempview];
        
        // [self createUI];
        
        [sv removeFromSuperview];
        sv = nil;
        
        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        [sv CreateView];
        [self.view addSubview:sv];
        
        [freeUserAlertView removeFromSuperview];
        freeUserAlertView = nil;
        
        freeUserAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"付费用户可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    @try {
     
        [previousSelectedBtn setSelected:YES];
        [currentSelectedBtn setSelected:NO];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (void)requestDatasWithOrgCode:code {
    
    @try {
     
#pragma mark  检查网络
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            //[[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSDictionary * dataDic =  [NSDictionary dictionaryWithObjectsAndKeys:
                                           [AppDatas sharedDatas].userCode, @"user_code",
                                           code, @"store_code",
                                           [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd, @"start_date",
                                           [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd, @"end_date",
                                           nil];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreDetailTrend"
                             dataParameters:dataDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        DLogObject(responseDic);
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            self.dataDic = responseDic;
                                            [self createUI];
                                            
                                        });
                                    }
                                    failure:^(NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            //   [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)viewWillAppear:(BOOL)animated{
    
    @try {
     
        [super viewWillAppear:animated];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)createUI{
    
    @try {
      
        arr = nil;
        arr = [NSMutableArray new];
        NSArray *title = @[@"业绩",@"商品",@"会销",@"客流"];
        NSArray * image =  @[@"icon_业绩",@"icon_商品",@"icon_会销",@"icon_客流"];
        NSArray * imageSel =  @[@"icon_业绩_s",@"icon_商品_s",@"icon_会销_s",@"icon_客流_s"];
        
        
        [line removeFromSuperview];
        line = nil;
        
        line = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 * SCREEN_H_SP - 0.5, SCREEN_WIDTH, 0.3)];
        line.backgroundColor = [UIColor colorWithHex:0xa8a8a8];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.view.width, 2) cornerRadius:1];
        line.layer.shadowPath = path.CGPath;
        [[line layer] setShadowOffset:CGSizeMake(0, 0)];
        [[line layer] setShadowOpacity:0.9];
        [[line layer] setShadowColor:[UIColor blackColor].CGColor];
        
        [tempview addSubview:line];
        
        
        [s removeFromSuperview];
        s = nil;
        
        s=[[UIView alloc]initWithFrame:CGRectMake(0,SCREEN_HEIGHT - 50 * SCREEN_H_SP, SCREEN_WIDTH,50* SCREEN_H_SP)];
        s.backgroundColor = [UIColor whiteColor];
        
        
        UIButton *firstBtn;
#pragma mark - 底部buttons
        for (int i=0; i<2; i++) {
            UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 * i + 5* SCREEN_W_SP,0, (SCREEN_WIDTH - 10* SCREEN_W_SP) / 2, 40* SCREEN_H_SP)];
            [btn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHex:0xd54851] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:imageSel[i]] forState:UIControlStateSelected];
            btn.imageEdgeInsets = UIEdgeInsetsMake(12* SCREEN_H_SP,10 *SCREEN_H_SP,5* SCREEN_H_SP,21* SCREEN_H_SP);
            btn.titleEdgeInsets = UIEdgeInsetsMake(12* SCREEN_H_SP, 15* SCREEN_H_SP,3* SCREEN_H_SP , 0);
            [btn setTitle:title[i] forState:UIControlStateNormal];
            btn.tag = 100 + i;
            [arr addObject:btn];
            [btn addTarget:self action:@selector(btn_Select:) forControlEvents:UIControlEventTouchUpInside];
            [s addSubview:btn];
            
            if (i == 0) {
                firstBtn = btn;
                
                //业绩看板特殊
                //            btn.selected = YES;
                
                [nameBtn setTitle:self.dataDic[@"data"][@"dataDay"][0][@"titleNam"] forState:UIControlStateNormal];
                
                self.navigationItem.titleView = nameBtn;
                
                //        self.title = self.dataDic[@"data"][@"dataDay"][0][@"titleNam"];;
                
            }
        }
        [tempview addSubview:s];
        
        self.viewArray = nil;
        
        self.viewArray = [NSMutableArray array];
#pragma mark - 创建三级页面
        [scrollview removeFromSuperview];
        scrollview = nil;
        
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT - 50* SCREEN_H_SP)];
        NSArray *viewAry = @[@"YJView",@"SPView",@"HXView",@"KLView"];
        for (int i = 0; i < 4; i++) {
            UIView *iv =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 50)];
            NSString *temp = viewAry[i];
            Class c = NSClassFromString(temp);
            view = [[c alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50* SCREEN_H_SP)];
            
            [iv addSubview:view];
            [scrollview addSubview:iv];
            //正向传值（方式1）
            view.nc = self.navigationController;
            
            [self.viewArray addObject:view];
        }
        
        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        tempDelegate.LeftSlideVC.thiredLevelViewArray = self.viewArray;
        
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 4, 0);
        scrollview.backgroundColor = [UIColor whiteColor];
        scrollview.delegate=self;
        scrollview.scrollEnabled = NO;
        scrollview.pagingEnabled=YES;
        scrollview.showsHorizontalScrollIndicator=NO;
        scrollview.showsVerticalScrollIndicator=NO;
        [tempview addSubview:scrollview];
        //默认点击第一个btn
        [self btn_Select:firstBtn];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 按钮事件函数
-(void)btn_Select:(UIButton *)sender{

    @try {
      
        currentSelectedBtn = sender;
        
        if (sender.selected) {
            
            return;
            
        }
        
        num = sender.tag;
        for (UIButton *btn in arr) {
            if ([btn isSelected]) {
                
                previousSelectedBtn = btn;
                
            }
            
            btn.selected = NO;
        }
        sender.selected = YES;
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
#pragma mark - 免费用户
        NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
        
        if (num == 100) {
            
             [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情业绩 YJView" forKey:@"crashTheClassName"];
            
            [scrollview setContentOffset:CGPointMake((num - 100) * SCREEN_WIDTH, 0) animated:NO];
            
            UIView * baiseView = self.viewArray[0];
            
            YJView * yj = (YJView *)baiseView;
            
            [yj receiveYeJiCode:_orgCode];
            
            
            [nameBtn setTitle:self.dataDic[@"data"][@"dataDay"][0][@"titleNam"] forState:UIControlStateNormal];
            
            self.navigationItem.titleView = nameBtn;
            
            [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
            [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
        }
        
        
        if (num == 101) {
            
            if (userType == 2) {
                
                [freeUserAlertView show];
                
            } else {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情商品 SPView" forKey:@"crashTheClassName"];
                
                [scrollview setContentOffset:CGPointMake((num - 100) * SCREEN_WIDTH, 0) animated:NO];
                
                UIView * baiseView = self.viewArray[1];
                
                SPView * sp = (SPView *)baiseView;
                
                [sp receiveGoodsCode:_orgCode WithTitleCode:_titleCode];
                
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoods];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGoods];
            }
            
        } if (num == 102) {
            
            if (userType == 2) {
                
                [freeUserAlertView show];
                
            } else {
                
                [scrollview setContentOffset:CGPointMake((num - 100) * SCREEN_WIDTH, 0) animated:NO];
                
                UIView * baiseView = self.viewArray[2];
                
                HXView * hx = (HXView *)baiseView;
                
                [hx receiveHuiXiaoCode:_orgCode];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
            }
            
        }if (num == 103){
            
            if (userType == 2) {
                
                [freeUserAlertView show];
                
            } else {
                
                [scrollview setContentOffset:CGPointMake((num - 100) * SCREEN_WIDTH, 0) animated:NO];
                
                UIView * baiseView = self.viewArray[2];
                
                KLView * kl = (KLView *)baiseView;
                
                [kl receiveKeLiuCode:_orgCode];
                
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
            }
            
        }
        
        MyView *v = self.viewArray[num - 100];
        [v refreshView];
        
        
        [tempview bringSubviewToFront:line];
        [tempview bringSubviewToFront:s];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



-(void)leftBarBtnClicked{
    
    @try {
     
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeStoreRank];
        
        [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
        
        __block DianPuView *store = [DianPuView new];
        __weak DianPuView *store1 = store;
        
        store1.refreshBlock = ^(NSString *dateStr,NSString *temp){
            
            if (![dateStr isEqualToString:[AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd]) {
                
                NSLog(@"点击时间  %@",[AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd);
                
                //  [[NSNotificationCenter defaultCenter] removeObserver:self name:@"stroeRefreshAfterPop" object:nil];
                
                //  [[NSNotificationCenter defaultCenter]postNotificationName:@"stroeRefreshAfterPop" object:nil];
                [self.delegate stroeRefreshAfterPop];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"a" forKey:@"stroeRefresh"];
            }
        };
        
        [store1 refreshViewAfterPopFromStoreDetailVC];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
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
        }if (!calendarBtn.selected) {
            [sv backView];
        }
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 定位日历响应位置
-(void)positionCalendarLocation{
    
    @try {
     
        __block __weak id gpsObserver;
        
        gpsObserver = [[NSNotificationCenter defaultCenter]
                       addObserverForName:@"calendarBtn"
                       object:nil
                       queue:[NSOperationQueue mainQueue]
                       usingBlock:^(NSNotification *note){
                           
                           id vc = [UIApplication sharedApplication ].keyWindow.rootViewController;
                           
                           if( [vc isMemberOfClass:[LeftSlideViewController class]]){
                               LeftSlideViewController* lsvc= (LeftSlideViewController*)vc;
                               
                               id curvc=lsvc.mainVC;
                               if ([curvc isMemberOfClass:[UINavigationController class]]) {
                                   UINavigationController* navs=(UINavigationController*)lsvc.mainVC;
                                   curvc=navs.visibleViewController;
                               }
                               
                               if(curvc ==self){
                                   
                                   if (num == 100) {
                                       
                                       
                                       
                                       
                                       UIView * baiseView = self.viewArray[0];
                                       
                                       YJView * yj = (YJView *)baiseView;
                                       
                                       [yj renjia1:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
                                       
                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"jjt1" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                   }else if (num == 101){
                                       
                                       
                                       
                                       UIView * baiseView = self.viewArray[1];
                                       
                                       SPView * sp = (SPView *)baiseView;
                                       
                                       [sp goods:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGoods];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoods];
                                       
                                       
                                   }else if (num == 102){
                                       
                                       
                                       UIView * baiseView = self.viewArray[2];
                                       
                                       HXView * hx = (HXView *)baiseView;
                                       
                                       [hx huixiao:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
                                       
                                       
                                   }else if (num == 103){
                                       
                                       UIView * baiseView = self.viewArray[2];
                                       
                                       KLView * kl = (KLView *)baiseView;
                                       
                                       [kl keliu:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
                                       
                                       
                                   }
                                   
                               }
                           }
                           
                           else  if (vc == self) {
                               
                           }
                           
                           calendarBtn.selected = NO;
                           
                           
                           DLog(@"run once, and only once!");
                           
                           [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                           
                       }];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
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
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情 ThreeDetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

@end
