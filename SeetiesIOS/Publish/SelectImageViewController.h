//
//  SelectImageViewController.h
//  PhotoDemo
//
//  Created by Seeties IOS on 3/19/15.
//  Copyright (c) 2015 Seeties IOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "LLARingSpinnerView.h"
#import "GAITrackedViewController.h"
@interface SelectImageViewController : BaseViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIView *AlbumView;
    IBOutlet UITableView *AlbumTblView;
    IBOutlet UILabel *ShowChooseUpText;
    LLARingSpinnerView *spinnerView;
    
    __block NSMutableArray *thumbsArr;
    __block NSMutableArray *FullArr;
    __block NSMutableArray *urlArray;
    __block NSMutableArray *LocationArray;
    __block NSMutableArray *DateArray;
    NSMutableArray *selectedIndexArr_Thumbs;
    NSMutableArray *selectedIndexArr_Location;
    NSMutableArray *selectedIndexArr_Date;
    
    IBOutlet UIButton *SelectAlbumButton;
    NSInteger CountSelectImg;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UIButton *SelectButton;
    
    NSString *CheckViewData;
    NSString *CheckDraft;
    
    IBOutlet UILabel *ChoosePhotoText;
    IBOutlet UILabel *DoneText;
    IBOutlet UIButton *DoneButton;
    IBOutlet UIImageView *ArrowImg;
    
    IBOutlet UIImageView *AlbumWhiteBack;
    IBOutlet UIButton *AlbumBackImg;
    
    NSInteger PhotoCount;
    BOOL CheckDone;
}
-(void)GetBackSelectData:(NSMutableArray *)SelectedIndexArr BackView:(NSString *)CheckView CheckDraft:(NSString *)DraftCheck;
-(IBAction)BackButton:(id)sender;

-(IBAction)CloseAlbumButton:(id)sender;
@end
