//
//  TestFeedV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/28/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestFeedV2ViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    UIRefreshControl *refreshControl;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UILabel *ShowFeedText;
    IBOutlet UIButton *SearchButton;
    IBOutlet UIButton *FilterButton;
    IBOutlet UIImageView *BarImage;
    
    int heightcheck;
    
    NSMutableArray *AddressArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    NSMutableArray *TypeArray;
}
-(IBAction)SearchButton:(id)sender;
@end
