//
//  BrightnessViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/20/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrightnessViewController : UIViewController{
    
    IBOutlet UIImageView *ShowBigImage;
    NSMutableArray *GetImageArray;
    NSInteger GetSelectCount;
    
    CIContext *context;
    CIFilter *filter;
    CIImage *beginImage;
    UIImageOrientation orientation; // New!
    
    IBOutlet UILabel *ShowBrightnessText;
    IBOutlet UIButton *SaveButton;
    
    IBOutlet UIImageView *ShowIcon1;
    IBOutlet UIImageView *ShowIcon2;
    IBOutlet UISlider *Slider;
    
}

-(IBAction)BackButton:(id)sender;
-(IBAction)SaveButton:(id)sender;

//testing
-(void)GetImageData:(NSArray *)ImageArray GetSelectCount:(NSInteger)SelectCount;
@end
