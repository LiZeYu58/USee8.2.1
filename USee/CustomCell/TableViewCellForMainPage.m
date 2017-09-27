//
//  TableViewCellForMainPage.m
//  LOSBi
//
//  Created by gufeifei on 16/8/11.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForMainPage.h"

@interface TableViewCellForMainPage () {
    
    UILabel *_amountValueLabel;
    
    UIView *_backgroungView;
    
    
    UILabel * _nameValueLable;
    
}

@end

@implementation TableViewCellForMainPage

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSString * brandStringLength = [[NSUserDefaults standardUserDefaults] objectForKey:@"brandStringLength"];
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _backgroungView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 70 * SCREEN_H_SP)];
        _backgroungView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:_backgroungView];
        
        _amountValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth - 20 - 130, 0, 130, 70 * SCREEN_H_SP)];
        _amountValueLabel.textColor = [UIColor colorWithHex:0xe43944];
        
        _amountValueLabel.font = [UIFont systemFontOfSize:26];
        _amountValueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_amountValueLabel];
        
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 220 * SCREEN_W_SP, 70 * SCREEN_H_SP)];
        
//        _logoImageView.image = [UIImage imageNamed:@"img_默认LOGO"];
        
        _logoImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:_logoImageView];
        
        _nameValueLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 220 * SCREEN_W_SP, 70 * SCREEN_H_SP)];
        
        _nameValueLable.textColor = [UIColor whiteColor];
        
        if (brandStringLength.length > 0) {
            _nameValueLable.font = [UIFont systemFontOfSize:15];
        }
        else{
            _nameValueLable.font = [UIFont systemFontOfSize:26];
        }
        
//        _nameValueLable.adjustsFontSizeToFitWidth = YES;
        _nameValueLable.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameValueLable];
        
        
    }
    return self;
}


-(void)setNameView:(NSString *)name{
    
    
    _nameValueLable.text = name;
    
    
}


-(void)setLogImageView:(UIImage *)image{
    
    _logoImageView.image = image;
}


- (void)setAmountValue:(NSString *)value {
    _amountValueLabel.text = value;
}

- (void)setBackgroundHidden:(BOOL)isHidden {
    _backgroungView.hidden = isHidden;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
