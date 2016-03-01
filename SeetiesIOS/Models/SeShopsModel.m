//
//  SeShopsModel.m
//  SeetiesIOS
//
//  Created by Lup Meng Poo on 29/02/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "SeShopsModel.h"

@interface SeShopsModel()


@end
@implementation SeShopsModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"result" :@"shops"
                                                       }];
}


@end
