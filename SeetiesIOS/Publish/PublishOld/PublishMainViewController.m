//
//  PublishMainViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PublishMainViewController.h"
#import "PublishViewController.h"
#import "DraftsViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface PublishMainViewController ()

@end

@implementation PublishMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
    NSInteger selectedIndex = 0;
    Locale *selectedLocale = [languageManager getSelectedLocale];
    selectedIndex = [languageManager.availableLocales indexOfObject:selectedLocale];
    NSLog(@"selectedIndex is %li",(long)selectedIndex);
    

    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetUsername;
    NSString *GetUsername1 = [defaults objectForKey:@"UserData_Name"];
    NSLog(@"GetUsername1 is %@",GetUsername1);
    NSString *FullString;
    if ([GetUsername1 isEqualToString:@"(null)"] || [GetUsername1 length] == 0) {
        GetUsername = [defaults objectForKey:@"UserName"];
        
        if (selectedIndex == 1 || selectedIndex == 2) {
            FullString = [[NSString alloc]initWithFormat:@"%@ %@",GetUsername,CustomLocalisedString(@"GoodDay", nil)];
        }else{
            FullString = [[NSString alloc]initWithFormat:@"%@ %@,",CustomLocalisedString(@"GoodDay", nil),GetUsername];
        }
    }else{
        if (selectedIndex == 1 || selectedIndex == 2) {
            FullString = [[NSString alloc]initWithFormat:@"%@ %@",GetUsername1,CustomLocalisedString(@"GoodDay", nil)];
        }else{
            FullString = [[NSString alloc]initWithFormat:@"%@ %@,",CustomLocalisedString(@"GoodDay", nil),GetUsername1];
        }
    }
    
    

    
    
    
    
    ShowUsername.text = FullString;
    DetailLabel.text = CustomLocalisedString(@"WhatWouldyouiketodo", nil);
    DraftsLabel.text = CustomLocalisedString(@"GotoDrafts", nil);
    RecommendText.text = CustomLocalisedString(@"Recommend", nil);
    SomethingText.text = CustomLocalisedString(@"SometingOnSeeties", nil);
    //[PublishButton setTitle:CustomLocalisedString(@"RecommendSometingOnSeeties",nil) forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    self.screenName = @"IOS Publish Main Page";
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIImageView *ShowImage = [[UIImageView alloc]init];
    ShowImage.frame = CGRectMake(135, screenHeight - 49, 50, 49);
    ShowImage.image = [UIImage imageNamed:@"TabBarCancel.png"];
    [self.tabBarController.view addSubview:ShowImage];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *CheckPost = [defaults objectForKey:@"CheckPost"];
    if ([CheckPost isEqualToString:@"Done"]) {
        CheckPost = @"False";
        [defaults setObject:CheckPost forKey:@"CheckPost"];
        [defaults synchronize];
        [self.tabBarController setSelectedIndex:0];
    }else{

    }
    
    

    
    
    
    
}
-(IBAction)PublishButton:(id)sender{
    PublishViewController *PublishView = [[PublishViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PublishView animated:NO completion:nil];
}
-(IBAction)DraftsButton:(id)sender{
    DraftsViewController *DraftsView = [[DraftsViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:DraftsView animated:NO completion:nil];
}
@end
