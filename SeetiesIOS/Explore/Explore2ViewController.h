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
@interface Explore2ViewController : BaseViewController<UIScrollViewDelegate,DoImagePickerControllerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{


    
    NSString *GetSearchText;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_GetSearchString;
    
    
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
