//
//  TimeView.h
//  LOSBi
//
//  Created by JJT on 16/9/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "BaseView.h"



@class TimeView;
@protocol TimeViewDelegate <NSObject>

/**
 *  按钮点击事件
 */
- (void)TimeView:(TimeView *)timeView index:(NSInteger)index;

@end

@interface TimeView : BaseView

@property(assign, nonatomic) id<TimeViewDelegate> delegate;

-(void)showTimeBtn;    //日周月年按钮自定义（会销有展示，另外一种）

@end
