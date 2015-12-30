//
//  SearchViewV2.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 3/11/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@interface SearchViewV2 : GAITrackedViewController<UIScrollViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *SUGGESTEDText;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *SearchBar;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *SelectCategoryArray;
    NSMutableArray *BackgroundColorArray;
    NSMutableArray *SelectBackgroundColorArray;
    NSMutableArray *CategoryIDArray;
    NSMutableArray *SelectCategoryIDArray;
    
    IBOutlet UIImageView *SearchIcon;
    IBOutlet UITextField *EnterKeywordHere;
    IBOutlet UIButton *Line01;
    IBOutlet UILabel *ORADDACATEGORYBELOW;
    
    IBOutlet UIView *ShowSearchLocationView;
    IBOutlet UITextField *SearchLocation;
    IBOutlet UITableView *LocationTblView;
    
    IBOutlet UITableView *SuggestionTblView;
    
    NSString *GetLat;
    NSString *GetLang;
    NSString *GetLocationName;
    
    NSMutableData *webData;
    NSURLConnection *theConnection_GetLocation;
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GetSearchPlace;
    NSURLConnection *theConnection_GetSearchString;
    
    NSMutableArray *LocationNameArray;
    NSMutableArray *LocationLatArray;
    NSMutableArray *LocationLongArray;
    
    NSMutableArray *SearchLocationNameArray;
    NSMutableArray *SearchPlaceIDArray;
    NSString *GetSearchPlaceID;
    
    IBOutlet UIView *ShowSearchTextOrPPLView;
    
    IBOutlet UIButton *MainSearchButton;
    
    NSMutableArray *LocalSuggestionTextArray;
    
    NSString *SearchString;
    
    UrlDataClass *DataUrl;

}
-(IBAction)MainSearchButton:(id)sender;

@end
