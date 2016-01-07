//
//  NewsFeedModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/4/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NewsFeedModel.h"

@interface NewsFeedModel()

@property(nonatomic,strong)NSString* type;

@end
@implementation NewsFeedModel


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data.location": @"location",
                                                       @"data.place_name": @"place_name",
                                                       @"data.place_formatted_address": @"place_formatted_address",
                                                       @"data.seetishop_id": @"seetishop_id",
                                                       @"data.collection_count": @"collection_count",
                                                       @"data.total_comments": @"total_comments",
                                                       @"data.like": @"like",
                                                       @"data.user_info": @"user_info",
                                                       @"data.type": @"type",

                                                       }];
}

-(FeedType)feedType
{
    
    SWITCH (_type) {
        
        CASE (@"following_post"){
            _feedType = FeedType_Following_Post;
            break;
        }
        CASE (@"local_quality_post"){
            _feedType = FeedType_Local_Quality_Post;
            break;
        }
        
        CASE (@"abroad_quality_post"){
            _feedType = FeedType_Abroad_Quality_Post;
            break;
        }
        CASE (@"announcement"){
            _feedType = FeedType_Announcement;
            break;
        }
        
        CASE (@"announcement_welcome"){
            _feedType = FeedType_Announcement_Welcome;
            break;
        }
        
        CASE (@"announcement_campaign"){
            _feedType = FeedType_Announcement_Campaign;
            break;
        }
        CASE (@"follow_suggestion_featured"){
            _feedType = FeedType_Suggestion_Featured;
            break;
        }
        
        CASE (@"follow_suggestion_friend"){
            _feedType = FeedType_Suggestion_Friend;
            break;
        }
        
        CASE (@"deal"){
            _feedType = FeedType_Deal;
            break;
        }
        
        CASE (@"invite_friend"){
            _feedType = FeedType_Invite_Friend;
            break;
        }
        CASE (@"country_promotion"){
            _feedType = FeedType_Country_Promotion;
            break;
        }
        CASE (@"collect_suggestion"){
            _feedType = FeedType_Collect_Suggestion;
            break;
        }
        CASE (@"following_collection"){
            _feedType = FeedType_Following_Collection;
            break;
        }
        DEFAULT
        {
            _feedType = FeedType_Following_Post;
            break;
            
        }
        
    }
    
    
    
    return _feedType;
}
@end


@implementation NewsFeedModels

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


@end
