//
//  SearchResultV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultV2ViewController : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UITextField *SearchTextField;
    IBOutlet UITextField *SearchAddressField;
    IBOutlet UIButton *FilterButton;
    
    UISegmentedControl *PostControl;
    
    IBOutlet UIScrollView *MainScroll;
    
    
    IBOutlet UIView *ShowSearchLocationView;
    IBOutlet UITableView *LocationTblView;
    
    NSMutableArray *SearchLocationNameArray;
    NSMutableArray *SearchPlaceIDArray;
    NSString *GetSearchPlaceID;
    
    NSURLConnection *theConnection_SearchLocation;
    NSURLConnection *theConnection_GetSearchPlace;
}
-(IBAction)CancelButton:(id)sender;
@end
