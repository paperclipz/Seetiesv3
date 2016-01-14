//
//  DataManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/6/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiVersionModel.h"
#import "LanguageModel.h"
#import "ExploreCountryModel.h"
#import "SearchModel.h"
#import "EditPhotoModel.h"
#import "FourSquareModel.h"

#import "CategoriesModel.h"
#import "PostModel.h"
#import "RecommendationModel.h"
#import "TagModel.h"
#import "ProfileModel.h"
#import "SeShopDetailModel.h"
#import "SeShopPhotoModel.h"
#import "FacebookModel.h"

@class FacebookModel;
@class  DraftsModel;
@class NewsFeedModels;
typedef void(^BoolBlock) (BOOL isCollected);
typedef void(^CompletionVoidBlock) (void);

@interface DataManager : NSObject
+ (id)Instance;
+(NSArray*)getSampleObject;


@property(nonatomic,strong)ProfileModel* userLoginProfileModel;//model from login

@property(nonatomic,strong)ApiVersionModel* apiVersionModel;
@property(nonatomic,strong)FacebookModel* facebookLoginModel;

@property(nonatomic,strong)LanguageModels* languageModels;
@property(nonatomic,strong)ExploreCountryModels* exploreCountryModels;
@property(nonatomic,strong)FourSquareModel* fourSquareVenueModel;
@property(nonatomic,strong)SearchModel* googleSearchModel;
@property(nonatomic,strong)SearchLocationDetailModel* googleSearchDetailModel;

@property(nonatomic,strong)DraftsModel* draftsModel;
@property(nonatomic,strong)CategoriesModel* categoriesModel;
@property(nonatomic,strong)CollectionModel* collectionModels;
@property(nonatomic,strong)DraftModel* editPostModel;
@property(nonatomic,strong)DraftModel* savedDraftModel;


@property(nonatomic,strong)TagModel* tagModel;
@property(nonatomic,strong)ProfileModel* userProfileModel;//model from proifle page. has additional follow and following
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userFollowingCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userSuggestedCollectionsModel;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)ProfilePostModel* userProfileLikeModel;
@property(nonatomic,strong)SeShopPhotoModel* seShopPhotoModel;
@property(nonatomic,strong)SeShopDetailModel* seShopDetailModel;
@property(nonatomic,strong)SeetiShopsModel* seNearbyShopModel;
@property(nonatomic,strong)SeetiShopsModel* seNearbyShopListingModel;


/* ================================ News Feed ================================ */

@property(nonatomic,strong)NewsFeedModels* newsFeedModels;


+(RecommendationModel*)getSampleRecommendation;
+(EditPhotoModel*)getSampleEditPhotoModel;
+(void)getCollectionFollowing:(NSString*)collectionID HasCollected:(BoolBlock)isCollected completion:(CompletionVoidBlock)completionBlock;//get collection is collected to show in view
+(void)setCollectionFollowing:(NSString*)collectionID isFollowing:(BOOL)following;//to set collection is collected and store after request from server
+(BOOL)isCollectionFollowed:(NSString*)collectionID isFollowing:(BOOL)isFollowing;//to check collection is collected to request from server

/*likes*/
+(void)setPostLikes:(NSString*)postID isLiked:(BOOL)liked;
+(void)getPostLikes:(NSString*)postID isLiked:(BoolBlock)isLikedBlock NotLikeBlock:(CompletionVoidBlock)notCollectedBlock;

@end
