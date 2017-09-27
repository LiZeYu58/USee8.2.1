//
//  YeJiView.m
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//


    // 业绩看板（二级页面）



#import "YeJiView.h"
#import "BigBtnView.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LOSHelper.h"
#import "TableViewCellForYejiTopRight.h"
#import "MainPageDetailCompareView.h"
//#import "Charts.h"
#import "TableViewChartCell.h"
#import "ThreeDetailViewController.h"
#import "AppDelegate.h"
#import "AnimationView.h"
#import "LOConst.h"
#import "MBProgressHUD.h"
//ChartViewDelegate, IChartAxisValueFormatter,
@interface YeJiView ()<BigBtnViewDelegate, UITableViewDataSource, UITabBarDelegate,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate, MBProgressHUDDelegate> {
    
    AnimationView *animationView; //刷新动画控件
    BigBtnView *dateComponent;  //日周月年控件
    
    UILabel *topLeftTitle; //左上角的标题
    UILabel *topLeftValue; //左上角的值
    UIView *topLeftView; //左上角的 UIView
    UIView *rightPageChartBaseView; //环形图或条形图的底层 View
    UIButton * drillButton; //环形图的下钻按钮
    UITableView *topRightTableView; //右上角的 TableView
    UITableView *horizontalBarChartView; //条形图
    UIScrollView *chartScrollView; //下半部图表的 ScrollView
    UIScrollView *baseScrollView; //整个业绩看板的底层 ScrollView
    
    BOOL isDefalutCompareSelected;
    BOOL isDrilled;
    
    NSInteger beginX; //记录图表 ScrollView 的拖拽起点
    NSInteger selectedEntryIndex; //图表选中的 Index
    NSInteger selectedDateComponentIndex; //日周月年选中的 Index
    NSInteger _downDrillInteger;
    
    NSInteger _scrollInteger;
    
    NSInteger pageNumber;
    
    NSInteger _touchTopRightInteger;
    
    NSString *baseOrgCode; //原始 OrgCode
    NSString *topLeftBarOrgCode; //左上角的 OrgCode
    NSString *headOrgCode; //上半部选中的 OrgCode
    NSString *chartOrgCode; //图表选中的 OrgCode
    
    NSString * downDrillOrgCode; //点击下钻OrgCode
    
    NSString * _followOrgCode;  //跟踪OrgCode
    
//    NSMutableArray<MainPageDetailCompareView *> *compareViewArray; //同比增控件
//    NSMutableArray<NSMutableArray *> *requestStatusArr;
    
    NSMutableArray * _increaseButtonArray;
    NSMutableArray * _roundLabelArray;
    NSMutableArray * _titleLabelArray;
    NSMutableArray * _valueLabelArray;
    NSMutableArray * _colorIncreaseArray;
    
    NSMutableDictionary * _selectIndexDic;
    NSMutableDictionary * _increaseMutableDictionary;
    
    
    NSDictionary *titleDataDic; //标题栏菜单返回体
    NSDictionary *headDataDic; //上半部返回体
    
    NSDictionary *titleDataTempDic; //标题栏菜单临时返回体
    NSMutableDictionary *headDataTempDic; //上半部临时返回体
    NSMutableDictionary *barChartTempDic; //柱状图临时返回体
    NSMutableDictionary *pieChartTempDic; //环形图临时返回体
    
    NSMutableArray * _nameLabelArray;
    NSMutableArray * _twoValueLabelArray;
    
    NSIndexPath *horizontalBarIndexPath; //条形图选中的 IndexPath
    NSIndexPath *topRightIndexPath; //右上角选中的 IndexPath
    
    MBProgressHUD *HUD;
//    CombinedChartView *combinedChartView; //柱状图
//
//    CombinedChartData * combinedChartData;
//    PieChartView *pieChartView; //环形图
   
    UIView * _topView;
    
    UIView * _increaseView;
    
    UIView * _centerPageChartBaseView;
}

@end

@implementation YeJiView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        pageNumber = 0;

        _touchTopRightInteger = 6;
        
        _scrollInteger = 1;
        
        _downDrillInteger = 1;
        
        selectedDateComponentIndex = 1;
       
        isDefalutCompareSelected = YES;
        
        selectedEntryIndex = BarCharMaxEntryCount - 1; //依照协议BarChart 图表最多7根柱子
        self.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        
        [self createViews];
        [dateComponent generateComponentViewWith:4];
        [self createBarChartView];
        
      //  [self createCompareComponentWithView:baseScrollView componentColorModul:ColorModulOne];
        }
    
    return self;
    
}

- (void)orgCodeToYeJi:(NSString *)orgCode{
    
    @try {
        [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        _followOrgCode = orgCode;
        
        baseOrgCode = orgCode;
        
        topLeftBarOrgCode = baseOrgCode;
        
        _selectIndexDic = nil;
        _selectIndexDic = [[NSMutableDictionary alloc]init];
        
        if (_scrollInteger == 1) {
           
            BOOL netStatus=NO;
            netStatus = [CommonTools isConnectionAvailable:self];
            
            if (netStatus) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
                if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                    
                    [self requestStoreTargetDetails:baseOrgCode];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:baseOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                
            }
            else{
                [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            }
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }

}

# pragma mark - CreateViews

- (void)createViews {
    @try {
        [baseScrollView removeFromSuperview];
        baseScrollView = nil;
        
        [animationView removeFromSuperview];
        animationView = nil;
        
        [dateComponent removeFromSuperview];
        dateComponent = nil;
        
        [chartScrollView removeFromSuperview];
        chartScrollView  = nil;
        
        [rightPageChartBaseView removeFromSuperview];
        rightPageChartBaseView = nil;
        
        [topLeftView removeFromSuperview];
        topLeftView = nil;
        
        [topRightTableView removeFromSuperview];
        topRightTableView = nil;
        
        if (SCREEN_HEIGHT == 812) {
             baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 84, SCREEN_WIDTH, self.height)];
        }
        else{
             baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.height)];
        }
        baseScrollView.contentSize = CGSizeMake(0, self.height);
        baseScrollView.backgroundColor = [UIColor whiteColor];
        baseScrollView.showsVerticalScrollIndicator = NO;
        
        baseScrollView.userInteractionEnabled = YES;
        baseScrollView.alwaysBounceVertical = YES;
        baseScrollView.delegate = self;
        [self addSubview:baseScrollView];
        
        animationView = [[AnimationView alloc]initWithFrame:CGRectMake(0, -60, SCREEN_WIDTH, 100)];
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        [animationView Animation];
        [animationView Animation1];
        [baseScrollView addSubview:animationView];
        
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_H_SP)];
        _topView.backgroundColor = [UIColor greenColor];
        [baseScrollView addSubview:_topView];
        
        //日周月年 btns
        dateComponent = [[BigBtnView alloc]initWithFrame:CGRectMake(0, 180 * SCREEN_H_SP, SCREEN_WIDTH, 54* SCREEN_H_SP)];
        dateComponent.delegate = self;
        [baseScrollView addSubview:dateComponent];
        
        //滚动视图
        chartScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, dateComponent.frame.origin.y + 59 * SCREEN_H_SP , SCREEN_WIDTH,self.height - NavigationBarHeight - _topView.frame.size.height - dateComponent.frame.size.height + 10 - 65 * SCREEN_H_SP+55)];
        chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, 0);
        chartScrollView.backgroundColor = [UIColor redColor];
        chartScrollView.bounces = YES;
        chartScrollView.showsHorizontalScrollIndicator = NO;
        chartScrollView.pagingEnabled = YES;
        chartScrollView.delegate = self;
        [baseScrollView addSubview:chartScrollView];
        
        [self creatCenterPageChartBaseView];
        
        rightPageChartBaseView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 3, 0, SCREEN_WIDTH, chartScrollView.frame.size.height - 55)];
        [chartScrollView addSubview:rightPageChartBaseView];
        
        UIImageView * pieImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * 4, 0, chartScrollView.width, chartScrollView.height)];
       
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *resourcePath = [bundle resourcePath];
        
     //   NSString * imageFilePath =;
        
        if (SystemVersion >= 8.0) {
            
            if (SCREEN_WIDTH <= 320) {
                pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图5s"]];
            }
            else if (SCREEN_WIDTH > 320 && SCREEN_WIDTH <= 375){
                
                pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图"]];
            }
            else if (SCREEN_WIDTH >= 414){
                
                 pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图6Plus"]];
            }

        }
        else{
            
            if (SCREEN_WIDTH <= 320) {
               
                pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图5s.png"]];
                
            }
            else if (SCREEN_WIDTH > 320 && SCREEN_WIDTH <= 375){
                
                 pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图.png"]];
            }
            else if (SCREEN_WIDTH >= 414){
                
                pieImageView.image = [UIImage imageWithContentsOfFile: [resourcePath stringByAppendingPathComponent:@"柱状图6Plus.png"]];
            }
        }

        [chartScrollView addSubview:pieImageView];
        
        chartScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        
        //top
        topLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 220 * SCREEN_W_SP, _topView.height)];
        topLeftView.backgroundColor = [UIColor colorWithHex:0xb3333a];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapedHandleSingle:)];
        [topLeftView addGestureRecognizer:singleTap];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        [_topView addSubview:topLeftView];
        
        topLeftTitle = [[UILabel alloc] initWithFrame:CGRectMake(20 * SCREEN_W_SP, 0, topLeftView.width - 30 * SCREEN_W_SP * 2, 64* SCREEN_W_SP)];
        topLeftTitle.font = [UIFont systemFontOfSize:16];
        topLeftTitle.textColor = [UIColor whiteColor];
        [topLeftView addSubview:topLeftTitle];
        
        topLeftValue = [[UILabel alloc] initWithFrame:topLeftView.bounds];
        topLeftValue.font = [UIFont systemFontOfSize:32];
        topLeftValue.textColor = [UIColor whiteColor];
        topLeftValue.textAlignment = NSTextAlignmentCenter;
        [topLeftView addSubview:topLeftValue];
        
        [self creatTopRightView];
       
        [self creatYearOnYearIncrease];
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}

-(void)creatCenterPageChartBaseView{
    
    _nameLabelArray = nil;
    _twoValueLabelArray = nil;
    _nameLabelArray = [[NSMutableArray alloc] init];
    _twoValueLabelArray = [[NSMutableArray alloc] init];
    
    
    _centerPageChartBaseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH,chartScrollView.frame.size.height + 55)];

    [chartScrollView addSubview:_centerPageChartBaseView];
    
    UIImageView * _centerPageImageView = [[UIImageView alloc]init];
    
    if (SCREEN_WIDTH == 320) {
        
        _centerPageImageView.frame = CGRectMake(8 * SCREEN_W_SP, 8 * SCREEN_H_SP, SCREEN_WIDTH - 16 * SCREEN_W_SP, 165 * SCREEN_H_SP);

    }
    else{
        
        if (SCREEN_HEIGHT == 812) {
             _centerPageImageView.frame = CGRectMake(8 * SCREEN_W_SP, 8 * SCREEN_H_SP, SCREEN_WIDTH - 16 * SCREEN_W_SP, 265 * SCREEN_H_SP);
        }
        else{
             _centerPageImageView.frame = CGRectMake(8 * SCREEN_W_SP, 8 * SCREEN_H_SP, SCREEN_WIDTH - 16 * SCREEN_W_SP, 175 * SCREEN_H_SP);
        }
    }
    
    _centerPageImageView.image = [UIImage imageNamed:@"img_业绩看板指标背景"];
    [_centerPageChartBaseView addSubview:_centerPageImageView];
    
    UIView * bottomPageView = [[UIView alloc] init];
    
    bottomPageView.frame = CGRectMake(8 * SCREEN_W_SP, _centerPageImageView.y + _centerPageImageView.height + 3 * SCREEN_H_SP, SCREEN_WIDTH - 16 * SCREEN_W_SP,120 * SCREEN_H_SP);
    
    [_centerPageChartBaseView addSubview:bottomPageView];
    
    for (NSInteger i = 0; i < 5; i++) {
        UILabel * nameLabel = [[UILabel alloc] init];
        
        if (i == 0) {
            nameLabel.frame = CGRectMake(8 * SCREEN_W_SP, 65 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5),20 * SCREEN_H_SP);
        }
        else{
            nameLabel.frame = CGRectMake(i * ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5) + 8 * SCREEN_W_SP, 65 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5),20 * SCREEN_H_SP);
        }
        
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:13 * SCREEN_H_SP];
        nameLabel.textColor = [UIColor colorWithHex:0x888888];
        [_centerPageChartBaseView addSubview:nameLabel];
        
        [_nameLabelArray addObject:nameLabel];
    }
    
    
    for (NSInteger i = 0; i < 5; i++) {
        UILabel * vauleLabel = [[UILabel alloc] init];
        
        if (i == 0) {
            vauleLabel.frame = CGRectMake(8 * SCREEN_W_SP, 90 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5),20 * SCREEN_H_SP);
        }
        else{
            vauleLabel.frame = CGRectMake(i * ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5) + 8 * SCREEN_W_SP, 90 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP) /5),20 * SCREEN_H_SP);
        }
        
        vauleLabel.textAlignment = NSTextAlignmentCenter;
        vauleLabel.font = [UIFont systemFontOfSize:16 * SCREEN_H_SP];
        vauleLabel.textColor = [UIColor colorWithHex:0xba2932];
        [_centerPageChartBaseView addSubview:vauleLabel];
        
        [_twoValueLabelArray addObject:vauleLabel];
    }
    
    
    for (NSInteger i = 0; i < 4; i ++) {
        
      UIView * fourView = [[UIView alloc] init];
      
      fourView.frame = CGRectMake(i%2 * ((SCREEN_WIDTH - 16 * SCREEN_W_SP)/2), i/2 * 60 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP)/2)-1.5, 60 * SCREEN_H_SP - 3);
          
      fourView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
      [bottomPageView addSubview:fourView];
        
       
      UILabel * fourNameLabel = [[UILabel alloc]init];
      fourNameLabel.frame = CGRectMake(0,15 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP)/2)-1.5, 13 * SCREEN_H_SP);
      
      fourNameLabel.textAlignment = NSTextAlignmentCenter;
      fourNameLabel.font = [UIFont systemFontOfSize:13 * SCREEN_H_SP];
      fourNameLabel.textColor = [UIColor colorWithHex:0x888888];
      [fourView addSubview:fourNameLabel];
        
        UILabel * fourVauelLabel = [[UILabel alloc]init];
        fourVauelLabel.frame = CGRectMake(0,13 * SCREEN_H_SP + 17 * SCREEN_H_SP, ((SCREEN_WIDTH - 16 * SCREEN_W_SP)/2)-1.5, 15 * SCREEN_H_SP);
        fourVauelLabel.textAlignment = NSTextAlignmentCenter;
        fourVauelLabel.font = [UIFont systemFontOfSize:16 * SCREEN_H_SP];
        fourVauelLabel.textColor = [UIColor colorWithHex:0xba2932];
        [fourView addSubview:fourVauelLabel];
        
        [_nameLabelArray addObject:fourNameLabel];
        [_twoValueLabelArray addObject:fourVauelLabel];
    }
    
}

-(void)creatYearOnYearIncrease{
    
    @try {
         _increaseView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 55 - 64, SCREEN_WIDTH, 55)];
        _increaseView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [baseScrollView addSubview:_increaseView];
        
        _colorIncreaseArray = [[NSMutableArray alloc]initWithObjects:[UIColor colorWithHex:0xFFB5C5],[UIColor colorWithHex:0xff782f],[UIColor colorWithHex:0xa8a8a8],nil];
        
        _increaseButtonArray = nil;
        _roundLabelArray = nil;
        _titleLabelArray = nil;
        _valueLabelArray = nil;
        
        _increaseMutableDictionary = [[NSMutableDictionary alloc]init];
        
        _increaseButtonArray = [[NSMutableArray alloc] init];
        
        _roundLabelArray = [[NSMutableArray alloc] init];
        
        _titleLabelArray = [[NSMutableArray alloc]init];
        
        _valueLabelArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < 3; i ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if (i == 0) {
                
                [_increaseMutableDictionary setObject:@"aa" forKey:[NSString stringWithFormat:@"0"]];
                
                button.selected = YES;
                button.backgroundColor = [UIColor whiteColor];
            }
            
            button.frame = CGRectMake(i * (SCREEN_WIDTH/3), 2, SCREEN_WIDTH/3, 55-2);
            
            [_increaseView addSubview:button];
            
            button.tag = i;
            [button addTarget:self action:@selector(increaseTouchButton:) forControlEvents:UIControlEventTouchUpInside];
            
            UILabel * roundLabel = [[UILabel alloc]init];
            roundLabel.layer.masksToBounds = YES;
            roundLabel.layer.cornerRadius = 5;
            roundLabel.backgroundColor = _colorIncreaseArray[i];
            [button addSubview:roundLabel];
            
            UILabel * titleLabel = [[UILabel alloc] init];
            
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor colorWithHex:0xa8a8a8];
            
            if (i == 0) {
                
                titleLabel.textColor = [UIColor colorWithHex:0xb3333a];
            }
            
            
            [button addSubview:titleLabel];
            
            if (SCREEN_WIDTH == 320) {
                roundLabel.frame = CGRectMake(17, 10, 10, 10);
                
                titleLabel.frame = CGRectMake(32, 5, SCREEN_WIDTH/3 - 30-5, 20);
            }
            else if(SCREEN_WIDTH == 375){
                roundLabel.frame = CGRectMake(26 * SCREEN_W_SP, 10, 10, 10);
                
                titleLabel.frame = CGRectMake(41 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
            }
            else if (SCREEN_WIDTH == 414){
                
                roundLabel.frame = CGRectMake(28 * SCREEN_W_SP, 10, 10, 10);
                
                titleLabel.frame = CGRectMake(43 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                
            }
            titleLabel.textAlignment = NSTextAlignmentLeft;
            if (i == 1) {
                
                if (SCREEN_WIDTH == 320) {
                    roundLabel.frame = CGRectMake(5, 10, 10, 10);
                    
                    titleLabel.frame = CGRectMake(20, 5, SCREEN_WIDTH/3 - 30-5, 20);
                }
                else if(SCREEN_WIDTH == 375){
                    roundLabel.frame = CGRectMake(12 * SCREEN_W_SP, 10, 10, 10);
                    
                    titleLabel.frame = CGRectMake(27 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                }
                else if (SCREEN_WIDTH == 414){
                    
                    roundLabel.frame = CGRectMake(15 * SCREEN_W_SP, 10, 10, 10);
                    
                    titleLabel.frame = CGRectMake(30 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                }
                
            }

            
            
            UILabel * valueLabel  =  [[UILabel alloc]initWithFrame:CGRectMake(0, titleLabel.origin.y + titleLabel.height, SCREEN_WIDTH/3,53 - 25)];
            valueLabel.font = [UIFont systemFontOfSize:16];
            
            valueLabel.textAlignment = NSTextAlignmentCenter;
            valueLabel.textColor = [UIColor colorWithHex:0xa8a8a8];
            [button addSubview:valueLabel];
            
            [_increaseButtonArray addObject:button];
            
            [_roundLabelArray addObject:roundLabel];
            
            [_titleLabelArray addObject:titleLabel];
            
            [_valueLabelArray addObject:valueLabel];
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


-(void)increaseTouchButton:(UIButton *)button{
    
    @try {
     
        if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
            UIButton * increaseButton = _increaseButtonArray[button.tag];
            UILabel * titleLabel = _titleLabelArray[button.tag];
            button.selected = !button.selected;
            
            if (button.selected) {
                
                [_increaseMutableDictionary setObject:@"aa" forKey:[NSString stringWithFormat:@"%ld",button.tag]];
                increaseButton.backgroundColor = [UIColor whiteColor];
                
                titleLabel.textColor = [UIColor colorWithHex:0xb3333a];
                
            }
            else{
                
                [_increaseMutableDictionary removeObjectForKey:[NSString stringWithFormat:@"%ld",button.tag]];
                increaseButton.backgroundColor =  [UIColor colorWithHex:0xdfdfdf];
                
                titleLabel.textColor = [UIColor colorWithHex:0xa8a8a8];;
            }
            
            [self refreshCombinedBarChar:barChartTempDic];
            
        }
        else{
            
          
        }

    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)creatTopRightView{
    
    @try {
        topRightTableView = [[UITableView alloc] init];
        topRightTableView.backgroundColor = [UIColor colorWithRed:0.608 green:0.000 blue:0.098 alpha:1.00];
        topRightTableView.dataSource = self;
        topRightTableView.delegate = self;
        topRightTableView.rowHeight = 45 * SCREEN_H_SP;
        topRightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // [topRightTableView registerClass:[TableViewCellForYejiTopRight class] forCellReuseIdentifier:@"TableViewCellForYejiTopRight"];
        // TableViewChartCell
        topRightTableView.showsVerticalScrollIndicator = NO;
        topRightTableView.frame = CGRectMake(topLeftView.width, 0, SCREEN_WIDTH - topLeftView.width, 180 * SCREEN_H_SP);
        [_topView addSubview:topRightTableView];
   
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


#pragma mark - 柱状图创建
- (void)createBarChartView {
    @try {
        UIImageView * firstImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, chartScrollView.width, chartScrollView.height)];
        
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *resourcePath = [bundle resourcePath];
        
        if (SystemVersion > 8.0) {
            
            if (SCREEN_WIDTH <= 320) {
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图5s"]];
            }
            else if (SCREEN_WIDTH > 320 && SCREEN_WIDTH <= 375){
                
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图"]];
            }
            else if (SCREEN_WIDTH >= 414){
                
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图6Plus"]];
            }

        }
        else{
            
            if (SCREEN_WIDTH <= 320) {
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图5s.png"]];
            }
            else if (SCREEN_WIDTH > 320 && SCREEN_WIDTH <= 375){
                
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图.png"]];
            }
            else if (SCREEN_WIDTH >= 414){
                
                firstImageView.image = [UIImage imageWithContentsOfFile:[resourcePath stringByAppendingPathComponent:@"环状图6Plus"]];
            }
        }
        
        [chartScrollView addSubview:firstImageView];
        
//        [combinedChartView removeFromSuperview];
//        combinedChartView = nil;
//
//        combinedChartView = [CombinedChartView new];
         UIView * combinedChartView = [UIView new];
        combinedChartView.backgroundColor = [UIColor blueColor];
        
        combinedChartView.frame = CGRectMake(SCREEN_WIDTH+20 * SCREEN_W_SP, 20 * SCREEN_H_SP, DeviceWidth - 20 * SCREEN_W_SP * 2, chartScrollView.height - 40 * SCREEN_H_SP -55);
        [chartScrollView addSubview:combinedChartView];
//        combinedChartView.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:0.3];
//
//        //禁止缩放
//        combinedChartView.pinchZoomEnabled = NO;
//        combinedChartView.doubleTapToZoomEnabled = NO;
//        combinedChartView.noDataTextDescription = @"无数据";
//        combinedChartView.scaleXEnabled = NO;
//        combinedChartView.scaleYEnabled = NO;
//
//        //x轴
//        ChartXAxis *xAxis = combinedChartView.xAxis;
//        xAxis.labelPosition = XAxisLabelPositionBottom;
//        xAxis.labelFont = [UIFont systemFontOfSize:10.f];
//        xAxis.labelTextColor = [UIColor grayColor];
//        xAxis.drawGridLinesEnabled = NO;
//        xAxis.granularity = 1.0; // only intervals of 1 day
//        xAxis.axisMinValue = - 0.5;
//        xAxis.valueFormatter = self;
//
//        //左边坐标轴
//        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//        leftAxisFormatter.minimumFractionDigits = 0.0;
//        leftAxisFormatter.maximumFractionDigits = 1.0;
//        leftAxisFormatter.minimumIntegerDigits = 1;
//
//        ChartYAxis *leftAxis = combinedChartView.leftAxis;
//        leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
//
//        leftAxis.forceLabelsEnabled = NO;
//        leftAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:leftAxisFormatter];
//        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
//        leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
//        leftAxis.drawAxisLineEnabled = NO;
//        leftAxis.drawGridLinesEnabled = YES;
//        leftAxis.gridColor = [UIColor lightGrayColor];
//        leftAxis.labelTextColor = xAxis.labelTextColor;
//        [leftAxis set_customAxisMax:YES];
//
//        combinedChartView.rightAxis.enabled = NO;//右边坐标轴
//        combinedChartView.legend.enabled = NO;//图注
//        combinedChartView.delegate = self;//delegate
//        combinedChartView.dragEnabled = NO;//禁止拖拽
//        combinedChartView.descriptionText = @"";//说明
        
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    }
}

- (double)reCalculateMaxYValue:(NSInteger)yMax {
    
    @try {
    
        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
        
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
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    }
}


#pragma mark - 饼状图
//- (void)createPieChartView {
//    @try {
//        [pieChartView  removeFromSuperview];
//        pieChartView = nil;
//
//        pieChartView = [PieChartView new];
//        pieChartView.frame = CGRectMake(0, 10 * SCREEN_H_SP, DeviceWidth, rightPageChartBaseView.height - 29 * SCREEN_H_SP);
//        pieChartView.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:0.3];
//        pieChartView.holeRadiusPercent = 0.7;
//        pieChartView.backgroundColor = [UIColor whiteColor];
//        pieChartView.legend.enabled = NO;
//        pieChartView.descriptionText = @"";
//        pieChartView.noDataTextDescription = @"没数据";
//        pieChartView.rotationEnabled = NO;
//        pieChartView.delegate = self;
//        pieChartView.entryLabelColor = UIColor.whiteColor;
//        pieChartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
//        [pieChartView animateWithXAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
//        [rightPageChartBaseView addSubview:pieChartView];
//
//        ChartLegend *l = pieChartView.legend;
//        l.position = ChartLegendPositionRightOfChart;
//        l.xEntrySpace = 7.0;
//        l.yEntrySpace = 0.0;
//
//     //   l.formToTextSpace = 10;
//        l.yOffset = 0.0;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//}

- (void)createHorizontalBarChartView {
    @try {
        [horizontalBarChartView removeFromSuperview];
        horizontalBarChartView = nil;
        
        horizontalBarChartView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth , rightPageChartBaseView.height) style:UITableViewStylePlain];
        horizontalBarChartView.bounces = NO;
        horizontalBarChartView.delegate =self;
        horizontalBarChartView.dataSource =self;
        horizontalBarChartView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [horizontalBarChartView registerClass:[TableViewChartCell class] forCellReuseIdentifier:@"TableViewChartCell"];
        horizontalBarChartView.showsHorizontalScrollIndicator = NO;
        horizontalBarChartView.showsVerticalScrollIndicator = NO;
        [rightPageChartBaseView addSubview:horizontalBarChartView];
        
        [horizontalBarChartView reloadData];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    }
    
}


- (void)createDrillButton {
    @try {
        [drillButton removeFromSuperview];
        drillButton = nil;
        
        drillButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 53 * SCREEN_W_SP, rightPageChartBaseView.frame.size.height - 60 * SCREEN_H_SP, 50 * SCREEN_W_SP, 50 * SCREEN_W_SP)];
        [drillButton setBackgroundImage:[UIImage imageNamed:@"btn_下钻"] forState:UIControlStateNormal];
        [drillButton setBackgroundImage:[UIImage imageNamed:@"btn_下钻_d"] forState:UIControlStateSelected];
        [rightPageChartBaseView addSubview:drillButton];
        
        [drillButton addTarget:self action:@selector(tapedDrillButton:) forControlEvents:UIControlEventTouchUpInside];
 
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}


- (void)refreshHeadWithRequestData:(BOOL)needRequest {
    
    @try {
         dispatch_async(dispatch_get_main_queue(), ^{
        
          [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]];
      
             if (_scrollInteger == 1) {
                
                 if (headDataTempDic.count == 0) {
                     return;
                 }
                 
                 if (headDataTempDic.count > 0) {
                     
                     topLeftBarOrgCode = headDataTempDic[@"data"][@"leftBar"][@"orgCode"];
                     
                     if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3) {
                         
                         //立即返回
                         topLeftTitle.text = headDataTempDic[@"data"][@"leftBar"][@"title"];
                         NSArray * totalValueList = headDataTempDic[@"data"][@"leftBar"][@"data"][0];
                         topLeftValue.text = headDataTempDic[@"data"][@"leftBar"][@"data"][0][totalValueList.count -1][@"value"];
                         
                     }
                     else if(chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                         
                         topLeftTitle.text = headDataTempDic[@"data"][@"leftBar"][@"title"];
                         NSArray * totalValueList = headDataTempDic[@"data"][@"leftBar"][@"data"][0];
                         topLeftValue.text = headDataTempDic[@"data"][@"leftBar"][@"data"][0][totalValueList.count -1][@"value"];
                         
                     }
                     else if(chartScrollView.contentOffset.x == SCREEN_WIDTH){
                         //立即返回
                         topLeftTitle.text = headDataTempDic[@"data"][@"leftBar"][@"title"];
                         NSArray * totalValueList = headDataTempDic[@"data"][@"leftBar"][@"data"][0];
                         topLeftValue.text = headDataTempDic[@"data"][@"leftBar"][@"data"][0][totalValueList.count -1][@"value"];
                         
                     }
                     
                     [topRightTableView reloadData];
                 }

             }
             
         });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}

- (void)refreshChartWithRequestData{
    
   
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
            
            if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                
                
                if (barChartTempDic) {
                    
                    [self refreshDateComponentWith:barChartTempDic]; //刷新日周月年名称控件
                }
                
                
            } else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3) {
                
                pieChartTempDic ? [self refreshBottomChart] : nil;
                
            }
        });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 刷新柱状图 @param dataSource 数据源

- (void)refreshCombinedBarChar:(NSMutableDictionary *)dataSource {
    @try {
        
        if (barChartTempDic.count == 0) {
            return;
        }
        else{
        
//        combinedChartData = nil;
//        combinedChartData = [[CombinedChartData alloc] init];
//
//        combinedChartData.lineData = [self refreshLineDataWithDataSource:dataSource];
//        combinedChartData.barData = [self refreshBarChartDataWithDataSource:dataSource];
//
//        combinedChartView.xAxis.axisMaximum = combinedChartData.xMax + 0.25 + 0.25;
//
//        [combinedChartView.leftAxis resetCustomAxisMax];
//        CGFloat numberY;
//
//        NSString * numberYS= [NSString stringWithFormat:@"%f",[combinedChartData yMax]];
//        numberY = [numberYS floatValue];
//
//        combinedChartView.leftAxis.forceLabelsEnabled = NO;
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
//            else  if (numberY >= 3 && numberY < 4)
//            {
//                numberY = numberY +0.35;
//            }
//            else if (numberY >= 4 && numberY < 5){
//                numberY = numberY +0.4;
//            }
//
//            else  if (numberY >= 5 && numberY < 6)
//            {
//                numberY = numberY +0.45;
//            }
//            else  if (numberY >= 6 && numberY < 7)
//            {
//                numberY = numberY +0.5;
//            }
//            else  if (numberY >= 7 && numberY < 8)
//            {
//                numberY = numberY +0.55;
//            }
//            else  if (numberY >= 8 && numberY < 9)
//            {
//                numberY = numberY +0.6;
//            }
//            else  if (numberY >= 9 && numberY < 10)
//            {
//                numberY = numberY +0.65;
//            }
//
//        }
//
//        else if (numberY >= 10 && numberY < 100) {
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
//            numberY = [combinedChartData yMax];
//        }
//
//        if (numberY == 0) {
//            [combinedChartView.leftAxis setAxisMaxValue:[self reCalculateMaxYValue:numberY]];
//
//
//        }
//        else{
//            if (numberY < 1) {
//               [combinedChartView.leftAxis setAxisMaxValue:[self reCalculateMaxYValue:numberY]];
//            }
//            else{
//                [combinedChartView.leftAxis setAxisMaxValue:numberY];
//            }
//
//        }
//
//        combinedChartView.data = combinedChartData;
//        ChartHighlight *hl = [[ChartHighlight alloc] initWithX:selectedEntryIndex dataSetIndex:0 stackIndex:0];
//        hl.dataIndex = 1;
//        [combinedChartView highlightValueWithHighlight:hl callDelegate:YES];
//
//        [combinedChartView setNeedsDisplay];
 
        }
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}

- (void)refreshBottomChart {
    
    @try {
       
        if (pieChartTempDic.count == 0) {
            
            return;
            
        }
        
        if (pieChartTempDic.count > 0) {
            
            [rightPageChartBaseView removeAllSubviews];
            
            NSString * drawType = pieChartTempDic[@"data"][@"data"][0][0][@"drawType"];
            selectedEntryIndex = 0;
            
            if ([drawType isEqualToString:@"1"]) {
                
                if ( [pieChartTempDic[@"data"][@"data"][0][0][@"data"] count] > 10) {
                    
                    [self createHorizontalBarChartView];
                    
                    horizontalBarIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
                    
                    if ([pieChartTempDic[@"data"][@"data"][0][0][@"drillType"] isEqualToString:@"2"]) {
                        
                       [self createDrillButton];
                        
                    }
                    
                }
                else{
//                    [self createPieChartView];
                    
                    if ([self refreshPieChart]) {
                        
                        if ([pieChartTempDic[@"data"][@"data"][0][0][@"drillType"] isEqualToString:@"2"]) {
                            
                            [self createDrillButton];
                            
                        }
                        
                    }
                }
                
              
                
            } else if ([drawType isEqualToString:@"2"]) {
                
                [self createHorizontalBarChartView];
              //  [self refreshHorizontalBarChart];
                
                if ([pieChartTempDic[@"data"][@"data"][0][0][@"drillType"] isEqualToString:@"2"]) {
                    
                    [self createDrillButton];
                    
                }
                
                horizontalBarIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];

            }
            
        }
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    }
    
}


#pragma mark - 刷新饼状图
- (BOOL)refreshPieChart {

    @try {
        if (pieChartTempDic) {
            
            NSMutableArray *array = pieChartTempDic[@"data"][@"data"][0][0][@"data"];
            
            if (array.count == 0) {
                
                return NO;
                
            }
            
            NSMutableArray *values = [[NSMutableArray alloc] init];
            NSInteger zeroCount = 0;
            
            double minValve = 0.0;
            
            for (int i = 0; i < array.count; i++ ) {
                
                double xValued = [array[i][@"data"][0][0][@"chartValue"] doubleValue];
                
                if (xValued > minValve) {
                    
                    minValve = xValued;
                    
                }
                
            }
            
            double minDisplayValue = 0.0;
            
            if (minValve < 0) {
                minDisplayValue = 0.0;
            } else {
                minDisplayValue = minValve / 10;
            }
            
            for (int i = 0; i < array.count; i++) {
                
                NSString * lab = [NSString stringWithFormat:@"%@ %@",array[i][@"orgName"],array[i][@"data"][0][0][@"chartValue"]];
                
                double xValued = [array[i][@"data"][0][0][@"chartValue"] doubleValue];
                
                if (xValued <= 0 || xValued < minDisplayValue) {
                    
                    xValued = minDisplayValue;
                    
                }else{
                    
                    xValued = [array[i][@"data"][0][0][@"chartValue"] doubleValue];
                    
                }
                
                
//                [values addObject:[[PieChartDataEntry alloc] initWithValue:xValued label:lab]];
                
                if ([array[i][@"data"][0][0][@"chartValue"] doubleValue] <= 0) {
                    
                    zeroCount++;
                    
                }
                
            }
            
            if (zeroCount == array.count) {
                
                return NO;
                
            }
            
//            PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
//            dataSet.sliceSpace = 3.0 * SCREEN_H_SP;   //间距
//            dataSet.valueLineColor = [UIColor grayColor];
//            dataSet.valueTextColor = [UIColor whiteColor];
//            dataSet.yValuePosition = 2;
//            dataSet.xValuePosition = 2;
//            dataSet.valueLinePart1OffsetPercentage = 0.7;
//            dataSet.valueLinePart1Length = 0.25;
//            dataSet.valueLinePart2Length = 0.2;
//            dataSet.drawValuesEnabled = NO;
//            dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
//            NSMutableArray *colors = [[NSMutableArray alloc] init];
//            [colors addObject:[UIColor colorWithHex:0xb3333a]];
//            [colors addObject:[UIColor colorWithHex:0xc43b3b]];
//            [colors addObject:[UIColor colorWithHex:0xd64949]];
//            [colors addObject:[UIColor colorWithHex:0xe5e5e5]];
//            dataSet.colors = colors;
//
//            PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
//            NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
//            pFormatter.numberStyle = NSNumberFormatterPercentStyle;
//            pFormatter.maximumFractionDigits = 1;
//            pFormatter.multiplier = @1.f;
//            pFormatter.percentSymbol = @" ";
//            [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
//            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
//            [data setValueTextColor:UIColor.grayColor];
//            pieChartView.data = data;
//            ChartHighlight *hl = [[ChartHighlight alloc] initWithX:selectedEntryIndex dataSetIndex:0 stackIndex:0];
//            hl.dataIndex = 1;
//            [pieChartView highlightValueWithHighlight:hl callDelegate:YES];
//            [pieChartView setNeedsDisplay];
//
            return YES;
            
        }
        
        return NO;
 
    } @catch (NSException *exception) {
      
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}

- (void)refreshDateComponentWith:(NSDictionary *) dateDataSource {
    @try {
        NSArray * timeArr = dateDataSource[@"data"][@"data"][0][@"dataBar"];
        
        [dateComponent setTitleWith:timeArr];
        
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
 }


#pragma mark - 刷新数据
- (void)refreshCompareComponent:(NSMutableDictionary *)dateDataSource chartSelectedIndex:(NSInteger)index {
    
    @try {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
        
            NSMutableArray *compareTitleList;
            
            NSMutableArray *compareValueList;
            
            if (_scrollInteger == 1) {
                
                if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                    
                    @try {
                        
                        if (barChartTempDic.count == 0) {
                            
                            return;
                            
                        }
                        
                        if (barChartTempDic.count > 0) {
                            
                            compareTitleList = [[NSMutableArray alloc] initWithArray:dateDataSource[@"data"][@"data"][0][@"compareTitle"]];
                            
                            if ([dateDataSource[@"data"][@"data"][0][@"data"][0] count] < 7) {
                                selectedEntryIndex = selectedEntryIndex -1;
                                compareValueList = [[NSMutableArray alloc] initWithArray:dateDataSource[@"data"][@"data"][0][@"data"][0][selectedEntryIndex][@"compareList"]];
                            }
                            else{
                                compareValueList = [[NSMutableArray alloc] initWithArray:dateDataSource[@"data"][@"data"][0][@"data"][0][selectedEntryIndex][@"compareList"]];
                            }
                            
                            for (NSInteger i = 0; i < _titleLabelArray.count; i++) {
                                
                                UILabel * titleLabel = _titleLabelArray[i];
                                
                                titleLabel.textAlignment = NSTextAlignmentLeft;
                                
                                titleLabel.text = compareTitleList[i];
                                
                                UILabel * valueLabel = _valueLabelArray[i];
                                valueLabel.text = compareValueList[i];
                                
                            }
                        }
                    } @catch (NSException *exception) {
                        
                    } @finally {
                        
                    }
                    
                } else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3) {
                    
                    if (pieChartTempDic.count == 0) {
                        
                        return;
                        
                    }
                    
                    if (pieChartTempDic.count > 0) {
                        compareTitleList =  [[NSMutableArray alloc] initWithArray:dateDataSource[@"data"][@"data"][0][0][@"data"][index][@"compareTitle"]];
                        
                        compareValueList = [[NSMutableArray alloc] initWithArray:dateDataSource[@"data"][@"data"][0][0][@"data"][index][@"data"][0][0][@"compareValueList"]];
                        
                        for (NSInteger i = 0; i < _titleLabelArray.count; i ++)
                        {
                            UILabel * titleLabel = _titleLabelArray[i];
                            titleLabel.textAlignment = NSTextAlignmentCenter;
                            
                            UILabel * valueLabel = _valueLabelArray[i];
                            titleLabel.text = compareTitleList[i];
                            valueLabel.text = compareValueList[i];
                            
                        }
                        
                    }
                    
                }

            }
            
        });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
       [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    }
    
}

#pragma mark - 刷新折线图数据
//- (LineChartData *)refreshLineDataWithDataSource:(NSDictionary *)dataSource{
//
//    @try {
//        LineChartData *lineChartData = [[LineChartData alloc] init];
//
//        if (dataSource) {
//
//            NSArray *dataArray = dataSource[@"data"][@"data"][0][@"data"][0];
//
//            for (int i = 0; i < _colorIncreaseArray.count; i++) {
//
//            if ([[_increaseMutableDictionary objectForKey:[NSString stringWithFormat:@"%d",i]] isEqualToString:@"aa"])
//            {
//
//                   NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//
//                    for (int j = 0; j < dataArray.count; j++) {
//
//                        [values addObject:@([dataArray[j][@"chartCompareList"][i][@"chartCompareValueLine"] doubleValue])];
//
//                    }
//
//                LineChartDataSet *lineChartDataSet = [self lineChartDataSetWithValues:values color:_colorIncreaseArray[i]];
//
//                    [lineChartData addDataSet:lineChartDataSet];
//
//                }
//
//
//            }
//        }
//
//
//        return lineChartData;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//       [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//
//}


#pragma mark - 回调 刷新条状图（竖直方法）
//- (BarChartData *)refreshBarChartDataWithDataSource:(NSDictionary *)dataSource {
//
//    @try {
//        BarChartData *d = [[BarChartData alloc] init];
//
//        if (dataSource) {
//
//            NSArray *array = dataSource[@"data"][@"data"][0][@"data"][0];
//            NSMutableArray <NSNumber *>* values = [NSMutableArray array];
//
//            for (int i = 0; i < array.count; i++) {
//
//                [values addObject:@([array[i][@"chartValue"] doubleValue])];
//
//            }
//
//            BarChartDataSet *bcd = [self barChartDataSetWithValues:values];
//
//            [d addDataSet:bcd];
//
//        }
//
//        if (d.dataSets && d.dataSets.count > 0) {
//
//            return d;
//
//        } else {
//
//            return nil;
//
//        }
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//       [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//
//}

#pragma mark - 数据装载前 折线图横坐标的设定
//- (LineChartDataSet *)lineChartDataSetWithValues:(NSArray <NSNumber *>*)values  color:(UIColor *)color{
//
//    @try {
//
//        NSMutableArray *entries = [[NSMutableArray alloc] init];
//
//        for (int index = 0; index < values.count; index++) {
//
//            if (values.count > 0) {
//
//                [entries addObject:[[ChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//
//            }
//            if (entries.count == values.count) {
//                [entries addObject:[[ChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//            }
//        }
//
//        LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:@"Line DataSet"];
//        [set setColor:color];
//        set.drawHorizontalHighlightIndicatorEnabled=NO;  //去掉线
//        set.drawVerticalHighlightIndicatorEnabled=NO;
//        [set setHighlightEnabled:NO];
//        set.lineWidth = 1.5;
//        [set setCircleColor:color];
//        set.circleRadius = 3.0;
//        set.circleHoleRadius = 0;
//        set.drawCircleHoleEnabled = YES;
//        set.fillColor = color;
//        set.mode = LineChartModeLinear;
//        set.drawValuesEnabled = YES;
//
//        set.valueFont = [UIFont systemFontOfSize:13*SCREEN_H_SP];
//
//        set.valueColors = @[color];
//        set.axisDependency = AxisDependencyLeft;
//
//        NSNumberFormatter *leftAxisFormatter = [[NSNumberFormatter alloc] init];
//        leftAxisFormatter.minimumFractionDigits = 0.0;
//        leftAxisFormatter.maximumFractionDigits = 1.0;
//        leftAxisFormatter.minimumIntegerDigits = 1;
//        set.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:leftAxisFormatter];
//        return set;
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//
//}

#pragma mark - 数据装载前 条状图横坐标的设定
//- (BarChartDataSet *)barChartDataSetWithValues:(NSArray <NSNumber *>*)values {
//
//    @try {
//        NSMutableArray *yVals = [[NSMutableArray alloc] init];
//
//        for (int index = 0; index < values.count; index++) {
//
//            [yVals addObject:[[BarChartDataEntry alloc] initWithX:index y:values[index].doubleValue]];
//
//        }
//
//        BarChartData *data1;
//        BarChartDataSet *set = [[BarChartDataSet alloc] initWithValues:yVals label:@"DataSet"];
//        set.drawValuesEnabled = NO;
//        [set setColor:[[UIColor colorWithHex:0xd7d7d7] colorWithAlphaComponent:1.0]];
//        [set setHighlightColor:[UIColor redColor]];
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set];
//        data1 = [[BarChartData alloc] initWithDataSets:dataSets];
//        data1.barWidth = 0.4f;
//        return set;
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//}

#pragma mark - Notification


#pragma mark - 品牌名选中的title所对应的code

- (void)brandToYeJi:(NSString *)orgCode {
    
    @try {
        _followOrgCode = orgCode;
        
        topLeftBarOrgCode = orgCode;
      
        baseOrgCode = orgCode;
        
        downDrillOrgCode = @"";
        
        headOrgCode = @"";
        
        topLeftView.backgroundColor = [UIColor colorWithHex:0xb3333a];
        
        
        //  刷新整个业绩看板页面
//        [self initRequestThreadWithCount:2 isStratAnimat:YES];
        
        [_selectIndexDic removeAllObjects];
        
        if (_scrollInteger == 1) {
           
            BOOL netStatus=NO;
            netStatus = [CommonTools isConnectionAvailable:self];
            
            if (netStatus) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
                if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                    
                    [self requestStoreTargetDetails:baseOrgCode];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:baseOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
            }
            else{
                [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            }

        }
               // [self refreshChartWithRequestData:YES];
        
//        TableViewCellForYejiTopRight *topRightCell = [topRightTableView cellForRowAtIndexPath:topRightIndexPath];
//        
//        if (topRightCell != nil) {
//            
//            topRightCell.selected = NO;
//            topRightIndexPath = nil;
//            
//        }
        
        if (horizontalBarIndexPath) {
            
            TableViewChartCell *horizontalBarChartCell = [horizontalBarChartView cellForRowAtIndexPath:horizontalBarIndexPath];
            
            if (horizontalBarChartCell != nil) {
                
                horizontalBarChartCell.selected = NO;
                [horizontalBarChartCell.numBtn setBackgroundColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
                
            }
            
        }
  
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}

#pragma mark - 日历 @param notification <#notification description#>

- (void)renjia1:(NSDate *)fromDate :(NSDate *)toDate{
    @try {

        [AppDatas sharedDatas].selectFromDate = fromDate;
        [AppDatas sharedDatas].selectToDate = toDate;
        
        
        if (_scrollInteger == 1) {
         
            BOOL netStatus=NO;
            netStatus = [CommonTools isConnectionAvailable:self];
            
            if (netStatus) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
                if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:_followOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                    
                    [self requestStoreTargetDetails:_followOrgCode];
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:_followOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                
            }
            else{
                [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            }

        }
        
//        [self initRequestThreadWithCount:2 isStratAnimat:YES];
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}

#pragma mark - 上半部左边视图点击事件回调

- (void)tapedHandleSingle:(UITapGestureRecognizer *)sender {
    @try {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
        
           headOrgCode = @"";
            
           [_selectIndexDic removeAllObjects];
            
            topLeftView.backgroundColor = [UIColor colorWithHex:0xb3333a];
            
            _followOrgCode = baseOrgCode;
            
        if (_scrollInteger == 1) {
         
            BOOL netStatus=NO;
            netStatus = [CommonTools isConnectionAvailable:self];
            
            if (netStatus) {
                
                if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                    
                    
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                }
                else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestStoreTargetDetails:baseOrgCode];
                    
                }
                else if(chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                    
                    NSString * pieOrgCode;
                    if (downDrillOrgCode.length > 0) {
                        pieOrgCode = downDrillOrgCode;
                    }
                    else{
                        pieOrgCode =  baseOrgCode;
                    }
                    
                    _followOrgCode = pieOrgCode;
                    _selectIndexDic = nil;
                    _selectIndexDic = [[NSMutableDictionary alloc]init];
                    
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    [self requestHeadWithCache:YES orgCode:pieOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:pieOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    // [self refreshChartWithRequestData:YES];
                }
                
            }
            else{
                [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            }

        }
      
        });
    } @catch (NSException *exception) {
        
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}


#pragma mark -  按钮下钻点击事件回调

- (void)tapedDrillButton:(UIButton *)sender {
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
        //    收费用户可用
        NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
        
        if (userType == 2) {
            
            HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
            HUD.delegate = self;
            HUD.mode = MBProgressHUDModeText;
            HUD.labelText = @"收费用户可用";
            HUD.margin = 10.f;
            HUD.removeFromSuperViewOnHide = YES;
            [HUD hide:YES afterDelay:2];
            
        } else {
            
            _downDrillInteger = 2;
            
            headOrgCode = @"";
            topLeftView.backgroundColor = [UIColor colorWithHex:0xb3333a];
            
            NSString *drillOrgCode = pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgCode"];
//            topLeftBarOrgCode = drillOrgCode;
//            
//            downDrillOrgCode = drillOrgCode;
            
            [_selectIndexDic removeAllObjects];

            BOOL netStatus=NO;
            netStatus = [CommonTools isConnectionAvailable:self];
            
            if (netStatus) {
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                
                [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:drillOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
            }
            else{
                [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
            }

        }
        });
    } @catch (NSException *exception) {
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
    
}



#pragma mark - BigBtnViewDelegate

- (void)bigBtnView:(BigBtnView *)bigBtnView index:(NSInteger)index {
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
            
        selectedDateComponentIndex = index+1;
            
        if (_scrollInteger == 1) {
            
            if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    NSString * orgCode;
                    
                    if (headOrgCode.length > 0) {
                        orgCode = headOrgCode;
                    }
                    else{
                        orgCode = baseOrgCode;
                    }
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:orgCode timeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
            }
            else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                
                [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                NSString * orgCode;
                
                if (headOrgCode.length > 0) {
                    orgCode = headOrgCode;
                }
                else{
                    orgCode = baseOrgCode;
                }
                
                [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                
                [self requestStoreTargetDetails:orgCode];
                
            }
            else if(chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                
                NSString * pieOrgCode;
                if (downDrillOrgCode.length > 0) {
                    pieOrgCode = downDrillOrgCode;
                }
                else{
                    pieOrgCode =  baseOrgCode;
                }
                
                if (headOrgCode.length > 0) {
                    pieOrgCode = headOrgCode;
                }
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:pieOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
            }

        }
            
        });
    } @catch (NSException *exception) {
    
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
   
}

#pragma mark - UITableViewDataSource & UITabBarDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    @try {
        
       return tableView == topRightTableView ? [headDataTempDic[@"data"][@"rightBar"] count] : [pieChartTempDic[@"data"][@"data"][0][0][@"data"] count];
        
    } @catch (NSException *exception) {
      
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
   
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        if (tableView == horizontalBarChartView) {
            @try {
                double unitWidth, maxLength = SCREEN_WIDTH / 4 - 10 * SCREEN_W_SP;
                NSMutableArray *dataArray = pieChartTempDic[@"data"][@"data"][0][0][@"data"];
                
                if ([dataArray[indexPath.row][@"data"][0][0][@"chartValue"] doubleValue] > 0) {
                    
                    unitWidth = [dataArray[indexPath.row][@"data"][0][0][@"chartValue"] doubleValue] / [dataArray[0][@"data"][0][0][@"chartValue"] doubleValue] * maxLength;
                    unitWidth = unitWidth > maxLength ? maxLength : unitWidth;
                    
                } else {
                    
                    unitWidth = 0;
                    
                }
                
                TableViewChartCell *cell = [[TableViewChartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewChartCellFor" WithWidth:unitWidth];
                [cell.rankBtn setTitle:[NSString stringWithFormat:@"%ld",indexPath.row + 1 ] forState:UIControlStateNormal];
                cell.nameLab.text = dataArray[indexPath.row][@"orgName"];
                cell.countLab.text = dataArray[indexPath.row][@"data"][0][0][@"chartValue"];
                UIView *cellBackView = [[UIView alloc]initWithFrame:cell.frame];
                cellBackView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
                cell.selectedBackgroundView = cellBackView;
                
                
                if (horizontalBarIndexPath != nil && indexPath.row == horizontalBarIndexPath.row) {
                    
                    [cell.numBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
                    
                } else {
                    
                    [cell.numBtn setBackgroundColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
                    
                }
                
                switch (indexPath.row) {
                        
                    case 0:
                        
                        [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
                        [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.rankBtn.frame = CGRectMake(10, 14, 20, 20);
                        cell.rankBtn.layer.cornerRadius = 10;
                        break;
                        
                    case 1:
                        
                        [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xff782f] forState:UIControlStateNormal];
                        [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.rankBtn.frame = CGRectMake(10, 14, 20, 20);
                        cell.rankBtn.layer.cornerRadius = 10;
                        
                        break;
                        
                    case 2:
                        
                        [cell.rankBtn setBackgroundColor:[UIColor colorWithHex:0xffae28] forState:UIControlStateNormal];
                        [cell.rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        cell.rankBtn.frame = CGRectMake(10, 14, 20, 20);
                        cell.rankBtn.layer.cornerRadius = 10;
                        
                        break;
                        
                    default:
                        
                        [cell.rankBtn setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
                        [cell.rankBtn setTitleColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
                        
                        break;
                        
                }
                
                return cell;

            } @catch (NSException *exception) {
            
                 [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
                
                 [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
                
            } @finally {
                
            }
            
        } else {
           
            @try {
                static NSString *CellIdentifier = @"Cell";
                UITableViewCell *cell=nil;
                if (cell==nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    if (SCREEN_WIDTH > 414) {
                        cell.bounds = CGRectMake(0, 0, _topView.width,60);
                    }
                    UIView  * selectView = [[UIView alloc] init];
                    selectView.frame = CGRectMake(0, 0, cell.width, cell.height);
                    selectView.tag = 13;
                    [cell.contentView addSubview:selectView];
                    
                    cell.backgroundColor = [UIColor colorWithRed:0.608 green:0.000 blue:0.098 alpha:1.00];
                    UILabel *  _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, 75 * SCREEN_W_SP, cell.contentView.height)];
                    _titleLabel.textColor = [UIColor whiteColor];
                    _titleLabel.textAlignment = NSTextAlignmentLeft;
                    _titleLabel.font = [UIFont systemFontOfSize:14];
                    [cell.contentView addSubview:_titleLabel];
                    _titleLabel.tag = 11;
                    
                    UILabel * _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(60* SCREEN_W_SP, 0, 80* SCREEN_W_SP, cell.contentView.height)];
                    _valueLabel.textColor = [UIColor whiteColor];
                    _valueLabel.textAlignment = NSTextAlignmentRight;
                    _valueLabel.font = [UIFont systemFontOfSize:14];
                    [cell.contentView addSubview:_valueLabel];
                    _valueLabel.tag = 12;
                    
                    
                }
                
                UILabel * titleLabel = (UILabel *)[cell viewWithTag:11];
                titleLabel.text = headDataTempDic[@"data"][@"rightBar"][indexPath.row][@"orgName"];
                
                UILabel * valueLabel = (UILabel *)[cell viewWithTag:12];
                
                if (chartScrollView.contentOffset.x == 0) {
                    
                    valueLabel.text = headDataTempDic[@"data"][@"rightBar"][indexPath.row][@"data"][0][selectedEntryIndex][@"value"];
                    
                    
                } else {
                    
//                    NSArray *dateArray = headDataTempDic[@"data"][@"rightBar"][indexPath.row][@"data"][0];
                  
                    valueLabel.text = headDataTempDic[@"data"][@"rightBar"][indexPath.row][@"data"][0][_touchTopRightInteger][@"value"];
                    
                }
                
                UIView * selectView = (UIView *)[cell viewWithTag:13];
                
                if ([_selectIndexDic[[NSString stringWithFormat:@"%ld",(long)indexPath.row]] isEqualToString:@"a"])
                {
                    selectView.backgroundColor = Color(194, 60, 63);
                }
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } @catch (NSException *exception) {
             
                 [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
                
                [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
                
            } @finally {
                
            }
            
        }
  
    } @catch (NSException *exception) {
        
    }
    
    
}

- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        
        TableViewCellForYejiTopRight *topRightCell = [topRightTableView cellForRowAtIndexPath:topRightIndexPath];
        
        if (topRightCell != nil) {
            
            topRightCell.selected = NO;
            
        }
        
        if (tableView == horizontalBarChartView) {
            
            TableViewChartCell *horizontalBarChartCell = [horizontalBarChartView cellForRowAtIndexPath:horizontalBarIndexPath];
            
            if (horizontalBarChartCell != nil) {
                
                horizontalBarChartCell.selected = NO;
                [horizontalBarChartCell.numBtn setBackgroundColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
                
            }
            
        }
        
        return indexPath;
        
    } @catch (NSException *exception) {
      
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    @try {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
            
        if (tableView == topRightTableView) {
            
            
            topLeftView.backgroundColor = [UIColor colorWithHex:0x9e262d];
            
            [_selectIndexDic removeAllObjects];
            
            [_selectIndexDic setObject:@"a" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
            
            topRightIndexPath = indexPath;
            headOrgCode = headDataTempDic[@"data"][@"rightBar"][indexPath.row][@"orgCode"];
            
            [topRightTableView reloadData];

            _followOrgCode = headOrgCode;
            
            [self touchRightTopView];
            
            
        } else if (tableView == horizontalBarChartView) {
            
            horizontalBarIndexPath = indexPath;
//            NSString * drawType = pieChartTempDic[@"data"][@"data"][0][0][@"drillType"];
            
            chartOrgCode = pieChartTempDic[@"data"][@"data"][0][0][@"data"][indexPath.row][@"orgCode"];
            
            
            TableViewChartCell *horizontalBarChartCell = [tableView cellForRowAtIndexPath:indexPath];
            [horizontalBarChartCell.numBtn setBackgroundColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            
             [self  refreshCompareComponent:pieChartTempDic chartSelectedIndex:indexPath.row];

        }
        });
    } @catch (NSException *exception) {
     
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}


-(void)touchRightTopView{
    @try {
     
        if (_scrollInteger == 1) {
            
            if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:headOrgCode timeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    // [self refreshChartWithRequestData:YES];
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
                
            }
            else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                
                [self requestStoreTargetDetails:headOrgCode];
                
            }
            else if(chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:headOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
                
            }
 
        }
            
    } @catch (NSException *exception) {
    
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
        [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    @try {
     
        if (scrollView == baseScrollView) {
            
            [animationView startAnimation];
            
        }
        
    } @catch (NSException *exception) {
     
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark - 即将结束拖拽

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
  
    @try {
        if (baseScrollView) {
            
            if (scrollView == baseScrollView) {
                
                [animationView  stopAnimating];
                
            }
            
            
            if (baseScrollView.contentOffset.y < -25) {
                
                 baseScrollView.contentInset = UIEdgeInsetsMake(80.0f, 0.0f, 0.0f, 0.0f);
                
                [animationView startAnimation1];
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    
                    if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                        
                        [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:_followOrgCode timeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    }
                    else if (chartScrollView.contentOffset.x == SCREEN_WIDTH* 2){
                        
                        [self requestStoreTargetDetails:_followOrgCode];
                    }
                    else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                        
                        [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:_followOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",(long)selectedDateComponentIndex]];
                    }
                    
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
               
                
            }
            
        }

    } @catch (NSException *exception) {
     
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    @try {
        if (scrollView == chartScrollView) {
            
            downDrillOrgCode = @"";
            
            headOrgCode = @"";
            
            _followOrgCode = baseOrgCode;
            
            _selectIndexDic = nil;
            _selectIndexDic = [[NSMutableDictionary alloc]init];
            
            if (chartScrollView.contentOffset.x== SCREEN_WIDTH*4) {
                chartScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            }
            if (chartScrollView.contentOffset.x== 0) {
                chartScrollView.contentOffset=CGPointMake(SCREEN_WIDTH*3, 0);
            }

         //   chartScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
            
            if (chartScrollView.contentOffset.x == SCREEN_WIDTH) {
                
                _touchTopRightInteger = 6;
                
            for (NSInteger i = 0; i < _titleLabelArray.count; i++) {
                    
                    UILabel * roundLabel = _roundLabelArray[i];
                    
                    UILabel * titleLabel = _titleLabelArray[i];
                    
                    if (SCREEN_WIDTH == 320) {
                        roundLabel.frame = CGRectMake(17, 10, 10, 10);
                        
                        titleLabel.frame = CGRectMake(32, 5, SCREEN_WIDTH/3 - 30-5, 20);
                    }
                    else if(SCREEN_WIDTH == 375){
                        roundLabel.frame = CGRectMake(26 * SCREEN_W_SP, 10, 10, 10);
                        
                        titleLabel.frame = CGRectMake(41 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                    }
                    else if (SCREEN_WIDTH == 414){
                        
                        roundLabel.frame = CGRectMake(28 * SCREEN_W_SP, 10, 10, 10);
                        
                        titleLabel.frame = CGRectMake(43 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                        
                    }
                    titleLabel.textAlignment = NSTextAlignmentLeft;
                    if (i == 1) {
                        
                        if (SCREEN_WIDTH == 320) {
                            roundLabel.frame = CGRectMake(5, 10, 10, 10);
                            
                            titleLabel.frame = CGRectMake(20, 5, SCREEN_WIDTH/3 - 30-5, 20);
                        }
                        else if(SCREEN_WIDTH == 375){
                            roundLabel.frame = CGRectMake(12 * SCREEN_W_SP, 10, 10, 10);
                            
                            titleLabel.frame = CGRectMake(27 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                        }
                        else if (SCREEN_WIDTH == 414){
                            
                            roundLabel.frame = CGRectMake(15 * SCREEN_W_SP, 10, 10, 10);
                            
                            titleLabel.frame = CGRectMake(30 * SCREEN_W_SP, 5, SCREEN_WIDTH/3 - 40-5, 20);
                        }
                        
                    }
                }
                
                _increaseView.hidden = NO;
                
                selectedEntryIndex = 6;
                
                [_increaseMutableDictionary removeAllObjects];
                [_increaseMutableDictionary setObject:@"aa" forKey:[NSString stringWithFormat:@"0"]];
                
                for (NSInteger i = 0; i < _increaseButtonArray.count; i++) {
                    UIButton * increaseButton = _increaseButtonArray[i];
                    UILabel  * titleLabel = _titleLabelArray[i];
                    
                    [increaseButton setEnabled:YES];
                    increaseButton.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
                    
                    if (i == 0) {
                        increaseButton.backgroundColor = [UIColor whiteColor];
                        increaseButton.selected = YES;
                        titleLabel.textColor = [UIColor colorWithHex:0xb3333a];
                    }
                    else{
                        increaseButton.selected = NO;
                        
                        titleLabel.textColor = [UIColor colorWithHex:0xa8a8a8];
                    }
                    
                    UILabel * roundLabel = _roundLabelArray[i];
                    roundLabel.hidden = NO;
                    
                }
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshCombinedBarCharWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self.delegate transMitheadTitle:pieChartTempDic[@"data"][@"data"][0][0][@"data"][0][@"orgCode"] nameString:pieChartTempDic[@"data"][@"data"][0][0][@"data"][0][@"orgName"]];
                    
                    // [self refreshChartWithRequestData:YES];
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
                
            }
            else if (chartScrollView.contentOffset.x == SCREEN_WIDTH * 2){
                
                _touchTopRightInteger = 6;
                
                _increaseView.hidden = YES;
                
                [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
                [self requestStoreTargetDetails:baseOrgCode];
            }
            else if(chartScrollView.contentOffset.x == SCREEN_WIDTH * 3){
                
                _touchTopRightInteger = 6;
                
                for (NSInteger i = 0; i < _titleLabelArray.count; i ++)
                {
                    UILabel * titleLabel = _titleLabelArray[i];
                    titleLabel.frame = CGRectMake(0, 5, self.width/3, 20);
                    titleLabel.textAlignment = NSTextAlignmentCenter;

                }

//                _scrollInteger = 2;
//                
//                [_centerPageChartBaseView removeFromSuperview];
//                _centerPageChartBaseView = nil;
                
//                chartScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
//                rightPageChartBaseView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, chartScrollView.frame.size.height - 55);
                
                _increaseView.hidden = NO;
                
                for (NSInteger i = 0; i < _increaseButtonArray.count; i++) {
                    UIButton * increaseButton = _increaseButtonArray[i];
                    
                    UILabel  * titleLabel = _titleLabelArray[i];
                    titleLabel.textColor = [UIColor colorWithHex:0xb3333a];
                    
                    
                    [increaseButton setEnabled:NO];
                    increaseButton.backgroundColor = [UIColor whiteColor];
                    
                    UILabel * roundLabel = _roundLabelArray[i];
                    roundLabel.hidden = YES;
                }
                
                BOOL netStatus=NO;
                netStatus = [CommonTools isConnectionAvailable:self];
                
                if (netStatus) {
                    [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
                    
                    
                    [self requestHeadWithCache:YES orgCode:baseOrgCode timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                    [self requestDataAndRefreshPieChartWithCache:YES WithOrgCode:baseOrgCode WithtimeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                    
                }
                else{
                    [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
                }
                
                
            }
        }
    } @catch (NSException *exception) {
     
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

#pragma mark 滑动到第二页店铺指标详情
-(void)requestStoreTargetDetails:(NSString *)orgCodeString{
    
    @try {
        
         [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        
        RequestInterfceViewController * RequestInterfceVC = [[RequestInterfceViewController alloc]init];
        
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
        
        [dic setObject:[AppDatas sharedDatas].userCode forKey:@"user_code"];
        
        [dic setObject:orgCodeString forKey:@"org_array"];
        
        [dic setObject:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex] forKey:@"time_level"];
        
        [dic setObject: [LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"] forKey:@"start_date"];
        
        [RequestInterfceVC requestEnrollInterface:@"com.bizvane.sun.usee.method.news.ChartDetailTrend" requestDic:dic];
        
        RequestInterfceVC.successBlock = ^(NSDictionary * dataDic){
            
            if ([dataDic[@"status"] isEqualToString:@"success"]) {
                
                [[HUDHelper getInstance] hideHUD];
                
                [animationView stopAnimating1];
                baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
                NSMutableArray * dataArray;
                
                if (selectedDateComponentIndex == 1) {
                    
                    dataArray = [[NSMutableArray alloc] initWithArray:dataDic[@"data"][@"dataDay"]];
                }
                else if (selectedDateComponentIndex == 2){
                    
                    dataArray = [[NSMutableArray alloc] initWithArray:dataDic[@"data"][@"dataWeek"]];
                }
                else if (selectedDateComponentIndex == 3){
                    
                    dataArray = [[NSMutableArray alloc] initWithArray:dataDic[@"data"][@"dataMonth"]];
                }
                else if (selectedDateComponentIndex == 4){
                    
                    dataArray = [[NSMutableArray alloc] initWithArray:dataDic[@"data"][@"dataYear"]];
                }
                
                for (NSInteger i = 0; i < _nameLabelArray.count; i ++) {
                    UILabel * nameLabel = _nameLabelArray[i];
                    UILabel * valueLabel = _twoValueLabelArray[i];
                    nameLabel.text = [NSString stringWithFormat:@"%@",dataArray[i][@"compareTitle"]];
                    valueLabel.text = [NSString stringWithFormat:@"%@",dataArray[i][@"compareValue"]];
                }
            }
            else{
                
                 [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
            }
            
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
       
             [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
            
           [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
            
        } @finally {
            
        }
    
}

#pragma mark - ChartViewDelegate : 图表被点击时的回调

//- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight {
//
//    @try {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
//
//        selectedEntryIndex = highlight.x;
//
//        if (chartView == combinedChartView) {
//
//            topLeftTitle.text = headDataTempDic[@"data"][@"leftBar"][@"title"];
//            topLeftValue.text = headDataTempDic[@"data"][@"leftBar"][@"data"][0][(int)highlight.x][@"value"];
//
//             _touchTopRightInteger = selectedEntryIndex;
//            [topRightTableView reloadData];
//
//             [self  refreshCompareComponent:barChartTempDic chartSelectedIndex:(int)highlight.x];
//
//        } else if (chartView == pieChartView) {
//
//            horizontalBarIndexPath = [NSIndexPath indexPathForItem:(int)highlight.x inSection:0];
//
//            chartOrgCode = pieChartTempDic[@"data"][@"data"][0][0][@"data"][(int)highlight.x][@"orgCode"];
//
//            drillButton != nil ? [drillButton setHidden:NO] : nil;
//
//            [self  refreshCompareComponent:pieChartTempDic chartSelectedIndex:(int)highlight.x];
//
//        }
//        });
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//
//    }
//}



//- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView {
//    @try {
//
//        ChartHighlight *hl = [[ChartHighlight alloc] initWithX:selectedEntryIndex dataSetIndex:0 stackIndex:0];
//        hl.dataIndex = 1;
//
//        [chartView highlightValueWithHighlight:hl callDelegate:NO];
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//
//
//}

#pragma mark - IChartAxisValueFormatter : 图表展示前横坐标的处理（比如每年最后一周为52，下一年第一周为1）

//- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis {
//
//    @try {
//        if (barChartTempDic) {
//
//            NSArray *array = barChartTempDic[@"data"][@"data"][0][@"data"][0];
//            NSInteger index = value;
//            NSString *str = [NSString stringWithFormat:@"%@",array[index][@"xAxis"]];
//
//            //[NSString stringWithString:];
//
//            return str;
//
//        } else {
//
//            NSString *str = [NSNumber numberWithDouble:value].stringValue;
//
//            return str;
//
//        }
//
//    } @catch (NSException *exception) {
//
//         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
//
//          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
//    }
//}

#pragma mark - 请求上半部数据

- (void)requestHeadWithCache:(BOOL)isUseCache orgCode:(NSString *)orgCode timeType:(NSString *)timeType {
    
    @try {
        
     //   headDataTempDic = nil;
     //   headDataTempDic = [[NSMutableDictionary alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            NSDictionary * requestDic = [NSDictionary dictionaryWithObjectsAndKeys:
             
             [AppDatas sharedDatas].userCode, @"user_code",
             [LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"],@"start_date",
             [LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"],@"end_date",
             orgCode, @"org_code",
             timeType,@"time_level",
             nil];

            
            
            [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.ScreenPerf"
                         dataParameters:requestDic                              withCache:isUseCache
                                success:^(NSDictionary *responseDic) {
                                    
                        dispatch_async(dispatch_get_main_queue(), ^{
                                        
                        [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                                        
             if ([responseDic[@"status"] isEqualToString:@"success"]) {
                        
                    baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    [animationView stopAnimating1];
                        
                    headDataTempDic = [[NSMutableDictionary alloc] initWithDictionary:responseDic];
                        
                    [self refreshHeadWithRequestData:NO];
                }
                            
                                        
                });
            } failure:^(NSError *error) {
                                   
                    dispatch_async(dispatch_get_main_queue(), ^{
                                        
                    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                                        
                                      //  [UIView animateWithDuration:.4 animations:^{
                    baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    [animationView stopAnimating1];
                    
                                            
                                   //     }];
                                        
                                    //    [self changeRequestThreadWithStatus:@"FAILED" ResponseCode:error.code isCheckRequestAllEnd:YES];
                                        
                                    });
                                }];
        });
 
    } @catch (NSException *exception) {
       
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    }
}


#pragma mark -  请求柱状图数据

- (void)requestDataAndRefreshCombinedBarCharWithCache:(BOOL)isUseCache orgCode:(NSString *)orgCode timeType:(NSString *)timeType {
    
    @try {
        barChartTempDic = nil;
        
        barChartTempDic = [[NSMutableDictionary alloc]init];
        pieChartTempDic = nil;
        
        pieChartTempDic = [[NSMutableDictionary alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            
         NSDictionary * dataDic  =  [NSDictionary dictionaryWithObjectsAndKeys:
             [AppDatas sharedDatas].userCode, @"user_code",
             [LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"], @"start_date",
             [LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"], @"end_date",
             orgCode, @"org_array",
             timeType, @"time_level",
             nil];
            
            
            [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.ChartTrendPerf"
                         dataParameters:dataDic
                              withCache:isUseCache
                                success:^(NSDictionary *responseDic) {
                                    
                            dispatch_async(dispatch_get_main_queue(), ^{
                                        
                            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                                        
               if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                            
                   [[HUDHelper getInstance] hideHUD];
                   
                   baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                   
                   [animationView stopAnimating1];

                   barChartTempDic = [[NSMutableDictionary alloc] initWithDictionary:responseDic];
                   
                  [self  refreshCompareComponent:barChartTempDic chartSelectedIndex:0];
                   
                  [self refreshCombinedBarChar:barChartTempDic];
                                            
                }
                else{
                    
                           baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                    
                           [animationView stopAnimating1];
                    
                            [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                    
            }
                                      
                     //   [self refreshChartWithRequestData];
                                
                                //    [self changeRequestThreadWithStatus:responseDic[@"status"] ResponseCode:200 isCheckRequestAllEnd:YES];
                                        
                                    });
                                } failure:^(NSError *error) {
                                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                      
                    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                        
                    baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    [animationView stopAnimating1];
                        
                [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                
                });
                                    
            }];
        });
 
    } @catch (NSException *exception) {
      
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}



#pragma mark -  请求环形图数据

- (void)requestDataAndRefreshPieChartWithCache:(BOOL)isUseCache WithOrgCode:(NSString *)orgCode WithtimeType:(NSString *)timeType {
    
    @try {
      
        barChartTempDic = nil;
        
        barChartTempDic = [[NSMutableDictionary alloc]init];

        barChartTempDic = nil;
        
        barChartTempDic = [[NSMutableDictionary alloc]init];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      [AppDatas sharedDatas].userCode, @"user_code",
                                      [LOSHelper stringFromDate:[AppDatas sharedDatas].selectFromDate withFormatter:@"yyyyMMdd"], @"start_date",
                                      [LOSHelper stringFromDate:[AppDatas sharedDatas].selectToDate withFormatter:@"yyyyMMdd"], @"end_date",
                                      orgCode, @"org_array",
                                      timeType, @"time_level",
                                      nil];
            if (_downDrillInteger == 2) {
               
                [dataDic setObject:@"1" forKey:@"drill_store"];
            }
            
            [[LOSAFNetworking new] POST:@"com.bizvane.sun.usee.method.news.ChartRatioPerf"
                         dataParameters:dataDic                              withCache:isUseCache
                                success:^(NSDictionary *responseDic) {
                                    
            dispatch_async(dispatch_get_main_queue(), ^{
                        
                    [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                                        
            if ([responseDic[@"status"] isEqualToString:@"success"]) {
                
                [[HUDHelper getInstance] hideHUD];
                
                baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                
                [animationView stopAnimating1];
                
              NSArray * responseArray = responseDic[@"data"][@"data"][0][0][@"data"];
                
            if (responseArray.count == 0) {
                    
                _downDrillInteger = 1;
                    
                return ;
            }
   
            if (_downDrillInteger == 2) {
                
               
                [self requestHeadWithCache:YES orgCode:pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgCode"] timeType:[NSString stringWithFormat:@"%ld",selectedDateComponentIndex]];
                
                if ([pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgCode"] length] > 0)
                {
                  baseOrgCode = pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgCode"];
                }
                
                [self.delegate transMitheadTitle:pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgCode"] nameString:pieChartTempDic[@"data"][@"data"][0][0][@"data"][horizontalBarIndexPath.row][@"orgName"]];
                
                _downDrillInteger = 1;
            }
   
             pieChartTempDic = [[NSMutableDictionary alloc] initWithDictionary:responseDic];
                
                        [self  refreshCompareComponent:pieChartTempDic chartSelectedIndex:0];
                                            
                        [self refreshBottomChart];
                                            
                    }
                    else{
                    
                        baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                        [animationView stopAnimating1];
                        
                    [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                        
                    }
                                      
                });
                                    
                } failure:^(NSError *error) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                      [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate: [NSDate date]]; //立即返回
                                        
                           baseScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                                            
                           [animationView stopAnimating1];
                           
                            [[HUDHelper getInstance] hideHUD];
                                    
                            [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];

                        });
                }];
            
        });
        
    } @catch (NSException *exception) {
      
         [[NSUserDefaults standardUserDefaults] setObject:@"业绩看板 YeJiView" forKey:@"crashTheClassName"];
        
          [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
    
    
}

@end
