//
//  TableViewCellForGuideData.m
//  LOSBi
//
//  Created by luodong on 16/11/10.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForGuideData.h"

@implementation TableViewCellForGuideData

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self createUI];
        
    }
    return self;
}

-(void)createUI{
    
    _FirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(25 * SCREEN_W_SP, self.height / 2 - 10 * SCREEN_H_SP, 20 * SCREEN_W_SP, 20 * SCREEN_H_SP)];

    _FirstLabel.textAlignment = NSTextAlignmentCenter;
    _FirstLabel.font = Font_14;
    [self.contentView addSubview:_FirstLabel];
    
    
    _SecondLabel = [[UILabel alloc]init];
    if (SCREEN_WIDTH > 414) {
       
        _SecondLabel.frame = CGRectMake(80 * SCREEN_W_SP, 0, 70 * SCREEN_W_SP, self.height);
    }
    else{
        
         _SecondLabel.frame = CGRectMake(80 * SCREEN_W_SP, 0, 70 * SCREEN_W_SP, self.height);
    }
    
    _SecondLabel.textColor = ColorText;
    _SecondLabel.textAlignment = NSTextAlignmentCenter;
    _SecondLabel.font = Font_14;
    [self.contentView addSubview:_SecondLabel];
    
    
    _ThirdLabel = [[UILabel alloc]init];
    
    if (SCREEN_WIDTH > 414) {
        
        _ThirdLabel.textAlignment = NSTextAlignmentLeft;
        _ThirdLabel.frame = CGRectMake(_SecondLabel.x + _SecondLabel.width + 20 * SCREEN_W_SP, 0, _SecondLabel.width + 35 * SCREEN_W_SP, self.height);
    }
    else{
        
        _ThirdLabel.textAlignment = NSTextAlignmentCenter;
        _ThirdLabel.frame = CGRectMake(_SecondLabel.x + _SecondLabel.width + 20 * SCREEN_W_SP, 0, _SecondLabel.width + 35 * SCREEN_W_SP, self.height);
    }
    _ThirdLabel.textColor = ColorText;
    _ThirdLabel.textAlignment = NSTextAlignmentCenter;
    _ThirdLabel.font = Font_14;
    _ThirdLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:_ThirdLabel];
    
    _FourthLabel = [[UILabel alloc]init];
    
    if (SCREEN_WIDTH > 414) {
        
        _FourthLabel.frame = CGRectMake(_ThirdLabel.x + _ThirdLabel.width - 30, 0, 70 * SCREEN_W_SP, self.height);
    }
    else{
        
        _FourthLabel.frame = CGRectMake(_ThirdLabel.x + _ThirdLabel.width + 15 * SCREEN_W_SP, 0, 70 * SCREEN_W_SP, self.height);
    }
    
    _FourthLabel.textColor = ColorText;
    _FourthLabel.textAlignment = NSTextAlignmentCenter;
    _FourthLabel.font = Font_14;
    [self.contentView addSubview:_FourthLabel];
    
    _CollectButton = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.width - 100 * SCREEN_W_SP, 0, 80 * SCREEN_W_SP, self.height)];
    _CollectButton.titleLabel.font = Font_14;
    _CollectButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_CollectButton];
    
    
    _singleCollectSmall = [[UIButton alloc]initWithFrame:CGRectMake(0, self.height / 2 - 12* SCREEN_H_SP, 80 * SCREEN_W_SP, 24 * SCREEN_H_SP)];
    _singleCollectSmall.layer.cornerRadius = 6;
    _singleCollectSmall.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
    _singleCollectSmall.layer.borderWidth = 1;
    _singleCollectSmall.userInteractionEnabled = NO;
    [_CollectButton addSubview:_singleCollectSmall];
    
}

@end
