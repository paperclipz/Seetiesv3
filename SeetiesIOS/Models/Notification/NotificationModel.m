//
//  NotificationModel.m
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "NotificationModel.h"

@interface NotificationModel()
@property(nonatomic,strong)NSArray* tempUserProfile;
@property(nonatomic,strong)NSString* type;
@property(nonatomic,strong)NSDictionary* user;


@end

@implementation NotificationModel


-(NotificationType)notType{
    
    
    SWITCH (_type) {
        
        CASE (@"follow"){
            _notType = NotificationType_Follow;
            break;
            
        }
        CASE (@"like"){
            _notType = NotificationType_Like;
            break;
            
        }
        CASE (@"mention"){
            _notType = NotificationType_Mention;
            break;
            
        }
        CASE (@"comment"){
            _notType = NotificationType_Comment;
            break;
            
        }
        CASE (@"collect"){
            _notType = NotificationType_Collect;
            break;
        }
        CASE (@"post_shared"){
            _notType = NotificationType_PostShared;
            break;
            
        }
        CASE (@"collection_shared"){
            _notType = NotificationType_CollectionShared;
            break;
            
        }
        
        CASE (@"collection_follow"){
            _notType = NotificationType_CollectionFollow;
            break;
            
        }
        
        CASE (@"seetishop_shared"){
            _notType = NotificationType_SeetiesShared;
            break;
            
        }
        
        CASE (@"seeties"){
            _notType = NotificationType_Seeties;
            break;
            
        }
        
        DEFAULT
        {
            _notType = NotificationType_Follow;
            break;
            
        }
    }
    
    return _notType;

}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"notificationMessage",
                                                       @"user.user_info" : @"tempUserProfiles",
                                                       @"user_thumbnail.url" : @"userProfileImage",
                                                       @"post.post_info" : @"arrPosts"

                                                       
                                                       }];
}

-(ProfileModel*)userProfile
{
    if (!_userProfile) {
        
        
        @try {
            
            NSDictionary* dict = _user[@"user_info"][0];
            
            _userProfile = [[ProfileModel alloc]initWithDictionary:dict error:nil];          
        }
        @catch (NSException *exception) {
            
            _userProfile = nil;
        }
        
    }
    
    return _userProfile;

}

@end
