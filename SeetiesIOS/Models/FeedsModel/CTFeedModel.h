//
//  CTFeedModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "Model.h"

//@class Location;
//@class ProfileModel;
//@class PhotoModel;

typedef enum
{
    FeedType_Following_Post = 1,
    FeedType_Local_Quality_Post = 2,
    FeedType_Abroad_Quality_Post = 3,
    FeedType_Announcement = 4,
    FeedType_Announcement_Welcome = 5,
    FeedType_Announcement_Campaign = 6,
    FeedType_Suggestion_Featured = 7,
    FeedType_Suggestion_Friend = 8,
    FeedType_Deal = 9,
    FeedType_Invite_Friend = 10,
    FeedType_Country_Promotion = 11,
    FeedType_Collect_Suggestion = 12,
    FeedType_Following_Collection = 13,
    
}FeedType;

#import "PaginationModel.h"
@protocol CTFeedModel @end
@protocol CTFeedTypeModel @end
@protocol CTFeedCollectionModel @end


@interface CTFeedModel : JSONModel

@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSString* place_name;
@property(nonatomic,strong)NSString* place_formatted_address;
@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,assign)int collection_count;
@property(nonatomic,assign)int total_comments;
@property(nonatomic,assign)BOOL like;
@property(nonatomic,strong)ProfileModel* user_info;
@property(nonatomic,strong)NSArray<PhotoModel>* photos;
@property(nonatomic,strong)NSString* image;
@property(nonatomic,strong)NSString* postDescription;
@property(nonatomic,strong)NSString* post_id;

@end

@interface CTFeedCollectionModel : JSONModel

@property(nonatomic,strong)NSArray<CollectionModel>* arrCollection;

@end

@interface CTFeedTypeModel : JSONModel
@property(nonatomic,assign)FeedType feedType;//non json attributes
@property(nonatomic,assign)FeedType tempType;//non json attributes

@property(nonatomic,strong)CTFeedModel<Ignore>* newsFeedData;
@property(nonatomic,strong)NSArray<CollectionModel>* arrCollections;
@property(nonatomic,strong)NSArray<ProfileModel *>* arrSuggestedFeature;

//@property(nonatomic,strong)NSArray<CollectionModel>* arrCollection;

@end



@interface NewsFeedModels : PaginationModel

@property(nonatomic,strong)NSArray<CTFeedTypeModel>* items;


@end
