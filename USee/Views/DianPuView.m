//
//  DianPuView.m -- 店铺排行
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.



    // 店铺排行 （二级页面）



#import "DianPuView.h"
#import "BigAndTimeView.h"
#import "SegmentView.h"
#import "BigAndTimeView.h"
#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#import "LOSAFNetworking.h"
#import "LOSHelper.h"
#import "AppDatas.h"
#import "TableViewCellForStoreRank.h"
#import "SlideView.h"
#import "ThreeDetailViewController.h"

#import "MBProgressHUD.h"

#import "AnimationView.h"


#define colorText Color(123, 123, 123)

@interface DianPuView ()<SegmentViewDelegate,UIScrollViewDelegate,BigAndTimeViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,SlideViewDelegate,UIGestureRecognizerDelegate, MBProgressHUDDelegate,storeViewControllDelegate,UITextFieldDelegate>

{
    UIScrollView * moveView;
    UIButton *_moneyUpBtn;    //排序按钮
    UIButton *_moneyDownBtn;
    UIButton *_moneyBtn;
    UIButton *_discountUpBtn;
    UIButton *_discountDownBtn;
    UIButton *_discountBtn;
    UIButton *_collectionBtn;   //全部收藏按钮
    
    UIButton * _drillUpButton;
    UIButton * _drillDownButton;
    
    
    UITableView *_tableView;
    
    
    UIView * rankView;
    
    UIView * rankheadView;
    
    NSMutableArray *_rankDataSourceArray;
    NSMutableArray *_favoriteCodeArray;

    NSMutableArray * _upTriangleButtonArray;
    NSMutableArray * _downTriangleButtonArray;
    
    CGFloat _cellHeight;
    BOOL _isStartOnZero;
    float _startPanX;
    BOOL _isStartedPanThrough;
    
    BOOL _storeKeyBoradBool;
    BOOL _storeTouchSeachBool;
   
    BOOL _leftSelectButtonBool;
    
    
    NSInteger _indexRankOrCollection;
    NSInteger _indexDayWeekMonthYear;
    NSInteger _indexSubHeadBar;
    NSString *_piaCode;
    NSInteger _indexTitle;
    NSInteger _indexPort;
    NSInteger _indexPath;
    NSInteger _indexOfLeft;
    NSInteger _indexOfPageNum;

    NSInteger _recoredIndexOfPageNum;
    
    NSInteger oneW;
    NSInteger twoW;
    
    BOOL _isLoadMOre;
    MBProgressHUD *HUD;
    NSInteger _cellIndexPath;
    
    BigAndTimeView *_bigview;
    
    UIImageView *imageView;
    
    NSInteger _singleBtnTag;
    
    NSInteger _storeDrill_type;
    //AlterView *_alert;  //加载动画
    
    NSString *_favoriteCode;
    

    UIScrollView * scrollView1;
    
    NSInteger firstCreate;
    
    NSInteger refreshPop;
    
    AnimationView * animationView;
    TwoAnimationView * twoAnimationView;

    BOOL _titleIsChanged;   //品牌切换时
    BOOL _removeCollectAnimation;   //点击收藏按钮时不需要回弹效果
    
    NSString *_datestr;
    NSString * _rankCutString;
    
    NSString * _subHeadOrgCode;
}

@property (nonatomic,strong)NSString *orderCode;    //排序Code（A/D）
@property (nonatomic,strong)NSString *orderPir;

@property (nonatomic,strong)NSString *orderString;
@property (nonatomic,strong)NSString *StoreCodeArrayStr;

//数据在这里
@property (nonatomic,strong)NSMutableDictionary *enterAndLeftDataDic;  //0201接口初始字典
@property (nonatomic,strong)NSDictionary *secondDic;    //020101
@property (nonatomic,strong)NSDictionary *collectionDic;    //0202

@property (nonatomic,strong)NSMutableArray *titleNameArray;
@property (nonatomic,strong)NSMutableArray *sortTitleArray;
@property (nonatomic,strong)NSMutableArray *orderTypesArr;
@property (nonatomic,strong)NSMutableArray *subHeadSideBarArray;
@property (nonatomic,strong)NSMutableArray *subOrgCodeArray;
@property (nonatomic,strong)NSMutableArray *leftSidebarNameArray;
@property (nonatomic,strong)NSMutableArray *leftSidebarPiaCode;

@property (nonatomic,strong)UITextField * tfText;
@end

@implementation DianPuView

-(id)initWithFrame:(CGRect)frame{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        
       NSString * stroeRefreshString = [[NSUserDefaults standardUserDefaults] objectForKey:@"stroeRefresh"];
        if (![stroeRefreshString isEqualToString:@"a"]) {
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeContentOffsetX"];
        }
        
        oneW = 1;
        twoW = 0;
        
        _leftSelectButtonBool = NO;
        _storeKeyBoradBool = NO;
        _storeTouchSeachBool = NO;
        
        _rankDataSourceArray = nil;
        _sortTitleArray   = nil;
        
        _rankDataSourceArray = [NSMutableArray new];
        _sortTitleArray = [NSMutableArray new];
        
        _cellHeight = 40;
        _storeDrill_type = 0;
        
        refreshPop = 0;
        _indexRankOrCollection = 1;
        _indexDayWeekMonthYear = 1;
        _indexSubHeadBar = 0;
        _indexTitle = 0;
        _indexPort = 0;
        _indexPath = 0;
        _indexOfLeft = 0;
        _indexOfPageNum = 1;
        
        _piaCode = @"";
        
        _orderCode = @"";
        _orderPir = @"";
        
        [self createUI];
        
        //键盘监听
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storekeyboardAppear:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(storeKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     
    }
    
    return self;
}

-(void)stroeRefreshAfterPop{
  
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"在店铺详情中切换日期后返回店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        _temp =  [[NSUserDefaults standardUserDefaults] objectForKey:@"orgCodeCode"];
        _piaCode =  [[NSUserDefaults standardUserDefaults] objectForKey:@"storePiaCode"];
        
        _leftSelectButtonBool = YES;
        
        _storeDrill_type = 0;
        
        _isLoadMOre = NO;
        
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)refreshViewAfterPopFromStoreDetailVC{

    @try {
        
    _refreshBlock([[NSUserDefaults standardUserDefaults]objectForKey:@"DateBeforePush"],[[NSUserDefaults standardUserDefaults]objectForKey:@"TempBeforePush"]);
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   
}


-(void)storekeyboardAppear:(NSNotification *)notif{

    _storeKeyBoradBool = YES;
}

-(void)storeKeyboardWillHide:(NSNotification *)notif{
    
    _storeKeyBoradBool = NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    @try {
        
        [self.tfText resignFirstResponder];
        _storeDrill_type = 0;
        
        [self request020101];
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)threeTotwo:(NSNotification *)notif{
    
    @try {
     
        _storeDrill_type = 0;
        [self requestDatasWithOrgCode: _temp];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
    
}


#pragma mark - 切换品牌时的通知方法
-(void)brandTableViewToDianPu:(NSString *)orgCode{
    
    @try {
     
        _storeDrill_type = 0;
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeContentOffsetX"];
        
        _temp = orgCode;
        
        _isLoadMOre = NO;
        
        _titleIsChanged = YES;
        _indexSubHeadBar = 0;
        _indexRankOrCollection = 1;
        
        _indexOfPageNum = 1;
        
        _leftSelectButtonBool = YES;
        [self requestDatasWithOrgCode: _temp];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 底部tableBar按钮的切换
-(void)dianpu:(NSNotification *)notif{
    
    @try {
     
        _storeDrill_type = 0;
        
        NSString *temp = [notif object];
        
        _temp = temp;
        _indexSubHeadBar = 0;
        _indexOfPageNum = 1;
        _titleIsChanged = YES;
        _isLoadMOre = NO;
        [self requestDatasWithOrgCode: _temp];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];

        
    } @finally {
        
    }
}


- (void)orgCodeToDianPu:(NSString *)orgCode{
    
    @try {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [_enterAndLeftDataDic removeAllObjects];
        _storeDrill_type = 0;
        
        _temp = orgCode;
        
        _indexSubHeadBar = 0;
        
        //    _indexSubHeadBar = 0;
        
        _indexOfPageNum = 1;
        _isLoadMOre = NO;
        _titleIsChanged = NO;
        _leftSelectButtonBool = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"storeContentOffsetX"];
        
        [self requestDatasWithOrgCode:_temp];
   
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 接收左侧边栏的通知方法
-(void)receiveIndex:(NSNotification *)notif{
    
    @try {
     
        _storeDrill_type = 0;
        
        //左侧边栏index
        _piaCode = notif.userInfo[@"piaCodeToDianPu"];
        _indexOfLeft = [notif.userInfo[@"indexOfLeft"] integerValue];
        _indexOfPageNum = 1;
        _titleIsChanged = YES;
        [self requestDatasWithOrgCode: _temp];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 接收日历切换时间参数的通知方法
- (void)renjia2:(NSNotification *)notification {
    
    @try {
     
        _storeDrill_type = 0;
        
        [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
        [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
        _indexOfPageNum = 1;
        
        _leftSelectButtonBool = YES;
        [self requestDatasWithOrgCode:_temp];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)storeRank:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {
        
        _storeDrill_type = 0;
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        
        
        //    //    把失散的变量兄弟们初始化 Part 2...找了好久...
        //    _orderString = @"A";
        //    _indexRankOrCollection = 1;
        //    _indexSubHeadBar = 0;
        //    _indexDayWeekMonthYear = 1;
        
        _isLoadMOre = NO;
        
        _leftSelectButtonBool = YES;
        _indexOfPageNum = 1;
        _titleIsChanged = NO;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark -
#pragma mark - 0201接口 请求数据

- (void)requestDatasWithOrgCode:orgCode{
    @try {
     
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString *subhead_org_code;
                if (_enterAndLeftDataDic.count > 0) {
                    
                    NSArray *subheadSidebarArr = _enterAndLeftDataDic[@"data"][@"subheadSidebar"];
                    NSMutableArray *subheadCodeArr = [NSMutableArray new];
                    for (int i = 0; i < subheadSidebarArr.count; i ++) {
                        
                        [subheadCodeArr addObject:subheadSidebarArr[i][@"code"]];
                    }
                    
                    subhead_org_code = subheadCodeArr[_indexSubHeadBar];
                }else{
                    
                    subhead_org_code = orgCode;
                }
                if (_titleIsChanged) {
                    subhead_org_code = orgCode;
                }
                
                
                NSString *tabs_code = [NSString stringWithFormat:@"%ld",(long)_indexRankOrCollection];
                
                
                NSString *orderPir = @"";
                NSString *orderCode = @"";
                
                NSString *pageSize = @"";
                NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_indexOfPageNum];
                
                NSString *timeLevel = [NSString stringWithFormat:@"%ld",(long)_indexDayWeekMonthYear];
                
                NSDictionary * dataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          
                                          [AppDatas sharedDatas].userCode, @"user_code",
                                          orgCode,@"title_org_code",
                                          subhead_org_code,@"subhead_org_code",
                                          tabs_code,@"tabs_code",
                                          
                                          _piaCode,@"pia_code",
                                          
                                          orderPir,@"order_pir",
                                          orderCode,@"order_code",
                                          
                                          pageSize,@"page_size",
                                          pageNum,@"page_num",
                                          
                                          [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd, @"start_date",
                                          [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd, @"end_date",
                                          
                                          timeLevel,@"time_level",
                                          
                                          nil];
                
                //    subhead_org_code = @"B001";
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreBoardSortAccess"
                             dataParameters:dataDic
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                                                [UIView animateWithDuration:.4 animations:^{
                                                    
                                                    [animationView stopAnimating1];
                                                    
                                                    scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                    
                                                }];
                                                
                                                //          footer.hidden = NO;
                                                
                                                self.enterAndLeftDataDic = [[NSMutableDictionary alloc] initWithDictionary:responseDic];
                                                
                                                [self refreshThisViewAndDatas];
                                                
                                                
                                                
                                            } else {
                                                
                                                HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
                                                HUD.delegate = self;
                                                HUD.mode = MBProgressHUDModeText;
                                                HUD.labelText = responseDic[@"msg"];
                                                HUD.margin = 10.f;
                                                HUD.removeFromSuperViewOnHide = YES;
                                                [HUD hide:YES afterDelay:2];
                                                
                                            }
                                            if (_rankDataSourceArray.count < 20) {
                                                //_tableView.footer.hidden = YES;
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 请求 入口+侧边栏 在这里刷新
-(void)refreshThisViewAndDatas{
    @try {
       
        if (!_enterAndLeftDataDic) {
            return;
        }
        
        if (_storeDrill_type == 1) {
#pragma mark - subheadBar + 日周月年 + 搜索框
            _storeDrill_type = 0;
            
            [_bigview removeFromSuperview];
            _bigview = nil;
            _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
            _bigview.checkUserType = YES;
            _bigview.delegate =self;
            NSMutableArray *subArray = [NSMutableArray new];
            NSArray *subheadSidebarArr = _enterAndLeftDataDic[@"data"][@"subheadSidebar"];
            for (int i = 0; i < subheadSidebarArr.count; i ++) {
                
                [subArray addObject:subheadSidebarArr[i][@"name"]];
            }
            NSString * str = [NSString stringWithFormat:@""];
            NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
            [_bigview showBigAndTimeView:subArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubHeadBar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:1];
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
            
            self.tfText.placeholder = @"店名";
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
            [_drillUpButton addTarget:self action:@selector(stroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            
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
            [_drillDownButton addTarget:self action:@selector(stroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            if (_indexSubHeadBar > 0) {
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
            
            
            _bigview.ScrollView.contentOffset =  CGPointMake(0, 0);
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"storeContentOffsetX"];
            
        }
        else if (_storeDrill_type == 2) {
            
            NSLog(@"数据  %@",_enterAndLeftDataDic);
            
            _storeDrill_type = 0;
#pragma mark - 侧边栏
            
            
#pragma mark - subheadBar + 日周月年 + 搜索框
            [_bigview removeFromSuperview];
            _bigview = nil;
            _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
            _bigview.checkUserType = YES;
            _bigview.delegate =self;
            NSMutableArray *subArray = [NSMutableArray new];
            NSArray *subheadSidebarArr = _enterAndLeftDataDic[@"data"][@"subheadSidebar"];
            for (int i = 0; i < subheadSidebarArr.count; i ++) {
                
                [subArray addObject:subheadSidebarArr[i][@"name"]];
            }
            NSString * str = [NSString stringWithFormat:@""];
            NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
            [_bigview showBigAndTimeView:subArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubHeadBar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:1];
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
            
            self.tfText.placeholder = @"店名";
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
            [_drillUpButton addTarget:self action:@selector(stroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            
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
            [_drillDownButton addTarget:self action:@selector(stroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            if (_indexSubHeadBar > 0) {
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
            
            
            
            _bigview.ScrollView.contentOffset =  CGPointMake(0, 0);
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"storeContentOffsetX"];
            
            //    self.tfText.frame = CGRectMake(10* SCREEN_W_SP, 135 + 40* SCREEN_H_SP, SCREEN_WIDTH - 20* SCREEN_W_SP, 30* SCREEN_H_SP);
            //    _drillUpButton.hidden = YES;
            //    _drillDownButton.hidden = YES;
            
        }
        else if(_storeDrill_type == 0){
            
#pragma mark - 侧边栏
            NSMutableArray *leftSidebarNameArray = [NSMutableArray new];
            NSMutableArray *leftSidebarPiaCode = [NSMutableArray new];
            NSMutableArray *leftArray = _enterAndLeftDataDic[@"data"][@"leftSidebar"];
            if (leftArray.count != 0) {
                for (int i = 0; i < leftArray.count; i ++) {
                    
                    [leftSidebarNameArray addObject:leftArray[i][@"nameArray"]];
                    [leftSidebarPiaCode addObject:leftArray[i][@"piaCode"]];
                    
                }
            }
            
            
            NSString * indexCollect = [NSString stringWithFormat:@"%ld",(long)_indexOfLeft];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:leftSidebarNameArray,@"leftArray",leftSidebarPiaCode,@"leftPiaCode",indexCollect,@"indexCollect",nil];
            NSNotification *notification =[NSNotification notificationWithName:@"DianPuLeftSidebarArray" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            _piaCode = leftSidebarPiaCode[_indexOfLeft];
            
            [[NSUserDefaults standardUserDefaults] setObject:_piaCode forKey:@"storePiaCode"];
            
#pragma mark - subheadBar + 日周月年 + 搜索框
            [_bigview removeFromSuperview];
            _bigview = nil;
            _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
            _bigview.checkUserType = YES;
            _bigview.delegate =self;
            NSMutableArray *subArray = [NSMutableArray new];
            NSArray *subheadSidebarArr = _enterAndLeftDataDic[@"data"][@"subheadSidebar"];
            for (int i = 0; i < subheadSidebarArr.count; i ++) {
                
                [subArray addObject:subheadSidebarArr[i][@"name"]];
            }
            NSString * str = [NSString stringWithFormat:@""];
            NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
            [_bigview showBigAndTimeView:subArray WithState:NO Withplaceholder:str WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubHeadBar withIndexOfTime:_indexDayWeekMonthYear - 1 scrollViewTag:1];
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
            
            self.tfText.placeholder = @"店名";
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
            [_drillUpButton addTarget:self action:@selector(stroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            
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
            [_drillDownButton addTarget:self action:@selector(stroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
            
            if (_indexSubHeadBar > 0) {
                if (SCREEN_WIDTH == 320) {
                    self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64 , SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                }
                else if (SCREEN_WIDTH > 414){
                    self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140, 30* SCREEN_H_SP);
                }
                else{
                    self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 140 , 30* SCREEN_H_SP);
                }
                
                _drillUpButton.hidden = NO;
                _drillDownButton.hidden = NO;
            }
            
#pragma mark - 排序按钮
            _orderCode = _enterAndLeftDataDic[@"data"][@"sortTitle"][0][@"orderType"];
            _orderPir = _enterAndLeftDataDic[@"data"][@"sortTitle"][0][@"piCode"];
            
            NSString * contentOffsetX = [[NSUserDefaults standardUserDefaults] objectForKey:@"storeContentOffsetX"];
            if (contentOffsetX.length > 0) {
                _bigview.ScrollView.contentOffset =  CGPointMake([contentOffsetX doubleValue], 0);
            }
            
            
            //    self.tfText.frame = CGRectMake(10* SCREEN_W_SP, 135 + 40* SCREEN_H_SP, SCREEN_WIDTH - 20* SCREEN_W_SP, 30* SCREEN_H_SP);
            //    _drillUpButton.hidden = YES;
            //    _drillDownButton.hidden = YES;
            
#pragma mark - 刷新rankView
            [rankView removeFromSuperview];
            rankView = nil;
            
            [_tableView removeFromSuperview];
            _tableView = nil;
            [self createRankView];
            
            
#pragma mark - tableView数据源
            if (_leftSelectButtonBool == YES) {
                _rankDataSourceArray = [NSMutableArray new];
                _rankDataSourceArray = [_enterAndLeftDataDic[@"data"][@"sortList"][@"data"] mutableCopy];
                [self refreshRankTableViewWith:_rankDataSourceArray];
                _leftSelectButtonBool = NO;
            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 刷新tableView数据
-(void)refreshRankTableViewWith:(NSMutableArray *)array{
    
    @try {
       
        if (!array) {
            return;
        }
        
        if (!_removeCollectAnimation) {
            
            [UIView animateWithDuration:0.2 animations:^{
                moveView.contentOffset = CGPointMake(0, 0);
            }];
            
        }
        _removeCollectAnimation = NO;
        
        
        _favoriteCodeArray = [NSMutableArray new];
        for (int i = 0; i < _rankDataSourceArray.count; i ++) {
            
            [_favoriteCodeArray addObject:_rankDataSourceArray[i][@"favoriteCode"]];
        }
        
        //刷新数据源
        [_tableView reloadData];
        if (_isLoadMOre) {
            
            
        }else{
            _tableView.contentOffset = CGPointMake(0, 0);
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

-(void)createUI{
    
    @try {
      
        self.clipsToBounds = YES;
        
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        if (SCREEN_HEIGHT == 812) {
             scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, self.height)];
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
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        
        
        SlideView * slide = [[SlideView alloc]init];
        slide.delegate = self;
        [self addSubview:slide];
        
        
#pragma mark - subHeadBar
        [_bigview removeFromSuperview];
        _bigview = nil;
        
        _bigview = [[BigAndTimeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140 *SCREEN_H_SP)];
        _bigview.delegate =self;
        _bigview.checkUserType = YES;
        NSArray *array = @[@"",@"",@"",@""];
        
        NSArray * timeBtnArr = @[@"日",@"周",@"月",@"年"];
        [_bigview showBigAndTimeView:array WithState:NO Withplaceholder:@"" WithTimeArray:timeBtnArr withIndexOfSubheadBar:_indexSubHeadBar withIndexOfTime:(_indexDayWeekMonthYear - 1) scrollViewTag:1];
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
        
        self.tfText.delegate =self;
        self.tfText.borderStyle = UITextBorderStyleRoundedRect;
        self.tfText.returnKeyType = UIReturnKeySearch;
        
        if (SCREEN_WIDTH == 320) {
            self.tfText.frame = CGRectMake(10, 143*SCREEN_H_SP + 40* SCREEN_H_SP - 64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        else if (SCREEN_WIDTH > 414){
            self.tfText.frame = CGRectMake(10, 113*SCREEN_H_SP + 40* SCREEN_H_SP-64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        else{
            self.tfText.frame = CGRectMake(10, 133*SCREEN_H_SP + 40* SCREEN_H_SP-64, SCREEN_WIDTH - 20, 30* SCREEN_H_SP);
        }
        
        self.tfText.clearButtonMode = UITextFieldViewModeAlways;
        
        self.tfText.placeholder = @"店名";
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
        [_drillUpButton addTarget:self action:@selector(stroeDrillUpTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
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
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50 - 64, 113*SCREEN_H_SP + 40* SCREEN_H_SP, 50, 28*SCREEN_H_SP);
        }
        else{
            _drillDownButton.frame = CGRectMake(10 + SCREEN_WIDTH - 140 + 10 + 10 + 50 - 64, 133*SCREEN_H_SP + 40* SCREEN_H_SP, 50, 28*SCREEN_H_SP);
        }
        
        [_drillDownButton setTitle:@"下钻" forState:UIControlStateNormal];
        _drillDownButton.layer.masksToBounds = YES;
        _drillDownButton.layer.cornerRadius = 5;
        _drillDownButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_drillDownButton addTarget:self action:@selector(stroeDrillDownTounchButton) forControlEvents:UIControlEventTouchUpInside];
        
        
        [moveView removeFromSuperview];
        moveView = nil;
        
        moveView = [[UIScrollView alloc]initWithFrame:CGRectMake(-0.01, _bigview.y + _bigview.height + 10 * SCREEN_H_SP, SCREEN_WIDTH - 10*SCREEN_W_SP, SCREEN_HEIGHT - (40 + 110 + 90) * SCREEN_H_SP - 64)];
        moveView.contentSize=CGSizeMake(SCREEN_WIDTH + 100 *SCREEN_W_SP , SCREEN_HEIGHT - (40 + 110 + 90) * SCREEN_H_SP - 64);
        
        moveView.alwaysBounceHorizontal = YES;
        moveView.delegate =self;
        
        moveView.backgroundColor = [UIColor whiteColor];
        moveView.showsHorizontalScrollIndicator = NO;
        [scrollView1 addSubview:moveView];
        //    moveView.scrollEnabled = NO;
        [moveView.panGestureRecognizer addTarget:self action:@selector(testPan:)];
        
        [rankView removeFromSuperview];
        rankView = nil;
        [_tableView removeFromSuperview];
        _tableView = nil;
#pragma mark - headview + tableView
        [self createRankView];
        
        
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
        piecew.textSeletedColor = [UIColor colorWithHex:0xba2932];
        piecew.linColor = [UIColor colorWithHex:0xc82d37];
        [piecew loadTitleArray:arrar];
        [self addSubview:piecew];
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark 点击上钻按钮
-(void)stroeDrillUpTounchButton{
    
    @try {
        
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        _storeDrill_type = 1;
        if (textStr.length == 0) {
            _storeTouchSeachBool = NO;
        }
        
        if (_storeKeyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_storeTouchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        _isLoadMOre = NO;
        _indexOfPageNum = 1;
        //请求并更新数据源
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 点击下钻按钮
-(void)stroeDrillDownTounchButton{
    
    @try {
        
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        _storeDrill_type = 2;
        if (textStr.length == 0) {
            _storeTouchSeachBool = NO;
        }
        
        if (_storeKeyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_storeTouchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        _isLoadMOre = NO;
        _indexOfPageNum = 1;
        //请求并更新数据源
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)createRankView{

    @try {
     
        //tableView + headView 的背景View
        [rankView removeAllSubviews];
        
        _rankCutString = @"ww";
        
        rankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, moveView.contentSize.width, moveView.contentSize.height)];
        rankView.backgroundColor = [UIColor whiteColor];
        [moveView addSubview:rankView];
        
#pragma mark - rankheadView
        rankheadView = [[UIView alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 0, moveView.contentSize.width, 50*SCREEN_H_SP)];
        rankheadView.backgroundColor = Color(238, 238, 238);
        [rankView addSubview:rankheadView];
        [rankheadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankHeadViewTap:)]];
        UIView *rightWhiteInRankheadView = [[UIView alloc]initWithFrame:CGRectMake(rankheadView.width - 10 *SCREEN_W_SP, 0, 10 *SCREEN_W_SP, rankheadView.height)];
        rightWhiteInRankheadView.backgroundColor = [UIColor whiteColor];
        [rankheadView addSubview:rightWhiteInRankheadView];
        
#pragma mark - 1、排行序列
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50 *SCREEN_W_SP, rankheadView.height)];
        rankLabel.text = @"排行";
        rankLabel.textColor = colorText;
        rankLabel.font = [UIFont systemFontOfSize:14];
        rankLabel.textAlignment = NSTextAlignmentLeft;
        [rankheadView addSubview:rankLabel];
        
        _upTriangleButtonArray = nil;
        _downTriangleButtonArray = nil;
        
        _upTriangleButtonArray = [[NSMutableArray alloc] init];
        
        _downTriangleButtonArray = [[NSMutableArray alloc] init];
        
#pragma mark - 排序指标：根据接口返回数据里的sortTitle的个数判断
        NSMutableArray *sortTitleArray = [NSMutableArray new];
        if (_enterAndLeftDataDic) {
            
            sortTitleArray = _enterAndLeftDataDic[@"data"][@"sortTitle"];
            for (int i = 0; i < sortTitleArray.count; i ++) {
                
                if ([sortTitleArray[i][@"orderType"] isEqualToString:@"D"])
                {
                    
                    UIButton *upTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *downTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    if (sortTitleArray.count == 1) {
                        upTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                        downTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                        cutBtn.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                    }else{
                        
                        if (i == 0) {
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                        }else{
                            
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, rankheadView.height *2 / 3, 65*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height);
                        }
                    }
                    
                    
                    upTriangle.tag = 500 + i;
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    [rankheadView addSubview:upTriangle];
                    
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    [_upTriangleButtonArray addObject:upTriangle];
                    
                    [_downTriangleButtonArray addObject:downTriangle];
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i == 0) {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                        [cutBtn setSelected:YES];
                        
                    }
                    
                    
                    [rankheadView addSubview:cutBtn];
                    
                }else if ([sortTitleArray[i][@"orderType"] isEqualToString:@"A"]){
                    
                    UIButton *upTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *downTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    if (sortTitleArray.count == 1) {
                        upTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                        downTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                        cutBtn.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                    }else{
                        
                        if (i == 0) {
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                        }else{
                            
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, rankheadView.height *2 / 3, 65*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height);
                        }
                    }
                    
                    
                    
                    upTriangle.tag = 500 + i;
                    [rankheadView addSubview:upTriangle];
                    
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    //                cutBtn.backgroundColor = Color(200, 200, 200);
                    
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i == 0) {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    }
                    
                    [cutBtn setSelected:YES];
                    
                    [_upTriangleButtonArray addObject:upTriangle];
                    
                    [_downTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }else{
                    
                    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120 *SCREEN_W_SP, rankheadView.height)];
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:sortTitleArray[i][@"siteName"] forState:UIControlStateNormal];
                    
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [rankheadView addSubview:cutBtn];
                    
                }
            }
        }
        
        //2、店名(宽度由指标数控制)
        UILabel *storeLabel = [UILabel new];
        storeLabel.frame = CGRectMake(rankLabel.x + rankLabel.width , 0, SCREEN_WIDTH - (rankLabel.x + rankLabel.width   + 120 *SCREEN_W_SP + 75 *(sortTitleArray.count - 1) *SCREEN_W_SP), rankheadView.height);
        storeLabel.text = @"店名";
        storeLabel.textColor = colorText;
        storeLabel.font = [UIFont systemFontOfSize:14];
        storeLabel.textAlignment = NSTextAlignmentCenter;
        [rankheadView addSubview:storeLabel];
        storeLabel.tag = 2222;
        
        
        //7、收藏
        [_collectionBtn removeFromSuperview];
        _collectionBtn = nil;
        
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(rankheadView.width - 90*SCREEN_W_SP, rankheadView.height / 4, 70 *SCREEN_W_SP, rankheadView.height / 2);
        _collectionBtn.tag = 1010;
        _collectionBtn.layer.cornerRadius = 5;
        _collectionBtn.layer.borderColor = [UIColor colorWithHex:0xba2932].CGColor;
        _collectionBtn.layer.borderWidth = 1;
        if (_indexRankOrCollection == 1) {
            [_collectionBtn setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else{
            [_collectionBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        [_collectionBtn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
        _collectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_collectionBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rankheadView addSubview:_collectionBtn];
        
        //_tableView
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        if (SCREEN_HEIGHT == 812) {
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake( - 4, rankheadView.y + rankheadView.height - 0.1, moveView.contentSize.width + 4, rankView.height - rankheadView.height - 50) style:UITableViewStylePlain];
        }
        else{
             _tableView = [[UITableView alloc]initWithFrame:CGRectMake( - 4, rankheadView.y + rankheadView.height - 0.1, moveView.contentSize.width + 4, rankView.height - rankheadView.height) style:UITableViewStylePlain];
        }
        
        _tableView.rowHeight = 40 *SCREEN_H_SP;
        
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.showsVerticalScrollIndicator = NO;
        //去除空白cell(不展示空白cell的上下边线)
        _tableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
        [_tableView registerClass:[TableViewCellForStoreRank class] forCellReuseIdentifier:@"storeTableViewCell"];
        [rankView addSubview:_tableView];
        
        [twoAnimationView removeFromSuperview];
        twoAnimationView = nil;
        
        twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -83, SCREEN_WIDTH, 100)];
        
        twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
        
        [twoAnimationView Animation];
        
        [twoAnimationView Animation1];
        
        [_tableView addSubview:twoAnimationView];
        
        [_tableView  addFooterWithTarget:self action:@selector(addFooterRefresh)];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark  点击分屏上按钮
-(void)createTwoRankView{
    
    @try {
       
#pragma mark - rankheadView
        [rankheadView removeAllSubviews];
        
        _rankCutString = @"ww";
        
        rankheadView = [[UIView alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 0, moveView.contentSize.width, 50*SCREEN_H_SP)];
        rankheadView.backgroundColor = Color(238, 238, 238);
        [rankView addSubview:rankheadView];
        [rankheadView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rankHeadViewTap:)]];
        UIView *rightWhiteInRankheadView = [[UIView alloc]initWithFrame:CGRectMake(rankheadView.width - 10 *SCREEN_W_SP, 0, 10 *SCREEN_W_SP, rankheadView.height)];
        rightWhiteInRankheadView.backgroundColor = [UIColor whiteColor];
        [rankheadView addSubview:rightWhiteInRankheadView];
        
#pragma mark - 1、排行序列
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 50 *SCREEN_W_SP, rankheadView.height)];
        rankLabel.text = @"排行";
        rankLabel.textColor = colorText;
        rankLabel.font = [UIFont systemFontOfSize:14];
        rankLabel.textAlignment = NSTextAlignmentLeft;
        [rankheadView addSubview:rankLabel];
        
        _upTriangleButtonArray = nil;
        _downTriangleButtonArray = nil;
        
        _upTriangleButtonArray = [[NSMutableArray alloc] init];
        
        _downTriangleButtonArray = [[NSMutableArray alloc] init];
        
#pragma mark - 排序指标：根据接口返回数据里的sortTitle的个数判断
        NSMutableArray *sortTitleArray = [NSMutableArray new];
        if (_enterAndLeftDataDic) {
            
            sortTitleArray = _enterAndLeftDataDic[@"data"][@"sortTitle"];
            for (int i = 0; i < sortTitleArray.count; i ++) {
                
                if ([sortTitleArray[i][@"orderType"] isEqualToString:@"D"])
                {
                    
                    UIButton *upTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *downTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    if (sortTitleArray.count == 1) {
                        upTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                        downTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                        cutBtn.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                    }else{
                        
                        if (i == 0) {
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                        }else{
                            
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, rankheadView.height *2 / 3, 65*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height);
                        }
                    }
                    
                    
                    upTriangle.tag = 500 + i;
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    [rankheadView addSubview:upTriangle];
                    
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    [cutBtn setTitle:[NSString stringWithFormat:@"%@",sortTitleArray[i][@"siteName"]] forState:UIControlStateNormal];
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i == 0) {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                        [cutBtn setSelected:YES];
                        
                    }
                    
                    [_upTriangleButtonArray addObject:upTriangle];
                    [_downTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }else if ([sortTitleArray[i][@"orderType"] isEqualToString:@"A"]){
                    
                    UIButton *upTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *downTriangle = [UIButton buttonWithType:UIButtonTypeCustom];
                    UIButton *cutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                    if (sortTitleArray.count == 1) {
                        upTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                        downTriangle.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                        cutBtn.frame = CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                    }else{
                        
                        if (i == 0) {
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, rankheadView.height *2 / 3, 120*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - (120 + 80) *SCREEN_W_SP, 0, 120*SCREEN_W_SP, rankheadView.height);
                        }else{
                            
                            upTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height / 3);
                            downTriangle.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, rankheadView.height *2 / 3, 65*SCREEN_W_SP, rankheadView.height / 3);
                            cutBtn.frame = CGRectMake(SCREEN_WIDTH - 80 *SCREEN_W_SP, 0, 65*SCREEN_W_SP, rankheadView.height);
                        }
                    }
                    
                    
                    
                    upTriangle.tag = 500 + i;
                    [rankheadView addSubview:upTriangle];
                    
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    downTriangle.tag = 600 + i;
                    [rankheadView addSubview:downTriangle];
                    
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:[NSString stringWithFormat:@"%@",sortTitleArray[i][@"siteName"]] forState:UIControlStateNormal];
                    //                cutBtn.backgroundColor = Color(200, 200, 200);
                    
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    
                    if (i == 0) {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    }
                    
                    [cutBtn setSelected:YES];
                    
                    [_upTriangleButtonArray addObject:upTriangle];
                    [_downTriangleButtonArray addObject:downTriangle];
                    
                    [rankheadView addSubview:cutBtn];
                    
                }else{
                    
                    UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120 *SCREEN_W_SP, 0, 120 *SCREEN_W_SP, rankheadView.height)];
                    cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                    cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    cutBtn.tag = 700 + i;
                    
                    [cutBtn setTitle:[NSString stringWithFormat:@"%@",sortTitleArray[i][@"siteName"]] forState:UIControlStateNormal];
                    
                    [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                    [cutBtn addTarget:self action:@selector(rankCutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [rankheadView addSubview:cutBtn];
                    
                }
            }
        }
        
        //2、店名(宽度由指标数控制)
        UILabel *storeLabel = [UILabel new];
        storeLabel.frame = CGRectMake(rankLabel.x + rankLabel.width , 0, SCREEN_WIDTH - (rankLabel.x + rankLabel.width   + 120 *SCREEN_W_SP + 75 *(sortTitleArray.count - 1) *SCREEN_W_SP), rankheadView.height);
        storeLabel.text = @"店名";
        storeLabel.textColor = colorText;
        storeLabel.font = [UIFont systemFontOfSize:14];
        storeLabel.textAlignment = NSTextAlignmentCenter;
        [rankheadView addSubview:storeLabel];
        storeLabel.tag = 2222;
        
        
        //7、收藏
        [_collectionBtn removeFromSuperview];
        _collectionBtn = nil;
        
        _collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectionBtn.frame = CGRectMake(rankheadView.width - 90*SCREEN_W_SP, rankheadView.height / 4, 70 *SCREEN_W_SP, rankheadView.height / 2);
        _collectionBtn.tag = 1010;
        _collectionBtn.layer.cornerRadius = 5;
        _collectionBtn.layer.borderColor = [UIColor colorWithHex:0xba2932].CGColor;
        _collectionBtn.layer.borderWidth = 1;
        if (_indexRankOrCollection == 1) {
            [_collectionBtn setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else{
            [_collectionBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        [_collectionBtn setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
        _collectionBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _collectionBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_collectionBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [rankheadView addSubview:_collectionBtn];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}



-(void)addFooterRefresh{
    
    @try {
        
#pragma mark    重新加载数据
        _isLoadMOre = YES;
        //将_indexOfPageNum的值传给服务器
        
        //假设下面的方法是网络请求返回后调用的代码
        if (_indexOfPageNum == 1) {
            [_rankDataSourceArray removeAllObjects];
        }
        
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

#pragma mark - 请求成功后改变所有按钮文字和状态
-(void)changeAllButtonTextAndStatusWith:(NSDictionary *)dic{

    @try {
        
        NSArray *valueArr = dic[@"data"][@"value"];
        
        //所有按钮置为被点击状态
        for (int i = 0; i < _rankDataSourceArray.count ; i ++) {
            
            UIButton *singleBtn = (UIButton *)[_tableView viewWithTag:1200 + i];
            [singleBtn setTitle:valueArr[0][@"favoriteName"] forState:UIControlStateNormal];
            [singleBtn setTitleColor:Color(167, 167, 167) forState:UIControlStateNormal];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - _scrollView回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    @try {
       
        if (scrollView == moveView) {
            
            CGPoint point = scrollView.contentOffset;
            
            //65像素的偏移量处于按钮中心
            if (point.x > 65) {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    scrollView.contentOffset = CGPointMake(110 *SCREEN_W_SP, 0);
                }];
                
            }else if (point.x <= 65)
            {
                
                [UIView animateWithDuration:0.2 animations:^{
                    
                    scrollView.contentOffset = CGPointMake(0, 0);
                }];
                
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 排序按钮
-(void)rankCutBtnClick:(UIButton *)button{
    
    @try {
        
        [self.tfText resignFirstResponder];
        _isLoadMOre = NO;
        
        _rankCutString = @"aa";
        //selectTag可判断用户点击的是第几个sortTitle
        NSInteger selectTag = button.tag - 700;
        
        //    UIButton * upBtn = (UIButton *)[rankheadView viewWithTag:500 + selectTag];
        //    UIButton * downBtn = (UIButton *)[rankheadView viewWithTag:600 +selectTag];
        UIButton * upBtn   =  _upTriangleButtonArray[selectTag];
        
        UIButton * downBtn =  _downTriangleButtonArray[selectTag];
        
        
        if (selectTag == 0) {
            
            if (twoW > 0) {
                oneW = 0;
                twoW = 0;
            }
            
            
            for (NSInteger i = 0; i < _upTriangleButtonArray.count; i++)
            {
                UIButton * button = _upTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
            }
            
            for (NSInteger i = 0; i < _downTriangleButtonArray.count; i++)
            {
                UIButton * button = _downTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
            }
            
            
            //        button.selected = !button.selected;
            if (oneW%2 == 0) {
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                
                _orderCode = @"D";
                
            }else{
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                
                _orderCode = @"A";
                
            }
            
            oneW ++;
        }
        else if (selectTag == 1){
            
            if (oneW > 0) {
                twoW = 0;
                oneW = 0;
            }
            
            for (NSInteger i = 0; i < _upTriangleButtonArray.count; i++)
            {
                UIButton * button = _upTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
            }
            
            for (NSInteger i = 0; i < _downTriangleButtonArray.count; i++)
            {
                UIButton * button = _downTriangleButtonArray[i];
                [button setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
            }
            
            
            //        button.selected = !button.selected;
            if (twoW%2 == 0) {
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                
                _orderCode = @"D";
                
            }else{
                
                [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                
                _orderCode = @"A";
                
            }
            
            twoW ++;
        }
        
        
        NSArray *titleArr = self.enterAndLeftDataDic[@"data"][@"sortTitle"];
        _orderPir = titleArr[selectTag][@"piCode"];
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        //请求接口
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 020101接口请求
-(void)request020101{
    
    @try {
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                NSString *title_org_code = _temp;
                
                NSString *subhead_org_code;
                if (_enterAndLeftDataDic) {
                    
                    NSArray *subheadSidebarArr = _enterAndLeftDataDic[@"data"][@"subheadSidebar"];
                    NSMutableArray *subheadCodeArr = [NSMutableArray new];
                    for (int i = 0; i < subheadSidebarArr.count; i ++) {
                        
                        [subheadCodeArr addObject:subheadSidebarArr[i][@"code"]];
                    }
                    
                    subhead_org_code = subheadCodeArr[_indexSubHeadBar];
                }else{
                    
                    subhead_org_code = title_org_code;
                }
                
                NSString *tabs_code = [NSString stringWithFormat:@"%ld",(long)_indexRankOrCollection];
                
                NSString *pageSize = @"";
                
                if (_isLoadMOre) {
                    
                    
                }else{
                    
                    _indexOfPageNum = 1;
                }
                NSString *pageNum = [NSString stringWithFormat:@"%ld",(long)_indexOfPageNum];
                
                
                NSString *timeLevel = [NSString stringWithFormat:@"%ld",(long)_indexDayWeekMonthYear];
                
                NSDictionary * dataDic  =  [NSDictionary dictionaryWithObjectsAndKeys:
                                            [AppDatas sharedDatas].userCode, @"user_code",
                                            title_org_code,@"title_org_code",
                                            subhead_org_code,@"subhead_org_code",
                                            
                                            tabs_code,@"tabs_code",
                                            _piaCode,@"pia_code",
                                            //                                 P100100011
                                            _orderPir,@"order_pir",  //排序
                                            _orderCode,@"order_code",
                                            pageSize,@"page_size",
                                            pageNum,@"page_num",
                                            self.tfText.text,@"search_value",
                                            
                                            [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd,@"start_date",
                                            [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd,@"end_date",
                                            timeLevel,@"time_level",
                                            [NSString stringWithFormat:@"%ld",(long)_storeDrill_type],@"drill_type",
                                            nil];
               
                _subHeadOrgCode = subhead_org_code;
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreBoardSort"
                             dataParameters:dataDic      withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[HUDHelper getInstance] hideHUD];//隐藏提示框
                            
                            [UIView animateWithDuration:0.4 animations:^{
                                
                            _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                                
                            scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                
                            }completion:^(BOOL finished){
                                
                                [twoAnimationView stopAnimating1];
                                
                                [animationView stopAnimating1];
                            }];
                            
                           //底部结束上拉加载更多
                            [_tableView  footerEndRefreshing];
                                            
                            [self.tfText resignFirstResponder];
                                            
                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                            if ([responseDic[@"data"][@"sort"][@"data"]count]  == 0  && _indexOfPageNum > 1) {
                                                    
                            [[HUDHelper getInstance]showErrorTipWithLabel:@"暂无更多店铺"];
                    }
                   else{
                                                    
                    if (_storeDrill_type == 1 || _storeDrill_type == 2) {
                                                        
                    if ([responseDic[@"data"][@"sort"][@"data"]count]  == 0 && [responseDic[@"data"][@"subheadSidebar"]count]  == 0) {
                                            
                            _indexOfPageNum = _recoredIndexOfPageNum;
                                                            
                            _storeDrill_type = 0;
                                                            
                                                            
                                return;
                   }
                   else if([responseDic[@"data"][@"subheadSidebar"]count] > 0){
                       
                       _subHeadOrgCode = responseDic[@"data"][@"subheadSidebar"][0][@"code"];
                       
                        [self.delegate transMitheadTitle:_subHeadOrgCode nameString:responseDic[@"data"][@"subheadSidebar"][0][@"name"]];

                   }
                        
                    _indexSubHeadBar = 0;
                                                        
                                                        //  [self.enterAndLeftDataDic re]
                        
                NSMutableDictionary * enterDic = [[NSMutableDictionary alloc] initWithDictionary:self.enterAndLeftDataDic[@"data"]];
                                                        
                                                        
               [enterDic removeObjectForKey:@"subheadSidebar"];
                        
               [enterDic setObject:responseDic[@"data"][@"subheadSidebar"] forKey:@"subheadSidebar"];
                                                        
               [self.enterAndLeftDataDic removeObjectForKey:@"data"];
                                                        
               [self.enterAndLeftDataDic setObject:enterDic forKey:@"data"];
                                                        //   [self.enterAndLeftDataDic[@"data"] addObject:responseDic[@"data"][@"subheadSidebar"]];
                                                        
               [self refreshThisViewAndDatas];
            }
                                                    
                    
                    NSMutableDictionary * enterDic = [[NSMutableDictionary alloc] initWithDictionary:self.enterAndLeftDataDic[@"data"]];
                                                    
                                                    
                    [enterDic removeObjectForKey:@"sortTitle"];
                    [enterDic setObject:responseDic[@"data"][@"sortTitle"] forKey:@"sortTitle"];
                                                    
                    [self.enterAndLeftDataDic removeObjectForKey:@"data"];
                                                    
                    [self.enterAndLeftDataDic setObject:enterDic forKey:@"data"];
                                                    
                    if ([_rankCutString isEqualToString:@"aa"]) {
                                                        
                    
                    }
                    else{
                        
                        [self createTwoRankView];
                        
                    }
                       
                        self.secondDic = responseDic;
                                                    
                                                    //               footer.hidden = NO;
                                                    
                        if (_isLoadMOre) {
                                                        
                        [self loadMoreDataWith:responseDic];
                                                        
                                                        
                    }else{
                                                        
                                                        
                    [self analysisDataWith020101:self.secondDic];
                                                        
                                                        
                    }
                    _indexOfPageNum ++;
                                                    
                    _recoredIndexOfPageNum = _indexOfPageNum;
                    }
                                                
                                                
                                            }else{
                                                
                                                HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
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
                                           
                                            [UIView animateWithDuration:0.4 animations:^{
                                                
                                                _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                                                
                                                scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                                
                                            }completion:^(BOOL finished){
                                                
                                                [twoAnimationView stopAnimating1];
                                                
                                                [animationView stopAnimating1];
                                            }];
                                            
                                            [_tableView footerEndRefreshing];
                                            
                                            _tableView.contentOffset = CGPointZero;
                                            if (_indexOfPageNum == 1) {
                                                _rankDataSourceArray = nil;
                                            }
                                            [_tableView reloadData];
                                            
                                            
                                            if (error.code == -1001) {
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                            }
                                            else if(error.code == -1011){
                                                
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                            }
                                            else{
                                                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                            }
                                            
                                        });
                                    }];
                
            });
            
        }
        else{
            
            _tableView.contentOffset = CGPointZero;
            [_tableView footerEndRefreshing];
            
            if (_indexOfPageNum == 1) {
                _rankDataSourceArray = nil;
            }
            
            [_tableView reloadData];
            
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)loadMoreDataWith:(NSDictionary *)dic{

    @try {
        
        NSMutableArray *nextPageArray= [dic[@"data"][@"sort"][@"data"] mutableCopy];
        if (nextPageArray.count == 0) {
            
            //    footer.hidden = YES;
            
            //        [footer setTitle:@"没有更多了" forState:MJRefreshStateIdle];
            //        [footer setTitle:@"没有更多" forState:MJRefreshStateNoMoreData];
            
            
        }else{
            
            for (int i = 0 ; i < nextPageArray.count; i ++) {
                
                [_rankDataSourceArray addObject:[nextPageArray objectAtIndex:i]];
                //            [_favoriteCodeArray addObject:nextPageArray[i][@"favoriteCode"]];
            }
            
            
            [self refreshRankTableViewWith:_rankDataSourceArray];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)analysisDataWith020101:(NSDictionary *)dic{

    @try {
        
        if (!dic) {
            return;
        }
        
        _rankDataSourceArray = nil;
        _rankDataSourceArray = [NSMutableArray new];
        _rankDataSourceArray = [dic[@"data"][@"sort"][@"data"] mutableCopy];
        
        [self refreshRankTableViewWith:_rankDataSourceArray];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)refreshSingleCollectWith:(NSDictionary *)dic{
    
    @try {
        
        NSString *storeCode = [NSString stringWithFormat:@"%@",_rankDataSourceArray[_indexPath][@"storeCode"]];
        
        NSArray *backArr = dic[@"data"][@"value"];
        for (int i = 0; i < backArr.count; i ++) {
            
            if ([backArr[i][@"storeCode"] isEqualToString:storeCode]){
                
                UIButton *button = (UIButton *)[self viewWithTag:_singleBtnTag];
                [button setTitle:backArr[i][@"favoriteName"] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    @try {
        
         return _rankDataSourceArray.count;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
   

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
       
        TableViewCellForStoreRank *cell = [tableView dequeueReusableCellWithIdentifier:@"storeTableViewCell"];
        
        UILabel *storeNameLabel = (UILabel *)[self viewWithTag:2222];
        NSArray *sortTitleArray = _enterAndLeftDataDic[@"data"][@"sortTitle"];
        cell.storeNameLabel.frame = CGRectMake(storeNameLabel.x, 0, storeNameLabel.width + 30 *SCREEN_W_SP, _cellHeight *SCREEN_H_SP) ;
        
        //第一列内容（排行列）
        if (indexPath.row == 0) {
            cell.rankOrderLabel.backgroundColor = Color(177, 36, 44);
            cell.rankOrderLabel.textColor = [UIColor whiteColor];
            cell.rankOrderLabel.frame = CGRectMake(25, cell.height / 4 *SCREEN_H_SP, 20 , 20);
            cell.rankOrderLabel.layer.cornerRadius = cell.rankOrderLabel.width / 2;
        }else if (indexPath.row == 1) {
            cell.rankOrderLabel.backgroundColor = Color(255, 108, 42);
            cell.rankOrderLabel.textColor = [UIColor whiteColor];
            cell.rankOrderLabel.frame = CGRectMake(25, cell.height / 4 *SCREEN_H_SP, 20 , 20);
            cell.rankOrderLabel.layer.cornerRadius = cell.rankOrderLabel.width / 2;
            
        }else if (indexPath.row == 2) {
            cell.rankOrderLabel.backgroundColor = Color(255, 164, 36);
            cell.rankOrderLabel.textColor = [UIColor whiteColor];
            cell.rankOrderLabel.frame = CGRectMake(25, cell.height / 4 *SCREEN_H_SP, 20 , 20);
            cell.rankOrderLabel.layer.cornerRadius = cell.rankOrderLabel.width / 2;
        }else{
            cell.rankOrderLabel.textColor = Color(123, 123, 123);//第四行及以下
            cell.rankOrderLabel.backgroundColor = [UIColor clearColor];
            cell.rankOrderLabel.layer.cornerRadius = 0;
            cell.rankOrderLabel.frame = CGRectMake(20, cell.height / 4 *SCREEN_H_SP, 30, 20);
        }
        cell.rankOrderLabel.clipsToBounds = YES;
        
        
        @try {
            
            //cell默认最多2个排序
            if (sortTitleArray.count == 1){
                
                cell.thirdQueueLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120 *SCREEN_W_SP + 15 *SCREEN_W_SP, 0, 120 *SCREEN_W_SP, _cellHeight *SCREEN_H_SP);
                
                //        cell.thirdQueueLabel.backgroundColor = Color(240, 240, 240);
                
                if (_rankDataSourceArray[indexPath.row][@"PI"][0][@"value"]) {
                    cell.thirdQueueLabel.text = [NSString stringWithFormat:@"%@", _rankDataSourceArray[indexPath.row][@"PI"][0][@"value"]];
                }
                
                [cell.fourthQueueLabel removeFromSuperview];
                
            }else if (sortTitleArray.count == 2) {
                
                cell.thirdQueueLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - (120 + 80) *SCREEN_W_SP + 15 *SCREEN_W_SP, 0, 120 *SCREEN_W_SP, _cellHeight *SCREEN_H_SP);
                cell.fourthQueueLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80 *SCREEN_W_SP + 15 *SCREEN_W_SP, 0, 65 *SCREEN_W_SP, _cellHeight *SCREEN_H_SP);
                
                NSMutableArray *orderData = [[NSMutableArray alloc] initWithArray:_rankDataSourceArray[indexPath.row][@"PI"]];
                if (orderData) {
                    cell.thirdQueueLabel.text = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"PI"][0][@"value"]];
                }else{
                    cell.thirdQueueLabel.text = @"";
                }
                if (orderData.count > 1) {
                    cell.fourthQueueLabel.text = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"PI"][1][@"value"]];
                }else{
                    cell.fourthQueueLabel.text = @"";
                }
            }
            
        } @catch (NSException *exception) {
            
             [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
            
            [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
            
        } @finally {
            
           
        }
        
        
        //测试的数据
        //    cell.goodsImgView.image = [UIImage imageNamed:@"img_排名页面收藏提示"];
        //    cell.goodsName.text = @"FXG5677879";
        //    cell.third.text = @"355";
        //    cell.fourth.text = @"90%";
        //    cell.fifth.text = @"55";
        //    cell.sixth.text = @"23";
        
        cell.rankOrderLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        
        cell.storeNameLabel.text = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"storeName"]];
        //    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_rankDataSourceArray[indexPath.row][@"productImage"]]];
        //    cell.goodsImgView.image = [UIImage imageWithData:data];
        
        UIButton *btn = (UIButton *)[self viewWithTag:1010];
        cell.collectBtn.frame = CGRectMake(_tableView.width - 80 *SCREEN_W_SP, 0, btn.width, _cellHeight *SCREEN_H_SP);
        cell.collectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        _indexPath = indexPath.row;
        
        cell.collectBtn.tag = 1200 + _indexPath;
        
        //若服务器返回已收藏，则按钮内部文字颜色直接设置为点击过的颜色
        if (_indexRankOrCollection == 1) {
            
            if ([_favoriteCodeArray[indexPath.row] isEqualToString:@"1"])
            {
                [cell.collectBtn setTitle:@"已收藏" forState:UIControlStateNormal];
                [cell.collectBtn setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                cell.collectBtn.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
            }else{
                
                [cell.collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
                [cell.collectBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
                cell.collectBtn.layer.borderColor = [UIColor colorWithHex:0x888888].CGColor;
                
            }
        }else{
            
            [cell.collectBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
            [cell.collectBtn setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            cell.collectBtn.layer.borderColor = [UIColor colorWithHex:0x888888].CGColor;
        }
        
        
        [cell.collectBtn addTarget:self action:@selector(collectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
        
        if (_storeKeyBoradBool == YES) {
            [self.tfText resignFirstResponder];
            self.tfText.text = @"";
            _storeTouchSeachBool = NO;
            return;
        }
        
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
        
        [[NSUserDefaults standardUserDefaults] setObject:[AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd forKey:@"DateBeforePush"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_temp forKey:@"TempBeforePush"];
        
        ThreeDetailViewController * detail = [ThreeDetailViewController new];
        
        detail.delegate = self;
        detail.orgCode = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"storeCode"]];
        detail.storeName = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"storeName"]];
        detail.titleCode = _temp;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"DianPuToProductDetailStoreCode" object:_rankDataSourceArray[indexPath.row][@"storeCode"] ];
        
        [tempAppDelegate.mainNavigationController pushViewController:detail animated:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"storeNumberString"];
        
        [self.tfText resignFirstResponder];

        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)collectBtnClick:(UIButton *)button{
    
    @try {
        
        if (![button.titleLabel.text isEqualToString:@"已收藏"] && [_tableView visibleCells].count > 0) {
            
            NSString *favoriteCode = _indexRankOrCollection == 1 ? @"0" : @"1" ;
            NSString *storeCode;
            
            if ([button.titleLabel.text containsString:@"全部"]) {
                
                for (int i = 0; i < _rankDataSourceArray.count; i++) {
                    
                    if (i == 0) {
                        
                        storeCode = [NSString stringWithFormat:@"%@",_rankDataSourceArray[i][@"storeCode"]];
                    }else{
                        
                        storeCode = [NSString stringWithFormat:@"%@,%@",storeCode,_rankDataSourceArray[i][@"storeCode"]];
                    }
                }
            }else{  //单个按钮
                
                NSIndexPath *indexPath = [self getIndexPathForButtonOnCell:button classOfCell:[TableViewCellForStoreRank class] tableView:_tableView];
                
                if (indexPath != nil) {
                    
                    storeCode = [NSString stringWithFormat:@"%@",_rankDataSourceArray[indexPath.row][@"storeCode"]];
                    
                }
            }
            
            [self request0202With:button storeCode:storeCode favoriteCode:favoriteCode];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(NSIndexPath *)getIndexPathForButtonOnCell:(UIButton *)button classOfCell:(Class)class tableView:(UITableView *)tableView{

    @try {
     
        NSIndexPath *indexPath = [tableView indexPathForCell:(UITableViewCell *)[[button superview] superview]];
        
        return indexPath;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}





-(void)request0202With:(UIButton *)button storeCode:(NSString *)storeCode favoriteCode:(NSString *)favoriteCode{
    
    @try {
        
        BOOL netStatus=NO;
        netStatus = [CommonTools isConnectionAvailable:self];
        
        if (netStatus) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                
                [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.StoreBoardCollectSwitch"
                             dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                             
                                             [AppDatas sharedDatas].userCode,@"user_code",
                                             storeCode,@"store_array",
                                             favoriteCode,@"favorite_code",
                                             
                                             nil]
                                  withCache:YES
                                    success:^(NSDictionary *responseDic) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                            //                            DLogObject(responseDic);
                                            
                                            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                                
                                                self.collectionDic = responseDic;
                                                
                                                
                                                [self collectButtonEndTouched:button];
                                                
                                                [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                                
                                                
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
            
        }
        else{
            [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)collectButtonEndTouched:(UIButton *)button{

    @try {
       
        if (_indexRankOrCollection == 1) {
            
            if ([button.titleLabel.text isEqualToString:@"全部收藏"]) {
                
                _favoriteCodeArray = [NSMutableArray new];
                
                for (int i = 0; i < _rankDataSourceArray.count; i ++) {
                    
                    
                    [_favoriteCodeArray addObject:[NSString stringWithFormat:@"%@",@"1"]];
                    
                }
                
                [_tableView reloadData];
                
                
            }else{
                
                NSIndexPath *indexPath = [self getIndexPathForButtonOnCell:button classOfCell:[TableViewCellForStoreRank class] tableView:_tableView];
                
                if (indexPath != nil) {
                    
                    [button setTitle:@"已收藏" forState:UIControlStateNormal];
                    [button setTitleColor:[UIColor colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
                    button.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
                    
                }
            }
            
            
            
        }else{
            
            NSMutableArray <NSIndexPath *> *array = [NSMutableArray new];
            
            if ([button.titleLabel.text isEqualToString:@"全部取消"]) {
                
                for (int i = 0; i < _rankDataSourceArray.count; i ++) {
                    
                    [array addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                }
                
                _rankDataSourceArray = [NSMutableArray arrayWithCapacity:0];
                
            }else{
                
                NSIndexPath *indexPath = [self getIndexPathForButtonOnCell:button classOfCell:[TableViewCellForStoreRank class] tableView:_tableView];
                
                if (indexPath != nil) {
                    
                    [_rankDataSourceArray removeObjectAtIndex:indexPath.row];
                    [_favoriteCodeArray removeObjectAtIndex:indexPath.row];
                    [array addObject:indexPath];
                    
                }
                
            }
            
            [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)rankHeadViewTap:(UITapGestureRecognizer *)tap{
    
    [self.tfText resignFirstResponder];
}

-(void)subHeadSideBarTap:(UITapGestureRecognizer *)tap{
    
    [self.tfText resignFirstResponder];
}


- (void)testPan:(UIPanGestureRecognizer *)gesture {
   
    @try {
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            //开始点击
            if (moveView.contentOffset.x <= 0) {
                _isStartOnZero = YES;
                _startPanX = [gesture locationInView:moveView].x;
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
                    CGPoint point = [gesture locationInView:moveView];
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark - 切换subHeadBar
- (void)headBarView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
        
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _storeTouchSeachBool = NO;
        }
        
        if (_storeKeyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_storeTouchSeachBool == NO) {
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
            
            // self.tfText.frame = CGRectMake(10* SCREEN_W_SP, 135*SCREEN_H_SP + 40* SCREEN_H_SP, SCREEN_WIDTH - 20* SCREEN_W_SP, 30* SCREEN_H_SP);
            
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
        
        _storeDrill_type = 0;
        _indexSubHeadBar = index;
        
        _isLoadMOre = NO;
        _indexOfPageNum = 1;
        //请求并更新数据源
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 切换日周月年
- (void)bigAndTimeView:(BigAndTimeView *)bigAndTimeView index:(NSInteger)index{
    
    @try {
       
        NSString *textStr = [self.tfText.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (textStr.length == 0) {
            _storeTouchSeachBool = NO;
        }
        
        if (_storeKeyBoradBool == YES) {
            [self.tfText resignFirstResponder];
        }
        
        if (_storeTouchSeachBool == NO) {
            self.tfText.text = @"";
        }
        
        _indexDayWeekMonthYear = index + 1;
        _isLoadMOre = NO;
        _indexOfPageNum = 1;
        [self.tfText resignFirstResponder];
        _storeDrill_type = 0;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        //请求并更新数据源
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 搜索框
#pragma mark - 点击Return键的时候，（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    @try {
       
        [textField resignFirstResponder];
        
        _storeTouchSeachBool = YES;
        
        _isLoadMOre = NO;
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
        
        return YES;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    @try {
        
        _storeTouchSeachBool = NO;
        
        self.tfText.text = @"";
        _indexOfPageNum = 1;
        _isLoadMOre = NO;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
        return YES;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 切换排行、收藏夹
-(void)piecewiseView:(SegmentView *)piecewiseView index:(NSInteger)index{
    
    @try {
        
        _indexRankOrCollection = index + 1;
        _isLoadMOre = NO;
        _storeDrill_type = 0;
        
        if (index == 0) {
            [_collectionBtn setTitle:@"全部收藏" forState:UIControlStateNormal];
        }else if (index == 1){
            [_collectionBtn setTitle:@"全部取消" forState:UIControlStateNormal];
        }
        _indexOfPageNum = 1;
        //请求并更新数据源
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
       
        if (scrollView == scrollView1) {
            
            [animationView startAnimation];
            
        }
        else if (scrollView == _tableView){
            [twoAnimationView startAnimation];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
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
       
        if (scrollView1) {
            
            if (scrollView == scrollView1) {
                
                [animationView  stopAnimating];
                
            }
            else if (scrollView == _tableView){
                [twoAnimationView  stopAnimating];
            }
            
            
            if (scrollView1.contentOffset.y < -25 || _tableView.contentOffset.y < -25) {
                
                if (scrollView == _tableView) {
                    
                     _tableView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                    
                    [twoAnimationView startAnimation1];
                    
                    _leftSelectButtonBool = YES;
                    _indexOfPageNum = 1;
                    _isLoadMOre = NO;
                    [self request020101];
                }
                else{
                    
                     scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                    
                    [animationView startAnimation1];
                   
                    _leftSelectButtonBool = YES;
                    _indexOfPageNum = 1;
                    _isLoadMOre = NO;
                    [self request020101];
                    
                }
                
            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)selectedLeftSideBar:(NSDictionary *)dict {
    
    @try {
        
        _rankCutString = @"ww";
        // _storeDrill_type = 0;
        //左侧边栏index
        _piaCode = [NSString stringWithFormat:@"%@",dict[@"piaCodeToDianPu"]];
        _indexOfLeft = [dict[@"indexOfLeft"] integerValue];
        _indexOfPageNum = 1;
        _leftSelectButtonBool = YES;
        
        _orderCode = @"";
        _orderPir = @"";
        
      //  [_rankDataSourceArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:_piaCode forKey:@"storePiaCode"];
        
        _isLoadMOre = NO;
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        [self request020101];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺排行  DianPuView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

@end


#pragma mark -
#pragma mark -





