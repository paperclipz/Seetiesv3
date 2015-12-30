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
    IBOutlet UIPageControl *pageControl;

    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_UpdateData;
    
    NSString *latPoint;
    NSString *lonPoint;
    
    IBOutlet UIView *Feed1View;
    IBOutlet UIImageView *Feed1Img;
    IBOutlet UIButton *Feed1DoneButton;
    IBOutlet UILabel *Feed1_nearby;
    IBOutlet UILabel *Feed1_nearbySub;
    IBOutlet UILabel *Feed1_Recommend;
    IBOutlet UILabel *Feed1_RecommendSub;
    
    IBOutlet UIView *Feed2View;
    IBOutlet UIImageView *Feed2Img;
    IBOutlet UIButton *Feed2DoneButton;
    IBOutlet UILabel *Feed2_CollectIn;
    IBOutlet UILabel *Feed2_CollectInSub;
    IBOutlet UILabel *Feed2_Collect;
    IBOutlet UILabel *Feed2_CollectSub;
    IBOutlet UILabel *Feed2_Follow;
    IBOutlet UILabel *Feed2_FollowSub;
    
    IBOutlet UIView *ProfileView;
    IBOutlet UIImageView *ProfileImg;
    IBOutlet UIButton *ProfileDoneButton;
    IBOutlet UILabel *Profile_EditProfile;
    IBOutlet UILabel *Profile_EditProfileSub;
    IBOutlet UILabel *Profile_Collections;
    IBOutlet UILabel *Profile_CollectionsSub;
    
    IBOutlet UIView *EditPostView;
    IBOutlet UIImageView *EditPostImg;
    IBOutlet UIButton *EditPostDoneButton;
    IBOutlet UILabel *EditPost_Addurl;
    IBOutlet UILabel *EditPost_AddurlSub;
    IBOutlet UILabel *EditPost_Save;
    IBOutlet UILabel *EditPost_SaveSub;
    
    IBOutlet UIView *TranslateView;
    IBOutlet UIImageView *TranslateImg;
    IBOutlet UIButton *TranslateDoneButton;
    IBOutlet UILabel *Translate_Title;
    IBOutlet UILabel *Translate_Sub;
}
-(IBAction)Feed1DoneButtonOnClick:(id)sender;
-(IBAction)Feed2DoneButtonOnClick:(id)sender;
-(IBAction)ProfileDoneButtonOnClick:(id)sender;
-(IBAction)EditPostDoneButtonOnClick:(id)sender;
-(IBAction)TranslateDoneButtonOnClick:(id)sender;
@end
