//
//  WhereIsThisViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/24/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface WhereIsThisViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>{
    
    IBOutlet UITextField *SearchField;
    IBOutlet UITableView *NearByTableView;
    IBOutlet UITableView *SearchTableView_Google;
    IBOutlet UITableView *SearchTableView_Four;
    IBOutlet UIView *ShowSearchView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UIView *ReturnView;
    IBOutlet UILabel *ReturnAddressText;
    IBOutlet UIButton *NextButton;
    
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *SearchBox;
    IBOutlet UIButton *LineButton;

    NSString *GetLatPoint;
    NSString *GetLongPoint;
    
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
    NSMutableArray *DistanceArray;

    NSMutableArray *NameArray;
    NSMutableArray *UrlArray;
    //Opening Hours
    NSMutableArray *isOpenArray;
    NSMutableArray *HourStatusArray;
    //Price
    NSMutableArray *CurrencyArray;
    NSMutableArray *PriceMessageArray;
    NSMutableArray *TierArray;
    //contact
    NSMutableArray *FormattedPhoneArray;
    NSMutableArray *PhoneArray;
    NSMutableArray *FacebookNameArray;
    
    NSMutableData *webData;
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GooglePlaceDetail;
    
    //Search Google
    NSMutableArray *Search_AddressArray;
    NSMutableArray *Search_NameArray;
    NSMutableArray *Search_PlaceIDArray;
    
    NSInteger CheckSelectWhichOne;
    
    //Search Foursquare
    NSMutableArray *GetLocationArray_Search;
    NSMutableArray *AddressArray_Search;
    NSMutableArray *CityArray_Search;
    NSMutableArray *CountryArray_Search;
    NSMutableArray *latArray_Search;
    NSMutableArray *lngArray_Search;
    NSMutableArray *StateArray_Search;
    NSMutableArray *formattedAddressArray_Search;
    NSMutableArray *GetreferralIdArray_Search;
    NSMutableArray *postalCodeArray_Search;
    NSMutableArray *DistanceArray_Search;
    
    NSMutableArray *NameArray_Search;
    NSMutableArray *UrlArray_Search;
    //Opening Hours
    NSMutableArray *isOpenArray_Search;
    NSMutableArray *HourStatusArray_Search;
    //Price
    NSMutableArray *CurrencyArray_Search;
    NSMutableArray *PriceMessageArray_Search;
    NSMutableArray *TierArray_Search;
    //contact
    NSMutableArray *FormattedPhoneArray_Search;
    NSMutableArray *PhoneArray_Search;
    NSMutableArray *FacebookNameArray_Search;
    
    NSString *TempAddress;
    NSString *CheckBackView;
    
    IBOutlet UIButton *GoogleButton;
    IBOutlet UIButton *FoursquareButton;
    IBOutlet UIImageView *LineImage;
    IBOutlet UIImageView *ArrowImage;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *Shownearby;
    
    NSString *GetPlaceID;
    
    NSInteger Check;
    
    NSString *GetGooglePlaceName;
}
-(void)GetCheckBackView:(NSString *)CheckView;
-(IBAction)BackButton:(id)sender;
-(IBAction)ConfirmButton:(id)sender;
-(IBAction)NextButton:(id)sender;

-(IBAction)GoogleButton:(id)sender;
-(IBAction)FoursquareButton:(id)sender;
@end
