//
//  SearchViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/15/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchChangeLocationViewController.h"
#import "SearchDetailViewController.h"
#import <CoreLocation/CoreLocation.h>

#import "LanguageManager.h"
#import "Locale.h"

@interface SearchViewController ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation SearchViewController
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tblview.frame = CGRectMake(10, 210, 300, [UIScreen mainScreen].bounds.size.height - 210);
    
    CategoryNameArray = [[NSMutableArray alloc]init];
    CategoryImageArray = [[NSMutableArray alloc]init];
    IDNArray = [[NSMutableArray alloc]init];
    [IDNArray addObject:@"6"];
    [IDNArray addObject:@"9"];
    [IDNArray addObject:@"12"];
    [IDNArray addObject:@"15"];
    [IDNArray addObject:@"13"];
    [IDNArray addObject:@"1"];
    [IDNArray addObject:@"2"];
    [IDNArray addObject:@"14"];
    [IDNArray addObject:@"11"];
    
    [CategoryNameArray addObject:CustomLocalisedString(@"Food",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Outdoor",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Culture",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Staycation",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Nightlife",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Art",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Beauty",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Product",nil)];
    [CategoryNameArray addObject:CustomLocalisedString(@"Kitchen",nil)];
    
    [CategoryImageArray addObject:@"Icon_Food&Drink.png"];
    [CategoryImageArray addObject:@"Icon_Outdoor&Sport.png"];
    [CategoryImageArray addObject:@"Icon_Culture&Attraction.png"];
    [CategoryImageArray addObject:@"Icon_Staycation.png"];
    [CategoryImageArray addObject:@"Icon_Nightlife.png"];
    [CategoryImageArray addObject:@"Icon_Art&Entertainment.png"];
    [CategoryImageArray addObject:@"Icon_Beauty&Fashion.png"];
    [CategoryImageArray addObject:@"Icon_Product.png"];
    [CategoryImageArray addObject:@"Icon_KitchenRecipe.png"];
    
    SearchText.delegate = self;
    
    Show2ndView.frame = CGRectMake(0, 0, 320, 568);
    Show2ndView.hidden = YES;
    //[self.view addSubview:Show2ndView];
    
    SearchText.placeholder = CustomLocalisedString(@"Recommendationsorpeople", nil);
    TitleLabel.text = CustomLocalisedString(@"Search", nil);//Provisioning_PTellUsYourCityView_5
    ShowLocationText.text = CustomLocalisedString(@"Provisioning_PTellUsYourCityView_5", nil);
    ShowPPLText.text = CustomLocalisedString(@"People", nil);
    ShowSearchTitle.text = CustomLocalisedString(@"ORSEARCHBYCATEGORY", nil);
    FindPPLName.text = CustomLocalisedString(@"FindPeopleName", nil);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   // [self.view endEditing:YES];// this will do the trick
    [SearchText resignFirstResponder];
    Show2ndView.hidden = YES;
    tblview.hidden = NO;
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 //   self.screenName = @"IOS Search Page";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetLocation = [defaults objectForKey:@"SearchPage_Location_Name"];
    GetLat = [defaults objectForKey:@"SearchPage_Location_Lat"];
    GetLang = [defaults objectForKey:@"SearchPage_Location_Long"];
    NSLog(@"GetLat is %@",GetLat);
    
    if ([GetLocation length] == 0) {
        
    }else{
        ShowLocationText.text = GetLocation;
    }
    
    if ([GetLat length] == 0 || [GetLat isEqualToString:@"(null)"]) {
        NSLog(@"get location again");
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
                    [self.locationManager startUpdatingLocation];
                } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    [self.locationManager  requestWhenInUseAuthorization];
                    [self.locationManager startUpdatingLocation];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
            }
        }
        [self.locationManager startUpdatingLocation];
    }else{
    }
}
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = [locations lastObject];
//    
//    GetLat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
//    GetLang = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
//    
//    NSLog(@"lat is %@ : lon is %@",GetLat, GetLang);
//    //Now you know the location has been found, do other things, call others methods here
//    [self.locationManager stopUpdatingLocation];
//
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
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        GetLat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        GetLang = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        
        NSLog(@"lat is %@ : lon is %@",GetLat, GetLang);
        if ([GetLat length] == 0 || [GetLat isEqualToString:@"(null)"]) {
            [self GetIpAddress];
        }
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetLat_ = [defaults objectForKey:@"GetLat"];
        NSString *GetLon_ = [defaults objectForKey:@"GetLang"];
        NSLog(@"GetLat_ is %@",GetLat_);
        GetLat = GetLat_;
        GetLang = GetLon_;
        NSLog(@"GetLat is %@",GetLat);
        
    }
}
//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    
//    NSLog(@"%@",error.userInfo);
//    if([CLLocationManager locationServicesEnabled]){
//        
//        NSLog(@"Location Services Enabled");
//        
//        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
//            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
//                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
//                                                              delegate:nil
//                                                     cancelButtonTitle:@"OK"
//                                                     otherButtonTitles:nil];
//            [alert show];
//            
//            
//        }
//
//    }
//}
-(void)GetIpAddress{
    NSLog(@"GetIpAddress work ?");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *ExternalIPAddress = [defaults objectForKey:@"ExternalIPAddress"];
//https://geoip.seeties.me/geoip/index.php?ip=123.123.123.123
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://geoip.seeties.me/geoip/index.php?ip=%@",ExternalIPAddress];
    
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    // NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:postBack];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    
    theConnection_GetIPAddress = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetIPAddress start];
    
    
    if( theConnection_GetIPAddress ){
        webData = [NSMutableData data];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)BackButton:(id)sender{
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    //[self presentViewController:ListingDetail animated:NO completion:nil];
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)ChangeSearchLocationButton:(id)sender{
    SearchChangeLocationViewController *SearchChangeLocationView = [[SearchChangeLocationViewController alloc]init];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:SearchChangeLocationView animated:NO completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CategoryNameArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        UIImageView *ShowCategoryImage = [[UIImageView alloc]init];
        ShowCategoryImage.frame = CGRectMake(1, 9, 35, 35);
        ShowCategoryImage.tag = 101;
        //ShowCategoryImage.image = [UIImage imageNamed:@"MiniMapPin.png"];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(50, 0, 270, 53);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        [cell addSubview:ShowCategoryImage];
        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
    ShowName.text = [CategoryNameArray objectAtIndex:indexPath.row];
    
    UIImageView *ShowCategoryImage = (UIImageView *)[cell viewWithTag:101];
   // ShowCategoryImage.text = [CategoryImageArray objectAtIndex:indexPath.row];
    ShowCategoryImage.image = [UIImage imageNamed:[CategoryImageArray objectAtIndex:indexPath.row]];
    
    // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSLog(@"Click...");
//    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionPush;
//    transition.subtype = kCATransitionFromRight;
//    [self.view.window.layer addAnimation:transition forKey:nil];
//    [self presentViewController:SearchDetailView animated:NO completion:nil];
//    [SearchDetailView SearchCategory:[IDNArray objectAtIndex:indexPath.row] Getlat:GetLat GetLong:GetLang];
//    [SearchDetailView GetTitle:@"Results"];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateTextLabelsWithText: newString];
    
    return YES;
}

-(void)updateTextLabelsWithText:(NSString *)string
{
    
    [ShowSearchPPLText setText:string];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    tblview.hidden = YES;
    Show2ndView.hidden = NO;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
    [textField resignFirstResponder];

    
    if ([SearchText.text length] == 0) {
        tblview.hidden = NO;
        Show2ndView.hidden = YES;
    }else{
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
       // [SearchDetailView GetSearchKeyword:SearchText.text Getlat:GetLat GetLong:GetLang];
        [SearchDetailView GetTitle:@"Results"];
    }
    
    

    return YES;
}
-(IBAction)SearchPPLButton:(id)sender{
    NSLog(@"SearchPPLButton click.");
    if ([SearchText.text length] == 0) {
        
    }else{
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
       // [SearchDetailView GetExpertsSearchKeyword:SearchText.text];
        [SearchDetailView GetTitle:@"Find People"];
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
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Connection" message:@"Check your wifi or 3G data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    
//    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"IpAddress return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Feed Json = %@",res);
    
    GetLat = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"latitude"]];
    NSLog(@"GetLat is %@",GetLat);
    
    GetLang = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"longitude"]];
    NSLog(@"GetLang is %@",GetLang);
    
    
}

@end
