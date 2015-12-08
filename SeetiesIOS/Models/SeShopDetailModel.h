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

@class DraftModel;

@interface SeShopDetailModel : Model

@property(nonatomic,strong)NSString* seetishop_id;
@property(nonatomic,strong)NSString* recommended_information;//best know for
@property(nonatomic,strong)NSString* contact_number;
@property(nonatomic,strong)NSString* urlFacebook;
@property(nonatomic,strong)NSString* urlWebsite;
@property(nonatomic,strong)Location* location;

@property(nonatomic,strong)PriceModel* price;

@property(nonatomic,readonly)NSArray* arrayInformation;
-(void)process;

@end
