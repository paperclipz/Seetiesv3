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


+(RecommendationModel*)getSampleRecommendation;
+(EditPhotoModel*)getSampleEditPhotoModel;

@end
