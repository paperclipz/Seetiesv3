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

@class ProfileViewController;
@class EditPostViewController;
@interface FeedV2DetailViewController : GAITrackedViewController<UIScrollViewDelegate,UIActionSheetDelegate>
@property(nonatomic,strong)EditPostViewController* editPostViewController;
@property(nonatomic,strong)ProfileViewController* profileViewController;
-(void)GetPostID:(NSString *)PostID;
@end
