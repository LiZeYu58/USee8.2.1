//
//  LeftSlideViewController.m
//  LeftSlideViewController
//
//  Created by huangzhenyu on 15/06/18.
//  Copyright (c) 2015年 huangzhenyu. All rights reserved.

#import "LeftSlideViewController.h"
#import "LeftSortsViewController.h"
#import "ShangPinView.h"
#import "DianPuView.h"
#import "GuanJianView.h"
#import "SPView.h"
#import "DaoGouView.h"

@interface LeftSlideViewController ()<UIGestureRecognizerDelegate, LeftSortsViewControllerDelegate>
{
    CGFloat _scalef;  //实时横向位移
    UIView *_leftView2;
    UIView *_leftView3;
    
    NSMutableDictionary *_leftDatas;
}

@property (nonatomic,strong) UITableView *leftTableview;
@property (nonatomic,assign) CGFloat leftTableviewW;
@property (nonatomic,strong) UIView *contentView;
@end


@implementation LeftSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @try {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftPiCodeString:) name:@"ToBeforeLeftClose" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clearGuanJianLeft) name:@"clearGuanJianLeftDatas" object:nil];
        
        //    @"ToSlideVCAndReplaceLeftDatas"
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(replaceLeftDatas:) name:@"ToSlideVCAndReplaceLeftDatas" object:nil];
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

-(void)replaceLeftDatas:(NSNotification *)notif{

    @try {
        
        _leftDatas = [NSMutableDictionary new];
        _leftDatas = notif.object;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
}

-(void)leftPiCodeString:(NSNotification *)notif{

    @try {
     
        _leftDatas = [NSMutableDictionary new];
        _leftDatas = notif.object;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }

}

-(void)clearGuanJianLeft{

    @try {
        
         _leftDatas = nil;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
}

/**
 @brief 初始化侧滑控制器
 @param leftVC 左视图控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象
 */
- (instancetype)initWithLeftView:(LeftSortsViewController *)leftVC
                     andMainView:(UIViewController *)mainVC
{
    @try {
       
        if(self = [super init]){
            self.speedf = vSpeedFloat;
            
            self.leftVC = leftVC;
            self.mainVC = mainVC;
            
            //滑动手势
            self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
            [self.mainVC.view addGestureRecognizer:self.pan];
            
            [self.pan setCancelsTouchesInView:YES];
            self.pan.delegate = self;
            
            self.leftVC.view.hidden = YES;
            
            [self.view addSubview:self.leftVC.view];
            
            //蒙版
            UIView *view = [[UIView alloc] init];
            view.frame = self.leftVC.view.bounds;
            view.backgroundColor = [UIColor blackColor];
            view.alpha = 0.5;
            self.contentView = view;
            [self.leftVC.view addSubview:view];
            
            //获取左侧tableview
            for (UIView *obj in self.leftVC.view.subviews) {
                if ([obj isKindOfClass:[UITableView class]]) {
                    self.leftTableview = (UITableView *)obj;
                }
            }
            self.leftTableview.backgroundColor = [UIColor clearColor];
            
            self.leftTableview.frame = CGRectMake(0, 0, kScreenWidth - kMainPageDistance, kScreenHeight);
            //设置左侧tableview的初始位置和缩放系数
            self.leftTableview.transform = CGAffineTransformMakeScale(kLeftScale, kLeftScale);
            self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
            
            [self.view addSubview:self.mainVC.view];
            self.closed = YES;//初始时侧滑窗关闭
            
            leftVC.delegate = self;
            
        }
        return self;

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    @try {
     
        self.leftVC.view.hidden = NO;
        
    } @catch (NSException *exception) {
       
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 滑动手势

//滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec{
    
    @try {
        
        CGPoint point = [rec translationInView:self.view];
        _scalef = (point.x * self.speedf + _scalef);
        
        BOOL needMoveWithTap = YES;  //是否还需要跟随手指移动
        if (((self.mainVC.view.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.x >= (kScreenWidth - kMainPageDistance )) && (_scalef >= 0)))
        {
            //边界值管控
            _scalef = 0;
            needMoveWithTap = NO;
        }
        
        //根据视图位置判断是左滑还是右边滑动
        if (needMoveWithTap && (rec.view.frame.origin.x >= 0) && (rec.view.frame.origin.x <= (kScreenWidth - kMainPageDistance)))
        {
            CGFloat recCenterX = rec.view.center.x + point.x * self.speedf;
            if (recCenterX < kScreenWidth * 0.5 - 2) {
                recCenterX = kScreenWidth * 0.5;
            }
            
            CGFloat recCenterY = rec.view.center.y;
            
            rec.view.center = CGPointMake(recCenterX,recCenterY);
            
            //scale 1.0~kMainPageScale
            CGFloat scale = 1 - (1 - kMainPageScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
            
            rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,scale, scale);
            [rec setTranslation:CGPointMake(0, 0) inView:self.view];
            
            CGFloat leftTabCenterX = kLeftCenterX + ((kScreenWidth - kMainPageDistance) * 0.5 - kLeftCenterX) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
            
            DLog(@"%f",leftTabCenterX);
            
            //leftScale kLeftScale~1.0
            CGFloat leftScale = kLeftScale + (1 - kLeftScale) * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
            
            self.leftTableview.center = CGPointMake(leftTabCenterX, kScreenHeight * 0.5);
            self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
            
            //tempAlpha kLeftAlpha~0
            CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (rec.view.frame.origin.x / (kScreenWidth - kMainPageDistance));
            self.contentView.alpha = tempAlpha;
            
        }
        else
        {
            //超出范围，
            if (self.mainVC.view.x < 0)
            {
                [self closeLeftView];
                _scalef = 0;
            }
            else if (self.mainVC.view.x > (kScreenWidth - kMainPageDistance))
            {
                [self openLeftView];
                _scalef = 0;
            }
        }
        
        //手势结束后修正位置,超过约一半时向多出的一半偏移
        if (rec.state == UIGestureRecognizerStateEnded) {
            if (fabs(_scalef) > vCouldChangeDeckStateDistance)
            {
                if (self.closed)
                {
                    [self openLeftView];
                }
                else
                {
                    [self closeLeftView];
                    
                }
            }
            else
            {
                if (self.closed)
                {
                    [self closeLeftView];
                }
                else
                {
                    [self openLeftView];
                }
            }
            _scalef = 0;
        }

    } @catch (NSException *exception) {
       
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    @try {
       
        if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
        {
            [UIView beginAnimations:nil context:nil];
            tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
            tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
            self.closed = YES;
            
            self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
            self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
            self.contentView.alpha = kLeftAlpha;
            
            [UIView commitAnimations];
            _scalef = 0;
            [self removeSingleTap];
            
            if (_leftDatas) {
                NSString * guanJianString  = [[NSUserDefaults standardUserDefaults] objectForKey:@"guanJianView"];
                if ([guanJianString isEqualToString:@"111"]) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"afterCloseLeft" object:_leftDatas];
                    
                }
            }
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 修改视图位置
/**
 @brief 关闭左视图
 */
- (void)closeLeftView
{
    @try {
        
        [UIView beginAnimations:nil context:nil];
        self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        self.mainVC.view.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
        self.closed = YES;
        
        self.leftTableview.center = CGPointMake(kLeftCenterX, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,kLeftScale,kLeftScale);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        [self removeSingleTap];
        
        if (_leftDatas) {
            
            NSString * guanJianString  = [[NSUserDefaults standardUserDefaults] objectForKey:@"guanJianView"];
            if ([guanJianString isEqualToString:@"111"]) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"afterCloseLeft" object:_leftDatas];
                
            }
            
        }
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
        
    } @finally {
        
    }
}

/**
 @brief 打开左视图
 */
- (void)openLeftView;
{
    @try {
       
        [UIView beginAnimations:nil context:nil];
        self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kMainPageScale,kMainPageScale);
        self.mainVC.view.center = kMainPageCenter;
        self.closed = NO;
        
        self.leftTableview.center = CGPointMake((kScreenWidth - kMainPageDistance) * 0.5, kScreenHeight * 0.5);
        self.leftTableview.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        self.contentView.alpha = 0;
        
        [UIView commitAnimations];
        [self disableTapButton];

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 行为收敛控制
- (void)disableTapButton
{
    @try {
       
        for (UIButton *tempButton in [_mainVC.view subviews])
        {
            [tempButton setUserInteractionEnabled:NO];
        }
        //单击
        if (!self.sideslipTapGes)
        {
            //单击手势
            self.sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handeTap:)];
            [self.sideslipTapGes setNumberOfTapsRequired:1];
            
            [self.mainVC.view addGestureRecognizer:self.sideslipTapGes];
            self.sideslipTapGes.cancelsTouchesInView = YES;  //点击事件盖住其它响应事件,但盖不住Button;
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 关闭行为收敛
- (void) removeSingleTap
{
    @try {
       
        for (UIButton *tempButton in [self.mainVC.view  subviews])
        {
            [tempButton setUserInteractionEnabled:YES];
        }
        [self.mainVC.view removeGestureRecognizer:self.sideslipTapGes];
        self.sideslipTapGes = nil;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
}

#pragma mark -  设置滑动开关是否开启  @param enabled YES:支持滑动手势，NO:不支持滑动手势

- (void)setPanEnabled: (BOOL) enabled
{
//    [self.pan setEnabled:enabled];
    
    @try {
        
         [self setPanEnabled:enabled leftViewType:LeftViewTypeMain];
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
//    if (self.closed) {
//        
//        DLog(@"12.16");
//    }

    
//    self.leftTableview.frame

    @try {
        
        if(touch.view.tag == vDeckCanNotPanViewTag)
        {
            //        NSLog(@"不响应侧滑");
            return NO;
        }
        else
        {
            //        NSLog(@"响应侧滑");
            return YES;
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 开启和关闭侧边栏
- (void)setPanEnabled:(BOOL)enabled leftViewType:(LeftViewType)type {
    
    @try {
       
        [self.pan setEnabled:enabled];
        
        if (type == LeftViewTypeMain) {
            [(LeftSortsViewController *)self.leftVC tableview].hidden = NO;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = YES;
        } else if (type == LeftViewTypeGoodsRank) {
            
            [(LeftSortsViewController *)self.leftVC tableview].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = NO;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = YES;
        } else if (type == LeftViewTypeKeyPoint) {
            [(LeftSortsViewController *)self.leftVC tableview].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = NO;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = YES;
        } else if (type == LeftViewTypeStoreRank) {
            [(LeftSortsViewController *)self.leftVC tableview].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = NO;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = YES;
        } else if (type == LeftViewTypeGoods){
            [(LeftSortsViewController *)self.leftVC tableview].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = NO;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = YES;
        }else if (type == LeftViewTypeGuide){
            [(LeftSortsViewController *)self.leftVC tableview].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC goodsRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC keyPointView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC storeRankView].hidden = YES;
            [(LeftSortsViewController *)self.leftVC guideView].hidden = NO;
            
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark - 二级页面
- (void)selectedSecondLeftSideBar:(NSDictionary *)dict viewIndex:(NSInteger)viewIndex {
    
    @try {
        
        UIView *view = self.secondLevelViewArray[viewIndex];
        ShangPinView *shanpinView;
        DianPuView *dianpuView;
        GuanJianView *guanJianView;
        DaoGouView *daoGouView;
        
        switch (viewIndex) {
                
            case 0: //业绩看板
                
                break;
                
            case 1: //店铺排行
                
                dianpuView = (DianPuView *)view;
                [dianpuView selectedLeftSideBar:dict];
                break;
                
            case 2: //商品排行
                
                shanpinView = (ShangPinView *)view;
                [shanpinView selectedLeftSideBar:dict];
                break;
                
            case 3: //关键指标
                
                guanJianView = (GuanJianView *)view;
                //            [guanJianView selectedLeftSideBar:dict];
                break;
                
            case 4: //区域看板
                
                break;
                
            case 5: //导购排行
                
                daoGouView = (DaoGouView *)view;
                //            [daoGouView selectedLeftSideBar:dict];
                break;
                
            default:
                
                break;
                
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 店铺排行详情页
- (void)selectedThiredLeftSideBar:(NSDictionary *)dict viewIndex:(NSInteger)viewIndex {
    
    @try {
     
        UIView *view = self.thiredLevelViewArray[viewIndex];
        SPView *sPView;
        
        switch (viewIndex) {
                
            case 0: //业绩
                
                break;
                
            case 1: //商品
                
                sPView = (SPView *)view;
                [sPView selectedLeftSideBar:dict];
                break;
                
            case 2: //会销
                
                break;
                
            case 3: //客流
                
                break;
                
            default:
                
                break;
                
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

@end
