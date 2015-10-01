//
//  ReportViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/25/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "UrlDataClass.h"
@interface ReportViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
    IBOutlet UITextView *DescriptionText;
    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UIButton *InappropriateButton;
    IBOutlet UIButton *CopyrightButton;
    
    IBOutlet UIImageView *SelectedInappropriate;
    IBOutlet UIImageView *SelectedCopyright;
    
    int CheckStatus;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_Report;
    
    NSString *GetPostID;
    
    IBOutlet UILabel *ShowInappropriate;
    IBOutlet UILabel *ShowCopyright;
    IBOutlet UILabel *ShowOther;
}
-(void)GetPostID:(NSString *)PostID;
@end
