//
//  TableViewCellForShangPinCell.m
//  LOSBi
//
//  Created by JJT on 16/9/17.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForShangPinCell.h"

@interface TableViewCellForShangPinCell ()


@end

@implementation TableViewCellForShangPinCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat cellHeight = 96 *SCREEN_H_SP;
        
        
        _rankBtn = [[UIButton alloc]initWithFrame:CGRectMake(25 *SCREEN_W_SP, (cellHeight / 2 - 10 *SCREEN_H_SP), 25 , 25 )];
        
        _rankBtn.layer.cornerRadius = _rankBtn.width /2;
        
        _rankBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _rankBtn.adjustsImageWhenHighlighted = NO;
        _rankBtn.clipsToBounds = YES;
        [self.contentView addSubview:_rankBtn];
        
        
        _imag = [[UIImageView alloc]initWithFrame:CGRectMake((10 + 50 + 15) *SCREEN_W_SP, 8*SCREEN_H_SP, 60 *SCREEN_W_SP, 60 *SCREEN_H_SP)];
        

        _imag.clipsToBounds = YES;
        
        [self.contentView addSubview:_imag];
        

        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(_imag.x, cellHeight - (20 + 4) *SCREEN_H_SP, _imag.width, 20 *SCREEN_H_SP)];
        
        _nameLab.text = @"FXD3456785";
        [_nameLab setAdjustsFontSizeToFitWidth:YES];
        _nameLab.font = [UIFont systemFontOfSize:6];
        
        _nameLab.textColor = [UIColor colorWithHex:0x888888];
        
        _nameLab.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_nameLab];
        
        
        _rankOneLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -20 * SCREEN_W_SP) / 6 * 2, 40 *SCREEN_H_SP, (SCREEN_WIDTH -20 * SCREEN_W_SP) / 6, 20 * SCREEN_H_SP)];
        
        _rankOneLab.textAlignment = NSTextAlignmentCenter;
        
        _rankOneLab.textColor = [UIColor colorWithHex:0x888888];
        
        _rankOneLab.text = @"";
        _rankOneLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rankOneLab];
        
        
        _rankTwoLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -20 * SCREEN_W_SP) / 6 * 3, 40 *SCREEN_H_SP, (SCREEN_WIDTH -20 * SCREEN_W_SP) / 6, 20 * SCREEN_H_SP)];
        
        
        _rankTwoLab.textAlignment = NSTextAlignmentCenter;
        
        _rankTwoLab.textColor = [UIColor colorWithHex:0x888888];
        
        _rankTwoLab.text = @"";
        _rankTwoLab.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_rankTwoLab];
        
        
        
        _rankThreeLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -20 * SCREEN_W_SP) / 6 * 4,40 *SCREEN_H_SP, (SCREEN_WIDTH -20 * SCREEN_W_SP) / 6, 20 * SCREEN_H_SP)];
        
        _rankThreeLab.textAlignment = NSTextAlignmentCenter;
        
        _rankThreeLab.textColor = [UIColor colorWithHex:0x888888];
        
        _rankThreeLab.text = @"";
        _rankThreeLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rankThreeLab];
        

        
        _rankFourthLab = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH -20 * SCREEN_W_SP) / 6 * 5,40 *SCREEN_H_SP, (SCREEN_WIDTH -20 * SCREEN_W_SP) / 6, 20 * SCREEN_H_SP)];
        
        _rankFourthLab.textAlignment = NSTextAlignmentCenter;
        
        _rankFourthLab.textColor = [UIColor colorWithHex:0x888888];
        
        _rankFourthLab.text = @"";
        _rankFourthLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_rankFourthLab];
        
        
    }
    return self;

}


@end
