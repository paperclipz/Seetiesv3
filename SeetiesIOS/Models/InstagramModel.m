//
//  InstagramModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/27/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "InstagramModel.h"

@implementation InstagramModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"user.username" : @"username",
                                                       @"user.profile_picture" : @"profile_picture",
                                                       @"user.full_name" : @"full_name",
                                                       @"user.id" : @"userID",
                                                       }];
}
@end
