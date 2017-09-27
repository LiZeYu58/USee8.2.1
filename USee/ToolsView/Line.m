//
//  Line.m
//  LOSBi
//
//  Created by JJT on 16/9/1.
//  Copyright © 2016年 L.O.S. All rights reserved.
//

#import "Line.h"

@implementation Line

@synthesize begin, end, color;

- (id)init
{
    self = [super init];
    if (self) {
        [self setColor:[UIColor whiteColor]];
    }
    return self;
}


@end
