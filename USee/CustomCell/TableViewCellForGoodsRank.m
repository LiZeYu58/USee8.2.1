//
//  TableViewCellForGoodsRank.m
//  LOSBi
//
//  Created by luodong on 16/9/19.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "TableViewCellForGoodsRank.h"

@implementation TableViewCellForGoodsRank

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCellUI];
        
    }
    return self;
}
-(void)createCellUI{
    
    CGFloat cellHeight = 96 * SCREEN_H_SP;
    
    //第一列
    _rankOrder = [[UILabel alloc]initWithFrame:CGRectMake(26 * SCREEN_W_SP, cellHeight / 2 - 10 * SCREEN_H_SP, 20*SCREEN_W_SP, 20*SCREEN_H_SP)];
    _rankOrder.layer.cornerRadius = _rankOrder.width / 2;
    _rankOrder.clipsToBounds = YES;
    _rankOrder.textAlignment = NSTextAlignmentCenter;
    _rankOrder.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_rankOrder];
    
    //第二列
    _goodsImgView = [[UIImageView alloc]init];
    if (SCREEN_WIDTH > 414) {
        _goodsImgView.frame = CGRectMake(SCREEN_WIDTH / 6 + 35 * SCREEN_W_SP, 8 * SCREEN_H_SP, 60 * SCREEN_W_SP, 60 * SCREEN_H_SP);
    }
    else{
         _goodsImgView.frame = CGRectMake(SCREEN_WIDTH / 6 + 17 * SCREEN_W_SP, 8 * SCREEN_H_SP, 60 * SCREEN_W_SP, 60 * SCREEN_H_SP);
    }
//    _goodsImgView.backgroundColor = Color(240, 240, 240);
    [self.contentView addSubview:_goodsImgView ];
    
    _goodsName = [[UILabel alloc]init];
    
    if (SCREEN_WIDTH > 414) {
        _goodsName.frame = CGRectMake(SCREEN_WIDTH / 6 + 30 * SCREEN_W_SP, cellHeight - 20 * SCREEN_H_SP, (60 + 6) * SCREEN_W_SP, 16);
    }
    else{
        _goodsName.frame = CGRectMake(SCREEN_WIDTH / 6 + 15 * SCREEN_W_SP, cellHeight - 23 * SCREEN_H_SP, (60 + 6) * SCREEN_W_SP, 16);
    }

    
    _goodsName.font = [UIFont systemFontOfSize:14];
    _goodsName.textColor = Color(123, 123, 123);
    _goodsName.textAlignment = NSTextAlignmentCenter;
    [_goodsName setAdjustsFontSizeToFitWidth:YES];
//    _goodsName.backgroundColor = Color(220, 220, 220);
    [self.contentView addSubview:_goodsName];
    
    //第三列
    _third = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 3 + 10 * SCREEN_W_SP, 0, 60 * SCREEN_W_SP, 14)];
    _third.font = [UIFont systemFontOfSize:14];
    _third.textColor = Color(123, 123, 123);
    _third.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_third];
    
    //第四列
    _fourth = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 + 10 * SCREEN_W_SP, 0, 60 * SCREEN_W_SP, 14)];
    _fourth.font = [UIFont systemFontOfSize:14];
    _fourth.textColor = Color(123, 123, 123);
    _fourth.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_fourth];
    
    //第五列
    _fifth = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 6 * 4 + 10 * SCREEN_W_SP, 0, 60 * SCREEN_W_SP, 14)];
    _fifth.font = [UIFont systemFontOfSize:14];
    _fifth.textColor = Color(123, 123, 123);
    _fifth.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_fifth];
    
    //第六列
    _sixth = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 6 * 5 + 10 * SCREEN_W_SP, 0, 60 * SCREEN_W_SP - 10 * SCREEN_W_SP, 14)];
    _sixth.font = [UIFont systemFontOfSize:14];
    _sixth.textColor = Color(123, 123, 123);
    _sixth.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_sixth];
    
    
    //收藏
    _singleCollect = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.width - 100 * SCREEN_W_SP, cellHeight / 2 - 22  * SCREEN_H_SP, 70 * SCREEN_W_SP, 25 * SCREEN_H_SP)];
    _singleCollect.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_singleCollect];
    
    _singleCollectSmall = [[UIButton alloc]initWithFrame:CGRectMake(0, cellHeight / 2 - 12  * SCREEN_H_SP, 70 * SCREEN_W_SP, 24 * SCREEN_H_SP)];
    _singleCollectSmall.layer.cornerRadius = 6;
    _singleCollectSmall.layer.borderColor = [UIColor colorWithHex:0xaaaaaa].CGColor;
    _singleCollectSmall.layer.borderWidth = 1;
    _singleCollectSmall.userInteractionEnabled = NO;
    [_singleCollect addSubview:_singleCollectSmall];
}






@end
