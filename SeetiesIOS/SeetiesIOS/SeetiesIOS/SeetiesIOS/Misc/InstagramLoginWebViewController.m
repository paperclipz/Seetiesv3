//
//  InstagramLoginWebViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/13/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "InstagramLoginWebViewController.h"

@interface InstagramLoginWebViewController ()

@end

@implementation InstagramLoginWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    MainWebView.frame = CGRectMake(0, 64, 320, screenHeight - 64);
    MainWebView.delegate = self;
    ShowActivity.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    client_id = @"ab7f100c649f43838358f36abed5033f";
    secret = @"b3e6ef4fb2094b60b9c44e204d24b476";
    callback = @"https://seeties.me";
    
    
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",client_id,callback];
    
    [MainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    [ShowActivity startAnimating];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    if ([[[request URL] host] isEqualToString:@"seeties.me"]) {
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"code"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        NSLog(@"verifier is %@",verifier);
        if (verifier) {
            NSLog(@"work here ???");
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,secret,callback,verifier];
            
            NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            if(theConnection) {
                receivedData = [[NSMutableData alloc] init];
            } else {
                
            }
            
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    NSLog(@"Instagram response is %@",response);
    
    NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Instagram res is %@",res);
    
    NSString *GetAccessToken = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"access_token"]];
    NSLog(@"GetAccessToken is %@",GetAccessToken);
    
    NSDictionary *NSDictionaryUserData = [res valueForKey:@"user"];
//    NSLog(@"NSDictionaryUserData is %@",NSDictionaryUserData);
//    
//    NSString *Getbio = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"bio"]];
//    NSLog(@"Getbio is %@",Getbio);
//    
//    NSString *Getwebsite = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"website"]];
//    NSLog(@"Getwebsite is %@",Getwebsite);
//    
//    NSString *Getfull_name = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"full_name"]];
//    NSLog(@"Getfull_name is %@",Getfull_name);
    
    NSString *Getid = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"id"]];
    NSLog(@"Getid is %@",Getid);
    
//    NSString *Getprofile_picture = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"profile_picture"]];
//    NSLog(@"Getprofile_picture is %@",Getprofile_picture);
//    
//    NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[NSDictionaryUserData objectForKey:@"username"]];
//    NSLog(@"Getusername is %@",Getusername);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetAccessToken forKey:@"InstagramToken"];
    [defaults setObject:Getid forKey:@"InstagramID"];
    [defaults synchronize];
    
    [ShowActivity stopAnimating];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
