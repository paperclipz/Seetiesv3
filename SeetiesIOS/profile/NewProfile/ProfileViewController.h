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
#import "PostListingViewController.h"
#import "LikesListingViewController.h"
#import "EditProfileV2ViewController.h"
#import "SearchViewV2Controller.h"
#import "FeedV2DetailViewController.h"
#import "CT3_SearchListingViewController.h"


@class PostListingViewController;
@class LikesListingViewController;
@class ConnectionsViewController;
@class SearchDetailViewController;
@class CollectionViewController;
@class SearchViewV2Controller;
@class CT3_SearchListingViewController;

@interface ProfileViewController : CommonViewController<TLTagsControlDelegate>

@property(nonatomic,strong)CollectionViewController* collectionViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)EditCollectionViewController* editCollectionViewController;
@property(nonatomic,strong)PostListingViewController* postListingViewController;
@property(nonatomic,strong)LikesListingViewController* likesListingViewController;
@property(nonatomic,strong)EditProfileV2ViewController* editProfileV2ViewController;
@property(nonatomic,strong)SearchViewV2Controller* searchViewV2Controller;
@property(nonatomic,strong)ConnectionsViewController* connectionsViewController;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@property(nonatomic,strong)FeedV2DetailViewController* feedV2DetailViewController;
@property(nonatomic,strong)CT3_SearchListingViewController* searchListingViewController;

-(void)initDataWithUserID:(NSString*)uID;

@end
