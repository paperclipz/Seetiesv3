//
//  FeedbackViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface FeedbackViewController : GAITrackedViewController<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>{
    
    IBOutlet TPKeyboardAvoidingScrollView *Scrollview;
    IBOutlet UITextField *EmailField;
    IBOutlet UITextView *FeedbackField;
    IBOutlet UIImageView *AddImageDone;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UIButton *SubmitButton;
    IBOutlet UIButton *AddImageButton;
    IBOutlet UIImageView *BarImage;
    
    NSString *SystemString;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;

    UIImage *GetImageData;
    
    IBOutlet UIButton *TextBack;
    IBOutlet UIImageView *LoginBack;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)AddImageButton:(id)sender;
-(IBAction)SubmitButton:(id)sender;
@end
