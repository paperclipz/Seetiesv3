//
//  PhotoModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"m.url" :@"imageURL",
                                                       @"m.resolution.w":@"imageWidth",
                                                       @"m.resolution.h":@"imageHeight"
                                                       
                                                       }];
}


-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    
    
    return copy;
    
}
@end
