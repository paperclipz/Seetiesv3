//
//  EnbleLocationViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 10/1/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "EnbleLocationViewController.h"

@interface EnbleLocationViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation EnbleLocationViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
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
    [NotNowButton setTitle:LocalisedString(@"Not now") forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)NotNowButtonOnLCilck:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)AllowButtonOnClick:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
        
    }else{
        
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
    }
    NSLog(@"no location get feed data");
    [manager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking granting location access!");
            [self.locationManager startUpdatingLocation]; // this will access location automatically if user granted access manually. and will not show apple's request alert twice. (Tested)
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User denied location access request!!");
            NSLog(@"To re-enable, please go to Settings and turn on Location Service for this app.");
            [self.locationManager stopUpdatingLocation];
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            // clear text
            NSLog(@"Got Location");
            [self.locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}
@end
