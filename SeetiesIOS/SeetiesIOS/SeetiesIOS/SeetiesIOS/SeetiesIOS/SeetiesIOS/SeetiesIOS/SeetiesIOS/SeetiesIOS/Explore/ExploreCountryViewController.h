//
//  ExploreCountryViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/17/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface ExploreCountryViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    
    NSString *GetCountryName;
    NSString *GetCountryIDN;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;

    
    NSMutableArray *CategoryArray;
    NSMutableArray *LPhotoArray;
    NSMutableArray *TitleArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_AddressArray;
    NSMutableArray *UserInfo_uidArray;
    NSMutableArray *UserInfo_FollowingArray;
    NSMutableArray *LocationArray;
    NSMutableArray *FullPhotoArray;
    NSMutableArray *MessageArray;
    NSMutableArray *LikesArray;
    NSMutableArray *CommentArray;
    NSMutableArray *LangArray;
    NSMutableArray *LatArray;
    NSMutableArray *LongArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *CheckLikeArray;
    NSMutableArray *Activities_profile_photoArray;
    NSMutableArray *Activities_typeArray;
    NSMutableArray *Activities_uidArray;
    NSMutableArray *Activities_usernameArray;
    NSMutableArray *LinkArray;
}
-(IBAction)BackButton:(id)sender;
-(void)GetCountryName:(NSString *)CountryName GetCountryIDN:(NSString *)CountryIDN;
-(IBAction)SearchButton:(id)sender;
-(void)GetDataFromServer;
@end
