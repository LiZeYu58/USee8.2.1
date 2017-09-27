//
//  ShowView.m
//  LOSBi
//
//  Created by JJT on 16/8/19.
//  Copyright © 2016年 L.O.S. All rights reserved.
//



    //日历的展示和收回



#import "ShowView.h"
#import "CalendarView.h"
#import "ShiDuanView.h"
#import "LOSHelper.h"
#import "AppDatas.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ShowView ()<MBProgressHUDDelegate>
{
    
    UIButton *riliBtn;
    UIButton *sdBtn;
    UIView *riliView;
    UIView *sdView;
    MBProgressHUD *HUD;
    
}

@end

@implementation ShowView



-(void)CreateView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kvo_dis:) name:@"dismis" object:nil];
    
//    self.frame = CGRectMake(0, -SCREEN_H_SP * 1000, SCREEN_WIDTH, SCREEN_H_SP * 500);
    self.frame = CGRectMake(0, -SCREEN_H_SP * 1000, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor clearColor];
    
    UILabel *rilititleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44 * SCREEN_H_SP)];
    [rilititleLabel setText:@"日历"];
    [rilititleLabel setFont:[UIFont systemFontOfSize:17]];
    [rilititleLabel setTextAlignment:NSTextAlignmentCenter];
    [rilititleLabel setTextColor:[UIColor colorWithHex:0xeb4b55]];
    [rilititleLabel setBackgroundColor:[UIColor colorWithHex:0x2C1D1F]];
    [self addSubview:rilititleLabel];
    
    riliView = [[UIView alloc]initWithFrame:CGRectMake(0, rilititleLabel.frame.size.height, SCREEN_WIDTH, 490 * SCREEN_H_SP)];
    riliView.backgroundColor = [UIColor colorWithHex:0x2C1D1F];
    [self addSubview:riliView];
    
    sdView = [[UIView alloc]initWithFrame:CGRectMake(0, rilititleLabel.frame.size.height, SCREEN_WIDTH, 200 * SCREEN_H_SP)];
    sdView.backgroundColor = [UIColor colorWithHex:0x2C1D1F];
    sdView.hidden = YES;
    [self addSubview:sdView];
    
//    免费用户
    NSInteger userType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userType"] integerValue];
    
    if (userType == 2) {
        
        UIView *noChoiceMaskView = [[UIView alloc]initWithFrame:self.bounds];
        UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTouchForNoChoice:)];
        [noChoiceMaskView addGestureRecognizer:touchGesture];
        [self addSubview:noChoiceMaskView];
        
    }
    
    NSDate *tempDate = [AppDatas sharedDatas].selectFromDate;
    CalendarView * calender = [[CalendarView alloc] initWithFrame:riliView.bounds];
    calender.clipsToBounds = YES;
    [riliView addSubview:calender];
    [calender calendarInit:tempDate];
    
    ShiDuanView *shiDuanView = [[ShiDuanView alloc]initWithFrame:sdView.bounds];
    [sdView addSubview:shiDuanView];
    
    UIView *bottomUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 480 * SCREEN_H_SP, SCREEN_WIDTH, SCREEN_HEIGHT - 480 * SCREEN_H_SP)];
    [bottomUpView setBackgroundColor:[UIColor clearColor]];
    UISwipeGestureRecognizer *BottomUpGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(bottomUp:)];
    [BottomUpGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [bottomUpView addGestureRecognizer:BottomUpGesture];
    UITapGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTouch:)];
    [bottomUpView addGestureRecognizer:touchGesture];
    [self addSubview:bottomUpView];
    
}

- (void)singleTouchForNoChoice:(UITapGestureRecognizer *)recognizer {
    
    HUD = [MBProgressHUD showHUDAddedTo:self animated:YES];
    HUD.delegate = self;
    HUD.mode = MBProgressHUDModeText;
    HUD.labelText = @"收费用户可用";
    HUD.margin = 10.f;
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:2];

    
}

#pragma mark -
#pragma mark HUD的代理方法,关闭HUD时执行
-(void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
    hud = nil;
}

- (void)singleTouch:(UITapGestureRecognizer *)recognizer {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismis" object:nil];
    
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSUInteger currentLeftViewType = [tempAppDelegate.LeftSlideVC currentLeftViewType];
//    if (currentLeftViewType != NOLeftViewType) {
//        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:currentLeftViewType];
//    }
//    
//    if (self.returnTextBlock != nil) {
//        self.returnTextBlock(1);
//    }

}

- (void)bottomUp:(UISwipeGestureRecognizer *)recognizer {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismis" object:nil];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUInteger currentLeftViewType = [tempAppDelegate.LeftSlideVC currentLeftViewType];
    if (currentLeftViewType != NOLeftViewType) {
        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:currentLeftViewType];
    }
    
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(1);
    }
}


#pragma mark -  点击日历按钮
-(void)riliBtn{
    riliBtn.selected = !riliBtn.selected;
    
    if (!riliBtn.selected) {
        
        
        riliBtn.selected = YES;
        
        return;
    }
    
    if (riliBtn.selected) {
        riliView.hidden = NO;
        sdView.hidden = YES;
        sdBtn.selected = NO;
//        riliBtn.userInteractionEnabled = NO;
    }if (!riliBtn.selected) {
        riliView.hidden = YES;
        sdView.hidden = NO;
        sdBtn.selected = YES;
        [riliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [riliBtn setBackgroundColor:[UIColor colorWithHex:0x392528] forState:UIControlStateNormal];
        [sdBtn setTitleColor:[UIColor colorWithHex:0xeb4b55] forState:UIControlStateSelected];
        [sdBtn setBackgroundColor:[UIColor colorWithHex:0x2C1D1F] forState:UIControlStateSelected];

    }
}

#pragma mark -  点击时段按钮
-(void)sdBtn{
    
     sdBtn.selected = !sdBtn.selected;
    
    if (!sdBtn.selected) {
        
        
        sdBtn.selected = YES;
        
        return;
    }

    
   
    if (sdBtn.selected) {
        riliView.hidden = YES;
        sdView.hidden = NO;
        riliBtn.selected = NO;
        [sdBtn setTitleColor:[UIColor colorWithHex:0xeb4b55] forState:UIControlStateSelected];
        [sdBtn setBackgroundColor:[UIColor colorWithHex:0x2C1D1F] forState:UIControlStateSelected];
        [riliBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [riliBtn setBackgroundColor:[UIColor colorWithHex:0x392528] forState:UIControlStateNormal];

    }if (!sdBtn.selected) {
        riliView.hidden = NO;
        sdView.hidden = YES;
        riliBtn.selected = YES;

    }
}

-(void) kvo_dis:(NSNotification *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, -SCREEN_H_SP * 1000, SCREEN_WIDTH, SCREEN_H_SP * 560);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"calendarBtn" object:nil];
}

- (void)send:(RequestSuccessStringBlock)stringBlock
{
    NSLog(@"stringBlock = %@",stringBlock);
    self.returnTextBlock = stringBlock;
}


-(void)showView{
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, NavigationBarHeight, SCREEN_WIDTH, self.height + 60 * SCREEN_H_SP);
    }];
    
}


-(void)showView1{
    [self.superview bringSubviewToFront:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.height);
    }];
    
}


-(void)backView{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismis" object:nil];
//    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSUInteger currentLeftViewType = [tempAppDelegate.LeftSlideVC currentLeftViewType];
//    if (currentLeftViewType != NOLeftViewType) {
//        [tempAppDelegate.LeftSlideVC setPanEnabled:YES leftViewType:currentLeftViewType];
//    }
//
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, -SCREEN_H_SP * 1000, SCREEN_WIDTH, SCREEN_H_SP * 500 + NavigationBarHeight);
    }];
    
}




@end
