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
#import "UsersModel.h"
#import "DealsModel.h"
#import "TranslationModel.h"
#import "PostDetailModel.h"

@class FacebookModel;
@class  DraftsModel;
@class NewsFeedModels;
@class InstagramModel;
@class CountriesModel;
@class HomeModel;
@class NotificationModels;
@class AppInfoModel;
@class InstagramUser;
@class SuggestedPlaceModel;
@class FriendSuggestionModel;
@class DealCollectionModel;

typedef void(^BoolBlock) (BOOL isCollected);
typedef void(^CompletionVoidBlock) (void);

@interface DataManager : NSObject
+ (id)Instance;
+(NSArray*)getSampleObject;

/*Login*/
@property(nonatomic,strong)InstagramUser* instagramUserModel;//model from login


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
@property(nonatomic,strong)DraftModel* postDetailModel;
@property(nonatomic,strong)TranslationModel* translationModel;

@property(nonatomic,strong)TagModel* tagModel;

// /  ============== model from proifle page. has additional follow and following usage: for all profiles include me and others ================= ///
@property(nonatomic,strong)ProfileModel* userProfileModel;
// /  ================================== model for "ME" from proifle page. has additional follow and following ===================================== ///
@property(nonatomic,strong)ProfileModel* currentUserProfileModel;//

@property(nonatomic,strong)CollectionsModel* postCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userFollowingCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userSuggestedCollectionsModel;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)ProfilePostModel* userProfileLikeModel;
@property(nonatomic,strong)SeShopPhotoModel* seShopPhotoModel;
@property(nonatomic,strong)SeShopDetailModel* seShopDetailModel;
@property(nonatomic,strong)SeShopsModel* seNearbyShopModel;
@property(nonatomic,strong)SeShopsModel* seShopListingModel;
@property(nonatomic,strong)UsersModel* usersModel;
@property(nonatomic,strong)DealsModel* dealsModel;
@property(nonatomic,strong)DealModel* dealModel;
@property(nonatomic,strong)SuggestedPlaceModel* suggestedPlaceModel;
@property(nonatomic,strong)FriendSuggestionModel* friendSuggestionModel;
/* ================================ News Feed ================================ */

@property(nonatomic,strong)NewsFeedModels* newsFeedModels;
@property(nonatomic,strong)CountriesModel* countriesModel;
@property(nonatomic,strong)HomeModel* homeModel;
@property(nonatomic,strong)NotificationModels* notificationModels;
@property(nonatomic,strong)NotificationModels* followingNotificationModels;
@property(nonatomic,strong)AppInfoModel* appInfoModel;


/* ================================ Notification ================================ */
@property(nonatomic,strong)DealCollectionModel* dealCollectionModel;

/* ============================== Post Detail ============================ */

@property(nonatomic,strong)PostDetailLikeModel *postDetailLikeModel;
@property(nonatomic,strong)PostDetailCommentModel *postDetailCommentModel;

+(RecommendationModel*)getSampleRecommendation;
+(EditPhotoModel*)getSampleEditPhotoModel;
+(void)getCollectionFollowing:(NSString*)collectionID HasCollected:(BoolBlock)isCollected completion:(CompletionVoidBlock)completionBlock;//get collection is collected to show in view
+(void)setCollectionFollowing:(NSString*)collectionID isFollowing:(BOOL)following;//to set collection is collected and store after request from server
+(BOOL)isCollectionFollowed:(NSString*)collectionID isFollowing:(BOOL)isFollowing;//to check collection is collected to request from server

/*likes*/
+(void)setPostLikes:(NSString*)postID isLiked:(BOOL)liked;
+(void)getPostLikes:(NSString*)postID isLiked:(BoolBlock)isLikedBlock NotLikeBlock:(CompletionVoidBlock)notCollectedBlock;
+(void)getPostCollected:(NSString*)postID isCollected:(BoolBlock)isCollectedBlock PostNotCollectedBlock:(CompletionVoidBlock)notCollectedBlock;
+(void)setPostsCollected:(NSString*)postID isPostCollected:(BOOL)collected;

+(BOOL)isUserFollowed:(NSString*)UserID isFollowing:(BOOL)isFollowing;

+(void)setUserFollowing:(NSString*)UserID isFollowing:(BOOL)following;
-(ProfileModel*)getCurrentUserProfileModel;

@end
