//
//  SeNearbyShopModel.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 09/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeNearbyShopModel.h"

@implementation ShopsModel

@end

@implementation ShopModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"facebook" :@"urlFacebook",
                                                       @"wallpapers": @"arrPhotos",
                                                       @"website" : @"urlWebsite",
                                                       @"profile_photo.picture": @"profile_photo"
                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

