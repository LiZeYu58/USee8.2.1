//
//  LoginViewController.m
//  LOSBi
//
//  Created by JJT on 16/8/30.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



/*
 
    登录页面
 */




#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LOSHelper.h"
#import "LOSAFNetworking.h"
#import "AppDatas.h"
#import "KeychainItemWrapper.h"
#import "MBProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate, MBProgressHUDDelegate>

{
    UITextField *accountField;  //账号输入框
    UITextField *passwordField;    //密码输入框
    UIButton * logBtn;      //登录按钮
    UIButton * passwordBtn;
    NSString *_smsCode;
    NSString *uuid;
  //  AlterView *_alert;
    MBProgressHUD *HUD;
    
}

@property(nonatomic,strong) NSDictionary *dataDic;
@property(nonatomic, assign) CGFloat keyBoadrHeight;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  _alert = [[AlterView alloc]initWithFrame:self.view.bounds];
    
    // 1.监听键盘弹出，把inputToolbar(输入工具条)往上移
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kbWillShow:)
                                                name:UIKeyboardWillShowNotification object:nil];
    // 2.监听键盘退出，inputToolbar恢复原位
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kbWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
    
    //给底层view添加 点击/滑动 事件
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(self_ViewTap:)]];
    [self.view addGestureRecognizer:[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(self_ViewTap:)]];
    

    self.view.backgroundColor = [UIColor colorWithHex:0xba2932];
    UIImageView *upImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300* SCREEN_W_SP)/2, 115* SCREEN_H_SP, 300* SCREEN_W_SP, 120 *SCREEN_H_SP)];
    upImage.image = [UIImage imageNamed:@"img_登录页面_logo"];
    [self.view addSubview:upImage];
    
    
    if (SCREEN_WIDTH > 414) {
#pragma mark - 账号输入框
        UIImageView *accountView = [[UIImageView alloc]initWithFrame:CGRectMake(50, upImage.frame.origin.y + 160 + 115, SCREEN_WIDTH - 100, 70)];
        accountView.userInteractionEnabled = YES;
        accountView.image = [UIImage imageNamed:@"img_登录页面_输入框"];
        [self.view addSubview:accountView];
        
        [accountField removeFromSuperview];
        accountField = nil;
        
        accountField = [[UITextField alloc]initWithFrame:accountView.bounds];
        accountField.leftViewMode = UITextFieldViewModeAlways;
        accountField.keyboardType = UIKeyboardTypeNumberPad;
        
        //获取账号
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        accountField.text = [userDefault objectForKey:@"Pusername"];
        
        
        accountField.placeholder = @"请输入帐号";
       // [accountField setAdjustsFontSizeToFitWidth:YES];
        [accountField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        accountField.textColor = [UIColor colorWithHex:0xffffff];
        accountField.font = [UIFont systemFontOfSize:16];
        UIImageView *accountImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        accountImg.image = [UIImage imageNamed:@"icon_登录页面_手机号"];
        accountField.leftView = accountImg;
        [accountView addSubview:accountField];
        [accountField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        
#pragma mark - 密码输入框
        UIImageView *passwordtView = [[UIImageView alloc]initWithFrame:CGRectMake(50, accountView.frame.origin.y + 110, SCREEN_WIDTH - 100, 70)];
        passwordtView.image = [UIImage imageNamed:@"img_登录页面_输入框"];
        passwordtView.userInteractionEnabled = YES;
        [self.view addSubview:passwordtView];
        
        [passwordField removeFromSuperview];
        passwordField = nil;
        
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, passwordtView.frame.size.width - 130, 70)];
        passwordField.leftViewMode = UITextFieldViewModeAlways;
        passwordField.keyboardType = UIKeyboardTypeNumberPad;
        passwordField.placeholder = @"请输入验证码";
       // [passwordField setAdjustsFontSizeToFitWidth:YES];
        [passwordField setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
        passwordField.textColor = [UIColor colorWithHex:0xffffff];
        passwordField.font = [UIFont systemFontOfSize:16];
        UIImageView *passwordImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        passwordImg.image = [UIImage imageNamed:@"icon_登录页面_验证码"];
        passwordField.leftView = passwordImg;
        [passwordField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
        
        
        [passwordBtn removeFromSuperview];
        passwordBtn = nil;
        
        passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(passwordtView.frame.size.width - 115, 15 , 110, 40)];
        [passwordBtn setBackgroundImage:[UIImage imageNamed:@"img_登录页面验证码按钮"] forState:UIControlStateNormal];
        [passwordBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        passwordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [passwordBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [passwordBtn setTitle:@"222" forState:UIControlStateSelected];
        [passwordBtn addTarget:self action:@selector(passwordBtn:) forControlEvents:UIControlEventTouchUpInside];
        [passwordtView addSubview:passwordBtn];
        [passwordtView addSubview:passwordField];
        
        
#pragma mark - 登录按钮
        
        [logBtn removeFromSuperview];
        logBtn = nil;
        
        logBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, passwordtView.frame.origin.y + 130, SCREEN_WIDTH - 100, 70)];
        //    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
        //    [logBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [logBtn setBackgroundImage:[UIImage imageNamed:@"button_login_d"] forState:UIControlStateNormal];
        //    [logBtn setBackgroundColor:[UIColor yellowColor]];
        [logBtn addTarget:self action:@selector(logBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logBtn];
        
        logBtn.enabled = NO;
    }
    else{
#pragma mark - 账号输入框
        UIImageView *accountView = [[UIImageView alloc]initWithFrame:CGRectMake(50*SCREEN_W_SP, upImage.frame.origin.y + 120*SCREEN_H_SP + 115*SCREEN_H_SP, SCREEN_WIDTH - 100*SCREEN_W_SP, 50*SCREEN_H_SP)];
        accountView.image = [UIImage imageNamed:@"img_登录页面_输入框"];
        accountView.userInteractionEnabled = YES;
        [self.view addSubview:accountView];
        
        [accountField removeFromSuperview];
        accountField = nil;
        
        accountField = [[UITextField alloc]initWithFrame:accountView.bounds];
        accountField.leftViewMode = UITextFieldViewModeAlways;
        accountField.keyboardType = UIKeyboardTypeNumberPad;
        
        //获取账号
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        accountField.text = [userDefault objectForKey:@"Pusername"];
        accountField.placeholder = @"请输入帐号";
        [accountField setAdjustsFontSizeToFitWidth:YES];
        [accountField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        accountField.textColor = [UIColor colorWithHex:0xffffff];
        accountField.font = [UIFont systemFontOfSize:16];
        UIImageView *accountImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        accountImg.image = [UIImage imageNamed:@"icon_登录页面_手机号"];
        accountField.leftView = accountImg;
        [accountView addSubview:accountField];
        [accountField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];

#pragma mark - 密码输入框
        UIImageView * passwordtView = [[UIImageView alloc]initWithFrame:CGRectMake(50* SCREEN_W_SP, accountView.frame.origin.y + 70*SCREEN_H_SP, SCREEN_WIDTH - 100* SCREEN_W_SP, 50*SCREEN_H_SP)];
        passwordtView.userInteractionEnabled = YES;
        passwordtView.image = [UIImage imageNamed:@"img_登录页面_输入框"];
        [self.view addSubview:passwordtView];
        
        [passwordField removeFromSuperview];
        passwordField = nil;
        
        passwordField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, passwordtView.frame.size.width - 130* SCREEN_W_SP, 50*SCREEN_H_SP)];
        passwordField.leftViewMode = UITextFieldViewModeAlways;
        passwordField.keyboardType = UIKeyboardTypeNumberPad;
        passwordField.placeholder = @"请输入验证码";
        [passwordField setAdjustsFontSizeToFitWidth:YES];
        [passwordField setValue:[UIFont boldSystemFontOfSize:10] forKeyPath:@"_placeholderLabel.font"];
        passwordField.textColor = [UIColor colorWithHex:0xffffff];
        passwordField.font = [UIFont systemFontOfSize:16];
        UIImageView *passwordImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        passwordImg.image = [UIImage imageNamed:@"icon_登录页面_验证码"];
        passwordField.leftView = passwordImg;
        [passwordField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];

        [passwordBtn removeFromSuperview];
        passwordBtn = nil;
        
        passwordBtn = [[UIButton alloc]initWithFrame:CGRectMake(passwordtView.frame.size.width - 115* SCREEN_W_SP, 5 * SCREEN_H_SP, 110* SCREEN_W_SP, 40 * SCREEN_H_SP)];
        [passwordBtn setBackgroundImage:[UIImage imageNamed:@"img_登录页面验证码按钮"] forState:UIControlStateNormal];
        [passwordBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        passwordBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [passwordBtn setTitleColor:[UIColor colorWithHex:0xffffff] forState:UIControlStateNormal];
        [passwordBtn setTitle:@"222" forState:UIControlStateSelected];
        [passwordBtn addTarget:self action:@selector(passwordBtn:) forControlEvents:UIControlEventTouchUpInside];
        [passwordtView addSubview:passwordBtn];
        [passwordtView addSubview:passwordField];
        
#pragma mark - 登录按钮
        
        [logBtn removeFromSuperview];
        logBtn = nil;
        
        logBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, passwordtView.frame.origin.y + 90, SCREEN_WIDTH - 100, 50* SCREEN_H_SP)];
        //    [logBtn setTitle:@"登录" forState:UIControlStateNormal];
        //    [logBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        [logBtn setBackgroundImage:[UIImage imageNamed:@"button_login_d"] forState:UIControlStateNormal];
        //    [logBtn setBackgroundColor:[UIColor yellowColor]];
        [logBtn addTarget:self action:@selector(logBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:logBtn];
        
        logBtn.enabled = NO;
    }
    
    KeychainItemWrapper *keyWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"UUIDOfTheYouShuOnBizvane" accessGroup:nil];
    uuid = [keyWrapper objectForKey:(id)kSecValueData];
    
    if ([uuid isEqualToString:@""]) {
        
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        [keyWrapper setObject:uuid forKey:(id)kSecValueData];
        
    }
    
}

#pragma mark - 页面空白处点击（取消键盘响应）
-(void)self_ViewTap:(UITapGestureRecognizer *)tap{

    [accountField resignFirstResponder];
    
    [passwordField resignFirstResponder];
}



#pragma mark - 根据两个输入框时时输入情况检验登录按钮是否能点击
-(void)textFieldDidChange:(id)sender{

    if ([accountField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""]) {
        
        logBtn.enabled = NO;
    }else{
        
        logBtn.enabled = YES;
    }
    
}


#pragma mark - 验证码发送倒计时

NSInteger count = 61;
- (void)noticeTransation:(NSTimer *)timer {
    
    count--;
    [passwordBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发", (long)count] forState:UIControlStateDisabled];
    
    [passwordBtn setTitleColor:[UIColor colorWithHex:0x7a1117] forState:UIControlStateDisabled];
    if ( count < 1) {
        passwordBtn.enabled = YES;
        [passwordBtn setTitle:@"重发" forState:UIControlStateNormal];
        
        [self.timer invalidate];
    } else {
        
        passwordBtn.enabled = NO;
    }
    
}

#pragma mark - 密码按钮
-(void)passwordBtn:(UIButton *)sender{
    
    if (accountField.text.length == 0) {
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"请输入帐号";
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];

        return;
        
    }else{
    
    //此处写 获取验证码 请求
    [self requestMessagePort];
        
      
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(noticeTransation:) userInfo:nil repeats:YES];
    count = 61;
    [self.timer fire];
    [passwordBtn setTitle:@"60秒后重发" forState:UIControlStateSelected];
        
    }
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

-(void)logBtn:(UIButton *)sender{
    
    //此处是屏蔽登录环节（打开下面的 请求登录接口，屏蔽此处即为正常情况）
//    [AppDatas sharedDatas].userCode = accountField.text;
//     [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewController];

//    请求登录接口
    [self requestLoginPort];
    
    //记住账号
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //登陆成功后把用户名存储到UserDefault
    [userDefaults setObject:accountField.text forKey:@"Pusername"];
    
}


#pragma mark - 密码核对
-(void)loginCheckSuccess{
    
    if ([accountField.text isEqualToString:@"1"] && [passwordField.text isEqualToString:@"1"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [(AppDelegate*)[UIApplication sharedApplication].delegate switchRootViewController];
    }else{
        
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.delegate = self;
        HUD.mode = MBProgressHUDModeText;
        HUD.labelText = @"帐号或密码错误";
        HUD.margin = 10.f;
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:2];
        
    }
}


#pragma mark - 登录请求
-(void)requestLoginPort{

    BOOL netStatus=NO;
    netStatus = [CommonTools isConnectionAvailable:self];
    
    if (netStatus) {

   // [_alert alterShow];
      [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
     [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.USeeLogin"
                dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                
                                accountField.text, @"user_code",
                                passwordField.text,@"sms_code",
                                uuid, @"mac_id",
                                nil]
                     withCache:YES success:^(NSDictionary *responseDic) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                         
                             if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                
                                 
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"storeDetailsString"];
                                 
                                 [CommonTools writeFile:responseDic[@"data"][@"data"] toFile:@"user_info.plist"];
                                 
                                 [AppDatas sharedDatas].userCode = accountField.text;
                                 [[NSUserDefaults standardUserDefaults] setObject:accountField.text forKey:@"phone_num"];
                                 //                             获取用户个人信息并存储起来
                                 [AppDatas sharedDatas].userPersonalInformation = responseDic[@"data"][@"data"];
                                 NSInteger userTypeInt = [responseDic[@"data"][@"data"][@"userType"] integerValue];
                                 NSNumber *userType = [NSNumber numberWithInteger:userTypeInt];
                                 [[NSUserDefaults standardUserDefaults] setObject:userType forKey:@"userType"];
                                 [[NSUserDefaults standardUserDefaults] setObject:[AppDatas sharedDatas].userPersonalInformation forKey:@"userPersonalInformation"];
                                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"alreadyLaunch"];
                                 [[NSUserDefaults standardUserDefaults] setObject:responseDic[@"data"][@"data"][@"page_array"] forKey:@"funcPermission"];
                                 
                                 NSString * storeDetailsString  = responseDic[@"data"][@"data"][@"page_detail_store"];
                                 NSArray * storeDetailsArray = [storeDetailsString componentsSeparatedByString:@","];
                                 
                                 for (NSInteger w = 0; w < storeDetailsArray.count; w ++) {
                                     NSString * storeString = storeDetailsArray[w];
                                    
                                     if ([storeString isEqualToString:@"StoreDetailBrand"]) {
                                         
                                         [[NSUserDefaults standardUserDefaults] setObject:storeString forKey:@"storeDetailsString"];
                                     }
                                     
                                 }
                                 
                                 
                                 //                                [[NSUserDefaults standardUserDefaults] setObject:@"1,2,3,4,5,6,7" forKey:@"funcPermission"]; //   测试用
                                 
                                 
                                 //                             收回键盘
                                 [accountField resignFirstResponder];
                                 [passwordField resignFirstResponder];
                                 
                                 //                             登陆成功！跳转进入首页
                                 [(AppDelegate *)[UIApplication sharedApplication].delegate switchRootViewController];
                                 
                             } else {
                                 
                                 HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                 HUD.delegate = self;
                                 HUD.mode = MBProgressHUDModeText;
                                 HUD.labelText = responseDic[@"msg"];
                                 HUD.margin = 10.f;
                                 HUD.removeFromSuperViewOnHide = YES;
                                 [HUD hide:YES afterDelay:2];
                                 
                             }
                             
                          //   [_alert alterDisMiss];

                             [[HUDHelper getInstance] hideHUD];//隐藏提示框

                         });
                         
                         
                     } failure:^(NSError *error) {
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                         
                       //  [_alert alterDisMiss];
                    [[HUDHelper getInstance] hideHUD];//隐藏提示框
 
                             
                        if (error.code == -1001) {
                                 
                         [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                        }else{
                                 
                       [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];
                                 
                        }
    
                             
                         LOSAlert(@"请求失败或权限丢失，请联系商帆工作人员");
                         });
                     }];
        
         });
    }
    else{
        [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
    }
}


#pragma mark - 短信验证码请求
-(void)requestMessagePort{

  //  [_alert alterShow];
    BOOL netStatus=NO;
    netStatus = [CommonTools isConnectionAvailable:self];

    if (netStatus) {
        [[HUDHelper getInstance] showLabelHUDOnScreen:@"加载中" enabled:YES];  //加载中
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            [[LOSAFNetworking new]POST:@"com.bizvane.sun.usee.method.SendSMS"
                        dataParameters:[NSDictionary dictionaryWithObjectsAndKeys:
                                        
                                        accountField.text, @"user_code"
                                        
                                        , nil]
                             withCache:YES success:^(NSDictionary *responseDic) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     //  [_alert alterDisMiss];
                                     [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                     
                                     if ([responseDic[@"status"] isEqualToString:@"success"]) {
                                         
                                         self.dataDic = responseDic;
                                         
                                         HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                         HUD.delegate = self;
                                         HUD.mode = MBProgressHUDModeText;
                                         HUD.labelText = responseDic[@"msg"];
                                         HUD.margin = 10.f;
                                         HUD.removeFromSuperViewOnHide = YES;
                                         [HUD hide:YES afterDelay:2];
                                         
                                     }
                                     else if ([responseDic[@"status"] isEqualToString:@"failed"]) {
                                         
                                         HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                                         HUD.delegate = self;
                                         HUD.mode = MBProgressHUDModeText;
                                         HUD.labelText = @"短信获取失败";
                                         HUD.margin = 10.f;
                                         HUD.removeFromSuperViewOnHide = YES;
                                         [HUD hide:YES afterDelay:2];
                                         
                                     }
                                 });
                                 
                             } failure:^(NSError *error) {
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     //  [_alert alterDisMiss];
                                     [[HUDHelper getInstance] hideHUD];//隐藏提示框
                                     
                                     
                                     if (error.code == -1001) {
                                         
                                         [[HUDHelper getInstance]showErrorTipWithLabel:@"加载超时"];
                                     }
                                     else{
                                         
                                         [[HUDHelper getInstance]showErrorTipWithLabel:@"加载失败"];                             
                                     }
                                 });
                                 
                             }];
            
        });

    }
    else{
        [[HUDHelper getInstance] showInformationWithoutImage:@"请检查网络"];
    }
}



#pragma mark 键盘显示时会触发的方法
- (void)kbWillShow:(NSNotification *)noti {
    // 1.获取键盘高度
    // 1.1获取键盘结束时候的位置
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrm.size.height;
    self.keyBoadrHeight = kbHeight;
        self.view.frame = CGRectMake(0, 0 - self.keyBoadrHeight + 60, SCREEN_WIDTH, SCREEN_HEIGHT);
}

#pragma mark 键盘退出时会触发的方法
- (void)kbWillHide:(NSNotification *)noti {
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                           self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                   });
    
}


@end
