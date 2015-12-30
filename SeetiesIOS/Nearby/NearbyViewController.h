//
//  NearbyViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 9/18/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "AsyncImageView.h"
@interface NearbyViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIImageView *BarImage;
    IBOutlet UILabel *ShowTitle;
    
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    UrlDataClass *DataUrl;
    NSMutableData *webData;
    
    NSString *GetLatdata;
    NSString *GetLongData;
    
    NSURLConnection *theConnection_Nearby;
    NSURLConnection *theConnection_QuickCollect;
    
    NSInteger TotalPage;
    NSInteger CurrentPage;
    NSInteger DataCount;
    NSInteger DataTotal;
    BOOL CheckLoad;
    int CheckFirstTimeLoad;
    int GetHeight;
    
    NSMutableArray *LPhotoArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *LocationArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    NSMutableArray *DistanceArray;
    NSMutableArray *SearchDisplayNameArray;
    NSMutableArray *TotalCommentArray;
    NSMutableArray *TotalLikeArray;
    NSMutableArray *SelfCheckLikeArray;
    NSMutableArray *arrCollect;
    
    NSMutableArray *arrlat;
    NSMutableArray *arrlng;
    
    NSString *CheckCollect;
    NSString *GetPostID;
    
    UIButton *CenterLine;
    
    MKPointAnnotation *MainAnnotation;
    
}
-(void)Getlat:(NSString *)lat GetLong:(NSString *)Long;
@end
