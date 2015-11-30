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

            ExpertLogin_Url = @"https://itcave-api.seeties.me/v2.2/login";
            UserRegister_Url = @"https://itcave-api.seeties.me/v2.2/register";
            FacebookRegister_Url = @"https://itcave-api.seeties.me/v2.2/login/facebook";
            Publish_PostUrl = @"https://itcave-api.seeties.me/v2.2/post";
            CategoryIDN_Url = @"https://itcave-api.seeties.me/v2.2/system/update/category";
            Feed_Url = @"https://itcave-api.seeties.me/v2.2/feed";
            Explore_Url = @"https://itcave-api.seeties.me/v2.2/explore";
            UserWallpaper_Url = @"https://itcave-api.seeties.me/v2.2/";
            Suggestions_Url = @"https://itcave-api.seeties.me/v2.2/user/suggestions";
            GetComment_URl = @"https://itcave-api.seeties.me/v2.2/post";
            UserLogout_Url = @"https://itcave-api.seeties.me/v2.2/logout";
            GetAlllangauge_Url = @"https://itcave-api.seeties.me/v2.2/system/languages";
            GetNotification_Url = @"https://itcave-api.seeties.me/v2.2/notifications";
            GetDrafts_Url = @"https://itcave-api.seeties.me/v2.2/draft";
            GetNotificationCount_Url = @"https://itcave-api.seeties.me/v2.2/notifications/count";
            GetAllCategory_Url = @"https://itcave-api.seeties.me/v2.2/system/update/category";
            GetFestivals_Url = @"https://itcave.seeties.me/festivals?hidden=header";
            GetNearbyPost_Url = @"https://itcave-api.seeties.me/v2.2/post/";//:post_id/nearbyposts?token="
            InstagramRegister_Url = @"https://itcave-api.seeties.me/v2.2/login/instagram";
//            ExpertLogin_Url = @"https://ios-api.seeties.me/v1.2/login";
//            UserRegister_Url = @"https://ios-api.seeties.me/v1.2/register";
//            FacebookRegister_Url = @"https://ios-api.seeties.me/v1.2/login/facebook";
//            Publish_PostUrl = @"https://ios-api.seeties.me/v1.2/post";
//            CategoryIDN_Url = @"https://ios-api.seeties.me/v1.2/system/update/category";
//            Feed_Url = @"https://ios-api.seeties.me/v1.2/feedv2";
//            Explore_Url = @"https://ios-api.seeties.me/v1.2/explore";
//            UserWallpaper_Url = @"https://ios-api.seeties.me/v1.2";
//            Suggestions_Url = @"https://ios-api.seeties.me/v1.2/user/suggestions";
//            GetComment_URl = @"https://ios-api.seeties.me/v1.2/post";
//            UserLogout_Url = @"https://ios-api.seeties.me/v1.2/logout";
//            GetAlllangauge_Url = @"https://ios-api.seeties.me/v1.2/system/languages";
//            GetNotification_Url = @"https://ios-api.seeties.me/v1.2/notifications";
//            GetDrafts_Url = @"https://ios-api.seeties.me/v1.2/draft";
//            GetNotificationCount_Url = @"https://ios-api.seeties.me/v1.2/notifications/count";
//            GetApiVersion_Url = @"https://ios-api.seeties.me/v1.2/system/apiversion";
        }else{
          //  NSLog(@"CheckAPI is 1");
            ExpertLogin_Url = @"https://ios-api.seeties.me/v2.2/login";
            UserRegister_Url = @"https://ios-api.seeties.me/v2.2/register";
            FacebookRegister_Url = @"https://ios-api.seeties.me/v2.2/login/facebook";
            Publish_PostUrl = @"https://ios-api.seeties.me/v2.2/post";
            CategoryIDN_Url = @"https://ios-api.seeties.me/v2.2/system/update/category";
            Feed_Url = @"https://ios-api.seeties.me/v2.2/feed";
            Explore_Url = @"https://ios-api.seeties.me/v2.2/explore";
            UserWallpaper_Url = @"https://ios-api.seeties.me/v2.2/";
            Suggestions_Url = @"https://ios-api.seeties.me/v2.2/user/suggestions";
            GetComment_URl = @"https://ios-api.seeties.me/v2.2/post";
            UserLogout_Url = @"https://ios-api.seeties.me/v2.2/logout";
            GetAlllangauge_Url = @"https://ios-api.seeties.me/v2.2/system/languages";
            GetNotification_Url = @"https://ios-api.seeties.me/v2.2/notifications";
            GetDrafts_Url = @"https://ios-api.seeties.me/v2.2/draft";
            GetNotificationCount_Url = @"https://ios-api.seeties.me/v2.2/notifications/count";
            GetApiVersion_Url = @"https://ios-api.seeties.me/v2.2/system/apiversion";
            GetAllCategory_Url = @"https://ios-api.seeties.me/v2.2/system/update/category";
            GetFestivals_Url = @"https://seeties.me/festivals?hidden=header";
            GetNearbyPost_Url = @"https://ios-api.seeties.me/v2.2/post/";//:post_id/nearbyposts?token="
            InstagramRegister_Url = @"https://ios-api.seeties.me/v2.2/login/instagram";
        }
        
        

        

      //  GetApiVersion_Url = @"https://itcave-api.seeties.me/v1.2/system/apiversion";
       
    }
    return self;
}
@end
