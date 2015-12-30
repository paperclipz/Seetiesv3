//
//  SeShopPhotoModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 12/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeShopPhotoModel.h"

@interface SeShopPhotoModel()
@property(nonatomic,strong)NSDictionary* paging;

@end
@implementation SePhotoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"m" :@"imageURL"
                                                       }];
}

@end

@implementation SeShopPhotoModel

-(NSString*)next
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"next"]) {
            _next = _paging[@"next"];
        }
    }
    return _next;
    
}

-(NSString*)previous
{
    if (_paging) {
        if ([[_paging allKeys]containsObject:@"previous"]) {
            _previous = _paging[@"previous"];
        }
    }
    return _previous;
}

@end
