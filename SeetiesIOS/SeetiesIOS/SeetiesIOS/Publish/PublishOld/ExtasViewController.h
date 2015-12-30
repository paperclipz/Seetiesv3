//
//  ExtasViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface ExtasViewController : GAITrackedViewController<UITextFieldDelegate>{
    //IBOutlet SMTagField  *tagField;
    IBOutlet UILabel *ShowTagText;
    IBOutlet UITextField *LinkField;
    IBOutlet UISwitch *ShareFB;
    NSMutableArray *TagArray;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *DoneButton;
    IBOutlet UILabel *TagsText;
    IBOutlet UILabel *TagsDetail;
    IBOutlet UILabel *URLText;
    IBOutlet UILabel *AlsoShareTo;
}
-(IBAction)BackButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
@end
