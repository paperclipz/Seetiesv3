//
//  ReportViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/25/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MainScroll.alwaysBounceVertical = YES;

    SelectedInappropriate.frame = CGRectMake(screenWidth - 35, 102, 25, 25);
    SelectedCopyright.frame = CGRectMake(screenWidth - 35, 194, 25, 25);
    
    SelectedCopyright.hidden = YES;
    SelectedInappropriate.hidden = YES;
    
    DescriptionText.delegate = self;
    
    CheckStatus = 0;
}
-(void)GetPostID:(NSString *)PostID{

    GetPostID = PostID;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    [DescriptionText resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)InappropriateButtonOnClick:(id)sender{
    InappropriateButton.selected = !InappropriateButton.selected;
    
    if (InappropriateButton.selected) {
        SelectedInappropriate.hidden = NO;
        CheckStatus = 1;
    }else{
        SelectedInappropriate.hidden = YES;
        CheckStatus = 0;
    }
    
}
-(IBAction)CopyrightButtonOnClick:(id)sender{
    CopyrightButton.selected = !CopyrightButton.selected;
    
    if (CopyrightButton.selected) {
        SelectedCopyright.hidden = NO;
        CheckStatus = 2;
    }else{
        SelectedCopyright.hidden = YES;
        CheckStatus = 0;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
if ([DescriptionText.text length] == 0) {
    DescriptionText.text = @"Please provide a description.";
}
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([DescriptionText.text isEqualToString:@"Please provide a description."]) {
        DescriptionText.text = @"";
    }else{
        
    }

    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [DescriptionText resignFirstResponder];
}
-(void)textViewDidChange:(UITextView *)textView
{
    CheckStatus = 0;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == DescriptionText) {
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
                }
    }
    return YES;
}

-(IBAction)SaveButton:(id)sender{
    [self SendReportToServer];
    [DescriptionText resignFirstResponder];
}
-(void)SendReportToServer{
    [ShowActivity startAnimating];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    
    NSString *GetString;
    if (CheckStatus == 0) {
        GetString = DescriptionText.text;
        if ([GetString isEqualToString:@""] || [GetString length] == 0) {
            GetString = @"";
        }
    }else if(CheckStatus == 1){
    GetString = @"This post has content that violates terms & condition in Seeties.";
    }else if(CheckStatus == 2){
    GetString = @"This post users copyrighted works without permission.";
    }
    
    
    
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@post/%@/flag",DataUrl.UserWallpaper_Url,GetPostID];
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
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetString] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    theConnection_Report = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Report) {
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
    [ShowActivity stopAnimating];
    //    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Connection" message:@"Check your wifi or 3G data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //
    //    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_Report) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"Report return get data to server ===== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        NSLog(@"Expert Json = %@",res);
        
        
        NSString *statusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"statusString is %@",statusString);
        
        if ([statusString isEqualToString:@"ok"]) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
    [ShowActivity stopAnimating];
}
@end
