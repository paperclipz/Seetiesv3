//
//  PSearchLocationViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/21/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchLocationDelegate <NSObject>

- (void)DidSelectLocation:(NSDictionary *)locationData;

@end

@interface PSearchLocationViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITextField *SearchLocationField;
    NSMutableData *webData;
    IBOutlet UILabel *ShowTitle;
    IBOutlet UITableView *tblview;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *SearchBar;
    IBOutlet UIButton *LineButton;
    
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
    
    NSMutableDictionary *address_dictionary; //new variable
}

@property (weak, nonatomic) id<searchLocationDelegate> delegate;

-(IBAction)CurrentLocationButton:(id)sender;
@end
