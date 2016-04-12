//
//  HomeLocationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressComponentModel.h"

#define Type_Search @"search"
#define Type_Featured @"featured"
#define Type_Current @"current"

@interface HomeLocationModel : JSONModel

@property(nonatomic,strong)NSString* timezone;
@property(nonatomic,strong)NSString* type;//1 : Search || 2: Current || 3 : Featured
@property(nonatomic,strong)NSString* latitude;
@property(nonatomic,strong)NSString* longtitude;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)AddressComponentModel* address_components;
@property(nonatomic,strong)NSString<Ignore>* locationName;
@property(nonatomic,strong)NSDictionary* dictAddressComponent;
@property(nonatomic,strong)NSString* stringAddressComponent;
@property(nonatomic,assign)int countryId;  //current selected country id

/*server properties*/

@end
