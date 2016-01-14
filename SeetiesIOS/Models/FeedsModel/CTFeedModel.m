//
//  CTFeedModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CTFeedModel.h"

@implementation CTFeedModel


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"postDescription",

                                                       }];
}

@end

@implementation CTFeedCollectionModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"arrCollection",
                                                       
                                                       }];
}


@end
@interface CTFeedTypeModel()
@property(nonatomic,strong)NSDictionary* data;
@property(nonatomic,strong)NSString* type;
@end

@implementation CTFeedTypeModel


-(CTFeedModel*)newsFeedData
{
    
    if (!_newsFeedData) {
        _newsFeedData = [[CTFeedModel alloc]initWithDictionary:_data error:nil];

    }
    return _newsFeedData;
}

-(NSArray<CollectionModel>*)arrCollections
{
    if (!_arrCollections) {
        
        NSMutableArray* arrTemp = [NSMutableArray new];

        for (NSDictionary* key in _data)
        {
            CollectionModel* model = [[CollectionModel alloc]initWithDictionary:key error:nil];
            
            [arrTemp addObject:model];
        
        }
        
        _arrCollections = [NSMutableArray arrayWithArray:arrTemp];
    }
    
    return _arrCollections;
}

-(NSArray<ProfileModel*>*)arrSuggestedFeature
{
    if (!_arrSuggestedFeature) {
        
        NSMutableArray* arrTemp = [NSMutableArray new];
        for (NSDictionary* key in _data)
        {
            CollectionModel* model = [[CollectionModel alloc]initWithDictionary:key error:nil];
            
            [arrTemp addObject:model];
            
        }
        
        _arrSuggestedFeature = [NSMutableArray arrayWithArray:arrTemp];

    }

    
    return _arrSuggestedFeature;
}


+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
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
