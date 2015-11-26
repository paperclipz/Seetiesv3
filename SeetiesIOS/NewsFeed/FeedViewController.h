//
//  FeedViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 8/14/15.
//  Copyright (c) 2015 Stylar Network. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UrlDataClass.h"
#import "SuggestedCollectionPostsViewController.h"
#import "ProfileViewController.h"
#import "CollectionListingViewController.h"

@class ProfileViewController;
@interface FeedViewController : BaseViewController<UIScrollViewDelegate,CLLocationManagerDelegate>

@property(nonatomic,strong)SuggestedCollectionPostsViewController* followingCollectionPostsViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;

@end
