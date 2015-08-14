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
@interface Explore2ViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIImageView *BarImage;
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
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
}
-(void)GetExploreDataFromServer;
-(void)InitCountriesView;
@end
