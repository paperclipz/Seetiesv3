//
//  CTWebViewController.m
//  SeetiesIOS
//
//  Created by Evan Beh on 1/19/16.
//  Copyright © 2016 Stylar Network. All rights reserved.
//

#import "CTWebViewController.h"
#import "InstagramKit.h"


@interface CTWebViewController ()<UIWebViewDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *ibWebView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak)     InstagramEngine *instagramEngine;

@end

@implementation CTWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ibWebView.delegate = self;
    self.instagramEngine = [InstagramEngine sharedEngine];
    
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
    
    self.ibWebView.scrollView.bounces = NO;
    
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURL];
    [self.ibWebView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    //NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code",Insta_Client_ID,Insta_Client_callback];
    
    // [self.ibWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
}

#pragma mark - Web View Delegate for Instagram

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error])
    {
        
        
        
        SLog(@"login success");
        
        
        [self getInstagramUser];
        
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
    [LoadingManager hide];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:[NSString stringWithFormat:@"%@", error]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void)getInstagramUser
{
    
    [self.instagramEngine getUserDetails:@"self" withSuccess:^(InstagramUser * _Nonnull user) {
        
        
        DataManager* dataManager = [ConnectionManager dataManager];
        dataManager.instagramUserModel = user;
        
        if (self.didFinishLoadConnectionBlock) {
            self.didFinishLoadConnectionBlock();
        }
        
    } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
        SLog(@"%ldd",(long)serverStatusCode);
        
        
        
    }];
}

@end
