//
//  ShareToFrenViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 27/10/2015.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "AsyncImageView.h"
#import "UrlDataClass.h"
@interface ShareToFrenViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>{

    IBOutlet TPKeyboardAvoidingScrollView *MainScroll;
    IBOutlet UIButton *BackButton;
    IBOutlet UITextField *SearchKeywordField;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    IBOutlet UILabel *ShowTitle;
    IBOutlet UILabel *ShowSendTo;
    
    IBOutlet UIButton *Line01;
    IBOutlet UIButton *Line02;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_GetFriendsListData;
    NSURLConnection *theConnection_SendCollectionata;
    NSURLConnection *theConnection_SendPostsData;
    
    //friends data
    NSMutableArray *arrUID;
    NSMutableArray *arrusername;
    NSMutableArray *arrProfileImg;
    
    NSString *ShareUserUID;
    NSString *GetPostsID;
    NSString *GetCollectionID;
}
-(void)GetPostsID:(NSString *)PostID GetCollectionID:(NSString *)CollectionID;
@end
