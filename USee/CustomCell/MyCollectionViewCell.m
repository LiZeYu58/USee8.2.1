//
//  MyCollectionViewCell.m
//  LOSBi
//
//  Created by JJT on 16/9/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {
        
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 5 * SCREEN_H_SP, SCREEN_WIDTH / 4,20 * SCREEN_H_SP)];
        
        _nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        _nameLab.textAlignment = NSTextAlignmentCenter;
        
        _nameLab.font = [UIFont systemFontOfSize:10];
        
        [self.contentView addSubview:_nameLab];
        
        
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 28 * SCREEN_H_SP, SCREEN_WIDTH / 4, 20 * SCREEN_H_SP)];
        
        _numLab.textColor = [UIColor colorWithHex:0xba2932];
        
        _numLab.textAlignment = NSTextAlignmentCenter;
        
        _numLab.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:_numLab];
    
        
           }
    return self;
}


@end
