//
//  TableViewCellForDetailStoreRank.m
//  LOSBi
//
//  Created by luodong on 16/9/22.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForDetailStoreRank.h"


#define colorText Color(123, 123, 123)

@implementation TableViewCellForDetailStoreRank

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        _firstLab = [[UILabel alloc]init];
        [self.contentView addSubview:_firstLab];
        
        _secondLab = [[UILabel alloc]init];
        _secondLab.textColor = colorText;
        [self.contentView addSubview:_secondLab];
        
        _thirdLab = [UILabel new];
        _thirdLab.textColor = colorText;
        [self.contentView addSubview:_thirdLab];
        
        _fourthLab = [[UILabel alloc]init];
        _fourthLab.textColor = colorText;
        [self.contentView addSubview:_fourthLab];
        
        _fifthLab = [UILabel new];
        _fifthLab.textColor = colorText;
        [self.contentView addSubview:_fifthLab];
        
        _sixthLab = [UILabel new];
        _sixthLab.textColor = colorText;
        [self.contentView addSubview:_sixthLab];
        
    }
    return self;
}

@end
