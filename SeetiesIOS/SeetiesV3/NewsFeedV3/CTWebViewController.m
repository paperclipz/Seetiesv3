//
//  CTWebViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/19/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CTWebViewController.h"

@interface CTWebViewController ()<UIWebViewDelegate>
{
    NSMutableData *receivedData;

}
@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation CTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibWebView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData:(AnnouncementModel*)model
{
    self.lblTitle.text = model.title[[Utils getDeviceAppLanguageCode]];
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.relatedID]]];
    

}

-(void)initDataWithURL:(NSString *)url andTitle:(NSString*)title
{
    self.lblTitle.text = LocalisedString(title);
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];

}

-(void)initDataForInstagram
{

    [LoadingManager show];
    NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",Insta_Client_ID,Insta_Client_callback];
    
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    

}


#pragma mark - Web View Delegate for Instagram
-(BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //    [indicator startAnimating];
    
    SLog(@"%@",[[request URL] host]);
    if ([[[request URL] host] isEqualToString:SERVER_PATH_LINK_LIVE]) {
        
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
        
        if (verifier) {
            
            NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",Insta_Client_ID,Insta_Client_Secret,Insta_Client_callback,verifier];
            
            NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
            receivedData = [[NSMutableData alloc] init];
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
    [LoadingManager hide];

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
    
    InstagramModel* model = [[InstagramModel alloc]initWithData:receivedData error:nil];
    
    [ConnectionManager dataManager].instagramModel = model;
    
    if (self.didFinishLoadConnectionBlock) {
        self.didFinishLoadConnectionBlock();
    }
    
    SLog(@"instagram response String : %@",response);
  //  SBJsonParser *jResponse = [[SBJsonParser alloc]init];
//    NSDictionary *tokenData = [jResponse objectWithString:response];
//    //  WebServiceSocket *dconnection = [[WebServiceSocket alloc] init];
//    //   dconnection.delegate = self;
//    
//    NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@", [tokenData objectForKey:@"access_token"], self.isLogin];
//    //  NSString *pdata = [NSString stringWithFormat:@"type=3&token=%@&secret=123&login=%@",[tokenData accessToken.secret,self.isLogin];
//    //  [dconnection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
//    
//    
//    UIAlertView *alertView = [[UIAlertView alloc]
//                              initWithTitle:@"Instagram Access TOken"
//                              message:pdata
//                              delegate:nil
//                              cancelButtonTitle:@"OK"
//                              otherButtonTitles:nil];
//    [alertView show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
