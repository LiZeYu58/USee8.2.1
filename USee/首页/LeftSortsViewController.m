//
//  LeftSortsViewController.m
//  LGDeckViewController
//
//  Created by jamie on 15/3/31.
//  Copyright (c) 2015年 Jamie-Ling. All rights reserved.
//

#import "LeftSortsViewController.h"
#import "AppDelegate.h"
#import "TableViewCellForLeftBarOfMainPage.h"
#import "LeftSlideViewController.h"
#import "LeftMenuYiJianFanKuiViewController.h"
#import "LeftMenuShouShiMiMaViewController.h"
#import "LOSHelper.h"
#import "SlideView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import "DianPuView.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import <objc/runtime.h>

#import "JPUSHService.h"

@interface LeftSortsViewController () <UITableViewDelegate,UITableViewDataSource,SlideViewDelegate>
{
    
    NSInteger DianPuLeftSideFirst;
    NSInteger GuideViewLeftSideFirst;
    NSInteger ShangPinLeftSideFirst;
    NSInteger GuanJianLeftSideFirst;
    NSInteger spLeftSideFirst;
    NSString *newVersion;
    NSString *newVersionDownloadUrl;
    NSString *uuid;
    NSString *mobileModel;
    NSString *currentVersion;
    
    NSString * _update_type;
    
    NSArray *messageArray;
    NSDictionary *versionDic;
    NSMutableArray * aa;
    NSMutableArray * dic; //关键字典
    NSMutableArray *gjUnitArr;

    NSMutableDictionary *PICodeDic;
    NSMutableDictionary * _selectIndexDic;
    NSMutableDictionary * _linchpinSelectIndexDic;
    
    UIView *_backgroundView;
    UIView *logoutAlertView;
    
}
@property (nonatomic,strong)NSMutableArray *leftNameArray;
@property (nonatomic,strong)NSMutableArray *DP_piaCodeArray;

@property (nonatomic,strong)NSMutableArray *SP_PiacodeArray;  //商品排行
@property (nonatomic,strong)NSMutableArray *SP_NameArray;

//@property (nonatomic,strong)NSMutableArray *GJ_PiaaArray;
@property (nonatomic,strong)NSMutableArray *GJ_NameArray;

@property (nonatomic,strong)NSMutableArray *sp_PiacodeArray;  //商品
@property (nonatomic,strong)NSMutableArray *sp_NameArray;



@property (nonatomic, strong) NSDictionary *dataDic1;

@property (nonatomic,strong)NSMutableArray *piaCodeArr;

@end

@implementation LeftSortsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @try {
     
        DianPuLeftSideFirst = 1;
        
        ShangPinLeftSideFirst = 1;
        
        GuanJianLeftSideFirst = 1;
        
        spLeftSideFirst = 1;
        
        self.view.backgroundColor = Color(184, 52, 61);
        
        self.tableview = [[UITableView alloc] init];
        //    self.tableview = tableview;
        self.tableview.frame = self.view.bounds;
        self.tableview.dataSource = self;
        self.tableview.delegate  = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableview];
        
        self.tableview.scrollEnabled = NO;
        
        [self.tableview registerClass:[TableViewCellForLeftBarOfMainPage class] forCellReuseIdentifier:@"TableViewCellForLeftBarOfMainPage"];
        
        mobileModel = [[UIDevice currentDevice] model];
        
        KeychainItemWrapper *keyWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUIDOfTheYouShuOnBizvane" accessGroup:nil];
        uuid = [keyWrapper objectForKey:(id)kSecValueData];
        
        if ([uuid isEqualToString:@""]) {
            
            uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [keyWrapper setObject:uuid forKey:(id)kSecValueData];
            
        }
        
        NSDictionary *appInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        currentVersion = [appInfoDictionary objectForKey:@"CFBundleShortVersionString"]; // app版本
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableview.height - 40, DeviceWidth - kMainPageDistance, 40)];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.numberOfLines = 2;
        infoLabel.font = [UIFont systemFontOfSize:10];
        infoLabel.text = [NSString stringWithFormat:@"版本v%@\n©2016 Bizvane.com", currentVersion];
        infoLabel.textAlignment = NSTextAlignmentCenter;
        [self.tableview addSubview:infoLabel];
        
        [self requestVersionCompare];
        
        //店铺排行
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DianPuLeftSidebarArray:) name:@"DianPuLeftSidebarArray" object:nil];
        
        
        //商品排行
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ShangPinLeftSidebarNotif:) name:@"ShangPinLeftSidebarNameArrayAndPiaCodeArray" object:nil];
        
        
        //关键指标
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GuanJianLeftSidebarArray:) name:@"GuanJianLeftSidebarArray" object:nil];
        
        
        //店铺详情--商品 侧边栏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(spLeftSidebarArray:) name:@"spLeftSidebarArray" object:nil];
        
        //导购排行
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GuideViewClick:) name:@"GuideViewToLeftSideBar" object:nil];
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 店铺排行
-(void)spLeftSidebarArray:(NSNotification *)notif{
    
    @try {
     
        _sp_PiacodeArray = [NSMutableArray new];
        
        _sp_NameArray = [NSMutableArray new];
        
        _sp_PiacodeArray = notif.userInfo[@"spleftPiaCode"];
        
        _sp_NameArray = notif.userInfo[@"spleftArray"];
        
        
        NSString * indeStr = notif.userInfo[@"SPindex"];
        NSInteger index = [indeStr integerValue];
        
        
        NSArray *arr4 = _sp_NameArray;
        
        if (spLeftSideFirst == 1) {
            
            //本页面控件刷新
            self.goodsView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.goodsView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            [self.view addSubview:self.goodsView];
            self.goodsView.hidden = NO;
            
            
            
            _slide4 = [[SlideView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - kMainPageDistance, 40 * arr4.count + arr4.count* 1)];
            _slide4.type = LeftViewTypeGoods1;
            _slide4.tag = 24;
            _slide4.delegate =self;
            [_slide4 loadTitleArray:arr4 arr:index];
            [self.goodsView addSubview:_slide4];
            
            spLeftSideFirst = 2;
            
        }else{
            
            [_slide4 loadTitleArray:arr4 arr:index];
            
        }

        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 关键指标侧边栏
-(void)GuanJianLeftSidebarArray:(NSNotification *)notif{

    @try {
        
        dic = [NSMutableArray new];
        aa = [NSMutableArray new];
        PICodeDic = [NSMutableDictionary new];
        _GJ_NameArray = [NSMutableArray new];
        gjUnitArr = [NSMutableArray new];
        
        aa = notif.userInfo[@"GuanJianleftPiaa"];
        PICodeDic = notif.userInfo[@"GuanJianleftPiaCode"];
        _GJ_NameArray = notif.userInfo[@"GuanJianleftName"];
        dic = notif.userInfo[@"dic"];
        gjUnitArr = notif.userInfo[@"PIUnitArr"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(unsigned long)_GJ_NameArray.count] forKey:@"linchpinCount"];
        
        
        //  if (GuanJianLeftSideFirst == 1) {
        [self.keyPointView removeFromSuperview];
        self.keyPointView = nil;
        
        self.keyPointView = [[UIView alloc] initWithFrame:self.view.bounds];
        self.keyPointView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
        [self.view addSubview:self.keyPointView];
        self.keyPointView.hidden = NO;
        
        _slide2 = [[SlideView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - kMainPageDistance, 40 * _GJ_NameArray.count + _GJ_NameArray.count* 1)];
        _slide2.type = LeftViewTypeKeyPoint1;
        _slide2.tag = 23;
        _slide2.delegate =self;
        [_slide2 loadTitleArray:_GJ_NameArray];
        [self.keyPointView addSubview:_slide2];
        
        //    GuanJianLeftSideFirst = 2;
        
        //  } else {
        
        //    [_slide2 loadTitleArray:_GJ_NameArray];
        
        // }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

#pragma mark - 商品发来的通知方法
-(void)ShangPinLeftSidebarNotif:(NSNotification *)notif{
    
    @try {
        
        NSString * indeStr = notif.userInfo[@"indexRankOrCollect"];
        NSInteger index = [indeStr integerValue];
        
        _SP_PiacodeArray = [NSMutableArray new];
        _SP_NameArray = [NSMutableArray new];
        _SP_PiacodeArray = notif.userInfo[@"piaCodeArray"];
        _SP_NameArray = notif.userInfo[@"nameArray"];
        
        NSArray *arr2 = _SP_NameArray;
        if (ShangPinLeftSideFirst == 1) {
            
            //刷新本页控件数据
            self.goodsRankView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.goodsRankView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            [self.view addSubview:self.goodsRankView];
            self.goodsRankView.hidden = NO;
            //        NSArray *arr2 = @[@"已售/库存/进销率"];
            
            _slide1 = [[SlideView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - kMainPageDistance, 40 * arr2.count + arr2.count* 1)];
            _slide1.type = LeftViewTypeGoodsRank1;
            _slide1.tag = 22;
            _slide1.delegate = self;
            [_slide1 loadTitleArray:arr2 arr:index];
            [self.goodsRankView addSubview:_slide1];
            
            ShangPinLeftSideFirst = 2;
        }else{
            
            [_slide1 loadTitleArray:arr2 arr:index];
            
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

//店铺 发来的 通知方法
-(void)DianPuLeftSidebarArray:(NSNotification *)notif{
    
    @try {
        
        NSString * indeStr = notif.userInfo[@"indexCollect"];
        
        NSInteger index = [indeStr integerValue];
        
        
        _DP_piaCodeArray = [NSMutableArray new];
        
        _leftNameArray = [NSMutableArray new];
        
        _DP_piaCodeArray = notif.userInfo[@"leftPiaCode"];
        
        _leftNameArray = notif.userInfo[@"leftArray"];
        
        NSArray *arr1 = _leftNameArray;
        
        if (DianPuLeftSideFirst == 1) {
            
            self.storeRankView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.storeRankView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            [self.view addSubview:self.storeRankView];
            self.storeRankView.hidden = NO;
            
            _slide = [[SlideView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH - kMainPageDistance, 40 * arr1.count + arr1.count* 1)];
            _slide.type = LeftViewTypeStoreRank1;
            _slide.tag = 21;
            _slide.delegate =self;
            
            [_slide loadTitleArray:arr1 arr:index];
            
            [self.storeRankView addSubview:_slide];
            
            DianPuLeftSideFirst = 2;
        }else{
            
            [_slide loadTitleArray:arr1 arr:index];
            
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark -
-(void)GuideViewClick:(NSNotification *)notif{
    
    @try {
       
        if (self.guideView == nil) {
            
            self.guideView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.guideView.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
            [self.view addSubview:self.guideView];
            self.guideView.hidden = NO;
            
        } else {
            
            
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 切换侧边栏时的回调
- (void)piecewiseView:(SlideView *)slideView index:(NSInteger)index{
    
    @try {
     
        if (slideView.tag == 21) {
            
            //店铺排行侧边栏
            NSString *piaCode = _DP_piaCodeArray[index];
            NSString *indexOfLeft = [NSString stringWithFormat:@"%ld",(long)index];
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:piaCode,@"piaCodeToDianPu",indexOfLeft,@"indexOfLeft",nil];
            
            if (_delegate &&[_delegate respondsToSelector:@selector(selectedThiredLeftSideBar:viewIndex:)]){
                
                [self.delegate selectedSecondLeftSideBar:dict viewIndex:1];
                
            }
            
        }else if (slideView.tag == 22){
            
            //商品排行侧边栏
            NSString *piaCode = _SP_PiacodeArray[index];
            NSString *indexOfLeft = [NSString stringWithFormat:@"%ld",(long)index];
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:piaCode,@"piaCode",indexOfLeft,@"indexOfLeftSideBar",nil];
            
            if (_delegate &&[_delegate respondsToSelector:@selector(selectedSecondLeftSideBar:viewIndex:)]){
                
                [self.delegate selectedSecondLeftSideBar:dict viewIndex:2];
                
            }
            
        }else if (slideView.tag == 23){ //关键指标
            
            UIButton *ub = [(UIButton *)self.view viewWithTag:index + 100];//获取当前操作的按钮
            
            if (!_selectIndexDic) {
                _selectIndexDic = [[NSMutableDictionary alloc]init];
            }
            if ([ub isSelected]) {
                [_selectIndexDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)index]];
            }
            else{
                [_selectIndexDic setObject:@"a" forKey:[NSString stringWithFormat:@"%ld",(long)index]];
            }
            
            //        DLog(@"%@", [ub titleLabel].text);
            int checkedCount = 0;//选中按钮计数器
            
            //用户操作取消选中时才进判断
            if(![ub isSelected]) {
                
                for (NSNumber *boolFlag in aa) {
                    
                    if ([boolFlag intValue] == 1) {
                        
                        ++checkedCount;
                        
                        //只要确认选中的按钮是否超过1个
                        if (checkedCount > 1) {
                            
                            break;
                            
                        }
                    }
                }
                
                //当前只剩1个按钮为选中状态, 反选用户操作的按钮
                if (checkedCount < 2) {
                    
                    [ub setSelected:YES];
                    
                    return;
                    
                }
            }
            
            BOOL flag = [aa[index] boolValue];
            
            flag = !flag;
            
            if (flag) {
                
                aa[index] = @(1);
                
            }else{
                
                aa[index] = @(0);
                
            }
            
            
            if (!flag) {
                
                [PICodeDic setObject:@"" forKey:[NSString stringWithFormat:@"%ld", (long)index]];
                
            } else{
                
                [PICodeDic setObject:dic[index][@"PICode"] forKey:[NSString stringWithFormat:@"%ld", (long)index]];
                
            }
            
            NSString *s = @"";
            NSMutableArray *z = [NSMutableArray new];
            NSMutableArray *g = [NSMutableArray new];
            NSMutableDictionary *leftDatas = [NSMutableDictionary new];
            
            for (int i = 0; i < PICodeDic.allKeys.count; i++) {
                
                NSString *tempStr = [PICodeDic objectForKey:[NSString stringWithFormat:@"%d", i]];
                
                if (i != 0 && ![tempStr isEqualToString:@""] && ![s isEqualToString:@""]) {
                    
                    s = [s stringByAppendingString:@","];
                    
                }
                
                s = [s stringByAppendingString:[PICodeDic objectForKey:[NSString stringWithFormat:@"%d", i]]];
                
                if (![tempStr isEqualToString:@""]) {
                    
                    [z addObject:gjUnitArr[i]];
                    [g addObject:_GJ_NameArray[i]];
                    
                }
            }
            
            [leftDatas setValue:s forKey:@"keyPoint"];
            [leftDatas setValue:z forKey:@"unitArray"];
            [leftDatas setValue:g forKey:@"nameArray"];
            //        [t setValue:aa forKey:@"indexOfSelected"];
            DLog(@"PICodeStr: %@", s);
            [_selectIndexDic setObject:leftDatas forKey:@"aa"];
            
#pragma mark  只是暂时注释   以后会用到  侧滑点击
            //    [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBeforeLeftClose" object:leftDatas];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBeforeLeftClose" object:_selectIndexDic];
            
        }else if (slideView.tag == 24){
            
            //店铺详情--商品 侧边栏
            //发送通知到店铺详情--商品页面
            NSString *piaCode = _sp_PiacodeArray[index];
            
            NSString *indexOfLeft = [NSString stringWithFormat:@"%ld",(long)index];
            
            
            NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:piaCode,@"piaCode",indexOfLeft,@"indexOfLeftSideBar",nil];
            
            if (_delegate &&[_delegate respondsToSelector:@selector(selectedThiredLeftSideBar:viewIndex:)]){
                
                [self.delegate selectedThiredLeftSideBar:dict viewIndex:1];
                
            }
            
        }else{
            
            DLog(@"11.25");
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
      
        return 5;
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 115 * SCREEN_H_SP;
    } else {
        return 70 * SCREEN_H_SP;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
      
        TableViewCellForLeftBarOfMainPage *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellForLeftBarOfMainPage"];
        [cell setIndex:indexPath.row];
        
        return cell;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
       
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        switch (indexPath.row) {
            case 0:
                //用户
                
                break;
            case 1:
                //操作手册
                
                break;
            case 2:
            {
                //手势密码
                
                LeftMenuShouShiMiMaViewController * shouShiMiMa = [LeftMenuShouShiMiMaViewController new];
                
                [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
                
                [tempAppDelegate.mainNavigationController pushViewController:shouShiMiMa animated:NO];
                
            }
                
                break;
            case 5:{
                //意见反馈
                LeftMenuYiJianFanKuiViewController *yijianfankui = [LeftMenuYiJianFanKuiViewController new];
                [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
                [tempAppDelegate.mainNavigationController pushViewController:yijianfankui animated:NO];
                break;
            }
            case 6:{
                //联系我们
                NSString *callNumber = @"400-000-0000";
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                         message:callNumber
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"呼叫"
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      NSURL *callUrl = [NSURL URLWithString:
                                                                                        [@"tel://" stringByAppendingString:callNumber]];
                                                                      if ([[UIApplication sharedApplication] canOpenURL:callUrl]) {
                                                                          [[UIApplication sharedApplication] openURL:callUrl];
                                                                      }
                                                                  }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                    style:UIAlertActionStyleCancel
                                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                                      
                                                                  }]];
                
                [tempAppDelegate.window.rootViewController presentViewController:alertController animated:YES completion:nil];
                break;
            }
            case 3:   //分享
            {
                
                NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
                [shareParams SSDKSetupShareParamsByText:nil
                                                 images:[UIImage imageNamed:@"60pt_"]
                                                    url:[NSURL URLWithString:@"http://update.bizvane.com/usee/v2/"]
                                                  title:@"有数 USee"
                                                   type:SSDKContentTypeAuto];
                [ShareSDK showShareActionSheet:nil
                                         items:nil
                                   shareParams:shareParams
                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                               
                               switch (state) {
                                   case SSDKResponseStateSuccess:
                                   {
                                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                           message:nil
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:@"确定"
                                                                                 otherButtonTitles:nil];
                                       [alertView show];
                                       break;
                                   }
                                   case SSDKResponseStateFail:
                                   {
                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                       message:[NSString stringWithFormat:@"%@",error]
                                                                                      delegate:nil
                                                                             cancelButtonTitle:@"OK"
                                                                             otherButtonTitles:nil, nil];
                                       [alert show];
                                       break;
                                   }
                                   default:
                                       break;
                               }
                           }
                 ];
                
                //  }
                
                
                break;
            }
            case 4:{
                //注销账号
                //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认注销账号？" preferredStyle:UIAlertControllerStyleAlert];
                //            [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //                [self doLogout];
                //            }]];
                //            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
                //            }]];
                
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                
                if (logoutAlertView && [logoutAlertView isHidden]) {
                    
                    [logoutAlertView setHidden:NO];
                    
                } else {
                    
                    logoutAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    [logoutAlertView setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
                    [window addSubview:logoutAlertView];
                    
                    UIView *logoutBodyView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300) / 2, (SCREEN_HEIGHT - 180) / 2, 300, 180)];
                    [logoutBodyView setBackgroundColor:[UIColor colorWithHex:0xcd3742]];
                    [logoutBodyView.layer setCornerRadius:5];
                    [logoutAlertView addSubview:logoutBodyView];
                    
                    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, logoutBodyView.width, 44)];
                    [headerView setBackgroundColor:[UIColor colorWithHex:0xba323a]];
                    
                    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headerView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5,5)];//圆角大小
                    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                    maskLayer.frame = headerView.bounds;
                    maskLayer.path = maskPath.CGPath;
                    headerView.layer.mask = maskLayer;
                    [logoutBodyView addSubview:headerView];
                    
                    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, (44 - 16) / 2, headerView.width - 10, 16)];
                    [headerLabel setText:@"提示"];
                    [headerLabel setTextAlignment:NSTextAlignmentCenter];
                    [headerLabel setFont:[UIFont systemFontOfSize:16]];
                    [headerLabel setTextColor:[UIColor whiteColor]];
                    [headerView addSubview:headerLabel];
                    
                    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (logoutBodyView.height - 16) / 2, logoutBodyView.width, 16)];
                    [messageLabel setText:@"确定注销账号?"];
                    [messageLabel setTextAlignment:NSTextAlignmentCenter];
                    [messageLabel setFont:[UIFont systemFontOfSize:16]];
                    [messageLabel setTextColor:[UIColor whiteColor]];
                    [logoutBodyView addSubview:messageLabel];
                    
                    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, logoutBodyView.height - 54, 120, 44)];
                    [cancelButton.layer setCornerRadius:5];
                    [cancelButton setBackgroundColor:[UIColor colorWithHex:0xba323a]];
                    [cancelButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    [cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                    [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
                    [cancelButton.titleLabel setTextColor:[UIColor whiteColor]];
                    [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
                    [cancelButton addTarget:self action:@selector(cancelLogout:) forControlEvents:UIControlEventTouchUpInside];
                    [logoutBodyView addSubview:cancelButton];
                    
                    UIButton *confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(logoutBodyView.width - 130, logoutBodyView.height - 54, 120, 44)];
                    [confirmButton.layer setCornerRadius:5];
                    [confirmButton setBackgroundColor:[UIColor colorWithHex:0xba323a]];
                    [confirmButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
                    [confirmButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                    [confirmButton setTitle:@"确定" forState: UIControlStateNormal];
                    [confirmButton.titleLabel setTextColor:[UIColor whiteColor]];
                    [confirmButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                    [confirmButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
                    [confirmButton addTarget:self action:@selector(doLogout:) forControlEvents:UIControlEventTouchUpInside];
                    [logoutBodyView addSubview:confirmButton];
                    
                }
                break;
                
            }
                
            default:
                break;
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}

#pragma mark - 确认注销账号
- (void)doLogout:(UIButton *)sender {
    
    @try {
       
        [JPUSHService setTags:[NSSet set] alias:@"" fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
            NSLog(@"rescode: %d, \ntags: --, \nalias: --\n", iResCode);
        }];

        LoginViewController * log = [LoginViewController new];
        
        [AppDatas restSharedData];
        
        [self presentViewController:log animated:YES completion:^{
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alreadyLaunch"];
            
        }];

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

- (void)cancelLogout:(UIButton *)sender {
    
    @try {
     
         [logoutAlertView setHidden:YES];
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
    
}


#pragma mark - tableView 回调
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @try {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.bounds.size.width, 180)];
        view.backgroundColor = [UIColor clearColor];
        return view;
        
    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
   
}


#pragma mark - 版本对比
- (void)requestVersionCompare {
    
    @try {
     
        [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.news.USeeUpdate" dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:[AppDatas sharedDatas].userCode, @"user_code", @"1", @"app_type", uuid, @"equipId", mobileModel, @"equipName", nil] withCache:YES
                           success:^(NSDictionary *responseDic) {
                               
                               if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                   
                                   newVersion = responseDic[@"data"][@"data"][@"version"];
                                   
                                   _update_type = responseDic[@"data"][@"data"][@"update_type"];
                                   
                                   NSString * is_active =[NSString stringWithFormat:@"%@",responseDic[@"data"][@"data"][@"is_active"]];
                                   
                                   //                NSString *
                                   
                                   if ([is_active isEqualToString:@"false"]) {
                                       
                                       LoginViewController * log = [LoginViewController new];
                                       
                                       [AppDatas restSharedData];
                                       
                                       [self presentViewController:log animated:YES completion:^{
                                           
                                           [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"alreadyLaunch"];
                                           
                                       }];
                                   }
                                   
                                   NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
                                   
                                   
                                   if ([bundleID isEqualToString:@"com.BURGEON.youshu"])
                                   {
                                       NSInteger newVersionNumber = 0;
                                       NSInteger currentVersionNumber = 0;
                                       
                                       if (newVersion) {
                                           newVersionNumber = [newVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
                                       }
                                       
                                       if (currentVersion) {
                                           currentVersionNumber = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""].integerValue;
                                       }
                                       
                                       if (newVersionNumber > currentVersionNumber) {
                                           
                                           versionDic = responseDic;
                                           newVersionDownloadUrl = versionDic[@"data"][@"data"][@"update_url"];
                                           
                                           messageArray = [[NSMutableArray alloc] initWithArray:versionDic[@"data"][@"data"][@"update_desc"]];
                                           
                                           [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newVersion"];
                                           
                                           [[NSUserDefaults standardUserDefaults] setObject: newVersion forKey:@"newVersion"];
                                           
                                           //版本更新
                                           if (messageArray) {
                                               [self showAlertView:messageArray];
                                               
                                           }
                                           
                                       }
                                       
                                   }
                               }
                               
                           } failure:^(NSError *error) {
                               
                               //         LOSAlert(@"请求失败, 请联系商帆管理人员");
                               //         LoginViewController *appStartController = [[LoginViewController alloc] init];
                               //                           [self presentViewController:appStartController animated:NO completion:nil];
                           }];

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}


#pragma mark - 新版本展示弹框
- (void)showAlertView:(NSMutableArray *)messageArr {
    
    @try {
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        
        _backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_backgroundView setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
        [window addSubview:_backgroundView];
        
        UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 225 * SCREEN_W_SP) / 2, SCREEN_HEIGHT / 4, 225 * SCREEN_W_SP, (SCREEN_HEIGHT / 2) + 0.5)];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        
        alertView.layer.masksToBounds = YES;
        alertView.layer.cornerRadius = 5;
        [_backgroundView addSubview:alertView];
        
        UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, alertView.width, 34 * SCREEN_H_SP)];
        NSString * versionText = @"新版本";
        versionText = [versionText stringByAppendingString:newVersion];
        [versionLabel setText:versionText];
        [versionLabel setFont:[UIFont systemFontOfSize:14]];
        [versionLabel setTextColor:[UIColor colorWithHex:0x33333]];
        [versionLabel setTextAlignment:NSTextAlignmentCenter];
        [alertView addSubview:versionLabel];
        
        UIScrollView *alertScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height, alertView.width, alertView.height - versionLabel.height - 44 * SCREEN_H_SP - 0.5)];
        [alertScrollView setShowsVerticalScrollIndicator:NO];
        [alertView addSubview:alertScrollView];
        
        CGFloat labelHeightCount = 10 * SCREEN_H_SP;
        
        for (NSString *message in messageArr) {
            
            if (message && ![message isKindOfClass:[NSNull class]]) {
                
                UILabel *messageLabel = [UILabel new];
                [messageLabel setText:message];
                [messageLabel setTextColor:[UIColor colorWithHex:0x33333]];
                CGSize messageSize = [message boundingRectWithSize:CGSizeMake(alertScrollView.width - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
                messageLabel.numberOfLines = 0;
                [messageLabel setFont:[UIFont systemFontOfSize:12]];
                [messageLabel setSize:messageSize];
                [messageLabel setX:10];
                [messageLabel setY:labelHeightCount];
                labelHeightCount += messageLabel.size.height + 10 * SCREEN_H_SP;
                [alertScrollView addSubview:messageLabel];
                
            }
        }
        
        [alertScrollView setContentSize:CGSizeMake(alertScrollView.width, labelHeightCount > alertScrollView.height ? labelHeightCount : alertScrollView.height)];
        
        UIView *splitLine = [[UIView alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height, alertView.width, 0.5)];
        [splitLine setBackgroundColor:[UIColor colorWithHex:0xdfdfdf]];
        [alertView addSubview:splitLine];
        
        
        if ([_update_type isEqualToString:@"1"]) {
            
            UIButton * rightDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width, 44 * SCREEN_H_SP)];
            [rightDownloadButton setTitle:@"立即下载" forState:UIControlStateNormal];
            [[rightDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            rightDownloadButton.tag = 2;
            [rightDownloadButton setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            [rightDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:rightDownloadButton];
            
        }
        else if ([_update_type isEqualToString:@"2"]){
            
            UIButton * leftDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(0, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width / 2, 44 * SCREEN_H_SP)];
            
            [leftDownloadButton setTitle:@"取消" forState:UIControlStateNormal];
            [[leftDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            [leftDownloadButton setTitleColor:[UIColor colorWithHex:0x888888] forState:UIControlStateNormal];
            leftDownloadButton.tag = 1;
            [leftDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:leftDownloadButton];
            
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertView.width / 2-1, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, 0.5, 44 * SCREEN_H_SP)];
            lineLabel.backgroundColor =  [UIColor colorWithHex:0xdfdfdf];
            [alertView addSubview:lineLabel];
            
            UIButton * rightDownloadButton = [[UIButton alloc]initWithFrame:CGRectMake(alertView.width / 2, versionLabel.y + versionLabel.height + alertScrollView.height + splitLine.height, alertView.width / 2, 44 * SCREEN_H_SP)];
            [rightDownloadButton setTitle:@"立即下载" forState:UIControlStateNormal];
            [[rightDownloadButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
            rightDownloadButton.tag = 2;
            [rightDownloadButton setTitleColor:[UIColor colorWithHex:0xba2932] forState:UIControlStateNormal];
            [rightDownloadButton addTarget:self action:@selector(jumpToDownloadPage:) forControlEvents:UIControlEventTouchUpInside];
            [alertView addSubview:rightDownloadButton];
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

- (void)jumpToDownloadPage:(UIButton *)sender {
    
    @try {
        
        [_backgroundView removeFromSuperview];
        _backgroundView = nil;
        
        if (sender.tag == 2){
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVersionDownloadUrl]];
        }

    } @catch (NSException *exception) {
        
         [CommonTools  collectErrolLogWriteFile:[NSString stringWithFormat:@"%@",exception]];
    } @finally {
        
    }
}

@end
