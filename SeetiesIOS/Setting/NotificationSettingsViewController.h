//
//  NotificationSettingsViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/2/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationSettingsViewController : UIViewController{

    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
}
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackButton:(id)sender;
@end
