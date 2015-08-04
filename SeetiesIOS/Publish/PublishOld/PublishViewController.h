//
//  PublishViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface PublishViewController : GAITrackedViewController<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIView *ShowSelectLangView;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIImageView *ShowSelectLangImage;
    
    IBOutlet UIImageView *ShowCategoryImage;
    IBOutlet UIImageView *ShowSelectCategoryImage;
    IBOutlet UILabel *ShowCooseCategoryText;
    
    UIToolbar *Toolbar;
    UIPickerView *Lang_PickerView;
    NSMutableArray *LangArray;
    NSMutableArray *LangIDArray;
    NSString *GetLang;
    NSString *GetLangID;
    
    IBOutlet UITextField *TitleField;
    IBOutlet UITextView *DescriptionField;
    IBOutlet UILabel *ShowTextCount;
    
    IBOutlet UIImageView *ShowImage;
    
    IBOutlet UIImageView *Publish_Back_2;
    IBOutlet UIImageView *ExtrasGotDataImg_2;
    IBOutlet UIButton *AddLocationButton;
    IBOutlet UIButton *ExtrasButton;
    IBOutlet UILabel *ShowTitleName;
    IBOutlet UILabel *ShowAddress;
    IBOutlet UIButton *ShowImgCount;
    BOOL gotdata;
    
    NSMutableArray *GetImgArray;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *StatusString;
    
    IBOutlet UIButton *PublishButton;
    IBOutlet UILabel *SelectPhotoText;
    
    NSString *UpdatePostCheck;
    NSString *GetPostID;
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID;
-(IBAction)BackButton:(id)sender;
-(IBAction)SelectCategoryButton:(id)sender;
-(IBAction)SelectImagesButton:(id)sender;
-(IBAction)AddLocationButton:(id)sender;
-(IBAction)ExtrasButton:(id)sender;

-(IBAction)SelectLangButton:(id)sender;

-(IBAction)PublishButton:(id)sender;

-(void)PostAllDataToServer;
@end
