//
//  YearsCollectionViewCell.m
//  LOSBi
//
//  Created by JJT on 16/8/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "YearsCollectionViewCell.h"

@implementation YearsCollectionViewCell


-(id)initWithFrame:(CGRect)frame{
    //完成单元格的定制任务
    self=[super initWithFrame:frame];
    
    if (self) {
        
        _yearLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH / 3, 50)];
        
        _yearLab.font = [UIFont systemFontOfSize:17];
        
        _yearLab.textColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:_yearLab];
    }
    return self;
}

@end
