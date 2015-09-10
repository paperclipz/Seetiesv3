//
//  SubmitProfileViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 1/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
@interface SubmitProfileViewController : GAITrackedViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>{

    IBOutlet UILabel *ShowTitle;
    IBOutlet UIImageView *ShowImage;
    IBOutlet UIButton *EditButton;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIImageView *BarImage;

    NSString *GetType;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
}
-(void)GetType:(NSString *)Type;
-(IBAction)SaveButton:(id)sender;
-(IBAction)EditButton:(id)sender;
@end
