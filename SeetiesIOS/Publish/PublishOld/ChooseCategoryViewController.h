//
//  ChooseCategoryViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

#import "UrlDataClass.h"
@interface ChooseCategoryViewController : GAITrackedViewController{

    IBOutlet UIButton *ArtBtn;
    IBOutlet UIButton *BeautyBtn;
    IBOutlet UIButton *FoodBtn;
    IBOutlet UIButton *KitchenBtn;
    IBOutlet UIButton *NightlifeBtn;
    IBOutlet UIButton *OutdoorBtn;
    IBOutlet UIButton *ProductBtn;
    IBOutlet UIButton *StaycationBtn;
    IBOutlet UIButton *CultureBtn;
    
    IBOutlet UIButton *DoneButn;
    
    NSString *GetSelectCategoryString;
    NSString *GetSelectCategoryIDN;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *IDNArray;
    NSMutableArray *CategoryNameArray;
    
    IBOutlet UILabel *ShowArt;
    IBOutlet UILabel *ShowBeauty;
    IBOutlet UILabel *ShowFood;
    IBOutlet UILabel *ShowKitchen;
    IBOutlet UILabel *ShowNightlife;
    IBOutlet UILabel *ShowOutdoor;
    IBOutlet UILabel *ShowProduct;
    IBOutlet UILabel *ShowStaycation;
    IBOutlet UILabel *ShowCulture;
    
    IBOutlet UILabel *ShowTitle;
    
}
-(IBAction)ArtButton:(id)sender;
-(IBAction)BeautyButton:(id)sender;
-(IBAction)FoodButton:(id)sender;
-(IBAction)KitchenButton:(id)sender;
-(IBAction)NightlifeButton:(id)sender;
-(IBAction)OutdoorButton:(id)sender;
-(IBAction)ProductButton:(id)sender;
-(IBAction)StaycationButton:(id)sender;
-(IBAction)CultureButton:(id)sender;
-(IBAction)BackButton:(id)sender;

-(IBAction)DoneButton:(id)sender;

-(void)GetAllcategory;
@end
