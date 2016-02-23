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
@interface CollectionModel()

@end

@implementation CollectionModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"collection_posts.posts": @"arrayPost",
                                                       @"new_collection_posts": @"arrayFollowingCollectionPost",
                                                       @"description": @"postDesc",
                                                       @"is_private": @"isPrivate",
                                                       @"tags":@"tagList",
                                                       @"collection_posts.total_page": @"total_page",
                                                       @"collection_posts.total_posts": @"total_posts",
                                                       @"collection_posts.page": @"page",
                                                       }];
}

-(NSMutableArray*)deleted_posts
{
    if (!_deleted_posts) {
        _deleted_posts = [NSMutableArray new];
    }
    return _deleted_posts;
}

-(void)process
{
    
    for (int i = 0; i<self.arrayPost.count; i++) {
        DraftModel* model = self.arrayPost[i];
        [model process];
        [model customProcess];
        
    }
    
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
    modelCopy.deleted_posts = [_deleted_posts mutableCopy];
    modelCopy.user_info = _user_info;
    return modelCopy;
}


@end

@interface CollectionsModel()
@property(nonatomic,strong)NSDictionary* paging;

@end
@implementation CollectionsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"result": @"arrCollections",
                                                       @"collections": @"arrSuggestedCollection",

                                                       }];
}

-(NSString*)next
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"next"]) {
            _next = _paging[@"next"];
        }
    }
    return _next;
    
}

-(NSString*)previous
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"previous"]) {
            _previous = _paging[@"previous"];
        }
    }
    return _previous;
}
@end
