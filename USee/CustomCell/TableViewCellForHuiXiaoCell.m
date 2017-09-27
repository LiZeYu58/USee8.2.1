//
//  TableViewCellForHuiXiaoCell.m
//  LOSBi
//
//  Created by JJT on 16/9/16.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForHuiXiaoCell.h"

@implementation TableViewCellForHuiXiaoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        _imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 *SCREEN_W_SP, 15 * SCREEN_H_SP, 10 *SCREEN_W_SP, 20 * SCREEN_H_SP)];
        
        
        [self.contentView addSubview:_imgBtn];
        
 
        _upNameLab = [[UILabel alloc]initWithFrame:CGRectMake(30 *SCREEN_W_SP, 5 *SCREEN_H_SP, 170 *SCREEN_W_SP, 20 *SCREEN_H_SP)];
        
//        _upNameLab.text = @"dsdsdd";
        
        _upNameLab.textColor = [UIColor grayColor];
        
        _upNameLab.textAlignment = NSTextAlignmentLeft;
        
        _upNameLab.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:_upNameLab];
        
        
        _downNameLab = [[UILabel alloc]initWithFrame:CGRectMake(30 *SCREEN_W_SP, 30 * SCREEN_H_SP, 50 *SCREEN_W_SP, 12 *SCREEN_H_SP)];
        
        _downNameLab.font = [UIFont systemFontOfSize:12];
        
//        _downNameLab.text = @"同期";
        _downNameLab.textAlignment = NSTextAlignmentLeft;
        _downNameLab.textColor = [UIColor colorWithHex:0x999999];
        
        [self.contentView addSubview:_downNameLab];
        
        
        
        
        _upNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170 *SCREEN_W_SP, 5 *SCREEN_H_SP, 60 *SCREEN_W_SP, 20 *SCREEN_H_SP)];
        
//        _upNumLab.text = @"9800(2345/3221)";
        
        _upNumLab.textColor = [UIColor grayColor];
        
        _upNumLab.textAlignment = NSTextAlignmentRight;
        
        _upNumLab.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_upNumLab];
        
        
        _upNumLab1 = [[UILabel alloc]initWithFrame:CGRectMake(_upNumLab.frame.origin.x + _upNumLab.frame.size.width, 5 *SCREEN_H_SP, 100 *SCREEN_W_SP, 20 *SCREEN_H_SP)];
        
        
        _upNumLab1.textColor = [UIColor grayColor];
        
        _upNumLab1.textAlignment = NSTextAlignmentLeft;
        
        _upNumLab1.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_upNumLab1];

        
        _downNumLab = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 170 *SCREEN_W_SP, 30 * SCREEN_H_SP, 160 *SCREEN_W_SP, 12 *SCREEN_H_SP)];
        
        _downNumLab.font = [UIFont systemFontOfSize:12];
        
//        _downNumLab.text = @"2500(4334/2323)";
        _downNumLab.textAlignment = NSTextAlignmentRight;
        _downNumLab.textColor = [UIColor colorWithHex:0x999999];
        
        [self.contentView addSubview:_downNumLab];
        
        
        
    }
    
    return self;

}

@end
