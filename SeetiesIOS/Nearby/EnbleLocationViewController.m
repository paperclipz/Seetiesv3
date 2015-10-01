//
//  EnbleLocationViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 10/1/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "EnbleLocationViewController.h"

@interface EnbleLocationViewController ()

@end

@implementation EnbleLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowNearbyImg.frame = CGRectMake((screenWidth / 2) - 150, 28, 299, 281);
    
    ShowSettingText.frame = CGRectMake((screenWidth / 2) - 110, screenHeight - 60, 220, 40);
    NotNowButton.frame = CGRectMake((screenWidth / 2) - 110, screenHeight - 130, 220, 50);
    AllowButton.frame = CGRectMake((screenWidth / 2) - 110, screenHeight - 190, 220, 50);
    ShowText.frame = CGRectMake((screenWidth / 2) - 110, screenHeight - 270, 220, 60);
    
    AllowButton.layer.cornerRadius= 25;
    AllowButton.layer.borderWidth = 1;
    AllowButton.layer.masksToBounds = YES;
    AllowButton.layer.borderColor=[[UIColor  whiteColor] CGColor];
    
    NotNowButton.layer.cornerRadius= 25;
    NotNowButton.layer.borderWidth = 1;
    NotNowButton.layer.masksToBounds = YES;
    NotNowButton.layer.borderColor=[[UIColor  whiteColor] CGColor];
    
    ShowSettingText.text = LocalisedString(@"You can change this setting in your Location Service");
    ShowText.text = LocalisedString(@"Hey there! Do enable location to give & receive the best recommendations and deals near you.");
    [AllowButton setTitle:LocalisedString(@"Allow location access") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)NotNowButtonOnLCilck:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)AllowButtonOnClick:(id)sender{}
@end
