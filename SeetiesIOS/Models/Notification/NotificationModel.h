//
//  NotificationModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 2/17/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@class DealCollectionModel;
@protocol ProfileModel
@end

@interface NotificationModel : JSONModel
@property(nonatomic,strong)NSString* notificationMessage;
@property(nonatomic,strong)NSString* date;
@property(nonatomic,strong)ProfileModel<Ignore>* userProfile;
@property(nonatomic,assign)NotificationType notType;
@property(nonatomic,assign)BOOL viewed;
@property(nonatomic,strong)NSString* uid;
@property(nonatomic,strong)NSString* post_id;
@property(nonatomic,strong)NSString* userProfileImage;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSArray<DraftModel>* arrPosts;
@property(nonatomic,strong)NSString* action;
@property(nonatomic,strong)SeShopDetailModel* seetishop;

@property(nonatomic,strong)CollectionModel* collectionInfo;

//for referral notification usage
@property(nonatomic,strong)DealCollectionModel* deal_collection;
@property(nonatomic,strong)NSString* referral_u_id;


//for following notification
@property(nonatomic,strong)NSDictionary* followCollectionInfo;
@property(nonatomic,strong)NSArray<ProfileModel>* arrFollowingUsers;
@property(nonatomic,strong)DealModel* deal;


//for collection Notification
@property(nonatomic,strong)NSArray<CollectionModel>* arrCollections;

//for type seeties || action collection
@property(nonatomic,strong)NSString* collection_id;
//for type seeties || action seetishop
@property(nonatomic,strong)NSString* seetishop_id;
//for type seeties || action url
@property(nonatomic,strong)NSString* url;
//for type seeties || action deal ID
@property(nonatomic,strong)NSString* deal_id;
//for type seeties || action deal collection ID
@property(nonatomic,strong)NSString* deal_collection_id;
@end
