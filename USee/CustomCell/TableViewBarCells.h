//
//  TableViewBarCells.h
//  LOSBi
//
//  Created by JJT on 16/9/14.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewBarCells : UITableViewCell

@property (nonatomic ,strong) UILabel * nameLab;

@property (nonatomic,strong)UILabel * valueLabel;

@property (nonatomic ,strong) UIView * amountNum;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithWidth:(NSUInteger)rr WithsmallWith:(NSMutableArray *)smallWithArray WithColors:(NSMutableArray *)lineBarcolors;


@end
