//
//  OpenWebViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/1/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "OpenWebViewController.h"
#import "LanguageManager.h"
#import "Locale.h"

@interface OpenWebViewController ()

@end

@implementation OpenWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DataUrl = [[UrlDataClass alloc]init];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    NSLog(@"screenHeight is %f",screenHeight);
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    web.frame = CGRectMake(0, 64, screenWidth, screenHeight - 108);
    activityIndicator.frame = CGRectMake(screenWidth - 20 - 15, 36, 20, 20);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    UIToolbar *toolbar = [[UIToolbar alloc]init];
    toolbar.frame = CGRectMake(0, screenHeight - 44, screenWidth, 44);
    UIBarButtonItem *spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(WebBackButton:)];
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button2=  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(WebForwardButton:)];
    UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button3=  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(RefreshButton:)];
    UIBarButtonItem *spacer4 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *button4=  [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(StopButton:)];
    UIBarButtonItem *spacer5 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f]];
    [toolbar setItems:[[NSArray alloc] initWithObjects:spacer1,button1,spacer2,button2,spacer3,button3,spacer4,button4,spacer5,nil]];
    //[toolbar setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    [self.view addSubview:toolbar];
    
    NSLog(@"toolbar is %@",toolbar);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Web View Page";
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)GetTitleString:(NSString *)String{

    GetStringText = String;
    
    if ([GetStringText isEqualToString:@"AboutSeeties"]) {
        url = [[NSString alloc]initWithFormat:@"https://seeties.me/about"];
    }else if ([GetStringText isEqualToString:@"TermsofUse"]) {
        url = [[NSString alloc]initWithFormat:@"https://seeties.me/terms"];
    }else if ([GetStringText isEqualToString:@"PrivacyPolicy"]){
        url = [[NSString alloc]initWithFormat:@"https://seeties.me/privacy"];
    }else if ([GetStringText isEqualToString:@"Festival"]){
        url = [[NSString alloc]initWithFormat:@"%@",DataUrl.GetFestivals_Url];
        ShowTitle.text = @"Festivals";
    }else{
        url = GetStringText;
    }
    
    
    [web setBackgroundColor:[UIColor whiteColor]];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(timerload) userInfo:nil repeats:YES];
}
-(void)GetTitleString:(NSString *)StringTitle GetFestivalUrl:(NSString *)StringUrl{

    GetStringText = StringTitle;
    url = StringUrl;
    ShowTitle.text = @"Festivals";
    
    
    [web setBackgroundColor:[UIColor whiteColor]];
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/2.0) target:self selector:@selector(timerload) userInfo:nil repeats:YES];
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
-(void)timerload{
    if (web.loading) {
        [activityIndicator startAnimating];
    }else{
        [activityIndicator stopAnimating];
    }
}
-(IBAction)WebBackButton:(id)sender{
     [web goBack];
}
-(IBAction)WebForwardButton:(id)sender{
    [web goForward];
}
-(IBAction)RefreshButton:(id)sender{
    [web reload];
}
-(IBAction)StopButton:(id)sender{//share to open safari and copy link
    //[web stopLoading];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:CustomLocalisedString(@"SettingsPage_Cancel", nil)
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Open in Safari",@"Copy Link", nil];
    
    [actionSheet showInView:self.view];
    
    actionSheet.tag = 200;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 200) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        
        if  ([buttonTitle isEqualToString:@"Open in Safari"]) {
            NSLog(@"Open in Safari");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        if ([buttonTitle isEqualToString:@"Copy Link"]) {
            NSLog(@"Copy Link");
            NSString *message = [NSString stringWithFormat:@"%@",url];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = message;
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}
@end
