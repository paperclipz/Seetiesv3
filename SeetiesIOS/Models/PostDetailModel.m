//
//  PostDetailModel.m
//  Seeties
//
//  Created by Lai on 30/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PostDetailModel.h"

@implementation PostDetailModel

@end

@implementation PostDetailLikeModel

@end

@implementation LikeDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"description": @"desc"}];
}

@end

@implementation PostDetailCommentModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation CommentDetailModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation NearbyRecommendationModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{ @"data": @"recommendationPosts" }];
}

@end

@implementation NearbyRecommendationDetailModel

@end



