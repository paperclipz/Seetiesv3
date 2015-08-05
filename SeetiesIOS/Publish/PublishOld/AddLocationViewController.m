//
//  AddLocationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "AddLocationViewController.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import <CoreLocation/CoreLocation.h>
#import "EditLocationViewController.h"
#import "ChangeSearchLocationViewController.h"

#import "LanguageManager.h"
#import "Locale.h"

@interface AddLocationViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) FSVenue *selected;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (strong, nonatomic) NSArray *venues;
@property (nonatomic, weak) NSOperation *lastSearchOperation;
@end

@implementation AddLocationViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    //Addlocation
    SearchField.delegate = self;
    ShowNearbySuggestionsText.text = CustomLocalisedString(@"Provisioning_PTellUsYourCityView_5", nil);
    ShowTitle.text = CustomLocalisedString(@"Addlocation", nil);
    SearchField.placeholder = CustomLocalisedString(@"Searchforaplace", nil);
    NearbySuggestionLabel.text = CustomLocalisedString(@"NearbySuggestions", nil);
    SearchResults.text = CustomLocalisedString(@"SEARCHHISTORY", nil);
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish Add Location Page";
    
    ShowNearbySuggestionsView.frame = CGRectMake(0, 122, 320, 443);
    ShowSearchView.frame = CGRectMake(0, 172, 320, 396);
    
    [self.view addSubview:ShowNearbySuggestionsView];
    [self.view addSubview:ShowSearchView];
    

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetTempName = [defaults objectForKey:@"ChangeSearchLocation_Name"];
    NSString *GetTemplat = [defaults objectForKey:@"ChangeSearchLocation_Lat"];
    NSString *GetTemplng = [defaults objectForKey:@"ChangeSearchLocation_Long"];
    NSLog(@"GetTempName is %@",GetTempName);
    if ([GetTempName length] == 0) {
       // [ShowNearbySuggestionsButton setTitle:@"Near my current location" forState:UIControlStateNormal];
        ShowSearchView.hidden = YES;
        ShowNearbySuggestionsButton.hidden = YES;
        ShowNearbySuggestionsText.text = CustomLocalisedString(@"Provisioning_PTellUsYourCityView_5", nil);
        ShowNearbySuggestionsText.hidden = YES;
        ShowTitleBar.frame = CGRectMake(0, 0, 320, 123);
    }else{
      //  [ShowNearbySuggestionsButton setTitle:GetTempName forState:UIControlStateNormal];
        ShowNearbySuggestionsText.text = GetTempName;
        ShowSearchView.hidden = YES;
        ShowNearbySuggestionsButton.hidden = NO;
        ShowNearbySuggestionsText.hidden = NO;
        ShowNearbySuggestionsView.hidden = NO;
        ShowNearbySuggestionsView.frame = CGRectMake(0, 172, 320, 396);
        [self Getlatitude:GetTemplat Getlongitude:GetTemplng];
        ShowTitleBar.frame = CGRectMake(0, 0, 320, 170);
    }
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
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"did begin editing");
    ShowNearbySuggestionsView.hidden = YES;
    ShowNearbySuggestionsButton.hidden = NO;
    ShowNearbySuggestionsText.hidden = NO;
    ShowSearchView.hidden = NO;
    ShowTitleBar.frame = CGRectMake(0, 0, 320, 170);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchField resignFirstResponder];
    ShowNearbySuggestionsView.hidden = NO;
    ShowNearbySuggestionsButton.hidden = YES;
    ShowNearbySuggestionsText.hidden = YES;
    ShowSearchView.hidden = YES;
    ShowTitleBar.frame = CGRectMake(0, 0, 320, 123);
}
- (void)getVenuesForLocation:(CLLocation *)location {
    NSLog(@"getVenuesForLocation work here?");
    [ShowNearByActivity startAnimating];
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          NSLog(@"venues is %@",venues);
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues = [converter convertToObjects:venues];
                                          [tblview reloadData];
                                         // [self proccessAnnotations];
                                          [ShowNearByActivity stopAnimating];
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
                                          GetreferralIdArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
//                                          NSDictionary *Alldata = [dic valueForKey:@"categories"];
//                                          NSLog(@"Alldata is %@",Alldata);
//                                          NSDictionary *Getlocationdata = [venues valueForKey:@"location"];
//                                          NSLog(@"Getlocationdata is %@",Getlocationdata);
                                          
                                          NSArray *GetCategoryData = (NSArray *)[venues valueForKey:@"location"];
                                          NSLog(@"GetCategoryData ===== %@",GetCategoryData);

                                          AddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          CityArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          CountryArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          latArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          lngArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          StateArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          formattedAddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          postalCodeArray = [[NSMutableArray alloc]initWithCapacity:[GetCategoryData count]];
                                          for (NSDictionary * dict in GetCategoryData){
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
                                          }
                                          NSLog(@"StateArray is %@",StateArray);
                                          
                                          for (NSDictionary * dict in venues){
                                              NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
                                              [GetreferralIdArray addObject:referralId];
                                          }
                                          NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);
                                        
                                          
                                      }
                                  }];
}
- (void)Getlatitude:(NSString *)latitude Getlongitude:(NSString *)longitude {
    [ShowNearByActivity startAnimating];
    double dlatitude = [latitude doubleValue];
    double dlongitude = [longitude doubleValue];
    [Foursquare2 venueSearchNearByLatitude:@(dlatitude)
                                 longitude:@(dlongitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(500)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          NSLog(@"venues is %@",venues);
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues = [converter convertToObjects:venues];
                                          [tblview reloadData];
                                          // [self proccessAnnotations];
                                          [ShowNearByActivity stopAnimating];
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
                                          GetreferralIdArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
                                          //                                          NSDictionary *Alldata = [dic valueForKey:@"categories"];
                                          //                                          NSLog(@"Alldata is %@",Alldata);
                                          //                                          NSDictionary *Getlocationdata = [venues valueForKey:@"location"];
                                          //                                          NSLog(@"Getlocationdata is %@",Getlocationdata);
                                          
                                          NSArray *GetCategoryData = (NSArray *)[venues valueForKey:@"location"];
                                          NSLog(@"GetCategoryData ===== %@",GetCategoryData);
                                          
                                          AddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          CityArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          CountryArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          latArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          lngArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          StateArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          formattedAddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                          postalCodeArray = [[NSMutableArray alloc]initWithCapacity:[GetCategoryData count]];
                                          for (NSDictionary * dict in GetCategoryData){
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
                                          }
                                          NSLog(@"StateArray is %@",StateArray);
                                          
                                          for (NSDictionary * dict in venues){
                                              NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
                                              [GetreferralIdArray addObject:referralId];
                                          }
                                          NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);
                                          
                                      }
                                  }];
}
//- (void)locationManager:(CLLocationManager *)manager
//    didUpdateToLocation:(CLLocation *)newLocation
//           fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"newLocation is %@",newLocation);
//   
//
//    //[self setupMapForLocatoion:newLocation];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *GetTempName = [defaults objectForKey:@"ChangeSearchLocation_Name"];
//    if ([GetTempName length] == 0) {
//        NSLog(@"come here? 1");
//         [self.locationManager stopUpdatingLocation];
//        [self getVenuesForLocation:newLocation];
//        self.location = newLocation;
//    }else{
//        NSLog(@"come here? 2");
//    }
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"newLocation is %@",newLocation);
    
    
    //[self setupMapForLocatoion:newLocation];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetTempName = [defaults objectForKey:@"ChangeSearchLocation_Name"];
    if ([GetTempName length] == 0) {
        NSLog(@"come here? 1");
        [self.locationManager stopUpdatingLocation];
        [self getVenuesForLocation:newLocation];
        self.location = newLocation;
    }else{
        NSLog(@"come here? 2");
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.locationManager stopUpdatingLocation];
}

- (void)startSearchWithString:(NSString *)string {
    [ShowSearchActivity startAnimating];
    NSLog(@"GetString is %@",string);
    NSLog(@"location latitude is %f",self.location.coordinate.latitude);
    NSLog(@"location longitude is %f",self.location.coordinate.longitude);
    
    [self.lastSearchOperation cancel];
    self.lastSearchOperation = [Foursquare2
                                venueSearchNearByLatitude:@(self.location.coordinate.latitude)
                                longitude:@(self.location.coordinate.longitude)
                                query:string
                                limit:nil
                                intent:intentCheckin
                                radius:@(500)
                                categoryId:nil
                                callback:^(BOOL success, id result){
                                    if (success) {
                                        NSDictionary *dic = result;
                                        NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                        FSConverter *converter = [[FSConverter alloc] init];
                                        self.venues = [converter convertToObjects:venues];
                                        [tblview_Search reloadData];
                                        [ShowSearchActivity stopAnimating];
                                        
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
                                        GetreferralIdArray = [[NSMutableArray alloc] initWithCapacity:[venues count]];
                                        //                                          NSDictionary *Alldata = [dic valueForKey:@"categories"];
                                        //                                          NSLog(@"Alldata is %@",Alldata);
                                        //                                          NSDictionary *Getlocationdata = [venues valueForKey:@"location"];
                                        //                                          NSLog(@"Getlocationdata is %@",Getlocationdata);
                                        
                                        NSArray *GetCategoryData = (NSArray *)[venues valueForKey:@"location"];
                                        NSLog(@"GetCategoryData ===== %@",GetCategoryData);
                                        
                                        AddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        CityArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        CountryArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        latArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        lngArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        StateArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        formattedAddressArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
                                        postalCodeArray = [[NSMutableArray alloc]initWithCapacity:[GetCategoryData count]];
                                        for (NSDictionary * dict in GetCategoryData){
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
                                        }
                                        NSLog(@"StateArray is %@",StateArray);
                                        
                                        for (NSDictionary * dict in venues){
                                            NSString *referralId =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"referralId"]];
                                            [GetreferralIdArray addObject:referralId];
                                        }
                                        NSLog(@"GetreferralIdArray is %@",GetreferralIdArray);
                                    } else {
                                        NSLog(@"%@",result);
                                    }
                                }];
}






- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == tblview) {
        return self.nearbyVenues.count;
    }else if(tableView == tblview_Search){
        return self.venues.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    if (tableView == tblview) {
        FSVenue *venue = self.nearbyVenues[indexPath.row];
        cell.textLabel.text = [venue name];
        if (venue.location.address) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
                                         venue.location.distance,
                                         venue.location.address];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                         venue.location.distance];
        }
    }else if(tableView == tblview_Search){
        FSVenue *venue = self.venues[indexPath.row];
        cell.textLabel.text = [venue name];
        if (venue.location.address) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
                                         venue.location.distance,
                                         venue.location.address];
        } else {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
                                         venue.location.distance];
        }
    }else{
        return 0;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"Click...");
    if (tableView == tblview) {
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray objectAtIndex:indexPath.row]];
        NSLog(@"GetAddress is %@",GetAddress);
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCity is %@",GetCity);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray objectAtIndex:indexPath.row]];
        NSLog(@"GetState is %@",GetState);
        NSString *Getlat = [[NSString alloc]initWithFormat:@"%@",[latArray objectAtIndex:indexPath.row]];
        NSLog(@"Getlat is %@",Getlat);
        NSString *Getlng = [[NSString alloc]initWithFormat:@"%@",[lngArray objectAtIndex:indexPath.row]];
        NSLog(@"Getlng is %@",Getlng);
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray objectAtIndex:indexPath.row]];
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        NSString *GetreferralId = [[NSString alloc]initWithFormat:@"%@",[GetreferralIdArray objectAtIndex:indexPath.row]];
        NSLog(@"GetreferralId is %@",GetreferralId);
        NSString *GetformattedAddress = [[NSString alloc]initWithFormat:@"%@",[formattedAddressArray objectAtIndex:indexPath.row]];
        NSLog(@"GetformattedAddress is %@",GetformattedAddress);
        NSString *TempAddress;
        
        
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil || [GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil || [GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
            if ([GetState length] == 0 || [GetState isEqualToString:@"(null)"] || GetState == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@",GetCountry];
            }else{
            TempAddress = [[NSString alloc]initWithFormat:@"%@,%@",GetState,GetCountry];
            }
            
        }else{
            if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetpostalCode,GetCity,GetState,GetCountry];
            }else{
                // TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                if ([GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil) {
                    TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetAddress,GetCity,GetState,GetCountry];
                }else{
                    //  TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    if ([GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
                        TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetAddress,GetpostalCode,GetState,GetCountry];
                    }else{
                        TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    }
                }
            }
        }
        
        



       
        NSLog(@"TempAddress is %@",TempAddress);
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
            GetAddress = @"";
        }
        if ([GetState length] == 0 || [GetState isEqualToString:@"(null)"] || GetState == nil) {
            GetState = @"";
        }
        if ([GetCountry length] == 0 || [GetCountry isEqualToString:@"(null)"] || GetCountry == nil) {
            GetCountry = @"";
        }
        if ([TempAddress length] == 0 || [TempAddress isEqualToString:@"(null)"] || TempAddress == nil) {
            TempAddress = @"";
        }
        if ([Getlat length] == 0 || [Getlat isEqualToString:@"(null)"] || Getlat == nil) {
            Getlat = @"";
        }
        if ([Getlng length] == 0 || [Getlng isEqualToString:@"(null)"] || Getlng == nil) {
            Getlng = @"";
        }
        if ([GetreferralId length] == 0 || [GetreferralId isEqualToString:@"(null)"] || GetreferralId == nil) {
            GetreferralId = @"";
        }
        
        
        NSString *CreateJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": 1\n}",GetAddress,GetState,GetCountry,TempAddress,Getlat,Getlng,GetreferralId];
        NSLog(@"CreateJsonString is %@",CreateJsonString);
        
        FSVenue *venue = self.nearbyVenues[indexPath.row];
        EditLocationViewController *EditLocationView = [[EditLocationViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:EditLocationView animated:NO completion:nil];
       // [EditLocationView GetName:[venue name] GetAddress:venue.location.address GetLat:venue.location.coordinate];
        [EditLocationView GetName:[venue name] GetAddress:TempAddress  GetLat:venue.location.coordinate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:CreateJsonString forKey:@"Location_Json"];
        [defaults synchronize];


    }else{
        NSString *GetAddress = [[NSString alloc]initWithFormat:@"%@",[AddressArray objectAtIndex:indexPath.row]];
        NSLog(@"GetAddress is %@",GetAddress);
        NSString *GetCity = [[NSString alloc]initWithFormat:@"%@",[CityArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCity is %@",GetCity);
        NSString *GetCountry = [[NSString alloc]initWithFormat:@"%@",[CountryArray objectAtIndex:indexPath.row]];
        NSLog(@"GetCountry is %@",GetCountry);
        NSString *GetState = [[NSString alloc]initWithFormat:@"%@",[StateArray objectAtIndex:indexPath.row]];
        NSLog(@"GetState is %@",GetState);
        NSString *Getlat = [[NSString alloc]initWithFormat:@"%@",[latArray objectAtIndex:indexPath.row]];
        NSLog(@"Getlat is %@",Getlat);
        NSString *Getlng = [[NSString alloc]initWithFormat:@"%@",[lngArray objectAtIndex:indexPath.row]];
        NSLog(@"Getlng is %@",Getlng);
        NSString *GetpostalCode = [[NSString alloc]initWithFormat:@"%@",[postalCodeArray objectAtIndex:indexPath.row]];
        NSLog(@"GetpostalCode is %@",GetpostalCode);
        NSString *GetreferralId = [[NSString alloc]initWithFormat:@"%@",[GetreferralIdArray objectAtIndex:indexPath.row]];
        NSLog(@"GetreferralId is %@",GetreferralId);
        NSString *GetformattedAddress = [[NSString alloc]initWithFormat:@"%@",[formattedAddressArray objectAtIndex:indexPath.row]];
        NSLog(@"GetformattedAddress is %@",GetformattedAddress);
        
        NSString *TempAddress;
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil || [GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil || [GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
            TempAddress = [[NSString alloc]initWithFormat:@"%@,%@",GetState,GetCountry];
        }else{
            if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
                TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetpostalCode,GetCity,GetState,GetCountry];
            }else{
                // TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                if ([GetpostalCode length] == 0 || [GetpostalCode isEqualToString:@"(null)"] || GetpostalCode == nil) {
                    TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetAddress,GetCity,GetState,GetCountry];
                }else{
                    //  TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    if ([GetCity length] == 0 || [GetCity isEqualToString:@"(null)"] || GetCity == nil) {
                        TempAddress = [[NSString alloc]initWithFormat:@"%@,%@,%@,%@",GetAddress,GetpostalCode,GetState,GetCountry];
                    }else{
                        TempAddress = [[NSString alloc]initWithFormat:@"%@,%@ %@,%@,%@",GetAddress,GetpostalCode,GetCity,GetState,GetCountry];
                    }
                }
            }
        }
        
        NSLog(@"TempAddress is %@",TempAddress);
        if ([GetAddress length] == 0 || [GetAddress isEqualToString:@"(null)"] || GetAddress == nil) {
            GetAddress = @"";
        }
        if ([GetState length] == 0 || [GetState isEqualToString:@"(null)"] || GetState == nil) {
            GetState = @"";
        }
        if ([GetCountry length] == 0 || [GetCountry isEqualToString:@"(null)"] || GetCountry == nil) {
            GetCountry = @"";
        }
        if ([TempAddress length] == 0 || [TempAddress isEqualToString:@"(null)"] || TempAddress == nil) {
            TempAddress = @"";
        }
        if ([Getlat length] == 0 || [Getlat isEqualToString:@"(null)"] || Getlat == nil) {
            Getlat = @"";
        }
        if ([Getlng length] == 0 || [Getlng isEqualToString:@"(null)"] || Getlng == nil) {
            Getlng = @"";
        }
        if ([GetreferralId length] == 0 || [GetreferralId isEqualToString:@"(null)"] || GetreferralId == nil) {
            GetreferralId = @"";
        }
        
        NSString *CreateJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {\n   \"route\":\"%@\",\n   \"administrative_area_level_1\":\"%@\",\n   \"country\":\"%@\"\n  },\n  \"formatted_address\": \"%@\",\n  \"lat\": %@,\n  \"lng\": %@,\n  \"reference\": \"%@\",\n  \"type\": 1\n}",GetAddress,GetState,GetCountry,TempAddress,Getlat,Getlng,GetreferralId];
        NSLog(@"CreateJsonString is %@",CreateJsonString);
        
        
        FSVenue *venue = self.venues[indexPath.row];
        EditLocationViewController *EditLocationView = [[EditLocationViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:EditLocationView animated:NO completion:nil];
       // [EditLocationView GetName:[venue name] GetAddress:venue.location.address GetLat:venue.location.coordinate];
        [EditLocationView GetName:[venue name] GetAddress:TempAddress GetLat:venue.location.coordinate];
        [EditLocationView JsonAddress:GetAddress JsonState:GetState JsonCountry:GetCountry JsonTempAddress:TempAddress JsonLat:Getlat JsonLng:Getlng JsonID:GetreferralId];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:CreateJsonString forKey:@"Location_Json"];
        [defaults synchronize];

    }
    
}
-(IBAction)NearbySuggestionsButton:(id)sender{
    [SearchField resignFirstResponder];
    ShowNearbySuggestionsView.hidden = NO;
    ShowNearbySuggestionsText.hidden = YES;
    ShowNearbySuggestionsButton.hidden = YES;
    ShowSearchView.hidden = YES;
    NSLog(@"Got Change View ?");
    ChangeSearchLocationViewController *ChangeSearchLocationView = [[ChangeSearchLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:ChangeSearchLocationView animated:NO completion:nil];
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"work here?");
    [SearchField resignFirstResponder];
    [self startSearchWithString:SearchField.text];
    return YES;
}

@end
