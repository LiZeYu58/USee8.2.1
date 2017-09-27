//
//  HUDHelper.m
//  USee
//
//  Created by 李泽雨 on 2017/3/27.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import "HUDHelper.h"

@implementation HUDHelper

+ (HUDHelper *) getInstance
{
    /*
     static dispatch_once_t once;
     static ThemeManager *instance = nil;
     dispatch_once( &once, ^{ instance = [[ThemeManager alloc] init]; } );
     return instance;
     */
    static HUDHelper *instance = nil;
    
    @synchronized(self) {
        if (instance == nil) {
            instance = [[HUDHelper alloc] init];
        }
    }
    
    return instance;
}


- (void)showLabelHUDOnScreen:(NSString*)label enabled:(BOOL)enabled{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.HUD.userInteractionEnabled = enabled;
    [[self appDelegate].window addSubview:self.HUD];
    
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    
    if (SCREEN_WIDTH == 320) {
        self.HUD.detailsLabelFont = [UIFont systemFontOfSize:14];
    }
    else{
       self.HUD.detailsLabelFont = [UIFont systemFontOfSize:17];
    }
    
    [self.HUD show:YES];
    
    [self.HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMBProgressHUDView)]];
}


//提示 错误tip
- (void)showErrorTipWithLabel:(NSString*)label{
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
   
    self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_提示_失败"]];
    
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
    
   
   [[self appDelegate].window addSubview:self.HUD];
    
  //  self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:17];
    [self.HUD show:YES];
    [self.HUD hide:YES afterDelay:1.0];
    [self.HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMBProgressHUDView)]];
}

#pragma mark - 只显示文字不显示图片
- (void)showInformationWithoutImage:(NSString*)label{
    
    if (self.HUD) {
        [self.HUD removeFromSuperview];
        self.HUD = nil;
    }
    
    self.HUD = [[MBProgressHUD alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:nil];
    // Set custom view mode
    self.HUD.mode = MBProgressHUDModeCustomView;
  
    [[self appDelegate].window addSubview:self.HUD];
    
    self.HUD.delegate = (id)self;
    //self.HUD.labelText = label;
    self.HUD.detailsLabelText = label;
    self.HUD.detailsLabelFont = [UIFont systemFontOfSize:17];
    [self.HUD show:YES];
   
    [self.HUD hide:YES afterDelay:1.0];
    [self.HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMBProgressHUDView)]];
}




-(void)removeMBProgressHUDView{
    [self.HUD hide:YES];
    
}

- (void)hideHUD{
    [self.HUD hide:YES];
}


- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


@end
