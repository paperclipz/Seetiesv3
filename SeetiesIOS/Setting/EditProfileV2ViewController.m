//
//  EditProfileV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/1/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import "EditProfileV2ViewController.h"

@interface EditProfileV2ViewController ()

@end

@implementation EditProfileV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    BackgroundImg.frame = CGRectMake(0, 64, screenWidth, 120);
    NSLog(@"BackgroundImg is %@",BackgroundImg);
    
    UserImg.contentMode = UIViewContentModeScaleAspectFill;
    UserImg.layer.backgroundColor=[[UIColor clearColor] CGColor];
    UserImg.layer.cornerRadius = 45;
    UserImg.layer.borderWidth = 5;
    UserImg.layer.masksToBounds = YES;
    UserImg.layer.borderColor=[[UIColor whiteColor] CGColor];
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
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
