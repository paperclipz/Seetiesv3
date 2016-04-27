//
//  FriendSuggestionModel.m
//  SeetiesIOS
//
//  Created by Lai on 13/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FriendSuggestionModel.h"

@implementation FriendSuggestionModel

@end

@implementation FriendSuggestionDetailModel

+(JSONKeyMapper *)keyMapper{
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"desc"}];
    
}

@end
