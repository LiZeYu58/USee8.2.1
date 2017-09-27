//
//  TableViewCellForYejiTopRight.m
//  LOSBi
//
//  Created by gufeifei on 16/9/6.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForYejiTopRight.h"

@interface TableViewCellForYejiTopRight () {
    UIView *_backgroungView;
    
    UILabel *_titleLabel;
    UILabel *_valueLabel;
}

@end

@implementation TableViewCellForYejiTopRight

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    @try {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            self.backgroundColor = [UIColor clearColor];
            
            
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * SCREEN_W_SP, 0, 70 * SCREEN_W_SP, self.contentView.height)];
            _titleLabel.textColor = [UIColor whiteColor];
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_titleLabel];
            
            _valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100* SCREEN_W_SP, 0, 80* SCREEN_W_SP, self.contentView.height)];
            _valueLabel.textColor = [UIColor whiteColor];
            _valueLabel.textAlignment = NSTextAlignmentRight;
            _valueLabel.font = [UIFont systemFontOfSize:14];
            [self.contentView addSubview:_valueLabel];
        }
        return self;

    } @catch (NSException *exception) {
        
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _valueLabel.x = frame.size.width - 10 * SCREEN_W_SP - 80* SCREEN_W_SP;
    
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setValue:(NSString *)value {
    _valueLabel.text = value;
}



@end

