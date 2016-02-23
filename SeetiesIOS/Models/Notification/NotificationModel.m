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

@property(nonatomic,strong)NSDictionary* collection;

//following_user
@end

@implementation NotificationModel


-(CollectionModel*)collectionInfo
{
    if (!_collectionInfo) {
        _collectionInfo = [[CollectionModel alloc]initWithDictionary:_collection error:nil];
    }
    
    return _collectionInfo;
}


-(NSDictionary*)followCollectionInfo
{
    if (!_followCollectionInfo) {
        _followCollectionInfo = _collection;
    }
    
    return _followCollectionInfo;
}

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
                                                       @"post.post_info" : @"arrPosts",
                                                       @"following_user.user_info" : @"arrFollowingUsers"
                                                       
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
