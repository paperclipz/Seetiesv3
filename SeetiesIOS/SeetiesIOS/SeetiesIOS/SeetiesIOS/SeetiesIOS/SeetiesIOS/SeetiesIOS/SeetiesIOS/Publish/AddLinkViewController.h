//
//  AddLinkViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/7/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AddLinkViewController : GAITrackedViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *AddContactField;
    NSString *GetDataLink;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    
    IBOutlet UIButton *BackButton;
    IBOutlet UIButton *SaveButton;
    
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *WhiteBackground;
}
-(void)GetWhatLink:(NSString *)GetLink;
-(IBAction)BackButton:(id)sender;
-(IBAction)SaveButton:(id)sender;

@end
