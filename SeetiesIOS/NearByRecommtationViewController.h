//
//  NearByRecommtationViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 6/10/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByRecommtationViewController : UIViewController<UIScrollViewDelegate>{

    IBOutlet UILabel *TitleLabel;
    IBOutlet UIImageView *BarImage;
    IBOutlet UIScrollView *MainScroll;
    IBOutlet UIActivityIndicatorView *ShowActivity;
    
    NSMutableArray *LPhotoArray;
    NSMutableArray *PostIDArray;
    NSMutableArray *place_nameArray;
    NSMutableArray *UserInfo_UrlArray;
    NSMutableArray *UserInfo_NameArray;
    NSMutableArray *TitleArray;
    NSMutableArray *MessageArray;
    NSMutableArray *DistanceArray;
    NSMutableArray *SearchDisplayNameArray;
    NSMutableArray *TotalCommentArray;
    NSMutableArray *TotalLikeArray;
    NSMutableArray *SelfCheckLikeArray;
    
    int heightcheck;
}
-(void)GetLPhoto:(NSMutableArray *)Photo GetPostID:(NSMutableArray *)PostID GetPlaceName:(NSMutableArray *)PlaceName GetUserInfoUrl:(NSMutableArray *)UserInfoUrl GetUserInfoName:(NSMutableArray *)UserInfoName GetTitle:(NSMutableArray *)Title GetMessage:(NSMutableArray *)Message GetDistance:(NSMutableArray *)Distance GetSearchDisplayName:(NSMutableArray *)SearchDisplayName GetTotalComment:(NSMutableArray *)TotalComment GetTotalLike:(NSMutableArray *)TotalLike GetSelfCheckLike:(NSMutableArray *)SelfCheckLike;
@end
