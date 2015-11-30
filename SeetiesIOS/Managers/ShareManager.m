//
//  ShareManager.m
//  SeetiesIOS
//
//  Created by Evan Beh on 11/24/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ShareManager.h"
#import <MessageUI/MessageUI.h>
#import <MGInstagram/MGInstagram.h>

#define SEETIES_LOGO_URL @"https://pbs.twimg.com/profile_images/499756229170716673/U1ejUl7V.png"
@interface ShareManager()<UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate>
{
    UIImageView* postImageView;
    UIViewController* viewController;
}

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property(nonatomic,strong)FBLinkShareParams* params;
@property(nonatomic,strong)NSString* postDescription;
@property(nonatomic,strong)NSString* shareID;
@property(nonatomic,strong)NSString* postTitle;
@property(nonatomic,strong)NSString* postImageURL;


@property(nonatomic,strong)MGInstagram* instagram;


@end
@implementation ShareManager

#pragma mark - SHARE API

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        _postTitle = @"SEEITES";
    }
    
    return self;
}
-(void)shareFacebook:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc
{
    NSString* caption = @"SEEITES";

    self.postTitle = title;
    self.postImageURL = imageURL;
    self.shareID = shareID;
    self.postDescription = description;
    viewController = vc;
    
    postImageView = [UIImageView new];
    [postImageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.postImageURL] andPlaceholderImage:[UIImage imageNamed:@"NoImage.png"] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      
        SLog(@"image finish load");
    }];
    
    NSString* message = [self getShareMessage:type appendURL:YES];
    NSString* finalLink = [self getShareLink:type];

    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:finalLink];
    content.contentDescription = message;
    content.contentTitle = caption;
    content.imageURL = [NSURL URLWithString:imageURL];
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:nil];
    
    
}

-(void)shareOnInstagram:(NSString*)imageURL delegate:(UIViewController*)vc
{
    self.postImageURL = imageURL;
    viewController = vc;
   // NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    postImageView = [UIImageView new];
   
    [postImageView sd_setImageWithURL:[NSURL URLWithString:self.postImageURL] placeholderImage:[UIImage imageNamed:@"NoImage.png"] options:SDWebImageHighPriority completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            [UIAlertView showWithTitle:LocalisedString(@"system")
                               message:LocalisedString(@"Loading Fail")
                     cancelButtonTitle:LocalisedString(@"OK")
                     otherButtonTitles:nil
                              tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                  if (buttonIndex == [alertView cancelButtonIndex]) {
                                      NSLog(@"Cancelled");
                                  }
                              }];

            return;
        }
        
        if([MGInstagram isAppInstalled])
        {
            self.instagram = [[MGInstagram alloc] init];

            CGFloat cropVal = (postImageView.image.size.height > postImageView.image.size.width ? postImageView.image.size.width : postImageView.image.size.height);
            
            cropVal *= [postImageView.image scale];
            
            CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
            CGImageRef imageRef = CGImageCreateWithImageInRect([postImageView.image CGImage], cropRect);
            
            NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
            CGImageRelease(imageRef);
            
            postImageView.image =  [UIImage imageWithData:imageData];
            
            UIImage *image = postImageView.image;

            [self.instagram postImage:image inView:viewController.view];
            
//            CGFloat cropVal = (postImageView.image.size.height > postImageView.image.size.width ? postImageView.image.size.width : postImageView.image.size.height);
//            
//            cropVal *= [postImageView.image scale];
//            
//            CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
//            CGImageRef imageRef = CGImageCreateWithImageInRect([postImageView.image CGImage], cropRect);
//            
//            NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
//            CGImageRelease(imageRef);
//            
//            postImageView.image =  [UIImage imageWithData:imageData];
//            
//            NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
//            if (![imageData writeToFile:writePath atomically:YES]) {
//                // failure
//                NSLog(@"image save failed to path %@", writePath);
//                return;
//            } else {
//                // success.
//            }
//            
//            // send it to instagram.
//            NSURL *fileURL = [NSURL fileURLWithPath:writePath];
//            self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
//            self.documentController.delegate = self;
//            [self.documentController setUTI:@"com.instagram.exclusivegram"];
//            [self.documentController setAnnotation:@{@"InstagramCaption" : @"We are making fun"}];
//            [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:viewController.view animated:YES];
        }
        else
        {
            NSLog(@"Error Instagram is either not installed or image is incorrect size");
            [self showMessageForType];
            
        }
}];
   
}

-(void)shareOnLINE:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc
{
    
    self.postTitle = title;
    self.postImageURL = imageURL;
    self.shareID = shareID;
    self.postDescription = description;
    viewController = vc;
  
    NSString* message = [self getShareMessage:type appendURL:YES];

    

    NSString *ShareText = message;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //Connect to itunes if user dont have app install
        
        [self showMessageForType];
      //  NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        //[[UIApplication sharedApplication] openURL:itunesURL];
    }
}

-(void)shareOnMessanger:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc
{
    
    self.postTitle = title;
    self.postImageURL = imageURL;
    self.shareID = shareID;
    NSString* caption = @"SEETIES.ME";
    self.postDescription = description;
    viewController = vc;
    NSString* message = [self getShareMessage:type appendURL:YES];
    NSString* finalLink = [self getShareLink:type];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:finalLink];
    content.contentTitle = caption;
    content.contentDescription = message;
    content.imageURL = [NSURL URLWithString:SEETIES_LOGO_URL];
    [FBSDKMessageDialog showWithContent:content delegate:nil];
    
}

-(void)shareOnWhatsapp:(NSString*)title message:(NSString*)description imageURL:(NSString*)imageURL shareType:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc
{
    
    self.postTitle = title;
    self.postImageURL = imageURL;
    self.shareID = shareID;
    self.postDescription = description;
    viewController = vc;

    NSString* message = [self getShareMessage:type appendURL:YES];

    NSString *ShareText = message;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=%@"];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }else{
        [self showMessageForType];

       // NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id310633997"];
        //[[UIApplication sharedApplication] openURL:itunesURL];
    }

}
#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

-(void)shareWithCopyLink:(ShareType)type shareID:(NSString*)shareID delegate:(UIViewController*)vc
{
    self.shareID = shareID;
    viewController = vc;
    NSString* message = [self getShareMessage:type appendURL:YES];

    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
    
    [UIAlertView showWithTitle:LocalisedString(@"system")
                       message:LocalisedString(@"Success Copy Link")
             cancelButtonTitle:LocalisedString(@"OK")
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          }
                      }];


}

-(void)shareOnEmail:(ShareType)type viewController:(UIViewController*)vc shareID:(NSString*)shareID
{
    
    viewController = vc;
    self.shareID = shareID;
    
    
    if ([MFMailComposeViewController canSendMail])
    {
        
       
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        NSString *messageSubject;

        switch (type) {
            default:
            case ShareTypeFacebookPost:
                
                messageSubject = @"Seeties Post";
                break;
            case ShareTypeFacebookCollection:
                messageSubject = @"Seeties Collection";

                break;

            case ShareTypeFacebookPostUser:
                messageSubject = @"Seeties User";

                break;

                
        }
        
        [mailer setSubject:messageSubject];
        NSString* message = [self getShareMessage:type appendURL:YES];
        [mailer setMessageBody:message isHTML:NO];
        [viewController presentViewController:mailer animated:YES completion:nil];

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Utility
-(NSString*)getShareMessage:(ShareType)type appendURL:(BOOL)isNeedAppendURL
{
    NSString* message;
    
    switch (type) {
            
        default:
        case ShareTypeFacebookPost:
        {
            message = LocalisedString(@"I was reading [post title] on Seeties and I thought you might be interested in reading it too.\n\n[post url]");
            if (self.postTitle) {
                message = [message stringByReplacingOccurrencesOfString:@"[post title]"
                                                             withString:self.postTitle];
            }
            else{
                message = [message stringByReplacingOccurrencesOfString:@"[post title]"
                                                             withString:@""];
            }
                 message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:isNeedAppendURL?[self getShareLink:type]:@""];
        }
            break;
        case ShareTypeFacebookCollection:
        {
            message = LocalisedString(@"I was checking this collection [collection title] on Seeties and I thought you might like to see it too.\n\n[post url]");
            if (self.postTitle) {
                message = [message stringByReplacingOccurrencesOfString:@"[collection title]"
                                                             withString:self.postTitle];
            }
            else{
                message = [message stringByReplacingOccurrencesOfString:@"[collection title]"
                                                             withString:@""];
            }
            
            message = [message stringByReplacingOccurrencesOfString:@"[post url]"
                                                         withString:isNeedAppendURL?[self getShareLink:type]:@""];
        }
            break;
        case ShareTypeFacebookPostUser:
        {
            message = [NSString stringWithFormat:@"Check out my profile on Seeties!"];
            message = [NSString stringWithFormat:@"%@ %@",message,isNeedAppendURL?[self getShareLink:type]:@""];

            
        }
            break;
    }
    
    return message;

}

-(NSString*)getShareLink:(ShareType)type
{
    NSString* seetiesLink = @"https://seeties.me/";
    NSString* subLink;
    switch (type) {
            
        default:
        case ShareTypeFacebookPost:
        {
            subLink = @"post/";
            
        }
            break;
        case ShareTypeFacebookCollection:
        {
            subLink = @"collections/";
           
        }
            break;
        case ShareTypeFacebookPostUser:
        {
            subLink = @"";
            
        }
            break;
    }

    NSString* finalLink = [NSString stringWithFormat:@"%@%@%@",seetiesLink,subLink,self.shareID];

    return finalLink;
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

#pragma mark - ERROR MESSAGE

-(void)showMessageForType
{
    [UIAlertView showWithTitle:LocalisedString(@"system")
                       message:LocalisedString(@"App Not Installed")
             cancelButtonTitle:LocalisedString(@"OK")
             otherButtonTitles:nil
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == [alertView cancelButtonIndex]) {
                              NSLog(@"Cancelled");
                          }
                      }];

}

#pragma mark - Mail Composer Delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }
    
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}
@end
