//
//  InviteFriendModel.m
//  Seeties
//
//  Created by Lup Meng Poo on 04/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "InviteFriendModel.h"

@implementation InviteFriendModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"desc"}];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
