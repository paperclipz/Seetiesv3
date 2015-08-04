//
//  PInterestV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/24/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PInterestV2ViewController : UIViewController<UIScrollViewDelegate>{

    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSubTitle;
    IBOutlet UIButton *DoneButton;
    IBOutlet UIScrollView *MainScroll;
    
    NSMutableArray *GetCategoryIDArray;
    NSMutableArray *GetNameArray;
    NSMutableArray *GetBackgroundColorArray;
    NSMutableArray *GetImageArray;
}

@end
