//
//  NSObject+Extension.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/22/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NSObject+Extension.h"

@implementation NSObject(Extra)

-(BOOL)isNull
{
    
    BOOL _isNUll = false;
    if ([self isKindOfClass:[NSArray class]]) {
        
        NSArray* array = (NSArray*)self;
        if (array == nil || [array count] == 0) {
            _isNUll = true;
        }
    }
    
    return _isNUll;
}
@end
