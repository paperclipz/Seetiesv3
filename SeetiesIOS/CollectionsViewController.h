//
//  CollectionsViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 11/11/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
@interface CollectionsViewController : GAITrackedViewController<UIScrollViewDelegate>{

    IBOutlet UILabel *ShowTitle;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIView *ShowNoDataView;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSMutableArray *CategoryArray;
    NSMutableArray *LPhotoArray;
    NSMutableArray *TitleArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_AddressArray;
    NSMutableArray *UserInfo_uidArray;
    NSMutableArray *UserInfo_FollowingArray;
    NSMutableArray *LocationArray;
    NSMutableArray *FullPhotoArray;
    NSMutableArray *MessageArray;
    NSMutableArray *LikesArray;
    NSMutableArray *CommentArray;
    NSMutableArray *LangArray;
    NSMutableArray *LatArray;
    NSMutableArray *LongArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *CheckLikeArray;
    NSMutableArray *Activities_profile_photoArray;
    NSMutableArray *Activities_typeArray;
    NSMutableArray *Activities_uidArray;
    NSMutableArray *Activities_usernameArray;
    NSMutableArray *LinkArray;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    
    NSURLConnection *theConnection_GetPost;
    NSURLConnection *theConnection_MorePost;
    
    BOOL CheckLoad;
}
-(void)GetWhatYourLike;
@end
