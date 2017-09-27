//
//  BaseWebViewViewController.m
//  USee
//
//  Created by 李泽雨 on 2017/5/4.
//  Copyright © 2017年 L.O.S. All rights reserved.
//

#import "BaseWebViewViewController.h"

@interface BaseWebViewViewController ()
{
    UIWebView * localWebView;
}
@end

@implementation BaseWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   // [self.navigationController.navigationBar setBackgroundColor:[UIColor blueColor]];
   
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHex:0xb3333a];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"button_back"] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc ] initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15*SCREEN_W_SP;
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, left];
    
    [self creatWebView];
}

-(void)backAction
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)creatWebView{
    
    [localWebView removeFromSuperview];
    localWebView = nil;
    
    if (!localWebView) {
        localWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        localWebView.backgroundColor = [UIColor clearColor];
        [localWebView setScalesPageToFit:YES];
        localWebView.scrollView.showsVerticalScrollIndicator = NO;
        NSURL *url = [[NSURL alloc]initWithString:_urlString];
        [localWebView loadRequest:[NSURLRequest requestWithURL:url]];
        
        [self.view addSubview:localWebView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
