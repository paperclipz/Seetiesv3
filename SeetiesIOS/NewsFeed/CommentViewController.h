//
//  CommentViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHInputToolbar.h"
#import "LLARingSpinnerView.h"
#import "ProfileViewController.h"
@class ProfileViewController;
@interface CommentViewController : UIViewController<UIScrollViewDelegate,BHInputToolbarDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)ProfileViewController* profileViewController;
@property (nonatomic, strong) BHInputToolbar *inputToolbar;

-(void)GetCommentIDArray:(NSMutableArray *)CommentIDArray GetPostIDArray:(NSMutableArray *)PostIDArray GetMessageArray:(NSMutableArray *)MessageArray GetUser_Comment_uidArray:(NSMutableArray *)User_Comment_uidArray GetUser_Comment_nameArray:(NSMutableArray *)User_Comment_nameArray GetUser_Comment_usernameArray:(NSMutableArray *)User_Comment_usernameArray GetUser_Comment_photoArray:(NSMutableArray *)User_Comment_photoArray;
-(void)GetRealPostID:(NSString *)PostID;
-(void)GetRealPostIDAndAllComment:(NSString *)PostIDN;
-(void)GetWhatView:(NSString *)WhatView;
-(IBAction)HideMentionsViewButton:(id)sender;

- (void)segmentAction:(UISegmentedControl *)segment;
@end
