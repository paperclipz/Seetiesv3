//
//  DealsModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 03/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "DealsModel.h"

@interface DealsModel()
@property(nonatomic, strong) NSArray<DealModel> *result;
@property(nonatomic, strong) NSArray<DealModel> *deals;

@end

@implementation DealsModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

-(NSArray<DealModel>*)arrDeals
{
    if (_result) {
        return _result;
    }
    else{
        return _deals;
    }
}

@end
