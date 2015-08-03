//
//  ProfileViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//
#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "SettingsViewController.h"
//#import "ProgressHUD.h"
#import "FeedDetailViewController.h"
#import "ShowFollowerAndFollowingViewController.h"
#import "FullImageViewController.h"
#import "SubmitProfileViewController.h"
#import <FacebookSDK/FacebookSDK.h>

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MainScroll.frame = CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 49);
    ShowUserWallpaperImage.frame = CGRectMake(0, 0, 320, 174);
    DataUrl = [[UrlDataClass alloc]init];
    SettingBarImage.frame = CGRectMake(0, -64, 320, 64);
    ShowExpertsImg.hidden = YES;
    CheckLoad = NO;
  // [self GetUserWallpaper];
    //[self InitView];
    
    ShowFollowersText.text = CustomLocalisedString(@"FOLLOWERS", nil);
    ShowFollowingText.text = CustomLocalisedString(@"FOLLOWING", nil);
  
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)SettingsButton:(id)sender{
    

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"EditProfilePhoto", nil),CustomLocalisedString(@"EditCoverBackground", nil),CustomLocalisedString(@"SettingsPage_Title", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"EditProfilePhoto", nil)]) {
            NSLog(@"Change profile photo");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SubmitProfileViewController *SubmitProfileView = [[SubmitProfileViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SubmitProfileView animated:NO completion:nil];
            [SubmitProfileView GetType:@"Profile Photo"];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"EditCoverBackground", nil)]) {
            NSLog(@"Change cover photo");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SubmitProfileViewController *SubmitProfileView = [[SubmitProfileViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SubmitProfileView animated:NO completion:nil];
            [SubmitProfileView GetType:@"Cover Photo"];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Title", nil)]) {
            NSLog(@"Settings");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            SettingsViewController *SettingsView = [[SettingsViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SettingsView animated:NO completion:nil];
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }else if(actionSheet.tag == 200){
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"ShareToFacebook", nil)]) {
            NSLog(@"Share to Facebook");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"https://seeties.me/%@",Getusername];
            NSLog(@"message is %@",message);
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
                                               @"", @"caption",
                                               @"", @"description",
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
        if ([buttonTitle isEqualToString:@"Copy Link"]) {
            NSLog(@"Copy Link");
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            NSString *message = [NSString stringWithFormat:@"Check out my profile on Seeties!\n\nhttps://seeties.me/%@",Getusername];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
        }
        
        if ([buttonTitle isEqualToString:@"Cancel Button"]) {
            NSLog(@"Cancel Button");
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{

    self.screenName = @"IOS Profile Page";
    self.title = CustomLocalisedString(@"MainTab_Profile",nil);
    
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckRole = [defaults objectForKey:@"Role"];
    if ([CheckRole isEqualToString:@"user"]) {
    }else{
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        UIImageView *ShowImage = [[UIImageView alloc]init];
        ShowImage.frame = CGRectMake(135, screenHeight - 49, 50, 49);
        ShowImage.image = [UIImage imageNamed:@"TabBarPublish.png"];
        [self.tabBarController.view addSubview:ShowImage];
    }
    
    // Do any additional setup after loading the view from its nib.
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *GetUsername = [defaults objectForKey:@"UserName"];
 //   NSString *GetUserProfilePhoto = [defaults objectForKey:@"UserProfilePhoto"];
//    ShowUsername.text = GetUsername;
    

    
    MainScroll.delegate = self;
    SettingBarImage.hidden = YES;
    
    
    NSString *CheckGetUserProfile = [defaults objectForKey:@"UserData_CheckData"];
    if ([CheckGetUserProfile isEqualToString:@"Done"]) {
       // [self GetUserWallpaper];
        [self GetUserData2];
        
        NSLog(@"done here?");
        NSString *GetUsername = [defaults objectForKey:@"UserData_Username"];
        NSString *Getname = [defaults objectForKey:@"UserData_Name"];
        NSString *GetLocation = [defaults objectForKey:@"UserData_Location"];
        NSString *GetAboutus = [defaults objectForKey:@"UserData_Abouts"];
        NSString *GetUrl = [defaults objectForKey:@"UserData_Url"];
        NSString *GetFollowersCount = [defaults objectForKey:@"UserData_FollowersCount"];
        NSString *GetFollowingCount = [defaults objectForKey:@"UserData_FollowingCount"];
        NSString *GetWallpaper = [defaults objectForKey:@"UserData_Wallpaper"];
        NSString *GetProfilePhoto = [defaults objectForKey:@"UserData_ProfilePhoto"];
        NSString *Getrole = [defaults objectForKey:@"Role"];
        
        if ([Getrole isEqualToString:@"user"]) {
        }else{
          //  [self GetUserPost];
        }
        
        ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
        ShowUserProfileImage.layer.cornerRadius=50;
        ShowUserProfileImage.layer.borderWidth=2.5;
        ShowUserProfileImage.layer.masksToBounds = YES;
        ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
        NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetProfilePhoto];
        NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
        // NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
        if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
            ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
        }else{
            NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserProfileImage.imageURL = url_UserImage;
        }
        
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
        // NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
        NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
        NSURL *url_UserImage = [NSURL URLWithString:GetWallpaper];
        //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowUserWallpaperImage.imageURL = url_UserImage;
        
        
        ShowUsername.text = Getname;

      //  ShowLocation.text = GetLocation;
        ShowAbout.text = GetAboutus;
        
//        [ShowAbout sizeToFit];
//        [ShowAbout setNeedsDisplay];
//        ShowAbout.textAlignment = NSTextAlignmentCenter;
        CGSize size = [ShowAbout sizeThatFits:CGSizeMake(ShowAbout.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = ShowAbout.frame;
        frame.size.height = size.height;
        ShowAbout.frame = frame;
        
        NSLog(@"ShowAbout is %@",ShowAbout);
        ShowUrl.text = GetUrl;
        ShowFollowersCount.text = GetFollowersCount;
        ShowFollowingCount.text = GetFollowingCount;
        NSString *TempString;
        if ([GetLocation isEqualToString:@"(null)"] || [GetLocation length] == 0) {
            ShowMapPin.hidden = YES;
          //  ShowLocation.hidden = YES;
            Showname.frame = CGRectMake(15, 202, 290, 21);
            Showname.textAlignment = NSTextAlignmentCenter;
            TempString = [[NSString alloc]initWithFormat:@"@%@",GetUsername];
        }else{
        TempString = [[NSString alloc]initWithFormat:@"@%@ ∙ %@",GetUsername,GetLocation];
        }
        
        Showname.text = TempString;
        
        if ([GetAboutus isEqualToString:@"(null)"] || [GetAboutus length] == 0) {
            if ([GetUrl isEqualToString:@"(null)"] || [GetUrl length] == 0) {
                if ([Getrole isEqualToString:@"user"]) {
                    ShowExpertsImg.hidden = YES;
                    // ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, 240, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, 240, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, 240, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, 240, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, 231, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, 234, 117, 30);
                    ShowDemo.frame = CGRectMake(139, 240, 42, 21);
                    LinkButton.hidden = YES;
                }else{
                    ShowExpertsImg.hidden = NO;
                    ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, 280, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, 280, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, 280, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, 280, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, 271, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, 274, 117, 30);
                    ShowDemo.frame = CGRectMake(139, 280, 42, 21);
                    LinkButton.hidden = YES;
                    
                    ProfileHeight = 310;
                }
            }else{
                if ([Getrole isEqualToString:@"user"]) {
                    ShowExpertsImg.hidden = YES;
                    // ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                    ShowUrl.frame = CGRectMake(15, 243, 290, 21);
                    LinkButton.frame = CGRectMake(15, 243, 290, 21);
                    ShowFollowersCount.frame = CGRectMake(112, 270, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, 270, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, 270, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, 270, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, 261, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, 264, 117, 30);
                    ShowDemo.frame = CGRectMake(139, 270, 42, 21);
                    
                }else{
                    ShowUrl.frame = CGRectMake(15, 243, 290, 21);
                    LinkButton.frame = CGRectMake(15, 243, 290, 21);
                    ShowExpertsImg.hidden = NO;
                    ShowExpertsImg.frame = CGRectMake(98, 270, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, 320, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, 320, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, 320, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, 320, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, 311, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, 314, 117, 30);
                    ShowDemo.frame = CGRectMake(139, 320, 42, 21);
                    ProfileHeight = 360;
                }
                
            }
            //            ShowExpertsImg.hidden = YES;
            //            ShowFollowersCount.frame = CGRectMake(126, 230, 42, 21);
            //            ShowFollowingCount.frame = CGRectMake(261, 230, 42, 21);
            //            ShowFollowersText.frame = CGRectMake(28, 230, 104, 21);
            //            ShowFollowingText.frame = CGRectMake(172, 230, 88, 21);
            //            ShowFollowersButton.frame = CGRectMake(28, 221, 118, 30);
            //            ShowFollowingButton.frame = CGRectMake(172, 224, 117, 30);
            //            ShowDemo.frame = CGRectMake(136, 230, 42, 21);
        }else{
            if ([GetUrl isEqualToString:@"(null)"] || [GetUrl length] == 0) {
                if ([Getrole isEqualToString:@"user"]) {
                    ShowExpertsImg.hidden = YES;
                    // ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 11, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 14, 117, 30);
                    ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                    LinkButton.hidden = YES;
                    // FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 61, 133, 42);
                }else{
                    ShowExpertsImg.hidden = NO;
                    ShowExpertsImg.frame = CGRectMake(98, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 71, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 74, 117, 30);
                    ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                    LinkButton.hidden = YES;
                    //  FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 121, 133, 42);
                     ProfileHeight = ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 100;
                }
            }else{
                if ([Getrole isEqualToString:@"user"]) {
                    ShowExpertsImg.hidden = YES;
                    ShowUrl.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                    LinkButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                    ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                    ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 37, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 40, 117, 30);
                    ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                    //   FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 87, 133, 42);
                }else{
                    ShowExpertsImg.hidden = NO;
                    
                    
                    ShowUrl.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                    LinkButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                    ShowExpertsImg.frame = CGRectMake(98, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 125, 40);
                    ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                    ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                    ShowFollowersText.frame = CGRectMake(28, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 104, 21);
                    ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 131, 21);
                    ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 97, 118, 30);
                    ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 100, 117, 30);
                    ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                    //  FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 147, 133, 42);
                    
                    
                    ProfileHeight = ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 147;
                }
                
            }
        }
        }else{
        NSLog(@"no done here?");
        [self GetUserData];
    }
    
     //[self GetUserData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
        CGFloat contentOffSet = MainScroll.contentOffset.y;
    if (contentOffSet == 0) {
        
        if (MainScroll.contentOffset.y == 0) {
            SettingBarImage.frame = CGRectMake(0, -64, 320, 64);
            SettingBarImage.hidden = YES;
        }else{
            SettingBarImage.frame = CGRectMake(0, MainScroll.contentOffset.y - 1, 320, 64);
        }
    }else{
        SettingBarImage.hidden = NO;
        if (MainScroll.contentOffset.y > 64) {
            SettingBarImage.frame = CGRectMake(0, 0, 320, 64);
        }else{
            SettingBarImage.frame = CGRectMake(0, -64 + MainScroll.contentOffset.y + 1, 320, 64);
        }
    }


}
-(void)InitView{
    NSLog(@"InitView?");
//    for (UIView * view in MainScroll.subviews) {
//    [view removeFromSuperview];
//    }
    
    if ([LPhotoArray count] == 0) {
        
    }else{
        
        UIImageView *ShowRecommendationTitleImage = [[UIImageView alloc]init];
        ShowRecommendationTitleImage.frame = CGRectMake(0, ProfileHeight, 320, 97);
        ShowRecommendationTitleImage.image = [UIImage imageNamed:@"BarRecommendation.png"];
        
        AsyncImageView *ShowRecommendationBigImage = [[AsyncImageView alloc]init];
        ShowRecommendationBigImage.frame = CGRectMake(0, ProfileHeight + 60, 320, 241);
        ShowRecommendationBigImage.contentMode = UIViewContentModeScaleAspectFill;
        ShowRecommendationBigImage.backgroundColor = [UIColor clearColor];
        ShowRecommendationBigImage.clipsToBounds = YES;
        ShowRecommendationBigImage.tag = 999;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowRecommendationBigImage];
        //   ShowRecommendationBigImage.image = [UIImage imageNamed:@"ImgSample.png"];
        NSURL *url_NearbyBig = [NSURL URLWithString:[LPhotoArray objectAtIndex:0]];
        NSLog(@"url_NearbyBig is %@",url_NearbyBig);
        ShowRecommendationBigImage.imageURL = url_NearbyBig;
        
        
        UIImageView *ShowLocationImage = [[UIImageView alloc]init];
        ShowLocationImage.frame = CGRectMake(15, ProfileHeight + 321, 8, 12);
        ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
        
        UILabel *ShowLocationLabel = [[UILabel alloc]init];
        ShowLocationLabel.frame = CGRectMake(35, ProfileHeight + 317, 250, 20);
        ShowLocationLabel.text = [LocationArray objectAtIndex:0];
        ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
        
        UILabel *ShowTitleLabel = [[UILabel alloc]init];
        ShowTitleLabel.frame = CGRectMake(15, ProfileHeight + 353, 290, 30);
        ShowTitleLabel.text = [TitleArray objectAtIndex:0];
        ShowTitleLabel.numberOfLines = 2;
        ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
        ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
        ShowTitleLabel.textColor = [UIColor blackColor];
        ShowTitleLabel.backgroundColor = [UIColor clearColor];
        
        
        UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
        [Line01 setTitle:@"" forState:UIControlStateNormal];
        [Line01 setFrame:CGRectMake(0, ProfileHeight + 403, 320, 1)];//129
        [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
        
        UIButton *BigButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
        [BigButton_Nearby setTitle:@"" forState:UIControlStateNormal];
        [BigButton_Nearby setFrame:CGRectMake(0, ProfileHeight, 320, 260)];
        [BigButton_Nearby setBackgroundColor:[UIColor clearColor]];
        [BigButton_Nearby addTarget:self action:@selector(BigButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [MainScroll addSubview:ShowRecommendationBigImage];
        [MainScroll addSubview:ShowRecommendationTitleImage];
        [MainScroll addSubview:ShowLocationLabel];
        [MainScroll addSubview:ShowLocationImage];
        [MainScroll addSubview:ShowTitleLabel];
        [MainScroll addSubview:Line01];
        [MainScroll addSubview:BigButton_Nearby];
        
        int height_Recommendation = 0;
        
        for (int i = DataCount; i < DataTotal; i++) {
            AsyncImageView *ShowNearbySmallImage = [[AsyncImageView alloc]init];
            ShowNearbySmallImage.frame = CGRectMake(200, (ProfileHeight + 274) + i * 145, 100 , 100);
            ShowNearbySmallImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowNearbySmallImage.backgroundColor = [UIColor clearColor];
            ShowNearbySmallImage.clipsToBounds = YES;
            ShowNearbySmallImage.tag = 99;
            ShowNearbySmallImage.image = [UIImage imageNamed:@"NoImage.png"];
            // [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowNearbySmallImage];
            NSURL *url_NearbySmall = [NSURL URLWithString:[LPhotoArray objectAtIndex:i]];
            //NSLog(@"url is %@",url);
            ShowNearbySmallImage.imageURL = url_NearbySmall;
            //ShowNearbySmallImage.image = [UIImage imageNamed:@"ImgSample.png"];
            
            UIImageView *ShowLocationImage = [[UIImageView alloc]init];
            ShowLocationImage.frame = CGRectMake(15, (ProfileHeight + 274) + i * 145, 8, 12);
            ShowLocationImage.image = [UIImage imageNamed:@"LocationPin.png"];
            
            UILabel *ShowLocationLabel = [[UILabel alloc]init];
            ShowLocationLabel.frame = CGRectMake(35, (ProfileHeight + 270) + i * 145, 160, 20);
            ShowLocationLabel.text = [LocationArray objectAtIndex:i];
            ShowLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
            ShowLocationLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0];
            
            UILabel *ShowTitleLabel = [[UILabel alloc]init];
            ShowTitleLabel.frame = CGRectMake(15, (ProfileHeight + 306) + i * 145, 170, 50);
            ShowTitleLabel.text = [TitleArray objectAtIndex:i];
            ShowTitleLabel.numberOfLines = 2;
            ShowTitleLabel.textAlignment = NSTextAlignmentLeft;
            ShowTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
            ShowTitleLabel.textColor = [UIColor blackColor];
            ShowTitleLabel.backgroundColor = [UIColor clearColor];
            
            
            UIButton *Line01 = [UIButton buttonWithType:UIButtonTypeCustom];
            [Line01 setTitle:@"" forState:UIControlStateNormal];
            [Line01 setFrame:CGRectMake(0, (ProfileHeight + 396) + i * 145, 320, 1)];
            [Line01 setBackgroundColor:[UIColor colorWithRed:239.0/255.0f green:239.0/255.0f blue:244.0/255.0f alpha:1.0]];
            
            UIButton *SmallButton_Nearby = [UIButton buttonWithType:UIButtonTypeCustom];
            [SmallButton_Nearby setTitle:@"" forState:UIControlStateNormal];
            [SmallButton_Nearby setFrame:CGRectMake(10, (ProfileHeight + 274) + i * 145, 300 , 100)];
            [SmallButton_Nearby setBackgroundColor:[UIColor clearColor]];
            SmallButton_Nearby.tag = i;
            [SmallButton_Nearby addTarget:self action:@selector(SmallButton_Nearby:) forControlEvents:UIControlEventTouchUpInside];
            
            height_Recommendation = (ProfileHeight + 274) + i * 145;
            
            [MainScroll addSubview:ShowNearbySmallImage];
            [MainScroll addSubview:ShowLocationLabel];
            [MainScroll addSubview:ShowLocationImage];
            [MainScroll addSubview:ShowTitleLabel];
            [MainScroll addSubview:Line01];
            [MainScroll addSubview:SmallButton_Nearby];
            
            
            // [MainScroll setContentSize:CGSizeMake(320, 800)];
        }
        
        //    UIButton *SeeMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //    [SeeMoreButton setImage:[UIImage imageNamed:@"SeeMore.png"] forState:UIControlStateNormal];
        //    [SeeMoreButton setFrame:CGRectMake(104, height_Recommendation + 10, 112, 51)];
        //    [SeeMoreButton setBackgroundColor:[UIColor clearColor]];
        //
        //    UIImageView *ShowCollectionTitleImage = [[UIImageView alloc]init];
        //    ShowCollectionTitleImage.frame = CGRectMake(0, height_Recommendation + 75, 320, 83);
        //    ShowCollectionTitleImage.image = [UIImage imageNamed:@"BarCollection.png"];
        //    
        //    [MainScroll addSubview:SeeMoreButton];
        
        
        
        [MainScroll setScrollEnabled:YES];
        MainScroll.backgroundColor = [UIColor whiteColor];
        // [MainScroll setContentSize:CGSizeMake(320, height_Collection + 190)];
        if ([TitleArray count] == 1) {
            [MainScroll setContentSize:CGSizeMake(320, height_Recommendation + 810)];
        }else{
            [MainScroll setContentSize:CGSizeMake(320, height_Recommendation + 150)];
        }

    }
      // [MainScroll setContentSize:CGSizeMake(320, height_Recommendation + 150)];
}
-(void)GetUserWallpaper{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    //https://dev-api.seeties.me/eb2ec552c5b10448c4d447d9beb62743/wallpaper/l?token=JDJ5JDA4JFhCTFhDYVNZZ2xqZElLRXBnRVYya3VwdE00ZkFsWkJSU21SdXU3YUhwYS94SUNJeTU4dzJT
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/wallpaper/l?token=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
   // NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
    NSLog(@"User Wallpaper FullString ====== %@",FullString);
    NSURL *url_UserImage = [NSURL URLWithString:FullString];
    //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
    ShowUserWallpaperImage.imageURL = url_UserImage;
    
 //   [self GetUserPost];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height)
    {
        // we are at the end
        NSLog(@"we are at the end");
        if (CheckLoad == YES) {
            
        }else{
            [self GetMoreYourLike];
            CheckLoad = YES;
        }
    }
}
-(void)GetUserPost{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/posts?token=%@",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetPost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetPost start];
    
    
    if( theConnection_GetPost ){
        webData = [NSMutableData data];
    }
}
-(void)GetMoreYourLike{
    NSLog(@"GetMoreYourLike");
    if (CurrentPage == TotalPage) {
        
    }else{
        CurrentPage += 1;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
        NSString *Getuid = [defaults objectForKey:@"Useruid"];
        NSString *FullString = [[NSString alloc]initWithFormat:@"%@%@/posts?token=%@&page=%li",DataUrl.UserWallpaper_Url,Getuid,GetExpertToken,(long)CurrentPage];
        
        
        NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
        NSLog(@"check postBack URL ==== %@",postBack);
        // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURL *url = [NSURL URLWithString:postBack];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"theRequest === %@",theRequest);
        [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
        
        theConnection_MorePost = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
        [theConnection_MorePost start];
        
        
        if( theConnection_MorePost ){
            webData = [NSMutableData data];
        }
    }
    
    
}
-(void)GetUserData{
    CheckDataReload = 1;
   // [ProgressHUD show:CustomLocalisedString(@"PleaseWait", nil)];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@expert/%@",DataUrl.UserWallpaper_Url,GetUsername];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetUserData check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetUserData start];
    
    
    if( theConnection_GetUserData ){
        webData = [NSMutableData data];
    }

}
-(void)GetUserData2{
    CheckDataReload += 1;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername = [defaults objectForKey:@"UserName"];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@expert/%@",DataUrl.UserWallpaper_Url,GetUsername];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"GetUserData check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetUserData = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetUserData start];
    
    
    if( theConnection_GetUserData ){
        webData = [NSMutableData data];
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   // [ProgressHUD showError:@"Something went wrong."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_GetPost) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
       // NSLog(@"User Post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
      //  NSLog(@"Feed Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSString *countString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
            NSLog(@"countString is %@",countString);
            if ([countString isEqualToString:@"0"]) {
                [self Initview_NoData];
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSString *page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"page"]];
                NSLog(@"page is %@",page);
                NSString *total_page = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"total_page"]];
                NSLog(@"total_page is %@",total_page);
                CurrentPage = [page intValue];
                TotalPage = [total_page intValue];
                NSLog(@"CurrentPage = %i",CurrentPage);
                NSLog(@"TotalPage = %i",TotalPage);
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
                //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                //  NSLog(@"titleData is %@",titleData);
               // NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                // NSLog(@"messageData is %@",messageData);
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                //  NSLog(@"locationData is %@",locationData_Nearby);
                NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
                //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
               // NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
               // NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
                //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                
                
//                CategoryArray = [[NSMutableArray alloc] initWithCapacity:[SingleLine count]];
//                for (NSDictionary * dict in SingleLine) {
//                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                    [CategoryArray addObject:username];
//                }
                //   NSLog(@"CategoryArray_Nearby is %@",CategoryArray_Nearby);
                UserInfo_NameArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                UserInfo_AddressArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                UserInfo_UrlArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                UserInfo_FollowingArray = [[NSMutableArray alloc] initWithCapacity:[UserInfoData count]];
                for (NSDictionary * dict in UserInfoData) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                    [UserInfo_NameArray addObject:username];
                    NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                    [UserInfo_AddressArray addObject:location];
                    NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    [UserInfo_uidArray addObject:uid];
                    NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                    [UserInfo_FollowingArray addObject:following];
                }
                //NSLog(@"UserInfo_NameArray_Nearby is %@",UserInfo_NameArray_Nearby);
                //NSLog(@"UserInfo_AddressArray_Nearby is %@",UserInfo_AddressArray_Nearby);
                
                UserInfo_UrlArray = [[NSMutableArray alloc]initWithCapacity:[UserInfoData_ProfilePhoto count]];
                for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                    [UserInfo_UrlArray addObject:url];
                }
                //  NSLog(@"UserInfo_UrlArray_Nearby is %@",UserInfo_UrlArray_Nearby);
                
                TitleArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
                LangArray = [[NSMutableArray alloc]initWithCapacity:[titleData count]];
                for (NSDictionary * dict in titleData) {
                    if ([dict count] == 0 || dict == nil || [dict objectForKey:@"530b0ab26424400c76000003"] == nil) {
                        NSLog(@"titleData nil");
                        [TitleArray addObject:@"nil"];
                        [LangArray addObject:@"nil"];
                    }else{
                    
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    NSString *ThaiTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"544481503efa3ff1588b4567"]];
                    NSString *IndonesianTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"53672e863efa3f857f8b4ed2"]];
                    NSString *PhilippinesTitle = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"539fbb273efa3fde3f8b4567"]];
                    NSLog(@"Title1 is %@",Title1);
                    NSLog(@"Title2 is %@",Title2);
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        if ([Title2 length] == 0 || Title2 == nil || [Title2 isEqualToString:@"(null)"]) {
                            if ([ThaiTitle length] == 0 || ThaiTitle == nil || [ThaiTitle isEqualToString:@"(null)"]) {
                                if ([IndonesianTitle length] == 0 || IndonesianTitle == nil || [IndonesianTitle isEqualToString:@"(null)"]) {
                                    if ([PhilippinesTitle length] == 0 || PhilippinesTitle == nil || [PhilippinesTitle isEqualToString:@"(null)"]) {
                                        
                                    }else{
                                        [TitleArray addObject:PhilippinesTitle];
                                        [LangArray addObject:@"CN"];
                                    }
                                }else{
                                    [TitleArray addObject:IndonesianTitle];
                                    [LangArray addObject:@"CN"];
                                }
                            }else{
                                [TitleArray addObject:ThaiTitle];
                                [LangArray addObject:@"CN"];
                            }
                        }else{
                            [TitleArray addObject:Title2];
                            [LangArray addObject:@"EN"];
                        }
                        
                    }else{
                        [TitleArray addObject:Title1];
                        [LangArray addObject:@"CN"];
                        
                    }
                    }}
                //NSLog(@"TitleArray_Nearby is %@",TitleArray_Nearby);
                
//                MessageArray = [[NSMutableArray alloc]initWithCapacity:[messageData count]];
//                for (NSDictionary * dict in messageData) {
//                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
//                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
//                    
//                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
//                        [MessageArray addObject:Title2];
//                    }else{
//                        [MessageArray addObject:Title1];
//                    }
//                }
                LocationArray = [[NSMutableArray alloc]initWithCapacity:[locationData_Address count]];
                LatArray = [[NSMutableArray alloc]initWithCapacity:[locationData count]];
                LongArray = [[NSMutableArray alloc]initWithCapacity:[locationData count]];
                for (NSDictionary * dict in locationData) {
                    NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                    [LatArray addObject:lat];
                    NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                    [LongArray addObject:lng];
                }
                
                for (NSDictionary * dict in locationData_Address) {
                    NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                    NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                    NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                    NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                    NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                    NSString *FullString;
                    if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                        if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                            if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                    FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                        }
                    }else{
                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                    }
                    
                    NSLog(@"Locality is %@",Locality);
                    NSLog(@"Address3 is %@",Address3);
                    NSLog(@"Address2 is %@",Address2);
                    NSLog(@"Address1 is %@",Address1);
                    NSLog(@"Country is %@",Country);
                    
                    //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                    [LocationArray addObject:FullString];
                }
                // NSLog(@"LocationArray_Nearby is %@",LocationArray_Nearby);
                NSLog(@"LatArray_Nearby is %@",LatArray);
                NSLog(@"LongArray_Nearby is %@",LongArray);
                place_nameArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
                LPhotoArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
                LikesArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
                CommentArray = [[NSMutableArray alloc] initWithCapacity:[GetAllData count]];
                PostIDArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                CheckLikeArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                FullPhotoArray = [[NSMutableArray alloc]init];
                LinkArray = [[NSMutableArray alloc]initWithCapacity:[GetAllData count]];
                
                
                Activities_profile_photoArray = [[NSMutableArray alloc]init];
                Activities_uidArray = [[NSMutableArray alloc]init];
                Activities_typeArray = [[NSMutableArray alloc]init];
                Activities_usernameArray = [[NSMutableArray alloc]init];
                
                
                
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                for (NSDictionary * dict in GetAllData){
                    NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [place_nameArray addObject:place_name];
                    NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                    [LikesArray addObject:total_like];
                    NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                    [CommentArray addObject:total_comments];
                    NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostIDArray addObject:post_id];
                    NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                    [CheckLikeArray addObject:like];
                    NSString *link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                    [LinkArray addObject:link];
                    
                    //
                    NSDictionary *Activities = [dict valueForKey:@"activities"];
                    NSLog(@"Activities is %@",Activities);
                    
                    
                    if ([Activities count] == 0){
                        
                        //TheDict is null
                        NSLog(@"Activities_Nearby is nil");
                        [Activities_profile_photoArray addObject:@"nil"];
                        [Activities_typeArray addObject:@"nil"];
                        [Activities_uidArray addObject:@"nil"];
                        [Activities_usernameArray addObject:@"nil"];
                    }
                    else{
                        //TheDict is not null
                        NSLog(@"Activities_Nearby is not nil");
                        NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict in Activities){
                            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                            [testarray_Photo addObject:profile_photo];
                            // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                            NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                            //[Activities_typeArray_Nearby addObject:type];
                            [testarray_type addObject:type];
                            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                            // [Activities_uidArray_Nearby addObject:uid];
                            [testarray_uid addObject:uid];
                            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                            // [Activities_usernameArray_Nearby addObject:username];
                            [testarray_username addObject:username];
                        }
                        NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                        [Activities_profile_photoArray addObject:result_Photo];
                        NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                        [Activities_typeArray addObject:result_Type];
                        NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                        [Activities_uidArray addObject:result_Uid];
                        NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                        [Activities_usernameArray addObject:result_Username];
                    }
                    
                    
                    
                    
                    
                    //  NSLog(@"Activities_profile_photoArray_Nearby is %@",Activities_profile_photoArray_Nearby);
                    
                    
                    
                    NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                    //  NSLog(@"photos is %@",photos);
                    // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                    // NSLog(@"photos is %@", photos);
                    NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                    //  NSLog(@"SplitArray is %@",SplitArray);
                    NSString *GetSplitString;
                    if ([SplitArray count] > 1) {
                        GetSplitString = [SplitArray objectAtIndex: 1];
                        NSMutableArray *testarray = [[NSMutableArray alloc]init];
                        for (int i = 0; i < [SplitArray count]; i++) {
                            NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                            
                            if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                            } else {
                                //  NSLog(@"Get GetData is %@",GetData);
                                NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                [testarray addObject:FinalString];
                            }
                        }
                        //   NSLog(@"testarray is %@",testarray);
                        NSString * result = [testarray componentsJoinedByString:@","];
                        [FullPhotoArray addObject:result];
                    }else{
                        GetSplitString = @"";
                    }
                    
                    NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                    //NSLog(@"SplitArray2 is %@",SplitArray2);
                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                    
                    [LPhotoArray addObject:FinalString];
                }
                DataCount = 1;
                DataTotal = (int)[TitleArray count];
                [self InitView];

                
            }
            //   NSLog(@"LikesArray = %@",LikesArray);
          
                
            

        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *CheckGetUserProfile = [defaults objectForKey:@"UserData_CheckData"];
        if ([CheckGetUserProfile isEqualToString:@"Done"]) {
        }else{
       // [ProgressHUD showSuccess:@""];
      //      [ProgressHUD dismiss];
        }
        

    }else if(connection == theConnection_GetUserData){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"User Data return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"res is %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSString *GetName = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
            NSLog(@"GetName is %@",GetName);
            Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
            NSLog(@"GetLocation is %@",GetLocation);
            NSString *GetAbouts = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"GetAbouts is %@",GetAbouts);
            NSString *GetUrl = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"personal_link"]];
            NSLog(@"GetUrl is %@",GetUrl);
            NSString *GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"follower_count"]];
            NSLog(@"GetFollowersCount is %@",GetFollowersCount);
            NSString *GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"following_count"]];
            NSLog(@"GetFollowingCount is %@",GetFollowingCount);
            NSString *Getcategories = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"categories"]];
            NSLog(@"Getcategories is %@",Getcategories);
            NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            NSString *GetGender = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
            NSLog(@"GetGender is %@",GetGender);
            NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"profile_photo"]];
            NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            NSString *Getrole = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"role"]];
            NSLog(@"Getrole is %@",Getrole);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
            
            NSDictionary *WallpaperData = [res valueForKey:@"wallpaper"];
            NSString *GetWallpaper = [[NSString alloc]initWithFormat:@"%@",[WallpaperData objectForKey:@"s"]];
            NSLog(@"GetWallpaper is %@",GetWallpaper);
            
            NSDictionary *LanguageData = [res valueForKey:@"languages"];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in LanguageData) {
                NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                [TempArray addObject:GetLanguage_1];
            }
            NSLog(@"TempArray is %@",TempArray);
            NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
            NSString *GetLanguage_2;
            if ([TempArray count] == 1) {
                GetLanguage_2 = @"";
            }else{
                GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
            }
            
            ShowUsername.text = GetName;
            
           // ShowLocation.text = GetLocation;
            ShowAbout.text = GetAbouts;
//            [ShowAbout sizeToFit];
//            [ShowAbout setNeedsDisplay];
            CGSize size = [ShowAbout sizeThatFits:CGSizeMake(ShowAbout.frame.size.width, CGFLOAT_MAX)];
            CGRect frame = ShowAbout.frame;
            frame.size.height = size.height;
            ShowAbout.frame = frame;
            
            NSLog(@"ShowAbout is %@",ShowAbout);
            
            ShowUrl.text = GetUrl;
            ShowFollowersCount.text = GetFollowersCount;
            ShowFollowingCount.text = GetFollowingCount;
            ShowUserProfileImage.contentMode = UIViewContentModeScaleAspectFill;
            ShowUserProfileImage.layer.backgroundColor=[[UIColor clearColor] CGColor];
            ShowUserProfileImage.layer.cornerRadius=50;
            ShowUserProfileImage.layer.borderWidth=2.5;
            ShowUserProfileImage.layer.masksToBounds = YES;
            ShowUserProfileImage.layer.borderColor=[[UIColor whiteColor] CGColor];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserProfileImage];
            NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",Getprofile_photo];
            NSLog(@"FullImagesURL1 ====== %@",FullImagesURL1);
            // NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
            if ([FullImagesURL1 length] == 0 || [FullImagesURL1 isEqualToString:@"null"] || [FullImagesURL1 isEqualToString:@"<null>"]) {
                ShowUserProfileImage.image = [UIImage imageNamed:@"avatar.png"];
            }else{
                NSURL *url_UserImage = [NSURL URLWithString:FullImagesURL1];
                //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
                ShowUserProfileImage.imageURL = url_UserImage;
            }
            
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:ShowUserWallpaperImage];
            // NSString *FullImagesURL1 = [[NSString alloc]initWithFormat:@"%@",GetUserProfilePhoto];
            NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
            NSURL *url_UserImage = [NSURL URLWithString:GetWallpaper];
            //NSLog(@"url_NearbyBig is %@",url_NearbyBig);
            ShowUserWallpaperImage.imageURL = url_UserImage;
            
            NSString *TempString;
            if ([GetLocation isEqualToString:@"(null)"] || [GetLocation length] == 0) {
                ShowMapPin.hidden = YES;
              //  ShowLocation.hidden = YES;
                Showname.frame = CGRectMake(15, 202, 290, 21);
                Showname.textAlignment = NSTextAlignmentCenter;
                TempString = [[NSString alloc]initWithFormat:@"@%@",Getusername];
            }else{
                TempString = [[NSString alloc]initWithFormat:@"@%@ ∙ %@",Getusername,GetLocation];
            }
            Showname.text = TempString;
            
            if ([GetAbouts isEqualToString:@"(null)"] || [GetAbouts length] == 0) {
                if ([GetUrl isEqualToString:@"(null)"] || [GetUrl length] == 0) {
                    if ([Getrole isEqualToString:@"user"]) {
                        ShowExpertsImg.hidden = YES;
                        // ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, 240, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, 240, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, 240, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, 240, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, 231, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, 234, 117, 30);
                        ShowDemo.frame = CGRectMake(139, 240, 42, 21);
                        LinkButton.hidden = YES;
                    }else{
                        ShowExpertsImg.hidden = NO;
                        ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, 280, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, 280, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, 280, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, 280, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, 271, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, 274, 117, 30);
                        ShowDemo.frame = CGRectMake(139, 280, 42, 21);
                        LinkButton.hidden = YES;
                        ProfileHeight = 320;
                    }
                }else{
                    if ([Getrole isEqualToString:@"user"]) {
                        ShowExpertsImg.hidden = YES;
                        ShowUrl.frame = CGRectMake(15, 243, 290, 21);
                        LinkButton.frame = CGRectMake(15, 243, 290, 21);
                        ShowFollowersCount.frame = CGRectMake(112, 270, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, 270, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, 270, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, 270, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, 261, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, 264, 117, 30);
                        ShowDemo.frame = CGRectMake(139, 270, 42, 21);
                    }else{
                        ShowUrl.frame = CGRectMake(15, 243, 290, 21);
                        LinkButton.frame = CGRectMake(15, 243, 290, 21);
                        ShowExpertsImg.hidden = NO;
                        ShowExpertsImg.frame = CGRectMake(98, 270, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, 320, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, 320, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, 320, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, 320, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, 311, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, 314, 117, 30);
                        ShowDemo.frame = CGRectMake(139, 320, 42, 21);
                        
                        ProfileHeight = 360;
                    }
                    
                }
                //            ShowExpertsImg.hidden = YES;
                //            ShowFollowersCount.frame = CGRectMake(126, 230, 42, 21);
                //            ShowFollowingCount.frame = CGRectMake(261, 230, 42, 21);
                //            ShowFollowersText.frame = CGRectMake(28, 230, 104, 21);
                //            ShowFollowingText.frame = CGRectMake(172, 230, 88, 21);
                //            ShowFollowersButton.frame = CGRectMake(28, 221, 118, 30);
                //            ShowFollowingButton.frame = CGRectMake(172, 224, 117, 30);
                //            ShowDemo.frame = CGRectMake(136, 230, 42, 21);
            }else{
                if ([GetUrl isEqualToString:@"(null)"] || [GetUrl length] == 0) {
                    if ([Getrole isEqualToString:@"user"]) {
                        ShowExpertsImg.hidden = YES;
                        // ShowExpertsImg.frame = CGRectMake(98, 230, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 11, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 14, 117, 30);
                        ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 42, 21);
                        LinkButton.hidden = YES;
                       // FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 61, 133, 42);
                    }else{
                        ShowExpertsImg.hidden = NO;
                        ShowExpertsImg.frame = CGRectMake(98, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 20, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 71, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 74, 117, 30);
                        ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 80, 42, 21);
                        LinkButton.hidden = YES;
                      //  FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 121, 133, 42);
                        ProfileHeight = ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 100;
                    }
                }else{
                    if ([Getrole isEqualToString:@"user"]) {
                        ShowExpertsImg.hidden = YES;
                        ShowUrl.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                        LinkButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                        ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                        ShowFollowersText.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 37, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 40, 117, 30);
                        ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 42, 21);
                     //   FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 87, 133, 42);
                    }else{
                        ShowExpertsImg.hidden = NO;
                        
                        
                        ShowUrl.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                        LinkButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 5, 290, 21);
                        ShowExpertsImg.frame = CGRectMake(98, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 46, 125, 40);
                        ShowFollowersCount.frame = CGRectMake(112, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                        ShowFollowingCount.frame = CGRectMake(263, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                        ShowFollowersText.frame = CGRectMake(28, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 104, 21);
                        ShowFollowingText.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 131, 21);
                        ShowFollowersButton.frame = CGRectMake(15, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 97, 118, 30);
                        ShowFollowingButton.frame = CGRectMake(172, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 100, 117, 30);
                        ShowDemo.frame = CGRectMake(139, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 106, 42, 21);
                      //  FollowButton.frame = CGRectMake(91, ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 147, 133, 42);
                        
                        
                        ProfileHeight = ShowAbout.frame.origin.y + ShowAbout.frame.size.height + 147;
                    }
                    
                }
                
            }
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *CheckGetUserProfile_ = [defaults objectForKey:@"UserData_CheckData"];
            if ([CheckGetUserProfile_ isEqualToString:@"Done"]) {
            }else{
               // [ProgressHUD showSuccess:@""];
         //       [ProgressHUD dismiss];
            }
            
            NSString *CheckGetUserProfile = @"Done";
           // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
            [defaults setObject:Getprofile_photo forKey:@"UserData_ProfilePhoto"];
            [defaults setObject:Getcategories forKey:@"UserData_Categories"];
            [defaults setObject:GetName forKey:@"UserData_Name"];
            [defaults setObject:Getusername forKey:@"UserData_Username"];
            [defaults setObject:GetAbouts forKey:@"UserData_Abouts"];
            [defaults setObject:GetUrl forKey:@"UserData_Url"];
            [defaults setObject:Getemail forKey:@"UserData_Email"];
            [defaults setObject:GetLocation forKey:@"UserData_Location"];
            [defaults setObject:Getdob forKey:@"UserData_dob"];
            [defaults setObject:GetGender forKey:@"UserData_Gender"];
            [defaults setObject:GetWallpaper forKey:@"UserData_Wallpaper"];
            [defaults setObject:GetSystemLanguage forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults setObject:GetFollowersCount forKey:@"UserData_FollowersCount"];
            [defaults setObject:GetFollowingCount forKey:@"UserData_FollowingCount"];
            [defaults setObject:Getrole forKey:@"Role"];
            [defaults synchronize];
            
            //[self GetUserWallpaper];
            
            if (CheckDataReload == 1) {
             //  [self GetUserPost];
            }else{
                
            }

        }
        
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        // NSLog(@"User Post return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        //  NSLog(@"Feed Json = %@",res);
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [ShowAlert show];
        }else{
            NSString *countString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"count"]];
            NSLog(@"countString is %@",countString);
            if ([countString isEqualToString:@"0"]) {
                [self Initview_NoData];
            }else{
                NSArray *GetAllData = (NSArray *)[res valueForKey:@"data"];
                NSLog(@"GetAllData ===== %@",GetAllData);
                
                NSDictionary *UserInfoData = [GetAllData valueForKey:@"user_info"];
                //  NSLog(@"UserInfoData_Nearby is %@",UserInfoData_Nearby);
                NSDictionary *UserInfoData_ProfilePhoto = [UserInfoData valueForKey:@"profile_photo"];
                //   NSLog(@"UserInfoData_Nearby_ProfilePhoto is %@",UserInfoData_Nearby_ProfilePhoto);
                // NSLog(@"UserInfoData_ProfilePhoto count = %i",[UserInfoData_ProfilePhoto count]);
                NSDictionary *titleData = [GetAllData valueForKey:@"title"];
                //  NSLog(@"titleData is %@",titleData);
                NSDictionary *messageData = [GetAllData valueForKey:@"message"];
                // NSLog(@"messageData is %@",messageData);
                NSDictionary *locationData = [GetAllData valueForKey:@"location"];
                //  NSLog(@"locationData is %@",locationData_Nearby);
                NSDictionary *locationData_Address = [locationData valueForKey:@"address_components"];
                //  NSLog(@"locationData_Address is %@",locationData_Address_Nearby);
                NSDictionary *CategoryMeta = [GetAllData valueForKey:@"category_meta"];
                NSDictionary *SingleLine = [CategoryMeta valueForKey:@"single_line"];
                //  NSLog(@"SingleLine_Nearby is %@",SingleLine_Nearby);
                for (NSDictionary * dict in SingleLine) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    [CategoryArray addObject:username];
                }
                for (NSDictionary * dict in UserInfoData) {
                    NSString *username = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"username"]];
                    [UserInfo_NameArray addObject:username];
                    NSString *location = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"location"]];
                    [UserInfo_AddressArray addObject:location];
                    NSString *uid = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"uid"]];
                    [UserInfo_uidArray addObject:uid];
                    NSString *following = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"following"]];
                    [UserInfo_FollowingArray addObject:following];
                }
                for (NSDictionary * dict in UserInfoData_ProfilePhoto) {
                    NSString *url = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"url"]];
                    [UserInfo_UrlArray addObject:url];
                }

                for (NSDictionary * dict in titleData) {
                    NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                    NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                    
                    if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                        [TitleArray addObject:Title2];
                        [LangArray addObject:@"EN"];
                    }else{
                        [TitleArray addObject:Title1];
                        [LangArray addObject:@"CN"];
                    }
                }
                for (NSDictionary * dict in messageData) {
                    if ([dict count] == 0 || dict == nil || [dict objectForKey:@"530b0ab26424400c76000003"] == nil) {
                        NSLog(@"titleData nil");
                        [MessageArray addObject:@"nil"];
                    }else{
                        NSString *Title1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0aa16424400c76000002"]];
                        NSString *Title2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
                        
                        if ([Title1 length] == 0 || Title1 == nil || [Title1 isEqualToString:@"(null)"]) {
                            [MessageArray addObject:Title2];
                        }else{
                            [MessageArray addObject:Title1];
                        }
                    }
 
                }
                for (NSDictionary * dict in locationData) {
                    NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lat"]];
                    [LatArray addObject:lat];
                    NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"lng"]];
                    [LongArray addObject:lng];
                }
                
                for (NSDictionary * dict in locationData_Address) {
                    NSString *Locality = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"locality"]];
                    NSString *Address3 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_3"]];
                    NSString *Address2 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_2"]];
                    NSString *Address1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"administrative_area_level_1"]];
                    NSString *Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"country"]];
                    NSString *FullString;
                    if ([Locality length] == 0 || Locality == nil || [Locality isEqualToString:@"(null)"]) {
                        if([Address3 length] == 0 || Address3 == nil || [Address3 isEqualToString:@"(null)"]){
                            if ([Address2 length] == 0 || Address2 == nil || [Address2 isEqualToString:@"(null)"]) {
                                if ([Address1 length] == 0 || Address1 == nil || [Address1 isEqualToString:@"(null)"]) {
                                    FullString = [[NSString alloc]initWithFormat:@"%@",Country];
                                }else{
                                    FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                                }
                            }else{
                                FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address2,Country];
                            }
                        }else{
                            FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address3,Country];
                        }
                    }else{
                        FullString = [[NSString alloc]initWithFormat:@"%@, %@",Locality,Country];
                    }
                    
                    NSLog(@"Locality is %@",Locality);
                    NSLog(@"Address3 is %@",Address3);
                    NSLog(@"Address2 is %@",Address2);
                    NSLog(@"Address1 is %@",Address1);
                    NSLog(@"Country is %@",Country);
                    
                    //  NSString *FullString = [[NSString alloc]initWithFormat:@"%@, %@",Address1,Country];
                    [LocationArray addObject:FullString];
                }
                
                
                
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                for (NSDictionary * dict in GetAllData){
                    NSString *place_name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"place_name"]];
                    [place_nameArray addObject:place_name];
                    NSString *total_like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_like"]];
                    [LikesArray addObject:total_like];
                    NSString *total_comments =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"total_comments"]];
                    [CommentArray addObject:total_comments];
                    NSString *post_id =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_id"]];
                    [PostIDArray addObject:post_id];
                    NSString *like =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"like"]];
                    [CheckLikeArray addObject:like];
                    NSString *link =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"link"]];
                    [LinkArray addObject:link];
                    
                    //
                    NSDictionary *Activities = [dict valueForKey:@"activities"];
                    NSLog(@"Activities is %@",Activities);
                    
                    
                    if ([Activities count] == 0){
                        
                        //TheDict is null
                        NSLog(@"Activities_Nearby is nil");
                        [Activities_profile_photoArray addObject:@"nil"];
                        [Activities_typeArray addObject:@"nil"];
                        [Activities_uidArray addObject:@"nil"];
                        [Activities_usernameArray addObject:@"nil"];
                    }
                    else{
                        //TheDict is not null
                        NSLog(@"Activities_Nearby is not nil");
                        NSMutableArray *testarray_Photo = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_type = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_uid = [[NSMutableArray alloc]init];
                        NSMutableArray *testarray_username = [[NSMutableArray alloc]init];
                        for (NSDictionary * dict in Activities){
                            NSString *profile_photo =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"profile_photo"]];
                            [testarray_Photo addObject:profile_photo];
                            // [Activities_profile_photoArray_Nearby addObject:profile_photo];
                            NSString *type =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"type"]];
                            //[Activities_typeArray_Nearby addObject:type];
                            [testarray_type addObject:type];
                            NSString *uid =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
                            // [Activities_uidArray_Nearby addObject:uid];
                            [testarray_uid addObject:uid];
                            NSString *username =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"username"]];
                            // [Activities_usernameArray_Nearby addObject:username];
                            [testarray_username addObject:username];
                        }
                        NSString *result_Photo = [testarray_Photo componentsJoinedByString:@","];
                        [Activities_profile_photoArray addObject:result_Photo];
                        NSString *result_Type = [testarray_type componentsJoinedByString:@","];
                        [Activities_typeArray addObject:result_Type];
                        NSString *result_Uid = [testarray_uid componentsJoinedByString:@","];
                        [Activities_uidArray addObject:result_Uid];
                        NSString *result_Username = [testarray_username componentsJoinedByString:@","];
                        [Activities_usernameArray addObject:result_Username];
                    }
                    
                    
                    
                    
                    
                    //  NSLog(@"Activities_profile_photoArray_Nearby is %@",Activities_profile_photoArray_Nearby);
                    
                    
                    
                    NSString *photos =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"photos"]];
                    //  NSLog(@"photos is %@",photos);
                    // NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"\n(){};\"\" "];
                    photos = [[photos componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                    // NSLog(@"photos is %@", photos);
                    NSArray *SplitArray = [photos componentsSeparatedByString:@"url="];
                    //  NSLog(@"SplitArray is %@",SplitArray);
                    NSString *GetSplitString;
                    if ([SplitArray count] > 1) {
                        GetSplitString = [SplitArray objectAtIndex: 1];
                        NSMutableArray *testarray = [[NSMutableArray alloc]init];
                        for (int i = 0; i < [SplitArray count]; i++) {
                            NSString *GetData = [[NSString alloc]initWithFormat:@"%@",[SplitArray objectAtIndex:i]];
                            
                            if ([GetData rangeOfString:@"m="].location == NSNotFound) {
                            } else {
                                //  NSLog(@"Get GetData is %@",GetData);
                                NSArray *SplitArray2 = [GetData componentsSeparatedByString:@"m="];
                                NSString *FinalString = [SplitArray2 objectAtIndex:0];
                                [testarray addObject:FinalString];
                            }
                        }
                        //   NSLog(@"testarray is %@",testarray);
                        NSString * result = [testarray componentsJoinedByString:@","];
                        [FullPhotoArray addObject:result];
                    }else{
                        GetSplitString = @"";
                    }
                    
                    NSArray *SplitArray2 = [GetSplitString componentsSeparatedByString:@"m="];
                    //NSLog(@"SplitArray2 is %@",SplitArray2);
                    NSString *FinalString = [SplitArray2 objectAtIndex:0];
                    
                    [LPhotoArray addObject:FinalString];
                }
                DataCount = DataTotal;
                DataTotal = (int)[TitleArray count];
                CheckLoad = NO;
                [self InitView];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *CheckGetUserProfile = [defaults objectForKey:@"UserData_CheckData"];
                if ([CheckGetUserProfile isEqualToString:@"Done"]) {
                }else{
                    //[ProgressHUD showSuccess:@""];
             //       [ProgressHUD dismiss];
                }
            }
            //   NSLog(@"LikesArray = %@",LikesArray);
            
            
            
            
        }

    }

}
-(void)Initview_NoData{
    NSLog(@"Initview_NoData?");
//    for (UIView *subview in MainScroll.subviews) {
//        [subview removeFromSuperview];
//    }
    LineButton.hidden = YES;
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    // [MainScroll setContentSize:CGSizeMake(320, height_Collection + 190)];
    [MainScroll setContentSize:CGSizeMake(320, 500)];
}
-(IBAction)BigButton_Nearby:(id)sender{
    NSLog(@"Nearby Button Click");
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray objectAtIndex:0]];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:0] GetUserUid:[UserInfo_uidArray objectAtIndex:0] GetUserFollowing:[UserInfo_FollowingArray objectAtIndex:0] GetCheckLike:[CheckLikeArray objectAtIndex:0] GetLink:[LinkArray objectAtIndex:0]];
//    [FeedDetailView GetImageArray:[FullPhotoArray objectAtIndex:0] GetTitle:[TitleArray objectAtIndex:0] GetUserName:[UserInfo_NameArray objectAtIndex:0] GetUserProfilePhoto:[UserInfo_UrlArray objectAtIndex:0] GetMessage:[MessageArray objectAtIndex:0] GetUserAddress:[UserInfo_AddressArray objectAtIndex:0] GetCategory:[CategoryArray objectAtIndex:0] GetTotalLikes:[LikesArray objectAtIndex:0] GetTotalComment:[CommentArray objectAtIndex:0]];
//    [FeedDetailView GetLat:[LatArray objectAtIndex:0] GetLong:[LongArray objectAtIndex:0] GetLocation:[LocationArray objectAtIndex:0]];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:0]];
}
-(IBAction)SmallButton_Nearby:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    FeedDetailViewController *FeedDetailView = [[FeedDetailViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FeedDetailView animated:NO completion:nil];
//    [FeedDetailView GetLang:[LangArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN] GetUserUid:[UserInfo_uidArray objectAtIndex:getbuttonIDN] GetUserFollowing:[UserInfo_FollowingArray objectAtIndex:getbuttonIDN] GetCheckLike:[CheckLikeArray objectAtIndex:getbuttonIDN] GetLink:[LinkArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetImageArray:[FullPhotoArray objectAtIndex:getbuttonIDN] GetTitle:[TitleArray objectAtIndex:getbuttonIDN] GetUserName:[UserInfo_NameArray objectAtIndex:getbuttonIDN] GetUserProfilePhoto:[UserInfo_UrlArray objectAtIndex:getbuttonIDN] GetMessage:[MessageArray objectAtIndex:getbuttonIDN] GetUserAddress:[UserInfo_AddressArray objectAtIndex:getbuttonIDN] GetCategory:[CategoryArray objectAtIndex:getbuttonIDN] GetTotalLikes:[LikesArray objectAtIndex:getbuttonIDN] GetTotalComment:[CommentArray objectAtIndex:getbuttonIDN]];
//    [FeedDetailView GetLat:[LatArray objectAtIndex:getbuttonIDN] GetLong:[LongArray objectAtIndex:getbuttonIDN] GetLocation:[LocationArray objectAtIndex:getbuttonIDN]];
    [FeedDetailView GetPostID:[PostIDArray objectAtIndex:getbuttonIDN]];
}
-(IBAction)ShowAll_FollowerButton:(id)sender{
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ShowFollowerAndFollowingView animated:NO completion:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:@"me" GetType:@"Follower"];
}
-(IBAction)ShowAll_FollowingButton:(id)sender{
    ShowFollowerAndFollowingViewController *ShowFollowerAndFollowingView = [[ShowFollowerAndFollowingViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ShowFollowerAndFollowingView animated:NO completion:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    [ShowFollowerAndFollowingView GetToken:GetExpertToken GetUID:@"me" GetType:@"Following"];
}
-(IBAction)ClickFullImageButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUserProfilePhoto = [defaults objectForKey:@"UserData_ProfilePhoto"];
    
    FullImageViewController *FullImageView = [[FullImageViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:FullImageView animated:NO completion:nil];
    [FullImageView GetImageString:GetUserProfilePhoto];

}
-(IBAction)ShareButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"ShareToFacebook", nil),CustomLocalisedString(@"CopyLink", nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 200;
//    NSString *message = [NSString stringWithFormat:@"http://seeties.me"];
//    
//    // Check if the Facebook app is installed and we can present the share dialog
//    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//    params.link = [NSURL URLWithString:message];
//    
//    // If the Facebook app is installed and we can present the share dialog
//    if ([FBDialogs canPresentShareDialogWithParams:params]) {
//        
//        // Present share dialog
//        [FBDialogs presentShareDialogWithLink:params.link
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"Error publishing story: %@", error.description);
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                          }
//                                      }];
//        
//        // If the Facebook app is NOT installed and we can't present the share dialog
//    } else {
//        // FALLBACK: publish just a link using the Feed dialog
//        
//        // Put together the dialog parameters
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"Seeties", @"name",
//                                       @"", @"caption",
//                                       @"Download Our App in http://seeties.me", @"description",
//                                       message, @"link",
//                                       @"", @"picture",
//                                       nil];
//        
//        // Show the feed dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // An error occurred, we need to handle the error
//                                                          // See: https://developers.facebook.com/docs/ios/errors
//                                                          NSLog(@"Error publishing story: %@", error.description);
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                          } else {
//                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                              
//                                                              if (![urlParams valueForKey:@"post_id"]) {
//                                                                  // User canceled.
//                                                                  NSLog(@"User cancelled.");
//                                                                  
//                                                              } else {
//                                                                  // User clicked the Share button
//                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                                  NSLog(@"result %@", result);
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//    }
    
//    NSString *message = [NSString stringWithFormat:@"https://seeties.me/%@",Getusername];
//    NSLog(@"message is %@",message);
//    // Check if the Facebook app is installed and we can present the share dialog
//    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//    params.link = [NSURL URLWithString:message];
//    
//    // If the Facebook app is installed and we can present the share dialog
//    if ([FBDialogs canPresentShareDialogWithParams:params]) {
//        
//        // Present share dialog
//        [FBDialogs presentShareDialogWithLink:params.link
//                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
//                                          if(error) {
//                                              // An error occurred, we need to handle the error
//                                              // See: https://developers.facebook.com/docs/ios/errors
//                                              NSLog(@"Error publishing story: %@", error.description);
//                                          } else {
//                                              // Success
//                                              NSLog(@"result %@", results);
//                                          }
//                                      }];
//        
//        // If the Facebook app is NOT installed and we can't present the share dialog
//    } else {
//        // FALLBACK: publish just a link using the Feed dialog
//        
//        // Put together the dialog parameters
//        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                       @"", @"name",
//                                       @"", @"caption",
//                                       @"", @"description",
//                                       message, @"link",
//                                       @"", @"picture",
//                                       nil];
//        
//        // Show the feed dialog
//        [FBWebDialogs presentFeedDialogModallyWithSession:nil
//                                               parameters:params
//                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
//                                                      if (error) {
//                                                          // An error occurred, we need to handle the error
//                                                          // See: https://developers.facebook.com/docs/ios/errors
//                                                          NSLog(@"Error publishing story: %@", error.description);
//                                                      } else {
//                                                          if (result == FBWebDialogResultDialogNotCompleted) {
//                                                              // User canceled.
//                                                              NSLog(@"User cancelled.");
//                                                          } else {
//                                                              // Handle the publish feed callback
//                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
//                                                              
//                                                              if (![urlParams valueForKey:@"post_id"]) {
//                                                                  // User canceled.
//                                                                  NSLog(@"User cancelled.");
//                                                                  
//                                                              } else {
//                                                                  // User clicked the Share button
//                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
//                                                                  NSLog(@"result %@", result);
//                                                              }
//                                                          }
//                                                      }
//                                                  }];
//    }

}
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
-(IBAction)OpenUrlButton:(id)sender{
    NSLog(@"OpenUrlButton Click.");
    if ([ShowUrl.text hasPrefix:@"http://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ShowUrl.text]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",ShowUrl.text];
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }

}
@end
