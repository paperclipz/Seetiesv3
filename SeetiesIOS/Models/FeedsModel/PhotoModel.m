//
//  PhotoModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/8/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"s.url" :@"imageURL",
                                                       @"s.resolution.w":@"imageWidth",
                                                       @"s.resolution.h":@"imageHeight"
                                                       
                                                       }];
}


-(id) copyWithZone: (NSZone *) zone
{
    PhotoModel *modelCopy = [[PhotoModel allocWithZone: zone] init];
    modelCopy.tags = [_tags mutableCopy];
    modelCopy.photo_id = [_photo_id mutableCopy];
    modelCopy.caption = [_caption mutableCopy];
    modelCopy.position = _position;
    modelCopy.imageURL = [_imageURL mutableCopy];
    modelCopy.image = _image;
    
    return modelCopy;
    
}

@end
