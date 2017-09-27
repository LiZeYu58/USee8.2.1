//
//  TableViewBarCells.m
//  LOSBi
//
//  Created by JJT on 16/9/14.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewBarCells.h"

@implementation TableViewBarCells

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithWidth:(NSUInteger)rr WithsmallWith:(NSMutableArray *)smallWithArray WithColors:(NSMutableArray *)lineBarcolors{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP, 10 * SCREEN_H_SP, 65, 40 * SCREEN_H_SP)];
        
        _nameLab.font = [UIFont systemFontOfSize:13];
//        _nameLab.backgroundColor = [UIColor orangeColor];
        
        _nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        [self.contentView addSubview:_nameLab];
        
        _valueLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 * SCREEN_W_SP+63, 20 * SCREEN_H_SP, 35, 20 * SCREEN_H_SP)];
        _valueLabel.font = [UIFont systemFontOfSize:13];
        _valueLabel.textAlignment = NSTextAlignmentCenter;
        //        _nameLab.backgroundColor = [UIColor orangeColor];
        
        _valueLabel.textColor = [UIColor colorWithHex:0x888888];
        
        [self.contentView addSubview:_valueLabel];
        
        
        _amountNum = [[UIView alloc]initWithFrame:CGRectMake(_nameLab.frame.origin.x +  100 + 3, 25 * SCREEN_H_SP, rr, 10 *SCREEN_H_SP)];
        
        _amountNum.backgroundColor = [UIColor grayColor];
        
        [self.contentView addSubview:_amountNum];
        
        UIView * smallView;
        
        double sss = 0;
        
        for (int i = 0; i < smallWithArray.count; i++) {
            
            if (i == 0) {
                
                double small = [smallWithArray[i] doubleValue];
                
                if (small < 0) {
                    small = 0;
                }
                
                smallView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, small, 10 *SCREEN_H_SP)];
                
                smallView.backgroundColor = lineBarcolors[i];
                
                 [_amountNum addSubview:smallView];
            
            }else{
            
                double small = [smallWithArray[i] doubleValue];
                
                double s = [smallWithArray[i-1] doubleValue];
                
                if (s < 0) {
                    s = 0;
                }
              
                if (small < 0) {
                    small = 0;
                }

                sss += s;
                
                smallView = [[UIView alloc]initWithFrame:CGRectMake(sss, 0, small, 10 *SCREEN_H_SP)];
                
                if (i < lineBarcolors.count) {
                    smallView.backgroundColor = lineBarcolors[i];
                } else {
                    smallView.backgroundColor = [UIColor colorWithHex:0xe5e5e5];
                }
                
                 [_amountNum addSubview:smallView];
                
            }
            
        }
        
      
    }
    
    
    return self;
    
}
@end
