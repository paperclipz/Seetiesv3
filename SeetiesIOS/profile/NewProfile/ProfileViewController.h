//
//  ProfileViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/9/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "BaseViewController.h"
#import "TLTagsControl.h"
#import "CollectionViewController.h"
#import "CollectionListingViewController.h"
#import "EditCollectionViewController.h"
#import "SettingsViewController.h"
#import "PostListingViewController.h"
#import "LikesListingViewController.h"
#import "EditProfileV2ViewController.h"
#import "SearchViewV2Controller.h"


#import "ShowFollowerAndFollowingViewController.h"
#import "SearchDetailViewController.h"

#import "ShareViewController.h"

@class PostListingViewController;
@class LikesListingViewController;

@interface ProfileViewController : BaseViewController<TLTagsControlDelegate>

@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)SettingsViewController* settingsViewController;
@property(nonatomic,strong)PostListingViewController* postListingViewController;
@property(nonatomic,strong)LikesListingViewController* likesListingViewController;

@property(nonatomic,strong)EditProfileV2ViewController* editProfileV2ViewController;
@property(nonatomic,strong)SearchViewV2Controller* searchViewV2Controller;

@property(nonatomic,strong)ShowFollowerAndFollowingViewController* showFollowerAndFollowingViewController;

@property(nonatomic,strong)SearchDetailViewController* searchDetailViewController;

@property(nonatomic,copy)VoidBlock btnAddMorePostClickedBlock;
@property(nonatomic,strong)ShareViewController* shareViewController;
-(void)requestAllDataWithType:(ProfileViewType)type UserID:(NSString*)uID;

@end
