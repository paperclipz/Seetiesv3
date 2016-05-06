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


- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    
    for (NSString *key in [self codableProperties])
    {
        
        [encoder encodeObject:[self valueForKey:key] forKey:key];
        
    }
    
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        
        for (NSString *key in [self codableProperties])
        {
            [self setValue:[decoder decodeObjectForKey:key] forKey:key];
            
        }
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] alloc] init];
    for (NSString *key in [self codableProperties])
    {
        [copy setValue:[self valueForKey:key] forKey:key];
    }
    return copy;
    
}

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



