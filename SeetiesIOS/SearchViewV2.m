//
//  SearchViewV2.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/11/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "SearchViewV2.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchDetailViewController.h"

#import "LanguageManager.h"
#import "Locale.h"
#import "Constants.h"
@interface SearchViewV2 ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation SearchViewV2
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 124);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SearchBar.frame = CGRectMake(15, 70, screenWidth - 30, 44);
    SearchLocation.frame = CGRectMake(61, 69, screenWidth - 61 - 25, 45);
    EnterKeywordHere.frame = CGRectMake(61, 30, screenWidth - 61 - 15, 30);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    CategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
    NSMutableArray *GetNameArray;
    if ([GetSystemLanguage isEqualToString:@"English"]) {
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
    }else if([GetSystemLanguage isEqualToString:@"繁體中文"] || [GetSystemLanguage isEqualToString:@"Traditional Chinese"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Tw"]];
    }else if([GetSystemLanguage isEqualToString:@"简体中文"] || [GetSystemLanguage isEqualToString:@"Simplified Chinese"] || [GetSystemLanguage isEqualToString:@"中文"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Cn"]];
    }else if([GetSystemLanguage isEqualToString:@"Bahasa Indonesia"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_In"]];
    }else if([GetSystemLanguage isEqualToString:@"Filipino"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Fn"]];
    }else if([GetSystemLanguage isEqualToString:@"ภาษาไทย"] || [GetSystemLanguage isEqualToString:@"Thai"]){
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name_Th"]];
    }else{
        GetNameArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Name"]];
    }
    
    CategoryArray = [[NSMutableArray alloc]initWithArray:GetNameArray];
    BackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
    
    TitleLabel.text = CustomLocalisedString(@"Search", nil);
    ORADDACATEGORYBELOW.text = CustomLocalisedString(@"ORADDACATEGORYBELOW", nil);
    SUGGESTEDText.text = CustomLocalisedString(@"Suggestions", nil);
    SearchLocation.placeholder = CustomLocalisedString(@"Entersearchlocation", nil);
    EnterKeywordHere.placeholder = CustomLocalisedString(@"TypetoSearch", nil);
    
    SearchLocationNameArray = [[NSMutableArray alloc]init];
    SearchPlaceIDArray = [[NSMutableArray alloc]init];
    
    [SearchLocationNameArray addObject:CustomLocalisedString(@"Currentlocation",nil)];
    [SearchPlaceIDArray addObject:@"0"];

    SelectCategoryArray = [[NSMutableArray alloc]init];
    SelectBackgroundColorArray = [[NSMutableArray alloc]init];
    SelectCategoryIDArray = [[NSMutableArray alloc]init];
    
    MainScroll.delegate = self;
    SearchLocation.delegate = self;
    EnterKeywordHere.delegate = self;
    
    MainScroll.frame = CGRectMake(0, 124, screenWidth, screenHeight - 60);
    
    MainSearchButton.frame = CGRectMake(0, screenHeight - 60, screenWidth, 60);
    [MainSearchButton setTitle:CustomLocalisedString(@"SearchNearby", nil) forState:UIControlStateNormal];
    
    ShowSearchLocationView.frame = CGRectMake(0, 124, screenWidth, screenHeight - 60);
    ShowSearchLocationView.hidden = YES;
    [self.view addSubview:ShowSearchLocationView];
    
    ShowSearchTextOrPPLView.frame = CGRectMake(0, 200, screenWidth, screenHeight - 50);
    ShowSearchTextOrPPLView.hidden = YES;
    [self.view addSubview:ShowSearchTextOrPPLView];
    
    SuggestionTblView.frame = CGRectMake(0, 0, screenWidth, screenHeight - 50);
    
    Line01.frame = CGRectMake(15, 85, screenWidth - 30, 2);
    ORADDACATEGORYBELOW.frame = CGRectMake(15, 104, screenWidth - 30, 21);
    
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
    
    [self InitView];
    
    LocalSuggestionTextArray = [[NSMutableArray alloc]init];
    [LocalSuggestionTextArray addObject:@"Coffee"];
    [LocalSuggestionTextArray addObject:@"Pizza"];
    [LocalSuggestionTextArray addObject:@"Night Club"];
    [LocalSuggestionTextArray addObject:@"Sushi"];
    [LocalSuggestionTextArray addObject:@"Museum"];
    [LocalSuggestionTextArray addObject:@"Hiking"];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Search v2 Page";
   


}
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
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
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
        
        NSLog(@"Location Get lat is %@ : lon is %@",GetLat, GetLang);
        if ([GetLat length] == 0 || [GetLat isEqualToString:@"(null)"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *GetLat_ = [defaults objectForKey:@"GetLat"];
            NSString *GetLon_ = [defaults objectForKey:@"GetLang"];
            GetLat = GetLat_;
            GetLang = GetLon_;
            
            
        }
        
        [self performSearchLatnLong];
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
    }else{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *GetLat_ = [defaults objectForKey:@"GetLat"];
        NSString *GetLon_ = [defaults objectForKey:@"GetLang"];
        GetLat = GetLat_;
        GetLang = GetLon_;
        [self performSearchLatnLong];
    }
}
-(void)performSearchLatnLong{
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",GetLat,GetLang];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetLocation = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetLocation start];
    
    
    if( theConnection_GetLocation ){
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
    if (connection == theConnection_GetLocation) {
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
                NSArray *GetresultsData = (NSArray *)[res valueForKey:@"results"];
                // NSLog(@"GetresultsData ===== %@",GetresultsData);
                
                LocationNameArray = [[NSMutableArray alloc]init];
                LocationLatArray = [[NSMutableArray alloc]init];
                LocationLongArray = [[NSMutableArray alloc]init];
                
                NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
                NSLog(@"geometryData ===== %@",geometryData);
                NSDictionary *locationData = [geometryData valueForKey:@"location"];
                
                for (NSDictionary *dict in GetresultsData){
                    NSString * formattedaddressData = [dict valueForKey:@"formatted_address"];
                    NSLog(@"formattedaddressData ===== %@",formattedaddressData);
                    [LocationNameArray addObject:formattedaddressData];
                }
                NSString *Getlat;
                NSString *Getlng;
                for (NSDictionary *dict in locationData){
                    Getlat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
                    Getlng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
                    [LocationLatArray addObject:Getlat];
                    [LocationLongArray addObject:Getlng];
                }
                
//                if ([LocationNameArray count] < 3) {
//                    GetLocationName = [LocationNameArray objectAtIndex:0];
//                    SearchLocation.text = [LocationNameArray objectAtIndex:0];

//                }else{
//                    
//                    NSInteger GetCount = [LocationNameArray count];
//                    
//                    GetLocationName = [LocationNameArray objectAtIndex:GetCount - 3];
//                    SearchLocation.text = [LocationNameArray objectAtIndex:GetCount - 3];
//                    GetLat = [LocationLatArray objectAtIndex:GetCount - 3];
//                    GetLang = [LocationLongArray objectAtIndex:GetCount - 3];
//                }
                
                SearchLocation.text = CustomLocalisedString(@"Currentlocation", nil);
                GetLat = [LocationLatArray objectAtIndex:0];
                GetLang = [LocationLongArray objectAtIndex:0];

            }
        }
        
       
    }else if(connection == theConnection_SearchLocation){
        [SearchLocationNameArray removeAllObjects];
        [SearchPlaceIDArray removeAllObjects];
        
        [SearchLocationNameArray addObject:CustomLocalisedString(@"Currentlocation",nil)];
        [SearchPlaceIDArray addObject:@"0"];
        
        
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        // NSLog(@"%@",res);
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Json Error." message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetpredictionsData = (NSArray *)[res valueForKey:@"predictions"];
                
                // ReferenceArray = [[NSMutableArray alloc]init];
                for (NSDictionary *dict in GetpredictionsData){
                    NSString * formattedaddressData = [dict valueForKey:@"description"];
                    NSLog(@"formattedaddressData ===== %@",formattedaddressData);
                    [SearchLocationNameArray addObject:formattedaddressData];
                    NSString * place_id = [dict valueForKey:@"place_id"];
                    [SearchPlaceIDArray addObject:place_id];
                    //            NSString * reference = [dict valueForKey:@"reference"];
                    //            [ReferenceArray addObject:reference];
                }
                NSLog(@"SearchLocationNameArray is %@",SearchLocationNameArray);
                NSLog(@"SearchPlaceIDArray is %@",SearchPlaceIDArray);
                [LocationTblView reloadData];
            }
        }
        
        
    }else if(connection == theConnection_GetSearchPlace){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
       //  NSLog(@"%@",res);
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Server Error." message:GetData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSLog(@"Server Work.");
            
            NSString *ErrorString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"error"]];
            NSLog(@"ErrorString is %@",ErrorString);
            NSString *MessageString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"message"]];
            NSLog(@"MessageString is %@",MessageString);
            
            if ([ErrorString isEqualToString:@"0"] || [ErrorString isEqualToString:@"401"]) {
                UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"Json Error." message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                ShowAlert.tag = 1000;
                [ShowAlert show];
                // send user back login screen.
            }else{
                NSArray *GetresultsData = (NSArray *)[res valueForKey:@"result"];
                NSLog(@"GetresultsData ===== %@",GetresultsData);
                NSDictionary *geometryData = [GetresultsData valueForKey:@"geometry"];
                NSLog(@"geometryData ===== %@",geometryData);
                NSDictionary *locationData = [geometryData valueForKey:@"location"];
                
                NSString *formattedaddressData = [GetresultsData valueForKey:@"formatted_address"];
                NSLog(@"formattedaddressData ===== %@",formattedaddressData);
                
                NSString *Getlat_;
                NSString *Getlng_;
                
                Getlat_ = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lat"]];
                Getlng_ = [[NSString alloc]initWithFormat:@"%@",[locationData valueForKey:@"lng"]];
                
                NSLog(@"formattedaddressData is %@",formattedaddressData);
                NSLog(@"Getlat is %@",Getlat_);
                NSLog(@"Getlng is %@",Getlng_);
                
                GetLocationName = formattedaddressData;
                SearchLocation.text = formattedaddressData;
                GetLat = Getlat_;
                GetLang = Getlng_;
                
                [SearchLocation resignFirstResponder];
                [EnterKeywordHere resignFirstResponder];
                MainScroll.hidden = NO;
                ShowSearchLocationView.hidden = YES;
               // [MainSearchButton setTitle:CustomLocalisedString(@"Search", nil) forState:UIControlStateNormal];
            }
        }
        

    }else if(connection == theConnection_GetSearchString){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        NSArray *GetStringData = (NSArray *)[res valueForKey:@"result"];
        NSLog(@"GetStringData is %@",GetStringData);
        
        [LocalSuggestionTextArray removeAllObjects];
        
        LocalSuggestionTextArray = [[NSMutableArray alloc]initWithArray:GetStringData];
        NSLog(@"LocalSuggestionTextArray is %@",LocalSuggestionTextArray);
        [SuggestionTblView reloadData];
    }
    
    
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // [self.view endEditing:YES];// this will do the trick
    [SearchLocation resignFirstResponder];
    [EnterKeywordHere resignFirstResponder];
    MainScroll.hidden = NO;
    ShowSearchLocationView.hidden = YES;
    ShowSearchTextOrPPLView.hidden = YES;
    if ([SearchLocation.text length] == 0) {
        SearchLocation.text = GetLocationName;
    }

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
 
    if (textField == SearchLocation) {
        MainScroll.hidden = YES;
        ShowSearchLocationView.hidden = NO;
        ShowSearchTextOrPPLView.hidden = YES;
        [LocationTblView reloadData];
    }else if(textField == EnterKeywordHere){
        ShowSearchTextOrPPLView.hidden = NO;
       // MainScroll.hidden = YES;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == SearchLocation) {
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSLog(@"newString is %@",newString);
        NSLog(@"found");
        if ([newString length] > 2) {
            NSLog(@"Check server");
            [self performSearch];
            //  [ShowActivity startAnimating];
            // [NSThread detachNewThreadSelector:@selector(SendMentionsToServer) toTarget:self withObject:nil];
        }else{
            
        }
    }else if(textField == EnterKeywordHere){
        SearchString = [textField.text stringByReplacingCharactersInRange:range withString:string];
      // [ShowSearchPPLText setText:newString];
        if ([SearchString length] > 2) {
            //start search
            [self SearchTextInServer];
        }
    }

    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    NSLog(@"work here?");
    if (theTextField == SearchLocation) {
        [SearchLocation resignFirstResponder];
        if ([SearchLocation.text length] == 0) {
            SearchLocation.text = GetLocationName;
            MainScroll.hidden = NO;
            ShowSearchLocationView.hidden = YES;
        }else{
            if ([GetLocationName isEqualToString:SearchLocation.text]) {
                MainScroll.hidden = NO;
                ShowSearchLocationView.hidden = YES;
                
            }else{
                [self performSearch];
            }
        }

    }else if(theTextField == EnterKeywordHere){
        [EnterKeywordHere resignFirstResponder];
        if ([EnterKeywordHere.text length] == 0) {
            ShowSearchTextOrPPLView.hidden = YES;
        }else{
            SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
            CATransition *transition = [CATransition animation];
            transition.duration = 0.2;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            [self presentViewController:SearchDetailView animated:NO completion:nil];
            [SearchDetailView GetSearchKeyword:EnterKeywordHere.text Getlat:GetLat GetLong:GetLang];
            [SearchDetailView GetTitle:@"Results"];
        }
    }

   // [ShowActivity startAnimating];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)InitView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
//use uilabel to load text, button load uilabel width and height
    for (int i = 0; i < [CategoryArray count]; i++) {
        UIButton *CategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [CategoryButton setTitle:@"" forState:UIControlStateNormal];
        [CategoryButton setFrame:CGRectMake((screenWidth/2)-151 + (i % 2)* 157, 142 + (44 * (CGFloat)(i /2)),151, 38)];
        NSString *BackgroundColor = [[NSString alloc]initWithFormat:@"%@",[BackgroundColorArray objectAtIndex:i]];
        
        NSUInteger red, green, blue;
        sscanf([BackgroundColor UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        [CategoryButton setBackgroundColor:color];
        CategoryButton.tag = i;
        [CategoryButton addTarget:self action:@selector(CategoryButtonSelect:) forControlEvents:UIControlEventTouchUpInside];

        [MainScroll addSubview:CategoryButton];
        
        UILabel *Showtitle = [[UILabel alloc]init];
        Showtitle.text = [CategoryArray objectAtIndex:i];
        Showtitle.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        Showtitle.textColor = [UIColor whiteColor];
        Showtitle.frame = CGRectMake((screenWidth/2)-146 + (i % 2)* 157, 142 + (44 * (CGFloat)(i /2)),131, 38);
        Showtitle.textAlignment = NSTextAlignmentLeft;
        Showtitle.adjustsFontSizeToFitWidth = YES;
        [MainScroll addSubview:Showtitle];
        
        UILabel *ShowPlus = [[UILabel alloc]init];
        ShowPlus.text = @"+";
        ShowPlus.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        ShowPlus.textColor = [UIColor whiteColor];
        ShowPlus.frame = CGRectMake((screenWidth/2)-15 + (i % 2)* 157, 142 + (44 * (CGFloat)(i /2)),10, 38);
        ShowPlus.textAlignment = NSTextAlignmentRight;
        [MainScroll addSubview:ShowPlus];
    }
    


    
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll setContentSize:CGSizeMake(screenWidth, 440)];
}
-(void)InitSelectDataView{
     CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    for (UIView *subview in MainScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    if ([SelectCategoryArray count] == 0) {
        SearchIcon.hidden = NO;
        EnterKeywordHere.hidden = NO;
    }else{
        SearchIcon.hidden = YES;
        EnterKeywordHere.hidden = YES;
    }
    
    CGRect ButtonHeight;
    float GetHeight = 0.0;
    for (int i = 0; i < [SelectCategoryArray count]; i++) {
        UIButton *CategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [CategoryButton setTitle:@"" forState:UIControlStateNormal];
        ButtonHeight = CategoryButton.frame;
        [CategoryButton setFrame:CGRectMake((screenWidth/2)-151 + (i % 2)* 157, 20 + (44 * (CGFloat)(i /2)),151, 38)];
        
        NSString *BackgroundColor = [[NSString alloc]initWithFormat:@"%@",[SelectBackgroundColorArray objectAtIndex:i]];
        
        NSUInteger red, green, blue;
        sscanf([BackgroundColor UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        [CategoryButton setBackgroundColor:color];
        CategoryButton.tag = i;
        [CategoryButton addTarget:self action:@selector(CategoryButtonUnSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        GetHeight = 20 + (40 * (CGFloat)(i /2));
        [MainScroll addSubview:CategoryButton];
        
        UILabel *Showtitle = [[UILabel alloc]init];
        Showtitle.text = [SelectCategoryArray objectAtIndex:i];
        Showtitle.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        Showtitle.textColor = [UIColor whiteColor];
        Showtitle.frame = CGRectMake((screenWidth/2)-146 + (i % 2)* 157, 20 + (44 * (CGFloat)(i /2)),131, 38);
        Showtitle.textAlignment = NSTextAlignmentLeft;
        Showtitle.adjustsFontSizeToFitWidth = YES;
        [MainScroll addSubview:Showtitle];
        
        UILabel *ShowPlus = [[UILabel alloc]init];
        ShowPlus.text = @"-";
        ShowPlus.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        ShowPlus.textColor = [UIColor whiteColor];
        ShowPlus.frame = CGRectMake((screenWidth/2)-15 + (i % 2)* 157, 20 + (44 * (CGFloat)(i /2)),10, 38);
        ShowPlus.textAlignment = NSTextAlignmentRight;
        [MainScroll addSubview:ShowPlus];
    }
    
    Line01.frame = CGRectMake(15, GetHeight + 65, screenWidth - 30, 2);
    ORADDACATEGORYBELOW.frame = CGRectMake(15, GetHeight + 84, screenWidth - 30, 21);
     CGRect ButtonOther;
    for (int i = 0; i < [CategoryArray count]; i++) {
        UIButton *CategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [CategoryButton setTitle:@"" forState:UIControlStateNormal];
        ButtonOther = CategoryButton.frame;
        [CategoryButton setFrame:CGRectMake((screenWidth/2)-151 +(i % 2)* 157, (GetHeight + 142) + (44 * (CGFloat)(i /2)),151, 38)];
        
        NSString *BackgroundColor = [[NSString alloc]initWithFormat:@"%@",[BackgroundColorArray objectAtIndex:i]];
        
        NSUInteger red, green, blue;
        sscanf([BackgroundColor UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        [CategoryButton setBackgroundColor:color];
        CategoryButton.tag = i;
        [CategoryButton addTarget:self action:@selector(CategoryButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        [MainScroll addSubview:CategoryButton];
        
        
        UILabel *Showtitle = [[UILabel alloc]init];
        Showtitle.text = [CategoryArray objectAtIndex:i];
        Showtitle.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        Showtitle.textColor = [UIColor whiteColor];
        Showtitle.frame = CGRectMake((screenWidth/2)-146 + (i % 2)* 157, (GetHeight + 142) + (44 * (CGFloat)(i /2)),131, 38);
        Showtitle.textAlignment = NSTextAlignmentLeft;
        Showtitle.adjustsFontSizeToFitWidth = YES;
        [MainScroll addSubview:Showtitle];
        
        UILabel *ShowPlus = [[UILabel alloc]init];
        ShowPlus.text = @"+";
        ShowPlus.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        ShowPlus.textColor = [UIColor whiteColor];
        ShowPlus.frame = CGRectMake((screenWidth/2)-15 + (i % 2)* 157, (GetHeight + 142) + (44 * (CGFloat)(i /2)),10, 38);
        ShowPlus.textAlignment = NSTextAlignmentRight;
        [MainScroll addSubview:ShowPlus];
    }
    
    [MainScroll addSubview:SearchIcon];
    [MainScroll addSubview:EnterKeywordHere];
    [MainScroll addSubview:Line01];
    [MainScroll addSubview:ORADDACATEGORYBELOW];
    
    if ([CategoryArray count] == 0) {
        Line01.hidden = YES;
        ORADDACATEGORYBELOW.hidden =YES;
    }else{
        Line01.hidden = NO;
        ORADDACATEGORYBELOW.hidden =NO;
    }
    
    [MainScroll setScrollEnabled:YES];
    MainScroll.backgroundColor = [UIColor whiteColor];
    [MainScroll setContentSize:CGSizeMake(320, 440)];
}
-(IBAction)CategoryButtonSelect:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSString *GetSelectCategory = [[NSString alloc]initWithFormat:@"%@",[CategoryArray objectAtIndex:getbuttonIDN]];
    NSString *GetSelectCategoryBackgroundColor = [[NSString alloc]initWithFormat:@"%@",[BackgroundColorArray objectAtIndex:getbuttonIDN]];
    NSString *GetSelectCategoryIDN = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:getbuttonIDN]];
    
    [SelectCategoryArray addObject:GetSelectCategory];
    [SelectBackgroundColorArray addObject:GetSelectCategoryBackgroundColor];
    [SelectCategoryIDArray addObject:GetSelectCategoryIDN];
    
    [CategoryArray removeObjectAtIndex:getbuttonIDN];
    [BackgroundColorArray removeObjectAtIndex:getbuttonIDN];
    [CategoryIDArray removeObjectAtIndex:getbuttonIDN];
    
    SearchIcon.hidden = YES;
    EnterKeywordHere.hidden = YES;
    
    NSLog(@"CategoryArray is %@",CategoryArray);
    NSLog(@"BackgroundColorArray is %@",BackgroundColorArray);
    NSLog(@"CategoryIDArray is %@",CategoryIDArray);
    
    NSLog(@"SelectCategoryArray is %@",SelectCategoryArray);
    NSLog(@"SelectBackgroundColorArray is %@",SelectBackgroundColorArray);
    NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
    
    [self InitSelectDataView];
}
-(IBAction)CategoryButtonUnSelect:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"button %li",(long)getbuttonIDN);
    
    NSString *GetSelectCategory = [[NSString alloc]initWithFormat:@"%@",[SelectCategoryArray objectAtIndex:getbuttonIDN]];
    NSString *GetSelectCategoryBackgroundColor = [[NSString alloc]initWithFormat:@"%@",[SelectBackgroundColorArray objectAtIndex:getbuttonIDN]];
    NSString *GetSelectCategoryIDN = [[NSString alloc]initWithFormat:@"%@",[SelectCategoryIDArray objectAtIndex:getbuttonIDN]];
    
    [CategoryArray addObject:GetSelectCategory];
    [BackgroundColorArray addObject:GetSelectCategoryBackgroundColor];
    [CategoryIDArray addObject:GetSelectCategoryIDN];
    
    [SelectCategoryArray removeObjectAtIndex:getbuttonIDN];
    [SelectBackgroundColorArray removeObjectAtIndex:getbuttonIDN];
    [SelectCategoryIDArray removeObjectAtIndex:getbuttonIDN];
    
    SearchIcon.hidden = YES;
    EnterKeywordHere.hidden = YES;
    
    
    NSLog(@"CategoryArray is %@",CategoryArray);
    NSLog(@"BackgroundColorArray is %@",BackgroundColorArray);
    NSLog(@"CategoryIDArray is %@",CategoryIDArray);
    
    NSLog(@"SelectCategoryArray is %@",SelectCategoryArray);
    NSLog(@"SelectBackgroundColorArray is %@",SelectBackgroundColorArray);
    NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
    
    [self InitSelectDataView];
}
-(void)performSearch{
    
    NSString *originalString = SearchLocation.text;
    NSString *replaced = [originalString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSLog(@"replaced is %@",replaced);
   // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&radius=500&sensor=false&types=geocode&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8",replaced];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == LocationTblView) {
        return [SearchLocationNameArray count];
    }else{
        return [LocalSuggestionTextArray count];
    }
    
  //  return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(15, 0, 290, 50);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 100;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        ShowName.numberOfLines = 5;

        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (tableView == LocationTblView) {
        UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
        ShowName.text = [SearchLocationNameArray objectAtIndex:indexPath.row];
    }else{
        UILabel *ShowName = (UILabel *)[cell viewWithTag:100];
        ShowName.text = [LocalSuggestionTextArray objectAtIndex:indexPath.row];
    }
    

    
    // cell.textLabel.text = [NameArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == LocationTblView) {
        if (indexPath.row == 0) {
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
            
            MainScroll.hidden = NO;
            ShowSearchLocationView.hidden = YES;
            [SearchLocation resignFirstResponder];
        }else{
            GetSearchPlaceID = [SearchPlaceIDArray objectAtIndex:indexPath.row];
            NSLog(@"GetSearchPlaceID is %@",GetSearchPlaceID);
            [self GetPlaceDetail];
        }
    }else{
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
        [SearchDetailView GetSearchKeyword:[LocalSuggestionTextArray objectAtIndex:indexPath.row] Getlat:GetLat GetLong:GetLang];
        [SearchDetailView GetTitle:@"Results"];
    
    }
    NSLog(@"Click...");


    
}
-(void)GetPlaceDetail{
    //https://maps.googleapis.com/maps/api/place/details/json?placeid=ChIJ3WWMjifu0TERagGedoFyKgM&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?placeid=%@&key=AIzaSyChnTBSAm0k30WSCjlV-29tBi8eCFRptq8",GetSearchPlaceID];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetSearchPlace = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetSearchPlace start];
    
    
    if( theConnection_GetSearchPlace ){
        webData = [NSMutableData data];
    }
}
-(IBAction)MainSearchButton:(id)sender{
    
    NSLog(@"CategoryArray is %@",CategoryArray);
    NSLog(@"BackgroundColorArray is %@",BackgroundColorArray);
    NSLog(@"CategoryIDArray is %@",CategoryIDArray);
    
    NSLog(@"SelectCategoryArray is %@",SelectCategoryArray);
    NSLog(@"SelectBackgroundColorArray is %@",SelectBackgroundColorArray);
    NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
    
    if ([SelectCategoryArray count] == 0 || SelectCategoryArray == nil) {
        NSString *JoinAllCategoryID = [CategoryIDArray componentsJoinedByString:@","];
        NSString *JoinAllCategoryName = [CategoryArray componentsJoinedByString:@","];

        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
        [SearchDetailView SearchCategory:JoinAllCategoryID Getlat:GetLat GetLong:GetLang GetCategoryName:JoinAllCategoryName];
        [SearchDetailView GetTitle:@"Results"];
    }else{
        NSString *JoinAllCategoryID = [SelectCategoryIDArray componentsJoinedByString:@","];
        NSString *JoinAllCategoryName = [SelectCategoryArray componentsJoinedByString:@","];
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
        [SearchDetailView SearchCategory:JoinAllCategoryID Getlat:GetLat GetLong:GetLang GetCategoryName:JoinAllCategoryName];
        [SearchDetailView GetTitle:@"Results"];
    }
    

}
-(void)SearchTextInServer{
    // NSString *FullString = [[NSString alloc]initWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:MY&key=AIzaSyDOH-6gH-anGu-AEOI3KX7_n5WLkz2gg-c",replaced];
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@/tags/%@",DataUrl.UserWallpaper_Url,SearchString];
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    theConnection_GetSearchString = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_GetSearchString start];
    
    
    if( theConnection_GetSearchString ){
        webData = [NSMutableData data];
    }
}
//-(IBAction)SearchPPLButton:(id)sender{
//    NSLog(@"SearchPPLButton click.");
//    if ([EnterKeywordHere.text length] == 0) {
//        
//    }else{
//        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.2;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        [self.view.window.layer addAnimation:transition forKey:nil];
//        [self presentViewController:SearchDetailView animated:NO completion:nil];
//        [SearchDetailView GetExpertsSearchKeyword:EnterKeywordHere.text];
//        [SearchDetailView GetTitle:@"Find People"];
//    }
//    
//}
@end
