//
//  EnbleLocationViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 10/1/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnbleLocationViewController : UIViewController{

    IBOutlet UIImageView *ShowNearbyImg;
    
    IBOutlet UILabel *ShowText;
    IBOutlet UILabel *ShowSettingText;
    
    IBOutlet UIButton *AllowButton;
    IBOutlet UIButton *NotNowButton;
}

-(IBAction)NotNowButtonOnLCilck:(id)sender;
-(IBAction)AllowButtonOnClick:(id)sender;

@end
