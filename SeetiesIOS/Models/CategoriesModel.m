//
//  CategoriesModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/21/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "CategoriesModel.h"


@implementation CategoryModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"images.default": @"defaultImageUrl",
                                                       @"images.selected": @"selectedImageUrl",
                                                       @"id" : @"category_id",
                                                       }];
}

@end

@implementation CategoriesModel

@end
