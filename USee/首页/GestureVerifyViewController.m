//
//  GestureVerifyViewController.m
//  LOSBi
//
//  Created by JJT on 16/8/31.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "PCCircleView.h"
#import "PCLockLabel.h"
#import "MiMaDetailViewController.h"
#import "PCCircleInfoView.h"
#import "LoginViewController.h"
#import "AppDatas.h"

@interface GestureVerifyViewController ()<CircleViewDelegate>

/**
 *  文字提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;
@property (nonatomic, assign) BOOL bol;
@property (nonatomic, strong) PCCircleInfoView *infoView;

@end

@implementation GestureVerifyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (instancetype)init
{
    self = [super init];
//    if (self) {
//        
//         self.view.backgroundColor = [UIColor colorWithHex:0xba2932];
//        
//    }
    return self;
}


#pragma mark - 手势密码UI创建
- (void)viewDidLoad{
    [super viewDidLoad];
    
    _bol = YES;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xba2932];
    
    if (self.isToSetNewGesture) {
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        leftBtn.frame = CGRectMake(0, 20, 44, 44);
        [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftBtn];
    }
    
    UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, SCREEN_WIDTH - 160, 40)];
    lab.text = @"验证手势解锁";
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lab];

    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    [lockView setType:CircleViewTypeVerify];
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
    msgLabel.textColor = [UIColor whiteColor];
    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    [msgLabel showNormalMsg:gestureTextOldGesture1];
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
    
    UILabel * forgetLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, SCREEN_HEIGHT - 80*SCREEN_H_SP, SCREEN_WIDTH - 200, 40)];
    forgetLabel.text = @"忘记手势密码？";
    forgetLabel.font = [UIFont systemFontOfSize:14];
    forgetLabel.textColor = [UIColor whiteColor];
    forgetLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:forgetLabel];
    forgetLabel.userInteractionEnabled = YES;
    [forgetLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetSecretCode:)]];
    
    
    [self setupSubViewsSettingVc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismis:) name:@"gestureSetVCDismis" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissToLeftMenuSSMMVC) name:@"backToLeftMenuSSMMVC" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissToLeftMenuSSMMVC) name:@"changeSeccessForReturnLeftMenuSSMMVC" object:nil];
}


-(void)dismissToLeftMenuSSMMVC{
    
    [self.msgLabel showWarnMsgAndShake:@"设置成功" withBOOLOfShake:NO];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
    self.infoView = infoView;
    [self.view addSubview:infoView];
}


#pragma mark - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    if (type == CircleViewTypeVerify) {
        
        if (equal) {
            DLog(@"验证成功");
            
            
            if (self.isChangeGesture) {
                [self.msgLabel showWarnMsgAndShake:@"验证成功" withBOOLOfShake:NO];
            }else{
                
                [self.msgLabel showWarnMsgAndShake:gestureTextSetSuccess withBOOLOfShake:NO];
            }
            
            //设置密码（需输入两次手势）
            if (self.isToSetNewGesture) {
                
                MiMaDetailViewController *gestureVc = [[MiMaDetailViewController alloc] init];
                [gestureVc setType:GestureViewControllerTypeSetting];

                gestureVc.isChangeGesture = self.isChangeGesture;
                gestureVc.bol = _bol;
                
                [self presentViewController:gestureVc animated:YES completion:^{
                    
                }];
                
            }
            //验证 or 登录密码
            else{
                
                
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
                
                if (self.isSwitchClose) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"states"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeSwitchToLeftMenuSSMM" object:nil];
                }
                
                
                
                if (self.delegate && [_delegate respondsToSelector:@selector(gestureVerfyAccessDidPass)]){

                    [self.delegate gestureVerfyAccessDidPass];

                }
                
           }
            
        } else {
            DLog(@"密码错误！");

            
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError withBOOLOfShake:YES];
        }
    }
}



-(void)forgetSecretCode:(UITapGestureRecognizer *)tap{

#pragma mark - 清空用户忘记的手势密码设置
    NSString *states = @"2";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:states forKey:@"states"];
    
    [AppDatas sharedDatas].userPersonalInformation = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPersonalInformation"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"alreadyLaunch"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"funcPermission"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Pusername"];
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:NO completion:^{
        
    }];
    
}


-(void)dismis:(NSNotification *)sender{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gestureDismissToLeftMenuShouShiMiMaVC" object:nil];
    [self dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

- (void)leftBarBtnClicked {
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
