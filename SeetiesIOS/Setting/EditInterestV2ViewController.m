//
//  EditInterestV2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/14/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "EditInterestV2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface EditInterestV2ViewController ()

@end

@implementation EditInterestV2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DataUrl = [[UrlDataClass alloc]init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetCategoryString;
    ShowTitle.text = CustomLocalisedString(@"SettingsPage_EditInterests",nil);
    [SaveButton setTitle:CustomLocalisedString(@"EditProfileSave",nil) forState:UIControlStateNormal];

    GetCategoryString = [defaults objectForKey:@"UserData_Categories"];
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    ShowTitle.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    SaveButton.frame = CGRectMake(screenWidth - 46 - 15, 29, 46, 30);
    Tblview.frame = CGRectMake(0, 64, screenWidth, screenHeight - 64);
    
    CategoryIDArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_ID"]];
    NSString *GetSystemLanguage = [[NSString alloc]initWithFormat:@"%@",[defaults objectForKey:@"UserData_SystemLanguage"]];
    NSLog(@"GetSystemLanguage is %@",GetSystemLanguage);
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
    SelectCategoryIDArray = [[NSMutableArray alloc]init];
    selectedIndexes = [[NSMutableArray alloc]init];
    CategoryArray = [[NSMutableArray alloc]initWithArray:GetNameArray];
    BackgroundColorArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Background"]];
    
    
    NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image"]];
    
    GetImageArray1 = [[NSMutableArray alloc]init];
    for (int i = 0; i < [GetTempImageArray count]; i++) {
        
        [GetImageArray1 addObject:[self decodeBase64ToImage:[GetTempImageArray objectAtIndex:i]]];
    }
    
    
    
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        SelectCategoryIDArray = [[NSMutableArray alloc]init];
    }else{
        
        NSLog(@"GetCategoryString is %@",GetCategoryString);
        NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"() \n"];
        GetCategoryString = [[GetCategoryString componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
        NSArray *arr = [GetCategoryString componentsSeparatedByString:@","];
        NSLog(@"arr is %@",arr);
        SelectCategoryIDArray = [[NSMutableArray alloc]initWithArray:arr];
        NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
        for (int i = 0; i < [CategoryIDArray count]; i++) {
            NSString *CheckCategoryID = [[NSString alloc]initWithFormat:@"%@",[CategoryIDArray objectAtIndex:i]];
            for (int z = 0; z < [SelectCategoryIDArray count]; z++) {
                if ([CheckCategoryID isEqualToString:[SelectCategoryIDArray objectAtIndex:z]]) {
                    NSString *TempIDN = [[NSString alloc]initWithFormat:@"%i",i];
                    [selectedIndexes addObject:TempIDN];
                    break;
                }
            }
        }
        
    }
    
    NSLog(@"selectedIndexes is %@",selectedIndexes);
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
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
-(IBAction)SaveButton:(id)sender{
    if ([selectedIndexes count] == 0) {
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Category cannot empty." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [ShowAlert show];
    }else{
        [self UpdateUserCategory];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [CategoryIDArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        CGSize rect = CGSizeMake(20, 20);
        CGFloat scale = [[UIScreen mainScreen]scale];
        UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
        [[GetImageArray1 objectAtIndex:indexPath.row] drawInRect:CGRectMake(0,0,rect.width,rect.height)];
        UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIButton *ShowImageButton = [[UIButton alloc]init];
        //ShowImageButton.tag = i;
        ShowImageButton.frame = CGRectMake(15, 7, 29, 29);
        [ShowImageButton setImage:picture1 forState:UIControlStateNormal];
        [ShowImageButton setContentMode:UIViewContentModeScaleAspectFit];
        NSUInteger red, green, blue;
        sscanf([[BackgroundColorArray objectAtIndex:indexPath.row] UTF8String], "#%2lX%2lX%2lX", &red, &green, &blue);
        UIColor *color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
        ShowImageButton.backgroundColor = color;
        ShowImageButton.layer.cornerRadius = 15; // this value vary as per your desire
        ShowImageButton.clipsToBounds = YES;
        // [ShowImageButton addTarget:self action:@selector(SelectCategoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:ShowImageButton];
        
        
        UILabel *ShowTitle_ = [[UILabel alloc]init];
        ShowTitle_.frame = CGRectMake(70, 0, 250, 44);
        ShowTitle_.tag = 150;
        //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
        ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
        ShowTitle_.textAlignment = NSTextAlignmentLeft;
        ShowTitle_.backgroundColor = [UIColor clearColor];
        [cell addSubview:ShowTitle_];
        
        

        // Assume cell is not checked -- if it is the loop below will check it.
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        //   NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
        for (int i = 0; i < selectedIndexes.count; i++) {
            NSUInteger num = [[selectedIndexes objectAtIndex:i] intValue];
            if (num == indexPath.row) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                // Once we find a match there is no point continuing the loop
                break;
            }
        }
        
    
        NSString *cellValue = [CategoryArray objectAtIndex:indexPath.row];
        UILabel *ShowTitle_1 = (UILabel *)[cell viewWithTag:150];
        ShowTitle_1.text = cellValue;
        
    
    
    
    
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
        
        //Get the selected country
        UITableViewCell *thisCell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            [SelectCategoryIDArray addObject:[CategoryIDArray objectAtIndex:indexPath.row]];
            NSInteger index = indexPath.row;
            [selectedIndexes addObject:[NSNumber numberWithInteger:index]];
        }else{
            thisCell.accessoryType = UITableViewCellAccessoryNone;
            [SelectCategoryIDArray removeObject:[CategoryIDArray objectAtIndex:indexPath.row]];
            NSInteger index = indexPath.row;
            [selectedIndexes removeObject:[NSNumber numberWithInteger:index]];
        }
//        
//        NSString *selectedCell = nil;
//        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
//        NSArray *array = [dictionary objectForKey:@"data"];
//        selectedCell = [array objectAtIndex:indexPath.row];
//        
//        NSLog(@"Category %@", selectedCell);
//        
//        
//    
    [Tblview deselectRowAtIndexPath:indexPath animated:NO];
    
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
    [spinnerView stopAnimating];
    [spinnerView removeFromSuperview];
    [LoadingBlackBackground removeFromSuperview];
    [ShowLoadingText removeFromSuperview];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"Update Category return get data to server ===== %@",GetData);
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"res is %@",res);
    
    if ([res count] == 0) {
        NSLog(@"Server Error.");
        UIAlertView *ShowAlert = [[UIAlertView alloc]initWithTitle:@"" message:CustomLocalisedString(@"SomethingError", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
            NSString *GetName_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"name"]];
            NSLog(@"GetName_ is %@",GetName_);
            NSString *Getusername = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"username"]];
            NSLog(@"Getusername is %@",Getusername);
            NSString *Getemail = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"email"]];
            NSLog(@"Getemail is %@",Getemail);
            NSString *GetLocation = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"location"]];
            NSLog(@"GetLocation is %@",GetLocation);
            NSString *GetAbouts_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"description"]];
            NSLog(@"GetAbouts_ is %@",GetAbouts_);
            NSString *GetUrl = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"personal_link"]];
            NSLog(@"GetUrl is %@",GetUrl);
            NSString *GetFollowersCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"follower_count"]];
            NSLog(@"GetFollowersCount is %@",GetFollowersCount);
            NSString *GetFollowingCount = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"following_count"]];
            NSLog(@"GetFollowingCount is %@",GetFollowingCount);
            NSString *Getcategories = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"categories"]];
            NSLog(@"Getcategories is %@",Getcategories);
            NSString *Getdob_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"dob"]];
            NSLog(@"Getdob_ is %@",Getdob_);
            NSString *GetGender_ = [[NSString alloc]initWithFormat:@"%@",[res objectForKey:@"gender"]];
            NSLog(@"GetGender_ is %@",GetGender_);
            
            NSDictionary *SystemLanguageData = [res valueForKey:@"system_language"];
            NSString *GetSystemLanguage_ = [[NSString alloc]initWithFormat:@"%@",[SystemLanguageData objectForKey:@"origin_caption"]];
            NSLog(@"GetSystemLanguage_ is %@",GetSystemLanguage_);
            
            NSInteger CheckSystemLanguageData;
            if ([GetSystemLanguage_ isEqualToString:@"English"]) {
                CheckSystemLanguageData = 0;
            }else if([GetSystemLanguage_ isEqualToString:@"Simplified Chinese"]){
                CheckSystemLanguageData = 1;
            }else if([GetSystemLanguage_ isEqualToString:@"Traditional Chinese"]){
                CheckSystemLanguageData = 2;
            }else if([GetSystemLanguage_ isEqualToString:@"Bahasa Indonesia"]){
                CheckSystemLanguageData = 3;
            }else if([GetSystemLanguage_ isEqualToString:@"Thai"] || [GetSystemLanguage_ isEqualToString:@"th"]){
                CheckSystemLanguageData = 4;
            }else if([GetSystemLanguage_ isEqualToString:@"Filipino"]){
                CheckSystemLanguageData = 5;
            }
            
            
            //  NSLog(@"CheckSystemLanguage is %li",(long)CheckSystemLanguage);
            LanguageManager *languageManager = [LanguageManager sharedLanguageManager];
            
            Locale *localeForRow = languageManager.availableLocales[CheckSystemLanguageData];
            
            NSLog(@"Landing Language selected: %@", localeForRow.name);
            
            [languageManager setLanguageWithLocale:localeForRow];
            
            NSDictionary *LanguageData = [res valueForKey:@"languages"];
            NSMutableArray *TempArray = [[NSMutableArray alloc]init];
            for (NSDictionary * dict in LanguageData) {
                NSString *GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[dict objectForKey:@"origin_caption"]];
                NSLog(@"GetLanguage_1 is %@",GetLanguage_1);
                [TempArray addObject:GetLanguage_1];
            }
            
            NSString *GetLanguage_1;
            NSString *GetLanguage_2;
            if ([TempArray count] == 1) {
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
            }else{
                GetLanguage_1 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:0]];
                GetLanguage_2 = [[NSString alloc]initWithFormat:@"%@",[TempArray objectAtIndex:1]];
            }
            NSString *CheckGetUserProfile = @"false";
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:CheckGetUserProfile forKey:@"UserData_CheckData"];
            [defaults setObject:Getcategories forKey:@"UserData_Categories"];
            [defaults setObject:GetName_ forKey:@"UserData_Name"];
            [defaults setObject:Getusername forKey:@"UserData_Username"];
            [defaults setObject:GetAbouts_ forKey:@"UserData_Abouts"];
            [defaults setObject:GetUrl forKey:@"UserData_Url"];
            [defaults setObject:Getemail forKey:@"UserData_Email"];
            [defaults setObject:GetLocation forKey:@"UserData_Location"];
            [defaults setObject:Getdob_ forKey:@"UserData_dob"];
            [defaults setObject:GetGender_ forKey:@"UserData_Gender"];
            [defaults setObject:GetSystemLanguage_ forKey:@"UserData_SystemLanguage"];
            [defaults setObject:GetLanguage_1 forKey:@"UserData_Language1"];
            [defaults setObject:GetLanguage_2 forKey:@"UserData_Language2"];
            [defaults synchronize];
            
            [spinnerView stopAnimating];
            [spinnerView removeFromSuperview];
            [LoadingBlackBackground removeFromSuperview];
            [ShowLoadingText removeFromSuperview];
            
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
    
    
}
-(void)UpdateUserCategory{
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    LoadingBlackBackground = [[UIButton alloc]init];
    [LoadingBlackBackground setTitle:@"" forState:UIControlStateNormal];
    LoadingBlackBackground.backgroundColor = [UIColor blackColor];
    LoadingBlackBackground.alpha = 0.5f;
    LoadingBlackBackground.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:LoadingBlackBackground];
    
    spinnerView.frame = CGRectMake((screenWidth / 2) - 18, (screenHeight / 2 ) - 18, 37, 37);
    [spinnerView startAnimating];
    
    ShowLoadingText = [[UILabel alloc]init];
    ShowLoadingText.frame = CGRectMake(0, (screenHeight/2) + 30, screenWidth, 40);
    ShowLoadingText.text = @"Updating...";
    ShowLoadingText.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    ShowLoadingText.textColor = [UIColor whiteColor];
    ShowLoadingText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:ShowLoadingText];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *GetExpertToken = [defaults objectForKey:@"ExpertToken"];
    NSString *Getuid = [defaults objectForKey:@"Useruid"];
    
    //Server Address URL
    NSString *urlString = [NSString stringWithFormat:@"%@%@",DataUrl.UserWallpaper_Url,Getuid];
    NSLog(@"urlString is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    //1063655260 + CAAGxtEzl7IABANzd8VBZCZAF3YUMAfiambyQ2orfrQ7rE4CEv3uVPZBahkXFFdRmuuZA0CzKZBiHDfUiot9UV3ijM5OddrKh3vcuDZCMCVEvjZBxDdocFAB1omPpVQHuQ9JTdbC58gsdquDicDVtFZBXLTHGOWNF9sVTL39rtBz5Js1dI6ctC3cgolSF6Aqlc54j9lIuvO6UJ7ehPDXGiMx5q1HMZBZBzPVOZCheBR1xTkT5qFauwOpNmu5
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //parameter first
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_first" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterFirst )
    [body appendData:[[NSString stringWithFormat:@"%@",GetExpertToken] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *GetSelectID = [SelectCategoryIDArray componentsJoinedByString:@","];
    //parameter second
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the key name @"parameter_second" to the post body
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"categories\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //Attaching the content to be posted ( ParameterSecond )
    [body appendData:[[NSString stringWithFormat:@"%@",GetSelectID] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    //close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Request  = %@",[[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding]);
    
    //setting the body of the post to the reqeust
    [request setHTTPBody:body];
    //
    //    //now lets make the connection to the web
    //    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //
    //    NSLog(@"returnString %@",returnString);
    
    NSURLConnection *theConnection_Facebook = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(theConnection_Facebook) {
        NSLog(@"Connection Successful");
        webData = [NSMutableData data];
    } else {
        
    }
    
}
@end
