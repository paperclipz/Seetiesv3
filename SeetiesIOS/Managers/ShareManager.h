//
//  ShareManager.h
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


typedef enum
{
    ShareTypeFacebookPost,
    ShareTypeFacebookCollection,
    ShareTypeFacebookPostUser,
} ShareType;

@interface ShareManager : NSObject
-(void)shareFacebook:(NSString*)title message:(NSString*)description shareType:(ShareType)type userID:(NSString*)userID delegate:(UIViewController*)vc;

@end
