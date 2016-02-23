//
//  ProfileModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileModel.h"


@interface ProfileModel()
@property(nonatomic,strong)NSString* user_id;

@end
@implementation ProfileModel

-(NSString*)uid
{
    if (![Utils isStringNull:_uid]) {
        return _uid;
    }
    else
    {
        return _user_id;
    }
}

-(NSString*)getGender
{
    if ([_gender isEqualToString:@"m"]) {
        return @"Male";
    }
    else{
        return @"Female";
    }
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"profileDescription",
                                                       @"wallpaper.l": @"wallpaper",
                                                       @"profile_photo_images.s": @"profile_photo_images"
                                                       }];
}


@end

@implementation ProfilePostModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"userPostData"
                                                       
                                                       }];
}

@end

@implementation SeetiShopsModel
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"userPostData"
                                                       
                                                       }];
}

@end


