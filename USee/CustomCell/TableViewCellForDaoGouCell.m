//
//  TableViewCellForDaoGouCell.m
//  LOSBi
//
//  Created by JJT on 16/11/10.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForDaoGouCell.h"

@implementation TableViewCellForDaoGouCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 100 * SCREEN_W_SP, 30 * SCREEN_H_SP)];

        _nameLab.font = [UIFont systemFontOfSize:13];
        
        _nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        _nameLab.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameLab];
        
        
        _numLab = [[UILabel alloc]initWithFrame:CGRectMake(205 * SCREEN_W_SP - 60 * SCREEN_W_SP, 10, 60 * SCREEN_W_SP, 30 * SCREEN_H_SP)];

        
        _numLab.font = [UIFont systemFontOfSize:13];
        
        _numLab.textColor = [UIColor colorWithHex:0x888888];

        
        _numLab.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:_numLab];
        
              
    }
    return self;
}


@end
