//
//  TestFeedV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/28/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

<<<<<<< HEAD
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
=======
@interface TestFeedV2ViewController : UIViewController<UIScrollViewDelegate>
>>>>>>> 51808a06ba337fe0ab3d9ee605e63dc1504fd9ae
@end
