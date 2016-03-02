//
//  SeShopsModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeShopsModel.h"

@interface SeShopsModel()
@property(nonatomic,strong)NSArray<SeShopDetailModel>* result;


@end
@implementation SeShopsModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"shops": @"shops",
//                                                       @"result" :@"shops"
//                                                       
//                                                       }];
//}


-(NSArray<SeShopDetailModel>*)shops
{
    if (!_shops) {
        return _result;
    }
    else{
        return _shops;
    }
    
}

@end
