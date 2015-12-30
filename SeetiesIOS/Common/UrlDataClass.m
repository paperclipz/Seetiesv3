//
//  UrlDataClass.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "UrlDataClass.h"

@implementation UrlDataClass
@synthesize ExpertLogin_Url,UserRegister_Url,CategoryIDN_Url,Publish_PostUrl,Feed_Url,Explore_Url,UserWallpaper_Url,Suggestions_Url,GetComment_URl,UserLogout_Url,FacebookRegister_Url,GetAlllangauge_Url,GetNotification_Url,GetDrafts_Url,GetNotificationCount_Url,GetApiVersion_Url,GetAllCategory_Url,GetFestivals_Url,GetNearbyPost_Url,InstagramRegister_Url;
static UrlDataClass *sharedMyManager = nil;

#pragma mark Singleton Methods
+ (id)sharedManager {
    @synchronized(self) {
        if(sharedMyManager == nil)
            sharedMyManager = [[super allocWithZone:NULL] init];
    }
    return sharedMyManager;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedManager];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)init {
    if (self = [super init]) {
        //http://dev-api.seeties.me
        //https://web-api.seeties.me
        //itcave - for apple testing v1.0
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *CheckAPI = [defaults objectForKey:@"CheckAPI"];
        if ([CheckAPI isEqualToString:@"0"]) {
          //  NSLog(@"CheckAPI is 0");

            ExpertLogin_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/login",API_VERSION];
            UserRegister_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/register",API_VERSION];
            FacebookRegister_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/login/facebook",API_VERSION];
            Publish_PostUrl = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/post",API_VERSION];
            CategoryIDN_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/system/update/category",API_VERSION];
            Feed_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/feed",API_VERSION];
            Explore_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/explore",API_VERSION];
            UserWallpaper_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/",API_VERSION];
            Suggestions_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/user/suggestions",API_VERSION];
            GetComment_URl = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/post",API_VERSION];
            UserLogout_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/logout",API_VERSION];
            GetAlllangauge_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/system/languages",API_VERSION];
            GetNotification_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/notifications",API_VERSION];
            GetDrafts_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/draft",API_VERSION];
            GetNotificationCount_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/notifications/count",API_VERSION];
            GetAllCategory_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/system/update/category",API_VERSION];
            GetFestivals_Url = [NSString stringWithFormat:@"https://itcave.seeties.me/festivals?hidden=header"];
            GetNearbyPost_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/post/",API_VERSION];
            InstagramRegister_Url = [NSString stringWithFormat:@"https://itcave-api.seeties.me/v%@/login/instagram",API_VERSION];

        }else{
            
            ExpertLogin_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/login",API_VERSION];
            UserRegister_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/register",API_VERSION];
            FacebookRegister_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/login/facebook",API_VERSION];
            Publish_PostUrl = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/post",API_VERSION];
            CategoryIDN_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/system/update/category",API_VERSION];
            Feed_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/feed",API_VERSION];
            Explore_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/explore",API_VERSION];
            UserWallpaper_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/",API_VERSION];
            Suggestions_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/user/suggestions",API_VERSION];
            GetComment_URl = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/post",API_VERSION];
            UserLogout_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/logout",API_VERSION];
            GetAlllangauge_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/system/languages",API_VERSION];
            GetNotification_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/notifications",API_VERSION];
            GetDrafts_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/draft",API_VERSION];
            GetNotificationCount_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/notifications/count",API_VERSION];
            GetAllCategory_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/system/update/category",API_VERSION];
            GetFestivals_Url = [NSString stringWithFormat:@"https://seeties.me/festivals?hidden=header"];
            GetNearbyPost_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/post/",API_VERSION];
            InstagramRegister_Url = [NSString stringWithFormat:@"https://ios-api.seeties.me/v%@/login/instagram",API_VERSION];
        }
        
        

        

      //  GetApiVersion_Url = @"https://itcave-api.seeties.me/v1.2/system/apiversion";
       
    }
    return self;
}
@end
