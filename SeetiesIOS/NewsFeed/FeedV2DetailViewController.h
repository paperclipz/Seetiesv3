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
//#import "GAITrackedViewController.h"
#import "LLARingSpinnerView.h"
#import "EditPostViewController.h"
#import "ProfileViewController.h"
#import "CollectionListingViewController.h"
#import "SeetiesShopViewController.h"
#import "ReportProblemViewController.h"

@class ProfileViewController;
@class EditPostViewController;
@class CollectionListingViewController;
@interface FeedV2DetailViewController : CommonViewController<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
@property(nonatomic,strong)CollectionListingViewController* collectionListingViewController;
@property(nonatomic,strong)ShareV2ViewController* shareV2ViewController;
@property(nonatomic,strong)SeetiesShopViewController* seetiesShopViewController;

-(void)GetPostID:(NSString *)PostID;
@end
