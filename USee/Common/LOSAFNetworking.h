//
//  LOSAFNetworking.h
//  LOSBi
//
//  Created by gufeifei on 16/8/25.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface LOSAFNetworking : NSObject             //请求封装

- (void)                    POST:(NSString *)method
                  dataParameters:(NSDictionary *)parameters
                       withCache:(BOOL)isUseCache
                         success:(void (^)(NSDictionary *responseDic))success
                         failure:(void (^)(NSError *error))failure;

@end
