//
//  PostListingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/23/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "FeedV2DetailViewController.h"
@class FeedV2DetailViewController;
@interface PostListingViewController : CommonViewController
@property(nonatomic, copy)VoidBlock btnAddMorePostBlock;
@property(nonatomic, strong)FeedV2DetailViewController* feedV2DetailViewController;
-(void)initData:(ProfilePostModel*)model UserProfileModel:(ProfileModel*)profileModel ProfileViewType:(ProfileViewType)type;

@end
