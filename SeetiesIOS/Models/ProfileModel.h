//
//  ProfileModel.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/20/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "Model.h"
#import "DraftModel.h"
#import "SeShopsModel.h"
#import "PaginationModel.h"

@class DraftModel;
@interface ProfileModel : Model<NSCopying>
@property(nonatomic,assign)int following_count;
@property(nonatomic,strong)NSString* location;
@property(nonatomic,assign)int follower_count;
@property(nonatomic,strong)NSString* username;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSString* profileDescription;
@property(nonatomic,strong)NSString* personal_link;
@property(nonatomic,strong)NSString* country;
@property(nonatomic,strong)NSArray* personal_tags;
@property(nonatomic,strong)NSString* wallpaper;
@property(nonatomic,strong)NSString* dob;
@property(nonatomic,strong)NSString* profile_photo_images;
@property(nonatomic,strong)NSString* gender;
@property(nonatomic,assign)BOOL following;
@property(nonatomic,strong)NSString* uid;
@property(nonatomic,strong)NSString* url;//use for notification user profile
@property(nonatomic,assign)BOOL phone_verified;
@property (nonatomic,strong)NSArray* categories;
@property (nonatomic,strong)NSString* crawler;
@property (nonatomic,strong)NSString* email;
@property (nonatomic,strong)NSString* token;
@property (nonatomic,strong)NSString* role;
@property (nonatomic,strong)LanguageModel* system_language;
@property (nonatomic,strong)NSString* provisioning;
@property (nonatomic,strong)NSString* fb_id;
@property (nonatomic,strong)NSString* insta_id;
@property (nonatomic,strong)NSString* contact_no;
@property (nonatomic,strong)NSString* referral_code;
@property (nonatomic,strong)NSArray<DraftModel>* posts;
@property(nonatomic,strong)NSArray<LanguageModel>* languages;



+(void)saveUserProfile:(ProfileModel*)model;
+(ProfileModel*)getUserProfile;
+(int)getWalletCount;

@end

@interface ProfilePostModel : Model
@property(nonatomic,strong)DraftsModel* userPostData;
@property(nonatomic,strong)DraftsModel* recommendations;

@end

