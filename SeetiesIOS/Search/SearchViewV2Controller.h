//
//  SearchViewV2Controller.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
@interface SearchViewV2Controller : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{

    IBOutlet UISearchBar *mySearchBar;
    IBOutlet UITableView *Tblview;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIScrollView *SearchScroll;
    
    NSString *GetSearchText;
    
    NSMutableArray *LocalSearchTextArray;
    
    NSInteger CheckTblview;
    
    NSMutableArray *GetReturnSearchTextArray;
    NSMutableArray *GetReturnSearchAddressArray;
    NSMutableArray *GetReturnSearchLatArray;
    NSMutableArray *GetReturnSearchLngArray;
    
    NSMutableArray *GetSearchArray;
    
    NSURLConnection *theConnection_GetSearchString;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    int ButtonOnClickCheck;
    

}

@end
