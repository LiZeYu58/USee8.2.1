//
//  QuYuCollectionViewCell.m
//  LOSBi
//
//  Created by JJT on 16/11/3.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "QuYuCollectionViewCell.h"

@implementation QuYuCollectionViewCell


-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    
    if (self) {

        _colorLab = [[UILabel alloc]initWithFrame:CGRectMake(20 * SCREEN_W_SP, 10 * SCREEN_H_SP, 12 * SCREEN_H_SP,12 * SCREEN_H_SP)];

        
        [self.contentView addSubview:_colorLab];
        
//        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_colorLab.frame.origin.x + _colorLab.frame.size.width + 10 * SCREEN_W_SP, 10 * SCREEN_H_SP, 50 * SCREEN_W_SP,12 * SCREEN_H_SP)];
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_colorLab.frame.origin.x + _colorLab.frame.size.width + 10 * SCREEN_W_SP, 10 * SCREEN_H_SP, 75 * SCREEN_W_SP,12 * SCREEN_H_SP)];
        
        
        _nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        _nameLab.textAlignment = NSTextAlignmentLeft;
      //  [_nameLab setAdjustsFontSizeToFitWidth:YES];
        
        _nameLab.font = [UIFont systemFontOfSize:12];
        

         [self.contentView addSubview:_nameLab];
        
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x + _nameLab.frame.size.width, 10 * SCREEN_H_SP, 60,12 * SCREEN_H_SP)];

        _numLab.textColor = [UIColor colorWithHex:0x888888];
        
        _numLab.textAlignment = NSTextAlignmentCenter;
        
        _numLab.font = [UIFont systemFontOfSize:12];
        
        [self.contentView addSubview:_numLab];
        
    }
    return self;
}



@end
