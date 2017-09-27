//
//  TableViewCellForGoodsRank.h
//  LOSBi
//
//  Created by luodong on 16/9/19.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellForGoodsRank : UITableViewCell

@property (nonatomic,strong) UILabel *rankOrder;
@property (nonatomic,strong) UIImageView *goodsImgView;
@property (nonatomic,strong) UILabel *goodsName;


@property (nonatomic,strong) UILabel *third;
@property (nonatomic,strong) UILabel *fourth;
@property (nonatomic,strong) UILabel *fifth;
@property (nonatomic,strong) UILabel *sixth;

@property (nonatomic,strong) UIButton *singleCollect;
@property (nonatomic,strong) UIButton *singleCollectSmall;

@end
