//
//  Filter2ViewController.m
//  SeetiesIOS
//
//  Created by Seeties IOS on 5/18/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import "Filter2ViewController.h"
#import "LanguageManager.h"
#import "Locale.h"
@interface Filter2ViewController ()

@end

@implementation Filter2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    tblview.frame = CGRectMake(0, 64, screenWidth, screenHeight - 124);
    TitleLabel.frame = CGRectMake(15, 20, screenWidth - 30, 44);
    BarImage.frame = CGRectMake(0, 0, screenWidth, 64);
    
    ApplyFilterButton.frame = CGRectMake(0, screenHeight - 60, screenWidth, 60);
    TitleLabel.text = CustomLocalisedString(@"Filter", nil);
    [ApplyFilterButton setTitle:CustomLocalisedString(@"ApplyFilter", nil) forState:UIControlStateNormal];


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Filter View";
}
-(IBAction)BackButton:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)GetWhatViewComeHere:(NSString *)WhatView{
    
   // CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    GetWhatViewCome = WhatView;
    NSString *TempSortByString;
    NSString *GetCategoryString;
    
    if ([GetWhatViewCome isEqualToString:@"Feed"]) {
        TempSortByString = [defaults objectForKey:@"Filter_Feed_SortBy"];
        GetCategoryString = [defaults objectForKey:@"Filter_Feed_Category"];
        
    }else if([GetWhatViewCome isEqualToString:@"Search"]){
        TempSortByString = [defaults objectForKey:@"Filter_Search_SortBy"];
        GetCategoryString = [defaults objectForKey:@"Filter_Search_Category"];
    }else if([GetWhatViewCome isEqualToString:@"Explore"]){
        TempSortByString = [defaults objectForKey:@"Filter_Explore_SortBy"];
        GetCategoryString = [defaults objectForKey:@"Filter_Explore_Category"];
    }
    
    //Initialize the dataArray
    dataArray = [[NSMutableArray alloc] init];
    
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
    
    
    NSMutableArray *GetTempImageArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Default"]];
    GetImageDefaultArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray];
    NSMutableArray *GetTempImageArray1 = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"Category_All_Image_Selected"]];
    GetImageSelectedArray = [[NSMutableArray alloc]initWithArray:GetTempImageArray1];
    
    SortImageArray = [[NSMutableArray alloc]init];
    
    [SortImageArray addObject:@"Popular.png"];
    [SortImageArray addObject:@"Recent.png"];
    [SortImageArray addObject:@"Distance.png"];
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:CustomLocalisedString(@"Popular", nil), CustomLocalisedString(@"MostRecent", nil), nil];
    //NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:CustomLocalisedString(@"Popular", nil), CustomLocalisedString(@"MostRecent", nil),CustomLocalisedString(@"Distance", nil), nil];
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithArray:CategoryArray];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [dataArray addObject:secondItemsArrayDict];
    
    if ([TempSortByString length] == 0 || [TempSortByString isEqualToString:@""] || [TempSortByString isEqualToString:@"(null)"] || TempSortByString == nil) {
        checkedIndexPath_Sort = [NSIndexPath indexPathForRow:1 inSection:0];
        GetSortStringData = @"2";
    }else{
        if ([TempSortByString isEqualToString:@"1"]) {
            checkedIndexPath_Sort = [NSIndexPath indexPathForRow:0 inSection:0];
            GetSortStringData = @"1";
        }else if([TempSortByString isEqualToString:@"2"]){
            checkedIndexPath_Sort = [NSIndexPath indexPathForRow:1 inSection:0];
            GetSortStringData = @"2";
        }else if([TempSortByString isEqualToString:@"3"]){
            checkedIndexPath_Sort = [NSIndexPath indexPathForRow:2 inSection:0];
            GetSortStringData = @"3";
        }
    }
    
    
    if ([GetCategoryString length] == 0 || [GetCategoryString isEqualToString:@""] || [GetCategoryString isEqualToString:@"(null)"] || GetCategoryString == nil) {
        SelectCategoryIDArray = [[NSMutableArray alloc]init];
    }else{

        NSLog(@"GetCategoryString is %@",GetCategoryString);
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return CustomLocalisedString(@"SortByBig", nil);
    if(section == 1)
        return CustomLocalisedString(@"ChooseacategoryBig", nil);
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    if (section == 1) {
        // 1. The view for the header
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 22)];

        
        // 3. Add a label
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(15, 5, tableView.frame.size.width - 5, 30);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:14];
        headerLabel.text = CustomLocalisedString(@"ChooseacategoryBig", nil);
        headerLabel.textAlignment = NSTextAlignmentLeft;
        
        // 4. Add the label to the header view
        [headerView addSubview:headerLabel];
        
        if ([selectedIndexes count] == [CategoryIDArray count]) {
            SelectAllButton = [[UIButton alloc]init];
            [SelectAllButton setSelected:YES];
            SelectAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 30);
            [SelectAllButton setTitle:CustomLocalisedString(@"UnSelectAll", nil) forState:UIControlStateNormal];
            SelectAllButton.backgroundColor = [UIColor clearColor];
            [SelectAllButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [SelectAllButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [SelectAllButton addTarget:self action:@selector(SelectAllButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:SelectAllButton];
        }

        if ([SelectAllButton isSelected]) {
            NSLog(@"Selected");
            SelectAllButton = [[UIButton alloc]init];
            [SelectAllButton setSelected:YES];
            SelectAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 30);
            [SelectAllButton setTitle:CustomLocalisedString(@"UnSelectAll", nil) forState:UIControlStateNormal];
            SelectAllButton.backgroundColor = [UIColor clearColor];
            [SelectAllButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [SelectAllButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [SelectAllButton addTarget:self action:@selector(SelectAllButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:SelectAllButton];
        }else{
            NSLog(@"no select");
            SelectAllButton = [[UIButton alloc]init];
            [SelectAllButton setSelected:NO];
            SelectAllButton.frame = CGRectMake(tableView.frame.size.width - 100, 5, 100, 30);
            [SelectAllButton setTitle:CustomLocalisedString(@"SelectAll", nil) forState:UIControlStateNormal];
            SelectAllButton.backgroundColor = [UIColor clearColor];
            [SelectAllButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [SelectAllButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [SelectAllButton addTarget:self action:@selector(SelectAllButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:SelectAllButton];
        }

        

        
        // 5. Finally return
        return headerView;
    }

    return 0;
}
-(IBAction)SelectAllButton:(id)sender{
    NSLog(@"SelectAllButton Click");

    
    SelectAllButton.selected = !SelectAllButton.selected;
    
    if (SelectAllButton.selected) {
        [SelectAllButton setTitle:CustomLocalisedString(@"UnSelectAll", nil) forState:UIControlStateNormal];
        
        [SelectCategoryIDArray removeAllObjects];
        SelectCategoryIDArray = [[NSMutableArray alloc]initWithArray:CategoryIDArray];
        [selectedIndexes removeAllObjects];
        for (int i = 0; i < [CategoryIDArray count]; i++) {
            NSInteger index = i;
            [selectedIndexes addObject:[NSNumber numberWithInteger:index]];
        }
    }else{
        [SelectAllButton setTitle:CustomLocalisedString(@"SelectAll", nil) forState:UIControlStateNormal];
        [SelectCategoryIDArray removeAllObjects];
        [selectedIndexes removeAllObjects];
    }
    
    [tblview reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (indexPath.section == 0) {
            UIImageView *ShowImage = [[UIImageView alloc]init];
            ShowImage.frame = CGRectMake(15, 7, 29, 29);
            //ShowImage.image = [UIImage imageNamed:[SortImageArray objectAtIndex:indexPath.row]];
            ShowImage.contentMode = UIViewContentModeScaleAspectFit;
            ShowImage.tag = 500;
            [cell addSubview:ShowImage];
            
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(70, 0, 250, 44);
            ShowTitle_.tag = 200;
            //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
            ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            ShowTitle_.textAlignment = NSTextAlignmentLeft;
            ShowTitle_.backgroundColor = [UIColor clearColor];
            [cell addSubview:ShowTitle_];
        }else{
            NSURL *imageURL = [NSURL URLWithString:[GetImageDefaultArray objectAtIndex:indexPath.row]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // Update the UI
                    UIImage *newImage = [UIImage imageWithData:imageData];
                    CGSize rect = CGSizeMake(20, 20);
                    CGFloat scale = [[UIScreen mainScreen]scale];
                    UIGraphicsBeginImageContextWithOptions(rect, NO, scale);
                    [newImage drawInRect:CGRectMake(0,0,rect.width,rect.height)];
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
                });
            });
            
            
            UILabel *ShowTitle_ = [[UILabel alloc]init];
            ShowTitle_.frame = CGRectMake(70, 0, 250, 44);
            ShowTitle_.tag = 150;
         //   ShowTitle_.text = [CategoryArray objectAtIndex:i];
            ShowTitle_.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
            ShowTitle_.textColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0];
            ShowTitle_.textAlignment = NSTextAlignmentLeft;
            ShowTitle_.backgroundColor = [UIColor clearColor];
            [cell addSubview:ShowTitle_];
            
            
        }
  //  }
    if (indexPath.section == 0) {
        if([checkedIndexPath_Sort isEqual:indexPath])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
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
        

    }

    if (indexPath.section == 0) {
        
        UIImageView *ShowImage = (UIImageView *)[cell viewWithTag:500];
        ShowImage.image = [UIImage imageNamed:[SortImageArray objectAtIndex:indexPath.row]];
        
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        //cell.textLabel.text = cellValue;
        UILabel *ShowTitle = (UILabel *)[cell viewWithTag:200];
        ShowTitle.text = cellValue;
    }else{
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        NSString *cellValue = [array objectAtIndex:indexPath.row];
        UILabel *ShowTitle = (UILabel *)[cell viewWithTag:150];
        ShowTitle.text = cellValue;
    
    }
    

    

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"indexPath.section IS %ld",(long)indexPath.section);
    
    if (indexPath.section == 0) {
        if(checkedIndexPath_Sort)
        {
            UITableViewCell* uncheckCell = [tableView
                                            cellForRowAtIndexPath:checkedIndexPath_Sort];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if([checkedIndexPath_Sort isEqual:indexPath])
        {
            checkedIndexPath_Sort = nil;
        }
        else
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            checkedIndexPath_Sort = indexPath;
            GetSortStringData = [[NSString alloc]initWithFormat:@"%ld",(long)indexPath.row + 1];
        }
        
        NSLog(@"checkedIndexPath_Sort ==== %@",checkedIndexPath_Sort);
        
        NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        selectedCell = [array objectAtIndex:indexPath.row];
        
        NSLog(@"Sort By %@", selectedCell);

    }else{
        
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
        
        NSString *selectedCell = nil;
        NSDictionary *dictionary = [dataArray objectAtIndex:indexPath.section];
        NSArray *array = [dictionary objectForKey:@"data"];
        selectedCell = [array objectAtIndex:indexPath.row];
        
        NSLog(@"Category %@", selectedCell);
        
        
    }
    [tblview deselectRowAtIndexPath:indexPath animated:NO];

}
-(IBAction)ApplyButton:(id)sender{
    NSLog(@"GetSortStringData is %@",GetSortStringData);
    NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
    
//    if ([GetSortStringData isEqualToString:@"3"]) {
//        GetSortStringData = @"2";
//    }
    
    if ([SelectCategoryIDArray count] == 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"Oops", nil) message:CustomLocalisedString(@"PleaseSelectatleast1category", nil) delegate:self
                                                 cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertview show];
    }else{
        NSLog(@"SelectCategoryIDArray is %@",SelectCategoryIDArray);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *TempString = [SelectCategoryIDArray componentsJoinedByString:@","];
        if ([GetWhatViewCome isEqualToString:@"Feed"]) {
            [defaults setObject:GetSortStringData forKey:@"Filter_Feed_SortBy"];
            [defaults setObject:TempString forKey:@"Filter_Feed_Category"];
            [defaults synchronize];
        }else if([GetWhatViewCome isEqualToString:@"Search"]){
            [defaults setObject:GetSortStringData forKey:@"Filter_Search_SortBy"];
            [defaults setObject:TempString forKey:@"Filter_Search_Category"];
            [defaults synchronize];
        }else if([GetWhatViewCome isEqualToString:@"Explore"]){
            [defaults setObject:GetSortStringData forKey:@"Filter_Explore_SortBy"];
            [defaults setObject:TempString forKey:@"Filter_Explore_Category"];
            [defaults synchronize];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
