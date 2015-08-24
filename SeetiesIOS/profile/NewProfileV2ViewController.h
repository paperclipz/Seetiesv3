//
//  NewProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 7/29/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "A3ParallaxScrollView.h"
@interface NewProfileV2ViewController : BaseViewController<UIScrollViewDelegate>{

    IBOutlet A3ParallaxScrollView *MainScroll;
    IBOutlet UIImageView *BackgroundImage;
    IBOutlet UIView *AllContentView;
    
    int GetHeight;
    
    UISegmentedControl *ProfileControl;
    
    UIView *PostView;
    UIView *CollectionView;
    UIView *LikeView;
}
-(IBAction)SettingsButton:(id)sender;
@end
