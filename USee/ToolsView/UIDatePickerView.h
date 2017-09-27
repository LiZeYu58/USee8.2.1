//
//  UIDatePickerView.h
//  LOSBi
//
//  Created by JJT on 16/8/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^UIDatePickerViewBlock)(NSDate *);

@interface UIDatePickerView : UIView


@property (nonatomic, copy) UIDatePickerViewBlock block;



- (void)showUIDatePicker;     // UIDatePicker的封装

@end
