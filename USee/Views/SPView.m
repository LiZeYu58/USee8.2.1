//
//  SPView.m
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "SPView.h"
#import "TableViewCellForShangPinCell.h"
#import "LOSHelper.h"
#import "AppDelegate.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "StoreDetailProductDetailViewController.h"

#import "MBProgressHUD.h"

#import "AnimationView.h"

#import "LeftSortsViewController.h"

#define colorText [UIColor colorWithHex:0x888888]


@interface SPView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate, MBProgressHUDDelegate,BigBtnViewDelegate>
{
    UITableView *_tableView;
    
    UIScrollView * scrollView1;
    
    NSInteger firstCreate;
    
    AnimationView * animationView;
    TwoAnimationView * twoAnimationView;
    
    UIView *dataView;
    UIView *headView;
    
    BigBtnView * _bigBtnView;
    
    NSMutableDictionary *operationCache;    //图像筛选器
    NSMutableDictionary *imageCache;    //图像缓存
    NSOperationQueue *downloadQueue;    //多线程队列
    NSInteger _indexOfLeft;
    
    
    NSString * _titleCode; // titleCode
    
    NSString * PiaCode;
    
    NSString * IndexOfLeft;
    MBProgressHUD *HUD;
    //  LDRefreshAutoGifFooter *footer;
    NSInteger _indexOfPageNum;
    BOOL _isLoadMore;
    NSInteger _timeLevel;
}

@end


@implementation SPView

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        _timeLevel = 1;
        firstCreate = 1;
        
        downloadQueue = nil;
        imageCache = nil;
        operationCache = nil;
        
        downloadQueue = [NSOperationQueue new];
        imageCache = [NSMutableDictionary new];
        operationCache  = [NSMutableDictionary new];
        _order_arrayStr = @"D";
        _orderPir = @"";
        _indexOfPageNum = 1;
        
        [self createUI];
        
        
        //        LeftToDianPuDetailShangPin
        //接收侧边栏传过来的piaCode
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivePiaCodeArrayCilck:) name:@"LeftToDianPuDetailShangPin" object:nil];
//        
        
        //orgcode
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShangPin:) name:@"ShangPin" object:nil];
        
        
        //日历
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jjt2:) name:@"jjt2" object:nil];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    @try {
     
        self.tfText.text = @"";
        [_tfText resignFirstResponder];
        _indexOfPageNum = 1;
        [self request020401];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

//通知方法
- (void)jjt2:(NSNotification *)notification {
    
    @try {
     
        [AppDatas sharedDatas].selectFromDate = notification.object[@"fromDate"];
        [AppDatas sharedDatas].selectToDate = notification.object[@"toDate"];
        _indexOfPageNum = 1;
        [self refreshDatasWithCache:YES WithCode:_storeCode];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

//通知方法
- (void)goods:(NSDate *)fromDate :(NSDate *)toDate{
    
    @try {
        
        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 接口请求过渡方法
- (void)refreshDatasWithCache:(BOOL)isUseCache WithCode:(NSString *)Code{
    
    @try {
     
        [self requestDatasFromDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"]
                            toDateStr:[LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"]
                            withCache:isUseCache
                             WithCode:Code];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


//通知方法
-(void)ShangPin:(NSNotification *)notif{
    
    @try {
     
        _storeCode = [notif object];
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

//通知方法
-(void)receiveGoodsCode:(NSString *)orgCode WithTitleCode:(NSString *)titleCode{
    
    @try {
    
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情商品 SPView" forKey:@"crashTheClassName"];
        
        _storeCode = orgCode;
        
        _titleCode = titleCode;
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
   
}


//通知方法
-(void)receivePiaCodeArrayCilck:(NSNotification *)notif{
    
    @try {
     
        _pia_code = notif.userInfo[@"piaCode"];
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        _indexOfLeft = [notif.userInfo[@"indexOfLeft"] integerValue];
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 通知方法
-(void)shangpin:(NSString *)piacode :(NSString *)slideIndex{
    
    @try {
     
        _pia_code = piacode;
        
        _indexOfLeft = [slideIndex integerValue];
        _indexOfPageNum = 1;
        [self refreshDatasWithCache:YES WithCode:_storeCode];

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 请求接口 0204
- (void)requestDatasFromDateStr:(NSString *)fromDateStr toDateStr:(NSString *)toDateStr withCache:(BOOL)isUseCache WithCode:(NSString *)store_code {
    
    @try {
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            NSString *piaCode;
            if (self.dataDic) {
                
                NSArray *subheadSidebarArr = [[NSArray alloc] initWithArray:self.dataDic[@"data"][@"leftSidebar"]];
                NSMutableArray *subheadCodeArr = [NSMutableArray new];
                for (int i = 0; i < subheadSidebarArr.count; i ++) {
                    
                    [subheadCodeArr addObject:subheadSidebarArr[i][@"piaCode"]];
                }
                
                if (subheadCodeArr.count > 0) {
                    
                     piaCode = subheadCodeArr[_indexOfLeft];
                }
               
            }else{
                
                piaCode = @"";
            }
            
            NSString *orderArrayStr;
            if (_order_arrayStr) {
                
                orderArrayStr = _order_arrayStr;
            }else{
                
                orderArrayStr = @"";
            }
            
            
            NSString * orderPir = @"";
            
            
            NSString *pageSize = @"";
            
            NSString *pageNum = @"1";
            
            NSDictionary * dataDic  = [NSDictionary dictionaryWithObjectsAndKeys:[AppDatas sharedDatas].userCode,@"user_code",
                                       store_code,@"store_code",
                                       piaCode,@"pia_code",
                                       
                                       _titleCode,@"title_org_code",
                                       
                                       orderPir,@"order_pir",   // 点击排序钮
                                       orderArrayStr,@"order_code",  //点击排序钮
                                       
                                       pageSize,@"page_size",
                                       pageNum,@"page_num",
                                       
                                       fromDateStr,@"start_date",
                                       toDateStr,@"end_date",[NSString stringWithFormat:@"%ld",(long)_timeLevel],@"time_level", nil];
            
            
            [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.StoreDetailProductAccess" dataParameters:dataDic
                             withCache:YES
                               success:^(NSDictionary *responseDic) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                       
                                       
                                       if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                           
                                           self.dataDic = responseDic;
                                           
                                           _indexOfPageNum ++;
                                           
                                           [animationView stopAnimating1];
                                           
                                           scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                           
                                           
                                           [self analysis0204Data];
                                           
                                           [self refreshOrderButtonInHeadviewAndTableView];
                                           
                                        
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
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求成功后解析数据
-(void)analysis0204Data{
    
    @try {
        _dataSourceArr = nil;
        _sortTitleNameArray = nil;
        _orderTypesArray = nil;
        _piCodeArray = nil;
        
        _dataSourceArr = [[NSMutableArray alloc] initWithArray:self.dataDic[@"data"][@"sortList"]];
        _sortTitleNameArray = [NSMutableArray new];
        _orderTypesArray = [NSMutableArray new];
        _piCodeArray = [NSMutableArray new];
        
        //排序的 Name
        NSArray *sortTitleArr = self.dataDic[@"data"][@"sortTitle"];
        if (sortTitleArr) {
            
            for (int i = 0; i < sortTitleArr.count; i ++) {
                
                if ([sortTitleArr[i][@"ySite"] isEqualToString:[NSString stringWithFormat:@"%d",i + 1]]) {
                    
                    NSString *name = sortTitleArr[i][@"siteName"];
                    [_sortTitleNameArray addObject:name];
                    
                    NSString *orderType = sortTitleArr[i][@"orderType"];
                    [_orderTypesArray addObject:orderType];
                    
                    [_piCodeArray addObject:sortTitleArr[i][@"piCode"]];
                }
            }
        }
        
        
        //侧边栏已由LeftSortsViewController处理
        NSMutableArray *leftNameArr = [NSMutableArray new];
        NSMutableArray *piaCodeArr = [NSMutableArray new];
        NSArray *leftSidebarArr = self.dataDic[@"data"][@"leftSidebar"];
        if (leftSidebarArr) {
            for (int i = 0; i < leftSidebarArr.count; i ++) {
                
                [leftNameArr addObject:leftSidebarArr[i][@"nameArray"]];
                
                [piaCodeArr addObject:leftSidebarArr[i][@"piaCode"]];
                
            }
        }
        
        
        NSString * indexCollect = [NSString stringWithFormat:@"%ld",(long)_indexOfLeft];
        
        //发送给左侧边栏的数组
        NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:leftNameArr,@"spleftArray",piaCodeArr,@"spleftPiaCode",indexCollect,@"SPindex",nil];
        NSNotification *notification =[NSNotification notificationWithName:@"spLeftSidebarArray" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        //数据源
        //  _dataSourceArr = [self.dataDic[@"data"][@"sortList"] mutableCopy];
        
        _pia_code = _pia_code == nil ? piaCodeArr[0] : _pia_code;  //默认侧边栏code
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)createUI{
    
    @try {
     
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [tempAppDelegate.LeftSlideVC setCurrentLeftViewType:LeftViewTypeGoods];
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:LeftViewTypeGoods];
        
        [self createHeadUI];
        
        //  [self refreshOrderButtonInHeadviewAndTableView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 创建UI
-(void)createHeadUI{
    
    @try {
        [scrollView1 removeFromSuperview];
        scrollView1 = nil;
        
        scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
        scrollView1.showsVerticalScrollIndicator = NO;
        // scrollView1.userInteractionEnabled = NO;
        scrollView1.delegate =self;
        scrollView1.contentSize = CGSizeMake(0, self.height);
        scrollView1.bounces = NO;
        // scrollView1.alwaysBounceVertical = YES;
        [self addSubview:scrollView1];
        
        [animationView  removeFromSuperview];
        animationView  = nil;
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 100)];
        
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [animationView Animation];
        
        [animationView Animation1];
        
        [scrollView1 addSubview:animationView];
        
        
#pragma mark -     日周月年
        [_bigBtnView  removeFromSuperview];
        _bigBtnView  = nil;
        
       
        if (SCREEN_HEIGHT == 812) {
             _bigBtnView = [[BigBtnView alloc]initWithFrame:CGRectMake(0, 89, SCREEN_WIDTH, 50 * SCREEN_H_SP)];
        }
        else{
             _bigBtnView = [[BigBtnView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50 * SCREEN_H_SP)];
        }
        NSArray *arr = @[@"日",@"周",@"月",@"年"];
        [_bigBtnView showBigBtnView:arr];
        _bigBtnView.delegate = self;
        [scrollView1 addSubview:_bigBtnView];
        
#pragma mark -     搜索框
        [self.tfText  removeFromSuperview];
        self.tfText  = nil;
        
        self.tfText = [[UITextField alloc]init];
        
        self.tfText.frame = CGRectMake(10 * SCREEN_W_SP, [LOConst refY:_bigBtnView p:70], SCREEN_WIDTH - 20 * SCREEN_W_SP, 30 * SCREEN_H_SP);
        self.tfText.delegate = self;
        self.tfText.borderStyle = UITextBorderStyleRoundedRect;
        self.tfText.returnKeyType = UIReturnKeySearch;
        self.tfText.clearButtonMode = UITextFieldViewModeAlways;
        [scrollView1 addSubview:self.tfText];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20 *SCREEN_H_SP, 30 *SCREEN_H_SP)];
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10 *SCREEN_W_SP);
        self.tfText.leftView = button;
        self.tfText.leftViewMode = UITextFieldViewModeAlways;
        self.tfText.placeholder = @"编号";
        
        [scrollView1 addSubview:self.tfText];
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 刷新页面
-(void)refreshOrderButtonInHeadviewAndTableView{
    
    @try {
     
        [dataView removeFromSuperview];
        dataView = nil;
        
        [_tableView removeFromSuperview];
        _tableView = nil;
        
        for (int i = 0; i < _sortTitleNameArray.count; i ++) {
            
            UIButton *orderButton = (UIButton *)[self viewWithTag:700 + i];
            [orderButton setTitle:_sortTitleNameArray[i] forState:UIControlStateNormal];
        }
        
        //tableView + headView 的背景View
        dataView = [[UIView alloc]initWithFrame:CGRectMake(-0.01, self.tfText.origin.y + self.tfText.height + 10, SCREEN_WIDTH -10 *SCREEN_W_SP, self.height - self.tfText.origin.y - self.tfText.height - 10)];
        dataView.backgroundColor = [UIColor whiteColor];
        
        [scrollView1 addSubview:dataView];
        
        //排行view
        [headView  removeFromSuperview];
        headView  = nil;
        
        headView = [[UIView alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, SCREEN_WIDTH - 20 * SCREEN_W_SP, 54 * SCREEN_H_SP)];
        headView.backgroundColor = Color(238, 238, 238);
        [dataView addSubview:headView];
        [headView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewTap:)]];
        
        //1、排行序列
        UILabel *rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, 50 *SCREEN_W_SP, headView.height)];
        rankLabel.text = @"排行";
        rankLabel.textColor = colorText;
        rankLabel.font = [UIFont systemFontOfSize:14];
        rankLabel.textAlignment = NSTextAlignmentLeft;
        [headView addSubview:rankLabel];
        
        //2、商品
        UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(rankLabel.frame.origin.x  +rankLabel.frame.size.width + 5 * SCREEN_W_SP, 0, 60 *SCREEN_W_SP, headView.height)];
        goodsLabel.text = @"商品";
        goodsLabel.textColor = colorText;
        goodsLabel.font = [UIFont systemFontOfSize:14];
        goodsLabel.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:goodsLabel];
        
        
        //按照接口返回的排序按钮个数定空间
        CGFloat rankRoomWidth = headView.width - (goodsLabel.x + goodsLabel.width);
        NSArray *sortTitleArray = [NSArray arrayWithObjects:@"件数",@"金额",@"笔数", nil];
        if (_sortTitleNameArray) {
            
            sortTitleArray = _sortTitleNameArray;
            
        }
        
        for (int i = 0; i < sortTitleArray.count; i ++) {
            
            if ([_orderTypesArray[i] isEqualToString:@"D"]) {
                
                UIButton *upTriangle = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, 0, rankRoomWidth / sortTitleArray.count, headView.height / 3)];
                upTriangle.tag = 500 + i;
                [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                [headView addSubview:upTriangle];
                
                UIButton *downTriangle = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, headView.height / 3 * 2, rankRoomWidth / sortTitleArray.count, headView.height / 3)];
                downTriangle.tag = 600 + i;
                [headView addSubview:downTriangle];
                
                UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, 0, rankRoomWidth / sortTitleArray.count, headView.height)];
                cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cutBtn.tag = 700 + i;
                [cutBtn setTitle:sortTitleArray[i] forState:UIControlStateNormal];
                [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                
                if (i == 0) {
                    
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
                    
                } else {
                    
                    [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    [cutBtn setSelected:YES];
                    
                }
                
                [cutBtn addTarget:self action:@selector(sequenceClick:) forControlEvents:UIControlEventTouchUpInside];
                [headView addSubview:cutBtn];
                
            }else if ([_orderTypesArray[i] isEqualToString:@"A"]){
                
                UIButton *upTriangle = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, 0, rankRoomWidth / sortTitleArray.count, headView.height / 3)];
                upTriangle.tag = 500 + i;
                
                if (i == 0) {
                    
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
                    
                } else {
                    
                    [upTriangle setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    
                }
                
                [headView addSubview:upTriangle];
                
                UIButton *downTriangle = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, headView.height / 3 * 2, rankRoomWidth / sortTitleArray.count, headView.height / 3)];
                [downTriangle setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                downTriangle.tag = 600 + i;
                [headView addSubview:downTriangle];
                
                UIButton *cutBtn = [[UIButton alloc]initWithFrame:CGRectMake(goodsLabel.x + goodsLabel.width + 15 *SCREEN_W_SP + rankRoomWidth / sortTitleArray.count * i, 0, rankRoomWidth / sortTitleArray.count, headView.height)];
                cutBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
                cutBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                cutBtn.tag = 700 + i;
                
                [cutBtn setTitle:sortTitleArray[i] forState:UIControlStateNormal];
                [cutBtn setSelected:YES];
                [cutBtn setTitleColor:colorText forState:UIControlStateNormal];
                [cutBtn addTarget:self action:@selector(sequenceClick:) forControlEvents:UIControlEventTouchUpInside];
                [headView addSubview:cutBtn];
                
            }
        }
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(-0.01,headView.frame.size.height, SCREEN_WIDTH +0.1, dataView.height - headView.height) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHex:0xdfdfdf];
        _tableView.delegate = self;
        _tableView.rowHeight = 96 * SCREEN_H_SP;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[TableViewCellForShangPinCell class] forCellReuseIdentifier:@"TableViewCellForShangPinCell"];
        
        [dataView addSubview:_tableView];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        [_tableView addFooterWithTarget:self action:@selector(addFooterRefresh)];
        
        [twoAnimationView  removeFromSuperview];
        twoAnimationView  = nil;
        
        twoAnimationView = [[TwoAnimationView alloc]initWithFrame:CGRectMake(0, -80, SCREEN_WIDTH, 100)];
        
        twoAnimationView.layer.borderColor = [UIColor redColor].CGColor;
        
        
        [twoAnimationView Animation];
        
        [twoAnimationView Animation1];
        
        [_tableView addSubview:twoAnimationView];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 日周月年切换
- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index {
    
    @try {
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中NSLog(@"切换日周月年索引  %ld",index);
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        _timeLevel =  index + 1;
        [self request020401];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 上拉加载更多
-(void)addFooterRefresh{
    
    @try {
     
        _isLoadMore = YES;
        
        //将_indexOfPageNum的值传给服务器
        
        if (_indexOfPageNum == 1) {
            [_dataSourceArr removeAllObjects];
        }
        
        [self request020401];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - 刷新排序按钮
-(void)refreshOrderViews{
    
    @try {
     
        for (int i = 0; i < _sortTitleNameArray.count; i ++) {
            
            UIButton *orderButton = (UIButton *)[self viewWithTag:700 + i];
            [orderButton setTitle:_sortTitleNameArray[i] forState:UIControlStateNormal];
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

//headview取消键盘响应
-(void)headViewTap:(UITapGestureRecognizer *)tap{
    
    [self.tfText resignFirstResponder];
    
}



# pragma mark - 切换排序按钮刷新数据
-(void)sequenceClick:(UIButton *)button{
    
    @try {
        [self.tfText resignFirstResponder];
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        
        //selectTag可判断用户点击的是第几个sortTitle
        NSInteger selectTag = button.tag - 700;
        
        UIButton *upBtn = (UIButton *)[self viewWithTag:500 + selectTag];
        UIButton *downBtn = (UIButton *)[self viewWithTag:600 + selectTag];
        
        button.selected = !button.selected;
        if (button.selected) {
            [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_选中"] forState:UIControlStateNormal];
            [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
            
            _orderTypesArray[selectTag] = @"A";
            
            _order_arrayStr = @"A";
            
        }else{
            
            [upBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
            [downBtn setImage:[UIImage imageNamed:@"icon_排序_down_选中"] forState:UIControlStateNormal];
            
            _orderTypesArray[selectTag] = @"D";
            
            _order_arrayStr = @"D";
            
        }
        
        _orderPir = _piCodeArray[selectTag];
        
        NSArray *sortTitleArr = self.dataDic[@"data"][@"sortTitle"];
        
        if (sortTitleArr.count > 1) {
            
            for (int i = 0; i < sortTitleArr.count; i++) {
                
                if (i != selectTag) {
                    
                    UIButton *tempUpBtn = (UIButton *)[self viewWithTag:500 + i];
                    UIButton *tempDownBtn = (UIButton *)[self viewWithTag:600 + i];
                    UIButton *tempBtn = (UIButton *)[self viewWithTag:700 + i];
                    
                    [tempUpBtn setImage:[UIImage imageNamed:@"icon_排序_up_未选中"] forState:UIControlStateNormal];
                    [tempDownBtn setImage:[UIImage imageNamed:@"icon_排序_down_未选中"] forState:UIControlStateNormal];
                    [tempBtn setSelected:YES];
                    
                }
                
            }
            
        }
        
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];
        
        //请求接口
        [self request020401];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求020401接口
-(void)request020401{
    
    @try {
        //  [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            NSString *pia_code = _pia_code;
            
            NSString *order_array = _order_arrayStr;
            
            NSString * orderPir = _orderPir;
            
            NSString * pageSize = @"";
            
            NSString * pageNum = [NSString stringWithFormat:@"%ld",(long)_indexOfPageNum];
            
            NSDictionary * requestDataDic  =  [NSDictionary dictionaryWithObjectsAndKeys:
                                               [AppDatas sharedDatas].userCode,@"user_code",
                                               _titleCode,@"title_org_code",
                                               _storeCode,@"store_code",
                                               
                                               pia_code,@"pia_code",
                                               
                                               orderPir,@"order_pir",
                                               
                                               order_array,@"order_code",
                                               
                                               pageSize,@"page_size",
                                               
                                               pageNum,@"page_num",
                                               
                                               self.tfText.text,@"search_value",
                                               
                                               [AppDatas sharedDatas].selectFromDate.stringFromDateWithFormatyyyyMMdd,@"start_date",
                                               [AppDatas sharedDatas].selectToDate.stringFromDateWithFormatyyyyMMdd,@"end_date",
                                               [NSString stringWithFormat:@"%ld",(long)_timeLevel],@"time_level",
                                               nil];
            
            
            
            [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.StoreDetailProduct"
                        dataParameters:requestDataDic                     withCache:YES
                               success:^(NSDictionary *responseDic) {
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       
                                       if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                           
                                           [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                          
                                           
                                            self.secondDic = responseDic;
                                           
                                           [_tableView footerEndRefreshing];
                                           
                                           [UIView animateWithDuration:0.4 animations:^{
                                               
                                               scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                               _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                                           }completion:^(BOOL finished){
                                               
                                               [animationView stopAnimating1];
                                               [twoAnimationView stopAnimating1];
                                           }];
                                           
                                           
                                           //[_tableView.footer endRefreshing];
                                           if ([responseDic[@"data"][@"sortList"]count] == 0 && _indexOfPageNum > 1) {
                                               
                                               [[HUDHelper getInstance]showErrorTipWithLabel:@"暂无更多商品"];
                                           }
                                           else{
                                               if (_isLoadMore) {
                                                   
                                                   [self loadMoreData];
                                                   
                                                   
                                               }else{
                                                   
                                                   [self analysis020401Data];
                                                   
                                                   [self refreshOrderViews];
                                                   
                                               }
                                               
                                               
                                              
                                               
                                               
                                               _indexOfPageNum ++;
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
                    
                                       [_tableView footerEndRefreshing];
                                       
                                       [UIView animateWithDuration:0.4 animations:^{
                                           
                                           scrollView1.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                           _tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
                                       }completion:^(BOOL finished){
                                           
                                           [animationView stopAnimating1];
                                           [twoAnimationView stopAnimating1];
                                       }];

                                       
                                       
                                       //[_tableView.footer endRefreshing];
                                       _tableView.contentOffset = CGPointZero;
                                       if (_indexOfPageNum == 1) {
                                           _dataSourceArr =  [[NSMutableArray alloc] init];
                                           [_tableView reloadData];
                                           
                                       }
                                       
                                       if (error.code == -1001) {
                                           
                                           [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                           
                                       }
                                       else{
                                           
                                           [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                           
                                       }
                                       
                                   });
                               }];
        });
  
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
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

//请求020401成功之后加载更多数据
-(void)loadMoreData{
    
    @try {
        NSMutableArray *nextPageArray= [self.secondDic[@"data"][@"sortList"] mutableCopy];
        
       
            
            for (int i = 0 ; i < nextPageArray.count; i ++) {
                
                [_dataSourceArr addObject:[nextPageArray objectAtIndex:i]];
                
            }
            
             [_tableView reloadData];
        
  
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 请求020401成功并解析
-(void)analysis020401Data{
    
    @try {
     
        // _dataSourceArr = nil;
        _dataSourceArr = [[NSMutableArray alloc] initWithArray:[self.secondDic[@"data"][@"sortList"] mutableCopy]];
        
        [_tableView reloadData];
        _tableView.contentOffset = CGPointZero;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}


#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    @try {
        
        if (_dataSourceArr.count > 0) {
            
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return _dataSourceArr.count;
        }
        else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
            return 0;
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 96 *SCREEN_H_SP;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        TableViewCellForShangPinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForShangPinCell"];
        
        //第一列
        [cell.rankBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1 ] forState:UIControlStateNormal];
        if (indexPath.row == 0) {
            [cell.rankBtn setBackgroundColor:Color(184, 43, 54) forState:UIControlStateNormal];
            [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else if (indexPath.row == 1){
            [cell.rankBtn setBackgroundColor:Color(249, 119, 58) forState:UIControlStateNormal];
            [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else if (indexPath.row == 2){
            [cell.rankBtn setBackgroundColor:Color(253, 173, 59) forState:UIControlStateNormal];
            [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else{
            [cell.rankBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
            [cell.rankBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        
        // 赋值
        cell.nameLab.text = _dataSourceArr[indexPath.row][@"productNO"];
        
        
        //   [self downloadImage:indexPath];
        
        NSString * imgURL = _dataSourceArr[indexPath.row][@"productImage"];
        
        [cell.imag sd_setImageWithURL:[NSURL URLWithString:imgURL] placeholderImage:[UIImage imageNamed:@"img_商品排行默认图"]];
        
        //sort可用空间 及其起始点
        CGFloat startX = cell.imag.x +cell.imag.width;
        cell.height = 96 *SCREEN_H_SP;
        CGFloat roomWidth = SCREEN_WIDTH - (25 + 60 + 50) *SCREEN_W_SP;
        //判断sortTitleArray.count
        NSArray *sortTitleArray = _sortTitleNameArray;
        NSArray *PIArray = _dataSourceArr[indexPath.row][@"PI"];
        for (int i = 0; i < sortTitleArray.count; i ++) {
            
            if (sortTitleArray.count == 1) {
                
                cell.rankOneLab.frame = CGRectMake(startX + 10 *SCREEN_W_SP, 0, roomWidth, cell.height);
                for (int j = 0; j < PIArray.count; j ++) {
                    
                    if ([_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"1"]) {
                        
                        cell.rankOneLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                        
                    }
                }
                
                cell.rankTwoLab.frame = CGRectZero;
                [cell.rankThreeLab removeFromSuperview];
                [cell.rankFourthLab removeFromSuperview];
                
            }else if (sortTitleArray.count == 2){
                
                cell.rankOneLab.frame = CGRectMake(startX + 10 *SCREEN_W_SP, 0, roomWidth / 2, cell.height);
                cell.rankTwoLab.frame = CGRectMake(startX + 10 *SCREEN_W_SP + roomWidth / 2, 0, roomWidth / 2, cell.height);
                [cell.rankThreeLab removeFromSuperview];
                [cell.rankFourthLab removeFromSuperview];
                
                for (int j = 0; j < PIArray.count; j ++) {
                    
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"1"]) {
                        
                        cell.rankOneLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"2"]) {
                        
                        cell.rankTwoLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    
                }
                
            }else if (sortTitleArray.count == 3){
                
                cell.rankOneLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP, 0, roomWidth / 3, cell.height);
                cell.rankTwoLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP + roomWidth / 3, 0, roomWidth / 3, cell.height);
                cell.rankThreeLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP + roomWidth / 3 * 2, 0, roomWidth / 3, cell.height);
                [cell.rankFourthLab removeFromSuperview];
                
                for (int j = 0; j < PIArray.count; j ++) {
                    
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"1"]) {
                        
                        cell.rankOneLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"2"]) {
                        
                        cell.rankTwoLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"3"]) {
                        
                        cell.rankThreeLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    
                }
                
            }else if (sortTitleArray.count == 4){
                
                cell.rankOneLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP, 0, roomWidth / 4, cell.height);
                
                cell.rankTwoLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP + roomWidth / 4, 0, roomWidth / 4, cell.height);
                
                cell.rankThreeLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP +roomWidth / 4 * 2, 0, roomWidth / 4, cell.height);
                
                cell.rankFourthLab.frame = CGRectMake(startX + 15 *SCREEN_W_SP + roomWidth / 4 * 3, 0, roomWidth / 4, cell.height);
                
                for (int j = 0; j < PIArray.count; j ++) {
                    
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"1"]) {
                        
                        cell.rankOneLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"2"]) {
                        
                        cell.rankTwoLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"3"]) {
                        
                        cell.rankTwoLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    if (_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] && [_dataSourceArr[indexPath.row][@"PI"][j][@"ySite"] isEqualToString:@"4"]) {
                        
                        cell.rankTwoLab.text = _dataSourceArr[indexPath.row][@"PI"][j][@"value"];
                    }
                    
                }
                
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @try {
     
        [self.tfText resignFirstResponder];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
}

#pragma mark - 点击Return键的时候，（标志着编辑已经结束了）
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    @try {
        
        [_tfText resignFirstResponder];
        
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];
        [self request020401];
        
        return YES;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    
    @try {
        
        self.tfText.text = @"";
        _isLoadMore = NO;
        _indexOfPageNum = 1;
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];
        [self request020401];
        
        return YES;

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - scrollView 回调
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    // [self.tfText resignFirstResponder];
}


#pragma mark - 即将结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    @try {
       
        if (scrollView1.contentOffset.y < -25 || _tableView.contentOffset.y < -25) {
            
            if (scrollView == scrollView1) {
                [animationView stopAnimating];
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];
                
                [animationView startAnimation1];
                _isLoadMore = NO;
                _indexOfPageNum = 1;
                self.tfText.text = @"";
                
                [self request020401];
                scrollView1.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
            }
            else if (scrollView == _tableView){
                [twoAnimationView stopAnimating];
                [twoAnimationView startAnimation1];
                _isLoadMore = NO;
                _indexOfPageNum = 1;
                
                [self request020401];
                
                _tableView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

//#pragma mark - cell里加载图片的方法封装
//- (void)downloadImage:(NSIndexPath *)indexPath {
//    
//    NSString *imgURL = _dataSourceArr[indexPath.row][@"productImage"];
//    
//    if (operationCache[imgURL] != nil) {
//        
//        return;
//        
//    }
//    
//    NSBlockOperation *downloadOp = [NSBlockOperation blockOperationWithBlock:^{
//        
//        NSURL *url = [NSURL URLWithString:imgURL];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:data];
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            [operationCache removeObjectForKey:imgURL];
//            
//            if (image != nil) {
//                
//                [imageCache setObject:image forKey:imgURL];
//                [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                
//            }
//            
//        }];
//        
//    }];
//    
//    [operationCache setObject:downloadOp forKey:imgURL];
//    [downloadQueue addOperation:downloadOp];
//    
//}

#pragma mark - 侧滑栏回调
- (void)selectedLeftSideBar:(NSDictionary *)dict {
    
    @try {
     
        _indexOfPageNum = 1;
        _pia_code = dict[@"piaCode"];
        
        _order_arrayStr = @"D";
        _indexOfLeft = [dict[@"indexOfLeftSideBar"] integerValue];
        //    [self request020401];
        
        [self refreshDatasWithCache:YES WithCode:_storeCode];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"店铺详情中商品  SPView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

@end
