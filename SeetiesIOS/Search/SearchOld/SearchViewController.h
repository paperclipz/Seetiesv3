//
//  SearchViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/15/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GAITrackedViewController.h"
@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{

    IBOutlet UITableView *tblview;
    IBOutlet UITextField *SearchText;
    IBOutlet UIView *Show2ndView;
    IBOutlet UILabel *ShowSearchPPLText;
    IBOutlet UILabel *ShowLocationText;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *ShowPPLText;
    IBOutlet UILabel *ShowSearchTitle;
    IBOutlet UILabel *FindPPLName;
    
    NSMutableArray *CategoryNameArray;
    NSMutableArray *CategoryImageArray;
    NSMutableArray *IDNArray;
    
    NSString *GetLat;
    NSString *GetLang;
    NSString *GetSearchText;
    
    NSMutableData *webData;
    NSURLConnection *theConnection_GetIPAddress;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)ChangeSearchLocationButton:(id)sender;

-(IBAction)SearchPPLButton:(id)sender;

@end
