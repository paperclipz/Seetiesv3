//
//  HomeModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/3/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "HomeModel.h"

@interface HomeModel()
@property(nonatomic,strong)NSDictionary* featured_deals_cover;

@end
@implementation HomeModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"featured_deals_cover.title": @"featured_title",
//                                                       @"featured_deals_cover.image": @"featured_image",
//                                                       }];
//}

-(NSString*)featured_title
{
    if (_featured_deals_cover) {
        @try {
            _featured_title = _featured_deals_cover[@"title"];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    return _featured_title;
}

-(NSString*)featured_image
{
    if (_featured_deals_cover) {
        @try {
            _featured_image = _featured_deals_cover[@"image"];
        }
        @catch (NSException *exception) {
            
        }
    }
    
    return _featured_image;
}
@end
