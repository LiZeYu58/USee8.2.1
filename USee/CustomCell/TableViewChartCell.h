//
//  TableViewChartCell.h
//  LOSBi
//
//  Created by JJT on 16/9/8.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewChartCell : UITableViewCell

@property (nonatomic ,strong) UIButton * rankBtn;

@property (nonatomic ,strong) UILabel * nameLab;


@property (nonatomic ,strong) UILabel * countLab;

@property (nonatomic ,strong) UIButton *numBtn;


@property (nonatomic ,assign) NSInteger width;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithWidth:(NSUInteger)rr;


@end
