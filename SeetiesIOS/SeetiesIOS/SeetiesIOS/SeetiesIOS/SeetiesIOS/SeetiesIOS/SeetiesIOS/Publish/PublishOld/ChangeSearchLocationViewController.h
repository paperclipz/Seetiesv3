//
//  ChangeSearchLocationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/30/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface ChangeSearchLocationViewController : GAITrackedViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UITextField *SearchLocationField;
    NSMutableData *webData;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UITableView *tblview;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIButton *CurrentLocationButton;
    IBOutlet UILabel *SubTitle;
    
    NSMutableArray *NameArray;
    NSMutableArray *LatArray;
    NSMutableArray *LongArray;
    NSMutableArray *address_componentsArray;
    NSMutableArray *PlaceIDArray;
    NSMutableArray *ReferenceArray;
    
    NSString *latPoint;
    NSString *lonPoint;
    
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GpsLocation;
    NSURLConnection *theConnection_SearchPlace;
    
    NSInteger CheckTbl;
    
    NSString *GetPlaceID;
}
-(IBAction)CurrentLocationButton:(id)sender;
@end
