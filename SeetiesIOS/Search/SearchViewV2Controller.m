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
@interface SearchViewV2Controller ()

@end

@implementation SearchViewV2Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    mySearchBar.delegate = self;
   // [mySearchBar setTintColor:[UIColor blackColor]];
    mySearchBar.tintColor = [UIColor whiteColor];
    mySearchBar.barTintColor = [UIColor clearColor];
    [mySearchBar setBackgroundImage:[[UIImage alloc]init]];
    [mySearchBar becomeFirstResponder];
    
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    Tblview.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64 - 216);
    
    LocalSearchTextArray = [[NSMutableArray alloc]init];
    [LocalSearchTextArray addObject:@"Coffee"];
    [LocalSearchTextArray addObject:@"Pizza"];
    [LocalSearchTextArray addObject:@"Night Club"];
    [LocalSearchTextArray addObject:@"Sushi"];
    [LocalSearchTextArray addObject:@"Museum"];
    [LocalSearchTextArray addObject:@"Hiking"];

    CheckTblview = 0;
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        NSLog(@"Click clear button");
        CheckTblview = 0;
        [Tblview reloadData];
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
       // [mySearchBar resignFirstResponder];
       // [mySearchBar setShowsCancelButton:NO animated:YES];
        [self GetSearchText];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    
    if (CheckTblview == 0) {
        return @"Search History";
    }else{
        return @"Suggestions";
        
    }
    
    return 0;
    
    
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
        
        UILabel *ShowName = [[UILabel alloc]init];
        ShowName.frame = CGRectMake(15, 0, 290, 50);
        ShowName.textColor = [UIColor darkGrayColor];
        ShowName.tag = 200;
        ShowName.backgroundColor = [UIColor clearColor];
        ShowName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
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
        
        SearchDetailViewController *SearchDetailView = [[SearchDetailViewController alloc]init];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.2;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        [self presentViewController:SearchDetailView animated:NO completion:nil];
        [SearchDetailView GetSearchKeyword:GetSearchText Getlat:[GetReturnSearchLngArray objectAtIndex:indexPath.row] GetLong:[GetReturnSearchLatArray objectAtIndex:indexPath.row] GetLocationName:[GetReturnSearchAddressArray objectAtIndex:indexPath.row]];
        [SearchDetailView GetTitle:GetSearchText];
        
    
    }
}

-(void)GetSearchText{
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@tags/%@",DataUrl.UserWallpaper_Url,GetSearchText];
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
                //        [LocalSuggestionTextArray removeAllObjects];
                //
                //        LocalSuggestionTextArray = [[NSMutableArray alloc]initWithArray:GetStringData];
                //        NSLog(@"LocalSuggestionTextArray is %@",LocalSuggestionTextArray);
                //        [SuggestionTblView reloadData];
                
                CheckTblview = 1;
                [Tblview reloadData];
                
                
            }
        }
        

    }
}
@end
