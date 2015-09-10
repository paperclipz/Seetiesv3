//
//  DraftModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "DraftModel.h"


@implementation Location
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation Photo

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation DraftModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"location.address_components" :@"location"                                                       
                                                       }];
}
@end

@implementation DraftsModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end