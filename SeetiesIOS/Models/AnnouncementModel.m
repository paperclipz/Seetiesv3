//
//  AnnouncementModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/18/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "AnnouncementModel.h"
@interface AnnouncementModel()
@property(nonatomic,strong)NSString* type;//user post N/A url
@end
@implementation AnnouncementModel

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

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"desc",
                                                       @"related.photo" : @"photo",
                                                       @"related.username" :@"userName",
                                                       @"related.id" :@"relatedID",
                                                       @"related.type" :@"type"

                                                       }];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}


-(AnnouncementType)annType
{
    SWITCH (_type) {
        
        CASE (@"user"){
            return AnnouncementType_User;
            break;
        }
        CASE (@"url"){
            return AnnouncementType_URL;
            break;
        }
        
        CASE (@"post"){
            return AnnouncementType_Post;
            break;
        }
        
        CASE(@"promo_code")
        {
            return AnnouncementType_Promo;
        }
  
        DEFAULT
        {
            return AnnouncementType_NA;
            break;
            
        }
    }

}
@end
