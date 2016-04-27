//
//  CTFeedModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CTFeedModel.h"

@interface CTFeedTypeModel()
@property(nonatomic,strong)NSDictionary* data;
@property(nonatomic,strong)NSString* type;
@end

@implementation CTFeedTypeModel


-(DraftModel*)newsFeedData
{
    
    if (!_newsFeedData) {
        _newsFeedData = [[DraftModel alloc]initWithDictionary:_data error:nil];

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
            ProfileModel* model = [[ProfileModel alloc]initWithDictionary:key error:nil];
            
            [arrTemp addObject:model];
            
        }
        
        _arrSuggestedFeature = [NSMutableArray arrayWithArray:arrTemp];

    }

    
    return _arrSuggestedFeature;
}


-(NSArray<DraftModel>*)arrPosts
{
    if (!_arrPosts) {
        
        NSMutableArray* arrTemp = [NSMutableArray new];
        for (NSDictionary* key in _data)
        {
            DraftModel* model = [[DraftModel alloc]initWithDictionary:key error:nil];
            
            [arrTemp addObject:model];
            
        }
        
        _arrPosts = [NSMutableArray arrayWithArray:arrTemp];
        
    }
    
    return _arrPosts;
}

-(CollectionModel*)followingCollectionData
{
    NSError* err = nil;
    if (!_followingCollectionData) {
        _followingCollectionData = [[CollectionModel alloc]initWithDictionary:_data error:&err];
        
        SLog(@"%@",err);
    }
    
    return _followingCollectionData;
}

-(NSDictionary*)dictData
{
    if (!_dictData) {
        _dictData = _data;
    }
    
    return _dictData;
}

-(AnnouncementModel*)announcementData
{
    if (!_announcementData) {
        _announcementData = [[AnnouncementModel alloc]initWithDictionary:_data error:nil];;
    }
    return _announcementData;
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
        
//        CASE (@"deal"){
//            _feedType = FeedType_Deal;
//            break;
//        }
        
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
