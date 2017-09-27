//
//  DetailViewController.m
//  LOSBi
//
//  Created by JJT on 16/8/22.
//  Copyright © 2016年 L.O.S. All rights reserved.




/*
 
 
    二级页面ViewController（点击主页下半部分的tableViewCell跳转至此ViewController）
 */



#import "DetailViewController.h"
#import "ShowView.h"
#import "ShareMenuViewController.h"
#import "MyView.h"
#import "LOSAFNetworking.h"
#import "LeftSortsViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "AppDatas.h"
#import "CalendarView.h"
#import "LOSHelper.h"
#import "MBProgressHUD.h"
#import "LOConst.h"
#import "YeJiView.h"
#import "DianPuView.h"
#import "ShangPinView.h"
#import "GuanJianView.h"
#import "QuYuView.h"
#import "DaoGouView.h"
#import "SheQuView.h"

@interface DetailViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource, UIAlertViewDelegate, MBProgressHUDDelegate,DianPuViewDelegate,ShangPinViewDelegate,YeJiViewDelegate,GuanJianViewDelegate,QuYuViewDelegate,shoppingViewDelegate,SheQuDelegate>
{
    
    BOOL _statusBarHidden;
    
    UIButton * calendarBtn;
    ShowView *sv; //日历展示
    UIScrollView *s;//标题
    UIScrollView *scrollview;//内容
    UIButton * rightBtn;
    UIButton * lefttBtn;
    NSMutableArray<UIButton *> * arr;
    UIView * tempview;
    MyView *view;
    UIImageView * imageView0;
    UIImageView * imageView1;
    UIImageView * imageView2;
    NSString * two;
    NSString * one;
    UIView * gestureView;
    CGPoint curP;
    CGFloat dragPSum;
    NSTimeInterval touchTime;
    NSInteger menuOffset;
    BOOL isMenuOffset;
    BOOL isTouchesDidEnded;
    
    BOOL _communityBool;
    
    CGRect _fram;
    
    NSInteger num;
    MBProgressHUD *HUD;
    UIButton *backView;
    UITableView *_tableView;
    UIButton *imageBtn;
    
    NSString * arrFirst1;
    
    UIButton *titleBtn;

    NSInteger _indexTitleName;
    
    UIImageView *leftArrowView;
    UIImageView *rightArrowView;
    
    UIButton *previousSelectedBtn;
    UIButton *currentSelectedBtn;
    UIAlertView *freeUserAlertView;
    
    UIView * line;
    
    UILabel * _nameLabel;
    UILabel * _roundLabel;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {

    @try {
     
       [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
#pragma mark 测试崩溃日志
        //    @try {
        //
        //        NSArray * array = [NSArray array];
        //        for (NSInteger i = 0; i < 3; i ++ ) {
        //            [array objectAtIndex:i];
        //        }
        //
        //    } @catch (NSException *exception) {
        //
        //        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        //
        //    } @finally {
        //
        //    }
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CommunityRoundLabelDisplay) name:@"CommunityPush" object:nil];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SheQuButton"];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.drillOrgCode forKey:@"orgCodeCode"];
        _statusBarHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"clearGuanJianLeftDatas" object:nil];
        
#pragma mark - 品牌名按钮
        
        [titleBtn removeFromSuperview];
        titleBtn = nil;
        
        titleBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 30 * SCREEN_W_SP, 0, 120 * SCREEN_W_SP, 44)];
        
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [titleBtn addTarget:self action:@selector(titleListCilck:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120 * SCREEN_W_SP, 24)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = self.titleName;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [titleBtn addSubview:_nameLabel];
        
        
        UIImageView * downImgeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 24, 10, 10)];
        downImgeView.center = CGPointMake(_nameLabel.frame.size.width/2, titleBtn.center.y + 10);
        downImgeView.image = [UIImage imageNamed:@"arrow_导航栏_down"];
        [titleBtn addSubview:downImgeView];
        
        self.navigationItem.titleView = titleBtn;
        
        NSUserDefaults *tage = [NSUserDefaults standardUserDefaults];
        two = [tage objectForKey:@"two"];
        one = [tage objectForKey:@"one"];
        
#pragma mark - 侧滑栏设置
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
        LeftSortsViewController *lvc = (LeftSortsViewController *)tempAppDelegate.LeftSlideVC.leftVC;
        [lvc.slide1 setGoodsIndex:0];
        [lvc.slide1 loadGoodsRankView];
        
        [lvc.slide setStoreRankIndex:0];
        [lvc.slide loadStoreRankView];
        
        self.automaticallyAdjustsScrollViewInsets = NO; //scrollview直接加在在self.view上，会自动留有64的距离
        
        self.view.backgroundColor = [UIColor whiteColor];
        
#pragma mark - 导航栏左按钮
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 0, 30, 44);
        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        
#pragma mark - 导航栏右按钮集
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -16;
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(0, 0, 44, 44);
        [shareBtn setImage:[UIImage imageNamed:@"icon_share"]
                  forState:UIControlStateNormal];
        //    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [shareBtn addTarget:self
                     action:@selector(shareBtnClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        
#pragma mark - 导航栏日历按钮
        [calendarBtn removeFromSuperview];
        calendarBtn = nil;
        
        calendarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        calendarBtn.frame = CGRectMake(0, 0, 44, 44);
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
        [calendarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);//文字下移
        [calendarBtn addTarget:self action:@selector(calendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *rightBtnsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        [rightBtnsView addSubview:shareBtn];
        [rightBtnsView addSubview:calendarBtn];
        calendarBtn.x = 0;
        shareBtn.x = 44;
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
        
#pragma mark - 导航栏右视图
        self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightBarButtonItem];
        
        calendarBtn.x = 0;
        shareBtn.x = 44;
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightBtnsView];
        
        //导航栏右视图
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, rightBarButton];
        
        [tempview removeFromSuperview];
        tempview = nil;
        
        tempview = [[UIView alloc]initWithFrame:self.view.bounds];
        
        [self.view addSubview:tempview];
        
        [self createUI];
        
        [sv removeFromSuperview];
        sv = nil;
        
        sv = [[ShowView alloc]initWithFrame:self.view.bounds];
        [sv CreateView];
        [self.view addSubview:sv];
        
#pragma mark - 点击品牌名出现的背景view
        [backView removeFromSuperview];
        backView = nil;
        
        backView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
        
        backView.hidden = YES;
        
        [backView addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
        
#pragma mark - 导航栏点击品牌按钮 展示品牌数组
        UIView *titleListView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4, 64 + 3, SCREEN_WIDTH / 2, 5 * 40)];
        titleListView.backgroundColor = [UIColor whiteColor];
        titleListView.layer.cornerRadius = 5;
        titleListView.clipsToBounds = YES;
        [backView addSubview:titleListView];
        
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, titleListView.width, titleListView.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // _tableView.separatorInset = UIEdgeInsetsMake(0,10, 0, 10);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [titleListView addSubview:_tableView];
        _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCellForList"];
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:backView];
        
        
        [freeUserAlertView removeFromSuperview];
        freeUserAlertView = nil;
        
        freeUserAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"付费用户可用" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBack:) name:@"titleBack" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedDates:) name:NotificationForSelectDate object:nil];

    } @catch (NSException *exception) {
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)CommunityRoundLabelDisplay{
    
    _roundLabel.hidden = NO;
}

#pragma mark 消失社区小红点
-(void)disappearRedRoundLabel{
    
    _roundLabel.hidden = YES;
}


#pragma mark 调整品牌名
-(void)transMitheadTitle:(NSString *)headTitleString  nameString:(NSString *)nameString{
    
    @try {

        RequestInterfceViewController * RequestInterfceVC = [[RequestInterfceViewController alloc]init];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[AppDatas sharedDatas].userCode forKey:@"user_code"];
        if (headTitleString.length == 0) {
            return;
        }
        
        [dic setObject:headTitleString forKey:@"org_code"];
        
        [RequestInterfceVC requestEnrollInterface:@"com.bizvane.sun.usee.method.news2.TitleBrother" requestDic:dic];
        
        RequestInterfceVC.successBlock = ^(NSDictionary * dataDic){

            self.titleNameArr = nil;
            self.orgCodeArr   = nil;
            self.titleNameArr = [NSMutableArray array];
            self.orgCodeArr   = [NSMutableArray array];
            
            
            NSMutableArray * dataArray = [[NSMutableArray alloc] initWithArray:dataDic[@"data"][@"title"]];
                        for (NSInteger i = 0; i < dataArray.count; i ++) {
                [self.orgCodeArr addObject:dataArray[i][@"code"]];
                [self.titleNameArr addObject:dataArray[i][@"name"]];
            }
            self.drillOrgCode = headTitleString;
             _nameLabel.text = nameString;
             [_tableView reloadData];
            [[HUDHelper getInstance] hideHUD];
            
            
        };
        
        RequestInterfceVC.errolBlock = ^(NSInteger errorCode){
            [[HUDHelper getInstance] hideHUD];
            
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

    NSLog(@"调整品牌名 %@",headTitleString);
}


#pragma mark - 状态栏隐藏
- (BOOL)prefersStatusBarHidden
{
    @try {
       
        return _statusBarHidden;
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 页面即将出现 展示导航栏
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    @try {
        
        NSString * sheQuString  = [[NSUserDefaults standardUserDefaults] objectForKey:@"SheQuButton"];
       
        NSString * communityUserString = [[NSUserDefaults standardUserDefaults] objectForKey:[AppDatas sharedDatas].userCode];
       // [[NSUserDefaults standardUserDefaults] setObject:@"11" forKey:];

        if ([communityUserString isEqualToString:@"11"]) {
            _roundLabel.hidden = NO;
        }
        
        if ([sheQuString isEqualToString:@"aa"]) {
            AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
            
            [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
            
        }
        
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xba2932];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        if (_communityBool == NO) {
            
            self.navigationController.navigationBarHidden = YES;
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 页面即将消失 侧边栏的设置
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    @try {
     
        [CommonTools removeFile:@"twoLinchpin"];
        [CommonTools removeFile:@"linchpinSelect"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linchpinCount"];
        
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 创建页面UI（主要是tabBar各按钮）
-(void)createUI{
    
    @try {
     
        arr = [NSMutableArray<UIButton *> new];
        NSArray *title = @[@"业绩看板",@"店铺排行",@"商品排行",@"关键指标",@"区域看板",@"导购排行",@"  社区  "];
        NSArray * image =  @[@"icon_业绩看板",@"icon_店铺排行",@"icon_商品排行",@"icon_关键指标",@"icon_区域看板",@"icon_导购排行",@"icon_社区"];
        NSArray * imageSel =  @[@"icon_业绩看板_s",@"icon_店铺排行_s",@"icon_商品排行_s",@"icon_关键指标_s",@"icon_区域看板_s",@"icon_导购排行_s",@"icon_社区_s"];
        
        [line removeFromSuperview];
        line = nil;
        
        if (SCREEN_HEIGHT == 812) {
            line = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70 * SCREEN_H_SP - 0.5, SCREEN_WIDTH, 0.7)];
           
            UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 30, SCREEN_WIDTH, 30)];
            bottomView.backgroundColor  = [UIColor colorWithHex:0xdfdfdf];
            [tempview addSubview:bottomView];
            
        }
        else{
             line = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 * SCREEN_H_SP - 0.5, SCREEN_WIDTH, 0.7)];
        }
        
        line.backgroundColor = [UIColor colorWithHex:0xa8a8a8];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.view.width, 2) cornerRadius:1];
        
        // 设置填充颜色
        UIColor *fillColor = [UIColor greenColor];
        [fillColor set];
        [path fill];
        line.layer.shadowPath = path.CGPath;
        [[line layer] setShadowOffset:CGSizeMake(0, 0)];
        [[line layer] setShadowOpacity:0.9];
        [[line layer] setShadowColor:[UIColor blackColor].CGColor];
        
        [tempview addSubview:line];
        
        
        [s removeFromSuperview];
        s = nil;
        
        if (SCREEN_HEIGHT == 812) {
             s = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 70 * SCREEN_H_SP, SCREEN_WIDTH, 50 * SCREEN_H_SP)];
        }
        else{
             s = [[UIScrollView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50 * SCREEN_H_SP, SCREEN_WIDTH, 50 * SCREEN_H_SP)];
        }
        s.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        
        NSString *funcPermission = [[NSUserDefaults standardUserDefaults] objectForKey:@"funcPermission"];
        NSArray *permissionArray = [funcPermission componentsSeparatedByString:@","];
        NSInteger permissionCount = -1;
        
        //底部buttons
        for (int i = 0; i < 7; i++) {
            
            BOOL access = NO;
            
            for (NSString *funcCode in permissionArray) {
                
                NSInteger code = [funcCode integerValue];
                
                if (i + 1 == code) {
                    
                    access = YES;
                    ++permissionCount;
                    break;
                    
                }
                
            }
            
            if (access) {
                
                UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * permissionCount, 0, SCREEN_WIDTH / 4, 50 * SCREEN_H_SP)];
                btn.tag = 10 + i;
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
                
                if (SCREEN_WIDTH > 414) {
                    btn.imageEdgeInsets = SCREEN_WIDTH > 320 ? UIEdgeInsetsMake(0 * SCREEN_H_SP, 35, 12 * SCREEN_H_SP, 2 * SCREEN_W_SP) : UIEdgeInsetsMake(0 * SCREEN_H_SP, 32, 12 * SCREEN_H_SP, -1 * SCREEN_W_SP);
                    btn.titleEdgeInsets = SCREEN_WIDTH > 320 ? UIEdgeInsetsMake(32 * SCREEN_H_SP, -10, 0 * SCREEN_H_SP, 10 * SCREEN_W_SP) : UIEdgeInsetsMake(32 * SCREEN_H_SP, -15, 0 * SCREEN_H_SP, 15 * SCREEN_W_SP);
                }
                else if(SCREEN_WIDTH > 375 && SCREEN_WIDTH <=  414){
                    
                    btn.imageEdgeInsets =  UIEdgeInsetsMake(0 * SCREEN_H_SP, 32, 12 * SCREEN_H_SP, -1 * SCREEN_W_SP);
                    if (i == 6) {
                        btn.titleEdgeInsets =  UIEdgeInsetsMake(32 * SCREEN_H_SP, -15+8, 0 * SCREEN_H_SP, 15 * SCREEN_W_SP);
                    }
                    else{
                        btn.titleEdgeInsets =  UIEdgeInsetsMake(32 * SCREEN_H_SP, -15+4 , 0 * SCREEN_H_SP, 15 * SCREEN_W_SP);
                    }
                    
                }
                else{
                    
                    btn.imageEdgeInsets = SCREEN_WIDTH > 320 ? UIEdgeInsetsMake(0 * SCREEN_H_SP, 35 * SCREEN_W_SP, 12 * SCREEN_H_SP, 2 * SCREEN_W_SP) : UIEdgeInsetsMake(0 * SCREEN_H_SP, 32 * SCREEN_W_SP, 12 * SCREEN_H_SP, -1 * SCREEN_W_SP);
                    btn.titleEdgeInsets = SCREEN_WIDTH > 320 ? UIEdgeInsetsMake(32 * SCREEN_H_SP, -10 * SCREEN_W_SP, 0 * SCREEN_H_SP, 10 * SCREEN_W_SP) : UIEdgeInsetsMake(32 * SCREEN_H_SP, -15 * SCREEN_W_SP, 0 * SCREEN_H_SP, 15 * SCREEN_W_SP);
                    
                }
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateSelected];
                
                NSBundle *bundle = [NSBundle mainBundle];
                NSString *resourcePath = [bundle resourcePath];
                
                NSString * imageFilePath = [resourcePath stringByAppendingPathComponent:image[i]];
                
                NSString * imageSelPath = [resourcePath stringByAppendingPathComponent:imageSel[i]];
                
                
                if (SystemVersion >= 8.0) {
                    
                    [btn setImage:[UIImage imageWithContentsOfFile:imageFilePath] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageWithContentsOfFile:imageSelPath] forState:UIControlStateSelected];
                }
                else{
                    
                    [btn setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@@2x.png",imageFilePath]] forState:UIControlStateNormal];
                    [btn setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@@2x.png",imageSelPath]] forState:UIControlStateSelected];
                }
                
               
                [btn setTitle:title[i] forState:UIControlStateNormal];
                [arr addObject:btn];
                [btn addTarget:self action:@selector(btn_Select:) forControlEvents:UIControlEventTouchUpInside];
                [s addSubview:btn];
                
                if (i == 6) {
                    
                    _roundLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width/2+8, 5, 8, 8)];
                    _roundLabel.backgroundColor = [UIColor redColor];
                    _roundLabel.layer.masksToBounds = YES;
                    _roundLabel.layer.cornerRadius = 4;
                    

                   NSString * CommunityUserString = [[NSUserDefaults standardUserDefaults] objectForKey:[AppDatas sharedDatas].userCode];
                
                if ([CommunityUserString isEqualToString:@"11"])
                {
                    _roundLabel.hidden = NO;
                }
                else{
                     _roundLabel.hidden = YES;
                }
                    
                   
                    [btn addSubview:_roundLabel];
                    
                }
                
                
                if (i == 0) {
                    
                    //                firstBtn = btn;
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    
                    [imageView0 removeFromSuperview];
                    imageView0 = nil;
                    
                    imageView0 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    imageView0.image = [UIImage imageNamed:@"img_左右滑动切换统计图表"];
                    imageView0.userInteractionEnabled = YES;
                    if ([one isEqualToString:@"1"]) {
                        
                        imageView0.hidden = YES;
                    }
                    
                    [window addSubview:imageView0];
                    UIPanGestureRecognizer *panRecognizer0 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom0:)];
                    panRecognizer0.delegate = self;
                    [imageView0 addGestureRecognizer:panRecognizer0];
                    
                }
            }
            
        }
        
        UIButton *firstBtn;
        if (arr.count > 0) {
            firstBtn = arr[0];
        }
        
        one = @"1";
        NSUserDefaults *tage = [NSUserDefaults standardUserDefaults];
        [tage setObject:one forKey:@"one"];
        
        s.bounces = NO;
        
        s.decelerationRate = 0;
        s.contentSize = CGSizeMake(SCREEN_WIDTH / 4 * permissionArray.count, 0);
        s.delegate=self;
        //    s.scrollEnabled = NO;
        s.scrollEnabled = YES;
        s.showsHorizontalScrollIndicator=NO;
        s.showsVerticalScrollIndicator=NO;
        [tempview addSubview:s];
        
        if (arr.count > 4) {
            
            UIImage *leftArrow = [UIImage imageNamed:@"icon_滚动箭头_L"];
            UIImage *rightArrow = [UIImage imageNamed:@"icon_滚动箭头_R"];
            
            [leftArrowView removeFromSuperview];
            leftArrowView = nil;
            
            [rightArrowView removeFromSuperview];
            rightArrowView = nil;
            
            leftArrowView = [[UIImageView alloc]initWithImage:leftArrow];
            rightArrowView = [[UIImageView alloc]initWithImage:rightArrow];
           
            
            if (SCREEN_HEIGHT == 812) {
                [leftArrowView setFrame:CGRectMake(5 * SCREEN_W_SP, SCREEN_HEIGHT - (80 * SCREEN_H_SP / 2 + leftArrow.size.height / 2), leftArrow.size.width, leftArrow.size.height)];
            }
            else{
                [leftArrowView setFrame:CGRectMake(5 * SCREEN_W_SP, SCREEN_HEIGHT - (50 * SCREEN_H_SP / 2 + leftArrow.size.height / 2), leftArrow.size.width, leftArrow.size.height)];
            }
            
           
            
            if (SCREEN_HEIGHT == 812) {
                [rightArrowView setFrame:CGRectMake(SCREEN_WIDTH - rightArrow.size.width - 5 * SCREEN_W_SP, SCREEN_HEIGHT - (80 * SCREEN_H_SP / 2 + rightArrow.size.height / 2), rightArrow.size.width, rightArrow.size.height)];
            }
            else{
                [rightArrowView setFrame:CGRectMake(SCREEN_WIDTH - rightArrow.size.width - 5 * SCREEN_W_SP, SCREEN_HEIGHT - (50 * SCREEN_H_SP / 2 + rightArrow.size.height / 2), rightArrow.size.width, rightArrow.size.height)];
            }
            
            leftArrowView.hidden = YES;
            
            [self.view addSubview:leftArrowView];
            [self.view addSubview:rightArrowView];
            
        }
        
        self.viewArray = nil;
        self.viewArray = [NSMutableArray array];
        //创建二级页面
        
        [scrollview removeFromSuperview];
        scrollview = nil;
        
        scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH ,SCREEN_HEIGHT - 50* SCREEN_H_SP)];
    
        
        NSArray *viewAry = @[@"YeJiView",@"DianPuView",@"ShangPinView",@"GuanJianView",@"QuYuView",@"DaoGouView",@"SheQuView"];
        
        for (int i = 0; i < 7; i++) {
            UIView *iv;
            if (SCREEN_HEIGHT == 812) {
                iv =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 90)];
            }
            else{
                iv =[[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT- 50)];
            }
            
            NSString *temp = viewAry[i];
            Class c = NSClassFromString(temp);
            
            if (SCREEN_HEIGHT == 812) {
                view = [[c alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 90* SCREEN_H_SP)];
            }
            else{
               view = [[c alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50* SCREEN_H_SP)];
            }
            [iv addSubview:view];
            [scrollview addSubview:iv];
            //正向传值（方式1）
            view.nc = self.navigationController;
            
            [self.viewArray addObject:view];
        }
        
        AppDelegate *tempDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        tempDelegate.LeftSlideVC.secondLevelViewArray = self.viewArray;
        
        scrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 7, 0);
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - scrollView回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    @try {
     
         [self scrollViewEnd];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (void)scrollViewEnd {
    
    @try {
        
        double d1 = s.contentOffset.x;
        double d2 = SCREEN_WIDTH / 4;
        int s1 = ((int)roundf(d1 / d2)) * d2;
        [s setContentOffset:CGPointMake(s1, 0)animated:YES];
        
        if (rightArrowView != nil && leftArrowView != nil) {
            
            if (s1 > d2 * (arr.count - 1) - SCREEN_WIDTH) {
                
                rightArrowView.hidden = YES;
                leftArrowView.hidden = NO;
                
            } else if (s1 < (int)d2) {
                
                rightArrowView.hidden = NO;
                leftArrowView.hidden = YES;
                
            } else if (s1 >= (int)d2 && s1 <= (int)(d2 * (arr.count - 1) - SCREEN_WIDTH)) {
                
                rightArrowView.hidden = NO;
                leftArrowView.hidden = NO;
                
            }
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - scrollView回调
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    @try {
     
        [self scrollViewEnd];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 底部tableBar按钮点击事件
- (void)btn_Select:(UIButton *)sender {
    
    @try {
     
        currentSelectedBtn = sender;
        
        if (sender.selected) {
            
            return;
            
        }
        
        for (UIButton *btn in arr) {
            
            if ([btn isSelected]) {
                
                previousSelectedBtn = btn;
                
            }
            
            btn.selected = NO;
        }
        
        _communityBool = YES;
        num = sender.tag;
        sender.selected = YES;
        UIWindow *window;
        UIPanGestureRecognizer *panRecognizer1;
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        //从社区页面切换其他页面让导航条不消失
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        NSString * orgCode = self.drillOrgCode;
        
        //免费用户
        NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
        
        //    YeJiView * yeJi = (YeJiView *)self.viewArray[0];
     
        //    DianPuView * dianPu = (DianPuView *)self.viewArray[1];
        //    ShangPinView * shangPin = (ShangPinView *)self.viewArray[2];
        //    GuanJianView * guanJian = (GuanJianView *)self.viewArray[3];
        
        [CommonTools removeFile:@"twoLinchpin"];
        [CommonTools removeFile:@"linchpinSelect"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linchpinCount"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"guanJianView"];
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SheQuButton"];
        
        switch (num) {
                
            case 10:
#pragma mark - 业绩看板
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                orgCode = self.drillOrgCode;
                
              //  if (self.drillTitleNameArr != nil) {
                    
                    //               [titleBtn setTitle:self.drillTitleName forState:UIControlStateNormal];
                  //  _nameLabel.text =self.drillTitleName;
                  //  [_tableView reloadData];
                    
              //  }
                
                UIView * baiseView = self.viewArray[0];
                
                YeJiView * yj = (YeJiView *)baiseView;
                
                yj.delegate = self;
                [yj orgCodeToYeJi:orgCode];
                
                
                // [[NSNotificationCenter defaultCenter] postNotificationName:@"YeJiKanBan" object:orgCode];
            }
                
                
                //            if (![dianPu isWaitingAlertDisplay] && ![shangPin isWaitingAlertDisplay] && ![guanJian isWaitingAlertDisplay]) {
                [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                //            }
                
                break;
                
            case 11:
#pragma mark - 店铺排行
            {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeStoreRank];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeStoreRank];
                [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                
                if (![two isEqualToString:@"2"]) {
                    window = [UIApplication sharedApplication].keyWindow;
                    imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    imageView1.image = [UIImage imageNamed:@"img_右滑打开侧边栏"];
                    imageView1.userInteractionEnabled = YES;
                    [window addSubview:imageView1];
                    
                    panRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom1:)];
                    panRecognizer1.delegate = self;
                    [imageView1 addGestureRecognizer:panRecognizer1];
                }
                
                if ([two isEqualToString:@"2"]) {
                    
                    imageView1.hidden = YES;
                    
                }

                UIView * baiseView = self.viewArray[1];
                
                DianPuView * dp = (DianPuView *)baiseView;
                
                dp.delegate = self;
                [dp orgCodeToDianPu:orgCode];
                
                }
                
                //            if (![yeJi isWaitingAlertDisplay]){
                //                if(![shangPin isWaitingAlertDisplay]) {
                //                    if (![guanJian isWaitingAlertDisplay]) {
                [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                //                    }
                //                }
                //            }
                
                break;
                
            case 12:
#pragma mark - 商品排行
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoodsRank];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGoodsRank];
                [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];

                UIView * baiseView = self.viewArray[2];
                
                ShangPinView * sp = (ShangPinView *)baiseView;
                
                sp.delegate = self;
                [sp orgCodeToShsngPin:orgCode];
                
            }
                
                //            if (![yeJi isWaitingAlertDisplay] && ![dianPu isWaitingAlertDisplay] && ![guanJian isWaitingAlertDisplay]) {
                [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                //            }
                
                break;
                
            case 13:
#pragma mark - 关键指标
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"111" forKey:@"guanJianView"];
               
                [[NSUserDefaults standardUserDefaults] setObject:@"关键指标 GuanJianView" forKey:@"crashTheClassName"];
                
                [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeKeyPoint];
                [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeKeyPoint];
                [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                
                UIView * baiseView = self.viewArray[3];
                
                GuanJianView * gj = (GuanJianView *)baiseView;
                
                gj.delegate = self;
                [gj orgCodeToGuanJian:orgCode];
                
                }
                
                //            if (![yeJi isWaitingAlertDisplay] && ![dianPu isWaitingAlertDisplay] && ![shangPin isWaitingAlertDisplay]) {
                [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                //            }
                
                break;
                
            case 14:
#pragma mark - 区域看板
            {
                
                if (userType == 2) {
                    
                    [freeUserAlertView show];
                    
                } else {
                    
                     [[NSUserDefaults standardUserDefaults] setObject:@"区域看板  QuYuView" forKey:@"crashTheClassName"];
                    
                    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
                    [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                    
                    [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                    
                    UIView * baiseView = self.viewArray[4];
                    
                    QuYuView * qy = (QuYuView *)baiseView;
                    qy.delegate = self;
                    [qy orgCodeToQuYu:orgCode];
                    
                }
                
            }
                
                break;
                
            case 15:
            {
#pragma mark - 导购
                
                if (userType == 2) {
                    
                    [freeUserAlertView show];
                    
                } else {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
                    
                    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                    //待修改2016.11.25
                    [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:LeftViewTypeGuide];
                    
                    [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGuide];
                    
                    [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                    
                    UIView * baiseView = self.viewArray[5];
                    
                    DaoGouView * dg = (DaoGouView *)baiseView;
                    
                    dg.delegate = self;
                    [dg orgCodeToQuYu:orgCode :self.titleName];
                    
                }
                
            }
                
                break;
                
            case 16:
#pragma mark - 社区
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"aa" forKey:@"SheQuButton"];
                
                if (userType == 2) {
                    
                    [freeUserAlertView show];
                    
                } else {
                     [[NSUserDefaults standardUserDefaults] setObject:@"社区  SheQuView" forKey:@"crashTheClassName"];
                    
                    [tempAppDelegate.mainNavigationController setNavigationBarHidden:YES];
                    
                    
                    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
                    [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                    
                    [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                    
                    _communityBool = NO;
                    UIView * baiseView = self.viewArray[6];
                    
                    SheQuView * sq = (SheQuView *)baiseView;
                    
                    sq.delegate = self;
                    [sq receiveCode:orgCode];
                    
                }
            }
                break;
                
            case 17:
                
                if (userType == 2) {
                    
                    [freeUserAlertView show];
                    
                } else {
                    
                    [tempAppDelegate.mainNavigationController setNavigationBarHidden:NO];
                    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
                    
                    [scrollview setContentOffset:CGPointMake((num - 10) * SCREEN_WIDTH, 0) animated:NO];
                    
                }
                
                break;
                
            default:
                
                break;
                
        }
        [tempview bringSubviewToFront:line];
        [tempview bringSubviewToFront:s];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 弹框按钮选择
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    @try {
     
        [previousSelectedBtn setSelected:YES];
        [currentSelectedBtn setSelected:NO];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - Title 展开按钮
- (void)titleListCilck:(UIButton *)button {
    
    backView.hidden = NO;
    
}


#pragma mark - 业绩看板title 返回
- (void)titleBack:(NSNotification *)notif {

    @try {
     
        self.drillTitleNameArr = notif.userInfo[@"titleNameArray"];
        self.drillTitleCodeArr = notif.userInfo[@"titleCodeArray"];
        self.drillOrgCode = notif.userInfo[@"drillOrgCode"];
        
        if (self.drillTitleCodeArr) {
            
            NSInteger matchIndex = 0;
            
            for (int i = 0; i < self.drillTitleCodeArr.count; i++) {
                
                if ([self.drillOrgCode isEqualToString:self.drillTitleCodeArr[i]]) {
                    
                    matchIndex = i;
                    break;
                    
                }
                
            }
            
            self.drillTitleName = self.drillTitleNameArr[matchIndex];
            //        [titleBtn setTitle:self.drillTitleNameArr[matchIndex] forState:UIControlStateNormal];
            _nameLabel.text = self.drillTitleNameArr[matchIndex];
            
        }
        
        [_tableView reloadData];

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}


#pragma mark - 数据源里包含品牌名
-(void)obtainTitleNameArrWith:(NSDictionary *)dic{
    
    @try {
     
        NSMutableArray *titleNameArr = [NSMutableArray new];
        self.titleCodeArr = [NSMutableArray new];
        NSArray *titleArr = dic[@"data"][@"title"];
        for (int i = 0; i < titleArr.count; i ++) {
            
            [titleNameArr addObject:titleArr[i][@"name"]];
            [_titleCodeArr addObject:titleArr[i][@"code"]];
            
        }
        
        _dataSourceArr = titleNameArr;
        
        
        if (_dataSourceArr) {
            
            if ([_dataSourceArr containsObject:_titleName]) {
                
                //            [titleBtn setTitle:_titleName forState:UIControlStateNormal];
                _nameLabel.text = _titleName;
                
            }else{
                
                
                //            [titleBtn setTitle:_dataSourceArr[0] forState:UIControlStateNormal];
                _nameLabel.text = _dataSourceArr[0];
            }
            
        }
        
        [_tableView reloadData];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - UITableViewDelegate,UITableViewDataSource 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    @try {
     
         return  self.titleNameArr.count;
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellForList"];
        
        cell.textLabel.text = self.titleNameArr[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithHex:0x888888];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
        cellBackView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = cellBackView;
        cell.textLabel.highlightedTextColor = [UIColor colorWithHex:0xd9434d];
        
        return cell;

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    @try {
     
        self.drillTitleName = self.titleNameArr[indexPath.row];
        //    [titleBtn setTitle:self.drillTitleName forState:UIControlStateNormal];
        _nameLabel.text = self.drillTitleName;
        self.drillOrgCode = self.orgCodeArr[indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.drillOrgCode forKey:@"orgCodeCode"];
        if (num == 10) {
            
            UIView * baiseView = self.viewArray[0];
            
            YeJiView * yj = (YeJiView *)baiseView;
            
            [yj brandToYeJi:self.drillOrgCode];
            
        } else {
            
            switch (num) {
                    
                case 11:
                {
                    
                    
                    UIView * baiseView = self.viewArray[1];
                    
                    DianPuView * dp = (DianPuView *)baiseView;
                    
                    [dp brandTableViewToDianPu:self.drillOrgCode];
                }
                    
                    break;
                    
                case 12:{
                    
                    UIView * baiseView = self.viewArray[2];
                    
                    ShangPinView * sp = (ShangPinView *)baiseView;
                    
                    [sp receiveTitleCode:self.drillOrgCode];
                    
                }
                    
                    break;
                    
                case 13:
                {
                    
                    UIView * baiseView = self.viewArray[3];
                    
                    GuanJianView * gj = (GuanJianView *)baiseView;
                    
                    [gj DetailVCTitleCodeToGuanJianView:self.drillOrgCode];
                }
                    
                    break;
                case 14:
                {
                    
                    UIView * baiseView = self.viewArray[4];
                    
                    QuYuView * qy = (QuYuView *)baiseView;
                    
                    [qy DetailVCTitleCodeToQuYuView:self.drillOrgCode];
                }
                    
                    break;
                    
                case 15:
                    
                {
                    
                    UIView * baiseView = self.viewArray[5];
                    
                    DaoGouView * dg = (DaoGouView *)baiseView;
                    
                    [dg DetailVCTitleCodeToGuideSaleClick:self.drillOrgCode];
                }
                    
                    break;
                    
                default:
                    
                    break;
                    
            }
            
        }
        
        backView.hidden = YES;
        
    } @catch (NSException *exception) {
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 隐藏品牌墙
-(void)disappear{
    
    @try {
     
        [UIView animateWithDuration:0.2 animations:^{
            
            
        } completion:^(BOOL finished) {
            
            backView.hidden = YES;
            
        }];

        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}


-(void)handlePanFrom2:(UITapGestureRecognizer*)recognizer
{
    @try {
        
        [imageView2 removeFromSuperview];
        imageView2 = nil;

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 首次进入页面 提示操作
-(void)handlePanFrom1:(UITapGestureRecognizer*)recognizer
{
    @try {
        
        if (recognizer.state == UIGestureRecognizerStateEnded) {
            if (imageView2) {
                return;
            }
            [imageView1 removeFromSuperview];
            imageView1 = nil;
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            
            imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView2.image = [UIImage imageNamed:@"img_排名页面收藏提示"];
            imageView2.userInteractionEnabled = YES;
            [window addSubview:imageView2];
            UIPanGestureRecognizer *panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom2:)];
            
            if ([two isEqualToString:@"2"]) {
                
                imageView2.hidden = YES;
            }
            [imageView2 addGestureRecognizer:panRecognizer2];
            
            two = @"2";
            NSUserDefaults *tage = [NSUserDefaults standardUserDefaults];
            [tage setObject:two forKey:@"two"];
        }

    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)handlePanFrom0:(UITapGestureRecognizer*)recognizer
{
    @try {
        
        [imageView0 removeFromSuperview];
        imageView0 = nil;
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 导航栏左侧按钮
-(void)leftBarBtnClicked{

    @try {
     
        [CommonTools removeFile:@"twoLinchpin"];
        [CommonTools removeFile:@"linchpinSelect"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"linchpinCount"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"guanJianView"];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
        
        //[tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeMain];
        
        
        // [[NSNotificationCenter defaultCenter] postNotificationName:@"returnToLeftZero" object:nil];
        
        
        [tempAppDelegate.mainNavigationController popToRootViewControllerAnimated:YES];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 导航栏右侧分享按钮点击事件
- (void)shareBtnClicked:(UIButton *)sender {
    
    @try {
        
        ShareMenuViewController *smvc = [[ShareMenuViewController alloc] initWithShareBtn:sender];
        
        //    smvc.vi = [LOSHelper getSnapshotImage];
        
        [self presentViewController:smvc animated:YES completion:^{
            
        }];

        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark -  获得点击的日期/时段

- (void)selectedDates:(NSNotification *)notification {
    
    @try {
        
        [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
        [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
        
        //    [self.mainPageDetailVC selectDateFrom:[AppDatas sharedDatas].selectFromDate
        //                                       to:[AppDatas sharedDatas].selectToDate];
        
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
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 定位日历的响应位置
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
                                   
                                   if (num == 10) {
                                       
                                       
                                       UIView * baiseView = self.viewArray[0];
                                       
                                       YeJiView * yj = (YeJiView *)baiseView;
                                       
                                       [yj renjia1:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
//                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"renjia1" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                   }else if (num == 11){
                                       
                                       
                                       UIView * baiseView = self.viewArray[1];
                                       
                                       DianPuView * dp = (DianPuView *)baiseView;
                                       
                                       [dp storeRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeStoreRank];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeStoreRank];
//
//                                       
//                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"renjia2" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                   }else if (num == 12){
                                       
                                       
                                       UIView * baiseView = self.viewArray[2];
                                       
                                       ShangPinView * sp = (ShangPinView *)baiseView;
                                       
                                       [sp goodsRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGoodsRank];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoodsRank];
//
//                                       //[[NSNotificationCenter defaultCenter] postNotificationName:@"renjia3" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                       
                                   }else if (num == 13){
                                       
                                       UIView * baiseView = self.viewArray[3];
                                       
                                       GuanJianView * gj = (GuanJianView *)baiseView;
                                       
                                       [gj keyRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeKeyPoint];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeKeyPoint];
//
//                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"renjia4" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                   }else if (num == 14){
                                       
                                       
                                       UIView * vvvv = self.viewArray[4];
                                       
                                       QuYuView * qy = (QuYuView *)vvvv;
                                       
                                       [qy regionRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:NOLeftViewType];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:NO leftViewType:NOLeftViewType];
//                                       // [[NSNotificationCenter defaultCenter] postNotificationName:@"renjia5" object:@{@"fromDate":[AppDatas sharedDatas].selectFromDate, @"toDate":[AppDatas sharedDatas].selectToDate}];
                                       
                                       
                                   }else if (num == 15){
                                       
                                       
                                       UIView * baiseView = self.viewArray[5];
                                       
                                       DaoGouView * dg = (DaoGouView *)baiseView;
                                       
                                       [dg guideSaleRank:[AppDatas sharedDatas].selectFromDate :[AppDatas sharedDatas].selectToDate];
                                       
                                       AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                       [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGuide];
                                       [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGuide];
//
//                                       
//                                       // [[NSNotificationCenter defaultCenter]postNotificationName:@"renjia_GuideSale" object:nil];
                                       
                                   }
                                   
                                   //    [self refreshDatasWithCache:YES];
                               }
                           }
                           
                           else  if (vc == self) {
                               
                               //        [self refreshDatasWithCache:YES];
                           }
                           
                           calendarBtn.selected = NO;
                           
                           
                           //                       [self refreshDatasWithCache:YES];
                           //                       
                           //                       calendarBtn.selected = NO;
                           
                           DLog(@"run once, and only once!");
                           
                           [[NSNotificationCenter defaultCenter] removeObserver:gpsObserver];
                           
                       }];
        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}


#pragma mark -  点击导航栏上日历按钮
-(void)calendarBtnClick{
    
    @try {
       
        calendarBtn.selected = !calendarBtn.selected;
        if (calendarBtn.selected) {
            
            sv = [[ShowView alloc]initWithFrame:self.view.bounds];
            
            [sv CreateView];
            
            [self.view addSubview:sv];
            
            
            [self positionCalendarLocation];
            
            [sv showView];
            
        }if (!calendarBtn.selected) {
            [sv backView];
        }

        
    } @catch (NSException *exception) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"进入七个模块  DetailViewController" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}

@end
