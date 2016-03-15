//
//  ChangePasswordViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/5/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface ChangePasswordViewController ()
{
    IBOutlet TPKeyboardAvoidingScrollView *Scrollview;
    IBOutlet UITextField *OldPasswordText;
    IBOutlet UITextField *NewPasswordText;
    IBOutlet UITextField *KeyinAgainText;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIButton *SubmitButton;
    IBOutlet UIImageView *BarImage;
    
    NSString *GetOldPassword;
    NSString *GetNewPassword;
    NSString *GetNewPasswordAgain;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *CheckFB;
    
    IBOutlet UIImageView *BackgroundImage001;
    IBOutlet UIImageView *BackgroundImage002;
    
    IBOutlet UIImageView *RedIcon1;
    IBOutlet UIImageView *RedIcon2;
    IBOutlet UIImageView *RedIcon3;
}
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SubmitButton.frame = CGRectMake(screenWidth - 60 , 29, 60, 30);
    Scrollview.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    Scrollview.delegate = self;
    BackgroundImage001.frame = CGRectMake(0, 79, screenWidth, 89);
    BackgroundImage002.frame = CGRectMake(0, 123, screenWidth, 89);
    
    RedIcon1.frame = CGRectMake(screenWidth - 40, 95, 12, 12);
    RedIcon2.frame = CGRectMake(screenWidth - 40, 137, 12, 12);
    RedIcon3.frame = CGRectMake(screenWidth - 40, 185, 12, 12);
    
    TitleLabel.text = CustomLocalisedString(@"ChangePassword", nil);
    [SubmitButton setTitle:CustomLocalisedString(@"Submit",nil) forState:UIControlStateNormal];
    OldPasswordText.placeholder = CustomLocalisedString(@"CurrentPassword", nil);
    NewPasswordText.placeholder = CustomLocalisedString(@"NewPassword", nil);
    KeyinAgainText.placeholder = CustomLocalisedString(@"NewPasswordAgain", nil);
    
    OldPasswordText.delegate = self;
    NewPasswordText.delegate = self;
    KeyinAgainText.delegate = self;
    
    
    RedIcon1.hidden = YES;
    RedIcon2.hidden = YES;
    RedIcon3.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    [super viewWillAppear:animated];
    self.screenName = @"IOS Change Password Page";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CheckFB = [defaults objectForKey:@"CheckPassword"];
    NSLog(@"CheckFB is %@",CheckFB);
    if ([CheckFB isEqualToString:@"0"]) {
        BackgroundImage002.hidden = YES;
        OldPasswordText.hidden = YES;
        NewPasswordText.frame = CGRectMake(15, 81, screenWidth - 30, 40);
        KeyinAgainText.frame = CGRectMake(15, 123, screenWidth - 30, 40);
    }else{
    
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == OldPasswordText) {
        [OldPasswordText resignFirstResponder];
        [NewPasswordText becomeFirstResponder];
    }else if(textField == NewPasswordText){
        [NewPasswordText resignFirstResponder];
        [KeyinAgainText becomeFirstResponder];
        // RedIcon.hidden = NO;
    }else{
        [textField resignFirstResponder];
    }
    
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == OldPasswordText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        if ([newString length] == 0) {
            RedIcon1.hidden = YES;
        }else{
            if([newString length] < 8){
                RedIcon1.hidden = NO;
            }else{
                RedIcon1.hidden = YES;
                //[PasswordField resignFirstResponder];
            }
        }
        
    }
    if (textField == NewPasswordText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        if ([newString length] == 0) {
            RedIcon2.hidden = YES;
        }else{
            if([newString length] < 8){
                RedIcon2.hidden = NO;
            }else{
                RedIcon2.hidden = YES;
                //[PasswordField resignFirstResponder];
            }
        }
        
    }
    if (textField == KeyinAgainText) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        if ([newString length] == 0) {
            RedIcon3.hidden = YES;
        }else{
            if([newString length] < 8){
                RedIcon3.hidden = NO;
            }else{
                RedIcon3.hidden = YES;
                //[PasswordField resignFirstResponder];
            }
        }
        
    }
    
    
    return YES;
}
-(IBAction)SubmitButton:(id)sender{
    
    GetOldPassword = OldPasswordText.text;
    GetNewPassword = NewPasswordText.text;
    GetNewPasswordAgain = KeyinAgainText.text;
    
    NSLog(@"GetOldPassword is %@",GetOldPassword);
    NSLog(@"GetNewPassword is %@",GetNewPassword);
    NSLog(@"GetNewPasswordAgain is %@",GetNewPasswordAgain);

    
    if ([CheckFB isEqualToString:@"0"]) {
        if ([GetNewPassword isEqualToString:GetNewPasswordAgain]) {
            [self SendDataToServer];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"New Password Not Same." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }else{
        if ([GetOldPassword length] == 0 && [GetNewPassword length] == 0 && [GetNewPasswordAgain length] == 0) {
            RedIcon1.hidden = NO;
            RedIcon2.hidden = NO;
            RedIcon3.hidden = NO;
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"All field cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            if ([GetOldPassword length] == 0 || [GetNewPassword length] == 0 || [GetNewPasswordAgain length] == 0) {
                if ([GetOldPassword length] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Current password cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    RedIcon1.hidden = NO;
                }
                if ([GetNewPassword length] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"New password cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    RedIcon2.hidden = NO;
                }
                if ([GetNewPasswordAgain length] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Confirm new password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    RedIcon3.hidden = NO;
                }
                
            }else{
                if ([GetNewPassword isEqualToString:GetNewPasswordAgain]) {
                    [self SendDataToServer];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"New Password Not Same." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    RedIcon2.hidden = NO;
                    RedIcon3.hidden = NO;
                }
            }
        }


    }


    

    

    
}
-(void)SendDataToServer{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [LoadingManager show];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [Utils getAppToken];
    NSString *Getuid = [Utils getUserID];
    
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@/change-password",DataUrl.UserWallpaper_Url,Getuid];
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
    
    if ([CheckFB isEqualToString:@"0"]) {
        
    }else{
        //parameter second
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the key name @"parameter_second" to the post body
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"old_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //Attaching the content to be posted ( ParameterSecond )
        [body appendData:[[NSString stringWithFormat:@"%@",GetOldPassword] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    

    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"new_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetNewPassword] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [LoadingManager hide];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"ChangePasword return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"res is %@",res);
    
    NSString *GetStatus = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
    NSLog(@"GetStatus is %@",GetStatus);
    
    if ([GetStatus isEqualToString:@"ok"]) {
        NSDictionary *GetAllData = [res valueForKey:@"data"];
        NSString *GetToken = [[NSString alloc]initWithFormat:@"%@",[GetAllData objectForKey:@"token"]];
        NSLog(@"GetToken is %@",GetToken);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:GetToken forKey:TOKEN];
        [defaults setObject:@"1" forKey:@"CheckPassword"];
        [defaults synchronize];
        
        [self BackButton:self.view];
    }else{
        NSString *GetMessage = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
        NSLog(@"GetMessage is %@",GetMessage);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:GetMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    
    
    [LoadingManager hide];
    

}
@end
