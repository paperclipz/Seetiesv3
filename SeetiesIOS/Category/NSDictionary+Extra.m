//
//  NSDictionary+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "NSDictionary+Extra.h"

@implementation NSDictionary(Extra)

- (BOOL)containsKey: (NSString *)key{
    BOOL retVal = 0;
    NSArray *allKeys = [self allKeys];
    retVal = [allKeys containsObject:key];
    return retVal;
}


@end
