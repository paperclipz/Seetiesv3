//
//  SeNearbyShopModel.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 09/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//


#import "Model.h"
#import "DraftModel.h"
#import "PriceModel.h"

@protocol ShopsModel
@end
@protocol SeetiShopNearbyShopPhotoModel
@end

@interface ShopsModel : Model
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* nearby_public_transport;
@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,strong)NSString* posts_count;
@property(nonatomic,strong)NSString* collections_count;
@property(nonatomic,strong)NSString* contact_number;
@property(nonatomic,strong)NSString* profile_photo;
@property(nonatomic,strong)Location* location;
@property(nonatomic,strong)PriceModel* price;
@property(nonatomic,strong)NSString* urlFacebook;
@property(nonatomic,strong)NSString* urlWebsite;
@property(nonatomic,strong)NSString* wallpaper;
@property(nonatomic,strong)NSString* recommended_information;
@property(nonatomic,strong)NSArray<SeetiShopNearbyShopPhotoModel>* arrPhotos;
@end

@interface SeNearbyShopModel : Model

@property(nonatomic,strong)NSArray<ShopsModel>* shops;
@property(nonatomic,assign)int offset;
@property(nonatomic,assign)int limit;
@property(nonatomic,assign)int total_shops;
@property(nonatomic,assign)int page;

-(void)process;

@end


@interface SeetiShopNearbyShopPhotoModel : JSONModel
@property(nonatomic,strong)NSString* imageURL;
@property(nonatomic,strong)UIImage* image;
-(id) copyWithZone: (NSZone *) zone;

@end