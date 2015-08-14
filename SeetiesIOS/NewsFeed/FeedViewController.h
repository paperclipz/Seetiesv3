//
//  FeedViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/14/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedViewController : UIViewController<UIScrollViewDelegate>{
    
    IBOutlet UIScrollView *MainScroll;
    UIRefreshControl *refreshControl;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    IBOutlet UILabel *ShowFeedText;
    IBOutlet UIButton *SearchButton;
    IBOutlet UIButton *FilterButton;
    IBOutlet UIImageView *BarImage;
    
    int heightcheck;
    int TestCheck;
    int TotalCount;
    
    NSMutableArray *arrAddress;
    NSMutableArray *arrTitle;
    NSMutableArray *arrMessage;
    NSMutableArray *arrType;
    NSMutableArray *arrImage;
}
-(IBAction)SearchButton:(id)sender;

@end
