//
//  UIDatePickerView.m
//  LOSBi
//
//  Created by JJT on 16/8/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "UIDatePickerView.h"

@interface UIDatePickerView ()

@property (nonatomic,strong) UIView * bigView;

@property (nonatomic,strong) UIView * bottomView;

@property (nonatomic,strong) UIDatePicker *picker;

@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) UIButton *cancelBtn;

@end

@implementation UIDatePickerView

- (void)showUIDatePicker {

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [window addSubview:self];
    
    self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 216 - 50, SCREEN_WIDTH, 216 + 50);
    [self addSubview:self.bottomView];
    
    self.sureBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 5, 50, 40);
    [self.bottomView addSubview:self.sureBtn];
    
    
    self.cancelBtn.frame = CGRectMake(10, 5, 50, 40);
    [self.bottomView addSubview:self.cancelBtn];
    
    self.picker.frame = CGRectMake(0, 50, SCREEN_WIDTH, 216);
    [self.bottomView addSubview:self.picker];

}

-(UIDatePicker *)picker{
    if (!_picker) {
        
        self.picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        self.picker.datePickerMode = UIDatePickerModeDate;//模式选择
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
         self.picker.locale = locale;
        self.picker.maximumDate = [NSDate date];
    }
    return _picker;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        self.bottomView = [[UIView alloc]initWithFrame:CGRectZero];
        self.bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIButton *)sureBtn{
    
    if (!_sureBtn) {
        self.sureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.sureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.sureBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        self.cancelBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(void)cancelBtn:(UIButton *)sender{

    [self removeFromSuperview];

}

-(void)sureBtn:(UIButton *)sender{

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shijianduan" object:self.picker.date];

    
    [self removeFromSuperview];
}


@end
