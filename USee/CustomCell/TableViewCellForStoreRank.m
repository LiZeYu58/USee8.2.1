//
//  TableViewCellForStoreRank.m
//  LOSBi
//
//  Created by luodong on 16/9/9.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForStoreRank.h"

@implementation TableViewCellForStoreRank

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self createCellUI];
      
    }
    return self;
}
-(void)createCellUI{
    
    CGFloat cellHeight = 40;
    
    //第一列
    _rankOrderLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, cellHeight / 4, 20 , 20)];

    _rankOrderLabel.textAlignment = NSTextAlignmentCenter;
    _rankOrderLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_rankOrderLabel];

    //第二列
    _storeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_rankOrderLabel.x +_rankOrderLabel.width + 38 *SCREEN_W_SP, 0, 100 *SCREEN_W_SP, 40)];
    _storeNameLabel.font = [UIFont systemFontOfSize:14];
    _storeNameLabel.textAlignment = NSTextAlignmentCenter;
    _storeNameLabel.textColor = [UIColor colorWithHex:0x888888];
    [self.contentView addSubview:_storeNameLabel];
    
    //第三列
    _thirdQueueLabel = [[UILabel alloc]initWithFrame:CGRectMake(_storeNameLabel.x + _storeNameLabel.width + 20, 0, 60, 40)];
    _thirdQueueLabel.font = [UIFont systemFontOfSize:14];
    _thirdQueueLabel.textColor = [UIColor colorWithHex:0x888888];
    _thirdQueueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_thirdQueueLabel];
    
    //第四列
    _fourthQueueLabel = [[UILabel alloc]initWithFrame:CGRectMake(_thirdQueueLabel.x + _thirdQueueLabel.width + 20, 0, 60, 40)];
    _fourthQueueLabel.font = [UIFont systemFontOfSize:14];
    _fourthQueueLabel.textColor = [UIColor colorWithHex:0x888888];
    _fourthQueueLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_fourthQueueLabel];
    
    //第五列
    _collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.width - 100, 0, 60, 30)];
    _collectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_collectBtn];
    
    _singleCollectSmall = [[UIButton alloc]initWithFrame:CGRectMake(0, (cellHeight / 2 - 12)* SCREEN_H_SP, 70 * SCREEN_W_SP, 24 * SCREEN_H_SP)];
    _singleCollectSmall.layer.cornerRadius = 6;
    _singleCollectSmall.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
    _singleCollectSmall.layer.borderWidth = 1;
    _singleCollectSmall.userInteractionEnabled = NO;
    [_collectBtn addSubview:_singleCollectSmall];
}


- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
