//
//  EditInterestViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
#import "LLARingSpinnerView.h"
@interface EditInterestViewController : UIViewController<UIScrollViewDelegate>{
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    int checkSelectData;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *CategorySelectIDArray;
    
    LLARingSpinnerView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
}
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackButton:(id)sender;

@end
