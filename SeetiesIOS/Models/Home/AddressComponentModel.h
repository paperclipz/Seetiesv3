//
//  AddressComponentModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressComponentModel : NSObject

@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSString* route;
@property(nonatomic,strong)NSString* locality;
@property(nonatomic,strong)NSString* administrative_area_level_1;
@property(nonatomic,strong)NSString* political;

@end
