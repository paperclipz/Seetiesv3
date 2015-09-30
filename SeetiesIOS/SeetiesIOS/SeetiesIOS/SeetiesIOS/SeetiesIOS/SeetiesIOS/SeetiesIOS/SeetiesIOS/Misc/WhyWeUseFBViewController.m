//
//  WhyWeUseFBViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/19/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "WhyWeUseFBViewController.h"

@interface WhyWeUseFBViewController ()

@end

@implementation WhyWeUseFBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ShowWhyFacebook.frame = CGRectMake((screenWidth/2) - 142, 100, 284, 50);
    ShowDetail.frame = CGRectMake(15, (screenHeight/2) - 85, screenWidth - 30, 170);
    ShowPrivacy.frame = CGRectMake((screenWidth/2) - 149, screenHeight - 145, 298, 64);
    OkButton.frame = CGRectMake((screenWidth/2) - 144, screenHeight - 70, 288, 50);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
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
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Why We User Facebook Page";
    
    ShowWhyFacebook.text = NSLocalizedString(@"WhyWeUserFB_Title",nil);
    ShowDetail.text = NSLocalizedString(@"WhyWeUserFB_Detail",nil);
    ShowPrivacy.text = NSLocalizedString(@"WhyWeUserFB_Privacy",nil);
    
}
@end
