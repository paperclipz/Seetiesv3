//
//  SearchChangeLocationViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/15/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SearchChangeLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"

@interface SearchChangeLocationViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation SearchChangeLocationViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SearchLocationField.delegate = self;
     tblview.frame = CGRectMake(0, 203, 320, [UIScreen mainScreen].bounds.size.height - 203);
    
    [CurrentLocationButton setTitle:CustomLocalisedString(@"Currentlocation", nil) forState:UIControlStateNormal];
    ShowTitle.text = CustomLocalisedString(@"Changesearchlocation", nil);
    SubTitle.text = CustomLocalisedString(@"SEARCHHISTORY", nil);
    SearchLocationField.placeholder = CustomLocalisedString(@"searchlocation", nil);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Search Change Location Page";
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
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"work here?");
    [SearchLocationField resignFirstResponder];
    [self performSearch];
    [ShowActivity startAnimating];
    return YES;
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
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",latPoint,lonPoint];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLConnection *theConnection_SearchLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_SearchLocation start];
    
    
    if( theConnection_SearchLocation ){
        webData = [NSMutableData data];
    }
}
-(void)performSearch{
    
    NSString *originalString = SearchLocationField.text;
    NSString *replaced = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"replaced is %@",replaced);
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLConnection *theConnection_SearchLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
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
    }
    NSString *Getlat;
    NSString *Getlng;
    for (NSDictionary *dict in locationData){
        Getlat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
        Getlng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
        [LatArray addObject:Getlat];
        [LongArray addObject:Getlng];
    }
    
    
    
    ShowTitle.text = @"SUGGESTIONS";
    
    NSLog(@"Getlat is %@",Getlat);
    NSLog(@"Getlng is %@",Getlng);
    
    [ShowActivity stopAnimating];
    
    [tblview reloadData];
    
    
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
        ShowMapPin.frame = CGRectMake(12, 17, 19, 22);
        ShowMapPin.image = [UIImage imageNamed:@"MiniMapPin.png"];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(47, 0, 280, 50);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
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
    
    NSLog(@"Click...");
    NSString *tempName = [[NSString alloc]initWithFormat:@"%@",[NameArray objectAtIndex:indexPath.row]];
    NSString *templat = [[NSString alloc]initWithFormat:@"%@",[LatArray objectAtIndex:indexPath.row]];
    NSString *templng = [[NSString alloc]initWithFormat:@"%@",[LongArray objectAtIndex:indexPath.row]];
    
    NSLog(@"tempName is %@",tempName);
    NSLog(@"templng is %@",templng);
    NSLog(@"templat is %@",templat);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:tempName forKey:@"SearchPage_Location_Name"];
    [defaults setObject:templat forKey:@"SearchPage_Location_Lat"];
    [defaults setObject:templng forKey:@"SearchPage_Location_Long"];
    [defaults synchronize];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    //    //[self presentViewController:ListingDetail animated:NO completion:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
@end
