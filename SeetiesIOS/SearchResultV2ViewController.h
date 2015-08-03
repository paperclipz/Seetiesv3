//
//  SearchResultV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultV2ViewController : UIViewController<UITextFieldDelegate>{

    IBOutlet UIImageView *BarImage;
    IBOutlet UITextField *SearchTextField;
    IBOutlet UITextField *SearchAddressField;
    IBOutlet UIButton *CancelButton;
    IBOutlet UIButton *FilterButton;
    
    UISegmentedControl *PostControl;
}
-(IBAction)CancelButton:(id)sender;
@end
