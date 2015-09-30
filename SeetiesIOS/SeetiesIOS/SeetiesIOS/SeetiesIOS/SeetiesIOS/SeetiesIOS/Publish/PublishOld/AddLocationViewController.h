//
//  AddLocationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AddLocationViewController : GAITrackedViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{

    IBOutlet UITextField *SearchField;
    IBOutlet UIView *ShowNearbySuggestionsView;
    IBOutlet UIView *ShowSearchView;
    IBOutlet UIButton *ShowNearbySuggestionsButton;
    IBOutlet UITableView *tblview;
    IBOutlet UITableView *tblview_Search;
    
    IBOutlet UIActivityIndicatorView *ShowNearByActivity;
    IBOutlet UIActivityIndicatorView *ShowSearchActivity;
    
    IBOutlet UILabel *ShowNearbySuggestionsText;
    
    NSMutableArray *GetLocationArray;
    NSMutableArray *AddressArray;
    NSMutableArray *CityArray;
    NSMutableArray *CountryArray;
    NSMutableArray *latArray;
    NSMutableArray *lngArray;
    NSMutableArray *StateArray;
    NSMutableArray *formattedAddressArray;
    NSMutableArray *GetreferralIdArray;
    NSMutableArray *postalCodeArray;
    
    IBOutlet UIImageView *ShowTitleBar;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *NearbySuggestionLabel;
    IBOutlet UILabel *SearchResults;
    
}
-(IBAction)BackButton:(id)sender;
-(IBAction)NearbySuggestionsButton:(id)sender;
@end
