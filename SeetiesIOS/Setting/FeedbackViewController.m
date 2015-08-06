//
//  FeedbackViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LLARingSpinnerView.h"

#import "LanguageManager.h"
#import "Locale.h"
@interface FeedbackViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation FeedbackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SubmitButton.frame = CGRectMake(screenWidth - 60 - 15 , 29, 60, 30);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    Scrollview.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    Scrollview.delegate = self;
    
    TextBack.frame = CGRectMake(0, 73, screenWidth, 145);
    LoginBack.frame = CGRectMake(0, 218, screenWidth, 89);
    
    AddImageDone.frame = CGRectMake(screenWidth - 25 - 15, 274, 25, 25);
    AddImageButton.frame = CGRectMake(15, 269, screenWidth - 30, 30);
    
    
    NSLog(@"name: %@", [[UIDevice currentDevice] name]);
    NSLog(@"systemName: %@", [[UIDevice currentDevice] systemName]);
    NSLog(@"systemVersion: %@", [[UIDevice currentDevice] systemVersion]);
    
    EmailField.delegate = self;
    FeedbackField.delegate = self;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetEmail = [defaults objectForKey:@"UserData_Email"];
    EmailField.text = GetEmail;
    
    AddImageDone.hidden = YES;
    
    SystemString = [[NSString alloc]initWithFormat:@"%@,%@,%@",[[UIDevice currentDevice] name],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]];
    
    TitleLabel.text = CustomLocalisedString(@"SettingsPage_Feedback", nil);
    [SubmitButton setTitle:CustomLocalisedString(@"Submit",nil) forState:UIControlStateNormal];
    [AddImageButton setTitle:CustomLocalisedString(@"IncludeScreenshot",nil) forState:UIControlStateNormal];
    FeedbackField.text = CustomLocalisedString(@"FeedbackDetail", nil);
    EmailField.placeholder = CustomLocalisedString(@"SignUpPage_Email", nil);
    
    GetImageData = [[UIImage alloc]init];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS FeedBack Page";
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"did begin editing");
    FeedbackField.text = @"";
    FeedbackField.textColor = [UIColor blackColor];
}
-(IBAction)AddImageButton:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    GetImageData = image;
    NSLog(@"GetImageData is %@",GetImageData);
    AddImageDone.hidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}
-(IBAction)SubmitButton:(id)sender{

    if ([FeedbackField.text length] == 0 || [EmailField.text length] == 0 || [FeedbackField.text isEqualToString:CustomLocalisedString(@"FeedbackDetail", nil)]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Email / Experience cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        BOOL eb=[self validateEmail:EmailField.text];
        
        if(!eb)
        {
            UIAlertView *alertsuccess = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter correct email id"
                                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alertsuccess show];
            
        }else{
            [self SendFeedBackData];
        }
        
    }
}
-(void)SendFeedBackData{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    self.spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.spinnerView.lineWidth = 1.0f;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];

    
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@system/feedback",DataUrl.UserWallpaper_Url];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"feedback"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",EmailField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",FeedbackField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"spec\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",SystemString] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (AddImageDone.hidden == NO) {
      //  NSData *imageData = UIImagePNGRepresentation(GetImageData);
        NSData *imageData = [[NSData alloc] initWithData:UIImageJPEGRepresentation((GetImageData), 0.5)];
        NSInteger imageSize = imageData.length;
        NSLog(@"SIZE OF IMAGE: %li ", (long)imageSize);
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"screenshot\"; filename=\"FeedBackImage.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
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
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
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
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Feedback return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"res is %@",res);
    
    NSString *GetError = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    NSLog(@"GetError is %@",GetError);
    NSString *GetMessage = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"GetMessage is %@",GetMessage);
    NSString *GetStatus = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
    NSLog(@"GetStatus is %@",GetStatus);

    if ([GetError isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:GetMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        if ([GetStatus isEqualToString:@"ok"]) {
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
    
    
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    

}
@end
