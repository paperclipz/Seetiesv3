//
//  NSMutableArray+MoveArray.m
//  DragDemo
//
//  Created by Seeties IOS on 5/28/15.
//  Copyright (c) 2015 YANGReal. All rights reserved.
//

#import "NSMutableArray+MoveArray.h"

@implementation NSMutableArray (MoveArray)
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to
{
    if (to != from) {
        id obj = [self objectAtIndex:from];
       // [obj retain];
        [self removeObjectAtIndex:from];
        if (to >= [self count]) {
            [self addObject:obj];
        } else {
            [self insertObject:obj atIndex:to];
        }
       // [obj release];
    }
}
@end
