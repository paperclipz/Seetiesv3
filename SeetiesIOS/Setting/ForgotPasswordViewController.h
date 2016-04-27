//
//  ForgotPasswordViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface ForgotPasswordViewController : UIViewController<UITextFieldDelegate>{

    IBOutlet UITextField *InputText;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    IBOutlet UIButton *ResetButton;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *DetailLabel;
    IBOutlet UIImageView *LogoImg;
    IBOutlet UIButton *BackGroundButton;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)resetButton:(id)sender;
@end
