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

@protocol SePhotoModel

@end
@protocol DealModel

@end
@class DraftModel;
@class SeShopGroupModel;

@interface SeShopDetailModel : Model
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,strong)NSString* recommended_information;//best know for
@property(nonatomic,strong)NSArray* contact_number;
@property(nonatomic,strong)NSString* urlFacebook;
@property(nonatomic,strong)NSString* urlWebsite;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)NSString* nearby_public_transport;
@property(nonatomic,strong)PriceModel* price;
@property(nonatomic,strong)NSArray* arrFeatureAvaiable;
@property(nonatomic,strong)NSArray* arrFeatureUnavaiable;
@property(nonatomic,assign)int total_available_vouchers;

@property(nonatomic,readonly)NSArray* arrayInformation;
@property(nonatomic,strong)SeShopCategoryModel* category;
@property(nonatomic,strong)NSArray* wallpapers;
@property(nonatomic,strong)NSDictionary* profile_photo_images;
@property(nonatomic,strong)NSString* language;
@property(nonatomic,strong)NSArray<DealModel>* deals;

/*for notification purposes*/
@property(nonatomic,strong)NSString* post_id;
@property(nonatomic,strong)NSString* place_id;
/*for notification purposes*/

/*seetiesshop group info*/
@property(nonatomic,strong)NSDictionary* profile_photo;
@property(nonatomic,strong)SeShopGroupModel* shop_group_info;

/*seetiesshop group info*/

@property(nonatomic,strong)NSString* posts_count;
@property(nonatomic,strong)NSString* collections_count;
@property(nonatomic,strong)NSString* wallpaper;
@property(nonatomic,strong)NSArray<SePhotoModel>* arrPhotos;
@property(nonatomic,assign)BOOL is_collaborate;


-(void)process;

@end
