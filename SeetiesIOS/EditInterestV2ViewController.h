//
//  EditInterestV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/14/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditInterestV2ViewController : UIViewController{

    IBOutlet UILabel *ShowTitle;
    IBOutlet UIButton *SaveButton;
    IBOutlet UIImageView *BarImage;
}
-(IBAction)SaveButton:(id)sender;
-(IBAction)BackButton:(id)sender;
@end
