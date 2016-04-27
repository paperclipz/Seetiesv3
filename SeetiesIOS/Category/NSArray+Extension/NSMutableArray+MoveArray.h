//
//  NSMutableArray+MoveArray.h
//  DragDemo
//
//  Created by Seeties IOS on 5/28/15.
//  Copyright (c) 2015 YANGReal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (MoveArray)
- (void)moveObjectFromIndex:(NSUInteger)from toIndex:(NSUInteger)to;
@end
