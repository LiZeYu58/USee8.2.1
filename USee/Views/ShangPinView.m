//
//  ShangPinView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //  商品排行（二级页面）



#import "ShangPinView.h"
#import "BigAndTimeView.h"
#import "SegmentView.h"
#import "TableViewCellForGoodsRank.h"
#import "LeftSlideViewController.h"
#import "AppDelegate.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "LOSFMDB.h"
#import "FourDetailViewController.h"
#import "LeftSortsViewController.h"
#import "MJRefresh.h"

#import "UIImageView+WebCache.h"

#import "AnimationView.h"



#define colorText Color(123, 123, 123)

@interface ShangPinView ()<SegmentViewDelegate,BigAndTimeViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource, LeftSortsViewControllerDelegate,goodsViewControllDelegate,UITextFieldDelegate>
{
    
    NSInteger _portIndex;
    
    UIScrollView *_scrollView;
    UITableView *_rankTableView;
    NSMutableArray *_rankDataSourceArray;

    NSMutableArray * _goodsUpTriangleButtonArray;
    NSMutableArray * _goodsDownTriangleButtonArray;
    
    CGFloat _cellHeight;
    
    BigAndTimeView * _bigview;
    
    BOOL _isStartOnZero;
    float _startPanX;
    BOOL _isStartedPanThrough;
    
    NSInteger _indexTitle;
    NSInteger _indexRankOrCollect;
    NSInteger _indexSubheadbar;
    NSInteger _indexDayWeekMonthYear;
    NSInteger _indexPath;
    NSInteger _indexOfLeftSideBar;
    NSInteger _indexOfPageNum;
    NSInteger _goodsRecordIndexOfPageNum;
    
    NSInteger _selectTabarGoods;
    
    NSInteger _singleBtnTag;
    
    NSInteger _goodsDrill_type;
    
    NSInteger _goodsOneW;
    NSInteger _goodsTwoW;
    
    BOOL isLoadMOre;
    BOOL _keyBoradBool;
    BOOL _touchSeachBool;
    
    UIScrollView * scrollView1;
    
    NSInteger firstCreate;
    
    AnimationView * animationView;
    
    TwoAnimationView * twoAnimationView;
    BOOL _titleIsChanged;
    
    
    UIView *rankView;
    UIView *rankheadView;
    
    UIButton * _drillUpButton;
    UIButton * _drillDownButton;
    
    NSMutableArray *favoriteCodeArray; //数据源 所有的收藏 Code
    
    NSString * _goodsCutString;
    
}
//数组
@property (nonatomic,strong)NSMutableArray *titleNameArray;
@property (nonatomic,strong)NSMutableArray *titleOrgCodeArray;
@property (nonatomic,strong)NSMutableArray *sortTitleNameArray;
@property (nonatomic,strong)NSMutableArray *subHeadNameArray;
@property (nonatomic,strong)NSMutableArray *subheadOrgCodeArray;
@property (nonatomic,strong)NSMutableArray *orderTypesArray;

//字符串
@property (nonatomic,strong)NSString *order_arrayStr;   //orderCode
@property (nonatomic,strong)NSString *titleOrgCode;
@property (nonatomic,strong)NSString *leftPiaCode;
@property (nonatomic,strong)NSString *favoriteCode;
@property (nonatomic,strong)NSString *productCode;
@property (nonatomic,strong)NSString *orderType;     //排序
@property (nonatomic,strong)NSString *orderPiCode;     //排序

//字典
@property (nonatomic,strong)NSMutableDictionary *mainDic;
@property (nonatomic,strong)NSDictionary *secondDic;
@property (nonatomic,strong)NSDictionary *collectionDic;

@property (nonatomic,strong)UITextField * tfText;

@end


@implementation ShangPinView


-(id)initWithFrame:(CGRect)frame{
    _keyBoradBool = NO;
    _touchSeachBool = NO;
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
        NSString * goodsRefreshString = [[NSUserDefaults standardUserDefaults] objectForKey:@"goodsRefresh"];
        
        if (![goodsRefreshString isEqualToString:@"a"]) {
          [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"goodsContentOffsetX"];
        }
       
        [self createUI];
        
        _goodsOneW = 1;
        _goodsTwoW = 0;
        
        firstCreate = 1;
        
        _cellHeight = 96;
        
        _goodsDrill_type = 0;
        
        _rankDataSourceArray = nil;
        _rankDataSourceArray = [NSMutableArray new];
        
        _order_arrayStr = @"";
        _titleOrgCode = @"";
        _leftPiaCode = @"";
        _orderPiCode = @"";
        _orderType = @"";
        
        _indexOfPageNum = 1;
        _indexTitle = 0;
        _indexRankOrCollect = 1;
        _indexSubheadbar = 0;
        _indexDayWeekMonthYear = 1;
        _portIndex = 0;
        _indexPath = 0;
        _indexOfLeftSideBar = 0;
        
        
#pragma mark - 键盘监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shangPinKeyboardAppear:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shangPinkeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    
    return self;
}

-(void)goodsrefreshSPView{
    
    @try {
        
        isLoadMOre = NO;
        _selectTabarGoods = 1;
        _indexOfPageNum = 1;
        _goodsDrill_type = 0;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)refreshSPViewAfterPop{
    
    @try {
        
        _RefreshSPBlock([[NSUserDefaults standardUserDefaults] objectForKey:@"DateStrBeforePush"]);
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(void)shangPinKeyboardAppear:(NSNotification *)notif{
    
    _keyBoradBool = YES;
    
}

-(void)shangPinkeyboardWillHide:(NSNotification *)notif{
    
    _keyBoradBool = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    @try {
        
        // [_bigview.tfText resignFirstResponder];
        _goodsDrill_type = 0;
        [self request0302];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)selectedLeftSideBar:(NSDictionary *)dict {
    
    @try {
        
        //  [_mainDic removeAllObjects];
        
        _goodsCutString = @"ww";
        
        _goodsDrill_type = 0;
        //   _indexSubheadbar = 0;
        //   [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"goodsContentOffsetX"];
        
        _leftPiaCode = dict[@"piaCode"];
        _indexOfLeftSideBar = [dict[@"indexOfLeftSideBar"] integerValue];
        _orderPiCode = @"";
        _orderType = @"";
        
        
        //  _selectTabarGoods = 1;
        // _titleIsChanged = NO;
        _indexOfPageNum = 1;
        isLoadMOre = NO;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 底部tableBar的切换
- (void)orgCodeToShsngPin:(NSString *)orgCode{
   
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
        [_mainDic removeAllObjects];
        
        _goodsDrill_type = 0;
        _indexSubheadbar = 0;
        
        
        _titleOrgCode = orgCode;
        _selectTabarGoods = 1;
        _titleIsChanged = NO;
        
        _indexOfPageNum = 1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"goodsContentOffsetX"];
        
        [self request0301];
        

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)receiveTitleCode:(NSString *)orgCode{
    
    @try {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"goodsContentOffsetX"];
        [_mainDic removeAllObjects];
        
        _goodsDrill_type = 0;
        _indexSubheadbar = 0;
        
        _titleOrgCode = orgCode;
        
        isLoadMOre = NO;
        
        _titleIsChanged = NO;
        
        // _selectTabarGoods = 1;
        
        _indexOfPageNum = 1;
        [self request0301];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (void)goodsRank:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {
        
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        _goodsDrill_type = 0;
        
        isLoadMOre = NO;
        //  _selectTabarGoods = 1;
        
        _indexOfPageNum = 1;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 0301接口请求
-(void)request0301{

    @try {
        
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                //subheadBar
                NSString *subhead_org_code;
                if (_mainDic.count > 0) {
                    
                    NSArray *subheadSidebarArr = _mainDic[@"data"][@"subheadSidebar"];
                    NSMutableArray *subheadCodeArr = [NSMutableArray new];
                    for (int i = 0; i < subheadSidebarArr.count; i ++) {
                        
                        [subheadCodeArr addObject:subheadSidebarArr[i][@"code"]];
                    }
                    
                    subhead_org_code = subheadCodeArr[_indexSubheadbar];
                }else{
                    
                    subhead_org_code = _titleOrgCode;
                }
                if (_titleIsChanged) {
                    subhead_org_code = _titleOrgCode;
                }
                
                
                NSString *tabs_code = [NSString stringWithFormat:@"%ld",(long)_indexRankOrCollect];    //需根据用户操作轨迹确定
                NSString *orderPir = @"";     //需根据用户操作轨迹确定
                NSString *orderCode = @"";
                NSString *pageSize = @"";
                NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_indexOfPageNum];
                
                NSString *time_level = [NSString stringWithFormat:@"%ld",(long)_indexDayWeekMonthYear];   //需根据用户操作轨迹确定
                NSDictionary  *  datadic  =  [NSDictionary dictionaryWithObjectsAndKeys:
                                              
                                              [AppDatas sharedDatas].userCode,@"user_code",
                                              _titleOrgCode,@"title_org_code",
                                              subhead_org_code,@"subhead_org_code",
                                              tabs_code,@"tabs_code",
                                              
                                              _leftPiaCode,@"pia_code",
                                              
                                              orderPir,@"order_pir",
                                              orderCode,@"order_code",
                                              
                                              pageSize,@"page_size",
                                              pageNum,@"page_num",
                                              
                                              [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd,@"start_date",
                                              [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd,@"end_date",
                                              
                                              time_level,@"time_level"
                                              
                                              , nil];
                [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.ProductBoardSortAccess"
                            dataParameters:datadic    withCache:YES
                                   success:^(NSDictionary *responseDic) {
                                       
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                               
                                               self.mainDic = [[NSMutableDictionary alloc]initWithDictionary:responseDic];
                                               
                                               //        footer.hidden = NO;
                                               
                                               [UIView animateWithDuration:.4 animations:^{
                                                   
                                                   
                                                   [animationView stopAnimating1];
                                                   
                                                   scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                   
                                               }];
                                               
                                               
                                               [self refreshViewAndDatas];
                                               
                                               
                                           }else{
                                               
                                               
                                           }
                                           
                                           
                                           _indexOfPageNum ++;
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
                _titleIsChanged = NO;
            });
            
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }

        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 主页面创建
-(void)createUI{
    
    @try {
        
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, self.height)];
        }
        else{
            scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.height)];
        }
        scrollView1.showsVerticalScrollIndicator = NO;
        scrollView1.userInteractionEnabled = YES;
        scrollView1.delegate =self;
        scrollView1.contentSize = CGSizeMake(0, self.height);
        
        scrollView1.alwaysBounceVertical = YES;
        [self addSubview:scrollView1];
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -90, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        [_bigview removeFromSuperview];
        _bigview = nil;
        //subheadBar ＋ 日周月年 ＋ 搜索框
        _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
        _bigview.delegate =self;
        _bigview.checkUserType = YES;
        NSArray *array = @[@"",@"",@"",@""];
        
        NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
        [_bigview showBigAndTimeView:array WithState:NO Withplaceholder:@"编号／店名" WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubheadbar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:2];
        [scrollView1 addSubview:_bigview];
        [_bigview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subHeadSideBarTap:)]];
        
        [self.tfText removeFromSuperview];
        self.tfText = nil;
        
        self.tfText = [[UITextField alloc]initWithFrame:CGRectZero];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_W_SP, 30 *SCREEN_H_SP)];
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
        self.tfText.leftView = button;
        self.tfText.leftViewMode = UITextFieldViewModeAlways;
        
        self.tfText.placeholder =[NSString stringWithFormat:@""];
        self.tfText.delegate =self;
        self.tfText.borderStyle = UITextBorderStyleRoundedRect;
        self.tfText.returnKeyType = UIReturnKeySearch;
        
        if (SCREEN_WIDTH == 320) {
            self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        else{
            self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        
        self.tfText.clearButtonMode = UITextFieldViewModeAlways;
        
        self.tfText.placeholder = @"编号／店名";
        
        [scrollView1 addSubview:self.tfText];
        
        [_drillUpButton removeFromSuperview];
        _drillUpButton = nil;
        
        _drillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _drillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_drillUpButton];
        
        if (SCREEN_WIDTH == 320) {
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        else{
            _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
        }
        
        _drillUpButton.hidden = YES;
        [_drillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
        _drillUpButton.layer.masksToBounds = YES;
        _drillUpButton.layer.cornerRadius = 5;
        [_drillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        _drillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_drillUpButton addTarget:self action:@selector(goodsDrillUpTouchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_drillDownButton removeFromSuperview];
        _drillDownButton = nil;
        
        _drillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        _drillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
        [scrollView1 addSubview:_drillDownButton];
        _drillDownButton.hidden = YES;
        [_drillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
        
        if (SCREEN_WIDTH == 320) {
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        else{
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
        }
        
        [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
        _drillDownButton.layer.masksToBounds = YES;
        _drillDownButton.layer.cornerRadius = 5;
        _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_drillDownButton addTarget:self action:@selector(goodsDrillDownTouchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_scrollView  removeFromSuperview];
        _scrollView  = nil;
        //scrollView（左滑出收藏栏）
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(-0.01, _bigview.y + _bigview.height + 10 *SCREEN_H_SP , SCREEN_WIDTH - 10, SCREEN_HEIGHT - (40 + 110 + 90) *SCREEN_H_SP - 64);
        
        if (SCREEN_WIDTH > 414) {
            
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 320, SCREEN_HEIGHT - (40 + 110 + 90 ) *SCREEN_H_SP - 64);
        }
        else{
            
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + 100, SCREEN_HEIGHT - (40 + 110 + 90 ) *SCREEN_H_SP - 64);
        }
        
        _scrollView.delegate =self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [scrollView1 addSubview:_scrollView];
        [_scrollView.panGestureRecognizer addTarget:self action:@selector(testPan:)];
        
        //排行view
        [rankView  removeFromSuperview];
        rankView = nil;
        
        rankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
        rankView.backgroundColor = [UIColor whiteColor];
        [_scrollView addSubview:rankView];
        
        //headview ＋ tableView
        [self createHeadviewAndRankTableView];
        
        //排行＋收藏夹
        NSArray *arrar = [NSArray arrayWithObjects:@"排行",@"收藏夹", nil];
        SegmentView *piecew;
        if (SCREEN_HEIGHT == 812) {
            piecew = [[SegmentView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - 40*SCREEN_H_SP+14, SCREEN_WIDTH, 40*SCREEN_H_SP)];
        }
        else{
            piecew = [[SegmentView alloc]initWithFrame:CGRectMake(0,self.frame.size.height - 40*SCREEN_H_SP, SCREEN_WIDTH, 40*SCREEN_H_SP)];
        }
        piecew.backgroundColor = [UIColor whiteColor];
        piecew.delegate = self;
        piecew.textFont = [UIFont systemFontOfSize:14];
        piecew.textNormalColor = [UIColor grayColor];
        piecew.textSeletedColor = [UIColor  colorWithHex:0xba2932];
        piecew.linColor = [UIColor  colorWithHex:0xba2932];
        [piecew loadTitleArray:arrar];
        [self addSubview:piecew];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 点击上钻按钮
-(void)goodsDrillUpTouchButton{
    
    @try {
        
        _goodsDrill_type = 1;
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _touchSeachBool = NO;
        }
        
        if (_keyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_touchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        _indexOfPageNum = 1;
        
        isLoadMOre = NO;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0302];   
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 点击下钻按钮
-(void)goodsDrillDownTouchButton{
    
    @try {
        _goodsDrill_type = 2;
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _touchSeachBool = NO;
        }
        
        if (_keyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_touchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        _indexOfPageNum = 1;
        
        isLoadMOre = NO;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0302];
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - headview ＋ tableView
-(void)createHeadviewAndRankTableView{
   
    @try {
        
        [rankheadView removeAllSubviews];
        
        _goodsCutString = @"ww";
        
        _goodsUpTriangleButtonArray = nil;
        _goodsDownTriangleButtonArray = nil;
        
        _goodsUpTriangleButtonArray = [[NSMutableArray alloc] init];
        
        _goodsDownTriangleButtonArray = [[NSMutableArray alloc] init];
        
        //rankheadView
        rankheadView = [[UIView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, _scrollView.contentSize.width - 10 *SCREEN_W_SP, 50  *SCREEN_H_SP)];
        rankheadView.backgroundColor = Color(238, 238, 238);
        rankheadView.tag = 2000;
        [rankView addSubview:rankheadView];
        [rankheadView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rankheadView:)]];
        
        //1、排行序列
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, (rankheadView.width - 100 * SCREEN_W_SP) / 6, rankheadView.height)];
        rankLabel.text = @"排行";
        rankLabel.textColor = colorText;
        rankLabel.font = [UIFont systemFontOfSize:14];
        rankLabel.textAlignment = NSTextAlignmentLeft;
        [rankheadView addSubview:rankLabel];
        
        //2、商品
        UILabel *goodsLabel = [[UILabel alloc]init];
        
        if (SCREEN_WIDTH > 414) {
            goodsLabel.frame = CGRectMake((rankheadView.width ) / 6, 0, (rankheadView.width - 120 * SCREEN_W_SP) / 6, rankheadView.height);
        }
        else{
            goodsLabel.frame = CGRectMake((rankheadView.width - 102 * SCREEN_W_SP) / 6, 0, (rankheadView.width - 100 * SCREEN_W_SP) / 6, rankheadView.height);
        }
        
        
        goodsLabel.text = @"商品";
        goodsLabel.textColor = colorText;
        goodsLabel.font = [UIFont systemFontOfSize:14];
        goodsLabel.textAlignment = NSTextAlignmentCenter;
        [rankheadView addSubview:goodsLabel];
        
        //排序指标
        if (_mainDic) {
            
            NSArray *sortTitleArray = _mainDic[@"data"][@"sortTitle"];
            for (int i = 0; i < sortTitleArray.count; i ++) {   //根据接口返回数据里的sortTitle的个数判断
                
                if ([sortTitleArray[i][@"orderType"] isEqualToString:@"D"]) {
                    
                    UIButton *upTriangle = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        upTriangle.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 *SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    else{
                        upTriangle.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 *SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    
                    upTriangle.tag = 500 + i;
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    [rankheadView addSubview:upTriangle];
                    
                    
                    UIButton *downTriangle = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        downTriangle.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    else{
                        downTriangle.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    UIButton *cutBtn = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        cutBtn.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height);
                        
                    }
                    else{
                        cutBtn.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height);
                    }
                    
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    
                    if (i == 0) {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                        [cutBtn setSelected:YES];
                        
                    }
                    
                    [_goodsUpTriangleButtonArray addObject:upTriangle];
                    [_goodsDownTriangleButtonArray addObject:downTriangle];
                    
                    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [rankheadView addSubview:cutBtn];
                    
                }else if ([sortTitleArray[i][@"orderType"] isEqualToString:@"A"]){
                    
                    UIButton *upTriangle = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3)];
                    upTriangle.tag = 500 + i;
                    
                    
                    if (i == 0) {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                        
                    }
                    
                    [rankheadView addSubview:upTriangle];
                    UIButton *downTriangle = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3)];
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height)];
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    [cutBtn setSelected:YES];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_goodsUpTriangleButtonArray addObject:upTriangle];
                    [_goodsDownTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }
            }
            
        }
        
        
        
        //7、收藏（全部收藏／全部取消）
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        collectionBtn.frame = CGRectMake(rankheadView.width - 80 * SCREEN_W_SP, rankheadView.height / 4, 70 * SCREEN_W_SP, rankheadView.height / 2);
        
        
        collectionBtn.tag = 1010;
        collectionBtn.layer.cornerRadius = 5;
        collectionBtn.layer.borderColor = Color(158, 32, 39).CGColor;
        collectionBtn.layer.borderWidth = 1;
        if (_indexRankOrCollect == 1) {
            [collectionBtn setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else{
            [collectionBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        [collectionBtn setTitleColor:Color(158, 32, 39) forState:UIControlStateNormal];
        collectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        collectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rankheadView addSubview:collectionBtn];
        
        //增大全部收藏按钮的响应空间
        UIView *allCollectView = [[UIView alloc]initWithFrame:CGRectMake(collectionBtn.x, 0, collectionBtn.width, rankheadView.height)];
        [allCollectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allCollectionViewTap:)]];
        [rankheadView addSubview:allCollectView];
        
        
        //排行tableView
        [_rankTableView  removeFromSuperview];
        _rankTableView = nil;
        
        if (SCREEN_HEIGHT == 812) {
             _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake( - 4, rankheadView.y + rankheadView.height -0.1, _scrollView.contentSize.width + 4, rankView.height - rankheadView.height - 50) style:UITableViewStylePlain];
        }
        else{
             _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake( - 4, rankheadView.y + rankheadView.height -0.1, _scrollView.contentSize.width + 4, rankView.height - rankheadView.height) style:UITableViewStylePlain];
        }
        
        _rankTableView.backgroundColor = [UIColor whiteColor];
        _rankTableView.bounces = YES;
        _rankTableView.delegate = self;
        _rankTableView.dataSource = self;
        _rankTableView.rowHeight = _cellHeight *SCREEN_H_SP;
        _rankTableView.showsVerticalScrollIndicator = NO;
        _rankTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_rankTableView registerClass:[TableViewCellForGoodsRank class] forCellReuseIdentifier:@"GoodsRankTableViewCell"];
        
        [rankView addSubview:_rankTableView];
        
        [twoAnimationView  removeFromSuperview];
        twoAnimationView = nil;
        
        twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -83, SCREEN_WIDTH, 100)];
        
        twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
        
        [twoAnimationView Animation];
        
        [twoAnimationView Animation1];
        
        [_rankTableView addSubview:twoAnimationView];
        
        
        [_rankTableView addFooterWithTarget:self action:@selector(addFooterRefresh)];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - headview ＋ tableView
-(void)createTwoHeadviewAndRankTableView{
    
    @try {
        
        //排行view
        [rankheadView removeAllSubviews];
        
        _goodsUpTriangleButtonArray = nil;
        _goodsDownTriangleButtonArray = nil;
        
        _goodsUpTriangleButtonArray = [[NSMutableArray alloc] init];
        
        _goodsDownTriangleButtonArray = [[NSMutableArray alloc] init];
        
        _goodsCutString = @"ww";
        //rankheadView
        rankheadView = [[UIView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, _scrollView.contentSize.width - 10 *SCREEN_W_SP, 50  *SCREEN_H_SP)];
        rankheadView.backgroundColor = Color(238, 238, 238);
        rankheadView.tag = 2000;
        [rankView addSubview:rankheadView];
        [rankheadView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rankheadView:)]];
        
        //1、排行序列
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, (rankheadView.width - 100 * SCREEN_W_SP) / 6, rankheadView.height)];
        rankLabel.text = @"排行";
        rankLabel.textColor = colorText;
        rankLabel.font = [UIFont systemFontOfSize:14];
        rankLabel.textAlignment = NSTextAlignmentLeft;
        [rankheadView addSubview:rankLabel];
        
        //2、商品
        UILabel *goodsLabel = [[UILabel alloc]init];
        
        if (SCREEN_WIDTH > 414) {
            goodsLabel.frame = CGRectMake((rankheadView.width ) / 6, 0, (rankheadView.width - 120 * SCREEN_W_SP) / 6, rankheadView.height);
        }
        else{
            goodsLabel.frame = CGRectMake((rankheadView.width - 102 * SCREEN_W_SP) / 6, 0, (rankheadView.width - 100 * SCREEN_W_SP) / 6, rankheadView.height);
        }
        
        
        goodsLabel.text = @"商品";
        goodsLabel.textColor = colorText;
        goodsLabel.font = [UIFont systemFontOfSize:14];
        goodsLabel.textAlignment = NSTextAlignmentCenter;
        [rankheadView addSubview:goodsLabel];
        
        //排序指标
        if (_mainDic) {
            
            NSArray *sortTitleArray = _mainDic[@"data"][@"sortTitle"];
            for (int i = 0; i < sortTitleArray.count; i ++) {   //根据接口返回数据里的sortTitle的个数判断
                
                if ([sortTitleArray[i][@"orderType"] isEqualToString:@"D"]) {
                    
                    UIButton *upTriangle = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        upTriangle.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 *SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    else{
                        upTriangle.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 *SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    
                    upTriangle.tag = 500 + i;
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    [rankheadView addSubview:upTriangle];
                    
                    
                    UIButton *downTriangle = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        downTriangle.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    else{
                        downTriangle.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3);
                    }
                    
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    UIButton *cutBtn = [[UIButton alloc]init];
                    
                    if (SCREEN_WIDTH > 414) {
                        cutBtn.frame = CGRectMake((rankheadView.width - 140* SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height);
                        
                    }
                    else{
                        cutBtn.frame = CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height);
                    }
                    
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    
                    if (i == 0) {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                        [cutBtn setSelected:YES];
                        
                    }
                    
                    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_goodsUpTriangleButtonArray addObject:upTriangle];
                    [_goodsDownTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }else if ([sortTitleArray[i][@"orderType"] isEqualToString:@"A"]){
                    
                    UIButton *upTriangle = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3)];
                    upTriangle.tag = 500 + i;
                    
                    
                    if (i == 0) {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                        
                    }
                    
                    [rankheadView addSubview:upTriangle];
                    UIButton *downTriangle = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, rankheadView.height * 2 / 3, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height / 3)];
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake((rankheadView.width - 100 * SCREEN_W_SP) / 3 + (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count * i, 0, (rankheadView.width - 100 * SCREEN_W_SP) * 2 / 3 / sortTitleArray.count, rankheadView.height)];
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    [cutBtn setSelected:YES];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(cutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [_goodsUpTriangleButtonArray addObject:upTriangle];
                    [_goodsDownTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }
            }
            
        }
        
        
        
        //7、收藏（全部收藏／全部取消）
        UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        collectionBtn.frame = CGRectMake(rankheadView.width - 80 * SCREEN_W_SP, rankheadView.height / 4, 70 * SCREEN_W_SP, rankheadView.height / 2);
        
        
        collectionBtn.tag = 1010;
        collectionBtn.layer.cornerRadius = 5;
        collectionBtn.layer.borderColor = Color(158, 32, 39).CGColor;
        collectionBtn.layer.borderWidth = 1;
        if (_indexRankOrCollect == 1) {
            [collectionBtn setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else{
            [collectionBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        [collectionBtn setTitleColor:Color(158, 32, 39) forState:UIControlStateNormal];
        collectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        collectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [collectionBtn addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rankheadView addSubview:collectionBtn];
        
        //增大全部收藏按钮的响应空间
        UIView *allCollectView = [[UIView alloc]initWithFrame:CGRectMake(collectionBtn.x, 0, collectionBtn.width, rankheadView.height)];
        [allCollectView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allCollectionViewTap:)]];
        [rankheadView addSubview:allCollectView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)addFooterRefresh{
    
    @try {
        
        isLoadMOre = YES;
        //将_indexOfPageNum的值传给服务器
        
        //假设下面的方法是网络请求返回后调用的代码
        if (_indexOfPageNum == 1) {
            [_rankDataSourceArray removeAllObjects];
        }
        
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 刷新控件和数据
-(void)refreshViewAndDatas{
    
    @try {
        
        if (self.mainDic) {
            
            // ||
            if (_goodsDrill_type == 1) {
                
                _goodsDrill_type = 0;
                
                [_bigview removeFromSuperview];
                _bigview = nil;
                //刷新 subheadSidebar + 日周月 ＋ 搜索框
                NSMutableArray *subheadArray = [NSMutableArray new];
                NSArray *subheadSidebarArr = _mainDic[@"data"][@"subheadSidebar"];
                for (int i = 0; i < subheadSidebarArr.count; i ++) {
                    
                    [subheadArray addObject:subheadSidebarArr[i][@"name"]];
                }
                _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
                _bigview.delegate =self;
                _bigview.checkUserType = YES;
                NSString * str = [NSString stringWithFormat:@"编号／店名"];
                NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
                [_bigview showBigAndTimeView:subheadArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubheadbar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:2];
                [scrollView1 addSubview:_bigview];
                [_bigview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subHeadSideBarTap:)]];
                
                _bigview.ScrollView.contentOffset = CGPointMake(0, 0);
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"goodsContentOffsetX"];
                
                [self.tfText removeFromSuperview];
                self.tfText = nil;
                
                self.tfText = [[UITextField alloc]initWithFrame:CGRectZero];
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_W_SP, 30 *SCREEN_H_SP)];
                button.adjustsImageWhenHighlighted = NO;
                [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
                self.tfText.leftView = button;
                self.tfText.leftViewMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder =[NSString stringWithFormat:@""];
                self.tfText.delegate =self;
                self.tfText.borderStyle = UITextBorderStyleRoundedRect;
                self.tfText.returnKeyType = UIReturnKeySearch;
                
                if (SCREEN_WIDTH == 320) {
                    self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else{
                    self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                
                self.tfText.clearButtonMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder = @"编号／店名";
                
                [scrollView1 addSubview:self.tfText];
                
                [_drillUpButton removeFromSuperview];
                _drillUpButton = nil;
                
                _drillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillUpButton];
                
                if (SCREEN_WIDTH == 320) {
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else{
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                
                _drillUpButton.hidden = YES;
                [_drillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
                _drillUpButton.layer.masksToBounds = YES;
                _drillUpButton.layer.cornerRadius = 5;
                [_drillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                _drillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillUpButton addTarget:self action:@selector(goodsDrillUpTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [_drillDownButton removeFromSuperview];
                _drillDownButton = nil;
                
                _drillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillDownButton];
                _drillDownButton.hidden = YES;
                [_drillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                
                if (SCREEN_WIDTH == 320) {
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else{
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                
                [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
                _drillDownButton.layer.masksToBounds = YES;
                _drillDownButton.layer.cornerRadius = 5;
                _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillDownButton addTarget:self action:@selector(goodsDrillDownTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                if (_indexSubheadbar > 0) {
                    if (SCREEN_WIDTH == 320) {
                        self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else if (SCREEN_WIDTH > 414){
                        self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else{
                        self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    
                    _drillUpButton.hidden = NO;
                    _drillDownButton.hidden = NO;
                }
                
            }
            else if (_goodsDrill_type == 2){
                
                _goodsDrill_type = 0;
                
                [_bigview removeFromSuperview];
                _bigview = nil;
                //刷新 subheadSidebar + 日周月 ＋ 搜索框
                NSMutableArray *subheadArray = [NSMutableArray new];
                NSArray *subheadSidebarArr = _mainDic[@"data"][@"subheadSidebar"];
                for (int i = 0; i < subheadSidebarArr.count; i ++) {
                    
                    [subheadArray addObject:subheadSidebarArr[i][@"name"]];
                }
                _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
                _bigview.delegate =self;
                _bigview.checkUserType = YES;
                NSString * str = [NSString stringWithFormat:@"编号／店名"];
                NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
                [_bigview showBigAndTimeView:subheadArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubheadbar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:2];
                [scrollView1 addSubview:_bigview];
                [_bigview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subHeadSideBarTap:)]];
                
                _bigview.ScrollView.contentOffset = CGPointMake(0, 0);
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"goodsContentOffsetX"];
                
                
                [self.tfText removeFromSuperview];
                self.tfText = nil;
                
                self.tfText = [[UITextField alloc]initWithFrame:CGRectZero];
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_W_SP, 30 *SCREEN_H_SP)];
                button.adjustsImageWhenHighlighted = NO;
                [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
                self.tfText.leftView = button;
                self.tfText.leftViewMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder =[NSString stringWithFormat:@""];
                self.tfText.delegate =self;
                self.tfText.borderStyle = UITextBorderStyleRoundedRect;
                self.tfText.returnKeyType = UIReturnKeySearch;
                
                if (SCREEN_WIDTH == 320) {
                    self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else{
                    self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                
                self.tfText.clearButtonMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder = @"编号／店名";
                
                [scrollView1 addSubview:self.tfText];
                
                [_drillUpButton removeFromSuperview];
                _drillUpButton = nil;
                
                _drillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillUpButton];
                
                if (SCREEN_WIDTH == 320) {
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else{
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                
                _drillUpButton.hidden = YES;
                [_drillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
                _drillUpButton.layer.masksToBounds = YES;
                _drillUpButton.layer.cornerRadius = 5;
                [_drillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                _drillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillUpButton addTarget:self action:@selector(goodsDrillUpTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [_drillDownButton removeFromSuperview];
                _drillDownButton = nil;
                
                _drillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillDownButton];
                _drillDownButton.hidden = YES;
                [_drillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                
                if (SCREEN_WIDTH == 320) {
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else{
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                
                [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
                _drillDownButton.layer.masksToBounds = YES;
                _drillDownButton.layer.cornerRadius = 5;
                _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillDownButton addTarget:self action:@selector(goodsDrillDownTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                if (_indexSubheadbar > 0) {
                    if (SCREEN_WIDTH == 320) {
                        self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else if (SCREEN_WIDTH > 414){
                        self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else{
                        self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    
                    _drillUpButton.hidden = NO;
                    _drillDownButton.hidden = NO;
                }
                
                
                
            }
            else if (_goodsDrill_type == 0){
                [_bigview removeFromSuperview];
                _bigview = nil;
                
                //刷新 subheadSidebar + 日周月 ＋ 搜索框
                NSMutableArray *subheadArray = [NSMutableArray new];
                NSArray *subheadSidebarArr = _mainDic[@"data"][@"subheadSidebar"];
                for (int i = 0; i < subheadSidebarArr.count; i ++) {
                    
                    [subheadArray addObject:subheadSidebarArr[i][@"name"]];
                }
                _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
                _bigview.delegate =self;
                _bigview.checkUserType = YES;
                NSString * str = [NSString stringWithFormat:@"编号／店名"];
                NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
                [_bigview showBigAndTimeView:subheadArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubheadbar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:2];
                [scrollView1 addSubview:_bigview];
                [_bigview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(subHeadSideBarTap:)]];
                
                NSString * goodsContentOffsetXString = [[NSUserDefaults standardUserDefaults] objectForKey:@"goodsContentOffsetX"];
                
                if (goodsContentOffsetXString.length > 0) {
                    _bigview.ScrollView.contentOffset = CGPointMake([goodsContentOffsetXString doubleValue], 0);
                }
                
                [self.tfText removeFromSuperview];
                self.tfText = nil;
                
                self.tfText = [[UITextField alloc]initWithFrame:CGRectZero];
                
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_W_SP, 30 *SCREEN_H_SP)];
                button.adjustsImageWhenHighlighted = NO;
                [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
                self.tfText.leftView = button;
                self.tfText.leftViewMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder =[NSString stringWithFormat:@""];
                self.tfText.delegate =self;
                self.tfText.borderStyle = UITextBorderStyleRoundedRect;
                self.tfText.returnKeyType = UIReturnKeySearch;
                
                if (SCREEN_WIDTH == 320) {
                    self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                else{
                    self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
                }
                
                self.tfText.clearButtonMode = UITextFieldViewModeAlways;
                
                self.tfText.placeholder = @"编号／店名";
                
                [scrollView1 addSubview:self.tfText];
                
                [_drillUpButton removeFromSuperview];
                _drillUpButton = nil;
                
                _drillUpButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillUpButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillUpButton];
                
                if (SCREEN_WIDTH == 320) {
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                else{
                    _drillUpButton.frame = CGRectMake(10+ SCREEN_WIDTH - 140 + 10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28* SCREEN_H_SP);
                }
                
                _drillUpButton.hidden = YES;
                [_drillUpButton setTitle:@"上钻" forState:UIControlStateNormal];
                _drillUpButton.layer.masksToBounds = YES;
                _drillUpButton.layer.cornerRadius = 5;
                [_drillUpButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                _drillUpButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillUpButton addTarget:self action:@selector(goodsDrillUpTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                
                [_drillDownButton removeFromSuperview];
                _drillDownButton = nil;
                
                _drillDownButton =  [UIButton buttonWithType:UIButtonTypeCustom];
                _drillDownButton.backgroundColor = [UIColor colorWithHex:0xcb2e38];
                [scrollView1 addSubview:_drillDownButton];
                _drillDownButton.hidden = YES;
                [_drillDownButton setTitleColor:[UIColor colorWithHex:0xFFFFFF] forState:UIControlStateNormal];
                
                if (SCREEN_WIDTH == 320) {
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                else{
                    _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, 50, 28*SCREEN_H_SP);
                }
                
                [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
                _drillDownButton.layer.masksToBounds = YES;
                _drillDownButton.layer.cornerRadius = 5;
                _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [_drillDownButton addTarget:self action:@selector(goodsDrillDownTouchButton) forControlEvents:UIControlEventTouchUpInside];
                
                if (_indexSubheadbar > 0) {
                    if (SCREEN_WIDTH == 320) {
                        self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else if (SCREEN_WIDTH > 414){
                        self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    else{
                        self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                    }
                    
                    _drillUpButton.hidden = NO;
                    _drillDownButton.hidden = NO;
                }
                
                [_rankTableView removeFromSuperview];
                _rankTableView = nil;
                
                //排行view
                [rankView  removeFromSuperview];
                rankView = nil;
                
                rankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.contentSize.width, _scrollView.contentSize.height)];
                rankView.backgroundColor = [UIColor whiteColor];
                [_scrollView addSubview:rankView];
                
                //刷新rankView
                [self createHeadviewAndRankTableView];
                
                
                //排行－－收藏夹:不需刷新
                
                
                //侧边栏
                NSMutableArray *nameArray = [NSMutableArray new];
                NSMutableArray *piaCodeArray = [NSMutableArray new];
                NSMutableArray *leftSidebarArr = [_mainDic[@"data"][@"leftSidebar"] mutableCopy];
                for (int i = 0; i < leftSidebarArr.count; i ++) {
                    
                    [nameArray addObject:leftSidebarArr[i][@"nameArray"]];
                    [piaCodeArray addObject:leftSidebarArr[i][@"piaCode"]];
                }
                
                NSString * indexCollect = [NSString stringWithFormat:@"%ld",(long)_indexOfLeftSideBar];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:nameArray,@"nameArray",piaCodeArray,@"piaCodeArray",indexCollect,@"indexRankOrCollect", nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ShangPinLeftSidebarNameArrayAndPiaCodeArray" object:nil userInfo:dic];
                _leftPiaCode = piaCodeArray[_indexOfLeftSideBar];
                
                //排序
                _orderType = _mainDic[@"data"][@"sortTitle"][0][@"orderType"];
                _orderPiCode = _mainDic[@"data"][@"sortTitle"][0][@"piCode"];
                
                
                
                //_rankTableView 刷新
                NSArray *dataArr = _mainDic[@"data"][@"sortList"][@"data"];
                _rankDataSourceArray = [dataArr mutableCopy];
                
                favoriteCodeArray = [NSMutableArray new];
                for (int i = 0; i < dataArr.count; i ++) {
                    
                    [favoriteCodeArray addObject:dataArr[i][@"favoriteCode"]];
                }
                
            }
            
            
        }
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
 }



-(void)rankheadView:(UITapGestureRecognizer *)tap{
    
    [self.tfText resignFirstResponder];
}


#pragma mark - _scrollView回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    @try {
        
        if (scrollView == _scrollView) {
            
            CGPoint point = scrollView.contentOffset;
            
            if (point.x > 65) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    scrollView.contentOffset = CGPointMake(110, 0);
                }];
                
            }else if (point.x <= 65) {
                
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    scrollView.contentOffset = CGPointMake(0, 0);
                }];
                
            }
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



-(void)cutBtnClick:(UIButton *)button{

    @try {
        
        [self.tfText resignFirstResponder];
        
        _goodsCutString = @"aa";
        
        
        
        //selectTag可判断用户点击的是第几个sortTitle
        NSInteger indexSelected = button.tag - 700;
        UIButton *upBtn = _goodsUpTriangleButtonArray[indexSelected];
        UIButton *downBtn = _goodsDownTriangleButtonArray[indexSelected];
        
        //  button.selected = !button.selected;
        if (indexSelected == 0) {
            
            if (_goodsTwoW > 0) {
                _goodsOneW = 0;
                _goodsTwoW = 0;
            }
            
            
            for (NSInteger i = 0; i < _goodsUpTriangleButtonArray.count; i++)
            {
                UIButton * button = _goodsUpTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
            }
            
            for (NSInteger i = 0; i < _goodsDownTriangleButtonArray.count; i++)
            {
                UIButton * button = _goodsDownTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
            }
            
            if (_goodsOneW % 2 == 0) {
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                
                _orderType = @"D";
                
            }else{
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                
                _orderType = @"A";
                
            }
            
            _goodsOneW ++;
            
            
        }else{
            
            if (_goodsOneW > 0) {
                _goodsOneW = 0;
                _goodsTwoW = 0;
            }
            
            for (NSInteger i = 0; i < _goodsUpTriangleButtonArray.count; i++)
            {
                UIButton * button = _goodsUpTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
            }
            
            for (NSInteger i = 0; i < _goodsDownTriangleButtonArray.count; i++)
            {
                UIButton * button = _goodsDownTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
            }
            
            
            if (_goodsTwoW % 2 == 0) {
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                
                _orderType = @"D";
                
            }else{
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                
                _orderType = @"A";
                
            }
            
            _goodsTwoW ++;
        }
        
        
#pragma mark - 根据点击的排序按钮orderPir,请求0302
        NSArray *orderTypeArray = _mainDic[@"data"][@"sortTitle"];
        _orderPiCode = orderTypeArray[indexSelected][@"piCode"];
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        _indexOfPageNum = 1;
        isLoadMOre = NO;
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 0302接口请求
-(void)request0302{
 
    @try {
        
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString *title_org_code = _titleOrgCode;      // title_org_code
                NSString *subhead_org_code;     // subheadBar_code
                if (_mainDic) {
                    
                    NSArray *subheadSidebarArr = _mainDic[@"data"][@"subheadSidebar"];
                    NSMutableArray *subheadCodeArr = [NSMutableArray new];
                    for (int i = 0; i < subheadSidebarArr.count; i ++) {
                        
                        [subheadCodeArr addObject:subheadSidebarArr[i][@"code"]];
                    }
                    subhead_org_code = subheadCodeArr[_indexSubheadbar];
                }else{
                    
                    subhead_org_code = _titleOrgCode;
                }
                
                NSString *tabs_code = [NSString stringWithFormat:@"%ld",(long)_indexRankOrCollect];    //排行－收藏夹
                
                //写死的假数据
                NSString *pageSize = @"";     //分页
                
                NSString *pageNum;
                if (isLoadMOre) {
                    
                    pageNum = [NSString stringWithFormat:@"%ld", (long)_indexOfPageNum];     //分页
                }else{
                    
                    pageNum = @"1";
                }
                
                
                NSString *time_level = [NSString stringWithFormat:@"%ld",(long)_indexDayWeekMonthYear];
                
                NSDictionary * numDic    = [NSDictionary dictionaryWithObjectsAndKeys:
                                            
                                            [AppDatas sharedDatas].userCode,@"user_code",
                                            title_org_code,@"title_org_code",
                                            subhead_org_code,@"subhead_org_code",
                                            
                                            tabs_code,@"tabs_code",
                                            _leftPiaCode,@"pia_code",
                                            
                                            _orderPiCode,@"order_pir",
                                            _orderType,@"order_code",
                                            
                                            pageSize,@"page_size",
                                            pageNum,@"page_num",
                                            
                                            self.tfText.text,@"search_value",
                                            
                                            [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd,@"start_date",
                                            [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd,@"end_date",
                                            time_level,@"time_level",
                                            [NSString stringWithFormat:@"%ld",(long)_goodsDrill_type],@"drill_type",
                                            nil];
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.ProductBoardSort"
                             dataParameters:numDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            [_rankTableView footerEndRefreshing];
                                            
                                            
                            [self.tfText resignFirstResponder];
                            
                           [UIView animateWithDuration:0.4 animations:^{
                               
                               scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                               _rankTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                               
                           }completion:^(BOOL finished){
                               
                               [animationView stopAnimating1];
                               [twoAnimationView stopAnimating1];

                           }];
                               
                        if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                                if ([responseDic[@"data"][@"sort"][@"data"] count] == 0 && _indexOfPageNum > 1) {
                                                    
                                [[HUDHelper getInstance]showErrorTipWithLabel:@"暂无更多商品"];
                            }
                        else{
                                                    
                        if (_goodsDrill_type == 1 || _goodsDrill_type == 2)
                        {
                        
                            if ([responseDic[@"data"][@"sort"][@"data"]count]  == 0 && [responseDic[@"data"][@"subheadSidebar"]count]  == 0)
                            {
                                                            
                            _indexOfPageNum = _goodsRecordIndexOfPageNum;
                                                            
                            _goodsDrill_type = 0;
                                                            
                            return;
                          }
                            else if([responseDic[@"data"][@"subheadSidebar"]count] > 0){

                                [self.delegate transMitheadTitle:responseDic[@"data"][@"subheadSidebar"][0][@"code"] nameString:responseDic[@"data"][@"subheadSidebar"][0][@"name"]];
                                
                            }
                            
                            _indexSubheadbar = 0;
                            
                            NSMutableDictionary * enterDic = [[NSMutableDictionary alloc] initWithDictionary:self.mainDic[@"data"]];
                                                        
                            [enterDic removeObjectForKey:@"subheadSidebar"];
                            
                            [enterDic setObject:responseDic[@"data"][@"subheadSidebar"] forKey:@"subheadSidebar"];
                                                        
                            [self.mainDic removeObjectForKey:@"data"];
                                                        
                            [self.mainDic setObject:enterDic forKey:@"data"];
                                                        
                                                        
                            [self refreshViewAndDatas];
                        }
                                                    
                        NSMutableDictionary * enterDic = [[NSMutableDictionary alloc] initWithDictionary:self.mainDic[@"data"]];
                                                    
                                                    
                        [enterDic removeObjectForKey:@"sortTitle"];
                        [enterDic setObject:responseDic[@"data"][@"sortTitle"] forKey:@"sortTitle"];
                                                    
                        [self.mainDic removeObjectForKey:@"data"];
                                                    
                        [self.mainDic setObject:enterDic forKey:@"data"];
                                                    
                        if ( [_goodsCutString isEqualToString:@"aa"]) {
                                                        
                                                        
                        }
                        else{
                        
                            [self createTwoHeadviewAndRankTableView];
                        }
                                                    
                                                    
                        self.secondDic = responseDic;
                                                    
                                                    //    footer.hidden = NO;
                                                    
                        if (isLoadMOre) {
                                                        
                            [self loadMoreDataWith:responseDic];
                                                        
                        }else{
                                                        
                        [self analysisDatasWith:responseDic];
                                                        
                        }
                                                    
                        _indexOfPageNum ++;
                        _goodsRecordIndexOfPageNum = _indexOfPageNum;
                    }
                                                
                    }
                    else{
                        if (_indexOfPageNum == 1) {
                        _rankDataSourceArray = nil;
                                                    
                                                    
                        [_rankTableView reloadData];
                }
                                                
                    [[HUDHelper getInstance]showErrorTipWithLabel:responseDic[@"msg"]];
                }
                                            
                });
                
                                    }
                failure:^(NSError *error) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                        [[HUDHelper getInstance] hideHUD];//隐藏提示框
                        
                        [UIView animateWithDuration:0.4 animations:^{
                                                
                        scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                        _rankTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                        }completion:^(BOOL finished){
                                                
                            [animationView stopAnimating1];
                            [twoAnimationView stopAnimating1];
                                                
                        }];
                                        
                        //[_rankTableView.footer endRefreshing];
                        _rankTableView.contentOffset = CGPointZero;
                                            
                        if (_indexOfPageNum == 1) {
                            
                            _rankDataSourceArray = nil;
                                                
                                                
                            [_rankTableView reloadData];
                        }
                                            
                                            
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
            
            [UIView animateWithDuration:0.4 animations:^{
                
                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                _rankTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
            }completion:^(BOOL finished){
                
                [animationView stopAnimating1];
                [twoAnimationView stopAnimating1];
                
            }];

            _rankTableView.contentOffset = CGPointZero;
            _rankDataSourceArray = nil;
            [_rankTableView reloadData];
            
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 加载更多
-(void)loadMoreDataWith:(NSDictionary *)dic{
   
    @try {
        
        NSMutableArray *nextPageArray= [dic[@"data"][@"sort"][@"data"] mutableCopy];
        
        if (nextPageArray.count == 0) {
            
            
        }else{
            
            for (int i = 0 ; i < nextPageArray.count; i ++) {
                
                [_rankDataSourceArray addObject:[nextPageArray objectAtIndex:i]];
                [favoriteCodeArray addObject:nextPageArray[i][@"favoriteCode"]];
            }
            
            
            [_rankTableView reloadData];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 解析数据
-(void)analysisDatasWith:(NSDictionary *)dic{
    
    @try {
        
        if (!dic) {
            return;
        }
        
        _rankDataSourceArray = [NSMutableArray new];
        
        _rankDataSourceArray = [dic[@"data"][@"sort"][@"data"] mutableCopy];
        
        favoriteCodeArray = [NSMutableArray new];
        
        if (_rankDataSourceArray){
            
            for (int i = 0; i < _rankDataSourceArray.count; i ++) {
                
                [favoriteCodeArray addObject:_rankDataSourceArray[i][@"favoriteCode"]];
            }
        }
        
        if (_rankDataSourceArray == nil) {
            
            _rankDataSourceArray = nil;
            favoriteCodeArray = nil;
            
            _rankDataSourceArray = [NSMutableArray new];
            favoriteCodeArray = [NSMutableArray new];
        }
        
        [self refreshTableView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 0302请求成功后，刷新数据不刷新页面
-(void)refreshTableView{
    
    @try {
        
        //页面置左
        [UIView animateWithDuration:0.2 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 0);
        }];
        
        
        //刷新数据源
        // if (_rankDataSourceArray.count > 0) {
        [_rankTableView reloadData];
        [_rankTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        // }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark - 排行、收藏按钮切换
-(void)piecewiseView:(SegmentView *)piecewiseView index:(NSInteger)index{

    @try {
        
        _goodsDrill_type = 0;
        //默认：排行1;收藏夹2
        _indexRankOrCollect = index + 1;
        
        isLoadMOre = NO;
        
        UIButton *collectButton = (UIButton *)[self viewWithTag:1010];
        if (_indexRankOrCollect == 1) {
            
            [collectButton setTitle:@"全部收藏" forState:UIControlStateNormal];
            
            
        }else if (_indexRankOrCollect == 2){
            
            [collectButton setTitle:@"全部取消" forState:UIControlStateNormal];
            
        }
        
        _indexOfPageNum = 1;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - subHeadBar 按钮切换
- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index
{
    
    @try {
     
        _goodsDrill_type = 0;
        
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _touchSeachBool = NO;
        }
        
        if (_keyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_touchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        if (index == 0) {
            
            if (SCREEN_WIDTH == 320) {
                self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            else if (SCREEN_WIDTH > 414){
                self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            else{
                self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
            }
            
            _drillUpButton.hidden = YES;
            _drillDownButton.hidden = YES;
        }
        else if (index > 0){
            
            if (SCREEN_WIDTH == 320) {
                self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }
            else if (SCREEN_WIDTH > 414){
                self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }
            else{
                self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
            }
            
            _drillUpButton.hidden = NO;
            _drillDownButton.hidden = NO;
            
        }
        
        _indexOfPageNum = 1;
        _indexSubheadbar = index;
        
        isLoadMOre = NO;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 日周月年 切换
-(void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index
{
    
    @try {
        
        _goodsDrill_type = 0;
        
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _touchSeachBool = NO;
        }
        
        if (_keyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_touchSeachBool == NO) {
            self.tfText.text = @"";
        }
        _indexOfPageNum = 1;
        
        _indexDayWeekMonthYear = index + 1;
        
        isLoadMOre = NO;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 搜索框
#pragma mark - 点击Return键的时候，（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    @try {
        
        [textField resignFirstResponder];
        
        _touchSeachBool = YES;
        
        isLoadMOre = NO;
        _indexOfPageNum = 1;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request0302];
        return YES;
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    @try {
        
        _touchSeachBool = NO;
        _indexOfPageNum = 1;
        isLoadMOre = NO;
        // [_bigview.tfText resignFirstResponder];
        self.tfText.text = @"";
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request0302];
        
        return YES;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark -
#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (_rankDataSourceArray) {
    @try {
        
        return _rankDataSourceArray.count;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
//    }else{
//        return 1;
//    }
    //return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        if (_rankDataSourceArray == nil || _rankDataSourceArray.count == 0) {
            
            return nil;
        }
        TableViewCellForGoodsRank *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsRankTableViewCell"];
        
        //第一列内容（排行列）
        if (indexPath.row == 0) {
            cell.rankOrder.backgroundColor = Color(177, 36, 44);
            cell.rankOrder.textColor = [UIColor whiteColor];
            cell.rankOrder.frame = CGRectMake(26 * SCREEN_W_SP, (_cellHeight / 2 - 10) * SCREEN_H_SP, 20, 20);
            cell.rankOrder.layer.cornerRadius = cell.rankOrder.width / 2;
        }else if (indexPath.row == 1) {
            cell.rankOrder.backgroundColor = Color(255, 108, 42);
            cell.rankOrder.textColor = [UIColor whiteColor];
            cell.rankOrder.frame = CGRectMake(26 * SCREEN_W_SP, (_cellHeight / 2 - 10) * SCREEN_H_SP, 20, 20);
            cell.rankOrder.layer.cornerRadius = cell.rankOrder.width / 2;
        }else if (indexPath.row == 2) {
            cell.rankOrder.backgroundColor = Color(255, 164, 36);
            cell.rankOrder.textColor = [UIColor whiteColor];
            cell.rankOrder.frame = CGRectMake(26 * SCREEN_W_SP, (_cellHeight / 2 - 10) * SCREEN_H_SP, 20, 20);
            cell.rankOrder.layer.cornerRadius = cell.rankOrder.width / 2;
        }else{
            cell.rankOrder.textColor = Color(123, 123, 123);//第四行及以下
            cell.rankOrder.backgroundColor = [UIColor clearColor];
            cell.rankOrder.frame = CGRectMake(18 * SCREEN_W_SP, (_cellHeight / 2 - 10) * SCREEN_H_SP, 34, 20);
            cell.rankOrder.layer.cornerRadius = 0;
        }
        cell.rankOrder.clipsToBounds = YES;
        
        
        //测试的假数据
        //    cell.goodsImgView.image = [UIImage imageNamed:@"img_排名页面收藏提示"];
        //    cell.goodsName.text = @"FXG5677879";
        //    cell.third.text = @"355";
        //    cell.fourth.text = @"90%";
        //    cell.fifth.text = @"55";
        //    cell.sixth.text = @"23";
        
        
        //sort可用空间
        CGFloat roomWidth = (_rankTableView.width - 100*SCREEN_W_SP - 14*SCREEN_W_SP) * 2 / 3;
        //判断sortTitleArray.count
        NSArray *sortTitleArray = _mainDic[@"data"][@"sortTitle"];
        if (sortTitleArray.count == 4) {
            //cell默认四个
        }else if (sortTitleArray.count == 3){
            //重用cell.third、cell.fourth、cell.fifth
            if (SCREEN_WIDTH >414) {
                
                cell.third.frame = CGRectMake(5 + roomWidth / 2, 0, roomWidth / 3, _cellHeight *SCREEN_H_SP);
                cell.fourth.frame = CGRectMake(5 + roomWidth / 2 + roomWidth / 3, 0, roomWidth / 3, _cellHeight *SCREEN_H_SP);
                cell.fifth.frame = CGRectMake(5 + roomWidth / 2 + roomWidth / 3 * 2, 0, roomWidth / 3, _cellHeight * SCREEN_H_SP);
            }
            else{
                
                cell.third.frame = CGRectMake(14 + roomWidth / 2, 0, roomWidth / 3, _cellHeight *SCREEN_H_SP);
                cell.fourth.frame = CGRectMake(14 + roomWidth / 2 + roomWidth / 3, 0, roomWidth / 3, _cellHeight *SCREEN_H_SP);
                cell.fifth.frame = CGRectMake(14 + roomWidth / 2 + roomWidth / 3 * 2, 0, roomWidth / 3, _cellHeight * SCREEN_H_SP);
            }
            
        }else if (sortTitleArray.count == 2) {
            if (SCREEN_WIDTH >414) {
                cell.third.frame = CGRectMake(5 + roomWidth / 2, 0, roomWidth / 2, _cellHeight *SCREEN_H_SP);
                cell.fourth.frame = CGRectMake(5 + roomWidth / 2 + roomWidth / 2, 0, roomWidth / 2, _cellHeight *SCREEN_H_SP);
            }
            else{
                cell.third.frame = CGRectMake(14 + roomWidth / 2, 0, roomWidth / 2, _cellHeight *SCREEN_H_SP);
                cell.fourth.frame = CGRectMake(14 + roomWidth / 2 + roomWidth / 2, 0, roomWidth / 2, _cellHeight *SCREEN_H_SP);
            }
            
        }else if (sortTitleArray.count == 1){
            
            if (SCREEN_WIDTH > 414) {
                cell.third.frame = CGRectMake(5 + roomWidth / 2, 0, roomWidth, _cellHeight *SCREEN_H_SP);
            }
            else{
                cell.third.frame = CGRectMake(14 + roomWidth / 2, 0, roomWidth, _cellHeight *SCREEN_H_SP);
            }
            
        }
        
        
        cell.rankOrder.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        
        cell.goodsName.text = _rankDataSourceArray[indexPath.row][@"productNO"];
        
        
        NSString *imgURL = _rankDataSourceArray[indexPath.row][@"productImage"];
        
       
        NSURL *URL = [NSURL URLWithString: imgURL];
        
        [cell.goodsImgView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"img_商品排行默认图"]];
        
        cell.goodsImgView.contentMode = UIViewContentModeScaleAspectFit;
        
        //排序指标最多4列
        NSArray *orderDataArray = _rankDataSourceArray[indexPath.row][@"PI"];
        if (0 < orderDataArray.count) {
            
            cell.third.text = _rankDataSourceArray[indexPath.row][@"PI"][0][@"value"];
            
        }
        if (1 < orderDataArray.count) {
            
            cell.fourth.text = _rankDataSourceArray[indexPath.row][@"PI"][1][@"value"];
            
        }
        if (2 < orderDataArray.count) {
            
            cell.fifth.text = _rankDataSourceArray[indexPath.row][@"PI"][2][@"value"];
            
        }
        if (3 < orderDataArray.count) {
            
            cell.sixth.text = _rankDataSourceArray[indexPath.row][@"PI"][3][@"value"];
            
        }
        
        UIButton *btn = (UIButton *)[self viewWithTag:1010];
        
        cell.singleCollect.frame = CGRectMake(_rankTableView.width - 80*SCREEN_W_SP, 0, btn.width, _cellHeight *SCREEN_H_SP);
        
        cell.singleCollect.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
        if (_indexRankOrCollect == 1) {
            
            if ([favoriteCodeArray[indexPath.row] isEqualToString:@"1"])
            {
                [cell.singleCollect setTitle:@"已收藏" forState:UIControlStateNormal];
                [cell.singleCollect setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                cell.singleCollect.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
            }else{
                
                [cell.singleCollect setTitle:@"收藏" forState:UIControlStateNormal];
                [cell.singleCollect setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
                cell.singleCollect.layer.borderColor = [UIColor colorWithHex:0x888888].CGColor;
                
            }
        }else{
            
            [cell.singleCollect setTitle:@"取消收藏" forState:UIControlStateNormal];
            [cell.singleCollect setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            cell.singleCollect.layer.borderColor = [UIColor colorWithHex:0x888888].CGColor;
        }
        
        
        [cell.singleCollect addTarget:self action:@selector(collectionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        if (_keyBoradBool == YES) {
            _touchSeachBool = NO;
            [self.tfText resignFirstResponder];
            self.tfText.text = @"";
            return;
        }
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        
        [[NSUserDefaults standardUserDefaults]setObject:[AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd forKey:@"DateStrBeforePush"];
        
        FourDetailViewController * fourVC = [FourDetailViewController new];
        fourVC.delegate = self;
        fourVC.productCode = _rankDataSourceArray[indexPath.row][@"productCode"];
        
        NSString *imgURL = _rankDataSourceArray[indexPath.row][@"productImage"];
        NSInteger annotationIndex = [imgURL rangeOfString:@"@"].location;
        NSString *imgPureURL = [imgURL substringToIndex:annotationIndex];
        fourVC.imgPureURL = imgPureURL;
        
        [tempAppDelegate.mainNavigationController pushViewController:fourVC animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"goodsNumberString"];
        [self.tfText resignFirstResponder];
        
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)allCollectionViewTap:(UITapGestureRecognizer *)tap{

    @try {
        
        UIButton *button = (UIButton *)[self viewWithTag:1010];
        [self collectionBtnClick:button];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
  

}

-(void)singleCollectBtn:(UIButton *)button{

    
}

-(void)collectionBtnClick:(UIButton *)button{

    @try {
       
        if (![[button titleLabel].text isEqualToString:@"已收藏"] && [_rankTableView visibleCells].count > 0) {
            
            NSString *product_arrayStr;
            NSString *favoriteCode = _indexRankOrCollect == 1 ? @"0" : @"1";
            
            if ([button.titleLabel.text containsString:@"全部"]) {
                
                for (int i= 0; i < _rankDataSourceArray.count; i++) {
                    
                    if (i == 0) {
                        
                        product_arrayStr = _rankDataSourceArray[i][@"productCode"];
                    }else{
                        
                        product_arrayStr = [NSString stringWithFormat:@"%@,%@",product_arrayStr,_rankDataSourceArray[i][@"productCode"]];
                    }
                    
                    
                }
                
            } else {
                
                NSIndexPath * indexPath = [self getCollectButtonOnCell:button classOfCell:[TableViewCellForGoodsRank class] tableView:_rankTableView];
                
                if (indexPath != nil) {
                    
                    product_arrayStr = _rankDataSourceArray[indexPath.row][@"productCode"];
                    
                }
            }
            
            
            [self request0303WithProductArrayStr:product_arrayStr andFavoriteCode:favoriteCode withButton:button];
            
            
        }
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(NSIndexPath *)getCollectButtonOnCell:(UIButton *)button classOfCell:(Class)class tableView:(UITableView *)tableView{
    
    @try {
        
         return [tableView indexPathForCell:(UITableViewCell *)[[button superview] superview]];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}

-(void)confirmCancelFrameWith:(UIButton *)button productArrayStr:(NSString *)prodectArrayStr andFavoriteCode:(NSString *)favoriteCode{
    
    @try {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                 message:@"是否取消收藏？"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              //请求接口
                                                              [self request0303WithProductArrayStr:prodectArrayStr andFavoriteCode:favoriteCode withButton:button];
                                                              
                                                          }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              
                                                              
                                                          }]];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
        

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 0303接口请求
-(void)request0303WithProductArrayStr:(NSString *)productArrayStr andFavoriteCode:(NSString *)favoriteCode withButton:(UIButton *)button{
    
    @try {
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.ProductBoardCollectSwitch"
                        dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                        
                                        [AppDatas sharedDatas].userCode,@"user_code",
                                        productArrayStr,@"product_array",
                                        favoriteCode,@"favorite_code",
                                        
                                        nil]
                             withCache:YES
                               success:^(NSDictionary *responseDic) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                           self.collectionDic = responseDic;
                                           
                                           
                                           [self collectButtonEndTouchedWith:button];
                                           
                                           
                                       }else{
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                           
                                       }
                                   });
                               }
                               failure:^(NSError *error) {
                                   
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
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)collectButtonEndTouchedWith:(UIButton *)button{
    
    @try {
        
        if (_indexRankOrCollect == 1) {
            
            if ([button.titleLabel.text isEqualToString:@"全部收藏"]) {
                
                for (int i= 0; i < _rankDataSourceArray.count; i++) {
                    
                    
                    favoriteCodeArray[i] = @"1";
                    
                }
                
            } else {
                
                NSIndexPath *indexPath = [self getCollectButtonOnCell:button classOfCell:[TableViewCellForGoodsRank class] tableView:_rankTableView];
                
                if (indexPath != nil) {
                    
                    [favoriteCodeArray setObject:@"1" atIndexedSubscript:indexPath.row];
                    [button setTitle:@"已收藏" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                    button.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
                    
                }
                
            }
            
            [_rankTableView reloadData];
            
        } else {
            
            NSMutableArray<NSIndexPath *> *array = [NSMutableArray new];
            
            if ([button.titleLabel.text isEqualToString:@"全部取消"]) {
                
                for (int i = 0; i < _rankDataSourceArray.count; i++) {
                    
                    [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                }
                
                [_rankDataSourceArray removeAllObjects];
                [favoriteCodeArray removeAllObjects];
                
                
            } else {
                
                NSIndexPath * indexPath = [self getCollectButtonOnCell:button classOfCell:[TableViewCellForGoodsRank class] tableView:_rankTableView];
                
                if (indexPath != nil) {
                    
                    [_rankDataSourceArray removeObjectAtIndex:indexPath.row];
                    [favoriteCodeArray removeObjectAtIndex:indexPath.row];
                    [array addObject:indexPath];
                    
                }
                
            }
            
            [_rankTableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark - scrollView相关事件
-(void)subHeadSideBarTap:(UITapGestureRecognizer *)tap{
    
    [self.tfText resignFirstResponder];
}


- (void)testPan:(UIPanGestureRecognizer *)gesture {

    @try {
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //开始点击
            if (_scrollView.contentOffset.x <= 0) {
                _isStartOnZero = YES;
                _startPanX = [gesture locationInView:_scrollView].x;
            } else {
                _isStartOnZero = NO;
            }
            _isStartedPanThrough = NO;
        } else if (gesture.state == UIGestureRecognizerStateChanged) {
            //移动中
            if (_isStartOnZero) {
                //从0坐标开始pan
                if (_isStartedPanThrough) {
                    //已经开始传递pan
                    [[(AppDelegate *)[UIApplication sharedApplication].delegate LeftSlideVC] handlePan:gesture];
                } else {
                    CGPoint point = [gesture locationInView:_scrollView];
                    if (point.x > _startPanX) {
                        _isStartedPanThrough = YES;
                        [[(AppDelegate *)[UIApplication sharedApplication].delegate LeftSlideVC] handlePan:gesture];
                    }
                }
            }
        } else if (gesture.state == UIGestureRecognizerStateEnded) {
            if (_isStartedPanThrough) {
                [[(AppDelegate *)[UIApplication sharedApplication].delegate LeftSlideVC] handlePan:gesture];
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}




-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
        
        if (scrollView == scrollView1) {
            [animationView startAnimation];
            
        }
        else if (scrollView == _rankTableView){
            [twoAnimationView startAnimation];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.tfText resignFirstResponder];
    
       
}

#pragma mark - 即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
        
        if (scrollView1.contentOffset.y < -25 || _rankTableView.contentOffset.y < -25) {
            
            if (scrollView == scrollView1) {
                [animationView stopAnimating];
                
            }
            else if (scrollView == _rankTableView){
                [twoAnimationView stopAnimating];
            }
            
            [UIView animateWithDuration:0.5 animations:^{
                
                if (scrollView == scrollView1) {
                    
                    scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                    [animationView startAnimation1];
                    
                    _indexOfPageNum = 1;
                   
                    isLoadMOre = NO;
                   
                    [self request0302];
                    
                }
                else if (scrollView == _rankTableView){
                    
                    _rankTableView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);

                    [twoAnimationView startAnimation1];
                    _indexOfPageNum = 1;
                    
                    isLoadMOre = NO;
                   
                    [self request0302];
                    
                }
                
            }];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"商品排行 ShangPinView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


@end

