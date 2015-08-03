//
//  ExploreCountryV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "AsyncImageView.h"
#import "LLARingSpinnerView.h"
@interface ExploreCountryV2ViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UILabel *ShowTItle;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *UserScroll;
    IBOutlet UIImageView *BarImage;

    NSString *GetCountryName;
    NSString *GetCountryIDN;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    NSMutableArray *PostIDArray;
    NSMutableArray *PhotoArray;
    
    NSURLConnection *theConnection_GetCountryData;
    NSURLConnection *theConnection_GetUserData;
    NSURLConnection *theConnection_Following;
    
    NSMutableArray *User_IDArray;
    NSMutableArray *User_ProfileImageArray;
    NSMutableArray *User_NameArray;
    NSMutableArray *User_LocationArray;
    NSMutableArray *User_FollowArray;
    NSMutableArray *User_UserNameArray;
    
    NSString *GetUserID;
    NSString *GetFollowString;
    
    UIButton *ShowFollowButton;
    IBOutlet UIButton *SearchButton;
    
    BOOL CheckLoadDone;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    BOOL CheckLoad_Explore;
    int CheckFirstTimeLoad;
    
   // LLARingSpinnerView *spinnerView;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SearchButton:(id)sender;
-(IBAction)FilterButton:(id)sender;
-(void)GetCountryName:(NSString *)CountryName GetCountryIDN:(NSString *)CountryIDN;
@end
