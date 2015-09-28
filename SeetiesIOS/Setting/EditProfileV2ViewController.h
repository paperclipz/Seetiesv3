//
//  EditProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/1/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface EditProfileV2ViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *SaveButton;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet AsyncImageView *BackgroundImg;
    IBOutlet AsyncImageView *UserImg;
    
    IBOutlet UIButton *BackgroundImgButton;
    IBOutlet UIButton *UserImgButton;
    
    IBOutlet UIActivityIndicatorView *spinnerView;
    
    NSString *GetWallpaper;
    NSString *GetProfileImg;
    NSString *GetUserName;
    NSString *GetName;
    NSString *GetLink;
    NSString *GetDescription;
    NSString *GetLocation;
    NSString *Getdob;
    NSString *GetGender;
    NSString *GetPersonalTags;
    
    NSMutableArray *GenderArray;
    
    int ButtonOnClick;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_Update;
    
    IBOutlet UITextField *UserNameField;
    IBOutlet UITextField *NameField;
    IBOutlet UITextField *LinkField;
    IBOutlet UITextField *TagasField;
    IBOutlet UITextView *DescriptionField;
    
    IBOutlet UITextField *LocationField;
    IBOutlet UITextField *GenderField;
    IBOutlet UITextField *DOBField;
    
    UIToolbar *Toolbar;
    UIPickerView *Gender_PickerView;
    UIDatePicker *Birthday_Picker;
    
    IBOutlet UIImageView *CaretLocationImg;
    
}
-(IBAction)BackButton:(id)sender;
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackgroundImgOnClick:(id)sender;
-(IBAction)UserImgOnClick:(id)sender;

-(IBAction)BirthdayButtonOnClick:(id)sender;
-(IBAction)LocationButtonOnClick:(id)sender;
-(IBAction)GenderButtonOnClick:(id)sender;
@end
