//
//  NotificationSettingsViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingsViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
    
    IBOutlet UIScrollView *MainScroll;
    
    IBOutlet UISwitch *EmailSwitch;
    
    IBOutlet UISwitch *InvitedFriendsSwitch;
    IBOutlet UISwitch *FriendslikeSwitch;
    IBOutlet UISwitch *FriendsFollowedSwitch;
    IBOutlet UISwitch *FriendsSharedSwitch_1;
    IBOutlet UISwitch *FriendsSharedSwitch_2;
    
    IBOutlet UISwitch *SomeoneFollowedSwitch;
    IBOutlet UISwitch *SomeoneMentionedSwitch;
    IBOutlet UISwitch *SomeonelikedSwitch;
}
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackButton:(id)sender;
@end
