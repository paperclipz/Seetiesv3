//
//  AddCollectionDataViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"
@interface AddCollectionDataViewController : UIViewController<UIScrollViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIButton *BackButton;
    IBOutlet AsyncImageView *PostImg;
    IBOutlet UITextView *NoteTextView;
    IBOutlet UITableView *tblview;
    IBOutlet UILabel *ShowNoteTextCount;
    IBOutlet UIButton *BackgroundBlackButton;
    
    NSString *GetPostID;
    NSString *GetImageData;
    NSString *GetCollectionID;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_CollectionData;
    NSURLConnection *theConnection_QuickCollect;
    
    NSMutableArray *CollectionData_IDArray;
    NSMutableArray *CollectionData_TitleArray;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    BOOL CheckReflash;
    
    IBOutlet UILabel *CollectThisTitle;
    IBOutlet UILabel *PickaCollectionTitle;
    IBOutlet UIButton *CreateCollectionButton;
}
-(void)GetPostID:(NSString *)PostID GetImageData:(NSString *)ImageData;
-(IBAction)CreateCollectionButton:(id)sender;
@end
