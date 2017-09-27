//
//  RequestInterfceViewController.h
//  iShow
//
//  Created by 李泽雨 on 2017/1/18.
//  Copyright © 2017年 Bizvane. All rights reserved.
//

#import "BaseViewController.h"

@interface RequestInterfceViewController : BaseViewController

@property (nonatomic, copy)  void(^successBlock) (NSDictionary * successDic);

@property (nonatomic, copy)  void(^DataDicBlock)(NSDictionary * dic);

@property (nonatomic, copy)  void(^errolBlock)(NSInteger  errolCodeInt);

@property (nonatomic, copy)  void(^noNetworkBlock)();

#pragma mark 报名接口请求
-(void)requestEnrollInterface:(NSString *)interfaceString requestDic:(NSDictionary *)dic;


@end
