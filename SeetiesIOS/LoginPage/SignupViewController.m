//
//  SignupViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/19/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SignupViewController.h"
#import "PTnCViewController.h"
#import "LLARingSpinnerView.h"
#import "PInterestV2ViewController.h"
#import "OpenWebViewController.h"
#import "ExpertLoginViewController.h"

#import <Parse/Parse.h>
@interface SignupViewController ()
//@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@property(nonatomic,strong)PInterestV2ViewController* pInterestV2ViewController;
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    EmailField.delegate = self;
    UsernameField.delegate = self;
    PasswordField.delegate = self;
    ConfirmPasswrodField.delegate = self;
    
    RedIcon.hidden = YES;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    Scrollview.delegate = self;
    Scrollview.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    ShowBackgroundImage.frame = CGRectMake(0, 0, screenWidth, screenHeight);

    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    ShowTitle.frame = CGRectMake(0, 30, screenWidth, 44);
    SignUpButton.frame = CGRectMake(30, 250, screenWidth - 60, 50);
    CancelButton.frame = CGRectMake(20, 20, 50, 44);
    LogoImg.frame = CGRectMake((screenWidth / 2) - 27, 20, 55, 50);
    
    btnBackground_1.frame = CGRectMake(30, 80, screenWidth - 60, 50);
    btnBackground_2.frame = CGRectMake(30, 131, screenWidth - 60, 50);
    btnBackground_3.frame = CGRectMake(30, 182, screenWidth - 60, 50);
    btnBackground_4.frame = CGRectMake(30, 233, screenWidth - 60, 50);
    btnBackground_1.layer.cornerRadius = 5;
    btnBackground_2.layer.cornerRadius = 5;
    btnBackground_3.layer.cornerRadius = 5;
    btnBackground_4.layer.cornerRadius = 5;
    SignUpButton.layer.cornerRadius = 5;
    
    EmailField.frame = CGRectMake(40, 80, screenWidth - 80, 50);
    UsernameField.frame = CGRectMake(40, 131, screenWidth - 80, 50);
    PasswordField.frame = CGRectMake(40, 182, screenWidth - 80, 50);
    ConfirmPasswrodField.frame = CGRectMake(40, 233, screenWidth - 80, 50);

    
    RedIcon.frame = CGRectMake(screenWidth - 40, 184, 12, 12);
    
//    ExternalIPAddress = [NSString stringWithFormat:@"%@",[SystemSharedServices externalIPAddress]];
//    NSLog(@"External IP Address: %@",ExternalIPAddress);
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // self.screenName = @"IOS Expert Login Page";
    self.screenName = @"IOS Sign Up Page";
    
    EmailField.placeholder = NSLocalizedString(@"Email Address",nil);
    UsernameField.placeholder = NSLocalizedString(@"Create your username", nil);
    PasswordField.placeholder = NSLocalizedString(@"Password", nil);
    ShowTitle.text = NSLocalizedString(@"SignUpPage_Title",nil);
    [SignUpButton setTitle:NSLocalizedString(@"Create",nil) forState:UIControlStateNormal];
    
   // [EmailField becomeFirstResponder];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [EmailField becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [EmailField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == EmailField) {
        [EmailField resignFirstResponder];
        [UsernameField becomeFirstResponder];
    }else if(textField == UsernameField){
        [UsernameField resignFirstResponder];
        [PasswordField becomeFirstResponder];
       // RedIcon.hidden = NO;
    }else if(textField == PasswordField){
        [UsernameField resignFirstResponder];
        //[ConfirmPasswrodField becomeFirstResponder];
      //  [PasswordField resignFirstResponder];
        if([PasswordField.text length] < 8){
           // RedIcon.hidden = NO;
        }else{
          //  RedIcon.hidden = YES;
            [PasswordField resignFirstResponder];
        }
    }else if(textField == ConfirmPasswrodField){
    
    }else{
        [textField resignFirstResponder];
    }

   
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == PasswordField) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        if ([newString length] == 0) {
            RedIcon.hidden = YES;
        }else{
            if([newString length] < 8){
                RedIcon.hidden = NO;
            }else{
                RedIcon.hidden = YES;
                //[PasswordField resignFirstResponder];
            }
        }

    }

    
    return YES;
}

//- (UIStatusBarStyle) preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
   
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)RegisterButton:(id)sender{
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    
    if ([EmailField.text length] == 0 || [emailTest evaluateWithObject:EmailField.text] == NO) {
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"EmailError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [ShowAlert show];
        [TSMessage showNotificationInViewController:self title:@"" subtitle:NSLocalizedString(@"EmailError", nil) type:TSMessageNotificationTypeError];
    }else if([UsernameField.text length] == 0){
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"UsernameError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [ShowAlert show];
        [TSMessage showNotificationInViewController:self title:@"" subtitle:NSLocalizedString(@"UsernameError", nil) type:TSMessageNotificationTypeError];
    }else if([PasswordField.text length] < 8){
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PasswordError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [ShowAlert show];
        [TSMessage showNotificationInViewController:self title:@"" subtitle:NSLocalizedString(@"Yikes. Your password must be at least 8 characters.", nil) type:TSMessageNotificationTypeError];
    }else{
        GetEmail = EmailField.text;
        GetUsername = UsernameField.text;
        GetPassword = PasswordField.text;
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"Provisioning_PTnC_5", nil) message:NSLocalizedString(@"Provisioning_PTnC_6", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Agree", nil), nil];
        ShowAlert.tag = 1000;
        [ShowAlert show];
    }
    
//   if ([UsernameField.text length] == 0 || [EmailField.text length] == 0 || [PasswordField.text length] == 0) {
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Status" message:@"All field cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [ShowAlert show];
//    }else{
//        GetEmail = EmailField.text;
//        GetUsername = UsernameField.text;
//        GetPassword = PasswordField.text;
//        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Terms & Conditions" message:@"I agree to Seeties' Terms of Use & Privacy Notice" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agree", nil];
//        ShowAlert.tag = 1000;
//        [ShowAlert show];
//
//       
//    }

    NSLog(@"Get Email = %@",EmailField.text);
    NSLog(@"Get Username = %@",UsernameField.text);
    NSLog(@"Get Password = %@",PasswordField.text);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            NSLog(@"Cancel");
        }else{
            //reset clicked
            ExpertLoginViewController *ExpertLoginView = [[ExpertLoginViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:ExpertLoginView animated:NO completion:nil];
            [ExpertLoginView GetSameEmailData:EmailField.text];
        }
    }else{
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
            NSLog(@"Cancel");
        }else{
            //reset clicked
            //[self SendLoginDataToServer];
            
             [self SendLoginDataToServer];
        }
    }

}
-(void)SendLoginDataToServer{
    [ShowActivity startAnimating];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
    if (ExternalIPAddress == nil || [ExternalIPAddress isEqualToString:@""] ||[ExternalIPAddress isEqualToString:@"(null)"]) {
        ExternalIPAddress = @"";
    }
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.UserRegister_Url];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetEmail] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetUsername] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetPassword] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"role\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"user"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ip_address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",ExternalIPAddress] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    theConnection_Signup = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Signup) {
       // NSLog(@"Connection Successful");
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
    [ShowActivity stopAnimating];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ErrorConnection", nil) message:NSLocalizedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Signup) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Signup return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        [ShowActivity stopAnimating];
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([MessageString length] == 0 || [MessageString isEqualToString:@"(null)"] || [MessageString isEqualToString:@"None"]) {
            NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            NSLog(@"statusString is %@",statusString);
            
            if ([statusString isEqualToString:@"ok"]) {
                //login done.
                // NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
                
                
                NSString *Getusername = UsernameField.text;
                NSString *GetUserPassword = PasswordField.text;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:Getusername forKey:@"UserName"];
                [defaults setObject:GetUserPassword forKey:@"UserPassword"];
                //  [defaults setObject:CheckLogin forKey:@"CheckLogin"];
                [defaults synchronize];
                
                [self SendLoginDataToServer2];
                
                //            PTnCViewController *PTnCView = [[PTnCViewController alloc]init];
                //            CATransition *transition = [CATransition animation];
                //            transition.duration = 0.4;
                //            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                //            transition.type = kCATransitionPush;
                //            transition.subtype = kCATransitionFromRight;
                //            [self.view.window.layer addAnimation:transition forKey:nil];
                //            [self presentViewController:PTnCView animated:NO completion:nil];
                //            [PTnCView GetFBLogin:@"NO"];
            }


        }else{
            if ([MessageString isEqualToString:@"Sorry that email is already taken. Please try another"]) {
//                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Email already exists" message:@"You can choose to login or change the email address" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Login", nil];
//                ShowAlert.tag = 500;
//                [ShowAlert show];
                
                [TSMessage showNotificationInViewController:self title:@"Email already exists" subtitle:@"You can choose to login or change the email address" type:TSMessageNotificationTypeError];
            }else{
//                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:MessageString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [ShowAlert show];
                
                [TSMessage showNotificationInViewController:self title:@"" subtitle:MessageString type:TSMessageNotificationTypeError];
            }
            
                    }

    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"ExpertLogin return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        [ShowActivity stopAnimating];
        
        NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
        NSLog(@"ErrorString is %@",ErrorString);
        NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"MessageString is %@",MessageString);
        
        if ([MessageString length] == 0 || [MessageString isEqualToString:@"(null)"] || [MessageString isEqualToString:@"None"]) {
            NSDictionary *GetAllData = [res valueForKey:@"data"];
            
            [ShowActivity stopAnimating];
            NSLog(@"Got Data.");
            NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithArray:[GetAllData valueForKey:@"categories"]];
            NSLog(@"categoriesArray is %@",categoriesArray);
            NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"country"]];
            NSLog(@"GetCountry is %@",GetCountry);
            NSString *Getcrawler = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"crawler"]];
            NSLog(@"Getcrawler is %@",Getcrawler);
            NSString *Getcreated_at = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"created_at"]];
            NSLog(@"Getcreated_at is %@",Getcreated_at);
            NSString *Getdescription = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"description"]];
            NSLog(@"Getdescription is %@",Getdescription);
            NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"dob"]];
            NSLog(@"Getdob is %@",Getdob);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"profile_photo"]];
            NSLog(@"Getprofile_photo is %@",Getprofile_photo);
            NSString *Gettoken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"token"]];
            NSLog(@"Gettoken is %@",Gettoken);
            NSString *Getuid = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"uid"]];
            NSLog(@"Getuid is %@",Getuid);
            NSString *Getrole = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"role"]];
            NSLog(@"Getrole is %@",Getrole);
            NSString *GetPasswordCheck = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"has_password"]];
            NSLog(@"GetPasswordCheck is %@",GetPasswordCheck);
            NSString *GetCategories = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"categories"]];
            NSString *GetFbID = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"fb_id"]];
            NSString *GetInstaID = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"insta_id"]];
            
            //  NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:Gettoken forKey:@"ExpertToken"];
            [defaults setObject:Getusername forKey:@"UserName"];
            [defaults setObject:Getprofile_photo forKey:@"UserProfilePhoto"];
            [defaults setObject:Getuid forKey:@"Useruid"];
            [defaults setObject:Getrole forKey:@"Role"];
            [defaults setObject:GetPasswordCheck forKey:@"CheckPassword"];
            [defaults setObject:GetCategories forKey:@"UserData_Categories"];
            [defaults setObject:GetFbID forKey:@"UserData_FbID"];
            [defaults setObject:GetInstaID forKey:@"UserData_instaID"];
            // [defaults setObject:CheckLogin forKey:@"CheckLogin"];
            [defaults synchronize];
            
            //     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *GetDeviceToken = [defaults objectForKey:@"DeviceTokenPush"];
            NSString *GetUserUID = [defaults objectForKey:@"Useruid"];
            NSLog(@"GetDeviceToken is %@",GetDeviceToken);
            NSLog(@"GetUserUID is %@",GetUserUID);
            if ([GetDeviceToken length] == 0 || GetDeviceToken == (id)[NSNull null] || GetDeviceToken.length == 0) {
                
            }else{
                NSString *Check = [defaults objectForKey:@"CheckGetPushToken"];
                if ([Check isEqualToString:@"Done"]) {
                    
                }else{
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    [currentInstallation setDeviceTokenFromData:GetDeviceToken];
                    NSString *TempTokenString = [[NSString alloc]initWithFormat:@"seeties_%@",GetUserUID];
                    
                    [currentInstallation removeObject:@"all" forKey:@"channels"];
                    [currentInstallation removeObject:TempTokenString forKey:@"channels"];
                    [currentInstallation saveInBackground];
                    
                    
                    currentInstallation.channels = @[TempTokenString,@"all"];
                    [currentInstallation saveInBackground];
                    NSLog(@"work here?");
                    NSString *TempString = @"Done";
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:TempString forKey:@"CheckGetPushToken"];
                    [defaults synchronize];
                }
                
            }
            
            [self.navigationController pushViewController:self.pInterestV2ViewController animated:YES];
        
        }else{
//            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [ShowAlert show];
            
            [TSMessage showNotificationInViewController:self title:@"" subtitle:NSLocalizedString(@"SomethingError", nil) type:TSMessageNotificationTypeError];
        }
    }
}

-(PInterestV2ViewController*)pInterestV2ViewController
{
    if (!_pInterestV2ViewController) {
        _pInterestV2ViewController = [PInterestV2ViewController new];
    }
    
    return _pInterestV2ViewController;
}


-(void)SendLoginDataToServer2{
    
    [ShowActivity startAnimating];
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@",DataUrl.ExpertLogin_Url];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"login_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",UsernameField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",PasswordField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"device_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"2"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
}

@end
