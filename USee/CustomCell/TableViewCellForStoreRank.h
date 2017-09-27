//
//  TableViewCellForStoreRank.h
//  LOSBi
//
//  Created by luodong on 16/9/9.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellForStoreRank : UITableViewCell

@property (nonatomic,strong) UILabel *rankOrderLabel;
@property (nonatomic,strong) UILabel *storeNameLabel;
@property (nonatomic,strong) UILabel *thirdQueueLabel;
@property (nonatomic,strong) UILabel *fourthQueueLabel;
@property (nonatomic,strong) UIButton *collectBtn;
@property (nonatomic,strong) UIButton *singleCollectSmall;
@end
