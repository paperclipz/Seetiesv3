//
//  ShowFollowerAndFollowingViewController.h
//  SeetiesIOS
//
//  Created by Chong Chee Yong on 12/24/14.
//  Copyright (c) 2014 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "ProfileViewController.h"
@class ProfileViewController;
@interface ShowFollowerAndFollowingViewController : GAITrackedViewController<UIScrollViewDelegate>

@property(nonatomic,strong)ProfileViewController* profileViewController;
-(void)GetToken:(NSString *)Token GetUID:(NSString *)uid GetType:(NSString *)Type;
@end
