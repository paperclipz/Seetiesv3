//
//  SeShopDetailModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/4/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "DraftModel.h"
#import "PriceModel.h"
#import "OpeningPeriodModel.h"
#import "SeShopCategoryModel.h"
#import "Location.h"

@class DraftModel;

@interface SeShopDetailModel : Model
@property(nonatomic,strong)NSString* name;

@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,strong)NSString* shopId;
@property(nonatomic,strong)NSString* recommended_information;//best know for
@property(nonatomic,strong)NSArray* contact_number;
@property(nonatomic,strong)NSString* urlFacebook;
@property(nonatomic,strong)NSString* urlWebsite;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSString* nearby_public_transport;
@property(nonatomic,strong)PriceModel* price;
@property(nonatomic,strong)NSArray* arrFeatureAvaiable;
@property(nonatomic,strong)NSArray* arrFeatureUnavaiable;

@property(nonatomic,readonly)NSArray* arrayInformation;
@property(nonatomic,strong)SeShopCategoryModel* category;
@property(nonatomic,strong)NSArray* wallpapers;
@property(nonatomic,strong)NSDictionary* profile_photo_images;
@property(nonatomic,strong)NSString* language;

-(void)process;

@end
