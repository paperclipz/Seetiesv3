//
//  SearchViewV2Controller.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "SearchViewV2Controller.h"
#import "LanguageManager.h"
#import "Locale.h"
#import "SearchDetailViewController.h"
#import "SearchResultV2ViewController.h"
@interface SearchViewV2Controller ()<CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

@implementation SearchViewV2Controller
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    mySearchBar.delegate = self;
    [mySearchBar setTintColor:[UIColor whiteColor]];
   // mySearchBar.tintColor = [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    mySearchBar.barTintColor = [UIColor clearColor];
    [mySearchBar setBackgroundImage:[[UIImage alloc]init]];
    mySearchBar.placeholder = LocalisedString(@"Search");
    [mySearchBar becomeFirstResponder];
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    Tblview.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 216);
    SearchScroll.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 216);
    SearchScroll.hidden = YES;
    
    LocalSearchTextArray = [[NSMutableArray alloc]init];
    [LocalSearchTextArray addObject:LocalisedString(@"Hiking")];
    [LocalSearchTextArray addObject:LocalisedString(@"Museum")];
    [LocalSearchTextArray addObject:LocalisedString(@"Sushi")];
    [LocalSearchTextArray addObject:LocalisedString(@"Night Club")];
    [LocalSearchTextArray addObject:LocalisedString(@"Pizza")];
    [LocalSearchTextArray addObject:LocalisedString(@"Coffee")];
    
    NSArray *ReveresdArray = [[LocalSearchTextArray reverseObjectEnumerator] allObjects];
    [LocalSearchTextArray removeAllObjects];
    [LocalSearchTextArray addObjectsFromArray:ReveresdArray];

    CheckTblview = 0;
    ButtonOnClickCheck = 0;
    
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
    
    [Tblview reloadData];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [mySearchBar becomeFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   // SearchTblView.hidden = NO;
    [searchBar setShowsCancelButton:YES animated:YES];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    //This'll Hide The cancelButton with Animation
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    mySearchBar.text = @"";
  //  SearchTblView.hidden = YES;
    //remaining Code'll go here
    
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];

    }
    else
    {
         [self dismissViewControllerAnimated:YES completion:nil];

    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        NSLog(@"Click clear button");
        CheckTblview = 0;
        [Tblview reloadData];
        SearchScroll.hidden = YES;
    }else{
        NSLog(@"auto key in ???");
        if ([searchText length] >= 1) {
            GetSearchText = searchText;
            [self GetSearchText];
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    GetSearchText = searchBar.text;
    NSLog(@"GetSearchText is %@",GetSearchText);
    
    if ([GetSearchText isEqualToString:@""] || GetSearchText == nil) {
        NSLog(@"no searchtext no need save ");
    }else{
        NSLog(@"got search data need save.");
        
//        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
//        [self.navigationController pushViewController:SearchDetailView animated:YES];
//        [SearchDetailView GetSearchKeyword:searchBar.text Getlat:@"" GetLong:@"" GetLocationName:@"" GetCurrentLat:latPoint GetCurrentLong:lonPoint];
//        mySearchBar.text = GetSearchText;
        self.ct3_SearchListingViewController = nil;
        self.ct3_SearchListingViewController.SearchText = GetSearchText;
        [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    
    if (CheckTblview == 0) {
        return LocalisedString(@"Search History");
    }else{
        return LocalisedString(@"Suggested search");
        
    }
    
    return 0;
    
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(20, 8, 320, 20);
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    myLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (CheckTblview == 0) {
        return [LocalSearchTextArray count];
    }else{
        return [GetReturnSearchTextArray count];
        
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
        UIImageView *ShowMapPin = [[UIImageView alloc]init];
        ShowMapPin.frame = CGRectMake(10, 10, 30, 30);
        ShowMapPin.image = [UIImage imageNamed:@"TimeIcon.png"];
        [cell addSubview:ShowMapPin];
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(50, 0, 290, 50);
        ShowName.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
        ShowName.tag = 200;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"ProximaNovaSoft-Regular" size:15];
        ShowName.numberOfLines = 5;
        
        [cell addSubview:ShowName];
        
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (CheckTblview == 0) {
        UILabel *ShowName = (UILabel *)[cell viewWithTag:200];
        ShowName.text = [LocalSearchTextArray objectAtIndex:indexPath.row];
    }else{
        UILabel *ShowName = (UILabel *)[cell viewWithTag:200];
        NSString *GetTempAddress = [[NSString alloc]initWithFormat:@"%@",[GetReturnSearchAddressArray objectAtIndex:indexPath.row]];
        if ([GetTempAddress isEqualToString:@""]) {
            ShowName.text = [GetReturnSearchTextArray objectAtIndex:indexPath.row];
        }else{
            
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ > %@",[GetReturnSearchTextArray objectAtIndex:indexPath.row],GetTempAddress];
            
            ShowName.text = TempString;
        }
        
        
        
    }
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Click...");
//    SearchResultV2ViewController *SearchResultView = [[SearchResultV2ViewController alloc]init];
//    [self presentViewController:SearchResultView animated:YES completion:nil];
    if (CheckTblview == 0 ) {
        GetSearchText = [LocalSearchTextArray objectAtIndex:indexPath.row];
        [self GetSearchText];
        
        mySearchBar.text = GetSearchText;
        
    }else{
        
//        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
//        [SearchDetailView GetSearchKeyword:[GetReturnSearchTextArray objectAtIndex:indexPath.row] Getlat:[GetReturnSearchLngArray objectAtIndex:indexPath.row] GetLong:[GetReturnSearchLatArray objectAtIndex:indexPath.row] GetLocationName:[GetReturnSearchAddressArray objectAtIndex:indexPath.row] GetCurrentLat:latPoint GetCurrentLong:lonPoint];
//        //[SearchDetailView GetTitle:GetSearchText];
//        [self.navigationController pushViewController:SearchDetailView animated:YES];
        self.ct3_SearchListingViewController = nil;
        self.ct3_SearchListingViewController.SearchText = [GetReturnSearchTextArray objectAtIndex:indexPath.row];
        self.ct3_SearchListingViewController.Getlat = [GetReturnSearchLatArray objectAtIndex:indexPath.row];
        self.ct3_SearchListingViewController.Getlong = [GetReturnSearchLngArray objectAtIndex:indexPath.row];
        self.ct3_SearchListingViewController.GetCurrentlat = latPoint;
        self.ct3_SearchListingViewController.GetCurrentLong = lonPoint;
        self.ct3_SearchListingViewController.LocationName = [GetReturnSearchAddressArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
    
    }
}

-(void)GetSearchText{
    
    NSString *FullString;
 if ([latPoint length] == 0 || [latPoint isEqualToString:@""] || [latPoint isEqualToString:@"(null)"] || latPoint == nil) {
     FullString = [[NSString alloc]initWithFormat:@"%@tags/%@",DataUrl.UserWallpaper_Url,GetSearchText];
 }else{
     FullString = [[NSString alloc]initWithFormat:@"%@tags?keyword=%@&lat=%@&lng=%@",DataUrl.UserWallpaper_Url,GetSearchText,latPoint,lonPoint];
 }
    
    
    
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
    [ShowActivity stopAnimating];
    //    [spinnerView stopAnimating];
    //    [spinnerView removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == theConnection_GetSearchString){
        NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSLog(@"get data to server   ==== %@",GetData);
        
        NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
        
        if ([res count] == 0) {
            NSLog(@"Server Error.");
            UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            ShowAlert.tag = 1000;
            [ShowAlert show];
        }else{
            NSString *StatusString = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"status"]];
            if ([StatusString isEqualToString:@"ok"]) {
                NSDictionary *GetAllData = [res valueForKey:@"data"];
                
                NSArray *GetStringData = (NSArray *)[GetAllData valueForKey:@"simple"];
                NSLog(@"GetStringData is %@",GetStringData);
                
                NSArray *GetcomplexData = (NSArray *)[GetAllData valueForKey:@"complex"];
                NSLog(@"GetcomplexData is %@",GetcomplexData);
                
                GetReturnSearchTextArray = [[NSMutableArray alloc]init];
                
                for (NSDictionary * dict in GetcomplexData){
                    NSString *tag = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"tag"]];
                    [GetReturnSearchTextArray addObject:tag];
                }
                
                NSDictionary *locationData = [GetcomplexData valueForKey:@"location"];
                NSLog(@"locationData is %@",locationData);
                GetReturnSearchAddressArray = [[NSMutableArray alloc]init];
                GetReturnSearchLatArray = [[NSMutableArray alloc]init];
                GetReturnSearchLngArray = [[NSMutableArray alloc]init];
                for (NSDictionary * dict in locationData) {
                    NSString *formatted_address = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"formatted_address"]];
                    //NSLog(@"formatted_address is %@",formatted_address);
                    if ([formatted_address isEqualToString:@"<null>"] || formatted_address == nil) {
                        [GetReturnSearchAddressArray addObject:@""];
                    }else{
                        [GetReturnSearchAddressArray addObject:formatted_address];
                    }
                    
                    NSString *lat = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lat"]];
                    //NSLog(@"formatted_address is %@",formatted_address);
                    if ([lat isEqualToString:@"<null>"] || lat == nil) {
                        [GetReturnSearchLatArray addObject:@""];
                    }else{
                        [GetReturnSearchLatArray addObject:lat];
                    }
                    
                    NSString *lng = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"lng"]];
                    //NSLog(@"formatted_address is %@",formatted_address);
                    if ([lng isEqualToString:@"<null>"] || lng == nil) {
                        [GetReturnSearchLngArray addObject:@""];
                    }else{
                        [GetReturnSearchLngArray addObject:lng];
                    }
                    
                }
                NSLog(@"GetReturnSearchTextArray is %@",GetReturnSearchTextArray);
                
                NSLog(@"GetReturnSearchAddressArray is %@",GetReturnSearchAddressArray);
                
                GetSearchArray = [[NSMutableArray alloc]initWithArray:GetStringData];
                if ([GetSearchArray count] == 0) {
                    [GetSearchArray addObject:GetSearchText];
                }
                //        [LocalSuggestionTextArray removeAllObjects];
                //
                //        LocalSuggestionTextArray = [[NSMutableArray alloc]initWithArray:GetStringData];
                //        NSLog(@"LocalSuggestionTextArray is %@",LocalSuggestionTextArray);
                //        [SuggestionTblView reloadData];
                
//                CheckTblview = 1;
//                [Tblview reloadData];
                
                SearchScroll.hidden = NO;
                SearchScroll.alwaysBounceVertical = YES;
                SearchScroll.backgroundColor = [UIColor whiteColor];
                [self InitSearchReturnView];
            }
        }
        

    }
}
-(void)InitSearchReturnView{
   // CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    int height = 0;
    
    for (UIView *subview in SearchScroll.subviews) {
        [subview removeFromSuperview];
    }
    
    UILabel *ShowSuggestedPlaces = [[UILabel alloc]init];
    ShowSuggestedPlaces.frame = CGRectMake(20, 10, screenWidth - 40, 20);
    ShowSuggestedPlaces.text = LocalisedString(@"Suggested places");
    ShowSuggestedPlaces.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    ShowSuggestedPlaces.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [SearchScroll addSubview:ShowSuggestedPlaces];
    
    height += 40;
    
    
    for (int i = 0; i < [GetReturnSearchTextArray count]; i++) {
        
        UIImageView *ShowLocationIcon = [[UIImageView alloc]init];
        ShowLocationIcon.frame = CGRectMake(20, height, 30, 30);
        ShowLocationIcon.image = [UIImage imageNamed:@"SearchLocationIcon.png"];
        [SearchScroll addSubview:ShowLocationIcon];
        
        UIButton *TextButton = [[UIButton alloc]init];
        NSString *GetTempAddress = [[NSString alloc]initWithFormat:@"%@",[GetReturnSearchAddressArray objectAtIndex:i]];
        if ([GetTempAddress isEqualToString:@""]) {
            [TextButton setTitle:[GetReturnSearchTextArray objectAtIndex:i] forState:UIControlStateNormal];
        }else{
            NSString *TempString = [[NSString alloc]initWithFormat:@"%@ > %@",[GetReturnSearchTextArray objectAtIndex:i],GetTempAddress];
            [TextButton setTitle:TempString forState:UIControlStateNormal];
        }
        TextButton.frame = CGRectMake(76, height, screenWidth - 155, 30);
        TextButton.backgroundColor = [UIColor clearColor];
        [TextButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        TextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        TextButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        TextButton.tag = i;
        [TextButton addTarget:self action:@selector(SearchWithLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [SearchScroll addSubview:TextButton];
        
        height += 40;
    }
    
    UIButton *Line01 = [[UIButton alloc]init];
    Line01.frame = CGRectMake(0, height, screenWidth, 1);
    [Line01 setTitle:@"" forState:UIControlStateNormal];//238
    [Line01 setBackgroundColor:[UIColor colorWithRed:233.0f/255.0f green:237.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    [SearchScroll addSubview:Line01];
    
    height += 11;
    
    UILabel *ShowSuggestedSearch = [[UILabel alloc]init];
    ShowSuggestedSearch.frame = CGRectMake(20, height, screenWidth - 40, 20);
    ShowSuggestedSearch.text = LocalisedString(@"Suggested search");
    ShowSuggestedSearch.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    ShowSuggestedSearch.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
    [SearchScroll addSubview:ShowSuggestedSearch];
    
    height += 30;
    
    for (int i = 0; i < [GetSearchArray count]; i++) {
        UIImageView *ShowSearchIcon = [[UIImageView alloc]init];
        ShowSearchIcon.frame = CGRectMake(20, height, 30, 30);
        ShowSearchIcon.image = [UIImage imageNamed:@"SuggestionSearchIcon.png"];
        [SearchScroll addSubview:ShowSearchIcon];
        
        UIButton *TextButton = [[UIButton alloc]init];
        [TextButton setTitle:[GetSearchArray objectAtIndex:i] forState:UIControlStateNormal];
        TextButton.frame = CGRectMake(76, height, screenWidth - 155, 30);
        TextButton.backgroundColor = [UIColor clearColor];
        [TextButton setTitleColor:[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        TextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        TextButton.titleLabel.font = [UIFont fontWithName:@"ProximaNovaSoft-Bold" size:15];
        TextButton.tag = i;
        [TextButton addTarget:self action:@selector(SearchTextOnlyButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [SearchScroll addSubview:TextButton];
        
        UIButton *GotoButton = [[UIButton alloc]init];
        [GotoButton setImage:[UIImage imageNamed:@"AutoComplete.png"] forState:UIControlStateNormal];
        GotoButton.frame = CGRectMake(screenWidth - 20 - 30, height, 30, 30);
        GotoButton.tag = i;
        [GotoButton addTarget:self action:@selector(SearchGetLocationButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [SearchScroll addSubview:GotoButton];
        
        height += 40;
    }
    
    
    
    CGSize contentSize = SearchScroll.frame.size;
    contentSize.height = height + 20;
    SearchScroll.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    SearchScroll.contentSize = contentSize;

}
-(IBAction)SearchWithLocationButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"SearchWithLocationButtonOnClick button %li",(long)getbuttonIDN);
    GetSearchText = [GetReturnSearchTextArray objectAtIndex:getbuttonIDN];
    
//    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:SearchDetailView animated:YES];
//    //[self presentViewController:SearchDetailView animated:YES completion:nil];
//    [SearchDetailView GetSearchKeyword:[GetReturnSearchTextArray objectAtIndex:getbuttonIDN] Getlat:[GetReturnSearchLatArray objectAtIndex:getbuttonIDN] GetLong:[GetReturnSearchLngArray objectAtIndex:getbuttonIDN] GetLocationName:[GetReturnSearchAddressArray objectAtIndex:getbuttonIDN] GetCurrentLat:latPoint GetCurrentLong:lonPoint];
//    //[SearchDetailView GetTitle:GetSearchText];
//    mySearchBar.text = GetSearchText;
    self.ct3_SearchListingViewController = nil;
    self.ct3_SearchListingViewController.SearchText = GetSearchText;
    self.ct3_SearchListingViewController.Getlat = [GetReturnSearchLatArray objectAtIndex:getbuttonIDN];
    self.ct3_SearchListingViewController.Getlong = [GetReturnSearchLngArray objectAtIndex:getbuttonIDN];
    self.ct3_SearchListingViewController.GetCurrentlat = latPoint;
    self.ct3_SearchListingViewController.GetCurrentLong = lonPoint;
    self.ct3_SearchListingViewController.LocationName = [GetReturnSearchAddressArray objectAtIndex:getbuttonIDN];
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}
-(IBAction)SearchTextOnlyButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"SearchTextOnlyButtonOnClick button %li",(long)getbuttonIDN);
    GetSearchText = [GetSearchArray objectAtIndex:getbuttonIDN];
    
//    SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]initWithNibName:@"SearchDetailViewController" bundle:nil];
//    [self.navigationController pushViewController:SearchDetailView animated:YES];
//    [SearchDetailView GetSearchKeyword:[GetSearchArray objectAtIndex:getbuttonIDN] Getlat:@"" GetLong:@"" GetLocationName:@"" GetCurrentLat:latPoint GetCurrentLong:lonPoint];
//   // [SearchDetailView GetTitle:GetSearchText];
//    mySearchBar.text = GetSearchText;
    self.ct3_SearchListingViewController = nil;
    self.ct3_SearchListingViewController.SearchText = GetSearchText;
    self.ct3_SearchListingViewController.GetCurrentlat = latPoint;
    self.ct3_SearchListingViewController.GetCurrentLong = lonPoint;
    [self.navigationController pushViewController:self.ct3_SearchListingViewController animated:YES];
}
-(IBAction)SearchGetLocationButtonOnClick:(id)sender{
    NSInteger getbuttonIDN = ((UIControl *) sender).tag;
    NSLog(@"SearchGetLocationButtonOnClick button %li",(long)getbuttonIDN);
    GetSearchText = [GetSearchArray objectAtIndex:getbuttonIDN];
    [self GetSearchText];
    mySearchBar.text = GetSearchText;
    
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *location = newLocation;
    
    if (location != nil) {
        latPoint = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        lonPoint = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        //Now you know the location has been found, do other things, call others methods here
        [self.locationManager stopUpdatingLocation];
        
        
    }else{
        
    }
}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    
    NSLog(@"%@",error.userInfo);
    
    if([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            UIAlertView    *alert = [[UIAlertView alloc] initWithTitle:@"App Permission Denied"
                                                               message:@"To re-enable, please go to Settings and turn on Location Service for this app."
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
    }
    NSLog(@"no location get feed data");
    [manager stopUpdatingLocation];
}
-(CT3_SearchListingViewController*)ct3_SearchListingViewController
{
    if (!_ct3_SearchListingViewController) {
        _ct3_SearchListingViewController = [CT3_SearchListingViewController new];
    }
    return _ct3_SearchListingViewController;
}
@end
