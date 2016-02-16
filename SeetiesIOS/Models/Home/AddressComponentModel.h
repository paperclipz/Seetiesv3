//
//  AddressComponentModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressComponentModel : NSObject

@property(nonatomic)NSString* country;
@property(nonatomic)NSString* route;
@property(nonatomic)NSString* locality;
@property(nonatomic)NSString* administrative_area_level_1;
@property(nonatomic)NSString* political;

@end
