//
//  CommentViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInputToolbar.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
@interface CommentViewController : GAITrackedViewController<UIScrollViewDelegate,BHInputToolbarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    BHInputToolbar *inputToolbar;
    
    IBOutlet UIView *ShowNoDataView;
    IBOutlet UILabel *ShowMainTitle;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIImageView *NoCommentImage;
    
@private
    BOOL keyboardIsVisible;
    BOOL isFirstShowKeyboard;
    BOOL isButtonClicked;
    BOOL isKeyboardShowing;
    BOOL isSystemBoardShow;
    
    IBOutlet UIView *toolBar;
    IBOutlet UITextField *TextString;
    IBOutlet UIButton *sendButton;
    CGFloat keyboardHeight;

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIScrollView *LikeScroll;
   // IBOutlet UITextField *textField;
    
    NSMutableArray *GetCommentIDArray;
    NSMutableArray *GetPostIDArray;
    NSMutableArray *GetMessageArray;
    NSMutableArray *GetUser_Comment_uidArray;
    NSMutableArray *GetUser_Comment_nameArray;
    NSMutableArray *GetUser_Comment_usernameArray;
    NSMutableArray *GetUser_Comment_photoArray;
    
    NSString *GetPostIDN;
    NSString *GetMessage;
    NSString *GetMentionsString;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSURLConnection *theConnection_Comment;
    NSURLConnection *theConnection_Mentions;
    NSURLConnection *theConnection_GetComment;
    NSURLConnection *theConnection_GetAllUserlikes;
    NSURLConnection *theConnection_SendFollowData;
    NSURLConnection *theConnection_DeleteCommentData;
    
    IBOutlet UILabel *ShowNoDataText_1;
    IBOutlet UILabel *ShowNoDataText_2;
    
    int checkDataLoading;
    
    IBOutlet UIView *MentionsView;
    IBOutlet UITableView *MetionsTblview;
    IBOutlet UIButton *BlackgroundButton;
    IBOutlet UIButton *BlackgroundWhiteButton;
    
    
    NSMutableArray *Mentions_UsernameArray;
    NSMutableArray *Mentions_NameArray;
    NSMutableArray *Mentions_uidArray;
    NSMutableArray *Mentions_ProfilePhotoArray;
    
    NSString *GetCommentCount;
    NSString *GetMentionsUID;
    
    int checkagain;
    
    NSMutableArray *TagNameArray;
    
    NSMutableArray *Like_UseruidArray;
    NSMutableArray *Like_UserProfilePhotoArray;
    NSMutableArray *Like_UsernameArray;
    NSMutableArray *Like_UserFollowingArray;
    
    NSString *SendFollowData;
    NSString *SendUserUid;
    
    NSString *GetWhatView;
    
    //LLARingSpinnerView *spinnerView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    NSString *GetDeletePostID;
    NSString *GetDeleteCommentID;
}
@property (nonatomic, strong) BHInputToolbar *inputToolbar;
-(IBAction)BackButton:(id)sender;
-(IBAction)SendButton:(id)sender;
-(void)GetCommentIDArray:(NSMutableArray *)CommentIDArray GetPostIDArray:(NSMutableArray *)PostIDArray GetMessageArray:(NSMutableArray *)MessageArray GetUser_Comment_uidArray:(NSMutableArray *)User_Comment_uidArray GetUser_Comment_nameArray:(NSMutableArray *)User_Comment_nameArray GetUser_Comment_usernameArray:(NSMutableArray *)User_Comment_usernameArray GetUser_Comment_photoArray:(NSMutableArray *)User_Comment_photoArray;
-(void)GetRealPostID:(NSString *)PostID;
-(void)GetRealPostIDAndAllComment:(NSString *)PostIDN;
-(void)GetWhatView:(NSString *)WhatView;
-(IBAction)HideMentionsViewButton:(id)sender;

- (void)segmentAction:(UISegmentedControl *)segment;
@end
