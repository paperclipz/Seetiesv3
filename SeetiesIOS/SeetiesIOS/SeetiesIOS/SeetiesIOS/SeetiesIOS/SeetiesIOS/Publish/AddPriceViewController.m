//
//  AddPriceViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/31/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "AddPriceViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface AddPriceViewController ()

@end

@implementation AddPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    AddPriceField.delegate = self;
    
    ShowTitle.text = CustomLocalisedString(@"Price", nil);
    ShowSubTitle.text = CustomLocalisedString(@"Tellushowmuch", nil);
    [BackButton setTitle:CustomLocalisedString(@"Discard", nil) forState:UIControlStateNormal];
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave", nil) forState:UIControlStateNormal];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 75, 20, 60, 44);
    WhiteBackground.frame = CGRectMake(0, 116, screenWidth, 100);
    AddPriceField.frame = CGRectMake(15, 136, screenWidth - 30, 60);
    ShowPerPax.frame = CGRectMake(15, 224, screenWidth - 30, 21);
    PriceButton.frame = CGRectMake(15, 78, screenWidth - 30, 31);
    
    [PriceButton setTitle:CustomLocalisedString(@"Currency", nil) forState:UIControlStateNormal];
    ShowPerPax.text = CustomLocalisedString(@"pax", nil);
    
    SelectPrice_PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, screenHeight - 216, screenWidth, 216)];
    [self.view addSubview:SelectPrice_PickerView];
    SelectPrice_PickerView.delegate = self;
    SelectPrice_PickerView.backgroundColor = [UIColor whiteColor];
    SelectPrice_PickerView.showsSelectionIndicator = YES;
    
    Toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 260,screenWidth, 44)];
    Toolbar.translucent = NO;
    Toolbar.barTintColor = [UIColor whiteColor];
    [self.view addSubview:Toolbar];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneSelect:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexibleSpace];
    [barItems addObject:doneBtn];
    [Toolbar setItems:barItems animated:YES];
    
    SelectPrice_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    
    
    ISO4217Array = [[NSMutableArray alloc]init];
    IOS4217NumArray = [[NSMutableArray alloc]init];
    
    [ISO4217Array addObject:@"USD"];
    [ISO4217Array addObject:@"MYR"];
    [ISO4217Array addObject:@"SGD"];
    [ISO4217Array addObject:@"THB"];
    [ISO4217Array addObject:@"IDR"];
    [ISO4217Array addObject:@"TWD"];
    [ISO4217Array addObject:@"PHP"];
    
    [IOS4217NumArray addObject:@"840"];
    [IOS4217NumArray addObject:@"458"];
    [IOS4217NumArray addObject:@"702"];
    [IOS4217NumArray addObject:@"764"];
    [IOS4217NumArray addObject:@"360"];
    [IOS4217NumArray addObject:@"901"];
    [IOS4217NumArray addObject:@"608"];
    
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *symbol = [theLocale objectForKey:NSLocaleCurrencySymbol];
    NSString *code = [theLocale objectForKey:NSLocaleCurrencyCode];
    
    NSLog(@"symbol is %@",symbol);
    NSLog(@"code is %@",code);
    
    for (int i = 0; i <[ISO4217Array count]; i++) {
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[ISO4217Array objectAtIndex:i]];
        if ([TempString isEqualToString:code]) {
            GetCountryNum = [IOS4217NumArray objectAtIndex:i];
            GetCountryShow = TempString;
            break;
        }else{
            GetCountryNum = @"840";
            GetCountryShow = @"USD";
        }
    }
    
}
-(IBAction)DoneSelect:(id)sender{
    SelectPrice_PickerView.hidden = YES;
    Toolbar.hidden = YES;
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
    self.screenName = @"IOS Add Price View V2";
    [AddPriceField becomeFirstResponder];
    
   // [PriceButton setTitle:GetCountryShow forState:UIControlStateNormal];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [AddPriceField resignFirstResponder];
}
-(IBAction)BackButton:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)SaveButton:(id)sender{

    if ([AddPriceField.text length] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"Error." message:@"Cannot be nil." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:AddPriceField.text forKey:@"PublishV2_Price"];
        [defaults setObject:GetCountryNum forKey:@"PublishV2_Price_NumCode"];
        [defaults setObject:GetCountryShow forKey:@"PublishV2_Price_Show"];
        [defaults synchronize];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(IBAction)SelectPrice:(id)sender{
    SelectPrice_PickerView.hidden = NO;
    Toolbar.hidden = NO;
    [AddPriceField resignFirstResponder];
}
// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //return LanguageArray.count;
    return [ISO4217Array count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    GetCountryShow = [ISO4217Array objectAtIndex:row];
    GetCountryNum = [IOS4217NumArray objectAtIndex:row];
    [PriceButton setTitle:GetCountryShow forState:UIControlStateNormal];
    PriceButton.imageEdgeInsets = UIEdgeInsetsMake(3, 110, 0, 0);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [ISO4217Array objectAtIndex:row];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    SelectPrice_PickerView.hidden = YES;
    Toolbar.hidden = YES;
    return YES;
}
@end
