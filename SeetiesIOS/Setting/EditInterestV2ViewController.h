//
//  EditInterestV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/14/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
@interface EditInterestV2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIImageView *BarImage;
    
    IBOutlet UITableView *Tblview;

    NSMutableArray *CategoryArray;
    NSMutableArray *BackgroundColorArray;
    NSMutableArray *CategoryIDArray;
    NSMutableArray *SelectCategoryIDArray;
    NSMutableArray *GetImageDefaultArray;
    NSMutableArray *GetImageSelectedArray;
    
    NSMutableArray *selectedIndexes;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    IBOutlet UIActivityIndicatorView *spinnerView;
    UIButton *LoadingBlackBackground;
    UILabel *ShowLoadingText;
}
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackButton:(id)sender;
@end
