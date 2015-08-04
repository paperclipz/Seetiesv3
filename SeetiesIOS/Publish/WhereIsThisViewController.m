//
//  WhereIsThisViewController.m
//  PhotoDemo
//
//  Created by Seeties IOS on 3/24/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import "WhereIsThisViewController.h"
#import "RecommendV2ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "ProfileV2ViewController.h"
#import "ExploreViewController.h"
#import "Explore2ViewController.h"
#import "NotificationViewController.h"
#import "SelectImageViewController.h"
#import "ConfirmPlaceViewController.h"
#import "FeedV2ViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface WhereIsThisViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) FSVenue *selected;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (strong, nonatomic) NSArray *venues;
@property (nonatomic, weak) NSOperation *lastSearchOperation;
@end

@implementation WhereIsThisViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    ShowTitle.text = CustomLocalisedString(@"Whereisthis", nil);
    Shownearby.text = CustomLocalisedString(@"NearbySuggestions", nil);
    [NextButton setTitle:CustomLocalisedString(@"DoneButton", nil) forState:UIControlStateNormal];
    SearchField.placeholder = CustomLocalisedString(@"TypeToSearch_Place", nil);
    SearchField.frame = CGRectMake(53, 70, screenWidth - 53 - 20, 45);
    ReturnView.hidden = YES;
    ReturnView.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
    NextButton.hidden = YES;
    
    CheckSelectWhichOne = 0;
    
    SearchField.delegate = self;
    ShowSearchView.frame = CGRectMake(0, 124, screenWidth, screenHeight - 124);
    ShowSearchView.hidden = YES;
    [self.view addSubview:ShowSearchView];
    NearByTableView.frame = CGRectMake(0, 159, screenWidth, screenHeight - 159);
    
    SearchTableView_Google.frame = CGRectMake(0, 50, screenWidth, ShowSearchView.frame.size.height - 50 - 216);
    SearchTableView_Four.frame = CGRectMake(0, 50, screenWidth, ShowSearchView.frame.size.height - 50 - 216);
    GoogleButton.frame = CGRectMake(0, 0, screenWidth/2, 50);
    FoursquareButton.frame = CGRectMake((screenWidth/2), 0, screenWidth/2, 50);
    LineImage.frame = CGRectMake((screenWidth/2) - 1, 13, 1, 30);
    ArrowImage.frame = CGRectMake((screenWidth/2)/2 - 10, 40, 21, 11);
    LineButton.frame = CGRectMake(0, 50, screenWidth, 1);
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 124);
    SearchBox.frame = CGRectMake(10, 70, screenWidth - 20, 44);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    ShowActivity.frame = CGRectMake(screenWidth - 20 - 15, 32, 20, 20);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetLatPoint = [defaults objectForKey:@"UserCurrentLocation_Lat"];
    GetLongPoint = [defaults objectForKey:@"UserCurrentLocation_Long"];
    
    NSLog(@"GetLatPoint is %@",GetLatPoint);
    NSLog(@"GetLongPoint is %@",GetLongPoint);
    if ([GetLatPoint length] == 0) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 10;
        if(IS_OS_8_OR_LATER){
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined && ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
                // choose one request according to your business.
                if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                    [self.locationManager requestAlwaysAuthorization];
                } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    [self.locationManager  requestWhenInUseAuthorization];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
            }
        }
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"WhereIsThis got location work.s");
        [self Getlatitude:GetLatPoint Getlongitude:GetLongPoint];
    }
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [SearchTableView_Google addGestureRecognizer:tapGesture];
    [SearchTableView_Four addGestureRecognizer:tapGesture];
    [ShowSearchView addSubview:ArrowImage];
    
    Check = 0;
    

    


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.screenName = @"IOS Where Is This View V2";
}
-(IBAction)NextButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetCheckBackView:(NSString *)CheckView{

    CheckBackView = CheckView;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetAddressData = [defaults objectForKey:@"PublishV2_Address"];
    ReturnView.hidden = NO;
    NextButton.hidden = NO;
    ReturnAddressText.text = GetAddressData;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
    if ([CheckBackView isEqualToString:@"Yes"]) {
        UIAlertView *AlertView = [[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure want delete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Draft",@"Delete", nil];
        AlertView.tag = 500;
        [AlertView show];
    }else{
    [self dismissViewControllerAnimated:YES completion:nil];
    }

    
}
-(IBAction)ConfirmButton:(id)sender{

    RecommendV2ViewController *ConfirmPlaceView = [[RecommendV2ViewController alloc]init];
    [self presentViewController:ConfirmPlaceView animated:YES completion:nil];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        GetLatPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        GetLongPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:GetLatPoint forKey:@"UserCurrentLocation_Lat"];
        [defaults setObject:GetLongPoint forKey:@"UserCurrentLocation_Long"];
        [defaults synchronize];
        
        [self Getlatitude:GetLatPoint Getlongitude:GetLongPoint];
        NSLog(@"WhereisThis lat is %@ : lon is %@",GetLatPoint, GetLongPoint);
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];;
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetLat = [defaults objectForKey:@"GetLat"];
        NSString *GetLon = [defaults objectForKey:@"GetLang"];
        
        GetLatPoint = GetLat;
        GetLongPoint = GetLon;
        
       // [self GetFeedDataFromServer];
        [self Getlatitude:GetLatPoint Getlongitude:GetLongPoint];
    }

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchField resignFirstResponder];
    ShowSearchView.hidden = YES;
//    if ([SearchLocation.text length] == 0) {
//        SearchLocation.text = GetLocationName;
//    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    
    if (textField == SearchField) {
        ShowSearchView.hidden = NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == SearchField) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        NSLog(@"found");
        if ([newString length] > 2) {
            NSLog(@"Check server");
            if (CheckSelectWhichOne == 0) {
                [self GetSearchText];
            }else{
                [self startSearchWithString:SearchField.text];
            }
        }else{
            
        }
    
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"work here?");
    if (theTextField == SearchField) {
        [SearchField resignFirstResponder];
        if ([SearchField.text length] == 0) {
            ShowSearchView.hidden = YES;
        }else{
            if (CheckSelectWhichOne == 0) {
                [self GetSearchText];
            }else{
                 [self startSearchWithString:SearchField.text];
            }
            
//            if ([GetLocationName isEqualToString:SearchLocation.text]) {
//                MainScroll.hidden = NO;
//                ShowSearchLocationView.hidden = YES;
//            }else{
//                [self performSearch];
//            }
        }
        
    }    // [ShowActivity startAnimating];
    return YES;
}




- (void)Getlatitude:(NSString *)latitude Getlongitude:(NSString *)longitude {
    [ShowActivity startAnimating];
    double dlatitude = [latitude doubleValue];
    double dlongitude = [longitude doubleValue];
    NSLog(@"latitude is %@",latitude);
    NSLog(@"longitude is %@",longitude);
    [Foursquare2 venueExploreRecommendedNearByLatitude:@(dlatitude) longitude:@(dlongitude) near:nil accuracyLL:nil altitude:nil accuracyAlt:nil query:nil limit:nil offset:nil radius:@(1000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
    NSLog(@"Check result is %@",result);
        if (success) {
            NSDictionary *dic = result;
            NSArray *venues = [dic valueForKeyPath:@"response.groups.items.venue"];
            NSLog(@"Check venues 1 is %@",venues);

            NSArray *GetLocationData = (NSArray *)[venues valueForKey:@"location"];
            NSLog(@"GetLocationData ===== %@",GetLocationData);
            
            NSArray *GetContactData = (NSArray *)[venues valueForKey:@"contact"];
            NSLog(@"GetContactData ===== %@",GetContactData);
            
            NSArray *GethoursData = (NSArray *)[venues valueForKey:@"hours"];
            NSLog(@"GethoursData ===== %@",GethoursData);
            
            NSArray *GetpriceData = (NSArray *)[venues valueForKey:@"price"];
            NSLog(@"GetpriceData ===== %@",GetpriceData);
            
            NSDictionary *venuesDataDic = [venues objectAtIndex:0];
            NSDictionary *LocationDataDic = [GetLocationData objectAtIndex:0];
            NSDictionary *ContactDataDic = [GetContactData objectAtIndex:0];
            NSDictionary *HoursDataDic = [GethoursData objectAtIndex:0];
            NSDictionary *PriceDataDic = [GetpriceData objectAtIndex:0];
            NSDictionary *MainDataDic = [venues objectAtIndex:0];

            // [self proccessAnnotations];
            //  [ShowNearByActivity stopAnimating];
            GetLocationArray = nil;
            GetreferralIdArray = nil;
            AddressArray = nil;
            CityArray = nil;
            CountryArray = nil;
            latArray = nil;
            lngArray = nil;
            StateArray = nil;
            formattedAddressArray = nil;
            postalCodeArray = nil;
            GetLocationArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
            GetreferralIdArray = [[NSMutableArray alloc] init];
            
            AddressArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            CityArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            CountryArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            latArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            lngArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            StateArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            formattedAddressArray = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            postalCodeArray = [[NSMutableArray alloc]initWithCapacity:[GetLocationData count]];
            DistanceArray = [[NSMutableArray alloc]initWithCapacity:[GetLocationData count]];
            for (NSDictionary * dict in LocationDataDic){
                NSString *address =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
                [AddressArray addObject:address];
                NSString *city =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"city"]];
                [CityArray addObject:city];
                NSString *country =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"country"]];
                [CountryArray addObject:country];
                NSString *lat =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"lat"]];
                [latArray addObject:lat];
                NSString *lng =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"lng"]];
                [lngArray addObject:lng];
                NSString *state =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];
                [StateArray addObject:state];
                NSString *formattedAddress =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"formattedAddress"]];
                [formattedAddressArray addObject:formattedAddress];
                NSString *postalCode =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"postalCode"]];
                [postalCodeArray addObject:postalCode];
                NSString *distance =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"distance"]];
                [DistanceArray addObject:distance];
            }
//            NSLog(@"AddressArray is %@",AddressArray);
//            NSLog(@"CityArray is %@",CityArray);
//            NSLog(@"CountryArray is %@",CountryArray);
//            NSLog(@"StateArray is %@",StateArray);
//            NSLog(@"postalCodeArray is %@",postalCodeArray);
            
            NameArray = [[NSMutableArray alloc]initWithCapacity:[venues count]];
            UrlArray = [[NSMutableArray alloc]initWithCapacity:[venues count]];
            for (NSDictionary * dict in MainDataDic){
                NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [NameArray addObject:name ];
                NSString *url_ =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
                [UrlArray addObject:url_ ];
//                NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
//                [GetreferralIdArray addObject:referralId];
            }
            isOpenArray = [[NSMutableArray alloc]initWithCapacity:[GethoursData count]];
            HourStatusArray = [[NSMutableArray alloc]initWithCapacity:[GethoursData count]];
            for (NSDictionary * dict in HoursDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [isOpenArray addObject:@"nil"];
                     [HourStatusArray addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"isOpen"] isKindOfClass:[NSNull class]]) {
                        NSString *isOpen =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"isOpen"]];
                        [isOpenArray addObject:isOpen];
                    } else {
                        [isOpenArray addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"status"] isKindOfClass:[NSNull class]]) {
                        NSString *isOpen =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
                        [HourStatusArray addObject:isOpen];
                    } else {
                        [HourStatusArray addObject:@"nil"];
                    }
                }
            }
            NSLog(@"isOpenArray is %@",isOpenArray);
            NSLog(@"HourStatusArray is %@",HourStatusArray);
            
            CurrencyArray = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            PriceMessageArray = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            TierArray = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            for (NSDictionary * dict in PriceDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [CurrencyArray addObject:@"nil"];
                    [PriceMessageArray addObject:@"nil"];
                    [TierArray addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"currency"] isKindOfClass:[NSNull class]]) {
                        NSString *currency =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"currency"]];
                        [CurrencyArray addObject:currency];
                    } else {
                        [CurrencyArray addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"message"] isKindOfClass:[NSNull class]]) {
                        NSString *message =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
                        [PriceMessageArray addObject:message];
                    } else {
                        [PriceMessageArray addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"tier"] isKindOfClass:[NSNull class]]) {
                        NSString *tier =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"tier"]];
                        [TierArray addObject:tier];
                    } else {
                        [TierArray addObject:@"nil"];
                    }
                }
            }
            
            FormattedPhoneArray = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            PhoneArray = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            FacebookNameArray = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            for (NSDictionary * dict in ContactDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [FormattedPhoneArray addObject:@"nil"];
                    [PhoneArray addObject:@"nil"];
                    [FacebookNameArray addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"formattedPhone"] isKindOfClass:[NSNull class]]) {
                        NSString *formattedPhone =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"formattedPhone"]];
                        [FormattedPhoneArray addObject:formattedPhone];
                    } else {
                        [FormattedPhoneArray addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"phone"] isKindOfClass:[NSNull class]]) {
                        NSString *phone =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
                        [PhoneArray addObject:phone];
                    } else {
                        [PhoneArray addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"facebookName"] isKindOfClass:[NSNull class]]) {
                        NSString *facebookName =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"facebookName"]];
                        [FacebookNameArray addObject:facebookName];
                    } else {
                        [FacebookNameArray addObject:@"nil"];
                    }
                }
            }
//
             NSLog(@"FacebookNameArray is %@",FacebookNameArray);
            for (NSDictionary * dict in venuesDataDic){
                NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
               // NSLog(@"referralId is %@",referralId);
                [GetreferralIdArray addObject:referralId];
            }
            NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);
            
            
            [NearByTableView reloadData];
            
            [ShowActivity stopAnimating];
            
        }else{
            NSLog(@"unsuccess");
        }

        
        
        
    }];
}
- (void)startSearchWithString:(NSString *)string {
    [ShowActivity startAnimating];
    NSLog(@"Foursdquare GetString is %@",string);
    double dlatitude = [GetLatPoint doubleValue];
    double dlongitude = [GetLongPoint doubleValue];
    
    [Foursquare2 venueExploreRecommendedNearByLatitude:@(dlatitude) longitude:@(dlongitude) near:@"" accuracyLL:nil altitude:nil accuracyAlt:nil query:string limit:nil offset:nil radius:@(5000) section:nil novelty:nil sortByDistance:nil openNow:nil venuePhotos:nil price:nil callback:^(BOOL success, id result){
        //   NSLog(@"Check result is %@",result);
        if (success) {
            NSDictionary *dic = result;
            NSArray *venues = [dic valueForKeyPath:@"response.groups.items.venue"];
            NSLog(@"Check venues 1 is %@",venues);
            
            NSArray *Test = [dic valueForKeyPath:@"response.groups.items.venue/hours"];
            NSLog(@"Check Test 1 is %@",Test);
            
            NSArray *GetLocationData = (NSArray *)[venues valueForKey:@"location"];
            NSLog(@"GetLocationData ===== %@",GetLocationData);
            
            NSArray *GetContactData = (NSArray *)[venues valueForKey:@"contact"];
            NSLog(@"GetContactData ===== %@",GetContactData);
            
            NSArray *GethoursData = (NSArray *)[venues valueForKey:@"hours"];
            NSLog(@"GethoursData ===== %@",GethoursData);
            
            NSArray *GetpriceData = (NSArray *)[venues valueForKey:@"price"];
            NSLog(@"GetpriceData ===== %@",GetpriceData);

            NSDictionary *LocationDataDic = [GetLocationData objectAtIndex:0];
            NSDictionary *ContactDataDic = [GetContactData objectAtIndex:0];
            NSDictionary *HoursDataDic = [GethoursData objectAtIndex:0];
            NSDictionary *PriceDataDic = [GetpriceData objectAtIndex:0];
            NSDictionary *MainDataDic = [venues objectAtIndex:0];
            
            // [self proccessAnnotations];
            //  [ShowNearByActivity stopAnimating];
            GetLocationArray_Search = nil;
            GetreferralIdArray_Search = nil;
            AddressArray_Search = nil;
            CityArray_Search = nil;
            CountryArray_Search = nil;
            latArray_Search = nil;
            lngArray_Search = nil;
            StateArray_Search = nil;
            formattedAddressArray_Search = nil;
            postalCodeArray_Search = nil;
            GetLocationArray_Search = [[NSMutableArray alloc] initWithCapacity:[venues count]];
            GetreferralIdArray_Search = [[NSMutableArray alloc] initWithCapacity:[venues count]];
            
            AddressArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            CityArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            CountryArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            latArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            lngArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            StateArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            formattedAddressArray_Search = [[NSMutableArray alloc] initWithCapacity:[GetLocationData count]];
            postalCodeArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetLocationData count]];
            DistanceArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetLocationData count]];
            for (NSDictionary * dict in LocationDataDic){
                NSString *address =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"]];
                [AddressArray_Search addObject:address];
                NSString *city =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"city"]];
                [CityArray_Search addObject:city];
                NSString *country =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"country"]];
                [CountryArray_Search addObject:country];
                NSString *lat =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"lat"]];
                [latArray_Search addObject:lat];
                NSString *lng =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"lng"]];
                [lngArray_Search addObject:lng];
                NSString *state =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"state"]];
                [StateArray_Search addObject:state];
                NSString *formattedAddress =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"formattedAddress"]];
                [formattedAddressArray_Search addObject:formattedAddress];
                NSString *postalCode =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"postalCode"]];
                [postalCodeArray_Search addObject:postalCode];
                NSString *distance =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"distance"]];
                [DistanceArray_Search addObject:distance];
            }
            // NSLog(@"StateArray is %@",StateArray);
            
            NameArray_Search = [[NSMutableArray alloc]initWithCapacity:[venues count]];
            UrlArray_Search = [[NSMutableArray alloc]initWithCapacity:[venues count]];
            for (NSDictionary * dict in MainDataDic){
                NSString *name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
                [NameArray_Search addObject:name ];
                NSString *url_ =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
                [UrlArray_Search addObject:url_ ];
                //                NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
                //                [GetreferralIdArray addObject:referralId];
            }
            NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);
            isOpenArray_Search = [[NSMutableArray alloc]initWithCapacity:[GethoursData count]];
            HourStatusArray_Search = [[NSMutableArray alloc]initWithCapacity:[GethoursData count]];
            for (NSDictionary * dict in HoursDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [isOpenArray_Search addObject:@"nil"];
                    [HourStatusArray_Search addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"isOpen"] isKindOfClass:[NSNull class]]) {
                        NSString *isOpen =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"isOpen"]];
                        [isOpenArray_Search addObject:isOpen];
                    } else {
                        [isOpenArray_Search addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"status"] isKindOfClass:[NSNull class]]) {
                        NSString *isOpen =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
                        [HourStatusArray_Search addObject:isOpen];
                    } else {
                        [HourStatusArray_Search addObject:@"nil"];
                    }
                }
            }
            //      NSLog(@"isOpenArray is %@",isOpenArray);
            //       NSLog(@"HourStatusArray is %@",HourStatusArray);
            
            CurrencyArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            PriceMessageArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            TierArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetpriceData count]];
            for (NSDictionary * dict in PriceDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [CurrencyArray_Search addObject:@"nil"];
                    [PriceMessageArray_Search addObject:@"nil"];
                    [TierArray_Search addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"currency"] isKindOfClass:[NSNull class]]) {
                        NSString *currency =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"currency"]];
                        [CurrencyArray_Search addObject:currency];
                    } else {
                        [CurrencyArray_Search addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"message"] isKindOfClass:[NSNull class]]) {
                        NSString *message =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
                        [PriceMessageArray_Search addObject:message];
                    } else {
                        [PriceMessageArray_Search addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"tier"] isKindOfClass:[NSNull class]]) {
                        NSString *tier =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"tier"]];
                        [TierArray_Search addObject:tier];
                    } else {
                        [TierArray_Search addObject:@"nil"];
                    }
                }
            }
            
            FormattedPhoneArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            PhoneArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            FacebookNameArray_Search = [[NSMutableArray alloc]initWithCapacity:[GetContactData count]];
            for (NSDictionary * dict in ContactDataDic){
                if ([dict isKindOfClass:[NSNull class]]) {
                    [FormattedPhoneArray_Search addObject:@"nil"];
                    [PhoneArray_Search addObject:@"nil"];
                    [FacebookNameArray_Search addObject:@"nil"];
                }else{
                    if (![[dict objectForKey:@"formattedPhone"] isKindOfClass:[NSNull class]]) {
                        NSString *formattedPhone =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"formattedPhone"]];
                        [FormattedPhoneArray_Search addObject:formattedPhone];
                    } else {
                        [FormattedPhoneArray_Search addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"phone"] isKindOfClass:[NSNull class]]) {
                        NSString *phone =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"phone"]];
                        [PhoneArray_Search addObject:phone];
                    } else {
                        [PhoneArray_Search addObject:@"nil"];
                    }
                    if (![[dict objectForKey:@"facebookName"] isKindOfClass:[NSNull class]]) {
                        NSString *facebookName =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"facebookName"]];
                        [FacebookNameArray_Search addObject:facebookName];
                    } else {
                        [FacebookNameArray_Search addObject:@"nil"];
                    }
                }
            }
            
            //
            //            for (NSDictionary * dict in venues){
            //                NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
            //                [GetreferralIdArray addObject:referralId];
            //            }
            //            NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);'
            
            
            [SearchTableView_Four reloadData];
            [ShowActivity stopAnimating];
        }else{
            NSLog(@"unsuccess");
        }
        
        
        
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == NearByTableView) {
        return [NameArray count];
    }else if(tableView == SearchTableView_Google){
        return [Search_NameArray count];
        
    }else if(tableView == SearchTableView_Four){
        return [NameArray_Search count];
        
    }
    else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        if (tableView == NearByTableView) {
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(15, 5, screenWidth - 30, 25);
            ShowTitle_.tag = 200;
            ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            ShowTitle_.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
            // ShowTitle.backgroundColor = [UIColor redColor];
            [cell addSubview:ShowTitle_];
            
            UILabel *ShowCountTitle_ = [[UILabel alloc]init];
            ShowCountTitle_.frame = CGRectMake(15, 30, screenWidth - 30, 20);
            ShowCountTitle_.tag = 300;
            ShowCountTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            ShowCountTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            //ShowCountTitle.backgroundColor = [UIColor yellowColor];
            [cell addSubview:ShowCountTitle_];
        }else if(tableView == SearchTableView_Google){
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(15, 5, screenWidth - 30, 25);
            ShowTitle_.tag = 200;
           // ShowTitle_.numberOfLines = 2;
            ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
            ShowTitle_.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
            // ShowTitle.backgroundColor = [UIColor redColor];
            [cell addSubview:ShowTitle_];
            
            UILabel *ShowCountTitle_ = [[UILabel alloc]init];
            ShowCountTitle_.frame = CGRectMake(15, 30, screenWidth - 30, 20);
            ShowCountTitle_.tag = 300;
            ShowCountTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
            ShowCountTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
            //ShowCountTitle.backgroundColor = [UIColor yellowColor];
            [cell addSubview:ShowCountTitle_];
            

        }else if(tableView == SearchTableView_Four){
                UILabel *ShowTitle_ = [[UILabel alloc]init];
                ShowTitle_.frame = CGRectMake(15, 5, screenWidth - 30, 25);
                ShowTitle_.tag = 400;
                //   ShowTitle_.numberOfLines = 2;
                ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
                ShowTitle_.textColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
                // ShowTitle.backgroundColor = [UIColor redColor];
                [cell addSubview:ShowTitle_];
                
                UILabel *ShowCountTitle_ = [[UILabel alloc]init];
                ShowCountTitle_.frame = CGRectMake(15, 30, screenWidth - 30, 20);
                ShowCountTitle_.tag = 300;
                ShowCountTitle_.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
                ShowCountTitle_.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
                //ShowCountTitle.backgroundColor = [UIColor yellowColor];
                [cell addSubview:ShowCountTitle_];
        
        }
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if (tableView == NearByTableView) {
       // FSVenue *venue = self.nearbyVenues[indexPath.row];
       // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
        UILabel *ShowTitle_ = (UILabel *)[cell viewWithTag:200];
        ShowTitle_.text = [NameArray objectAtIndex:indexPath.row];
        
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray objectAtIndex:indexPath.row]];
        NSLog(@"GetAddress is %@",GetAddress);
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCity is %@",GetCity);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray objectAtIndex:indexPath.row]];
        NSLog(@"GetState is %@",GetState);
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray objectAtIndex:indexPath.row]];
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil || [GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil || [GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
            if ([GetState length] == 0 || [GetState isEqualToString:@"(null)"] || GetState == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@",GetCountry];
            }else{
                TempAddress = [[NSString alloc]initWithFormat:@"%@, %@",GetState,GetCountry];
            }
            
        }else{
            if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetpostalCode,GetCity,GetState,GetCountry];
            }else{
                // TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                if ([GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil) {
                    TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetAddress,GetCity,GetState,GetCountry];
                }else{
                    //  TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    if ([GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
                        TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetAddress,GetpostalCode,GetState,GetCountry];
                    }else{
                        TempAddress = [[NSString alloc]initWithFormat:@"%@, %@ %@, %@, %@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    }
                }
            }
        }
        NSLog(@"TempAddress is %@",TempAddress);
        UILabel *ShowCountTitle_ = (UILabel *)[cell viewWithTag:300];
        ShowCountTitle_.text = [NSString stringWithFormat:@"%@",TempAddress];
    }else if(tableView == SearchTableView_Google){
        UILabel *ShowTitle_ = (UILabel *)[cell viewWithTag:200];
        ShowTitle_.text = [Search_NameArray objectAtIndex:indexPath.row];
        if ([ShowTitle_.text isEqualToString:CustomLocalisedString(@"Addthisplace", nil)]) {
            ShowTitle_.textColor = [UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f];
        }
        
        UILabel *ShowCountTitle_ = (UILabel *)[cell viewWithTag:300];
        ShowCountTitle_.text = [Search_AddressArray objectAtIndex:indexPath.row];
    }else if(tableView == SearchTableView_Four){
        UILabel *ShowTitle_ = (UILabel *)[cell viewWithTag:400];
        ShowTitle_.text = [NameArray_Search objectAtIndex:indexPath.row];
        
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetAddress is %@",GetAddress);
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetCity is %@",GetCity);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetState is %@",GetState);
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil || [GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil || [GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
            if ([GetState length] == 0 || [GetState isEqualToString:@"(null)"] || GetState == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@",GetCountry];
            }else{
                TempAddress = [[NSString alloc]initWithFormat:@"%@, %@",GetState,GetCountry];
            }
            
        }else{
            if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetpostalCode,GetCity,GetState,GetCountry];
            }else{
                // TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                if ([GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil) {
                    TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetAddress,GetCity,GetState,GetCountry];
                }else{
                    //  TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    if ([GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
                        TempAddress = [[NSString alloc]initWithFormat:@"%@, %@, %@, %@",GetAddress,GetpostalCode,GetState,GetCountry];
                    }else{
                        TempAddress = [[NSString alloc]initWithFormat:@"%@, %@ %@, %@, %@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    }
                }
            }
        }
        
        NSLog(@"TempAddress is %@",TempAddress);
        
        NSString *GetDistance = [[NSString alloc]initWithFormat:@"%@",[DistanceArray_Search objectAtIndex:indexPath.row]];
        NSLog(@"GetDistance is %@",GetDistance);
        NSString *TempFullString;
        if ([GetDistance isEqualToString:@"(null)"] || GetDistance == nil || [GetDistance isEqualToString:@""]) {
            TempFullString = [[NSString alloc]initWithFormat:@"%@",TempAddress];
        }else{
            TempFullString = [[NSString alloc]initWithFormat:@"%@",TempAddress];
        }
        
        NSLog(@"TempFullString is %@",TempFullString);
        // cell.detailTextLabel.text = TempFullString;
        UILabel *ShowCountTitle_ = (UILabel *)[cell viewWithTag:300];
        ShowCountTitle_.text = TempFullString;
    
    }else{
        return 0;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == NearByTableView) {
        
        NSLog(@"Click...");
        
        
        NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[NameArray objectAtIndex:indexPath.row]];
        NSString *Templat = [[NSString alloc]initWithFormat:@"%@",[latArray objectAtIndex:indexPath.row]];
        NSString *TempLng = [[NSString alloc]initWithFormat:@"%@",[lngArray objectAtIndex:indexPath.row]];
        
        NSString *TempPhone = [[NSString alloc]initWithFormat:@"%@",[FormattedPhoneArray objectAtIndex:indexPath.row]];
        NSString *TempHour = [[NSString alloc]initWithFormat:@"%@",[HourStatusArray objectAtIndex:indexPath.row]];
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray objectAtIndex:indexPath.row]];
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray objectAtIndex:indexPath.row]];
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray objectAtIndex:indexPath.row]];
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray objectAtIndex:indexPath.row]];
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray objectAtIndex:indexPath.row]];
        NSString *GetreferralId = [[NSString alloc]initWithFormat:@"%@",[GetreferralIdArray objectAtIndex:indexPath.row]];
        NSString *TempFBLink = [[NSString alloc]initWithFormat:@"%@",[FacebookNameArray objectAtIndex:indexPath.row]];
        if ([TempFBLink isEqualToString:@""] || TempFBLink == nil || [TempFBLink isEqualToString:@"(null)"] || [TempFBLink isEqualToString:@"nil"]) {
            TempFBLink = @"";
        }else{
        TempFBLink = [[NSString alloc]initWithFormat:@"www.facebook.com/%@",[FacebookNameArray objectAtIndex:indexPath.row]];
        }
        
//        NSString *CreateJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": 1\n}",GetAddress,GetState,GetCountry,TempAddress,Getlat,Getlng,GetreferralId];
//        NSLog(@"CreateJsonString is %@",CreateJsonString);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:TempAddress forKey:@"PublishV2_Address"];
        [defaults setObject:TempName forKey:@"PublishV2_Name"];
        [defaults setObject:Templat forKey:@"PublishV2_Lat"];
        [defaults setObject:TempLng forKey:@"PublishV2_Lng"];
        [defaults setObject:TempFBLink forKey:@"PublishV2_Link"];
        [defaults setObject:TempPhone forKey:@"PublishV2_Contact"];
        [defaults setObject:TempHour forKey:@"PublishV2_Hour"];
        
        //location json data
        [defaults setObject:GetAddress forKey:@"PublishV2_Location_Address"];
        [defaults setObject:GetCity forKey:@"PublishV2_Location_City"];
        [defaults setObject:GetCountry forKey:@"PublishV2_Location_Country"];
        [defaults setObject:GetState forKey:@"PublishV2_Location_State"];
        [defaults setObject:GetpostalCode forKey:@"PublishV2_Location_PostalCode"];
        [defaults setObject:GetreferralId forKey:@"PublishV2_Location_ReferralId"];
        [defaults setObject:@"1" forKey:@"PublishV2_type"];
        [defaults synchronize];
        
        
        
        
        
        
        RecommendV2ViewController *ConfirmPlaceView = [[RecommendV2ViewController alloc]init];
        [self presentViewController:ConfirmPlaceView animated:YES completion:nil];
//        [ConfirmPlaceView GetAddress:[AddressArray objectAtIndex:indexPath.row] Getname:[NameArray objectAtIndex:indexPath.row] GetLat:[latArray objectAtIndex:indexPath.row] GetLong:[lngArray objectAtIndex:indexPath.row] GetFBLink:[FacebookNameArray objectAtIndex:indexPath.row] GetPhone:[FormattedPhoneArray objectAtIndex:indexPath.row] GetPrice:TempPrice GetHour:TempHour];
        
        
        
        
    }else if(tableView == SearchTableView_Google){
        GetGooglePlaceName = [[NSString alloc]initWithFormat:@"%@",[Search_NameArray objectAtIndex:indexPath.row]];
        if ([GetGooglePlaceName isEqualToString:CustomLocalisedString(@"Addthisplace", nil)]) {
            //open add place
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:GetLatPoint forKey:@"PublishV2_Lat"];
            [defaults setObject:GetLongPoint forKey:@"PublishV2_Lng"];
            [defaults synchronize];
            
            ConfirmPlaceViewController *OpenConfirmPlace = [[ConfirmPlaceViewController alloc]init];
            [self presentViewController:OpenConfirmPlace animated:YES completion:nil];
            [OpenConfirmPlace CheckAddNewPlace:@"AddNewPlace"];
            
//            GetPlaceID = [[NSString alloc]initWithFormat:@"%@",[Search_PlaceIDArray objectAtIndex:0]];
//            [self GetGooglePlaceDetail];

        }else{
            GetPlaceID = [[NSString alloc]initWithFormat:@"%@",[Search_PlaceIDArray objectAtIndex:indexPath.row]];
            [self GetGooglePlaceDetail];
        }

    }else if(tableView == SearchTableView_Four){
        // foursquare
        
        
        NSString *TempName = [[NSString alloc]initWithFormat:@"%@",[NameArray_Search objectAtIndex:indexPath.row]];
        NSString *Templat = [[NSString alloc]initWithFormat:@"%@",[latArray_Search objectAtIndex:indexPath.row]];
        NSString *TempLng = [[NSString alloc]initWithFormat:@"%@",[lngArray_Search objectAtIndex:indexPath.row]];
        NSString *TempFBLink = [[NSString alloc]initWithFormat:@"%@",[FacebookNameArray_Search objectAtIndex:indexPath.row]];
        NSString *TempPhone = [[NSString alloc]initWithFormat:@"%@",[FormattedPhoneArray_Search objectAtIndex:indexPath.row]];
        NSString *TempHour = [[NSString alloc]initWithFormat:@"%@",[HourStatusArray_Search objectAtIndex:indexPath.row]];
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray objectAtIndex:indexPath.row]];
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray objectAtIndex:indexPath.row]];
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray objectAtIndex:indexPath.row]];
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray objectAtIndex:indexPath.row]];
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray objectAtIndex:indexPath.row]];
        NSString *GetreferralId = [[NSString alloc]initWithFormat:@"%@",[GetreferralIdArray objectAtIndex:indexPath.row]];
        if ([TempFBLink isEqualToString:@""] || TempFBLink == nil || [TempFBLink isEqualToString:@"(null)"] || [TempFBLink isEqualToString:@"nil"]) {
            TempFBLink = @"";
        }else{
            TempFBLink = [[NSString alloc]initWithFormat:@"www.facebook.com/%@",[FacebookNameArray objectAtIndex:indexPath.row]];
        }
        
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:TempAddress forKey:@"PublishV2_Address"];
        [defaults setObject:TempName forKey:@"PublishV2_Name"];
        [defaults setObject:Templat forKey:@"PublishV2_Lat"];
        [defaults setObject:TempLng forKey:@"PublishV2_Lng"];
        [defaults setObject:TempFBLink forKey:@"PublishV2_Link"];
        [defaults setObject:TempPhone forKey:@"PublishV2_Contact"];
        [defaults setObject:TempHour forKey:@"PublishV2_Hour"];
        [defaults setObject:GetAddress forKey:@"PublishV2_Location_Address"];
        [defaults setObject:GetCity forKey:@"PublishV2_Location_City"];
        [defaults setObject:GetCountry forKey:@"PublishV2_Location_Country"];
        [defaults setObject:GetState forKey:@"PublishV2_Location_State"];
        [defaults setObject:GetpostalCode forKey:@"PublishV2_Location_PostalCode"];
        [defaults setObject:GetreferralId forKey:@"PublishV2_Location_ReferralId"];
        [defaults setObject:@"1" forKey:@"PublishV2_type"];
        [defaults synchronize];
        
        
        NSLog(@"Click...");
        RecommendV2ViewController *ConfirmPlaceView = [[RecommendV2ViewController alloc]init];
        [self presentViewController:ConfirmPlaceView animated:YES completion:nil];
    }


}
-(void)GetSearchText{
    [ShowActivity startAnimating];
    NSString *originalString = SearchField.text;
    NSString *replaced = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"replaced is %@",replaced);
    // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?location=%@,%@&input=%@&radius=50000&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM&type=address",GetLatPoint,GetLongPoint,replaced];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"google check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_SearchLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_SearchLocation start];
    
    
    if( theConnection_SearchLocation ){
        webData = [NSMutableData data];
    }
    
  //  place detail link
    //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJHSFhNDFJzDERNi56oRzu0_A&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == theConnection_SearchLocation) {
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        // NSLog(@"%@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetresultsData = (NSArray *)[res valueForKey:@"predictions"];
                NSLog(@"GetresultsData is %@",GetresultsData);
                Search_NameArray = [[NSMutableArray alloc]init];
                Search_AddressArray = [[NSMutableArray alloc]init];
                Search_PlaceIDArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in GetresultsData){
//                    NSString * formattedaddressData = [dict valueForKey:@"formatted_address"];
//                    [Search_AddressArray addObject:formattedaddressData];
//                    NSString * name = [dict valueForKey:@"description"];
//                    [Search_NameArray addObject:name];
                    NSString * place_id = [dict valueForKey:@"place_id"];
                    [Search_PlaceIDArray addObject:place_id];
                }

                NSDictionary *address_componentsData = [GetresultsData valueForKey:@"terms"];
                for (NSDictionary *dict in address_componentsData){
                    NSArray *valueData = (NSArray *)[dict valueForKey:@"value"];
                    if (valueData == nil || [valueData count] == 0) {
                        [Search_NameArray addObject:@""];
                        [Search_AddressArray addObject:@""];
                        [Search_PlaceIDArray addObject:@""];
                    }else{
                        //                    NSString * name = [dict valueForKey:@"value"];
                        [Search_NameArray addObject:[valueData objectAtIndex:0]];
                        if ([valueData count] == 1) {
                            
                            [Search_AddressArray addObject:[valueData objectAtIndex:0]];
                            
                        }else{
                            NSMutableArray *TempData = [[NSMutableArray alloc]init];
                            for (int i = 1; i < [valueData count]; i++) {
                                NSString * place_id = [valueData objectAtIndex:i];
                                [TempData addObject:place_id];
                            }
                            
                            NSString *result = [TempData componentsJoinedByString:@", "];
                            [Search_AddressArray addObject:result];
                        }
                    }
                }
                
                [Search_NameArray addObject:CustomLocalisedString(@"Addthisplace", nil)];
                [Search_AddressArray addObject:CustomLocalisedString(@"Cannotfindinthelist", nil)];
                [Search_PlaceIDArray addObject:@""];

                NSLog(@"Search_NameArray is %@",Search_NameArray);
                NSLog(@"Search_AddressArray is %@",Search_AddressArray);
                
                
                [SearchTableView_Google reloadData];
               // NSLog(@"Search_PlaceIDArray is %@",Search_PlaceIDArray);
                
                [ShowActivity stopAnimating];
            }
        }
    }else if(connection == theConnection_GooglePlaceDetail){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
        NSLog(@"StatusString is %@",StatusString);
        if ([StatusString isEqualToString:@"OK"]) {
            NSArray *GetresultsData = (NSArray *)[res valueForKey:@"result"];
            NSLog(@"GetresultsData is %@",GetresultsData);
            
            NSString *Get_FormattedAddress = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"formatted_address"]];
            NSLog(@"Get_FormattedAddress is %@",Get_FormattedAddress);
            NSString *Get_Name = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"name"]];
            NSLog(@"Get_Name is %@",Get_Name);
            NSString *Get_PhoneNumber = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"formatted_phone_number"]];
            NSLog(@"Get_PhoneNumber is %@",Get_PhoneNumber);
            NSString *Get_Website = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"website"]];
            NSLog(@"Get_Website is %@",Get_Website);
            NSString *Get_Address = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"vicinity"]];
            NSLog(@"Get_Address is %@",Get_Address);
            NSString *Get_referralId = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"reference"]];
            NSLog(@"Get_referralId is %@",Get_referralId);
            NSString *Get_place_id = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"place_id"]];
            NSLog(@"Get_place_id is %@",Get_place_id);
            
            NSString *Get_postalCode;
            NSString *Get_Country;
            NSString *Get_City;
            NSString *Get_State;
            
            NSDictionary *address_componentsData = [GetresultsData valueForKey:@"address_components"];
            NSLog(@"address_componentsData is %@",address_componentsData);
                for (NSDictionary *dict in address_componentsData) {
                    if ([dict count] == 0 || dict == nil || [dict isKindOfClass:[NSNull class]]) {
                    }else{
                        if([[dict objectForKey:@"types"] containsObject:@"country"])
                        {
                            NSLog(@"country : %@ ",[dict objectForKey:@"long_name"]);
                            Get_Country = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                        }
                        if([[dict objectForKey:@"types"] containsObject:@"administrative_area_level_1"])
                        {
                            NSLog(@"administrative_area_level_1 : %@ ",[dict objectForKey:@"long_name"]);
                            Get_State = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                        }
                        if([[dict objectForKey:@"types"] containsObject:@"locality"])
                        {
                            NSLog(@"locality : %@ ",[dict objectForKey:@"long_name"]);
                            Get_City = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                        }
                        if([[dict objectForKey:@"types"] containsObject:@"postal_code"])
                        {
                            NSLog(@"postal_code : %@ ",[dict objectForKey:@"long_name"]);
                            Get_postalCode = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"long_name"]];
                        }
                    }

                    
                }

            NSLog(@"Get_Country is %@",Get_Country);
            NSLog(@"Get_State is %@",Get_State);
            NSLog(@"Get_City is %@",Get_City);
            NSLog(@"Get_postalCode is %@",Get_postalCode);
            
            NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
            //NSLog(@"geometryData ===== %@",geometryData);
            NSDictionary *locationData = [geometryData valueForKey:@"location"];
            NSString *Get_Lat = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
            NSString *Get_Lng = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
            NSLog(@"Get_Lat is %@",Get_Lat);
            NSLog(@"Get_Lng is %@",Get_Lng);

            NSDictionary *OpeningHourData = [GetresultsData valueForKey:@"opening_hours"];
            NSString *sourceData = [[NSString alloc]initWithFormat:@"%@",OpeningHourData];
            NSLog(@"sourceData is %@",sourceData);
            NSArray *WeekdayData = (NSArray *)[OpeningHourData valueForKey:@"weekday_text"];
            NSLog(@"WeekdayData is %@",WeekdayData);
            
            NSDictionary *periodsData = [OpeningHourData valueForKey:@"periods"];
            NSString *periodsDataString = [[NSString alloc]initWithFormat:@"%@",periodsData];
            NSLog(@"periodsDataString is %@",periodsDataString);
            
            NSDictionary *closeData = [periodsData valueForKey:@"close"];
            NSDictionary *openData = [periodsData valueForKey:@"open"];
            NSLog(@"closeData is %@",closeData);
            NSLog(@"openData is %@",openData);
            
            NSMutableArray *CloseArray = [[NSMutableArray alloc]init];
            NSMutableArray *OpenArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in closeData) {//close data
                NSString *GetDay = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"day"]];
                NSString *GetTime = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"time"]];
                //    NSLog(@"GetDay is %@",GetDay);
                //    NSLog(@"GetTime is %@",GetTime);
                
                NSString *TempString = [[NSString alloc]initWithFormat:@"{\"close\":{\"day\":%@,\"time\":\"%@\"}",GetDay,GetTime];
                //NSLog(@"TempString is %@",TempString);
                [CloseArray addObject:TempString];
            }
            
            for (NSDictionary *dict in openData) {//open data
                NSString *GetDay = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"day"]];
                NSString *GetTime = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"time"]];
                //  NSLog(@"GetDay is %@",GetDay);
                // NSLog(@"GetTime is %@",GetTime);
                
                NSString *TempString = [[NSString alloc]initWithFormat:@"\"open\":{\"day\":%@,\"time\":\"%@\"}}",GetDay,GetTime];
                // NSLog(@"TempString is %@",TempString);
                [OpenArray addObject:TempString];
            }
            
            NSLog(@"CloseArray is %@",CloseArray);
            NSLog(@"OpenArray is %@",OpenArray);
            
            NSMutableArray *FullArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < [CloseArray count]; i++) {
                NSString *TestString = [[NSString alloc]initWithFormat:@"%@,%@",[CloseArray objectAtIndex:i],[OpenArray objectAtIndex:i]];
                [FullArray addObject:TestString];
            }
            
            NSString *greeting = [FullArray componentsJoinedByString:@","];
            NSLog(@"greeting %@",greeting);
            
            NSString *open_nowData = [[NSString alloc]initWithFormat:@"%@",[OpeningHourData valueForKey:@"open_now"]];
            NSLog(@"open_nowData is %@",open_nowData);
            
            NSString *GetHour;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEEE"];
            NSLog(@"%@", [dateFormatter stringFromDate:[NSDate date]]);
            NSString *dayName = [dateFormatter stringFromDate:[NSDate date]];
            NSLog(@"dayName is %@",dayName);
            
            if ([WeekdayData count] == 0) {
                GetHour = @"";
            }else{
                if ([dayName isEqualToString:@"Monday"]) {
                    GetHour = [WeekdayData objectAtIndex:0];
                }else if([dayName isEqualToString:@"Tuesday"]){
                    NSLog(@"Get Display Data is %@",[WeekdayData objectAtIndex:1]);
                    GetHour = [WeekdayData objectAtIndex:1];
                }else if([dayName isEqualToString:@"Wednesday"]){
                    GetHour = [WeekdayData objectAtIndex:2];
                }else if([dayName isEqualToString:@"Thursday"]){
                    GetHour = [WeekdayData objectAtIndex:3];
                }else if([dayName isEqualToString:@"Friday"]){
                    GetHour = [WeekdayData objectAtIndex:4];
                }else if([dayName isEqualToString:@"Saturday"]){
                    GetHour = [WeekdayData objectAtIndex:5];
                }else if([dayName isEqualToString:@"Sunday"]){
                    GetHour = [WeekdayData objectAtIndex:6];
                }
            }
            
            NSMutableArray *FullArray11 = [[NSMutableArray alloc]init];
            for (int i = 0; i < [WeekdayData count]; i++) {
                NSString *TestString = [[NSString alloc]initWithFormat:@"\"%@\"",[WeekdayData objectAtIndex:i]];
                [FullArray11 addObject:TestString];
            }
            NSString *WeekdayDataString = [FullArray11 componentsJoinedByString:@","];
            NSLog(@"WeekdayDataString %@",WeekdayDataString);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setObject:Get_FormattedAddress forKey:@"PublishV2_Address"];
            [defaults setObject:GetGooglePlaceName forKey:@"PublishV2_Name"];
            [defaults setObject:Get_Lat forKey:@"PublishV2_Lat"];
            [defaults setObject:Get_Lng forKey:@"PublishV2_Lng"];
            [defaults setObject:Get_Website forKey:@"PublishV2_Link"];
            [defaults setObject:Get_PhoneNumber forKey:@"PublishV2_Contact"];
            [defaults setObject:GetHour forKey:@"PublishV2_Hour"];
            
            [defaults setObject:Get_Address forKey:@"PublishV2_Location_Address"];
            [defaults setObject:Get_City forKey:@"PublishV2_Location_City"];
            [defaults setObject:Get_Country forKey:@"PublishV2_Location_Country"];
            [defaults setObject:Get_State forKey:@"PublishV2_Location_State"];
            [defaults setObject:Get_postalCode forKey:@"PublishV2_Location_PostalCode"];
            [defaults setObject:Get_referralId forKey:@"PublishV2_Location_ReferralId"];
            [defaults setObject:Get_place_id forKey:@"PublishV2_Location_PlaceId"];
            [defaults setObject:@"2" forKey:@"PublishV2_type"];
            [defaults setObject:WeekdayDataString forKey:@"PublishV2_Source"];
            [defaults setObject:greeting forKey:@"PublishV2_Period"];
            [defaults setObject:open_nowData forKey:@"PublishV2_OpenNow"];
            [defaults synchronize];
            
//            if ([GetGooglePlaceName isEqualToString:@"Add this place?"]) {
//                //open add place
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:Get_Lat forKey:@"PublishV2_Lat"];
//                [defaults setObject:Get_Lng forKey:@"PublishV2_Lng"];
//                [defaults synchronize];
//                
//                ConfirmPlaceViewController *OpenConfirmPlace = [[ConfirmPlaceViewController alloc]init];
//                [self presentViewController:OpenConfirmPlace animated:YES completion:nil];
//                [OpenConfirmPlace CheckAddNewPlace:@"AddNewPlace"];
//                
//            }else{
//                RecommendV2ViewController *ConfirmPlaceView = [[RecommendV2ViewController alloc]init];
//                [self presentViewController:ConfirmPlaceView animated:YES completion:nil];
//            }
            
            RecommendV2ViewController *ConfirmPlaceView = [[RecommendV2ViewController alloc]init];
            [self presentViewController:ConfirmPlaceView animated:YES completion:nil];
            

        }
    }
}
-(IBAction)GoogleButton:(id)sender{
    Check = 0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSLog(@"Google Button Click");
    [GoogleButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [FoursquareButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    CheckSelectWhichOne = 0;
    ArrowImage.frame = CGRectMake((screenWidth/2)/2 - 10, 40, 21, 11);
    NSString *TempString = SearchField.text;
    if ([TempString length] == 0) {
        
    }else{
        [self GetSearchText];
    }
    SearchTableView_Google.hidden = NO;
    SearchTableView_Four.hidden = YES;
    //[SearchTableView reloadData];
  
}
-(IBAction)FoursquareButton:(id)sender{
    Check = 1;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    ArrowImage.frame = CGRectMake((screenWidth/2) + (screenWidth/2) / 2 - 10, 40, 21, 11);
    [FoursquareButton setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [GoogleButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    NSLog(@"Foursquare Button Click");
    CheckSelectWhichOne = 1;
    NSString *TempString = SearchField.text;
    if ([TempString length] == 0) {
        
    }else{
        [self startSearchWithString:TempString];
    }
    SearchTableView_Google.hidden = YES;
    SearchTableView_Four.hidden = NO;
    //[SearchTableView reloadData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 500) {//delete action
        if (buttonIndex == [alertView cancelButtonIndex]){
            //cancel clicked ...do your action
        }else if(buttonIndex == 1){
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            NSLog(@"confirm delete post");
            CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
            CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
            
            UITabBarController *tabBarController=[[UITabBarController alloc]init];
            tabBarController.tabBar.frame = CGRectMake(0, screenHeight - 50, screenWidth, 50);
            [tabBarController.tabBar setTintColor:[UIColor colorWithRed:51.0f/255.0f green:181.0f/255.0f blue:229.0f/255.0f alpha:1.0]];
            //FirstViewController and SecondViewController are the view controller you want on your UITabBarController
//            UIImage* tabBarBackground = [UIImage imageNamed:@"TabBarBg@2x-1.png"];
//            [[UITabBar appearance] setShadowImage:tabBarBackground];
//            [[UITabBar appearance] setBackgroundImage:tabBarBackground];
            
            
            FeedV2ViewController *firstViewController=[[FeedV2ViewController alloc]initWithNibName:@"FeedV2ViewController" bundle:nil];
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:firstViewController];
            Explore2ViewController *secondViewController=[[Explore2ViewController alloc]initWithNibName:@"Explore2ViewController" bundle:nil];
            
            SelectImageViewController *threeViewController=[[SelectImageViewController alloc]initWithNibName:@"SelectImageViewController" bundle:nil];
            
            NotificationViewController *fourViewController=[[NotificationViewController alloc]initWithNibName:@"NotificationViewController" bundle:nil];
            
            ProfileV2ViewController *fiveViewController=[[ProfileV2ViewController alloc]initWithNibName:@"ProfileV2ViewController" bundle:nil];
            
            //adding view controllers to your tabBarController bundling them in an array
            tabBarController.viewControllers=[NSArray arrayWithObjects:navController,secondViewController,threeViewController,fourViewController,fiveViewController, nil];
            
            
            //[self presentModalViewController:tabBarController animated:YES];
            // [self presentViewController:tabBarController animated:NO completion:nil];
            [[[[UIApplication sharedApplication] delegate] window] setRootViewController:tabBarController];
            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Address"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Name"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lat"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Lng"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Link"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Contact"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Hour"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Address"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_City"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SelectLanguage"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_Country"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_State"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_PostalCode"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Location_ReferralId"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_type"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_Show"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Price_NumCode"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_BlogLink"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"selectedIndexArr_Thumbs_Data"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Source"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Period"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_OpenNow"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Draft_PhotoCaption"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoCount"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Title"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Message"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionDataArray"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringArray"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_TagStringDataArray"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_CaptionArray"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_Category"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PublishV2_PhotoID_Delete"];
        }
    }

}
-(void)hideKeyboard
{
    [SearchField resignFirstResponder];
    if ([SearchField.text length] == 0) {
        ShowSearchView.hidden = YES;
    }
    
}
-(void)GetGooglePlaceDetail{
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",GetPlaceID];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GooglePlaceDetail = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GooglePlaceDetail start];
    
    
    if( theConnection_GooglePlaceDetail ){
        webData = [NSMutableData data];
    }
    
    //  place detail link
    //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJHSFhNDFJzDERNi56oRzu0_A&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
}
@end
