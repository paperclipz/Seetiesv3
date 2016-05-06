//
//  PTellUsYourCityViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "PTellUsYourCityViewController.h"

#import "PSearchLocationViewController.h"
#import "PSelectYourInterestViewController.h"
@interface PTellUsYourCityViewController ()

@end

@implementation PTellUsYourCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSString *CheckStatus = @"2";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:CheckStatus forKey:@"CheckProvisioningStatus"];
    [defaults synchronize];
    
    MainScorll.delegate = self;
    [MainScorll setContentSize:CGSizeMake(screenWidth, screenHeight)];
    MainScorll.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    
    backgroundLanguage.frame = CGRectMake(0, 357, screenWidth, 89);
    backgroundLocation.frame = CGRectMake(0, 167, screenWidth, 45);
    SkipButton.frame = CGRectMake(screenWidth - 50 - 15, 27, 50, 30);
    ShowTitle_City.frame = CGRectMake(0, 61, screenWidth, 50);
    ShowTitle_Lang.frame = CGRectMake(0, 264, screenWidth, 40);
    ShowSubTitle_City.frame = CGRectMake(40, 109, screenWidth - 80, 40);
    ShowSubTitle_Lang.frame = CGRectMake(0, 294, screenWidth, 48);
    ShowLocation.frame = CGRectMake(15, 175, screenWidth - 30, 30);
    
    ShowSelectLang01.frame = CGRectMake(screenWidth - 189 - 15, 367, 189, 21);
    ShowSelectLang02.frame = CGRectMake(screenWidth - 189 - 15, 413, 189, 21);
    
    SelectLangButton01.frame = CGRectMake(0, 357, screenWidth, 42);
    SelectLangButton02.frame = CGRectMake(0, 401, screenWidth, 42);
    
    CantinueButton.frame = CGRectMake((screenWidth/2) - 144, 482, 288, 50);
    
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,screenWidth, 44)];
    Toolbar.translucent = NO;
    Toolbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:Toolbar];
    
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    LanguageArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
//    LanguageArray = [[NSMutableArray alloc]init];
//    [LanguageArray addObject:@"English"];
//    [LanguageArray addObject:@"Chinese"];
    
    Language_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    [self.view addSubview:Language_PickerView];
    Language_PickerView.delegate = self;
    Language_PickerView.backgroundColor = [UIColor whiteColor];
    Language_PickerView.showsSelectionIndicator = YES;
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    CheckSelectLang = 0;
    
    GetSelectLang01 = @"530b0ab26424400c76000003";
    GetSelectLang02 = @"530b0ab26424400c76000003";
    GetSelectLangText01 = @"English";
    GetSelectLangText02 = @"English";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    ShowTitle_City.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_1",nil);
    ShowTitle_Lang.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_6",nil);
    ShowSubTitle_City.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_2",nil);
    ShowSubTitle_Lang.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_7",nil);
    ShowPrimary.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_9",nil);
    ShowSecondary.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_10",nil);
    [CantinueButton setTitle:NSLocalizedString(@"Provisioning_PTellUsYourCityView_8",nil) forState:UIControlStateNormal];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetLocationString = [defaults objectForKey:@"Provisioning_LocationName"];
    if ([GetLocationString length] == 0) {
        ShowLocation.text = NSLocalizedString(@"Provisioning_PTellUsYourCityView_5",nil);
    }else{
        ShowLocation.text = GetLocationString;
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

}
-(IBAction)DoneSelect:(id)sender{
    
    Language_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
     CheckSelectLang = 0;
    
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return LanguageArray.count;
    return [LanguageArray count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    if (CheckSelectLang == 1) {
        GetSelectLang01 = [LanguageIDArray objectAtIndex:row];
        GetSelectLangText01 = [LanguageArray objectAtIndex:row];
        ShowSelectLang01.text = GetSelectLangText01;

    }else{
        GetSelectLang02 = [LanguageIDArray objectAtIndex:row];
        GetSelectLangText02 = [LanguageArray objectAtIndex:row];
        ShowSelectLang02.text = GetSelectLangText02;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [LanguageArray objectAtIndex:row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)ContinueButton:(id)sender{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetSelectLang01 forKey:@"Provisioning_SelectLanguage01"];
    [defaults setObject:GetSelectLang02 forKey:@"Provisioning_SelectLanguage02"];
    [defaults synchronize];
    
    PSelectYourInterestViewController *SelectYourInterestView = [[PSelectYourInterestViewController alloc]init];
    [self presentViewController:SelectYourInterestView animated:YES completion:nil];
    
//    NSLog(@"setObject:GetSelectLang01 is %@",GetSelectLang01);
//    NSLog(@"setObject:GetSelectLang02 is %@",GetSelectLang02);
}
-(IBAction)SkipButton:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetSelectLang01 forKey:@"Provisioning_SelectLanguage01"];
    [defaults setObject:GetSelectLang02 forKey:@"Provisioning_SelectLanguage02"];
    [defaults synchronize];
    
    PSelectYourInterestViewController *SelectYourInterestView = [[PSelectYourInterestViewController alloc]init];
    [self presentViewController:SelectYourInterestView animated:YES completion:nil];
}
-(IBAction)SelectLangButton01:(id)sender{
    NSLog(@"in here???");
    Language_PickerView.hidden = NO;
    Toolbar.hidden = NO;
    CheckSelectLang = 1;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    LanguageArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    
    [LanguageArray removeObject:GetSelectLangText02];
    [LanguageIDArray removeObject:GetSelectLang02];
    [Language_PickerView reloadAllComponents];
    
    NSLog(@"LanguageArray is %@",LanguageArray);
    NSLog(@"LanguageIDArray is %@",LanguageIDArray);
}
-(IBAction)SelectLangButton02:(id)sender{
    Language_PickerView.hidden = NO;
    Toolbar.hidden = NO;
    CheckSelectLang = 2;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *LanguageID_Array = [defaults objectForKey:@"LanguageData_ID"];
    NSMutableArray *LanguageName_Array = [defaults objectForKey:@"LanguageData_Name"];
    
    LanguageIDArray = [[NSMutableArray alloc]initWithArray:LanguageID_Array];
    LanguageArray = [[NSMutableArray alloc]initWithArray:LanguageName_Array];
    [LanguageArray addObject:@"None"];
    [LanguageIDArray addObject:@""];
    
    [LanguageArray removeObject:GetSelectLangText01];
    [LanguageIDArray removeObject:GetSelectLang01];
    [Language_PickerView reloadAllComponents];
   
}
-(IBAction)SearchLocationButton:(id)sender{
    PSearchLocationViewController *PSearchLocationView = [[PSearchLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:PSearchLocationView animated:NO completion:nil];
}
@end
