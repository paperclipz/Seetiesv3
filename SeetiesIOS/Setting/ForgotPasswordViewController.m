//
//  ForgotPasswordViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "LLARingSpinnerView.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface ForgotPasswordViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation ForgotPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    InputText.delegate = self;
    
    TitleLabel.text = CustomLocalisedString(@"ForgotPassword", nil);
    DetailLabel.text = CustomLocalisedString(@"ForgotPasswordDetail", nil);
    [ResetButton setTitle:CustomLocalisedString(@"ResetPassword",nil) forState:UIControlStateNormal];
    InputText.placeholder = CustomLocalisedString(@"ExpertLogin_Username", nil);
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BackGroundButton.frame = CGRectMake(30, 154, screenWidth - 60, 44);
   // TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    DetailLabel.frame = CGRectMake(30, 85, screenWidth - 60, 66);
    ResetButton.frame = CGRectMake(30, 212, screenWidth - 60, 50);
    InputText.frame = CGRectMake(35, 161, screenWidth - 70, 30);
    LogoImg.frame = CGRectMake((screenWidth / 2) - 20, 20, 40, 40);
    
    ResetButton.layer.cornerRadius = 5;
    BackGroundButton.layer.cornerRadius = 5;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Forgot Password Page";
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)resetButton:(id)sender{
    NSLog(@"Get inputtext is %@",InputText.text);
    if ([InputText.text length] == 0) {
        
    }else{
        [self sendDataToServer];
    }
}
-(void)sendDataToServer{
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
    NSString *urlString = [NSString stringWithFormat:@"%@forgot-password",DataUrl.UserWallpaper_Url];
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
    [body appendData:[[NSString stringWithFormat:@"%@",InputText.text] dataUsingEncoding:NSUTF8StringEncoding]];
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
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Forgot Password return get data to server ===== %@",GetData);
    
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
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Please try again" message:GetMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }else{
        if ([GetStatus isEqualToString:@"ok"]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:@"You should get an email soon." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
        }else{
        
        }
        
    }
    
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
}
@end
