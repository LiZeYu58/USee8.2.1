//
//  ShowView.h
//  LOSBi
//
//  Created by JJT on 16/8/19.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
 
    日历展示
 */


#import <UIKit/UIKit.h>

typedef void (^RequestSuccessStringBlock)(NSInteger  successInteger);

@interface ShowView : UIView

@property (nonatomic,copy)RequestSuccessStringBlock returnTextBlock;

- (void)send:(RequestSuccessStringBlock)stringBlock;

-(void)CreateView;          // 日历展示的封装

-(void)showView;

-(void)showView1;

-(void)backView;

@end
