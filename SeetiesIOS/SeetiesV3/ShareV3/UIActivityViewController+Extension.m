//
//  UIActivityViewController+Extension.m
//  SeetiesIOS
//
//  Created by Lai on 07/04/2016.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "UIActivityViewController+Extension.h"
#import "ShareFriendViewController.h"
#import "CustomUIActivity.h"
#import "CustomItemSource.h"

@implementation UIActivityViewController (Extension)

+ (UIActivityViewController *)ShowShareViewControllerOnTopOf:(UIViewController*)viewController WithDataToPost:(CustomItemSource *)dataToPost {
    
    __weak UIViewController *weakSelf = viewController;
    
    NSMutableArray *customUIActivity = [[NSMutableArray alloc] init];
    
    if ([Utils checkUserIsLogin] && !(dataToPost.shareType == ShareTypePostUser) && (dataToPost.shareType != ShareTypeInvite) && (dataToPost.shareType != ShareTypeReferralInvite)) {
        
        //Create custom UIActivity
        SeetiesUIActivity *customControl = [[SeetiesUIActivity alloc] initWithTitle:@"Seeties" activityImage:[UIImage imageNamed:@"ShareToBuddiesIcon"] activityType:@"com.seeties.custom" completionBlock:^(id object){
            
            ShareFriendViewController *shareScreen = [[ShareFriendViewController alloc] initWithNibName:@"ShareFriendViewController" bundle:nil];
            
            shareScreen.postData = dataToPost;
            
            [weakSelf presentViewController:shareScreen animated:YES completion:nil];
        }];

        [customUIActivity addObject:customControl];
    }
    
    //Create custom facebook UIActivity
    CustomUIActivity *customFBControl = [[CustomUIActivity alloc] initWithTitle:@"Facebook" activityImage:[UIImage imageNamed:@"FacebookIcon"] activityType:@"com.custom.PostToFacebook" completionBlock:^(id object){
        
        FBSDKShareLinkContent *content = dataToPost.fbShareContent;
        
        [FBSDKShareDialog showFromViewController:weakSelf
                                     withContent:content
                                        delegate:nil];
    }];
    
    [customUIActivity addObject:customFBControl];
    
    CustomUIActivity *customWhatsApp = [[CustomUIActivity alloc] initWithTitle:@"Whatsapp" activityImage:[UIImage imageNamed:@"WhatsappIcon"] activityType:@"com.custom.whatsapp" completionBlock:nil];
    
    [customUIActivity addObject:customWhatsApp];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[dataToPost] applicationActivities:customUIActivity];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypeCopyToPasteboard,
                                   UIActivityTypePostToFacebook,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    return activityVC;
}

@end
