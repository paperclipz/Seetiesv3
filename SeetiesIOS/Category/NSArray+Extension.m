//
//  NSArray+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/22/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NSArray+Extension.h"

@interface NSMutableArray (Shuffling)

- (void)shuffle;

@end

@implementation NSMutableArray (Shuffling)

- (void)shuffle {
    @synchronized(self) {
        NSUInteger count = [self count];
        
        if (count == 0) {
            return;
        }
        
        for (NSUInteger i = 0; i < count; i++) {
            NSUInteger j = arc4random() % (count - 1);
            
            if (j != i) {
                [self exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
}

@end

@implementation NSArray(Extra)

- (NSArray *)shuffledArray {
    NSMutableArray *newArray = [self mutableCopy];
    
    [newArray shuffle];
    return newArray;
}

@end


