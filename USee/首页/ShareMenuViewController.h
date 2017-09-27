//
//  ShareMenuViewController.h
//  LOSBi
//
//  Created by gufeifei on 16/8/16.
//  Copyright © 2016年 L.O.S. All rights reserved.




/*
 
    导航栏右侧分享按钮点击跳转至此页面
 */


#import "BaseViewController.h"

@interface ShareMenuViewController : BaseViewController

//@property (nonatomic, strong) UIImage * vi;

- (instancetype)initWithShareBtn:(UIButton *)inShareBtn;            //点击导航栏上的分享，弹出的界面

@end
