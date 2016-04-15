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
    
    if ([Utils checkUserIsLogin] && !(dataToPost.shareType == ShareTypePostUser)) {
        
        //Create custom UIActivity
        SeetiesUIActivity *customControl = [[SeetiesUIActivity alloc] initWithTitle:@"Seeties" activityImage:[UIImage imageNamed:@"ShareToBuddiesIcon"] activityType:@"com.seeties.custom" completionBlock:^(id object){
            
            ShareFriendViewController *shareScreen = [[ShareFriendViewController alloc] initWithNibName:@"ShareFriendViewController" bundle:nil];
            
            shareScreen.postData = dataToPost;
            
            [weakSelf presentViewController:shareScreen animated:YES completion:nil];
        }];

        [customUIActivity addObject:customControl];
    }
    
    //Create custom facebook UIActivity
//    CustomUIActivity *customFBControl = [[CustomUIActivity alloc] initWithTitle:@"Facebook" activityImage:[UIImage imageNamed:@"FB-f-Logo__blue_144"] activityType:@"com.apple.UIKit.activity.PostToFacebook" completionBlock:^(id object){
//        
//        FBSDKShareLinkContent *content = dataToPost.fbShareContent;
//        
//        [FBSDKShareDialog showFromViewController:weakSelf
//                                     withContent:content
//                                        delegate:nil];
//    }];
//    
//    [customUIActivity addObject:customFBControl];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[dataToPost] applicationActivities:customUIActivity];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypeCopyToPasteboard,
//                                   UIActivityTypePostToFacebook,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    return activityVC;
}

@end
