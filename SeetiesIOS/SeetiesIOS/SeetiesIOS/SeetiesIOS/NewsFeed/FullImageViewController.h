//
//  FullImageViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "GAITrackedViewController.h"
@interface FullImageViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MImageScroll;
    IBOutlet UIPageControl *PageControlOn;
    NSMutableArray *GetAllFullImageArray;
    NSMutableArray *GetAllFullCaptionArray;
    NSInteger GetCurrentIdn;
    AsyncImageView *ShowImage;
    
    UIScrollView *ImageScroll;
    BOOL pageControlBeingUsed;
    
    IBOutlet UILabel *ShowImageCount;
    
    NSString *GetImageString;
    
    IBOutlet UIButton *BackButton;
}
-(IBAction)BackButton:(id)sender;
-(void)GetAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn GetAllCaptionArray:(NSMutableArray *)AllCaptionArray;
-(void)GetImageString:(NSString *)ImageString;
-(void)GetLocalAllImageArray:(NSMutableArray *)AllImageArray GetIDN:(NSInteger)ImageIdn;
@end
