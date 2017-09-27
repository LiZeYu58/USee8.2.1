//
//  MainPageDetailCompareView.m
//  LOSBi
//
//  Created by gufeifei on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.


    // 点击主页 上半部分 －－ 0004接口页面



#import "MainPageDetailCompareView.h"

@interface MainPageDetailCompareView () {
    
}

@end

@implementation MainPageDetailCompareView

- (instancetype)initWithFrame:(CGRect)frame {
    @try {
        self = [super initWithFrame:frame];
        
        if (self) {
            
            self.originBgColor = [UIColor colorWithHex:0xdfdfdf];
            self.originTextColor = [UIColor colorWithHex:0xa8a8a8];
            self.selectBgColor = [UIColor colorWithHex:0xffffff];
            self.selectTextColor = [UIColor colorWithHex:0xba2932];
            
            self.title = [[UILabel alloc] initWithFrame:CGRectMake(17 * SCREEN_W_SP, 6 * SCREEN_H_SP, frame.size.width - 15 * SCREEN_W_SP, 14)];
            self.title.textAlignment = NSTextAlignmentLeft;
            self.title.font = [UIFont systemFontOfSize:14];
            self.title.textColor = self.originTextColor;
            [self addSubview:self.title];
            
            self.chartColorView = [[UIView alloc] initWithFrame:CGRectMake(5 * SCREEN_W_SP, _title.frame.size.height / 2 + 4 * SCREEN_H_SP, 8 * SCREEN_W_SP, 8 * SCREEN_H_SP)];
            self.chartColorView.layer.cornerRadius = self.chartColorView.width / 2;
            [self addSubview:self.chartColorView];
            
            self.value = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height / 2 + 3 * SCREEN_H_SP, frame.size.width, 16)];
            self.value.font = [UIFont systemFontOfSize:16];
            self.value.textAlignment = NSTextAlignmentCenter;
            self.value.textColor = self.originTextColor;
            [self.value setAdjustsFontSizeToFitWidth:YES];
            [self addSubview:self.value];
            
        }
        
        return self;

    } @catch (NSException *exception) {
        
    }
    
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    _title.text = title;
    _value.text = value;
    

}

-(void)setTitle:(NSString *)title value:(NSString *)value valueFont:(NSInteger)valueFont{
    [self setTitle:title value:value];
    _value.font = [UIFont systemFontOfSize:valueFont];
}

- (void)setSelected:(BOOL)selected {
    
    @try {
        _selected = selected;
        
        //更新ui
        if (_selected) {
            self.backgroundColor = self.selectBgColor;
            _title.textColor = self.selectTextColor;
            _value.textColor = self.selectTextColor;
        } else {
            self.backgroundColor = self.originBgColor;
            _title.textColor = self.originTextColor;
            _value.textColor = self.originTextColor;
        }

    } @catch (NSException *exception) {
        
    }
}

- (void)setChartColor:(UIColor *)chartColor {
    _chartColorView.backgroundColor = chartColor;
}

- (UIColor *)chartColor {
    return _chartColorView.backgroundColor;
}

- (void)setOriginBgColor:(UIColor *)originBgColor {
    _originBgColor = originBgColor;
    [self setSelected:_selected];
}

- (void)setSelectBgColor:(UIColor *)selectBgColor {
    _selectBgColor = selectBgColor;
    [self setSelected:_selected];
}

- (void)setOriginTextColor:(UIColor *)originTextColor {
    _originTextColor = originTextColor;
    [self setSelected:_selected];
}

- (void)setSelectTextColor:(UIColor *)selectTextColor {
    _selectTextColor = selectTextColor;
    [self setSelected:_selected];
}

@end
