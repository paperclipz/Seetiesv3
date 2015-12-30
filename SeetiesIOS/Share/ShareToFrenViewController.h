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
#import "ShareManager.h"
@interface ShareToFrenViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>{

    IBOutlet UIScrollView *MainScroll;
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
    NSURLConnection *theConnection_SendSeetiShopData;
    
    //friends data
    NSMutableArray *arrUID;
    NSMutableArray *arrusername;
    NSMutableArray *arrProfileImg;
    
    NSString *ShareUserUID;
    NSString *GetShareID;
    NSString *GetUserID;
    NSInteger GetType;
}
-(void)GetID:(NSString *)ID GetUserID:(NSString *)userID GetType:(ShareType)type;
@end
