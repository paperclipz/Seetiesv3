//
//  PTellUsYourCityViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTellUsYourCityViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *MainScorll;
    IBOutlet UILabel *ShowSelectLang01;
    IBOutlet UILabel *ShowSelectLang02;
    IBOutlet UILabel *ShowLocation;
    IBOutlet UIButton *SkipButton;
    IBOutlet UIImageView *backgroundLocation;
    IBOutlet UIImageView *backgroundLanguage;

    UIToolbar *Toolbar;
    UIPickerView *Language_PickerView;
    
    NSMutableArray *LanguageArray;
    NSMutableArray *LanguageIDArray;
    
    int CheckSelectLang;
    
    NSString *GetSelectLang01;
    NSString *GetSelectLang02;
    
    NSString *GetSelectLangText01;
    NSString *GetSelectLangText02;
    
    IBOutlet UILabel *ShowTitle_City;
    IBOutlet UILabel *ShowSubTitle_City;
    
    IBOutlet UILabel *ShowTitle_Lang;
    IBOutlet UILabel *ShowSubTitle_Lang;
    
    IBOutlet UIButton *CantinueButton;
    
    IBOutlet UILabel *ShowPrimary;
    IBOutlet UILabel *ShowSecondary;
    
    IBOutlet UIButton *SelectLangButton01;
    IBOutlet UIButton *SelectLangButton02;
}
-(IBAction)ContinueButton:(id)sender;
-(IBAction)SkipButton:(id)sender;
-(IBAction)SelectLangButton01:(id)sender;
-(IBAction)SelectLangButton02:(id)sender;
-(IBAction)SearchLocationButton:(id)sender;
@end
