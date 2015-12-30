//
//  ShowFollowerAndFollowingViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface ShowFollowerAndFollowingViewController : GAITrackedViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    NSString *GetToken;
    NSString *Getuid;
    NSString *GetType;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *User_LocationArray;
    NSMutableArray *User_NameArray;
    NSMutableArray *User_UserNameArray;
    NSMutableArray *User_ProfilePhotoArray;
    NSMutableArray *User_UIDArray;
    NSMutableArray *User_FollowedArray;
    
    
    NSURLConnection *theConnection_GetFollower;
    NSURLConnection *theConnection_GetFollowing;
    NSURLConnection *theConnection_SendFollowData;
    
    NSInteger DataTest;
    
    NSInteger GetSelectIDN;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    int CheckFirstTimeLoad;
}
-(void)GetToken:(NSString *)Token GetUID:(NSString *)uid GetType:(NSString *)Type;
-(IBAction)BackButton:(id)sender;
@end
