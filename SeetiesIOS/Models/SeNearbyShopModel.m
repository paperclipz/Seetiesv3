//
//  SeNearbyShopModel.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 09/12/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "SeNearbyShopModel.h"

@implementation SeNearbyShopModel
-(void)process
{
    
    for (int i = 0; i<self.shops.count; i++) {
        ShopsModel* model = self.shops[i];
    }
    
}
@end

@implementation ShopsModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"facebook" :@"urlFacebook",
                                                       @"wallpapers": @"arrPhotos",
                                                       @"website" : @"urlWebsite"
                                                       }];
}


@end

@implementation SeetiShopNearbyShopPhotoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"m" :@"imageURL"
                                                       }];
}


-(id) copyWithZone: (NSZone *) zone
{
    PhotoModel *modelCopy = [[PhotoModel allocWithZone: zone] init];
    modelCopy.imageURL = [_imageURL mutableCopy];
    modelCopy.image = _image;
    
    return modelCopy;
    
}

@end