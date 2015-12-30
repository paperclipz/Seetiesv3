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
#import "ProfileViewController.h"
#import "ShowFollowerAndFollowingViewController.h"
@class ProfileViewController;
@class ShowFollowerAndFollowingViewController;
@interface CollectionViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)ShowFollowerAndFollowingViewController* showFollowerAndFollowingViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)UINavigationController* navEditCollectionViewController;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;

-(void)GetCollectionID:(NSString *)ID_ GetPermision:(NSString *)PermisionUser GetUserUid:(NSString *)UserUid;
@end
