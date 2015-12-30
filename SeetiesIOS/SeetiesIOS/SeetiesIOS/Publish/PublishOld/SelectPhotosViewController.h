//
//  SelectPhotosViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 10/28/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface SelectPhotosViewController : GAITrackedViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate>{

    IBOutlet UIScrollView *AddImageScroll;
    IBOutlet UIImageView *ShowBigImage;
    IBOutlet UIButton *AddImgButton;
    IBOutlet UILabel *ShowTitle;
    UIImage *tempImg;
    NSMutableArray *ImgArray;
    
    NSString *GetType;
    IBOutlet UIButton *DoneButton;
    NSInteger getbuttonIDN;
    
    IBOutlet UIButton *TapToEdit;
    
    NSMutableArray *GetImgArray;
    
}
-(void)GetImgArray:(NSMutableArray *)imgarray;
-(void)GetType:(NSString *)Type;
-(IBAction)BackButton:(id)sender;
-(IBAction)AddImageButton:(id)sender;
-(IBAction)DoneButton:(id)sender;
-(IBAction)EditButton:(id)sender;
@end
