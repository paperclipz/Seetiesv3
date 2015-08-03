//
//  AddContactViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/31/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "AddContactViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface AddContactViewController ()

@end

@implementation AddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddContactField.delegate = self;
    ShowTitle.text = CustomLocalisedString(@"AddContact", nil);
    ShowSubTitle.text = CustomLocalisedString(@"TellusContact", nil);
    [BackButton setTitle:CustomLocalisedString(@"Discard", nil) forState:UIControlStateNormal];
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 75, 20, 60, 44);
    WhiteBackground.frame = CGRectMake(0, 90, screenWidth, 100);
    AddContactField.frame = CGRectMake(15, 91, screenWidth - 30, 60);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"IOS Add Contact View V2";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"PublishV2_Contact"]];
    if ([TempString length] == 0 || [TempString isEqualToString:@"(null)"] || [TempString isEqualToString:CustomLocalisedString(@"AddPhoneNumber", nil)]) {
        AddContactField.placeholder = @"+60123456789";
    }else{
        AddContactField.text = TempString;
    }
        
    [AddContactField becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [AddContactField resignFirstResponder];
}
-(IBAction)BackButton:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)SaveButton:(id)sender{
    
    if ([AddContactField.text length] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:AddContactField.text forKey:@"PublishV2_Contact"];
        [defaults synchronize];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
