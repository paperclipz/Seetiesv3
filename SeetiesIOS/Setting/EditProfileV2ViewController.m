//
//  EditProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/1/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditProfileV2ViewController.h"
#import "PSearchLocationViewController.h"
@interface EditProfileV2ViewController ()

@end

@implementation EditProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    DataUrl = [[UrlDataClass alloc]init];
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SaveButton.frame = CGRectMake(screenWidth - 50, 20, 50, 44);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowTitle.text = LocalisedString(@"Edit Profile");
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MainScroll.alwaysBounceVertical = YES;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 744)];
    
    spinnerView.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,screenWidth, 44)];
    Toolbar.translucent=NO;
    Toolbar.barTintColor=[UIColor whiteColor];
    [self.view addSubview:Toolbar];
    
    Gender_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    ShowPersonalInformation.text = LocalisedString(@"Personal Information");
    
    GenderArray = [[NSMutableArray alloc]init];
    [GenderArray addObject:CustomLocalisedString(@"Male",nil)];
    [GenderArray addObject:CustomLocalisedString(@"Female",nil)];
    
    UserNameField.delegate = self;
    UserNameField.placeholder = LocalisedString(@"Username");
    NameField.delegate = self;
    NameField.placeholder = LocalisedString(@"Name");
    LinkField.delegate = self;
    LinkField.placeholder = LocalisedString(@"Website");
    TagasField.delegate = self;
    TagasField.placeholder = LocalisedString(@"Separate tags with space. Eg. Foodie, photographer, gym buff etc.");
    DescriptionField.frame = CGRectMake(45, 414, screenWidth - 45 - 20, 95);
    DescriptionField.delegate = self;
    DescriptionField.text = LocalisedString(@"About me");
    LocationField.delegate = self;
    LocationField.placeholder = LocalisedString(@"Location");
    DOBField.delegate = self;
    DOBField.placeholder = LocalisedString(@"ddmmyyyy");
    GenderField.delegate = self;
    GenderField.placeholder = LocalisedString(@"Gender");
    
    CaretLocationImg.frame = CGRectMake(screenWidth - 30, 641, 30, 30);

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetWallpaper = [defaults objectForKey:@"UserData_Wallpaper"];
    GetProfileImg = [defaults objectForKey:@"UserData_ProfilePhoto"];
    GetUserName = [defaults objectForKey:@"UserData_Username"];
    GetName = [defaults objectForKey:@"UserData_Name"];
    GetLink = [defaults objectForKey:@"UserData_Url"];
    GetDescription = [defaults objectForKey:@"UserData_Abouts"];
    GetLocation = [defaults objectForKey:@"UserData_Location"];
    Getdob = [defaults objectForKey:@"UserData_dob"];
    GetGender = [defaults objectForKey:@"UserData_Gender"];
    GetPersonalTags = [defaults objectForKey:@"UserData_PersonalTags"];
    NSString *CheckFullLocation = [defaults objectForKey:@"Provisioning_LocationName"];
    
    BackgroundImgButton.frame = CGRectMake(0, 64, screenWidth, 120);
    BackgroundImg.frame = CGRectMake(0, 64, screenWidth, 120);
    NSLog(@"BackgroundImg is %@",BackgroundImg);
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:BackgroundImg];
    //NSLog(@"User Wallpaper FullString ====== %@",GetWallpaper);
    NSURL *url_WallpaperImage = [NSURL URLWithString:GetWallpaper];
    BackgroundImg.imageURL = url_WallpaperImage;
    
    UserImgButton.layer.cornerRadius = 45;
    UserImgButton.layer.borderWidth = 5;
    UserImgButton.layer.masksToBounds = YES;
    UserImgButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    UserImg.contentMode = UIViewContentModeScaleAspectFill;
    UserImg.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImg.layer.cornerRadius = 45;
    UserImg.layer.borderWidth = 5;
    UserImg.layer.masksToBounds = YES;
    UserImg.layer.borderColor=[[UIColor whiteColor] CGColor];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:UserImg];
    if ([GetProfileImg length] == 0 || [GetProfileImg isEqualToString:@"null"] || [GetProfileImg isEqualToString:@"<null>"]) {
        UserImg.image = [UIImage imageNamed:@"DefaultProfilePic.png"];
    }else{
        NSURL *url_UserImage = [NSURL URLWithString:GetProfileImg];
        UserImg.imageURL = url_UserImage;
    }
    
    //checking data
    UserNameField.text = GetUserName;
    NameField.text = GetName;
    
    if ([GetLink length] == 0) {
    }else{
        LinkField.text = GetLink;
    }
    if ([GetDescription length] == 0) {
    }else{
        DescriptionField.text = GetDescription;
    }
    
    if ([GetLocation length] == 0) {
        if ([CheckFullLocation length] == 0) {
        }else{
            LocationField.text = CheckFullLocation;
        }
    }else{
        if ([CheckFullLocation length] == 0) {
            LocationField.text = GetLocation;
        }else{
            LocationField.text = CheckFullLocation;
        }
        
    }
    
    if ([Getdob length] == 0) {
    }else{
        DOBField.text = Getdob;
    }
    if ([GetGender length] == 0) {
    }else{
        if ([GetGender isEqualToString:@"m"]) {
            GenderField.text = CustomLocalisedString(@"Male",nil);
        }else{
            GenderField.text = CustomLocalisedString(@"Female",nil);
        }
    }
    if ([GetPersonalTags length] == 0 || [GetPersonalTags isEqualToString:@"\"\""]) {
    }else{
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
        GetPersonalTags = [[GetPersonalTags componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        NSArray *arr = [GetPersonalTags componentsSeparatedByString:@","];
        NSString *result = [arr componentsJoinedByString:@" "];
        TagasField.text = result;
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

   // CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetLocation = [defaults objectForKey:@"UserData_Location"];
    NSString *CheckFullLocation = [defaults objectForKey:@"Provisioning_LocationName"];
    
    if ([GetLocation length] == 0) {
        if ([CheckFullLocation length] == 0) {
        }else{
            LocationField.text = CheckFullLocation;
        }
    }else{
        if ([CheckFullLocation length] == 0) {
            LocationField.text = GetLocation;
        }else{
            LocationField.text = CheckFullLocation;
        }
        
    }

}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"did begin editing");
    if (textView == DescriptionField) {
        if ([DescriptionField.text isEqualToString:LocalisedString(@"About me")]) {
            DescriptionField.text = @"";
        }
    }
    
    
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == DescriptionField) {
        if ([text isEqualToString:@"\n"]) {
            // Be sure to test for equality using the "isEqualToString" message
            [textView resignFirstResponder];
            // Return FALSE so that the final '\n' character doesn't get added
            return FALSE;
        }else{
            if([text length] == 0)
            {
                if([textView.text length] != 0)
                {
                    return YES;
                }
            }
            else if([[textView text] length] >= 150)
            {
               // ShowDescriptionCount.text = @"0 / 150";
               // ShowDescriptionCount.textColor = [UIColor redColor];
                return NO;
            }
        }
    }
    
    
    
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField==TagasField)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == UserNameField) {
        [UserNameField resignFirstResponder];
        [NameField becomeFirstResponder];
    }else if(textField == NameField){
        [NameField resignFirstResponder];
        [LinkField becomeFirstResponder];
    }else if(textField == LinkField){
        [LinkField resignFirstResponder];
        [TagasField becomeFirstResponder];
    }else if(textField == TagasField){
        [TagasField resignFirstResponder];
        [DescriptionField becomeFirstResponder];
        
    }else{
        [textField resignFirstResponder];
    
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackgroundImgOnClick:(id)sender{
    ButtonOnClick = 0;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:CustomLocalisedString(@"Howdoyouwanttodoaddimage",nil)
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel",nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:CustomLocalisedString(@"PhotoLibrary",nil),CustomLocalisedString(@"Camera",nil), nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 100;
}
-(IBAction)UserImgOnClick:(id)sender{
    ButtonOnClick = 1;
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
    NSLog(@"Get select image is %@",image);
    if (ButtonOnClick == 0) {
        BackgroundImg.image = image;
        GetWallpaper = @"NEW";
    }else{
        UserImg.image = image;
        GetProfileImg = @"NEW";
    }
    
   // ShowImage.image = image;
   // NSLog(@"editingInfo is %@",editingInfo);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)SaveButton:(id)sender{
    
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
//    if ([emailTest evaluateWithObject:TagasField.text] == NO) {
//        TagasField.text = @"";
//    }else{
        SaveButton.enabled = NO;
        [self UpdateUserInformation];
//    }
    

}
-(void)UpdateUserInformation{
    [spinnerView startAnimating];
    
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
    
    if ([GetUserName isEqualToString:UserNameField.text]) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",UserNameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([GetName isEqualToString:NameField.text]) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",NameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([GetLink isEqualToString:LinkField.text]) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"personal_link\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",LinkField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    if ([GetDescription isEqualToString:DescriptionField.text] || [DescriptionField.text isEqualToString:LocalisedString(@"About me")]) {
        
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",DescriptionField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([TagasField.text isEqualToString:@""] || [TagasField.text length] == 0) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"personal_tags\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        //[body appendData:[[NSString stringWithFormat:@""] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }else{
        NSArray *TempTagsArray = [TagasField.text componentsSeparatedByString:@" "];
        for (int i = 0; i < [TempTagsArray count]; i++) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the key name @"parameter_second" to the post body
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"personal_tags[%i]\"\r\n\r\n",i] dataUsingEncoding:NSUTF8StringEncoding]];
            //Attaching the content to be posted ( ParameterSecond )
            [body appendData:[[NSString stringWithFormat:@"%@",[TempTagsArray objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    if ([DOBField.text isEqualToString:Getdob]) {
    }else{
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"dob\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",DOBField.text] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([GenderField.text isEqualToString:GetGender]) {
    }else{
        NSString *GetTempGender;
        if ([GenderField.text isEqualToString:CustomLocalisedString(@"Male",nil)]) {
            GetTempGender = @"m";
        }else{
            GetTempGender = @"f";
        }
        
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetTempGender] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([LocationField.text isEqualToString:GetLocation]) {
    }else{
        NSString *GetLocationJson = [defaults objectForKey:@"Provisioning_FullJson"];
        NSLog(@"GetLocationJson is %@",GetLocationJson);
        if ([GetLocationJson isEqualToString:@"(null)"]) {
            GetLocationJson = @"";
        }else{
            
        }
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"home_city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetLocationJson] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }

    
    if ([GetWallpaper isEqualToString:@"NEW"]) {
        NSData *imageData = UIImageJPEGRepresentation(BackgroundImg.image, 1.0);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"wallpaper\"; filename=\"WallpaperPhoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        // add it to body
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if ([GetProfileImg isEqualToString:@"NEW"]) {
        NSData *imageData = UIImageJPEGRepresentation(UserImg.image, 1.0);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"profile_photo\"; filename=\"ProfilePhoto.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        // add it to body
        [body appendData:imageData];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    

    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Update = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Update) {
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    SaveButton.enabled = YES;
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Update) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Edit Profile return get data to server ===== %@",GetData);
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            if ([StatusString isEqualToString:@"ok"]) {
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                
                NSDictionary *WallpaperData = [GetAllData valueForKey:@"wallpaper"];
                NSString *GetWallpaper_ = [[NSString alloc]initWithFormat:@"%@",[WallpaperData objectForKey:@"s"]];
                
                NSDictionary *ProfilePhotoData = [GetAllData valueForKey:@"profile_photo_images"];
                NSString *GetProfileImg_ = [[NSString alloc]initWithFormat:@"%@",[ProfilePhotoData objectForKey:@"l"]];
                
                NSString *GetName_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"name"]];
                NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
                NSString *GetLocation_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"location"]];
                NSString *GetAbouts_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
                NSString *GetUrl_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"personal_link"]];
                NSString *Getdob_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
                NSString *GetGender_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"gender"]];
                NSString *GetPersonalTags_ = [[NSString alloc]initWithFormat:@"%@",[GetAllData valueForKey:@"personal_tags"]];
                
                NSLog(@"before GetPersonalTags_ is %@",GetPersonalTags_);
                NSLog(@"GetPersonalTags_ length is %lu",(unsigned long)[GetPersonalTags_ length]);
                if ([GetPersonalTags_ length] == 10) {
                    GetPersonalTags_ = @"";
                }
                NSLog(@"after GetPersonalTags_ is %@",GetPersonalTags_);
                NSString *EditDone = @"GotEdit";
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:GetProfileImg_ forKey:@"UserData_ProfilePhoto"];
                [defaults setObject:GetWallpaper_ forKey:@"UserData_Wallpaper"];
                [defaults setObject:GetName_ forKey:@"UserData_Name"];
                [defaults setObject:Getusername forKey:@"UserData_Username"];
                [defaults setObject:GetAbouts_ forKey:@"UserData_Abouts"];
                [defaults setObject:GetUrl_ forKey:@"UserData_Url"];
                // [defaults setObject:GetEmail forKey:@"UserData_Email"];
                [defaults setObject:GetLocation_ forKey:@"UserData_Location"];
                [defaults setObject:Getdob_ forKey:@"UserData_dob"];
                [defaults setObject:GetGender_ forKey:@"UserData_Gender"];
                [defaults setObject:GetPersonalTags_ forKey:@"UserData_PersonalTags"];
                [defaults setObject:EditDone forKey:@"CheckEditUserInformation"];
                [defaults synchronize];
                
                
                CATransition *transition = [CATransition animation];
                transition.duration = 0.2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionPush;
                transition.subtype = kCATransitionFromLeft;
                [self.view.window.layer addAnimation:transition forKey:nil];
                //[self presentViewController:ListingDetail animated:NO completion:nil];
                [self dismissViewControllerAnimated:NO completion:nil];
                
                
            }else{
                
            }
            
            
        }
    }
    
    [spinnerView stopAnimating];

}
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - UIPicker view Delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return [GenderArray count];
    }
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        GenderField.text = [GenderArray objectAtIndex:row];
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 100) {
        return [GenderArray objectAtIndex:row];
    }
    return 0;
}
-(IBAction)DoneSelect:(id)sender{
    
    Gender_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
    
}
-(void)GetBirthdayChange{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [dateFormat stringFromDate:Birthday_Picker.date];
    NSLog(@"date is >>> , %@",date);
    DOBField.text = date;
}
-(IBAction)BirthdayButtonOnClick:(id)sender{
    Gender_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
  
    [UserNameField resignFirstResponder];
    [NameField resignFirstResponder];
    [LinkField resignFirstResponder];
    [LinkField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Birthday_Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Birthday_Picker.tag = 100;
    [self.view addSubview:Birthday_Picker];
    // Birthday_Picker.delegate = self;
    Birthday_Picker.datePickerMode = UIDatePickerModeDate;
    //NSLog(@"ShowBirthday.text is %@",DOBField.text);
    if ([DOBField.text length] == 0 || [DOBField.text isEqualToString:@"0000-00-00"]) {
        Birthday_Picker.date = [NSDate date];
    }else{
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormat dateFromString:DOBField.text];
        [Birthday_Picker setDate:date];
    }
    
    [Birthday_Picker addTarget:self   action:@selector(GetBirthdayChange)forControlEvents:UIControlEventValueChanged];
    Birthday_Picker.backgroundColor = [UIColor whiteColor];
    //Birthday_Picker.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    Toolbar.hidden = NO;
}
-(IBAction)LocationButtonOnClick:(id)sender{
    PSearchLocationViewController *PSearchLocationView = [[PSearchLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PSearchLocationView animated:NO completion:nil];
}
-(IBAction)GenderButtonOnClick:(id)sender{
    Gender_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    Birthday_Picker.hidden = YES;
    
    [UserNameField resignFirstResponder];
    [NameField resignFirstResponder];
    [LinkField resignFirstResponder];
    [LinkField resignFirstResponder];
    [DescriptionField resignFirstResponder];
    
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    Gender_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    Gender_PickerView.tag = 100;
    [self.view addSubview:Gender_PickerView];
    Gender_PickerView.delegate = self;
    Gender_PickerView.backgroundColor = [UIColor whiteColor];
    Gender_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    Toolbar.hidden = NO;
}

@end
