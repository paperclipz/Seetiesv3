//
//  GreetingModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 3/15/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "GreetingModel.h"

@implementation GreetingModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"image.selected_background": @"backgroundImage",
//                                                       @"image.logo": @"logoImage",
//                                                       }];
//}
@end
