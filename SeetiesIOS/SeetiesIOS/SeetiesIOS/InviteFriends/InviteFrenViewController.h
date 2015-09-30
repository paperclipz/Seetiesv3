//
//  InviteFrenViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MessageUI/MessageUI.h>
#import "UrlDataClass.h"

@interface InviteFrenViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>{

    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    IBOutlet UITableView *EmailTblView;
    IBOutlet UIView *ShowInviteView;
    IBOutlet UIView *ShowFBView;
    IBOutlet UIView *ShowEmailView;
    
    IBOutlet UIButton *TabButton_1;
    IBOutlet UIButton *TabButton_2;
    IBOutlet UIButton *TabButton_3;
    
    IBOutlet UILabel *ShowFBText_1;
    IBOutlet UIButton *FbButton;
    
    IBOutlet UILabel *ShowOtherText_1;
    IBOutlet UIButton *FbMessagerButton;
    IBOutlet UIButton *WhatsappButton;
    IBOutlet UIButton *TrueLineButton;
    IBOutlet UIButton *SMSButton;
    
    IBOutlet UIButton *LineButton;
    
    IBOutlet UIButton *LoadingButton;
     IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *InviteScroll;
    
    NSMutableArray *AllEmailDataArray;
    NSMutableArray *FullNameDataArray;
    
    NSString *GetEmail;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_GetAllUserData;
    NSURLConnection *theConnection_SendFollowData;
    NSURLConnection *theConnection_SendAllFollow;
    NSURLConnection *theConnection_GetContactUserData;
    NSURLConnection *theConnection_UpdateFBToSever;
    
    NSMutableArray *All_Experts_Username_Array;
    NSMutableArray *All_Experts_Location_Array;
    NSMutableArray *All_Experts_ProfilePhoto_Array;
    NSMutableArray *All_Experts_uid_Array;
    NSMutableArray *All_Experts_Followed_Array;
    
    NSInteger InviteEmailCheck;
    NSInteger GetSelectIDN;
    
    UIButton *TempButton;
    UIImageView *ShowFBInviteIcon;
    
    int CheckFollowAllButton;
    int CheckFollowFBAllButton;
    int CheckWhichOneOnClick;
    
    NSString *UserEmail;
    NSString *UserName;
    NSString *GetFB_ID;
    NSString *GetFB_Token;
    NSString *Name;
    NSString *Userdob;
    NSString *UserGender;
    
    NSMutableArray *FB_Experts_Username_Array;
    NSMutableArray *FB_Experts_ProfilePhoto_Array;
    NSMutableArray *FB_Experts_uid_Array;
    NSMutableArray *FB_Experts_Followed_Array;
    NSMutableArray *FB_Experts_Name_Array;
    
    NSString *SendMessage;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    BOOL CheckLoad;
    int GetHeight;
    int CheckFirstTimeLoad;
}
-(IBAction)TabButton_1:(id)sender;
-(IBAction)TabButton_2:(id)sender;
-(IBAction)TabButton_3:(id)sender;
@end
