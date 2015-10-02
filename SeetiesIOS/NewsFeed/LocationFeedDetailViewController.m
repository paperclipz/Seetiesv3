//
//  LocationFeedDetailViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "LocationFeedDetailViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface LocationFeedDetailViewController ()

@end

@implementation LocationFeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //ShowMainTitle.text = CustomLocalisedString(@"EditProfileLocation", nil);
    ShowMainTitle.text = LocalisedString(@"About the place");
    //[DirectionsButton setTitle:CustomLocalisedString(@"Directions", nil) forState:UIControlStateNormal];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    DirectionsButton.frame = CGRectMake(screenWidth - 50, 22, 50, 40);
    ShowMainTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    
    MainScroll.delegate = self;
    MainScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    MainScroll.alwaysBounceVertical = YES;
//    if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
//        
//        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
//        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
//        if( screenHeight < screenWidth ){
//            screenHeight = screenWidth;
//        }
//        
//        if( screenHeight > 480 && screenHeight < 667 ){
//            NSLog(@"iPhone 5/5s");
//            MapView.frame = CGRectMake(0, 64, 320, 400);
//            ShowImage.frame = CGRectMake(8, 480, 80, 80);
//            ShowTitle.frame = CGRectMake(96, 480, 216, 40);
//            ShowLocation.frame = CGRectMake(96, 528, 216, 20);
//        } else {
//            NSLog(@"iPhone 4/4s");
//            MapView.frame = CGRectMake(0, 64, 320, 308);
//            ShowImage.frame = CGRectMake(8, 380, 80, 80);
//            ShowTitle.frame = CGRectMake(96, 380, 216, 40);
//            ShowLocation.frame = CGRectMake(96, 428, 216, 20);
//        }
//    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Feed Location Page";
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
-(void)GetLat:(NSString *)Lat GetLong:(NSString *)Long GetFirstImage:(NSString *)FirstImage GetTitle:(NSString *)Title GetLocation:(NSString *)Location{

    GetLat = Lat;
    GetLong = Long;
    GetFirstImage = FirstImage;
    GetTitle = Title;
    GetLocation = Location;
    
    NSLog(@"GetLat is %@",GetLat);
    NSLog(@"GetLong is %@",GetLong);
    
    MapView.delegate = self;

    MKCoordinateRegion newRegion;
    newRegion.center.latitude = [GetLat doubleValue];
    newRegion.center.longitude = [GetLong doubleValue];
    newRegion.span.latitudeDelta = 0.005;
    newRegion.span.longitudeDelta = 0.005;
    [MapView setRegion:newRegion animated:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    NSString *tamplatitude = [[NSString alloc]initWithFormat:@"%@",GetLat];
    NSString *tampLongitude = [[NSString alloc]initWithFormat:@"%@",GetLong];
    
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
    [annotation setTitle:GetTitle]; //You can set the subtitle too
    [MapView addAnnotation:annotation];
}
-(void)GetLink:(NSString *)Link GetContact:(NSString *)Contact GetOpeningHour:(NSString *)OpeningHour GetPrice:(NSString *)Price GetPeriods:(NSString *)Periods{
    
     CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    GetPlaceLink = Link;
    GetContact = Contact;
    GetOpeningHour = OpeningHour;
    GetPrice = Price;
    GetAllPeriods = Periods;
    
    if ([GetLocation length] == 0 || [GetLocation isEqualToString:@"<null>"]) {
        GetLocation = @"";
    }
    
    
    NSLog(@"GetPlaceLink is %@",GetPlaceLink);
    NSLog(@"GetContact is %@",GetContact);
    NSLog(@"GetOpeningHour is %@",GetOpeningHour);
    NSLog(@"GetPrice is %@",GetPrice);
    NSLog(@"GetAllPeriods is %@",GetAllPeriods);
    
    if ([GetPlaceLink length] == 0 && [GetContact length] == 0 && [GetOpeningHour length] == 0 && [GetPrice length] == 0 && [GetAllPeriods length] == 0) {
        NSLog(@"No more information");
        MapView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 60 - 200);
        
        UIImageView *ShowLocationIcon = [[UIImageView alloc]init];
        ShowLocationIcon.frame = CGRectMake(25, MapView.frame.size.height + 16, 25, 25);
        ShowLocationIcon.image = [UIImage imageNamed:@"BluePin.png"];
        [MainScroll addSubview:ShowLocationIcon];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(55, MapView.frame.size.height + 20, screenWidth - 55 - 25, 21);
        ShowPlaceName.text = GetTitle;
        ShowPlaceName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowPlaceName];
        
        UILabel *ShowPlaceFormattedAddress = [[UILabel alloc]init];
        ShowPlaceFormattedAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowPlaceFormattedAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowPlaceFormattedAddress.text = GetLocation;
        ShowPlaceFormattedAddress.numberOfLines = 0;
        ShowPlaceFormattedAddress.backgroundColor = [UIColor clearColor];
        ShowPlaceFormattedAddress.frame = CGRectMake(70, MapView.frame.size.height + 45, screenWidth - 95,[ShowPlaceFormattedAddress sizeThatFits:CGSizeMake(screenWidth - 95, CGFLOAT_MAX)].height);
        [MainScroll addSubview:ShowPlaceFormattedAddress];
    }else{
        NSLog(@"Got information");
        
        MapView.frame = CGRectMake(0, 0, screenWidth, 200);
        
        UIImageView *ShowLocationIcon = [[UIImageView alloc]init];
        ShowLocationIcon.frame = CGRectMake(25, 200 + 16, 25, 25);
        ShowLocationIcon.image = [UIImage imageNamed:@"BluePin.png"];
        [MainScroll addSubview:ShowLocationIcon];
        
        UILabel *ShowPlaceName = [[UILabel alloc]init];
        ShowPlaceName.frame = CGRectMake(70, 200 + 20, screenWidth - 70 - 25, 21);
        ShowPlaceName.text = GetTitle;
        ShowPlaceName.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
        ShowPlaceName.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        [MainScroll addSubview:ShowPlaceName];
        
        UILabel *ShowPlaceFormattedAddress = [[UILabel alloc]init];
        ShowPlaceFormattedAddress.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowPlaceFormattedAddress.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowPlaceFormattedAddress.text = GetLocation;
        ShowPlaceFormattedAddress.numberOfLines = 0;
        ShowPlaceFormattedAddress.backgroundColor = [UIColor clearColor];
        ShowPlaceFormattedAddress.frame = CGRectMake(70, 200 + 45, screenWidth - 95,[ShowPlaceFormattedAddress sizeThatFits:CGSizeMake(screenWidth - 95, CGFLOAT_MAX)].height);
        [MainScroll addSubview:ShowPlaceFormattedAddress];
        
//        UIButton *Line01 = [[UIButton alloc]init];
//        Line01.frame = CGRectMake(25, 200 + 45 + ShowPlaceFormattedAddress.frame.size.height + 20, screenWidth, 1);
//        [Line01 setTitle:@"" forState:UIControlStateNormal];
//        [Line01 setBackgroundColor:[UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f]];
//        [MainScroll addSubview:Line01];
        
        int GetHeight = 200 + 45 + ShowPlaceFormattedAddress.frame.size.height + 30;
        
        if ([GetPlaceLink length] == 0) {
        }else{
            UIImageView *ShowLinkIcon = [[UIImageView alloc]init];
            ShowLinkIcon.frame = CGRectMake(25, GetHeight, 25, 25);
            ShowLinkIcon.image = [UIImage imageNamed:@"BlueLink.png"];
            [MainScroll addSubview:ShowLinkIcon];
            
            UILabel *ShowPlacelink = [[UILabel alloc]init];
            ShowPlacelink.frame = CGRectMake(70, GetHeight, screenWidth - 95, 25);
            ShowPlacelink.text = GetPlaceLink;
            ShowPlacelink.numberOfLines = 0;
            ShowPlacelink.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            ShowPlacelink.backgroundColor = [UIColor clearColor];
            ShowPlacelink.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
           // ShowPlacelink.frame = CGRectMake(55, GetHeight, screenWidth - 80,[ShowPlacelink sizeThatFits:CGSizeMake(screenWidth - 80, CGFLOAT_MAX)].height);
            [MainScroll addSubview:ShowPlacelink];
            
            UIButton *OpenLinkButton = [[UIButton alloc]init];
            OpenLinkButton.frame = CGRectMake(70, GetHeight, screenWidth - 95, 25);
            [OpenLinkButton setTitle:@"" forState:UIControlStateNormal];
            [OpenLinkButton addTarget:self action:@selector(OpenLinkButton:) forControlEvents:UIControlEventTouchUpInside];
            [OpenLinkButton setBackgroundColor:[UIColor clearColor]];
            [MainScroll addSubview:OpenLinkButton];
            
            GetHeight += [ShowPlacelink sizeThatFits:CGSizeMake(screenWidth - 80, CGFLOAT_MAX)].height + 30;
        }
        
        if ([GetContact length] == 0) {
            
        }else{
            UIImageView *ShowContactIcon = [[UIImageView alloc]init];
            ShowContactIcon.frame = CGRectMake(25, GetHeight, 25, 25);
            ShowContactIcon.image = [UIImage imageNamed:@"BluePhone.png"];
            [MainScroll addSubview:ShowContactIcon];
            
            UILabel *ShowContact = [[UILabel alloc]init];
            ShowContact.frame = CGRectMake(70, GetHeight , screenWidth - 95, 25);
            ShowContact.text = GetContact;
            ShowContact.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowContact.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowContact];
            
            UIButton *OpenContactButton = [[UIButton alloc]init];
            OpenContactButton.frame = CGRectMake(55, GetHeight, screenWidth - 80, 21);
            [OpenContactButton setTitle:@"" forState:UIControlStateNormal];
            [OpenContactButton addTarget:self action:@selector(OpenContactButton:) forControlEvents:UIControlEventTouchUpInside];
            [OpenContactButton setBackgroundColor:[UIColor clearColor]];
            [MainScroll addSubview:OpenContactButton];
            
            
            
            GetHeight += 50;
        }
        if ([GetPrice length] == 0) {
            
        }else{
            UIImageView *ShowPriceIcon = [[UIImageView alloc]init];
            ShowPriceIcon.frame = CGRectMake(25, GetHeight, 25, 25);
            ShowPriceIcon.image = [UIImage imageNamed:@"BluePrice.png"];
            [MainScroll addSubview:ShowPriceIcon];
            
            UILabel *ShowPriceTExt = [[UILabel alloc]init];
            ShowPriceTExt.frame = CGRectMake(70, GetHeight, screenWidth - 95, 25);
            ShowPriceTExt.text = GetPrice;
            ShowPriceTExt.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowPriceTExt.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowPriceTExt];
            
            GetHeight += 50;
        }
        
        if ([GetOpeningHour length] == 0) {
            
        }else{
            UIImageView *ShowOpeningIcon = [[UIImageView alloc]init];
            ShowOpeningIcon.frame = CGRectMake(25, GetHeight, 25, 25);
            ShowOpeningIcon.image = [UIImage imageNamed:@"BlueTime.png"];
            [MainScroll addSubview:ShowOpeningIcon];
            
            if ([GetOpeningHour isEqualToString:@"0"]) {
                GetOpeningHour = @"Close";
            }else{
                
                GetOpeningHour = @"Open";
            }
            
            UILabel *ShowOpeningTExt = [[UILabel alloc]init];
            ShowOpeningTExt.frame = CGRectMake(70, GetHeight, screenWidth - 95, 25);
            ShowOpeningTExt.text = GetOpeningHour;
            ShowOpeningTExt.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            ShowOpeningTExt.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
            [MainScroll addSubview:ShowOpeningTExt];
            
            GetHeight += 20;
        }
        
        if ([GetAllPeriods rangeOfString:@"("].location == NSNotFound) {
          //  NSLog(@"string does not contain bla");
            if ([GetAllPeriods length] == 0 || [GetAllPeriods length] == 10) {
                
            }else{
                
                GetAllPeriods = [GetAllPeriods stringByReplacingOccurrencesOfString:@"="
                                                                         withString:@" "];
                
                NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"{};\""];
                GetAllPeriods = [[GetAllPeriods componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
                
                UILabel *ShowAllOpeningText = [[UILabel alloc]init];
                ShowAllOpeningText.frame = CGRectMake(60, GetHeight, screenWidth - 60 - 25, 140);
                ShowAllOpeningText.text = GetAllPeriods;
                ShowAllOpeningText.numberOfLines = 10;
                ShowAllOpeningText.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
                ShowAllOpeningText.backgroundColor = [UIColor clearColor];
                ShowAllOpeningText.textAlignment = NSTextAlignmentLeft;
                ShowAllOpeningText.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                [MainScroll addSubview:ShowAllOpeningText];
                
                GetHeight += 160;
                
                UILabel *ShowLocalTime = [[UILabel alloc]init];
                ShowLocalTime.frame = CGRectMake(0, GetHeight - 1, screenWidth, 21);
                ShowLocalTime.text = @"(All time are based on local time)";
                ShowLocalTime.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0f];
                ShowLocalTime.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:13];
                ShowLocalTime.textAlignment = NSTextAlignmentCenter;
                [MainScroll addSubview:ShowLocalTime];
                
                GetHeight += 40;
            }
        } else {
          //  NSLog(@"string contains bla!");
        }
        

        
        MainScroll.contentSize = CGSizeMake(screenWidth, GetHeight);

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
        pin.image = [UIImage imageNamed:@"PinInMap.png"];
        pin.calloutOffset = CGPointMake(0, 0);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //        [button addTarget:self
        //                   action:@selector(checkinButton) forControlEvents:UIControlEventTouchUpInside];
        pin.rightCalloutAccessoryView = button;
        
    }
    return pin;
}
-(IBAction)DirectionsButton:(id)sender{
    NSString *latlong = [[NSString alloc]initWithFormat:@"%@,%@",GetLat,GetLong];
    // NSString *latlong = @"-56.568545,1.256281";
    
    CGFloat systemVersion = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
    if( systemVersion > 6.0 ){

        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
//            NSString *url = [NSString stringWithFormat: @"comgooglemaps://?center=%@&zoom=14&views=traffic",
//                             [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            NSString *url = [NSString stringWithFormat: @"comgooglemaps://?q=%@&zoom=10",
                             latlong];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//            [[UIApplication sharedApplication] openURL:
//             [NSURL URLWithString:@"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
            NSString *url = [NSString stringWithFormat: @"http://maps.apple.com?q=%@",
                             [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }

    }else{
        
        NSString *url = [NSString stringWithFormat: @"http://maps.google.com/maps?q=%@",
                         [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
-(IBAction)OpenLinkButton:(id)sender{
    
    NSLog(@"Open link click");
    if ([GetPlaceLink hasPrefix:@"http://"] || [GetPlaceLink hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:GetPlaceLink]];
    } else {
        NSString *TempString = [[NSString alloc]initWithFormat:@"http://%@",GetPlaceLink];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:TempString]];
    }
}
-(IBAction)OpenContactButton:(id)sender{
    
    NSLog(@"Open contact click");
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        NSString *phoneNumber = [@"telprompt://" stringByAppendingString:GetContact];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        
    } else {
        
        UIAlertView *warning =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [warning show];
    }
}
@end
