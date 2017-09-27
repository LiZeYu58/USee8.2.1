//
//  TableViewCellForMainPage.h
//  LOSBi
//
//  Created by gufeifei on 16/8/11.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellForMainPage : UITableViewCell

@property (nonatomic,strong)UIImageView * logoImageView;

- (void)setAmountValue:(NSString *)value;
- (void)setBackgroundHidden:(BOOL)isHidden;
- (void)setLogImageView:(UIImage *)image;
- (void)setNameView:(NSString *)name;


@end
