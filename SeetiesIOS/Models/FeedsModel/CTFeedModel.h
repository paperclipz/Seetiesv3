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
    FeedType_Abroad_Quality_Post,
    FeedType_Announcement,
    FeedType_Announcement_Welcome,
    FeedType_Announcement_Campaign,
    FeedType_Suggestion_Featured,
    FeedType_Suggestion_Friend,
    FeedType_Deal,
    FeedType_Invite_Friend,
    FeedType_Country_Promotion,
    FeedType_Collect_Suggestion,
    FeedType_Following_Collection,
    
}FeedType;

#import "PaginationModel.h"
@protocol CTFeedModel @end
@protocol CTFeedTypeModel @end



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


@end

@interface CTFeedTypeModel : JSONModel
@property(nonatomic,assign)FeedType feedType;//non json attributes
@property(nonatomic,assign)FeedType tempType;//non json attributes

@property(nonatomic,strong)CTFeedModel* data;

@end

@interface NewsFeedModels : PaginationModel

@property(nonatomic,strong)NSArray<CTFeedTypeModel>* items;

@end
