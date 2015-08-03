//
//  MainViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface MainViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UIImageView *ShowAllDoneImage;
    IBOutlet UITableView *tblview;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BackgroundImage;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *latPoint;
    NSString *lonPoint;
    NSInteger CheckLocationOnOff;
    
    NSString *ExternalIPAddress;
    
    NSMutableArray *CategoryArray_Nearby;
    NSMutableArray *LPhotoArray_Nearby;
    NSMutableArray *TitleArray_Nearby;
    NSMutableArray *place_nameArray_Nearby;
    NSMutableArray *UserInfo_NameArray_Nearby;
    NSMutableArray *UserInfo_UrlArray_Nearby;
    NSMutableArray *UserInfo_AddressArray_Nearby;
    NSMutableArray *UserInfo_uidArray_Nearby;
    NSMutableArray *UserInfo_FollowingArray_Nearby;
    NSMutableArray *LocationArray_Nearby;
    NSMutableArray *FullPhotoArray_Nearby;
    NSMutableArray *MessageArray_Nearby;
    NSMutableArray *LikesArray_Nearby;
    NSMutableArray *CommentArray_Nearby;
    NSMutableArray *LangArray_Nearby;
    NSMutableArray *LatArray_Nearby;
    NSMutableArray *LongArray_Nearby;
    NSMutableArray *PostIDArray_Nearby;
    NSMutableArray *CheckLikeArray_Nearby;
    NSMutableArray *Activities_profile_photoArray_Nearby;
    NSMutableArray *Activities_typeArray_Nearby;
    NSMutableArray *Activities_uidArray_Nearby;
    NSMutableArray *Activities_usernameArray_Nearby;
    NSMutableArray *Location_DistanceArray_Nearby;
    NSMutableArray *Link_Array_Nearby;
    
    NSMutableArray *CategoryArray_Local;
    NSMutableArray *LPhotoArray_Local;
    NSMutableArray *TitleArray_Local;
    NSMutableArray *place_nameArray_Local;
    NSMutableArray *UserInfo_NameArray_Local;
    NSMutableArray *UserInfo_UrlArray_Local;
    NSMutableArray *UserInfo_AddressArray_Local;
    NSMutableArray *UserInfo_uidArray_Local;
    NSMutableArray *UserInfo_FollowingArray_Local;
    NSMutableArray *LocationArray_Local;
    NSMutableArray *FullPhotoArray_Local;
    NSMutableArray *MessageArray_Local;
    NSMutableArray *LikesArray_Local;
    NSMutableArray *CommentArray_Local;
    NSMutableArray *LangArray_Local;
    NSMutableArray *LatArray_Local;
    NSMutableArray *LongArray_Local;
    NSMutableArray *PostIDArray_Local;
    NSMutableArray *CheckLikeArray_Local;
    NSMutableArray *Activities_profile_photoArray_Local;
    NSMutableArray *Activities_typeArray_Local;
    NSMutableArray *Activities_uidArray_Local;
    NSMutableArray *Activities_usernameArray_Local;
    NSMutableArray *Location_DistanceArray_Local;
    NSMutableArray *Link_Array_Local;

    
    
    //ForeignLand
    NSMutableArray *CategoryArray_ForeignLand;
    NSMutableArray *LPhotoArray_ForeignLand;
    NSMutableArray *TitleArray_ForeignLand;
    NSMutableArray *place_nameArray_ForeignLand;
    NSMutableArray *UserInfo_NameArray_ForeignLand;
    NSMutableArray *UserInfo_UrlArray_ForeignLand;
    NSMutableArray *UserInfo_AddressArray_ForeignLand;
    NSMutableArray *UserInfo_uidArray_ForeignLand;
    NSMutableArray *UserInfo_FollowingArray_ForeignLand;
    NSMutableArray *LocationArray_ForeignLand;
    NSMutableArray *FullPhotoArray_ForeignLand;
    NSMutableArray *MessageArray_ForeignLand;
    NSMutableArray *LikesArray_ForeignLand;
    NSMutableArray *CommentArray_ForeignLand;
    NSMutableArray *LangArray_ForeignLand;
    NSMutableArray *LatArray_ForeignLand;
    NSMutableArray *LongArray_ForeignLand;
    NSMutableArray *PostIDArray_FOreignLand;
    NSMutableArray *CheckLikeArray_ForeignLand;
    NSMutableArray *Activities_profile_photoArray_ForeignLand;
    NSMutableArray *Activities_typeArray_ForeignLand;
    NSMutableArray *Activities_uidArray_ForeignLand;
    NSMutableArray *Activities_usernameArray_ForeignLand;
    NSMutableArray *Location_DistanceArray_ForeignLand;
    NSMutableArray *Link_Array_ForeignLand;

    //Extra
    NSMutableArray *CategoryArray_Extra;
    NSMutableArray *LPhotoArray_Extra;
    NSMutableArray *TitleArray_Extra;
    NSMutableArray *place_nameArray_Extra;
    NSMutableArray *UserInfo_NameArray_Extra;
    NSMutableArray *UserInfo_UrlArray_Extra;
    NSMutableArray *UserInfo_AddressArray_Extra;
    NSMutableArray *UserInfo_uidArray_Extra;
    NSMutableArray *UserInfo_FollowingArray_Extra;
    NSMutableArray *LocationArray_Extra;
    NSMutableArray *FullPhotoArray_Extra;
    NSMutableArray *MessageArray_Extra;
    NSMutableArray *LikesArray_Extra;
    NSMutableArray *CommentArray_Extra;
    NSMutableArray *LangArray_Extra;
    NSMutableArray *LatArray_Extra;
    NSMutableArray *LongArray_Extra;
    NSMutableArray *PostIDArray_Extra;
    NSMutableArray *CheckLikeArray_Extra;
    NSMutableArray *Activities_profile_photoArray_Extra;
    NSMutableArray *Activities_typeArray_Extra;
    NSMutableArray *Activities_uidArray_Extra;
    NSMutableArray *Activities_usernameArray_Extra;
    NSMutableArray *Location_DistanceArray_Extra;
    NSMutableArray *Link_Array_Extra;
    
    //featured
    NSMutableArray *featured_userImgArray;
    NSMutableArray *featured_userUidArray;
    NSMutableArray *featured_usernameArray;
    
    IBOutlet UIView *ShowNoDataView;
    IBOutlet UIButton *RetryButton;
    
    NSTimer *GetNotifactionCountTimer;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_CheckNotification;
    UILabel *ShowBadgeText;
}
-(IBAction)NotificationButton:(id)sender;
-(IBAction)SettingsButton:(id)sender;
-(IBAction)PublishButton:(id)sender;
-(IBAction)SearchButton:(id)sender;

-(IBAction)RetryButton:(id)sender;
@end
