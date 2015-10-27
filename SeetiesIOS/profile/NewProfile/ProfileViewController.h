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


@interface ProfileViewController : BaseViewController<TLTagsControlDelegate>

@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)SettingsViewController* settingsViewController;
@property(nonatomic,strong)PostListingViewController* postListingViewController;
@property(nonatomic,strong)LikesListingViewController* likesListingViewController;

@end
