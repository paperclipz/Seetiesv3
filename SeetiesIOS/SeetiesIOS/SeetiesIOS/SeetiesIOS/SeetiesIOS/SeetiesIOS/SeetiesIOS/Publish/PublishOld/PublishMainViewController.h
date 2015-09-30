//
//  PublishMainViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface PublishMainViewController : GAITrackedViewController{

    IBOutlet UILabel *ShowUsername;
    IBOutlet UILabel *DetailLabel;
    IBOutlet UILabel *DraftsLabel;
    IBOutlet UILabel *RecommendText;
    IBOutlet UILabel *SomethingText;

}
-(IBAction)PublishButton:(id)sender;
-(IBAction)DraftsButton:(id)sender;
@end
