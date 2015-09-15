//
//  ExploreCountryModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 8/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "Model.h"


@protocol FestivalModel
@end

@protocol ExploreCountryModel
@end


@interface FestivalModel : JSONModel
@property (assign, nonatomic) NSString <Optional>*thumbnail;
@property (assign, nonatomic) NSString <Optional>*url;
@end

@interface ExploreCountryModel : JSONModel

@property (assign, nonatomic) int countryID;
@property (assign, nonatomic) int seqNo;
@property (strong, nonatomic) NSString* name;
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSDictionary* shortName;

@property (strong, nonatomic) NSString* thumbnail;
@property (strong, nonatomic) FestivalModel<Optional>* festival;
@property (strong, nonatomic) NSString<Optional>* coverPhoto;
@property (strong, nonatomic) NSString<Optional>* facebookPhoto;
@property (strong, nonatomic) NSString<Optional>* explorePhoto;
@property (strong, nonatomic) NSString<Optional>* name_en;
@end


@interface ExploreCountryModels : Model
@property (strong, nonatomic) NSArray<ExploreCountryModel>* countries;

@end