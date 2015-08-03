//
//  ConfirmPlaceViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/24/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "ConfirmPlaceViewController.h"
#import "ShowImageViewController.h"
#import "AddPriceViewController.h"
#import "AddContactViewController.h"
#import "EditLocationV2ViewController.h"
#import "AddLinkViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
#import "WhereIsThisViewController.h"
#import "RecommendV2ViewController.h"
#import "LocationOnMapViewController.h"
@interface ConfirmPlaceViewController ()

@end

@implementation ConfirmPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.text = CustomLocalisedString(@"ConfirmLocation", nil);
    ShowDownView.frame = CGRectMake(0, screenHeight - 40, screenWidth, 40);
    SearchAgainButton.frame = CGRectMake(screenWidth - 155, 0, 140, 40);
    [SearchAgainButton setTitle:CustomLocalisedString(@"ConfirmPlace_Search", nil) forState:UIControlStateNormal];
    ShowWrongPlaceText.text = CustomLocalisedString(@"ConfirmPlace_Text", nil);
    
    ShowEditMapView.frame = CGRectMake(0, 189, screenWidth, 30);
    
    MapView.delegate = self;
    MapView.frame = CGRectMake(0, 64, screenWidth, 155);
    OpenMapButton.frame = CGRectMake(0, 64, screenWidth, 155);
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 0, screenWidth, screenHeight - 40);
    [MainScroll setContentSize:CGSizeMake(320, 568)];
    ShowTitle.frame = CGRectMake(15, 20, screenWidth-30, 44);
    
    ArrowRight.frame = CGRectMake(screenWidth - 42 - 15, 0, 42, 21);
    ChangePinButton.frame = CGRectMake(0, 0, screenWidth, 30);
    ShowTaptheMapPin.text = CustomLocalisedString(@"tapthemaptoadjustpin", nil);
    ShowTaptheMapPin.frame = CGRectMake(15, 5, screenWidth - 30, 21);
    
    ShowName.delegate = self;
    ShowAddress.delegate = self;
    
    [DoneButton setTitle:CustomLocalisedString(@"DoneButton", nil) forState:UIControlStateNormal];
    DoneButton.frame = CGRectMake(screenWidth - 80 - 15, 20, 80, 44);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
    dayName = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"dayName is %@",dayName);
    
   // ConfirmButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, 320, 60);
    
    EditInfoIcon_1 = [[UIImageView alloc]init];
    EditInfoIcon_1.image = [UIImage imageNamed:@"EditInfo.png"];
    EditInfoIcon_2 = [[UIImageView alloc]init];
    EditInfoIcon_2.image = [UIImage imageNamed:@"EditInfo.png"];
    EditInfoIcon_3 = [[UIImageView alloc]init];
    EditInfoIcon_3.image = [UIImage imageNamed:@"EditInfo.png"];
    
    [MainScroll addSubview:EditInfoIcon_1];
    [MainScroll addSubview:EditInfoIcon_2];
    [MainScroll addSubview:EditInfoIcon_3];

}
-(void)CheckAddNewPlace:(NSString *)CheckString{

    GetCheckString = CheckString;
    if ([GetCheckString isEqualToString:@"AddNewPlace"]) {
        ShowDownView.hidden = YES;
        
    }else{
        ShowName.enabled = NO;
        ShowName.userInteractionEnabled = NO;
        ShowAddress.editable = NO;
        ShowAddress.userInteractionEnabled = NO;
        ShowEditMapView.hidden = YES;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([ShowAddress.text isEqualToString:@"Add address"]) {
        ShowAddress.text = @"";
    }else{
        
    }
    ShowAddress.textColor = [UIColor blackColor];
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [ShowName resignFirstResponder];
    [ShowAddress resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [ShowName resignFirstResponder];
    [ShowAddress resignFirstResponder];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
  //  CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    if([textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height!=textView.frame.size.height)
    {
        textView.frame = CGRectMake(55, GetFinalHeight, screenWidth - 70,[textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height);
        
        LineButton.frame = CGRectMake(15, GetFinalHeight + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height + 20 , screenWidth, 1);
        
        ShowWebsiteIcon.frame = CGRectMake(15, GetFinalHeight + 41 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 23, 24);
        ShowWebsite.frame = CGRectMake(62, GetFinalHeight + 41 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62 - 40, 24);
        AddWebsiteButton.frame = CGRectMake(62, GetFinalHeight + 41 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62, 24);
        EditInfoIcon_1.frame = CGRectMake(screenWidth - 25 - 13, GetFinalHeight + 46 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 13, 13);

        ShowPhoneIcon.frame = CGRectMake(15, GetFinalHeight + 96 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 24, 25);
        ShowPhone.frame = CGRectMake(62, GetFinalHeight + 96 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62 - 40, 25);
        AddContactButton.frame = CGRectMake(62, GetFinalHeight + 96 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62, 25);
        EditInfoIcon_2.frame = CGRectMake(screenWidth - 25 - 13, GetFinalHeight + 101 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 13, 13);
        
        ShowPriceIcon.frame = CGRectMake(15, GetFinalHeight + 151 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 24, 25);
        ShowPrice.frame = CGRectMake(62, GetFinalHeight + 151 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62 - 40, 25);
        AddPriceButton.frame = CGRectMake(62, GetFinalHeight + 151 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, screenWidth - 62, 25);
        EditInfoIcon_3.frame = CGRectMake(screenWidth - 25 - 13, GetFinalHeight + 151 + 5 + [textView sizeThatFits:CGSizeMake(screenWidth - 70, CGFLOAT_MAX)].height, 13, 13);
    }
    
    
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation)
        return nil;
    
    static NSString *s = @"ann";
    MKAnnotationView *pin = [mapView dequeueReusableAnnotationViewWithIdentifier:s];
    if (!pin) {
        pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:s];
        pin.canShowCallout = YES;
        pin.image = [UIImage imageNamed:@"MapPin.png"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //        [button addTarget:self
        //                   action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{

    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)DoneButton:(id)sender{
    if ([GetCheckString isEqualToString:@"AddNewPlace"]) {
        if ([ShowName.text length] == 0 || [ShowAddress.text length] == 0|| [ShowAddress.text isEqualToString:CustomLocalisedString(@"AddAddress", nil)] || [ShowName.text length] == 0|| [ShowName.text isEqualToString:CustomLocalisedString(@"Addplacename", nil)]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"Pleasefillinplacename", nil) delegate:self
                                     cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:ShowName.text forKey:@"PublishV2_Name"];
            [defaults setObject:ShowAddress.text forKey:@"PublishV2_Address"];
            [defaults synchronize];
            
            RecommendV2ViewController *RecommendV2View = [[RecommendV2ViewController alloc]init];
            [self presentViewController:RecommendV2View animated:YES completion:nil];
        }

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
-(IBAction)NextButton:(id)sender{
    

    if ([ShowWebsite.text length] == 0 || [ShowWebsite.text isEqualToString:CustomLocalisedString(@"Addfb", nil)]) {
        
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ShowWebsite.text forKey:@"PublishV2_Link"];
        [defaults synchronize];
    }
    ShowImageViewController *ShowImageView = [[ShowImageViewController alloc]init];
    [self presentViewController:ShowImageView animated:YES completion:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.screenName = @"IOS Edit Location View V2";
    
    
    
   // CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetPriceData = [defaults objectForKey:@"PublishV2_Price"];
    NSString *GetPriceNumCodeData = [defaults objectForKey:@"PublishV2_Price_NumCode"];
    NSString *GetPriceShowData = [defaults objectForKey:@"PublishV2_Price_Show"];
    NSString *GetContactData = [defaults objectForKey:@"PublishV2_Contact"];
    NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
    NSString *GetNameData = [defaults objectForKey:@"PublishV2_Name"];
    NSString *GetLatData = [defaults objectForKey:@"PublishV2_Lat"];
    NSString *GetLngData = [defaults objectForKey:@"PublishV2_Lng"];
    NSString *GetLinkData = [defaults objectForKey:@"PublishV2_Link"];
    NSString *GetHourData = [defaults objectForKey:@"PublishV2_Hour"];
    
    NSLog(@"GetPriceData is %@",GetPriceData);
    NSLog(@"GetPriceNumCodeData is %@",GetPriceNumCodeData);
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [GetLatData doubleValue];
    newRegion.center.longitude = [GetLngData doubleValue];
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
    [MapView setRegion:newRegion animated:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSString *tamplatitude = [[NSString alloc]initWithFormat:@"%@",GetLatData];
    NSString *tampLongitude = [[NSString alloc]initWithFormat:@"%@",GetLngData];
    
    NSLog(@"tamplatitude is %@",tamplatitude);
    NSLog(@"tampLongitude is %@",tampLongitude);
    
    region.center.latitude = [tamplatitude doubleValue];
    region.center.longitude = [tampLongitude doubleValue];
    
    //    MKCoordinateRegion newRegion;
    //    newRegion.center.latitude = [GetLat doubleValue];
    //    newRegion.center.longitude = [GetLong doubleValue];
    //    newRegion.span.latitudeDelta = 0.1;
    //    newRegion.span.longitudeDelta = 0.1;
    //    [MapView setRegion:newRegion animated:YES];
    //    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:region.center];
   // [annotation setTitle:@"We at Here"]; //You can set the subtitle too
    [MapView addAnnotation:annotation];
    
    int GetHeight = 226;
    
    if ([GetNameData length] == 0) {
        ShowName.placeholder = CustomLocalisedString(@"Addplacename", nil);
        UIImageView *EditInfoIcon_Name = [[UIImageView alloc]init];
        EditInfoIcon_Name.image = [UIImage imageNamed:@"EditInfo.png"];
        EditInfoIcon_Name.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 5, 13, 13);
        [MainScroll addSubview:EditInfoIcon_Name];
    }else{
    ShowName.text = GetNameData;
    }
    

    ShowName.frame = CGRectMake(60, GetHeight, screenWidth - 60 - 15,30);
    
    GetHeight += ShowName.frame.size.height + 5;
    
    if ([GetAddressData length] == 0) {
        ShowAddress.text = CustomLocalisedString(@"AddAddress", nil);
        UIImageView *EditInfoIcon_Address = [[UIImageView alloc]init];
        EditInfoIcon_Address.image = [UIImage imageNamed:@"EditInfo.png"];
        EditInfoIcon_Address.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 10, 13, 13);
        [MainScroll addSubview:EditInfoIcon_Address];
    }else{
        ShowAddress.text = GetAddressData;

    }
    GetFinalHeight = GetHeight;

    ShowAddress.frame = CGRectMake(55, GetHeight, screenWidth - 75 - 15,[ShowAddress sizeThatFits:CGSizeMake(screenWidth - 75 - 15, CGFLOAT_MAX)].height);
    
   // EditAddressButton.frame = CGRectMake(62, 239, screenWidth - 62, ShowName.frame.size.height + ShowAddress.frame.size.height + 5);
    
    GetHeight += ShowAddress.frame.size.height + 20;
    
    
    LineButton.frame = CGRectMake(15, GetHeight, screenWidth, 1);
    
    GetHeight += 21;
    ShowWebsiteIcon.frame = CGRectMake(15, GetHeight, 23, 24);
    ShowWebsite.frame = CGRectMake(62, GetHeight, screenWidth - 62 - 40, 24);
    AddWebsiteButton.frame = CGRectMake(62, GetHeight, screenWidth - 62, 24);
//    EditInfoIcon_1 = [[UIImageView alloc]init];
//    EditInfoIcon_1.image = [UIImage imageNamed:@"EditInfo.png"];
    EditInfoIcon_1.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 5, 13, 13);
  //  [MainScroll addSubview:EditInfoIcon_1];
    GetHeight += 24 + 30;
    ShowPhoneIcon.frame = CGRectMake(15, GetHeight, 24, 25);
    ShowPhone.frame = CGRectMake(62, GetHeight, screenWidth - 62 - 40, 25);
    AddContactButton.frame = CGRectMake(62, GetHeight, screenWidth - 62, 25);
//    EditInfoIcon_2 = [[UIImageView alloc]init];
//    EditInfoIcon_2.image = [UIImage imageNamed:@"EditInfo.png"];
    EditInfoIcon_2.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 5, 13, 13);
   // [MainScroll addSubview:EditInfoIcon_2];
    GetHeight += 25 + 30;
    ShowPriceIcon.frame = CGRectMake(15, GetHeight, 24, 25);
    ShowPrice.frame = CGRectMake(62, GetHeight, screenWidth - 62 - 40, 25);
    AddPriceButton.frame = CGRectMake(62, GetHeight, screenWidth - 62, 25);
//    EditInfoIcon_3 = [[UIImageView alloc]init];
//    EditInfoIcon_3.image = [UIImage imageNamed:@"EditInfo.png"];
    EditInfoIcon_3.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 5, 13, 13);
   // [MainScroll addSubview:EditInfoIcon_3];
    GetHeight += 25 + 30;

    
    if ([GetPriceData length] == 0 || [GetPriceData isEqualToString:@"(null)"] || GetPriceData == nil) {
        ShowPrice.text = CustomLocalisedString(@"AddPrice", nil);
    }else{
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@ %@",GetPriceShowData,GetPriceData];
        ShowPrice.text = TempString;
        ShowPrice.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
    if ([GetContactData length] == 0 || [GetContactData isEqualToString:@"(null)"] || GetContactData == nil) {
        ShowPhone.text = CustomLocalisedString(@"AddPhoneNumber", nil);
    }else{
        ShowPhone.text = GetContactData;
        ShowPhone.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
    
    if ([GetLinkData isEqualToString:@""] || GetLinkData == nil || [GetLinkData isEqualToString:@"(null)"] || [GetLinkData isEqualToString:CustomLocalisedString(@"Addfb", nil)]) {
        ShowWebsite.text = CustomLocalisedString(@"Addfb", nil);
        ShowWebsite.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
    }else{
        ShowWebsite.text = GetLinkData;
        ShowWebsite.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
    
    if ([GetHourData isEqualToString:@""] || GetHourData == nil || [GetHourData isEqualToString:@"(null)"] || [GetHourData isEqualToString:@"nil"]) {
//        ShowHours.text = @"not support this function.";
//        ShowHours.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        ShowHourIcon.hidden = YES;
        ShowHours.hidden = YES;
    }else{
        ShowHourIcon.frame = CGRectMake(15, GetHeight, 24, 24);
        ShowHours.frame = CGRectMake(62, GetHeight, screenWidth - 62 - 40, 24);
//        UIImageView *EditInfoIcon_4 = [[UIImageView alloc]init];
//        EditInfoIcon_4.image = [UIImage imageNamed:@"EditInfo.png"];
//        EditInfoIcon_4.frame = CGRectMake(screenWidth - 25 - 13, GetHeight + 5, 13, 13);
//        [MainScroll addSubview:EditInfoIcon_4];
        ShowHours.text = GetHourData;
        ShowHours.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [MapView removeAnnotations:MapView.annotations];
}
-(IBAction)AddWebsiteButton:(id)sender{
    if ([ShowWebsite.text length] == 0) {
        
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ShowWebsite.text forKey:@"PublishV2_Link"];
        [defaults synchronize];
    }
    AddLinkViewController *AddLinkView = [[AddLinkViewController alloc]init];
    [self presentViewController:AddLinkView animated:YES completion:nil];
    [AddLinkView GetWhatLink:@"FB/Site"];
}
-(IBAction)AddPriceButton:(id)sender{
    if ([ShowPrice.text length] == 0) {

    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ShowPrice.text forKey:@"PublishV2_Price_Show"];
        [defaults synchronize];
    }
    AddPriceViewController *AddPriceView = [[AddPriceViewController alloc]init];
    [self presentViewController:AddPriceView animated:YES completion:nil];
}
-(IBAction)AddContactButton:(id)sender{
    if ([ShowPhone.text length] == 0) {
        
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:ShowPhone.text forKey:@"PublishV2_Contact"];
        [defaults synchronize];
    }
     AddContactViewController *AddContactView = [[AddContactViewController alloc]init];
    [self presentViewController:AddContactView animated:YES completion:nil];
}
-(IBAction)EditLocationbutton:(id)sender{
    [MapView removeAnnotations:MapView.annotations];
    EditLocationV2ViewController *EditLocationView = [[EditLocationV2ViewController alloc]init];
    [self presentViewController:EditLocationView animated:YES completion:nil];
}
-(IBAction)ChangePlaceButton:(id)sender{

    WhereIsThisViewController *WhereIsThisView = [[WhereIsThisViewController alloc]init];
    [self presentViewController:WhereIsThisView animated:YES completion:nil];
}
-(IBAction)ChangePinButton:(id)sender{
    [MapView removeAnnotations:MapView.annotations];
    if ([GetCheckString isEqualToString:@"AddNewPlace"]) {
        LocationOnMapViewController *LocationOnMap = [[LocationOnMapViewController alloc]init];
        [self presentViewController:LocationOnMap animated:YES completion:nil];
        [LocationOnMap CheckAddNewPlace:@"AddNewPlace"];
        
    }else{
        LocationOnMapViewController *LocationOnMap = [[LocationOnMapViewController alloc]init];
        [self presentViewController:LocationOnMap animated:YES completion:nil];
    }

}
@end
