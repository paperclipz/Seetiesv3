//
//  UrlDataClass.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlDataClass : NSObject

@property (nonatomic, strong) NSString *ExpertLogin_Url;
@property (nonatomic, strong) NSString *UserRegister_Url;
@property (nonatomic, strong) NSString *CategoryIDN_Url;
@property (nonatomic, strong) NSString *Publish_PostUrl;
@property (nonatomic, strong) NSString *Feed_Url;
@property (nonatomic, strong) NSString *Explore_Url;
@property (nonatomic, strong) NSString *UserWallpaper_Url;
@property (nonatomic, strong) NSString *Suggestions_Url;
@property (nonatomic, strong) NSString *GetComment_URl;
@property (nonatomic, strong) NSString *UserLogout_Url;
@property (nonatomic, strong) NSString *FacebookRegister_Url;
@property (nonatomic, strong) NSString *GetAlllangauge_Url;
@property (nonatomic, strong) NSString *GetNotification_Url;
@property (nonatomic, strong) NSString *GetDrafts_Url;
@property (nonatomic, strong) NSString *GetNotificationCount_Url;
@property (nonatomic, strong) NSString *GetApiVersion_Url;
@property (nonatomic, strong) NSString *GetAllCategory_Url;
@property (nonatomic, strong) NSString *GetFestivals_Url;
@property (nonatomic, strong) NSString *GetNearbyPost_Url;

+ (id)sharedManager;
@end
