//
//  AddPriceViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/31/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AddPriceViewController : GAITrackedViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    IBOutlet UITextField *AddPriceField;
    
    NSMutableArray *ISO4217Array;
    NSMutableArray *IOS4217NumArray;
    
    NSString *GetCountryNum;
    NSString *GetCountryShow;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    
    IBOutlet UIButton *BackButton;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIButton *PriceButton;
    
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *WhiteBackground;
    IBOutlet UILabel *ShowPerPax;
    
    UIToolbar *Toolbar;
    UIPickerView *SelectPrice_PickerView;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SaveButton:(id)sender;

-(IBAction)SelectPrice:(id)sender;
@end
