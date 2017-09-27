//
//  SheQuView.h
//  LOSBi
//
//  Created by JJT on 16/8/23.
//  Copyright © 2016年 L.O.S. All rights reserved.
//





/*
 
    社区页面
 */




#import "MyView.h"

@protocol SheQuDelegate <NSObject>

-(void)disappearRedRoundLabel;

@end

@interface SheQuView : MyView

//协议申明
@property (assign,nonatomic) id<SheQuDelegate> delegate;


-(void)receiveCode:(NSString *)orgCode;

@end
