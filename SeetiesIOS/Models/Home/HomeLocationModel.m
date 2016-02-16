//
//  HomeLocationModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/5/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "HomeLocationModel.h"

@implementation HomeLocationModel


-(AddressComponentModel*)address_components
{
    if (!_address_components) {
        _address_components = [AddressComponentModel new];
    }
    
    return _address_components;
}

@end
