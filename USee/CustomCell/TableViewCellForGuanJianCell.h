//
//  TableViewCellForGuanJianCell.h
//  LOSBi
//
//  Created by JJT on 16/9/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Charts.h"

@interface TableViewCellForGuanJianCell : UITableViewCell

@property (nonatomic,strong) UIView * upView;

@property (nonatomic,strong) UIView * upView1;

@property (nonatomic,strong) UILabel * uplLab;

@property (nonatomic,strong) UILabel * uprLab;

@property (nonatomic,strong) UILabel * uprLab1;

//@property (nonatomic, strong) LineChartView *chartView;

@property (nonatomic, strong) NSMutableArray * xValueArray;


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithArr1:(NSMutableArray *)arr1 WithArr2:(NSMutableArray *)arr2 WithArr3:(NSMutableArray *)arr3;


@end
