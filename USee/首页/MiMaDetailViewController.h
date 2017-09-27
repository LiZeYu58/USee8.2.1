//
//  MiMaDetailViewController.h
//  LOSBi
//
//  Created by JJT on 16/8/30.
//  Copyright © 2016年 L.O.S. All rights reserved.




/*
 
    密码详情
 */



#import "BaseViewController.h"

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;



@interface MiMaDetailViewController : BaseViewController


/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;                // 密码详情


@property (nonatomic, assign) BOOL isChangeGesture;  //修改手势密码

@property (nonatomic, assign) BOOL bol;



@end
