//
//  LeftMenuShouShiMiMaViewController.m
//  LOSBi
//
//  Created by JJT on 16/8/30.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "LeftMenuShouShiMiMaViewController.h"
#import "MiMaDetailViewController.h"
#import "GestureVerifyViewController.h"
#import "AppDelegate.h"

@interface LeftMenuShouShiMiMaViewController ()
{
    
    UIView * downView;
    NSString *count;
    UISwitch *witch;
    NSString *states;
    
    
}

@end

@implementation LeftMenuShouShiMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    count = [user objectForKey:@"count"];
    states = [user objectForKey:@"states"];
    
    self.title = @"手势密码";
    self.view.backgroundColor = [UIColor lightGrayColor];

    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 44);
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIView * upView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, SCREEN_WIDTH, 50)];
    upView.tag = 777;
    upView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:upView];
    
    UILabel *upLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH - 80, 40)];
    upLab.font = [UIFont systemFontOfSize:15];
    upLab.textAlignment = NSTextAlignmentLeft;
    
    upLab.textColor = [UIColor grayColor];
    upLab.text = @"开启手势密码";
    [upView addSubview:upLab];
    
    
    witch = [[UISwitch alloc] initWithFrame:CGRectMake(upView.frame.size.width - 70, 10, 60, 40)];
    //设置开关的状态  默认为关闭状态
//    witch.on = NO;
    
    witch.onTintColor = [UIColor redColor];
    witch.tintColor = [UIColor lightGrayColor];
    
    [upView addSubview:witch];
    
    
    [witch addTarget:self action:@selector(switch_Change:) forControlEvents:UIControlEventValueChanged];

    [self createDownBtn];
    
    
    if ([states isEqualToString:@"1"]) {
        
        witch.on = YES;
        
        downView.hidden = NO;
        
    }else if ([states isEqualToString:@"2"]){
        
        witch.on = NO;
        
        downView.hidden = YES;
    }

    
//    gestureSetVCDismis
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismisOfGestureSetSeccess:) name:@"gestureSetVCDismis" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(state:) name:@"state" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gestureViewOfLeftBackBtn:) name:@"gestureViewOfLeftBackBtn" object:nil];

    //remove 修改手势密码
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeSwitch) name:@"closeSwitchToLeftMenuSSMM" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeSwitch) name:@"closeSwitchOFSSMM" object:nil];
}

-(void)closeSwitch{

    witch.on = NO;
    downView.hidden = YES;
}

#pragma mark - 创建修改密码行
-(void)createDownBtn{

    UIView *upView = (UIView *)[self.view viewWithTag:777];
    
    downView = [[UIView alloc]initWithFrame:CGRectMake(0, upView.frame.origin.y + 60, SCREEN_WIDTH, 50)];
    
    downView.backgroundColor = [UIColor whiteColor];
    
    downView.hidden = YES;
    
    [self.view addSubview:downView];
    
    UILabel *downLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 120, 40)];
    downLab.font = [UIFont systemFontOfSize:15];
    downLab.textAlignment = NSTextAlignmentLeft;
    downLab.textColor = [UIColor grayColor];
    
    downLab.text = @"修改手势密码";
    [downView addSubview:downLab];
    
    
    UIImageView *imag = [[UIImageView alloc]initWithFrame:CGRectMake(downView.frame.size.width - 40, 5, 30, 40)];
    
    imag.image = [UIImage imageNamed:@"arrow_grey_right"];
    
    [downView addSubview:imag];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(downViewTap_Click:)];
    //把点击手势添加的视图上
    [downView addGestureRecognizer:tap];
}

#pragma mark - 通知方法
-(void)dismisOfGestureSetSeccess:(NSNotification *)notif{

    witch.on = YES;
    downView.hidden = NO;
}
#pragma mark - 通知方法
-(void)gestureViewOfLeftBackBtn:(NSNotification *)sender{
    
    witch.on = YES;
    
    downView.hidden = NO;
    
}
#pragma mark - 通知方法
-(void)state:(NSNotification *)sender{
    
    witch.on = NO;

    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"states"];

}

#pragma mark - 修改手势密码按钮响应事件
-(void)downViewTap_Click:(UITapGestureRecognizer *)sender{
    
    GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
    
    gestureVerifyVc.isChangeGesture = YES;
    gestureVerifyVc.isToSetNewGesture = YES;

    [self presentViewController:gestureVerifyVc animated:YES completion:^{
    }];
        
}

#pragma mark - 手势密码开关
-(void)switch_Change:(UISwitch *)sender{
    
    //根据开关的状态执行不同的操作
    if (sender.on) {
        
        DLog(@"开关打开，设置手势密码");
        
        MiMaDetailViewController * detail = [MiMaDetailViewController new];
            
        detail.type = GestureViewControllerTypeSetting;
            
        [self presentViewController:detail animated:YES completion:^{
                
        }];

        
    }else{
        DLog(@"开关关闭，验证手势密码");
        
        GestureVerifyViewController * detail = [GestureVerifyViewController new];
        
        detail.isSwitchClose = YES;
        
        detail.isToSetNewGesture = NO;
        
        [self presentViewController:detail animated:YES completion:^{
            }];

        
     }

}

#pragma mark -  返回按钮
-(void)leftBarBtnClicked{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
    
    
}


@end
