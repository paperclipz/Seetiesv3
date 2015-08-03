//
//  Explore2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "DoImagePickerController.h"
@interface Explore2ViewController : UIViewController<UIScrollViewDelegate,DoImagePickerControllerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UISearchBar *mySearchBar;
    IBOutlet UIButton *MainLine;
    
    NSString *GetSearchText;
    
    IBOutlet UIScrollView *CountriesScroll;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *CountryIDArray;
    NSMutableArray *NameArray;
    NSMutableArray *SeqNoArray;
    NSMutableArray *ThumbnailArray;
    
    NSURLConnection *theConnection_All;
    NSURLConnection *theConnection_GetSearchString;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UITableView *SearchTblView;
    
    NSMutableArray *LocalSearchTextArray;
    
    NSMutableArray *GetReturnSearchTextArray;
    NSMutableArray *GetReturnSearchAddressArray;
    NSMutableArray *GetReturnSearchLatArray;
    NSMutableArray *GetReturnSearchLngArray;
    
    NSInteger CheckTblview;
}
-(void)GetExploreDataFromServer;
-(void)InitCountriesView;
@end
