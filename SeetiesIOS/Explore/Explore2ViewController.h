//
//  Explore2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
@interface Explore2ViewController : BaseViewController<UIScrollViewDelegate>{
    NSString *GetSearchText;
    
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;

    NSMutableArray *CountryIDArray;
    NSMutableArray *NameArray;
    NSMutableArray *SeqNoArray;
    NSMutableArray *ThumbnailArray;
    
    NSURLConnection *theConnection_All;
    
    //no connection view
    IBOutlet UIView *NoConnectionView;
    IBOutlet UILabel *ShowNoConnectionText;
    IBOutlet UIImageView *NoConnectionImg;
    IBOutlet UIButton *TryAgainButton;
    
    IBOutlet UIButton *SearchButton;
    NSMutableArray *FestivalUrlArray;
    NSMutableArray *FestivalImageArray;
    

}
-(IBAction)TryAgainButton:(id)sender;
-(void)GetExploreDataFromServer;
-(void)InitCountriesView;

-(IBAction)SearchButton:(id)sender;
@end
