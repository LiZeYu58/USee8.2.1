//
//  NSDate+LOSCompare.m
//  LOSBi
//
//  Created by JJT on 16/8/20.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "NSDate+LOSCompare.h"
#import "NSDate+Escort.h"

@implementation NSDate (LOSCompare)
- (BOOL)isEqualToYearMonthDay:(NSDate *)inDate {
    if (self.year == inDate.year
        && self.month == inDate.month
        && self.day == inDate.day) {
        return YES;
    } else {
        return NO;
    }
}
@end

