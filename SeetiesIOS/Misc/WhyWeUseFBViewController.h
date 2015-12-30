//
//  WhyWeUseFBViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/19/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface WhyWeUseFBViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UILabel *ShowWhyFacebook;
    IBOutlet UILabel *ShowDetail;
    IBOutlet UILabel *ShowPrivacy;
    IBOutlet UIButton *OkButton;
    IBOutlet UIScrollView *MainScroll;
}
-(IBAction)BackButton:(id)sender;

@end
