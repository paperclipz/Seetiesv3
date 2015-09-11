//
//  ExploreCountryModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"

@protocol ExploreCountryModel
@end

@interface ExploreCountryModel : JSONModel

@property (assign, nonatomic) int countryID;
@property (assign, nonatomic) int seqNo;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSDictionary* shortName;

@property (assign, nonatomic) NSString <Optional>*festivalUrl;
@property (assign, nonatomic) NSString <Optional>*festivalImage;
@property (strong, nonatomic) NSString* thumbnailA;

@property (strong, nonatomic) NSString* coverPhoto;
@property (strong, nonatomic) NSString* facebookPhoto;
@property (strong, nonatomic) NSString* explorePhoto;

@property (strong, nonatomic) NSString* name_en;
@end


@interface ExploreCountryModels : Model
@property (strong, nonatomic) NSArray<ExploreCountryModel>* countries;

@end