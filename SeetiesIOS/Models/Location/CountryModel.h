//
//  CountryModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/1/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "PlacesModel.h"
#import "FilterCurrencyModel.h"
#import "InviteFriendModel.h"

@protocol PlacesModel
@end
@protocol FilterCurrencyModel
@end
@protocol InviteFriendModel
@end

@interface CountryModel : PaginationModel

@property(nonatomic,strong)NSString* status;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,assign)int country_id;
@property(nonatomic,strong)NSMutableArray* arrArea;
@property(nonatomic,strong)NSMutableArray* arrCountryName;
@property(nonatomic,strong)NSString* phone_country_code;
@property(nonatomic,strong)NSArray* place_display_fields;
@property(nonatomic,assign)BOOL has_featured_deals;
@property(nonatomic,strong)NSString* country_code;
@property(nonatomic,assign)BOOL home_filter_display;//check whether display on screen
@property(nonatomic,strong)FilterCurrencyModel *filter_currency;
@property(nonatomic,strong)InviteFriendModel *invite_friend_banner;
-(NSString*)formattedCountryDisplay;
-(NSString*)shortCountryCode;

@end
