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
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MessageUI/MessageUI.h>
#import "UrlDataClass.h"
#import "ProfileViewController.h"
@class ProfileViewController;
@interface InviteFrenViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,FBSDKAppInviteDialogDelegate,MFMailComposeViewControllerDelegate,UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>



@end
