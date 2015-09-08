//
//  EditProfileV2ViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/1/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "TPKeyboardAvoidingScrollView.h"
@interface EditProfileV2ViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIButton *SaveButton;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet AsyncImageView *BackgroundImg;
    IBOutlet AsyncImageView *UserImg;
    
    NSString *GetWallpaper;
    NSString *GetProfileImg;
}
-(IBAction)BackButton:(id)sender;
@end
