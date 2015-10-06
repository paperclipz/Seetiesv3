//
//  RecommendationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/28/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecommendationVenueModel.h"

@interface RecommendationModel : NSObject

@property(nonatomic,strong)NSString* postMainTitle;
@property(nonatomic,strong)NSString* postMainDescription;
@property(nonatomic,strong)NSString* postSecondTitle;
@property(nonatomic,strong)NSString* postSecondDescription;
@property(nonatomic,strong)NSString* postURL;
@property(nonatomic,strong)NSString* price;
@property(nonatomic,strong)NSString* post_id;
@property(nonatomic,strong)NSString* postMainLanguage;
@property(nonatomic,strong)NSString* postSeconLanguage;
@property(nonatomic,strong)NSArray* selectedCategories;


@property(nonatomic,strong)NSMutableArray* arrDeletedImages;

@property(nonatomic,strong)NSMutableArray* arrPostImagesList;//photoModel
@property(nonatomic,strong)RecommendationVenueModel* reccomendVenueModel;


-(id)initWithDraftModel:(DraftModel*)model;
-(id) copyWithZone: (NSZone *) zone;

@end
