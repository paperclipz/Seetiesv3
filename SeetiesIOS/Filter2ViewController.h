//
//  Filter2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 5/18/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface Filter2ViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate>{

    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *ApplyFilterButton;
    IBOutlet UITableView *tblview;
    
    NSMutableArray *dataArray;
    NSIndexPath* checkedIndexPath_Sort;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *BackgroundColorArray;
    NSMutableArray *CategoryIDArray;
    NSMutableArray *SelectCategoryIDArray;
    NSMutableArray *GetImageArray1;
    
    NSMutableArray *SortImageArray;
    
    NSMutableArray *selectedIndexes;
    
    NSString *GetSortStringData;
    
    NSString *GetWhatViewCome;
    
    UIButton *SelectAllButton;
}
-(IBAction)BackButton:(id)sender;
-(void)GetWhatViewComeHere:(NSString *)WhatView;
-(IBAction)ApplyButton:(id)sender;
@end
