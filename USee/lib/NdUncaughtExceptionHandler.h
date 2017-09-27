//
//  NdUncaughtExceptionHandler.h
//  iShow
//
//  Created by zhang on 15/11/2.
//  Copyright © 2015年 Bizvane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NdUncaughtExceptionHandler : NSObject{
    
}

+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;

@end
