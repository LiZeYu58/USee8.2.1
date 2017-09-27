//
//  MyView.h
//  LOSBi
//
//  Created by JJT on 16/8/22.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "BaseView.h"


@interface MyView : BaseView

@property UINavigationController *nc;



+ (id)shareInstance;

- (void)refreshView;


@end
