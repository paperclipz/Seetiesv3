//
//  ShareViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ShareViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ShareToFrenViewController.h"
@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MainScroll.delegate = self;
    MainScroll.alwaysBounceVertical = YES;
    
    CenterView.frame = CGRectMake((screenWidth / 2) - 160, 120, 320, screenHeight);
    GoToIcon.frame = CGRectMake(screenWidth - 25 - 10, 76, 25, 23);
    
    BackButton.frame = CGRectMake(screenWidth - 50, 0, 50, 50);
    
    CheckShareStatus = 0;
    
    ShowTitle.text = LocalisedString(@"Share this post");
    ShowSubTitle.text = LocalisedString(@"Send via other apps");
    ShowSendToFren.text = LocalisedString(@"Send to buddies in Seeties");
    ShowSendToFrenSub.text = LocalisedString(@"Your buddies will be notified of this collection you've shared.");
}
-(void)GetCollectionID:(NSString *)Collectionid{

    GetCollectionID = Collectionid;
    CheckShareStatus = 1;
}
-(void)GetPostID:(NSString *)ID GetMessage:(NSString *)Msg GetTitle:(NSString *)Title GetImageData:(NSString *)ImgData{
    CheckShareStatus = 0;
    GetPostID = ID;
    GetMessage = Msg;
    GetTitle = Title;
    GetImgData = ImgData;
    
    imageMain = [[AsyncImageView alloc]init];
    imageMain.frame = CGRectMake(0, 0, 300, 300);
    imageMain.contentMode = UIViewContentModeScaleAspectFill;
    imageMain.layer.masksToBounds = YES;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageMain];
    if ([GetImgData length] == 0) {
        imageMain.image = [UIImage imageNamed:@"NoImage.png"];
    }else{
        NSURL *url_NearbySmall = [NSURL URLWithString:GetImgData];
        imageMain.imageURL = url_NearbySmall;
    }
    [MainScroll addSubview:imageMain];
    imageMain.hidden = YES;
    
    //===========
    NSLog(@"GetPostID is %@",GetPostID);
    NSLog(@"GetMessage is %@",GetMessage);
    NSLog(@"GetTitle is %@",GetTitle);
    NSLog(@"GetImgData is %@",GetImgData);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)FacebookButtonOnClick:(id)sender{
    NSLog(@"FacebookButtonOnClick");
    NSString *message;
    NSString *Description;
    NSString *caption;
    if (CheckShareStatus == 0) {
        message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
        Description = [NSString stringWithFormat:@"%@",GetMessage];
        caption = [NSString stringWithFormat:@"SEETIES.ME"];
    }else{
        message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
        Description = @"";
        caption = [NSString stringWithFormat:@"SEETIES.ME"];
    }
    
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:message];
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
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
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"", @"name",
                                       caption, @"caption",
                                       Description, @"description",
                                       message, @"link",
                                       @"", @"picture",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }

}
-(IBAction)InstagramButtonOnClick:(id)sender{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if([[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        CGFloat cropVal = (imageMain.image.size.height > imageMain.image.size.width ? imageMain.image.size.width : imageMain.image.size.height);
        
        cropVal *= [imageMain.image scale];
        
        CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
        CGImageRef imageRef = CGImageCreateWithImageInRect([imageMain.image CGImage], cropRect);
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
        CGImageRelease(imageRef);
        
        NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
        if (![imageData writeToFile:writePath atomically:YES]) {
            // failure
            NSLog(@"image save failed to path %@", writePath);
            return;
        } else {
            // success.
        }
        
        // send it to instagram.
        NSURL *fileURL = [NSURL fileURLWithPath:writePath];
        self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentController.delegate = self;
        [self.documentController setUTI:@"com.instagram.exclusivegram"];
        [self.documentController setAnnotation:@{@"InstagramCaption" : @"We are making fun"}];
        [self.documentController presentOpenInMenuFromRect:CGRectMake(0, 0, 320, 480) inView:self.view animated:YES];
    }
    else
    {
        NSLog (@"Instagram not found");
        
    }
}

-(IBAction)LINEButtonOnClick:(id)sender{
    NSString *message;
    
    if (CheckShareStatus == 0) {
        message = [NSString stringWithFormat:@"I found %@ on Seeties. Let's try it together.\n\nhttps://seeties.me/post/%@",GetTitle,GetPostID];
    }else{
        message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
    }
    
    NSString *ShareText = message;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"line://msg/text/%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}
-(IBAction)MessengerButtonOnClick:(id)sender{
    NSString *message;
    NSString *Description;
    if (CheckShareStatus == 0) {
        message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
        Description = [NSString stringWithFormat:@"%@",GetMessage];
    }else{
        message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
        Description = @"";
    }
    

    //NSString *caption = [NSString stringWithFormat:@"SEETIES.ME"];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:message];
    content.contentTitle = @"";
    content.contentDescription = Description;
    content.imageURL = [NSURL URLWithString:@"https://pbs.twimg.com/profile_images/499756229170716673/U1ejUl7V.png"];
    [FBSDKMessageDialog showWithContent:content delegate:nil];
}
-(IBAction)WhatsappButtonOnClick:(id)sender{
     NSString *message;
    if (CheckShareStatus == 0) {
        message = [NSString stringWithFormat:@"I found %@ on Seeties. Let's try it together.\n\nhttps://seeties.me/post/%@",GetTitle,GetPostID];
    }else{
        message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
    }
   
    NSString *ShareText = message;
    ShareText = [ShareText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=%@"];
    NSURL *whatsappURL = [NSURL URLWithString:[NSString stringWithFormat:@"whatsapp://send?text=%@",ShareText]];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }else{
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id310633997"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
}
-(IBAction)CopyLinkButtonOnClick:(id)sender{
    
    NSString *message;
    if (CheckShareStatus == 0) {
        message = [NSString stringWithFormat:@"I found %@ on Seeties. Let's try it together.\n\nhttps://seeties.me/post/%@",GetTitle,GetPostID];
    }else{
        message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = message;
    [TSMessage showNotificationInViewController:self title:@"" subtitle:@"Success Copy Link" type:TSMessageNotificationTypeSuccess];
}
-(IBAction)EmailButtonOnClick:(id)sender{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        NSString *MessageSubject;
        if (CheckShareStatus == 0) {
            MessageSubject = [NSString stringWithFormat:@"I found %@ on Seeties. Let's try it together.\n\nhttps://seeties.me/post/%@",GetTitle,GetPostID];
        }else{
            MessageSubject = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
        }
       
        [mailer setSubject:MessageSubject];
        
        NSString *message;
        NSString *Description;
        
        if (CheckShareStatus == 0) {
            message = [NSString stringWithFormat:@"https://seeties.me/post/%@",GetPostID];
            Description = [NSString stringWithFormat:@"%@",GetMessage];
        }else{
            message = [NSString stringWithFormat:@"https://seeties.me/collections/%@",GetCollectionID];
            Description = @"";
        }
        
        NSString *emailBody = [[NSString alloc]initWithFormat:@"%@ %@",Description,message];
        [mailer setMessageBody:emailBody isHTML:NO];
        
        // [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"appInviteDialog results is %@",results);
}
- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error{
    NSLog(@"appInviteDialog error is %@",error);
}
-(IBAction)ShareToFrenButtonOnClick:(id)sender{

    ShareToFrenViewController *ShareToFrenView = [[ShareToFrenViewController alloc]init];
    [self presentViewController:ShareToFrenView animated:YES completion:nil];
    [ShareToFrenView GetPostsID:GetPostID GetCollectionID:GetCollectionID];
}
@end
