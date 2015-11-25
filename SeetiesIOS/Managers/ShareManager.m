//
//  ShareManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ShareManager.h"

@interface ShareManager()

@property(nonatomic,strong)FBLinkShareParams* params;
@property(nonatomic,strong)NSString* postDescription;
@property(nonatomic,strong)NSString* userID;
@property(nonatomic,strong)NSString* postTitle;


@end
@implementation ShareManager

-(void)shareFacebookTitle:(NSString*)title message:(NSString*)description shareType:(ShareType)type userID:(NSString*)userID delegate:(UIViewController*)vc
{
    self.postTitle = title;
    self.userID = userID;
    self.postDescription = description;
    NSString* message = @"";
    NSString* seetiesLink = @"https://seeties.me/";
    NSString* subLink;
    NSString* iDLink = @"";
    NSString* caption = @"SEETIES.ME";
    
    switch (type) {
            
        default:
        case ShareTypeFacebookPost:
        {
            subLink = @"post/";
            message = LocalisedString(@"I was reading [post title] on Seeties and I thought you might be interested in reading it too.\n\n[post url]");
            message = [message stringByReplacingOccurrencesOfString:@"[post title]"
                                                         withString:self.postTitle];
            message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:@""];
        }
            break;
        case ShareTypeFacebookCollection:
        {
            subLink = @"collections/";
            message = LocalisedString(@"I was checking this collection [collection title] on Seeties and I thought you might like to see it too.\n\n[post url]");
            message = [message stringByReplacingOccurrencesOfString:@"[collection title]"
                                                         withString:self.postTitle];
            message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:@""];
        }
            break;
        case ShareTypeFacebookPostUser:
        {
            subLink = @"/";
            message = [NSString stringWithFormat:@"Check out my profile on Seeties!"];

        }
            break;
    }
    
    NSString* finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,iDLink];

    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:finalLink];
    content.contentDescription = self.postDescription;
    content.contentTitle = self.postTitle;
    content.imageURL = [NSURL URLWithString:@"http://www.wallpapereast.com/static/images/hd-computer-wallpapers.jpg"];
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:nil];
    
    
    
    // Check if the Facebook app is installed and we can present the share dialog
    _params = nil;
    self.params = [[FBLinkShareParams alloc] init];
    self.params.link = [NSURL URLWithString:message];
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:_params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:self.params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        
        // Put together the dialog parameters
    
        
        NSDictionary* params = @{@"name":@"",
                                 @"caption":caption,
                                 @"description":self.postDescription,
                                 @"link":message,
                                 @"picture":@""};
        
        
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
