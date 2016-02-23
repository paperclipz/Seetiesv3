//
//  QuickBrowseModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/23/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "QuickBrowseModel.h"

@implementation QuickBrowseModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"image.selected_background": @"backgroundImage",
                                                       @"image.logo": @"logoImage",
                                                       }];
}


@end
