//
//  TagLocationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 3/9/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TagLocationModel : JSONModel


@property(nonatomic,strong)NSString* formatted_address;
@property(nonatomic,strong)NSString* lng;
@property(nonatomic,strong)NSString* lat;
@property(nonatomic,strong)NSString* address_components;

@end
