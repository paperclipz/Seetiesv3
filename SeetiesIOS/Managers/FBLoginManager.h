//
//  FBLoginManager.h
//  Seeties
//
//  Created by Lai on 23/05/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

typedef void (^FBGraphRequestHandler)(NSDictionary *result);
typedef void (^FBLoginHandler)(FBSDKLoginManagerLoginResult *result);

@interface FBLoginManager : NSObject

+ (void)performFacebookGraphRequest:(FBGraphRequestHandler)completionBlock;
+ (void)performFacebookLogin:(UIViewController *)viewController completionBlock:(FBLoginHandler)completionBlock;

@end
