//
//  PTnCViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PTnCViewController.h"
#import "PTellUsYourCityViewController.h"
#import "LLARingSpinnerView.h"


@interface PTnCViewController ()
@property (nonatomic, strong) LLARingSpinnerView *spinnerView;
@end

@implementation PTnCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    NSString *CheckStatus = @"1";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
   
}
-(void)GetFBLogin:(NSString *)Check{

    CheckFBLogin = Check;
    
    if ([CheckFBLogin isEqualToString:@"YES"]) {
      
    }else{
     [self SendLoginDataToServer];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // self.screenName = @"IOS Provisioning 1st";
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)AcceptAndContinueButton:(id)sender{

    UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Terms & Conditions" message:@"I agree to Seeties' Terms of Use & Privacy Notice" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Agree", nil];
    [ShowAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
        NSLog(@"Cancel");
    }else{
        //reset clicked
        PTellUsYourCityViewController *TellUsYourCityView = [[PTellUsYourCityViewController alloc]init];
        [self presentViewController:TellUsYourCityView animated:YES completion:nil];
    }
}
-(void)SendLoginDataToServer{
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.spinnerView = [[LLARingSpinnerView alloc] initWithFrame:CGRectZero];
    self.spinnerView.frame = CGRectMake((screenWidth/2) - 30, (screenHeight/2) - 30, 60, 60);
    self.spinnerView.tintColor = [UIColor colorWithRed:51.f/255 green:181.f/255 blue:229.f/255 alpha:1];
    //self.spinnerView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.spinnerView.lineWidth = 1.0f;
    [self.view addSubview:self.spinnerView];
    [self.spinnerView startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetLoginID = [defaults objectForKey:@"UserName"];
    GetPassword = [defaults objectForKey:@"UserPassword"];
    
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
    [body appendData:[[NSString stringWithFormat:@"%@",GetLoginID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetPassword] dataUsingEncoding:NSUTF8StringEncoding]];
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"ErrorConnection", nil) message:NSLocalizedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"ExpertLogin return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Expert Json = %@",res);
    
    [self.spinnerView stopAnimating];
    [self.spinnerView removeFromSuperview];
    
    NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
    NSLog(@"ErrorString is %@",ErrorString);
    NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
    NSLog(@"MessageString is %@",MessageString);
    
    if ([ErrorString isEqualToString:@"0"]) {
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [ShowAlert show];
    }else{
        [self.spinnerView stopAnimating];
        [self.spinnerView removeFromSuperview];
        NSLog(@"Got Data.");
        NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithArray:[res valueForKey:@"categories"]];
        NSLog(@"categoriesArray is %@",categoriesArray);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"country"]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *Getcrawler = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"crawler"]];
        NSLog(@"Getcrawler is %@",Getcrawler);
        NSString *Getcreated_at = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"created_at"]];
        NSLog(@"Getcreated_at is %@",Getcreated_at);
        NSString *Getdescription = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
        NSLog(@"Getdescription is %@",Getdescription);
        NSString *Getdob = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
        NSLog(@"Getdob is %@",Getdob);
        NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
        NSLog(@"Getemail is %@",Getemail);
        NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
        NSLog(@"Getusername is %@",Getusername);
        NSString *Getprofile_photo = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"profile_photo"]];
        NSLog(@"Getprofile_photo is %@",Getprofile_photo);
        NSString *Gettoken = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"token"]];
        NSLog(@"Gettoken is %@",Gettoken);
        NSString *Getuid = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"uid"]];
        NSLog(@"Getuid is %@",Getuid);
        
      //  NSString *CheckLogin = [[NSString alloc]initWithFormat:@"LoginDone"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:Gettoken forKey:@"ExpertToken"];
        [defaults setObject:Getusername forKey:@"UserName"];
        [defaults setObject:Getprofile_photo forKey:@"UserProfilePhoto"];
        [defaults setObject:Getuid forKey:@"Useruid"];
       // [defaults setObject:CheckLogin forKey:@"CheckLogin"];
        [defaults synchronize];
        
        
        PTellUsYourCityViewController *TellUsYourCityView = [[PTellUsYourCityViewController alloc]init];
        [self presentViewController:TellUsYourCityView animated:YES completion:nil];
    }
}
@end
