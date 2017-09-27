//
//  CalendarView.h
//  LOSBi
//
//  Created by JJT on 16/8/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//




/*
    
    日历控件封装
 */



#import <UIKit/UIKit.h>

@class MonthModel;

@interface CalendarView : UIView

- (void)calendarInit:(NSDate *)date;              // 日历界面的封装

-(void)reloadData;

//CollectionViewHeader
@end
@interface CalendarHeaderView : UICollectionReusableView
@end

//UICollectionViewCell
@interface CalendarCell : UICollectionViewCell
@property (weak, nonatomic) UILabel *dayLabel;
@property (weak, nonatomic) UILabel *lab;
@property (weak ,nonatomic)UIImageView *img;

@property (strong, nonatomic) MonthModel *monthModel;
@end

//存储模型
@interface MonthModel : NSObject
@property (assign, nonatomic) NSInteger dayValue;
@property (strong, nonatomic) NSDate *dateValue;
@property (assign, nonatomic) BOOL isSelectedDay;


@end
