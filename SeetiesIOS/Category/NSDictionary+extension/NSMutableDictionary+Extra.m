//
//  NSMutableDictionary+Extra.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/2/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NSMutableDictionary+Extra.h"

@implementation NSMutableDictionary(Extra)



-(void)appendDictionarywithKey:(NSString*)key withValue:(NSString*)value
{
    
    
    if (![Utils isStringNull:value]) {
        NSDictionary* tempDict = @{key : value};
        
        [self addEntriesFromDictionary:tempDict];
        
    }
}
@end
