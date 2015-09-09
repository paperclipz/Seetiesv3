//
//  SubmitProfileViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 1/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "SubmitProfileViewController.h"
//#import <CoreLocation/CoreLocation.h>
//@import AssetsLibrary;
#import "LanguageManager.h"
#import "Locale.h"

@interface SubmitProfileViewController ()

@end

@implementation SubmitProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowImage.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    EditButton.frame = CGRectMake((screenWidth/2) - 73, screenHeight - 70, 147, 32);
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];
    [EditButton setTitle:CustomLocalisedString(@"TapToChange", nil) forState:UIControlStateNormal];
    
    SaveButton.frame = CGRectMake(screenWidth - 55 - 15, 29, 55, 30);
    
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Submit Image (Image/Cover) Page";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)GetType:(NSString *)Type{
    GetType = Type;
    NSString *tempString;
    if ([GetType isEqualToString:@"Profile Photo"]) {
        tempString = CustomLocalisedString(@"EditProfilePhoto",nil);
    }else{
        tempString = CustomLocalisedString(@"EditCoverPhoto",nil);
        
    }
    ShowTitle.text = tempString;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CustomLocalisedString(@"Howdoyouwanttodoaddimage",nil)
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"PhotoLibrary",nil),CustomLocalisedString(@"Camera",nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 100) {
        NSLog(@"The Normal action sheet.");
        //Get the name of the current pressed button
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];

        if  ([buttonTitle isEqualToString:CustomLocalisedString(@"PhotoLibrary",nil)]) {
            NSLog(@"Photo Library");
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:nil];
            //  //  [self presentModalViewController:imagePicker animated:YES];
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"Camera",nil)]) {
            NSLog(@"Camera");
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])  {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing = NO;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:nil];
            }else{
                
                UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@""
                                                                      message:@"Device has no camera"
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles: nil];
                
                [myAlertView show];
            }
            
        }
        if ([buttonTitle isEqualToString:CustomLocalisedString(@"SettingsPage_Cancel",nil)]) {
            NSLog(@"Cancel Button");
        }
    }

    
}
-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    // imageSelect.image = image;
    ShowImage.image = image;
    NSLog(@"editingInfo is %@",editingInfo);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    NSString *mediaType = info[UIImagePickerControllerMediaType];
//    UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
//    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
//    NSValue *cropRect = info[UIImagePickerControllerCropRect];
//    NSURL *mediaUrl = info[UIImagePickerControllerMediaURL];
//    NSURL *referenceUrl = info[UIImagePickerControllerReferenceURL];
//    NSDictionary *mediaMetadata = info[UIImagePickerControllerMediaMetadata];
//    
//    NSLog(@"mediaType=%@", mediaType);
//    NSLog(@"originalImage=%@", originalImage);
//    NSLog(@"editedImage=%@", editedImage);
//    NSLog(@"cropRect=%@", cropRect);
//    NSLog(@"mediaUrl=%@", mediaUrl);
//    NSLog(@"referenceUrl=%@", referenceUrl);
//    NSLog(@"mediaMetadata=%@", mediaMetadata);
//    
//    if (!referenceUrl) {
//        NSLog(@"Media did not have reference URL.");
//    } else {
//        ALAssetsLibrary *assetsLib = [[ALAssetsLibrary alloc] init];
//        [assetsLib assetForURL:referenceUrl
//                   resultBlock:^(ALAsset *asset) {
//                       NSString *type =
//                       [asset valueForProperty:ALAssetPropertyType];
//                       CLLocation *location =
//                       [asset valueForProperty:ALAssetPropertyLocation];
//                       NSNumber *duration =
//                       [asset valueForProperty:ALAssetPropertyDuration];
//                       NSNumber *orientation =
//                       [asset valueForProperty:ALAssetPropertyOrientation];
//                       NSDate *date =
//                       [asset valueForProperty:ALAssetPropertyDate];
//                       NSArray *representations =
//                       [asset valueForProperty:ALAssetPropertyRepresentations];
//                       NSDictionary *urls =
//                       [asset valueForProperty:ALAssetPropertyURLs];
//                       NSURL *assetUrl =
//                       [asset valueForProperty:ALAssetPropertyAssetURL];
//                       
//                       NSLog(@"type=%@", type);
//                       NSLog(@"location=%@", location);
//                       NSLog(@"duration=%@", duration);
//                       NSLog(@"assetUrl=%@", assetUrl);
//                       NSLog(@"orientation=%@", orientation);
//                       NSLog(@"date=%@", date);
//                       NSLog(@"representations=%@", representations);
//                       NSLog(@"urls=%@", urls);
//                   }
//                  failureBlock:^(NSError *error) {
//                      NSLog(@"Failed to get asset: %@", error);
//                  }];
//    }
//    
//    //You can retrieve the actual UIImage
//    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
//    ShowImage.image = image;
//    //Or you can get the image url from AssetsLibrary
//    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
//    NSLog(@"path is %@",path);
//    [picker dismissViewControllerAnimated:YES completion:^{
//    }];
//}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)EditButton:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CustomLocalisedString(@"Howdoyouwanttodoaddimage",nil)
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"PhotoLibrary",nil),CustomLocalisedString(@"Camera",nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
}
-(IBAction)SaveButton:(id)sender{
    if ([GetType isEqualToString:@"Profile Photo"]) {
        [self SubmitProfilePhoto];
        SaveButton.enabled = NO;
    }else{
        [self SubmitCoverPhoto];
        SaveButton.enabled = NO;
    }
}
-(void)SubmitProfilePhoto{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    LoadingBlackBackground = [[UIButton alloc]init];
    [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
    LoadingBlackBackground.backgroundColor = [UIColor blackColor];
    LoadingBlackBackground.alpha = 0.5f;
    LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:LoadingBlackBackground];
    
    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.lineWidth = 1.0f;
    [self.view addSubview:spinnerView];
    [spinnerView startAnimating];
    
    ShowLoadingText = [[UILabel alloc]init];
    ShowLoadingText.frame = CGRectMake(0, (screenHeight/2) + 30, screenWidth, 40);
    ShowLoadingText.text = @"Updating...";
    ShowLoadingText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    ShowLoadingText.textColor = [UIColor whiteColor];
    ShowLoadingText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowLoadingText];

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DataUrl.UserWallpaper_Url,Getuid];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    NSData *imageData = UIImageJPEGRepresentation(ShowImage.image, 1.0);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_photo\"; filename=\"ProfilePhoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    // add it to body
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    

    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
   // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_ProfilePhoto = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_ProfilePhoto) {
      //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }

}
-(void)SubmitCoverPhoto{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    LoadingBlackBackground = [[UIButton alloc]init];
    [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
    LoadingBlackBackground.backgroundColor = [UIColor blackColor];
    LoadingBlackBackground.alpha = 0.5f;
    LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:LoadingBlackBackground];
    
    spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    spinnerView.lineWidth = 1.0f;
    [self.view addSubview:spinnerView];
    [spinnerView startAnimating];
    
    ShowLoadingText = [[UILabel alloc]init];
    ShowLoadingText.frame = CGRectMake(0, (screenHeight/2) + 30, screenWidth, 40);
    ShowLoadingText.text = @"Uploading...";
    ShowLoadingText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    ShowLoadingText.textColor = [UIColor whiteColor];
    ShowLoadingText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowLoadingText];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DataUrl.UserWallpaper_Url,Getuid];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSData *imageData = UIImagePNGRepresentation(ShowImage.image);
     NSData *imageData = UIImageJPEGRepresentation(ShowImage.image, 1.0);
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"wallpaper\"; filename=\"ProfilePhoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    // add it to body
    [body appendData:imageData];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_ProfilePhoto = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_ProfilePhoto) {
        //  NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
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
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"SubmitProfilePhoto return get data to server ===== %@",GetData);
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"res is %@",res);
    if ([res count] == 0) {
        NSLog(@"Server Error.");
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        ShowAlert.tag = 1000;
        [ShowAlert show];
    }else{
        NSLog(@"Server Work.");
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
            // send user back login screen.
        }else{
            NSString *GetName_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
            NSLog(@"GetName_ is %@",GetName_);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
            NSLog(@"GetLocation is %@",GetLocation);
            NSString *GetAbouts_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"GetAbouts_ is %@",GetAbouts_);
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
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
            
            NSInteger CheckSystemLanguageData;
            if ([GetSystemLanguage isEqualToString:@"English"]) {
                CheckSystemLanguageData = 0;
            }else if([GetSystemLanguage isEqualToString:@"Simplified Chinese"]){
                CheckSystemLanguageData = 1;
            }else if([GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
                CheckSystemLanguageData = 2;
            }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
                CheckSystemLanguageData = 3;
            }else if([GetSystemLanguage isEqualToString:@"Thai"] || [GetSystemLanguage isEqualToString:@"th"]){
                CheckSystemLanguageData = 4;
            }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
                CheckSystemLanguageData = 5;
            }
            
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
            
            NSString *GetLanguage_1;
            NSString *GetLanguage_2;
            if ([TempArray count] == 1) {
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
            }else{
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
            }
            NSString *CheckGetUserProfile = @"false";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
            [defaults setObject:Getprofile_photo forKey:@"UserData_ProfilePhoto"];
            [defaults setObject:Getcategories forKey:@"UserData_Categories"];
            [defaults setObject:GetName_ forKey:@"UserData_Name"];
            [defaults setObject:Getusername forKey:@"UserData_Username"];
            [defaults setObject:GetAbouts_ forKey:@"UserData_Abouts"];
            [defaults setObject:GetUrl forKey:@"UserData_Url"];
            [defaults setObject:Getemail forKey:@"UserData_Email"];
            [defaults setObject:GetLocation forKey:@"UserData_Location"];
            [defaults setObject:Getdob forKey:@"UserData_dob"];
            [defaults setObject:GetWallpaper forKey:@"UserData_Wallpaper"];
            [defaults setObject:GetGender forKey:@"UserData_Gender"];
            [defaults setObject:GetSystemLanguage forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults synchronize];
            
            SaveButton.enabled = YES;
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
            [LoadingBlackBackground removeFromSuperview];
            [ShowLoadingText removeFromSuperview];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [self.view.window.layer addAnimation:transition forKey:nil];
            //[self presentViewController:ListingDetail animated:NO completion:nil];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    
}
@end
