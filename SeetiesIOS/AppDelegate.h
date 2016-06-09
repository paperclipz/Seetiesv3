//
//  AppDelegate.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/14/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <FacebookSDK/FacebookSDK.h>
#import "UrlDataClass.h"
#import "NewLandingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
}
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic)NewLandingViewController* landingViewController;
//get firebase token
+(NSString *)getFirebaseToken;
//- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

//com.Seeties.SeetiesIOS.Live
//com.Seeties.SeetiesIOS.Dev
@end
