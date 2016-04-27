//
//  ExpiryDateModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 25/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealExpiryDateModel.h"

@implementation DealExpiryDateModel

-(BOOL)isEqual:(id)object{
    if (object == nil) {
        return NO;
    }
    if (![object isKindOfClass:DealExpiryDateModel.class]) {
        return NO;
    }
    
    DealExpiryDateModel *otherExpiryModel = (DealExpiryDateModel*)object;
    return [otherExpiryModel.expiryDate isEqualToString:self.expiryDate]? YES : NO;
}

-(NSUInteger)hash{
    return self.expiryDate.hash;
}

@end
