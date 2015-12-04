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
#import "DraftModel.h"
#import "CategoriesModel.h"
#import "PostModel.h"

#import "RecommendationModel.h"

#import "TagModel.h"
#import "ProfileModel.h"
#import "SeShopDetailModel.h"


typedef void(^BoolBlock) (BOOL isCollected);
typedef void(^CompletionVoidBlock) (void);

@interface DataManager : NSObject
+ (id)Instance;
+(NSArray*)getSampleObject;

@property(nonatomic,strong)ApiVersionModel* apiVersionModel;
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
@property(nonatomic,strong)ProfileModel* userProfileModel;
@property(nonatomic,strong)CollectionsModel* userCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userFollowingCollectionsModel;
@property(nonatomic,strong)CollectionsModel* userSuggestedCollectionsModel;
@property(nonatomic,strong)ProfilePostModel* userProfilePostModel;
@property(nonatomic,strong)ProfilePostModel* userProfileLikeModel;
@property(nonatomic,strong)SeShopDetailModel* seShopDetailModel;



+(RecommendationModel*)getSampleRecommendation;
+(EditPhotoModel*)getSampleEditPhotoModel;
+(void)getCollectionFollowing:(NSString*)collectionID HasCollected:(BoolBlock)isCollected completion:(CompletionVoidBlock)completionBlock;
+(void)setCollectionFollowing:(NSString*)collectionID isFollowing:(BOOL)following;

@end
