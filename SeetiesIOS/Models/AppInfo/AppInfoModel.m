//
//  AppInfoModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/24/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AppInfoModel.h"

@implementation AppInfoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"images.default": @"defaultImageUrl",
//                                                       @"images.selected": @"selectedImageUrl"
//                                                       }];
//}

@end
