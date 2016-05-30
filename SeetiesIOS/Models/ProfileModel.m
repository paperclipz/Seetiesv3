//
//  ProfileModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ProfileModel.h"
#import "DealManager.h"
#import "DealExpiryDateModel.h"


#define KEY_USER_PROFILE @"Current_User_Profile"

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

+(void)saveUserProfile:(ProfileModel*)model
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:KEY_USER_PROFILE];
    
    if (model) {
        
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:model];
        [defaults setObject:encodedObject forKey:KEY_USER_PROFILE];
        [defaults synchronize];
        
    }
    else{
        
        SLog(@"%@",model);
    }
    
}

+(ProfileModel*)getUserProfile
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData * data = [defaults objectForKey:KEY_USER_PROFILE];
    
    ProfileModel* model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return model;
}

+(int)getWalletCount
{
    if ([ConnectionManager isNetworkAvailable]) {
        return [[DealManager Instance]getWalletCount];
    }
    else{
        
        int count = 0;
        NSArray<DealExpiryDateModel *>* arrExpireData = [DealExpiryDateModel getWalletList];
        
        for (int i = 0; i<arrExpireData.count; i++)
        {
            DealExpiryDateModel* model = arrExpireData[i];
            count += model.dealModelArray.count;
            
        }
        
        return count;    }

}

// ======================================================= Profile Post Model  ======================================================//

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



