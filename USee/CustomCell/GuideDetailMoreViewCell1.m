//
//  GuideDetailMoreViewCell1.m
//  LOSBi
//
//  Created by JJT on 16/11/14.
//  Copyright © 2016年 L.O.S. All rights reserved.



    //  导购详情 更多 cell1



#import "GuideDetailMoreViewCell1.h"

@implementation GuideDetailMoreViewCell1


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        
        
        UIView * bigView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 20 * SCREEN_W_SP, 100 * SCREEN_H_SP)];
        
        bigView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:bigView];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 0, (SCREEN_WIDTH - 10 * SCREEN_W_SP) / 3 - 20 * SCREEN_W_SP, 50 * SCREEN_H_SP)];
        
        _nameLab.textAlignment = NSTextAlignmentCenter;
        
        _nameLab.textColor = [UIColor grayColor];
        
        _nameLab.font = [UIFont systemFontOfSize:14];
        
        _nameLab.text = @"业绩";
        
        [bigView addSubview:_nameLab];
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 50 * SCREEN_H_SP, (SCREEN_WIDTH - 10 * SCREEN_W_SP) / 3 - 20, 30 * SCREEN_H_SP)];
        
        _numLab.textAlignment = NSTextAlignmentCenter;
        
        _numLab.textColor = [UIColor colorWithHex:0xba2932];
        
        _numLab.font = [UIFont systemFontOfSize:14];
        
        _numLab.text = @"1654";

       [bigView addSubview:_numLab];
        
        
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 10 * SCREEN_W_SP) / 3 - 1 * SCREEN_W_SP, 20 * SCREEN_H_SP, 1 * SCREEN_W_SP, 50 * SCREEN_H_SP)];
        
        [bigView addSubview:_lineView];
                
        
    }
    return self;
}





@end
