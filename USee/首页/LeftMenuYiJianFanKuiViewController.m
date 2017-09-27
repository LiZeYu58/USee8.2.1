//
//  LeftMenuYiJianFanKuiViewController.m
//  LOSBi
//
//  Created by gufeifei on 16/8/24.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "LeftMenuYiJianFanKuiViewController.h"
#import "UIView_extra.h"
#import "AppDelegate.h"

@interface LeftMenuYiJianFanKuiViewController () <UITextViewDelegate> {
    UITextView *_textView;
    UILabel *_holderPlaceLabel;
}

@end

@implementation LeftMenuYiJianFanKuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 30, 44);
    leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    
    [leftBtn addTarget:self action:@selector(leftBarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];

    
    self.title = @"意见反馈";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(sendBtnClicked)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight / 5 * 2)];
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_textView];
    
    _holderPlaceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, _textView.width, 20)];
    _holderPlaceLabel.text = @"留下您对有数的建议";
    _holderPlaceLabel.textColor = [UIColor colorWithHex:0x999999];
    [_textView addSubview:_holderPlaceLabel];
    
}

- (void)sendBtnClicked {
    DLog(@"sendBtnClicked");
}


#pragma mark - 

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _holderPlaceLabel.hidden = YES;
    } else {
        _holderPlaceLabel.hidden = NO;
    }
    self.navigationItem.rightBarButtonItem.enabled = _holderPlaceLabel.hidden;
}

#pragma mark -  返回按钮
-(void)leftBarBtnClicked{

    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [tempAppDelegate.mainNavigationController popViewControllerAnimated:YES];
    
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
