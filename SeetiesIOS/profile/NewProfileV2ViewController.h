//
//  NewProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3ParallaxScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"

//https://github.com/freak4pc/SMTagField tag simple
@interface NewProfileV2ViewController : BaseViewController<UIScrollViewDelegate,UISearchBarDelegate>{

    IBOutlet A3ParallaxScrollView *MainScroll;
    IBOutlet AsyncImageView *BackgroundImage;
    IBOutlet UIView *AllContentView;
    
    int GetHeight;
    
    UISegmentedControl *ProfileControl;
    
    UIView *PostView;
    UIView *CollectionView;
    UIView *LikeView;
    
    IBOutlet UIButton *SettingsButton;
    IBOutlet UIButton *ShareButton;
    IBOutlet UISearchBar *SearchBarTemp;
    
    BOOL CheckExpand;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetUserData;
    
    //content data 
    AsyncImageView *ShowUserProfileImage;
    
    
    NSString *GetProfileImg;
    NSString *GetName;
    NSString *GetUserName;
    NSString *GetLocation;
    NSString *GetDescription;
    NSString *GetLink;
}
-(IBAction)SettingsButton:(id)sender;
@end
