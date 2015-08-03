//
//  AddLinkViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/7/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "AddLinkViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface AddLinkViewController ()

@end

@implementation AddLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddContactField.delegate = self;
    ShowTitle.text = CustomLocalisedString(@"link", nil);
    ShowSubTitle.text = CustomLocalisedString(@"TellusLink", nil);
    [BackButton setTitle:CustomLocalisedString(@"Discard", nil) forState:UIControlStateNormal];
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    
   // CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
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
-(void)GetWhatLink:(NSString *)GetLink{

    GetDataLink = GetLink;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"IOS Add Link View V2";
    [AddContactField becomeFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([GetDataLink isEqualToString:@"Blog"]) {
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"PublishV2_BlogLink"]];
        if ([TempString length] == 0 || [TempString isEqualToString:@"(null)"] || [TempString isEqualToString:CustomLocalisedString(@"AddLink", nil)]) {
            AddContactField.placeholder = @"www.bloglink.com/post";
        }else{
            AddContactField.text = TempString;
        }
    }else{
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"PublishV2_Link"]];
        if ([TempString length] == 0 || [TempString isEqualToString:@"(null)"] || [TempString isEqualToString:CustomLocalisedString(@"Addfb", nil)]) {
            AddContactField.placeholder = @"www.facebook.com/shopname";
        }else{
            AddContactField.text = TempString;
        }
    }
    
    
    
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
        if ([GetDataLink isEqualToString:@"Blog"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:AddContactField.text forKey:@"PublishV2_BlogLink"];
            [defaults synchronize];
        }else{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:AddContactField.text forKey:@"PublishV2_Link"];
            [defaults synchronize];
        }

        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
