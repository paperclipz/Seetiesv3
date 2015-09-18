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
@interface CollectionViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIButton *MapButton;
    IBOutlet UIButton *MoreButton;
    
    NSString *GetID;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    NSURLConnection *theConnection_CollectionData;
    
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
    
    //Content Data
    NSMutableArray *Content_arrImage;
    
    UIButton *ListButton;
    UIButton *GridButton;
    
    UIView *ListView;
    UIView *GridView;
}
-(void)GetCollectionID:(NSString *)ID_;
@end
