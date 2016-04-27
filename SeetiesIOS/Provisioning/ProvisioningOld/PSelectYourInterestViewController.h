//
//  PSelectYourInterestViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface PSelectYourInterestViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    
    IBOutlet UIButton *SelectAllBtn;
    IBOutlet UIButton *ContiuneBtn;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *IDNArray;
    NSMutableArray *CategoryNameArray;
    
    NSMutableArray *SelectIDNArray;
    NSMutableArray *SelectCategoryNameArray;
    NSString *GetSelectCategoryString;
    NSString *GetSelectCategoryIDN;
    
    int checkSelectData;
    
    IBOutlet UILabel *ShowTitle;
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *CategorySelectIDArray;
    

}
-(IBAction)SelectAllButton:(id)sender;
-(IBAction)ContiuneButton:(id)sender;

@end
