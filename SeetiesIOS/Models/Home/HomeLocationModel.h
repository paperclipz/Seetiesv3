//
//  HomeLocationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressComponentModel.h"

@interface HomeLocationModel : JSONModel

@property(nonatomic,strong)NSString* timezone;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSString* latitude;
@property(nonatomic,strong)NSString* longtitude;
@property(nonatomic,strong)NSString* place_id;
@property(nonatomic,strong)AddressComponentModel* address_components;


/*server properties*/

@end
