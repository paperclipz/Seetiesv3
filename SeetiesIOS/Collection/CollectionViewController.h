//
//  CollectionViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "AsyncImageView.h"
#import "EditCollectionViewController.h"
@interface CollectionViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIButton *MapButton;
    IBOutlet UIButton *MoreButton;
    IBOutlet UIView *DownBarView;
    IBOutlet UIButton *ShareButton;
    IBOutlet UIImageView *ShowBar;
    
    IBOutlet UIButton *TranslateButton;
    IBOutlet UIButton *ShareLinkButton;
    
    NSString *GetID;
    NSString *GetPermisionUser;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_CollectionData;
    NSURLConnection *theConnection_GetTranslate;
    NSURLConnection *theConnection_QuickCollect;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    
    //Collection Data
    NSString *GetTitle;
    NSString *GetDescription;
    NSString *GetUsername;
    NSString *GetUserProfile;
    NSString *GetLocation;
    NSString *GetTags;
    NSMutableArray *ArrHashTag;
    NSMutableArray *GetLanguagesArray;
    NSString *GetIsPrivate;
    
    //Content Data
    NSMutableArray *Content_arrImage;
    NSMutableArray *Content_arrTitle;
    NSMutableArray *Content_arrMessage;
    NSMutableArray *Content_arrPlaceName;
    NSMutableArray *Content_arrNote;
    NSMutableArray *Content_arrID;
    NSMutableArray *Content_arrID_arrDistance;
    NSMutableArray *Content_arrID_arrDisplayCountryName;
    NSMutableArray *Content_arrUserName;
    NSMutableArray *Content_arrCollect;
    
    UIButton *ListButton;
    UIButton *GridButton;
    
    UIView *ListView;
    UIView *GridView;
    
    int CheckClick;
    
    NSString *GetPostID;
    NSString *CheckCollect;
    int GetCollectionHeight;
    IBOutlet UILabel *ShowTitleInTop;
}
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)UINavigationController* navEditCollectionViewController;
-(void)GetCollectionID:(NSString *)ID_ GetPermision:(NSString *)PermisionUser;
@end
