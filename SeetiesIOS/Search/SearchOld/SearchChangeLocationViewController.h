//
//  SearchChangeLocationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/15/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface SearchChangeLocationViewController : GAITrackedViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
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
    
    NSString *latPoint;
    NSString *lonPoint;
}
-(IBAction)CurrentLocationButton:(id)sender;
-(IBAction)BackButton:(id)sender;
@end
