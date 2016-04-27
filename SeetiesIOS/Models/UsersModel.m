//
//  UsersModel.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 21/01/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UsersModel.h"

@implementation UsersModel

@end

@implementation UserModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"userDesc",
                                                       @"uid":@"userUID"
                                                       }];
}

@end
