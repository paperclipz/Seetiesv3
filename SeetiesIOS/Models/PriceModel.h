//
//  PriceModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 12/7/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface PriceModel : JSONModel

@property(nonatomic,strong)NSString* value;
@property(nonatomic,strong)NSString* code;
@property(nonatomic,strong)NSString* payment;

@end
