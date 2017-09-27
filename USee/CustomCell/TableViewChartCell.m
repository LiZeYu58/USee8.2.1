//
//  TableViewChartCell.m
//  LOSBi
//
//  Created by JJT on 16/9/8.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewChartCell.h"
#import "LOSHelper.h"

@interface TableViewChartCell ()

@end

@implementation TableViewChartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithWidth:(NSUInteger)unitWidth {
    
    @try {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        
        if (self) {
            
            _rankBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 6, 36, 36)];
            _rankBtn.layer.cornerRadius = 18;
            _rankBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            _rankBtn.clipsToBounds = YES;
            [self.contentView addSubview:_rankBtn];
            
            _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_rankBtn.frame.origin.x + 46, 15, SCREEN_WIDTH / 2 - _rankBtn.frame.origin.x - 40, 20)];
            _nameLab.font = [UIFont systemFontOfSize:15];
            _nameLab.textAlignment = NSTextAlignmentLeft;
            _nameLab.textColor = [UIColor grayColor];
            [self.contentView addSubview:_nameLab];
            
            _countLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 2, 15, SCREEN_WIDTH / 4 - 10, 20)];
            _countLab.textColor = [UIColor grayColor];
            _countLab.textAlignment = NSTextAlignmentRight;
            _countLab.font = [UIFont systemFontOfSize:15];
            [self.contentView addSubview:_countLab];
            
            _numBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 4 * 3, 19, unitWidth , 10)];
            _numBtn.userInteractionEnabled = NO;
            [_numBtn setBackgroundColor:[UIColor colorWithHex:0xd7d7d7] forState:UIControlStateNormal];
            [self.contentView addSubview:_numBtn];
            
        }
        
        return self;
 
    } @catch (NSException *exception) {
        
    }
    
}

@end
