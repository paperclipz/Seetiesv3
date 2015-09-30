//
//  ShowImageViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/13/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "DoImagePickerController.h"
@interface ShowImageViewController : GAITrackedViewController<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate,DoImagePickerControllerDelegate>{
    IBOutlet UIScrollView *MainScroll;

    NSMutableArray *GetImageArray;
    NSMutableArray *GetImageDataArray;
    NSMutableArray *GetPhotoIDArray;
    NSMutableArray *PhotoPositionArray;
    NSMutableArray *CaptionArray;
    UIImage *tempImg;
    NSMutableArray *ImgArray;
    IBOutlet UIImageView *ShowBigImage;
    IBOutlet UIScrollView *SmallImgScroll;
    IBOutlet UITextView *CaptionField;
    IBOutlet UIButton *CaptionBackground;
    IBOutlet UIImageView *SmallArrowImage;
    
    NSMutableDictionary *TempDictonary;
    
    IBOutlet UIView *ShowMessageArrangeView;
    IBOutlet UIView *ArrangeBackgroundImg;
    
//    IBOutlet UIButton *SmallImgButton_01;
//    IBOutlet UIButton *SmallImgButton_02;
//    IBOutlet UIButton *SmallImgButton_03;
//    IBOutlet UIButton *SmallImgButton_04;
//    IBOutlet UIButton *SmallImgButton_05;
//    IBOutlet UIButton *SmallImgButton_06;
//    IBOutlet UIButton *SmallImgButton_07;
//    IBOutlet UIButton *SmallImgButton_08;
//    IBOutlet UIButton *SmallImgButton_09;
//    IBOutlet UIButton *SmallImgButton_10;
    
    NSInteger GetTag;
    
    UIButton *InitButton;
    
    IBOutlet UIButton *AddatagButton;
    IBOutlet UILabel *ShowTextCount;
    
    IBOutlet UIButton *DeleteButton;
    IBOutlet UIButton *CropButton;
    IBOutlet UIButton *BrightnessButton;
    
    NSInteger SelctImgCount;
    
    NSMutableArray *SendCaptionDataArray;
    NSMutableArray *TagStringArray;
    NSMutableArray *TagStringDataArray;
    NSMutableArray *CategorySelectIDArray;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSString *StatusString;
    NSString *TagString;
    NSString *CreateLocationJsonString;
    
    NSString *GetUpdatePost;
    NSString *GetPostID;
    
    IBOutlet UIButton *DoneButton;
    
    int GetHeight;
    
    IBOutlet UIButton *EditButton;
    
    IBOutlet UILabel *ShowHoldandDragText;
    
    NSMutableArray *DeletePhotoIDArray;
    
}
-(void)GetIsupdatePost:(NSString *)UpdatePost GetPostID:(NSString *)PostID;
-(IBAction)BackButton:(id)sender;
-(IBAction)CropButton:(id)sender;
-(IBAction)BrightnessButton:(id)sender;
//-(IBAction)TellaStoryButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
-(IBAction)DeleteButton:(id)sender;

-(IBAction)EditButton:(id)sender;

-(IBAction)OKButton:(id)sender;
@end
