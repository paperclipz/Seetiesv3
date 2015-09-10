//
//  NotificationSettingsViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "NotificationSettingsViewController.h"

@interface NotificationSettingsViewController ()

@end

@implementation NotificationSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    MainScroll.alwaysBounceVertical = YES;
    [MainScroll setContentSize:CGSizeMake(screenWidth, 700)];
    
    EmailSwitch.frame = CGRectMake(screenWidth - 51 - 10, 110, 51, 31);
    
    InvitedFriendsSwitch.frame = CGRectMake(screenWidth - 51- 10, 197, 51, 31);
    FriendslikeSwitch.frame = CGRectMake(screenWidth - 51- 10, 240, 51, 31);
    FriendsFollowedSwitch.frame = CGRectMake(screenWidth - 51- 10, 282, 51, 31);
    FriendsSharedSwitch_1.frame = CGRectMake(screenWidth - 51- 10, 325, 51, 31);
    FriendsSharedSwitch_2.frame = CGRectMake(screenWidth - 51- 10, 369, 51, 31);
    
    SomeoneFollowedSwitch.frame = CGRectMake(screenWidth - 51- 10, 463, 51, 31);
    SomeoneMentionedSwitch.frame = CGRectMake(screenWidth - 51- 10, 507, 51, 31);
    SomeonelikedSwitch.frame = CGRectMake(screenWidth - 51- 10, 550, 51, 31);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
-(IBAction)SaveButton:(id)sender{

}
@end
