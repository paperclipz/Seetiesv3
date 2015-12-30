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
    ShareTypePost,
    ShareTypeCollection,
    ShareTypePostUser,
    ShareTypeSeetiesShop
} ShareType;

@interface ShareManager : NSObject
//shareID (postID, collectionID,UserID)
-(void)shareFacebook:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc;
-(void)shareOnLINE:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc;
-(void)shareOnInstagram:(NSString*)imageURL delegate:(UIViewController*)vc;
-(void)shareOnMessanger:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc;
-(void)shareOnWhatsapp:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc;
-(void)shareWithCopyLink:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc;
-(void)shareOnEmail:(ShareType)type viewController:(UIViewController*)vc shareID:(NSString*)shareID;

@end
