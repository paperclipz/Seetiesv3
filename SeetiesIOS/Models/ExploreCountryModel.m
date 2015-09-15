//
//  ExploreCountryModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 8/10/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "ExploreCountryModel.h"


@implementation FestivalModel



@end
@implementation ExploreCountryModel


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"country_id": @"countryID",
                                                       @"seq_no": @"seqNo",
                                                       @"short_name": @"shortName",
                                                       @"photos.cover": @"coverPhoto",
                                                       @"photos.fb": @"facebookPhoto",
                                                       @"photos.explore": @"explorePhoto"
                                                
                                                       
                                                       }];
}

@end

@implementation ExploreCountryModels

@end