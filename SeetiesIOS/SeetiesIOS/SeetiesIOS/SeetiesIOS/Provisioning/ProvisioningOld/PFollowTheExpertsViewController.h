//
//  PFollowTheExpertsViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/20/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UrlDataClass.h"
@class LeveyTabBarController;
@interface PFollowTheExpertsViewController : GAITrackedViewController<UIScrollViewDelegate>{
    
    LeveyTabBarController *leveyTabBarController;

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *iPhone4Scroll;
    IBOutlet UIScrollView *iPhone6Scroll;
    IBOutlet UIScrollView *iPhone6PlusScroll;
    IBOutlet UIPageControl *pageControl;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_UpdateData;
    
    IBOutlet UIButton *SkipButton_01_568;
    IBOutlet UIButton *SkipButton_01_480;
    IBOutlet UIButton *SkipButton_02_568;
    IBOutlet UIButton *SkipButton_02_480;
    IBOutlet UIButton *SkipButton_03_568;
    IBOutlet UIButton *SkipButton_03_480;
    IBOutlet UIButton *SkipButton_04_568;
    IBOutlet UIButton *SkipButton_04_480;
    IBOutlet UIButton *DoneButton_568;
    IBOutlet UIButton *DoneButton_480;
    
    IBOutlet UILabel *WelcometoSeeties_568;
    IBOutlet UILabel *WelcometoSeeties_480;
    IBOutlet UILabel *Seewhypeopleloveus_568;
    IBOutlet UILabel *Seewhypeopleloveus_480;
    IBOutlet UILabel *Slideformore_568;
    IBOutlet UILabel *Slideformore_480;
    
    IBOutlet UILabel *Recommend_480;
    IBOutlet UILabel *Shareyourstories_480;
    IBOutlet UILabel *Friends_480;
    IBOutlet UILabel *Seewhatyourfriends_480;
    IBOutlet UILabel *AnewWay_480;
    IBOutlet UILabel *Eatwhere_480;
    IBOutlet UILabel *Allofyour_480;
    IBOutlet UILabel *Keepyourbestcity_480;
    
    IBOutlet UILabel *Recommend_568;
    IBOutlet UILabel *Shareyourstories_568;
    IBOutlet UILabel *Friends_568;
    IBOutlet UILabel *Seewhatyourfriends_568;
    IBOutlet UILabel *AnewWay_568;
    IBOutlet UILabel *Eatwhere_568;
    IBOutlet UILabel *Allofyour_568;
    IBOutlet UILabel *Keepyourbestcity_568;
    
    IBOutlet UIButton *SkipButton_01_iPH6;
    IBOutlet UIButton *SkipButton_01_iPH6Plus;
    IBOutlet UIButton *SkipButton_02_iPH6;
    IBOutlet UIButton *SkipButton_02_iPH6Plus;
    IBOutlet UIButton *SkipButton_03_iPH6;
    IBOutlet UIButton *SkipButton_03_iPH6Plus;
    IBOutlet UIButton *SkipButton_04_iPH6;
    IBOutlet UIButton *SkipButton_04_iPH6Plus;
    IBOutlet UIButton *DoneButton_iPH6;
    IBOutlet UIButton *DoneButton_iPH6Plus;
    
    IBOutlet UILabel *WelcometoSeeties_iPH6;
    IBOutlet UILabel *WelcometoSeeties_iPH6Plus;
    IBOutlet UILabel *Seewhypeopleloveus_iPH6;
    IBOutlet UILabel *Seewhypeopleloveus_iPH6Plus;
    IBOutlet UILabel *Slideformore_iPH6;
    IBOutlet UILabel *Slideformore_iPH6Plus;
    
    IBOutlet UILabel *Recommend_iPH6Plus;
    IBOutlet UILabel *Shareyourstories_iPH6Plus;
    IBOutlet UILabel *Friends_iPH6Plus;
    IBOutlet UILabel *Seewhatyourfriends_iPH6Plus;
    IBOutlet UILabel *AnewWay_iPH6Plus;
    IBOutlet UILabel *Eatwhere_iPH6Plus;
    IBOutlet UILabel *Allofyour_iPH6Plus;
    IBOutlet UILabel *Keepyourbestcity_iPH6Plus;
    
    IBOutlet UILabel *Recommend_iPH6;
    IBOutlet UILabel *Shareyourstories_iPH6;
    IBOutlet UILabel *Friends_iPH6;
    IBOutlet UILabel *Seewhatyourfriends_iPH6;
    IBOutlet UILabel *AnewWay_iPH6;
    IBOutlet UILabel *Eatwhere_iPH6;
    IBOutlet UILabel *Allofyour_iPH6;
    IBOutlet UILabel *Keepyourbestcity_iPH6;
    
    IBOutlet UIImageView *TourImage01;
    
    NSString *latPoint;
    NSString *lonPoint;
}
-(IBAction)SkipButton01:(id)sender;
-(IBAction)SkipButton02:(id)sender;
-(IBAction)SkipButton03:(id)sender;
-(IBAction)SkipButton04:(id)sender;
-(IBAction)DoneButton:(id)sender;
@end
