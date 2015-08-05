//
//  ChooseCategoryViewController.m
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import "ChooseCategoryViewController.h"
//#import "ProgressHUD.h"
#import "LanguageManager.h"
#import "Locale.h"

@interface ChooseCategoryViewController ()

@end

@implementation ChooseCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ShowTitle.text = CustomLocalisedString(@"SelectCategory", nil);
    
    DataUrl = [[UrlDataClass alloc]init];
    
    [ArtBtn setImage:[UIImage imageNamed:@"Icon_Art&Entertainment.png"] forState:UIControlStateNormal];
    [ArtBtn setImage:[UIImage imageNamed:@"Select_Art&Enterainment.png"] forState:UIControlStateSelected];
    
    [BeautyBtn setImage:[UIImage imageNamed:@"Icon_Beauty&Fashion.png"] forState:UIControlStateNormal];
    [BeautyBtn setImage:[UIImage imageNamed:@"Select_Beauty&Fashion.png"] forState:UIControlStateSelected];
    
    [FoodBtn setImage:[UIImage imageNamed:@"Icon_Food&Drink.png"] forState:UIControlStateNormal];
    [FoodBtn setImage:[UIImage imageNamed:@"Select_Food&Drink.png"] forState:UIControlStateSelected];
    
    [KitchenBtn setImage:[UIImage imageNamed:@"Icon_KitchenRecipe.png"] forState:UIControlStateNormal];
    [KitchenBtn setImage:[UIImage imageNamed:@"Select_KitchenRecipe.png"] forState:UIControlStateSelected];
    
    [NightlifeBtn setImage:[UIImage imageNamed:@"Icon_Nightlife.png"] forState:UIControlStateNormal];
    [NightlifeBtn setImage:[UIImage imageNamed:@"Select_Nightlife.png"] forState:UIControlStateSelected];
    
    [OutdoorBtn setImage:[UIImage imageNamed:@"Icon_Outdoor&Sport.png"] forState:UIControlStateNormal];
    [OutdoorBtn setImage:[UIImage imageNamed:@"Select_Outdoor&Sport.png"] forState:UIControlStateSelected];
    
    [ProductBtn setImage:[UIImage imageNamed:@"Icon_Product.png"] forState:UIControlStateNormal];
    [ProductBtn setImage:[UIImage imageNamed:@"Select_Product.png"] forState:UIControlStateSelected];
    
    [StaycationBtn setImage:[UIImage imageNamed:@"Icon_Staycation.png"] forState:UIControlStateNormal];
    [StaycationBtn setImage:[UIImage imageNamed:@"Select_Staycation.png"] forState:UIControlStateSelected];
    
    [CultureBtn setImage:[UIImage imageNamed:@"Icon_Culture&Attraction.png"] forState:UIControlStateNormal];
    [CultureBtn setImage:[UIImage imageNamed:@"Select_Culture&Attraction.png"] forState:UIControlStateSelected];
    
    DoneButn.userInteractionEnabled = NO;
    [DoneButn setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [DoneButn setTitle:CustomLocalisedString(@"Done", nil) forState:UIControlStateNormal];
    
    ShowArt.text = CustomLocalisedString(@"Art",nil);
    ShowBeauty.text = CustomLocalisedString(@"Beauty",nil);
    ShowFood.text = CustomLocalisedString(@"Food",nil);
    ShowProduct.text = CustomLocalisedString(@"Product",nil);
    ShowOutdoor.text = CustomLocalisedString(@"Outdoor",nil);
    ShowKitchen.text = CustomLocalisedString(@"Kitchen",nil);
    ShowStaycation.text = CustomLocalisedString(@"Staycation",nil);
    ShowCulture.text = CustomLocalisedString(@"Culture",nil);
    ShowNightlife.text = CustomLocalisedString(@"Nightlife",nil);
    
    [self GetAllcategory];
}
- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.screenName = @"IOS Publish Select Category Page";
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
-(IBAction)ArtButton:(id)sender{
    ArtBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    GetSelectCategoryString = @"Art & Entertainment";
    if (BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        
    }
    
}
-(IBAction)BeautyButton:(id)sender{
    BeautyBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Beauty & Fashion";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        
    }
}
-(IBAction)FoodButton:(id)sender{
    FoodBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Food & Drink";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        
    }
}
-(IBAction)KitchenButton:(id)sender{
    KitchenBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Kitchen Recipe";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        
    }
}
-(IBAction)NightlifeButton:(id)sender{
    NightlifeBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Nightlife";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        //NightlifeBtn.selected = !NightlifeBtn.isSelected;
    }
}
-(IBAction)OutdoorButton:(id)sender{
    OutdoorBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Outdoor & Sport";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || ProductBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
       
    }
}
-(IBAction)ProductButton:(id)sender{
    ProductBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Product";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || StaycationBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        StaycationBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
        //ProductBtn.selected = !ProductBtn.isSelected;
    }
}
-(IBAction)StaycationButton:(id)sender{
    StaycationBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Staycation";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || CultureBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        CultureBtn.selected = NO;
    }else{
       // StaycationBtn.selected = !StaycationBtn.isSelected;
    }
}
-(IBAction)CultureButton:(id)sender{
    CultureBtn.selected = YES;
    DoneButn.userInteractionEnabled = YES;
    GetSelectCategoryString = @"Culture & Landmark";
    [DoneButn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (ArtBtn.selected || BeautyBtn.selected || FoodBtn.selected || KitchenBtn.selected || NightlifeBtn.selected || OutdoorBtn.selected || ProductBtn.selected || StaycationBtn.selected) {
        //NSLog(@"");
        ArtBtn.selected = NO;
        BeautyBtn.selected = NO;
        FoodBtn.selected = NO;
        KitchenBtn.selected = NO;
        NightlifeBtn.selected = NO;
        OutdoorBtn.selected = NO;
        ProductBtn.selected = NO;
        StaycationBtn.selected = NO;
    }else{
       // CultureBtn.selected = !CultureBtn.isSelected;
    }
}
-(IBAction)DoneButton:(id)sender{
    NSLog(@"Done Button Click.");
    
    for (int i = 0; i < [CategoryNameArray count]; i++) {
        NSString *TempString = [[NSString alloc]initWithFormat:@"%@",[CategoryNameArray objectAtIndex:i]];
        if ([TempString isEqualToString:GetSelectCategoryString]) {
            
            GetSelectCategoryIDN = [[NSString alloc]initWithFormat:@"%@",[IDNArray objectAtIndex:i]];
            
            break;
        }
    }
    
    NSLog(@"GetSelectCategoryString is %@",GetSelectCategoryString);
    NSLog(@"GetSelectCategoryIDN is %@",GetSelectCategoryIDN);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:GetSelectCategoryString forKey:@"CategorySelected"];
    [defaults setObject:GetSelectCategoryIDN forKey:@"CategorySelectedIDN"];
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
-(void)GetAllcategory{
   // [ProgressHUD show:CustomLocalisedString(@"PleaseWait", nil)];
    
    NSString *FullString = [[NSString alloc]initWithFormat:@"%@",DataUrl.CategoryIDN_Url];
    
    NSString *postBack = [[NSString alloc] initWithFormat:@"%@",FullString];
    NSLog(@"check postBack URL ==== %@",postBack);
    NSURL *url = [NSURL URLWithString:[postBack stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSLog(@"theRequest === %@",theRequest);
    [theRequest addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    NSURLConnection *theConnection_All = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    [theConnection_All start];
    
    
    if( theConnection_All ){
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
    //[ProgressHUD showError:@"Something went wrong."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:CustomLocalisedString(@"ErrorConnection", nil) message:CustomLocalisedString(@"NoData", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *GetData = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"ExpertLogin return get data to server ===== %@",GetData);
    
    NSData *jsonData = [GetData dataUsingEncoding:NSUTF8StringEncoding];
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
    NSLog(@"Json = %@",res);
    
    NSArray *GetCategoryData = (NSArray *)[res valueForKey:@"categories"];
    NSLog(@"GetCategoryData ===== %@",GetCategoryData);
    
//    NSDictionary *StreaminfoData = [GetCategoryData valueForKey:@"single_line"];
//    NSLog(@"StreaminfoData ===== %@",StreaminfoData);
    NSArray *GetNameEng = (NSArray *)[GetCategoryData valueForKey:@"single_line"];
    NSLog(@"GetNameEng ===== %@",GetNameEng);
    
    IDNArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
    CategoryNameArray = [[NSMutableArray alloc] initWithCapacity:[GetCategoryData count]];
    for (NSDictionary * dict in GetCategoryData){
        NSString *GuestIDN =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        [IDNArray addObject:GuestIDN];
    }
    NSLog(@"IDNArray is %@",IDNArray);
    for (NSDictionary * dict in GetNameEng){
        NSString *Name =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"530b0ab26424400c76000003"]];
        [CategoryNameArray addObject:Name];
    }
    NSLog(@"CategoryNameArray is %@",CategoryNameArray);
    
    
    
    //[ProgressHUD showSuccess:@"That was great!"];
   // [ProgressHUD dismiss];
    
    
    
}
@end
