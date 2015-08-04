//
//  FilterViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 5/15/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface FilterViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *ApplyFilterButton;
    IBOutlet UIScrollView *MainScroll;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *BackgroundColorArray;
    NSMutableArray *CategoryIDArray;
    NSMutableArray *SelectCategoryIDArray;
    NSMutableArray *GetImageArray1;
    
    IBOutlet UILabel *SortByText;
    IBOutlet UILabel *CategoryText;
    
    IBOutlet UILabel *ShowPopular;
    IBOutlet UILabel *ShowDistance;
    IBOutlet UILabel *ShowRecent;
    
    IBOutlet UIButton *WhiteBack_1;
    IBOutlet UIButton *WhiteBack_2;
    IBOutlet UIButton *WhiteBack_3;

    UIImageView *SortbySelectImg;
    
    NSString *GetSortByString;
    
    NSString *GetWhatViewCome;
    
}
-(void)GetWhatViewComeHere:(NSString *)WhatView;
-(IBAction)BackButton:(id)sender;

-(IBAction)PopularButton:(id)sender;
-(IBAction)DistanceButton:(id)sender;
-(IBAction)RecentButton:(id)sender;

-(IBAction)ApplyButton:(id)sender;
@end
