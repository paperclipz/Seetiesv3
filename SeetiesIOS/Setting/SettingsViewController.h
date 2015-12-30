//
//  SettingsViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface SettingsViewController : GAITrackedViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *Title_Account;
    IBOutlet UILabel *EditProfile;
    IBOutlet UILabel *EditInterests;
    IBOutlet UILabel *AccountSetting;
    IBOutlet UILabel *FindInviteFriends;
    
    IBOutlet UILabel *Title_Support;
    IBOutlet UILabel *AboutSeeties;
    IBOutlet UILabel *TermOfUse;
    IBOutlet UILabel *PrivacyPolicy;
    IBOutlet UILabel *Feedback;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_logout;
    
    IBOutlet UITableView *tblview;
    
    NSMutableArray *dataArray;
    
}
-(IBAction)BackButton:(id)sender;

@end
