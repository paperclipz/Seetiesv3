//
//  AddContactViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/31/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AddContactViewController : GAITrackedViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *AddContactField;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    
    IBOutlet UIButton *BackButton;
    IBOutlet UIButton *SaveButton;
    
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *WhiteBackground;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SaveButton:(id)sender;
@end
