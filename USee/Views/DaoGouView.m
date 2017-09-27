//
//  DaoGouView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.



//      导购排行（二级页面）



#import "DaoGouView.h"
#import "BigBtnView.h"
#import "SegmentView.h"
#import "TableViewCellForGuideData.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "AppDelegate.h"
#import "BigAndTimeView.h"
#import "LOSHelper.h"
#import "GuideDetailViewController.h"
#import "AppDelegate.h"
#import "LOConst.h"
#import "AnimationView.h"



@interface DaoGouView ()<UITextFieldDelegate,SegmentViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,BigAndTimeViewDelegate> {

    
    UIView *headview; //数据行的标题栏 View
    UIScrollView *scrollViewForShowData; //数据行的 ScrollView
    UITableView *bodyTableView; //数据行的 TableView
    UIButton *collectAll; //全部收藏/全部取消 Button
    
    UIButton * _drillUpButton;
    UIButton * _drillDownButton;
    
    NSInteger indexForRankOrCollect; //排行或收藏夹切换的 Index
    NSInteger indexDayWeekMonthYear; //日周月年的 Index
    
    NSInteger _shoppingguideInteger;
    
    NSInteger _shoppingRecordNumberInteger;
    
    NSString *orgCode; //品牌 Code
    NSString *orgName; //品牌名称
    NSDictionary *mainDic; //数据源
    
    NSDictionary *searchDic; //数据源
    NSMutableArray *headArray; //数据源 tHead 开始
    NSMutableArray *dataSourceArray; //数据源 tBody 开始
    NSMutableArray *favoriteCodeArray; //数据源 所有的收藏 Code
    
    NSMutableArray * _shoppingTitArray;
    NSMutableArray * _shoppingCodeArray;
    
    BigAndTimeView* _bigview; //日周月年按钮
    
    AnimationView * animationView;
    
    TwoAnimationView * twoAnimationView;

    
    UIScrollView * scrollView1;

    NSString * _ShoppingguideDrillTypeString;
    
    NSInteger _indexOfPageNum;
    
    NSInteger _subHeadBarIndex;
    
    BOOL _isLoadMore;

    BOOL _shoppingGuideKeyBoradBool;
    BOOL _shoppingGuideTouchSeachBool;
    
}

@end

@implementation DaoGouView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _subHeadBarIndex = 0;
        _shoppingRecordNumberInteger = 1;
        
        _shoppingguideInteger = 1;
        
        _ShoppingguideDrillTypeString = @"0";
        
        _shoppingGuideTouchSeachBool = NO;
        _shoppingGuideKeyBoradBool = NO;
        
        indexForRankOrCollect = 1;
        indexDayWeekMonthYear = 1;
        _indexOfPageNum = 1;

        
        [self createUI];
        
#pragma mark - 键盘监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    return self;
}

-(void)keyboardAppear:(NSNotification *)notif{
    
    _shoppingGuideKeyBoradBool = YES;
}

-(void)keyboardWillHide:(NSNotification *)notif{
    
    _shoppingGuideKeyBoradBool = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    @try {
    
        [_tfText resignFirstResponder];
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (void)DetailVCTitleCodeToGuideSaleClick:(NSString *)OrgCode {
    
    @try {
        
        orgCode = OrgCode;
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        _shoppingguideInteger = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)guideSaleRank:(NSDate *)fromDate :(NSDate *)toDate{

    @try {
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 接收二级菜单跳转通知 DetailViewController
- (void)orgCodeToQuYu:(NSString *)orgCoded :(NSString *)orgNamed{
    
    @try {
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
        _shoppingguideInteger = 1;
        
        orgCode = orgCoded;
        orgName = orgNamed;
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        _isLoadMore = NO;
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 0602接口请求
- (void)request0602 {
    
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                //    写死的数据－－20161110
                NSString *pirCodeArray = @"P100100011";
                NSString *orderCode = @"D";
                NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_indexOfPageNum];
                NSString *orderPir = @"P100100011";
                
                //    以下变量要获取真实数据
                NSString *tabsCode = [NSString stringWithFormat:@"%ld", (long)indexForRankOrCollect]; //排行－收藏夹
                NSString *pageSize = @"";
                NSString *timeLevel = [NSString stringWithFormat:@"%ld", (long)indexDayWeekMonthYear]; //日周月年
                
                NSDictionary * shoppingGuideDic  =  [NSDictionary dictionaryWithObjectsAndKeys:
                                                     
                                                     [AppDatas sharedDatas].userCode,@"user_code",
                                                     orgCode,@"org_code",
                                                     tabsCode,@"tabs_code",
                                                     pirCodeArray,@"pir_code_array",
                                                     orderPir,@"order_pir",
                                                     orderCode,@"order_code",
                                                     pageSize,@"page_size",
                                                     pageNum,@"page_num",
                                                     [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd,@"start_date",
                                                     [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd,@"end_date",
                                                     timeLevel,@"time_level",
                                                     self.tfText.text,@"search_value",_ShoppingguideDrillTypeString,@"drill_type",
                                                     nil];
                
       [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.EmpSortTable"
                            dataParameters:shoppingGuideDic
                                 withCache:YES success:^(NSDictionary *responseDic) {
                                     
        dispatch_async(dispatch_get_main_queue(), ^{
                
            [[HUDHelper getInstance] hideHUD];  //加载中
                                         
            [bodyTableView footerEndRefreshing];
                                         
            
            [UIView animateWithDuration:0.4 animations:^{
                
                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
                bodyTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                
            }completion:^(BOOL finished){
                
                [animationView stopAnimating1];
                
                [twoAnimationView  stopAnimating1];

            }];
            
            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                             
                                             
            if ([responseDic[@"data"][@"tBody"]count] == 0 && _indexOfPageNum > 1) {
                                                 
                [[HUDHelper getInstance]showErrorTipWithLabel:@"暂无更多导购"];
              }
             else{
                                           
            mainDic = responseDic;
            
            if (_shoppingguideInteger == 1) {
            
              _subHeadBarIndex = 0;
                
              [self  refreshShoppingBigAndTimeView];
              [self refreshUpDrillTypeAndDownDrillType];
               _shoppingguideInteger = 2;
            }
            
            if ([_ShoppingguideDrillTypeString isEqualToString:@"1"] || [_ShoppingguideDrillTypeString isEqualToString:@"2"])
             {
            
            if ([mainDic[@"data"][@"subheadSidebar"] count] == 0)
            {
                
            _ShoppingguideDrillTypeString = @"0";

            _indexOfPageNum  =  _shoppingRecordNumberInteger;
                 return;
            }
            
            _subHeadBarIndex = 0;
            [self refreshUpDrillTypeAndDownDrillType];
            [self  refreshShoppingBigAndTimeView];
                 
            [self.delegate transMitheadTitle:mainDic[@"data"][@"subheadSidebar"][0][@"code"] nameString:mainDic[@"data"][@"subheadSidebar"][0][@"name"]];
        }
                                             
                                                 
        if (_isLoadMore) {
                                                     
                [self loadMoreData];
                                                     
        }else{
                                                     
            [self analysis0602WithDatasource:mainDic]; //解析数据并刷新控件
                            
        }
                                                 
            _indexOfPageNum ++;
            _shoppingRecordNumberInteger = _indexOfPageNum;
        }
                                             
        }else{
                                             
            if (_indexOfPageNum == 1) {
                            
            [scrollViewForShowData setContentOffset:CGPointMake(0, 0) animated:NO];
                            
            [bodyTableView setContentOffset:CGPointMake(0, 0) animated:NO];
            
            dataSourceArray = nil;
            
            [bodyTableView reloadData];
        }
          }

            _ShoppingguideDrillTypeString = @"0";
            
            });
                                     
                                 } failure:^(NSError *error) {
                                     
                                     
                dispatch_async(dispatch_get_main_queue(), ^{
                                         
                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                       
               _ShoppingguideDrillTypeString = @"0";
                                         
                [bodyTableView footerEndRefreshing];
                    
                [UIView animateWithDuration:0.4 animations:^{
                    
                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    
                    bodyTableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                }completion:^(BOOL finished){
                    
                    [animationView stopAnimating1];
                    
                    [twoAnimationView  stopAnimating1];
                }];
                    
               if (_indexOfPageNum == 1) {
                   
                [scrollViewForShowData setContentOffset:CGPointMake(0, 0) animated:NO];
                
                [bodyTableView setContentOffset:CGPointMake(0, 0) animated:NO];
                
                dataSourceArray = nil;
                
                [bodyTableView reloadData];
                                             
               }
                                         
            if (error.code == -1001) {
                                             
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                             
            }
            
            if(error.code == -1011){
                                             
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                             
            }
                    
                });
            }];
        });
    }
    
    else{
            
            [bodyTableView footerEndRefreshing];
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
    }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)refreshUpDrillTypeAndDownDrillType{
    
    if (SCREEN_WIDTH == 320) {
        self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
    }
    else if (SCREEN_WIDTH > 414){
        self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
    }
    else{
        self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
    }
    
    _drillUpButton.hidden = YES;
    _drillDownButton.hidden = YES;
}

#pragma mark - 加载更多数据
-(void)loadMoreData{

    @try {
     
        NSMutableArray *newMoreDataSourceArray = [mainDic[@"data"][@"tBody"] mutableCopy];
        
        if (newMoreDataSourceArray.count == 0) {
            
            
            
        }else{
            
            for (int i = 0; i < newMoreDataSourceArray.count; i ++) {
                
                [dataSourceArray addObject:[newMoreDataSourceArray objectAtIndex:i]];
            }
            
            favoriteCodeArray = nil;
            favoriteCodeArray = [NSMutableArray new];
            for (NSDictionary *tempDic in dataSourceArray) {
                
                [favoriteCodeArray addObject:tempDic[@"favoriteCode"]];
                
            }
            
            [bodyTableView reloadData];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
    
    }
}


#pragma mark - 解析0602接口数据
- (void)analysis0602WithDatasource:(NSDictionary *)dic {
    
  //  [[NSNotificationCenter defaultCenter]postNotificationName:@"GuideViewToLeftSideBar" object:nil];
    
    @try {
     
        [self refreshHeadview];
        [bodyTableView reloadData];
        
        [scrollViewForShowData setContentOffset:CGPointMake(0, 0) animated:NO];
        [bodyTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}



#pragma mark - 刷新headview

- (void)refreshHeadview {
    
    @try {
     
        headArray = mainDic[@"data"][@"tHead"];
        
        dataSourceArray = nil;
        dataSourceArray = [NSMutableArray new];
        
        dataSourceArray = [mainDic[@"data"][@"tBody"] mutableCopy];
        
        favoriteCodeArray = nil;
        favoriteCodeArray = [NSMutableArray new];
        
        for (NSDictionary *tempDic in dataSourceArray) {
            
            [favoriteCodeArray addObject:tempDic[@"favoriteCode"]];
            
        }
        
        for (int i = 0; i < headArray.count; i ++) {
            
            UILabel *label = (UILabel *)[self viewWithTag:1001 + i];
            label.text = headArray[i];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - UI创建
- (void)createUI {
    
    @try {
     
        [scrollView1 removeAllSubviews];
        
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
       
        if (SCREEN_HEIGHT == 812) {
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, self.height)];
        }
        else{
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.height)];
        }
        
        scrollView1.delegate =self;
        
        scrollView1.showsVerticalScrollIndicator = NO;
        
        scrollView1.contentSize = CGSizeMake(0, self.height);
        
        scrollView1.alwaysBounceVertical = YES;
        
        [self addSubview:scrollView1];
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -85, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
#pragma mark -     搜索框
        self.tfText.frame = CGRectMake(10 * SCREEN_W_SP, 120 *SCREEN_H_SP , SCREEN_WIDTH - 20 * SCREEN_W_SP, 28 * SCREEN_H_SP);
        [scrollView1 addSubview:self.tfText];
        
        [_drillUpButton removeFromSuperview];
        _drillUpButton = nil;
        
        _drillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _drillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_drillUpButton];
        if (SCREEN_WIDTH == 320) {
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 155*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH <= 414 && SCREEN_WIDTH > 375){
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 139*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320){
           _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 145*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }

        
        _drillUpButton.hidden = YES;
        [_drillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
        _drillUpButton.layer.masksToBounds = YES;
        _drillUpButton.layer.cornerRadius = 5;
        [_drillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        _drillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_drillUpButton addTarget:self action:@selector(stroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_drillDownButton removeFromSuperview];
        _drillDownButton = nil;
        
        _drillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _drillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_drillDownButton];
        _drillDownButton.hidden = YES;
        [_drillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        
        if (SCREEN_WIDTH == 320) {
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 155*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH <= 414 && SCREEN_WIDTH > 375){
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 139*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        else if(SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320){
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 145*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }

        
        
        [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
        _drillDownButton.layer.masksToBounds = YES;
        _drillDownButton.layer.cornerRadius = 5;
        _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_drillDownButton addTarget:self action:@selector(stroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        //    _scrollViewForShowData
        [scrollViewForShowData removeFromSuperview];
        scrollViewForShowData = nil;
        
        scrollViewForShowData = [[UIScrollView alloc]initWithFrame:CGRectMake(0, [LOConst refYH:_tfText p:10], SCREEN_WIDTH - 10, SCREEN_HEIGHT - [LOConst refYH:_tfText p:-100])];
        scrollViewForShowData.contentSize = CGSizeMake(SCREEN_WIDTH + 90 * SCREEN_W_SP, SCREEN_HEIGHT - [LOConst refYH:_tfText p:-100]);
        scrollViewForShowData.delegate = self;
        scrollViewForShowData.showsHorizontalScrollIndicator = NO;
        scrollViewForShowData.showsVerticalScrollIndicator = NO;
        scrollViewForShowData.alwaysBounceHorizontal = YES;
        scrollViewForShowData.backgroundColor = [UIColor whiteColor];
        [scrollView1 addSubview:scrollViewForShowData];
        
        self.tfText.placeholder = @"姓名／店名";
        
        //    headview ＋ tableView
        [self createheadviewAndTableView];
        
        
#pragma mark -      排行－－收藏夹
        NSArray *arrar = [NSArray arrayWithObjects:@"排行",@"收藏夹", nil];
        SegmentView *piecew;
        
        if (SCREEN_HEIGHT == 812) {
            piecew = [[SegmentView alloc]initWithFrame:CGRectMake(0, [LOConst refH:self p:-110], SCREEN_WIDTH, 40 * SCREEN_H_SP)];
        }
        else{
            piecew = [[SegmentView alloc]initWithFrame:CGRectMake(0, [LOConst refH:self p:-40], SCREEN_WIDTH, 40 * SCREEN_H_SP)];
        }
        piecew.backgroundColor = [UIColor whiteColor];
        piecew.delegate = self;
        piecew.textFont = [UIFont systemFontOfSize:14];
        piecew.textNormalColor = [UIColor grayColor];
        piecew.textSeletedColor = ColorThemeRed;
        piecew.linColor = ColorThemeRed;
        [piecew loadTitleArray:arrar];
        [scrollView1 addSubview:piecew];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark 刷新头部组织以及日、周、月、年
-(void)refreshShoppingBigAndTimeView{
    
    NSArray *arr = @[@"日",@"周",@"月",@"年",];
    
    NSArray * titNum = mainDic[@"data"][@"subheadSidebar"];
    
    _shoppingTitArray = nil;
    _shoppingTitArray = [NSMutableArray new];
    
    _shoppingCodeArray = nil;
    _shoppingCodeArray = [NSMutableArray new];
    
    for (int i =0; i < titNum.count; i++) {
        
        NSString * str = titNum[i][@"name"];
        
        NSString * codeStr = titNum[i][@"code"];
        
        [_shoppingCodeArray addObject:codeStr];
        
        [_shoppingTitArray addObject:str];
    }
    
#pragma mark -     日周月年
    [_bigview removeFromSuperview];
    _bigview = nil;
    
    _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 *SCREEN_H_SP)];
    _bigview.delegate =self;
    _bigview.checkUserType = YES;
//    NSArray *array = @[@"",@"",@"",@""];
    
    [_bigview showRegionAndShoppingGuideBigAndTimeView:_shoppingTitArray WithState:NO Withplaceholder:@"" WithTimeArray:arr withIndexOfSubheadBar:_subHeadBarIndex withIndexOfTime:indexDayWeekMonthYear - 1 scrollViewTag:1];
    
    [scrollView1 addSubview:_bigview];

}

#pragma mark 点击上钻按钮
-(void)stroeDrillUpTounchButton{
    
    _ShoppingguideDrillTypeString = @"1";
    
    NSString *textStr = [_tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textStr.length == 0) {
        _shoppingGuideTouchSeachBool = NO;
    }
    
    if (_shoppingGuideKeyBoradBool == YES) {
        [_tfText resignFirstResponder];
    }
    
    if (_shoppingGuideTouchSeachBool== NO) {
        _tfText.text = @"";
    }
    
    _isLoadMore = NO;
    _indexOfPageNum = 1;
    
    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    [self request0602];
    
}

#pragma mark 点击下钻按钮
-(void)stroeDrillDownTounchButton{
    
     _ShoppingguideDrillTypeString = @"2";
    
    NSString *textStr = [_tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (textStr.length == 0) {
        _shoppingGuideTouchSeachBool = NO;
    }
    
    if (_shoppingGuideKeyBoradBool == YES) {
        [_tfText resignFirstResponder];
    }
    
    if (_shoppingGuideTouchSeachBool== NO) {
        _tfText.text = @"";
    }
    
    _isLoadMore = NO;
    _indexOfPageNum = 1;
    
    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    [self request0602];
}

#pragma mark - subheadBar 切换
- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
        
        if (index > 0) {
            
            if (SCREEN_WIDTH == 320) {
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }
            else if (SCREEN_WIDTH > 414){
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }
            else{
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }

            _drillUpButton.hidden = NO;
            _drillDownButton.hidden = NO;
        }
        else if (index == 0){
            
            if (SCREEN_WIDTH == 320) {
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            else if (SCREEN_WIDTH > 414){
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            else{
                self.tfText.frame = CGRectMake(10, [LOConst refY:_bigview p:70] + 50* SCREEN_H_SP, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            
            _drillUpButton.hidden = YES;
            _drillDownButton.hidden = YES;

        }
        
        
            NSString *textStr = [_tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (textStr.length == 0) {
                _shoppingGuideTouchSeachBool = NO;
            }
            
            if (_shoppingGuideKeyBoradBool == YES) {
                [_tfText resignFirstResponder];
            }
            
            if (_shoppingGuideTouchSeachBool== NO) {
                _tfText.text = @"";
            }
        
            _isLoadMore = NO;
            _indexOfPageNum = 1;
        
            _subHeadBarIndex = index;
        
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
            orgCode = _shoppingCodeArray[_subHeadBarIndex];
        
            [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 切换日周月年
- (void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    
    @try {
        
        NSString *textStr = [_tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _shoppingGuideTouchSeachBool = NO;
        }
        
        if (_shoppingGuideKeyBoradBool == YES) {
            [_tfText resignFirstResponder];
        }
        
        if (_shoppingGuideTouchSeachBool== NO) {
            _tfText.text = @"";
        }
        
        indexDayWeekMonthYear = index + 1;
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark - 创建搜索框以下、排行/收藏夹以上 视图
- (void)createheadviewAndTableView {

    @try {
     
        [headview  removeFromSuperview];
        headview  = nil;
        
        headview = [[UIView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, scrollViewForShowData.contentSize.width - 10 * SCREEN_W_SP, 50 * SCREEN_H_SP)];
        headview.backgroundColor = Color(238, 238, 238);
        [scrollViewForShowData addSubview:headview];
        
        [headview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        
        headArray  = nil;
        headArray = [[NSMutableArray alloc]initWithObjects:@"排行",@"",@"",@"", nil];
        
        for (int i = 0 ; i < headArray.count; i ++) {
            
            UILabel *label;
            
            if (i == 0) {
                
                label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50 * SCREEN_W_SP, headview.height)];
                
            }else{
                
                if (SCREEN_WIDTH > 414) {
                    label = [[UILabel alloc]initWithFrame:CGRectMake(35 * SCREEN_W_SP + (SCREEN_WIDTH - (10 + 50) * SCREEN_W_SP) / (headArray.count - 1) * (i - 1), 0, (SCREEN_WIDTH - (10 + 50) * SCREEN_W_SP) / (headArray.count - 1), headview.height)];
                }
                else{
                    label = [[UILabel alloc]initWithFrame:CGRectMake(50 * SCREEN_W_SP + (SCREEN_WIDTH - (10 + 50) * SCREEN_W_SP) / (headArray.count - 1) * (i - 1), 0, (SCREEN_WIDTH - (10 + 50) * SCREEN_W_SP) / (headArray.count - 1), headview.height)];
                }
                
                label.tag = 1000 + i; //label的tag值从1001开始
                
            }
            
            label.text = headArray[i];
            label.textColor = ColorText;
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [headview addSubview:label];
            
        }
        
        //    全部收藏按钮
        [collectAll  removeFromSuperview];
        collectAll  = nil;
        
        collectAll = [[UIButton alloc]initWithFrame:CGRectMake(headview.width - 100 * SCREEN_W_SP + 10 * SCREEN_W_SP, headview.height / 4, 80 * SCREEN_W_SP, headview.height / 2)];
        if (indexForRankOrCollect == 1) {
            [collectAll setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else{
            [collectAll setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        [collectAll setTitleColor:ColorThemeRed forState:UIControlStateNormal];
        collectAll.titleLabel.font = Font_14;
        collectAll.layer.borderWidth = 1;
        collectAll.layer.borderColor = ColorThemeRed.CGColor;
        collectAll.layer.cornerRadius = 5;
        [collectAll addTarget:self action:@selector(favoriteButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
        [headview addSubview:collectAll];
        
        [bodyTableView  removeFromSuperview];
        bodyTableView  = nil;
        
        bodyTableView = [[UITableView alloc]init];
        
        if (SCREEN_WIDTH > 414) {
            bodyTableView.frame =  CGRectMake(-0.01, headview.y + headview.height, scrollViewForShowData.contentSize.width, self.height - headview.height - 120* SCREEN_H_SP - 40 * SCREEN_H_SP - 35 * SCREEN_H_SP);
        }
        else{
            
            if (SCREEN_WIDTH == 320) {
                bodyTableView.frame =  CGRectMake(-0.01, headview.y + headview.height, scrollViewForShowData.contentSize.width, self.height - headview.height - 120* SCREEN_H_SP - 40 * SCREEN_H_SP - 35 * SCREEN_H_SP-64);
            }
            else if(SCREEN_WIDTH == 414){
                bodyTableView.frame =  CGRectMake(-0.01, headview.y + headview.height, scrollViewForShowData.contentSize.width, self.height - headview.height - 120* SCREEN_H_SP - 40 * SCREEN_H_SP - 35 * SCREEN_H_SP-64);
            }
            else{
                bodyTableView.frame =  CGRectMake(-0.01, headview.y + headview.height, scrollViewForShowData.contentSize.width, self.height - headview.height - _bigview.height - 40 * SCREEN_H_SP - 35 * SCREEN_H_SP-64- 120* SCREEN_H_SP);
            }
            
        }
        
        
        bodyTableView.delegate = self;
        bodyTableView.dataSource = self;
        bodyTableView.bounces = YES;
        bodyTableView.showsVerticalScrollIndicator = NO;
        bodyTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        bodyTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 10 *SCREEN_W_SP);
        [scrollViewForShowData addSubview:bodyTableView];
        [bodyTableView registerClass:[TableViewCellForGuideData class] forCellReuseIdentifier:@"TableViewCellForGuideData"];
        
        // [bodyTableView addHeaderWithTarget:self action:@selector(addHeaderRefresh)];
        
        [twoAnimationView  removeFromSuperview];
        twoAnimationView  = nil;
        
        twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -83, SCREEN_WIDTH, 100)];
        
        twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [twoAnimationView Animation];
        
        [twoAnimationView  Animation1];
        
        [bodyTableView addSubview:twoAnimationView];
        
        [bodyTableView addFooterWithTarget:self action:@selector(addFooterRefresh)];
        //  [self addRefresh];
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
    
    }
    
}

#pragma mark - 添加上拉加载更多
-(void)addFooterRefresh{
    
    @try {
     
        _isLoadMore = YES;
        
        //假设下面的方法是网络请求返回后调用的代码
        if (_indexOfPageNum == 1) {
            [dataSourceArray removeAllObjects];
        }
        
        orgCode = _shoppingCodeArray[_subHeadBarIndex];
        
        [self request0602];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)tap{
    
    [self.tfText resignFirstResponder];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    @try {
     
        return dataSourceArray.count;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
     
        TableViewCellForGuideData *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForGuideData"];
        
        if(indexPath.row == 0) {
            
            cell.FirstLabel.backgroundColor = Color(177, 36, 44);
            cell.FirstLabel.textColor = [UIColor whiteColor];
            cell.FirstLabel.frame = CGRectMake(25 * SCREEN_W_SP, cell.height / 2 - 10 * SCREEN_H_SP, 20, 20);
            cell.FirstLabel.layer.cornerRadius = cell.FirstLabel.height / 2;
            
        }else if(indexPath.row == 1){
            
            cell.FirstLabel.backgroundColor = Color(255, 108, 42);
            cell.FirstLabel.textColor = [UIColor whiteColor];
            cell.FirstLabel.frame = CGRectMake(25 * SCREEN_W_SP, cell.height / 2 - 10 * SCREEN_H_SP, 20, 20);
            cell.FirstLabel.layer.cornerRadius = cell.FirstLabel.height / 2;
        }else if (indexPath.row == 2){
            
            cell.FirstLabel.backgroundColor = Color(255, 164, 36);
            cell.FirstLabel.textColor = [UIColor whiteColor];
            cell.FirstLabel.frame = CGRectMake(25 * SCREEN_W_SP, cell.height / 2 - 10 * SCREEN_H_SP, 20 , 20);
            cell.FirstLabel.layer.cornerRadius = cell.FirstLabel.height / 2;
        }else{
            
            cell.FirstLabel.textColor = Color(123, 123, 123); //第四行及以下
            cell.FirstLabel.backgroundColor = [UIColor clearColor];
            
            if (SCREEN_WIDTH > 414) {
                cell.FirstLabel.frame = CGRectMake(20 * SCREEN_W_SP, cell.height / 2 - 10 * SCREEN_H_SP, 34, 20);
            }
            else{
                cell.FirstLabel.frame = CGRectMake(18 * SCREEN_W_SP, cell.height / 2 - 10 * SCREEN_H_SP, 34, 20);
            }
            
            cell.FirstLabel.layer.cornerRadius = cell.FirstLabel.height / 2;
            
        }
        cell.FirstLabel.clipsToBounds = YES;
        
        cell.FirstLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1]; //第一列
        cell.SecondLabel.text = dataSourceArray[indexPath.row][@"value"][0]; //第二列
        cell.ThirdLabel.text = dataSourceArray[indexPath.row][@"value"][1]; //第三列
        cell.FourthLabel.text = dataSourceArray[indexPath.row][@"value"][2]; //第四列
        //    cell.FourthLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.CollectButton.frame = CGRectMake(tableView.width - 90 * SCREEN_W_SP, 0, 80 * SCREEN_W_SP, cell.height);//收藏列
        
        //    favoriteCode = favoriteCodeArray[indexPath.row];
        
        if (indexForRankOrCollect == 1) {
            
            if ([favoriteCodeArray[indexPath.row] isEqualToString:@"0"]) {
                
                [cell.CollectButton setTitle:@"收藏" forState:UIControlStateNormal];
                [cell.CollectButton setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
                
            }else{
                
                [cell.CollectButton setTitle:@"已收藏" forState:UIControlStateNormal];
                [cell.CollectButton setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                cell.CollectButton.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
                
            }
            
        } else {
            
            [cell.CollectButton setTitle:@"取消收藏" forState:UIControlStateNormal];
            [cell.CollectButton setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            
        }
        
        [cell.CollectButton addTarget:self action:@selector(favoriteButtonDidTouched:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 点击cell跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
     
        if (_shoppingGuideKeyBoradBool == YES) {
            [_tfText resignFirstResponder];
            _tfText.text = @"";
            _shoppingGuideTouchSeachBool = NO;
            return;
        }
        
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView]; //关闭左侧抽屉
        
        GuideDetailViewController *detail = [GuideDetailViewController new];
        detail.dimCode = dataSourceArray[indexPath.row][@"code"][0];
        detail.dimName = dataSourceArray[indexPath.row][@"value"][0];
        detail.dimStoreName = dataSourceArray[indexPath.row][@"value"][1];
        detail.dimBrandName = orgName;
        
        [tempAppDelegate.mainNavigationController pushViewController:detail animated:YES];
        
    } @catch (NSException *exception) {
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 找到点击的收藏按钮或者取消收藏按钮所在的indexPath
- (NSIndexPath *)findIndexPathForButtonOnCell:(UIButton *)button classOfCell:(Class)class tableView:(UITableView *)tableView {
    
    @try {
     
        NSIndexPath * indexPathOfClickedButton;
        
        for(UIView *next = [button superview]; next; next = next.superview) {
            
            if ([[next nextResponder] isKindOfClass:class]) {
                
                indexPathOfClickedButton = [tableView indexPathForCell:(UITableViewCell *)[next nextResponder]];
                break;
            }
            
        }
        
        return indexPathOfClickedButton;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 收藏按钮点击事件
- (void)favoriteButtonDidTouched:(UIButton *)button {
    
    @try {

        if (![[button titleLabel].text isEqualToString:@"已收藏"] && [bodyTableView visibleCells].count > 0) {
            
            NSString *emp = [NSString new];
            NSString *dimCode;
            NSString *storeCode;
            NSString *favoriteCode = indexForRankOrCollect == 1 ? @"0" : @"1";
            
            if ([button.titleLabel.text containsString:@"全部"]) {
                
                for (int i= 0; i < dataSourceArray.count; i++) {
                    
                    dimCode = dataSourceArray[i][@"code"][0];
                    storeCode = dataSourceArray[i][@"code"][1];
                    emp = i != dataSourceArray.count - 1 ? [emp stringByAppendingString:[storeCode stringByAppendingFormat:@"%@%@%@", @"@~#", dimCode, @","]] : [emp stringByAppendingString:[storeCode stringByAppendingFormat:@"%@%@", @"@~#", dimCode]];
                    
                }
                
            } else {
                
                NSIndexPath * indexPath = [self findIndexPathForButtonOnCell:button classOfCell:[TableViewCellForGuideData class] tableView:bodyTableView];
                
                if (indexPath != nil) {
                    
                    dimCode = dataSourceArray[indexPath.row][@"code"][0];
                    storeCode = dataSourceArray[indexPath.row][@"code"][1];
                    emp = [storeCode stringByAppendingFormat:@"%@%@", @"@~#", dimCode];
                    
                }
                
            }
            
            
            [self request0604:emp clickedButton:button favoriteCode:favoriteCode];
            
            
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 确定取消
-(void)confirmCancelFrameWith:(UIButton *)button withEmp_array:(NSString *)emp andFavoriteCode:(NSString *)favoriteCode{

    @try {
     
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"是否取消收藏？"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              //请求接口
                                                              [self request0604:emp clickedButton:button favoriteCode:favoriteCode];
                                                              
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              
                                                          }]];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}


#pragma mark - 0604接口请求
- (void)request0604:(NSString *)emp_array clickedButton:(UIButton *)button favoriteCode:(NSString *)favoriteCode {
    
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          
                                          [AppDatas sharedDatas].userCode, @"user_code",
                                          emp_array, @"emp_array",
                                          favoriteCode, @"favorite_code",
                                          nil];
                
                
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.EmpFavorite"
                            dataParameters:dataDic                   withCache:YES success:^(NSDictionary *responseDic) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                        [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                        
                                        [self favoriteButtonEndTouched:button];
                                        
                                    }else{
                                        
                                        [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                    }
                                });
                            } failure:^(NSError *error) {
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                    
                                    if (error.code == -1001) {
                                        
                                        [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                        
                                        
                                    }
                                    if(error.code == -1011){
                                        
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

- (void)favoriteButtonEndTouched:(UIButton *)button {
    
    @try {
     
        if (indexForRankOrCollect == 1) {
            
            if ([button.titleLabel.text isEqualToString:@"全部收藏"]) {
                
                for (int i= 0; i < dataSourceArray.count; i++) {
                    
                    
                    favoriteCodeArray[i] = @"1";
                    
                }
                
            } else {
                
                NSIndexPath *indexPath = [self findIndexPathForButtonOnCell:button classOfCell:[TableViewCellForGuideData class] tableView:bodyTableView];
                
                if (indexPath != nil) {
                    
                    [favoriteCodeArray setObject:@"1" atIndexedSubscript:indexPath.row];
                    [button setTitle:@"已收藏" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                    button.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
                    
                }
                
            }
            
            [bodyTableView reloadData];
            
        } else {
            
            NSMutableArray<NSIndexPath *> *array = [NSMutableArray new];
            
            if ([button.titleLabel.text isEqualToString:@"全部取消"]) {
                
                for (int i = 0; i < dataSourceArray.count; i++) {
                    
                    [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                }
                
                [dataSourceArray removeAllObjects];
                [favoriteCodeArray removeAllObjects];
                
            } else {
                
                NSIndexPath * indexPath = [self findIndexPathForButtonOnCell:button classOfCell:[TableViewCellForGuideData class] tableView:bodyTableView];
                
                if (indexPath != nil) {
                    
                    [dataSourceArray removeObjectAtIndex:indexPath.row];
                    [favoriteCodeArray removeObjectAtIndex:indexPath.row];
                    [array addObject:indexPath];
                    
                }
                
            }
            
            [bodyTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 结束拖拽_scrollViewForShowData

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    @try {
     
        if (scrollView == scrollViewForShowData) {
            
            //        scrollViewForShowData.backgroundColor = [UIColor orangeColor];
            
            //像素的偏移量处于按钮中心
            scrollView.contentOffset.x > 50 * SCREEN_W_SP ? [scrollView setContentOffset:CGPointMake(80 * SCREEN_W_SP, 0) animated:YES] : [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 搜索框
- (UITextField *)tfText {
    
    @try {
       
        if (!_tfText) {
            self.tfText = [[UITextField alloc]initWithFrame:CGRectZero];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_H_SP, 30 *SCREEN_H_SP)];
            button.adjustsImageWhenHighlighted = NO;
            [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
            self.tfText.leftView = button;
            self.tfText.leftViewMode = UITextFieldViewModeAlways;
            self.tfText.placeholder =[NSString stringWithFormat:@""];
            self.tfText.clearButtonMode = UITextFieldViewModeAlways;
            self.tfText.delegate =self;
            self.tfText.borderStyle = UITextBorderStyleRoundedRect;
            self.tfText.returnKeyType = UIReturnKeySearch;
        }
        
        return _tfText;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


#pragma mark - 点击Return键的时候，（标志着编辑已经结束了）

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    @try {

        [textField resignFirstResponder];
        _shoppingGuideTouchSeachBool = YES;
        _isLoadMore = NO;
        
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0602];
        
        return YES;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 点击清空按钮
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    @try {
        
        _shoppingGuideTouchSeachBool = NO;
        _indexOfPageNum = 1;
        _isLoadMore = NO;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [_tfText resignFirstResponder];
        _tfText.text = @"";
        [self request0602];
        return YES;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 排行－－收藏夹

- (void)piecewiseView:(SegmentView *)piecewiseView index:(NSInteger)index {

    @try {
     
        indexForRankOrCollect = index + 1;
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        switch (index) {
                
            case 0: //排行
                
                [collectAll setTitle:@"全部收藏" forState:UIControlStateNormal];
                break;
                
            case 1: //收藏夹
                
                [collectAll setTitle:@"全部取消" forState:UIControlStateNormal];
                break;
                
            default:
                
                break;
                
        }
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0602];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
     
        if (scrollView == scrollView1) {
            [animationView startAnimation];
        }
        else if (scrollView == bodyTableView){
            [twoAnimationView startAnimation];
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    @try {
     
        [self.tfText resignFirstResponder];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
      
        if (scrollView == scrollView1) {
            [animationView stopAnimating];
        }
        else if (scrollView == bodyTableView){
            [twoAnimationView stopAnimating];
        }
        
        
        if (scrollView1.contentOffset.y < -25 || bodyTableView.contentOffset.y < -25) {
            
            if (scrollView == scrollView1) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                
                scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                [animationView startAnimation1];
               
                _indexOfPageNum = 1;
                _isLoadMore = NO;
                [self request0602];
                
            }
            else if (scrollView == bodyTableView){
                
                 bodyTableView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                [twoAnimationView startAnimation1];
               
                _indexOfPageNum = 1;
                _isLoadMore = NO;
                [self request0602];
                
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"导购排行 DaoGouView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

@end
