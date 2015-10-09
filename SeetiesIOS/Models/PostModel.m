//
//  CollectionModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation CollectionModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"posts.data": @"arrayPost",
                                                       @"description": @"postDesc",
                                                       @"is_private": @"isPrivate",
                                                       @"tags":@"tagList",
                                                       @"posts.total_page": @"total_page",
                                                       @"posts.total_posts": @"total_posts",
                                                       @"posts.page": @"page"
                                                       }];
}


-(id) copyWithZone: (NSZone *) zone
{
    CollectionModel *modelCopy = [[CollectionModel allocWithZone: zone] init];
    modelCopy.name = [_name mutableCopy];
    modelCopy.postDesc = [_postDesc mutableCopy];
    modelCopy.collection_id = [_collection_id mutableCopy];
    modelCopy.isPrivate = _isPrivate;
    modelCopy.is_default = _is_default;


    modelCopy.tagList = [[NSMutableArray alloc]initWithArray:_tagList copyItems:YES];
    
    return modelCopy;
}

@end
