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
        
        @try {
            _newsFeedData = [[DraftModel alloc]initWithDictionary:_data error:nil];

        } @catch (NSException *exception) {
            
        }

    }
    return _newsFeedData;
}

-(NSArray<CollectionModel>*)arrCollections
{
    if (!_arrCollections) {
        
        NSMutableArray<CollectionModel>* arrTemp = [NSMutableArray<CollectionModel> new];

        
        @try {
            for (NSDictionary* key in _data)
            {
                CollectionModel* model = [[CollectionModel alloc]initWithDictionary:key error:nil];
                
                if (model) {
                    [arrTemp addObject:model];
                }
                
            }

        } @catch (NSException *exception) {
            
        }
        
        _arrCollections = [NSMutableArray<CollectionModel> arrayWithArray:arrTemp];
    }
    else{
        _arrCollections = [NSMutableArray<CollectionModel> new];

    }
    
    return _arrCollections;
}

-(NSArray<ProfileModel*>*)arrSuggestedFeature
{
    if (!_arrSuggestedFeature) {
        
        NSMutableArray* arrTemp = [NSMutableArray new];
        
        @try {
            for (NSDictionary* key in _data)
            {
                ProfileModel* model = [[ProfileModel alloc]initWithDictionary:key error:nil];
                
                if (model) {
                    [arrTemp addObject:model];
                }
                
            }
        } @catch (NSException *exception) {
            
        }
        
        _arrSuggestedFeature = [NSMutableArray arrayWithArray:arrTemp];

    }

    
    return _arrSuggestedFeature;
}


-(NSArray<DraftModel>*)arrPosts
{
    if (!_arrPosts) {
        
        NSMutableArray<DraftModel>* arrTemp = [NSMutableArray<DraftModel> new];
        
        @try {
            
            for (NSDictionary* key in _data)
            {
                DraftModel* model = [[DraftModel alloc]initWithDictionary:key error:nil];
                
                if (model) {
                    [arrTemp addObject:model];
                    
                }
                
            }

            
        } @catch (NSException *exception) {
            
        }
        _arrPosts = [NSMutableArray<DraftModel> arrayWithArray:arrTemp];
        
    }
    
    return _arrPosts;
}

-(CollectionModel*)followingCollectionData
{
    NSError* err = nil;
    if (!_followingCollectionData) {
        
        if (_data) {
            
            @try {
                _followingCollectionData = [[CollectionModel alloc]initWithDictionary:_data error:&err];

            } @catch (NSException *exception) {
                
            } 
        }
        
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

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            
        }
    }
    
    return self;
}

@end


@implementation NewsFeedModels

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];
        
    }
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            
        }
    }
    
    return self;
}
@end
