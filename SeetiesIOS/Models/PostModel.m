//
//  CollectionModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 9/22/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "PostModel.h"

//@implementation PostModel
//+(BOOL)propertyIsOptional:(NSString*)propertyName
//{
//    return YES;
//}
//
//@end

@implementation CollectionModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"collection_posts.posts": @"arrayPost",
                                                       @"description": @"postDesc",
                                                       @"is_private": @"isPrivate",
                                                       @"tags":@"tagList",
                                                       @"collection_posts.total_page": @"total_page",
                                                       @"collection_posts.total_posts": @"total_posts",
                                                       @"collection_posts.page": @"page"
                                                       }];
}

-(NSMutableArray*)deleted_posts
{
    if (!_deleted_posts) {
        _deleted_posts = [NSMutableArray new];
    }
    return _deleted_posts;
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
    modelCopy.deleted_posts = [[NSMutableArray alloc]initWithArray:_deleted_posts copyItems:YES];

    return modelCopy;
}


@end
@implementation CollectionsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"result": @"arrCollections"                                                       
                                                       }];
}
@end
