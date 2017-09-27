//
//  ThreeDetailViewController.h
//  LOSBi
//
//  Created by JJT on 16/9/15.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    店铺排行详情 页面总汇
 */


#import "BaseViewController.h"

@protocol storeViewControllDelegate;

@interface ThreeDetailViewController : BaseViewController

@property (nonatomic , assign) id<storeViewControllDelegate> delegate;

@property (nonatomic ,strong) NSString * orgCode;           //三级界面总汇

@property (nonatomic ,strong) NSString * titleCode;

@property (nonatomic ,strong) NSString *storeName;

@end

@protocol storeViewControllDelegate <NSObject>

-(void)stroeRefreshAfterPop;

@end
