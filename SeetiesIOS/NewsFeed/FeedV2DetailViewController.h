//
//  FeedV2DetailViewController.h
//  SeetiesIOS
//
//  Created by Seeties IOS on 4/8/15.
//  Copyright (c) 2015 Ahyong87. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "UrlDataClass.h"
#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
#import "EditPostViewController.h"
#import "ProfileViewController.h"
#import "CollectionListingViewController.h"
#import "SeetiesShopViewController.h"

@class ProfileViewController;
@class EditPostViewController;
@class CollectionListingViewController;
@class CT3_SearchListingViewController;

@interface FeedV2DetailViewController : CommonViewController<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)SeetiesShopViewController* seetiesShopViewController;
@property(nonatomic,strong)CT3_SearchListingViewController* searchListingViewController;

-(void)GetPostID:(NSString *)PostID;
@end
