//
//  ChangeSearchLocationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ChangeSearchLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

@interface ChangeSearchLocationViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation ChangeSearchLocationViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SearchLocationField.delegate = self;
    
    tblview.frame = CGRectMake(0, 203, 320, [UIScreen mainScreen].bounds.size.height - 203);
    
    CheckTbl = 0;
    
    [CurrentLocationButton setTitle:CustomLocalisedString(@"Currentlocation", nil) forState:UIControlStateNormal];
    ShowTitle.text = CustomLocalisedString(@"SEARCHHISTORY", nil);
    SubTitle.text = CustomLocalisedString(@"Changesearchlocation", nil);
    SearchLocationField.placeholder = CustomLocalisedString(@"searchlocation", nil);
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish ChangeSearch Location Page";
    
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"work here?");
    [SearchLocationField resignFirstResponder];
    [self performSearch];
    [ShowActivity startAnimating];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSLog(@"newString is %@",newString);
    NSLog(@"found");
    if ([newString length] > 2) {
        NSLog(@"Check server");
        [self performSearch];
        [ShowActivity startAnimating];
        // [NSThread detachNewThreadSelector:@selector(SendMentionsToServer) toTarget:self withObject:nil];
    }else{
        
    }
    
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchLocationField resignFirstResponder];
  //  [DescriptionField resignFirstResponder];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
         [self performSearchLatnLong];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetLat = [defaults objectForKey:@"GetLat"];
        NSString *GetLon = [defaults objectForKey:@"GetLang"];
        
        latPoint = GetLat;
        lonPoint = GetLon;
        
        [self performSearchLatnLong];
    }
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = [locations lastObject];
//    
//    latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    
//    NSLog(@"lat is %@ : lon is %@",latPoint, lonPoint);
//    //Now you know the location has been found, do other things, call others methods here
//    [self.locationManager stopUpdatingLocation];
//    
//    [self performSearchLatnLong];
//}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
    NSLog(@"didFailWithError: %@", error);
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"please check your network connection or that you are not in airplane mode" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"user has denied to use current Location " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"unknown network error" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
            break;
    }
}
-(IBAction)CurrentLocationButton:(id)sender{
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
}
-(void)performSearchLatnLong{
    
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=mel&location=3.099292%2C101.6448593&radius=500&sensor=false&types=geocode&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
    
    //    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=mel&location=%@,%@&radius=500&sensor=false&types=geocode&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8",latPoint,lonPoint];
    
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",latPoint,lonPoint];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GpsLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GpsLocation start];
    
    
    if( theConnection_GpsLocation ){
        webData = [NSMutableData data];
    }
}
-(void)performSearch{
    
    NSString *originalString = SearchLocationField.text;
    NSString *replaced = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"replaced is %@",replaced);
    //    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&radius=500&sensor=false&types=geocode&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",replaced];
    
    //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=mel&location=3.099292%2C101.6448593&radius=500&sensor=false&types=geocode&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_SearchLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_SearchLocation start];
    
    
    if( theConnection_SearchLocation ){
        webData = [NSMutableData data];
    }
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
        
        NSArray *GetpredictionsData = (NSArray *)[res valueForKey:@"predictions"];
        NameArray = [[NSMutableArray alloc]init];
        PlaceIDArray = [[NSMutableArray alloc]init];
        ReferenceArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in GetpredictionsData){
            NSString * formattedaddressData = [dict valueForKey:@"description"];
            NSLog(@"formattedaddressData ===== %@",formattedaddressData);
            [NameArray addObject:formattedaddressData];
            NSString * place_id = [dict valueForKey:@"place_id"];
            [PlaceIDArray addObject:place_id];
            NSString * reference = [dict valueForKey:@"reference"];
            [ReferenceArray addObject:reference];
        }
        ShowTitle.text = @"Suggestions";
        [tblview reloadData];
        [ShowActivity stopAnimating];
        CheckTbl = 1;
    }else if(connection == theConnection_GpsLocation){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        // NSLog(@"%@",res);
        
        NSArray *GetresultsData = (NSArray *)[res valueForKey:@"results"];
        // NSLog(@"GetresultsData ===== %@",GetresultsData);
        
        NameArray = [[NSMutableArray alloc]init];
        LatArray = [[NSMutableArray alloc]init];
        LongArray = [[NSMutableArray alloc]init];
        address_componentsArray = [[NSMutableArray alloc]init];
        
        NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
        NSLog(@"geometryData ===== %@",geometryData);
        NSDictionary *locationData = [geometryData valueForKey:@"location"];
        //    NSString * formattedaddressData = [[GetresultsData valueForKey:@"formatted_address"] componentsJoinedByString:@""];
        //    NSLog(@"formattedaddressData ===== %@",formattedaddressData);
        //    [NameArray addObject:formattedaddressData];
        
        
        for (NSDictionary *dict in GetresultsData){
            NSString * formattedaddressData = [dict valueForKey:@"formatted_address"];
            NSLog(@"formattedaddressData ===== %@",formattedaddressData);
            [NameArray addObject:formattedaddressData];
            
            NSDictionary *address_componentsData = [dict valueForKey:@"address_components"];
            NSLog(@"address_componentsData is %@",address_componentsData);
            NSMutableArray *testarray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in address_componentsData) {
                if([[dict objectForKey:@"types"] containsObject:@"country"])
                {
                    NSLog(@"country : %@ ",[dict objectForKey:@"long_name"]);
                    NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"country\":\"%@\"",[dict objectForKey:@"long_name"]];
                    [testarray addObject:FullString];
                    //  break;
                }
                if([[dict objectForKey:@"types"] containsObject:@"route"])
                {
                    NSLog(@"route : %@ ",[dict objectForKey:@"long_name"]);
                    NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"route\":\"%@\"",[dict objectForKey:@"long_name"]];
                    [testarray addObject:FullString];
                    //  break;
                }
                if([[dict objectForKey:@"types"] containsObject:@"administrative_area_level_1"])
                {
                    NSLog(@"administrative_area_level_1 : %@ ",[dict objectForKey:@"long_name"]);
                    NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"administrative_area_level_1\":\"%@\"",[dict objectForKey:@"long_name"]];
                    [testarray addObject:FullString];
                    //  break;
                }
                if([[dict objectForKey:@"types"] containsObject:@"locality"])
                {
                    NSLog(@"locality : %@ ",[dict objectForKey:@"long_name"]);
                    NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"locality\":\"%@\"",[dict objectForKey:@"long_name"]];
                    [testarray addObject:FullString];
                    //  break;
                }
                
            }
            NSLog(@"testarray is %@",testarray);
            NSString * result = [testarray componentsJoinedByString:@","];
            [address_componentsArray addObject:result];
        }
        NSLog(@"address_componentsArray is %@",address_componentsArray);
        NSString *Getlat;
        NSString *Getlng;
        for (NSDictionary *dict in locationData){
            Getlat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
            Getlng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
            [LatArray addObject:Getlat];
            [LongArray addObject:Getlng];
        }
        
        
        
        ShowTitle.text = @"Suggestions";
        
        NSLog(@"Getlat is %@",Getlat);
        NSLog(@"Getlng is %@",Getlng);
        
        [ShowActivity stopAnimating];
        
        [tblview reloadData];
        
        CheckTbl = 2;
    }else{
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        // NSLog(@"%@",res);
        
        NSString * formattedaddressData;
        NSString * result;
        NSArray *GetresultsData = (NSArray *)[res valueForKey:@"result"];
        NSLog(@"GetresultsData ===== %@",GetresultsData);
        NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
        NSLog(@"geometryData ===== %@",geometryData);
        NSDictionary *locationData = [geometryData valueForKey:@"location"];
        
        // for (NSDictionary *dict in GetresultsData){
        formattedaddressData = [GetresultsData valueForKey:@"formatted_address"];
        NSLog(@"formattedaddressData ===== %@",formattedaddressData);
        
        NSDictionary *address_componentsData = [GetresultsData valueForKey:@"address_components"];
        NSLog(@"address_componentsData is %@",address_componentsData);
        NSMutableArray *testarray = [[NSMutableArray alloc]init];
        for (NSDictionary *dict in address_componentsData) {
            if([[dict objectForKey:@"types"] containsObject:@"country"])
            {
                NSLog(@"country : %@ ",[dict objectForKey:@"long_name"]);
                NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"country\":\"%@\"",[dict objectForKey:@"long_name"]];
                [testarray addObject:FullString];
                //  break;
            }
            if([[dict objectForKey:@"types"] containsObject:@"route"])
            {
                NSLog(@"route : %@ ",[dict objectForKey:@"long_name"]);
                NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"route\":\"%@\"",[dict objectForKey:@"long_name"]];
                [testarray addObject:FullString];
                //  break;
            }
            if([[dict objectForKey:@"types"] containsObject:@"administrative_area_level_1"])
            {
                NSLog(@"administrative_area_level_1 : %@ ",[dict objectForKey:@"long_name"]);
                NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"administrative_area_level_1\":\"%@\"",[dict objectForKey:@"long_name"]];
                [testarray addObject:FullString];
                //  break;
            }
            if([[dict objectForKey:@"types"] containsObject:@"locality"])
            {
                NSLog(@"locality : %@ ",[dict objectForKey:@"long_name"]);
                NSString *FullString = [[NSString alloc]initWithFormat:@"\n   \"locality\":\"%@\"",[dict objectForKey:@"long_name"]];
                [testarray addObject:FullString];
                //  break;
            }
            
        }
        NSLog(@"testarray is %@",testarray);
        result = [testarray componentsJoinedByString:@","];
        // }
        NSString *Getlat;
        NSString *Getlng;
        NSString *Getplace_id;
        NSString *Getreference;
        //   for (NSDictionary *dict in locationData){
        Getlat = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
        Getlng = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
        Getplace_id = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"place_id"]];
        Getreference = [[NSString alloc]initWithFormat:@"%@",[GetresultsData valueForKey:@"reference"]];
        //  }
        
        
        NSArray *SplitArray = [result componentsSeparatedByString:@","];
        NSString * str = [SplitArray componentsJoinedByString:@","];
        NSLog(@"str is %@",str);
        
        NSString *CreateJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {%@\n  },\n  \"formatted_address\": \"%@\",\n  \"lat\": \"%@\",\n  \"lng\": \"%@\",\n  \"place_id\": \"%@\",\n  \"reference\": \"%@\",\n  \"type\": 2\n}",str,formattedaddressData,Getlat,Getlng,Getplace_id,Getreference];
        NSLog(@"CreateJsonString is %@",CreateJsonString);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      //  [defaults setObject:formattedaddressData forKey:@"Provisioning_LocationName"];
       // [defaults setObject:CreateJsonString forKey:@"Provisioning_FullJson"];
        [defaults setObject:formattedaddressData forKey:@"ChangeSearchLocation_Name"];
        [defaults setObject:Getlat forKey:@"ChangeSearchLocation_Lat"];
        [defaults setObject:Getlng forKey:@"ChangeSearchLocation_Long"];
        [defaults synchronize];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        //[self presentViewController:ListingDetail animated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [NameArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        UIImageView *ShowMapPin = [[UIImageView alloc]init];
        ShowMapPin.frame = CGRectMake(8, 12, 19, 22);
        ShowMapPin.image = [UIImage imageNamed:@"MiniMapPin.png"];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(30, 0, 280, 50);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"Avenir" size:15];
        ShowName.numberOfLines = 5;
        [cell addSubview:ShowMapPin];
        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
    ShowName.text = [NameArray objectAtIndex:indexPath.row];
    
    // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (CheckTbl == 1) {
        GetPlaceID = [[NSString alloc]initWithFormat:@"%@",[PlaceIDArray objectAtIndex:indexPath.row]];
        [self GetPlaceDetail];
    }else{
        NSLog(@"Click...");
        NSString *tempName = [[NSString alloc]initWithFormat:@"%@",[NameArray objectAtIndex:indexPath.row]];
        NSString *templat = [[NSString alloc]initWithFormat:@"%@",[LatArray objectAtIndex:indexPath.row]];
        NSString *templng = [[NSString alloc]initWithFormat:@"%@",[LongArray objectAtIndex:indexPath.row]];
        
        NSLog(@"tempName is %@",tempName);
        NSLog(@"templng is %@",templng);
        NSLog(@"templat is %@",templat);
        
        NSString *tempaddress_components = [[NSString alloc]initWithFormat:@"%@",[address_componentsArray objectAtIndex:indexPath.row]];
        NSArray *SplitArray = [tempaddress_components componentsSeparatedByString:@","];
        NSString * str = [SplitArray componentsJoinedByString:@","];
        NSLog(@"str is %@",str);
        
        NSString *CreateJsonString = [[NSString alloc]initWithFormat:@"{\n  \"address_components\":\n  {%@\n  },\n  \"formatted_address\": \"%@\",\n  \"lat\": \"%@\",\n  \"lng\": \"%@\",\n  \"type\": 2\n}",str,tempName,templat,templng];
        NSLog(@"CreateJsonString is %@",CreateJsonString);
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
       // [defaults setObject:tempName forKey:@"Provisioning_LocationName"];
       // [defaults setObject:CreateJsonString forKey:@"Provisioning_FullJson"];
        [defaults setObject:tempName forKey:@"ChangeSearchLocation_Name"];
        [defaults setObject:templat forKey:@"ChangeSearchLocation_Lat"];
        [defaults setObject:templng forKey:@"ChangeSearchLocation_Long"];

        [defaults synchronize];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        //[self presentViewController:ListingDetail animated:NO completion:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
    
    
    
    
    
    
}
-(void)GetPlaceDetail{
    //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ3WWMjifu0TERagGedoFyKgM&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyCFM5ytVF7QUtRiQm_E12vKVp01sl_f_xM",GetPlaceID];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_SearchPlace = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_SearchPlace start];
    
    
    if( theConnection_SearchPlace ){
        webData = [NSMutableData data];
    }
}
@end
