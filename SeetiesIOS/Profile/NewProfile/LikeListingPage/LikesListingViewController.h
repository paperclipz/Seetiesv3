//
//  LikesListingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/26/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "FeedV2DetailViewController.h"

@class FeedV2DetailViewController;
@interface LikesListingViewController : CommonViewController
-(void)initData:(ProfilePostModel*)model;
@property(nonatomic, strong)FeedV2DetailViewController* feedV2DetailViewController;

@end
