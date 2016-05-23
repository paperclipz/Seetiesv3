//
//  FBLoginManager.m
//  Seeties
//
//  Created by Lai on 23/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "FBLoginManager.h"
#import "FacebookModel.h"
#import "MessageManager.h"

@implementation FBLoginManager

+ (void)performFacebookGraphRequest:(FBGraphRequestHandler)completionBlock {
    
    if (![FBSDKAccessToken currentAccessToken]) {
        return;
    }
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, picture, email, gender, birthday, first_name, last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error)
         {
             NSLog(@"resultis:%@",result);
             
             NSDictionary *facebookData = result;
             FacebookModel* model = [FacebookModel new];
             
             model.uID = facebookData[@"id"];
             model.name = facebookData[@"name"];
             model.userProfileImageURL = facebookData[@"picture"][@"data"][@"url"];
             model.email = facebookData[@"email"];
             model.gender = facebookData[@"gender"];
             model.dob = facebookData[@"birthday"];
             model.userName = facebookData[@"last_name"];
             model.userFullName = [NSString stringWithFormat:@"%@%@", facebookData[@"first_name"], facebookData[@"last_name"]];
             
             model.fbToken = [[FBSDKAccessToken currentAccessToken] tokenString];
             
             [ConnectionManager dataManager].facebookLoginModel = model;
             
             if (completionBlock) {
                 completionBlock(result);
             }
//             [self requestServerForFacebookLogin];
         }
         else {
             NSLog(@"Process error");
             
//             [MessageManager showMessage:LocalisedString(@"system") SubTitle:@"Facebook Login Failed!" Type:TSMessageNotificationTypeError];
         }
     }];
}

+ (void)performFacebookLogin:(UIViewController *)viewController completionBlock:(FBLoginHandler)completionBlock {
    
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        
        [loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_birthday"] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            if (error) {
                NSLog(@"Process error");
                [MessageManager showMessage:LocalisedString(@"system") SubTitle:@"Facebook Login Failed!" Type:TSMessageNotificationTypeError];
            
            } else {
                
                if (completionBlock) {
                    completionBlock(result);
                }
            }
        }];

}

@end
