//
//  SearchDetailViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/3/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
//#import "GAITrackedViewController.h"
#import "ProfileViewController.h"
@class ProfileViewController;
@interface SearchDetailViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)ProfileViewController* profileViewController;
-(void)GetSearchKeyword:(NSString *)Keyword Getlat:(NSString *)lat GetLong:(NSString *)Long GetLocationName:(NSString *)LocationName GetCurrentLat:(NSString *)CurrentLat GetCurrentLong:(NSString *)CurrentLong;
-(void)GetTitle:(NSString *)String;
-(IBAction)SortbyButton:(id)sender;
@end
