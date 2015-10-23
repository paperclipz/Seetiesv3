//
//  CollectionListingViewController.h
//  SeetiesIOS
//
//  Created by Evan Beh on 10/21/15.
//  Copyright © 2015 Stylar Network. All rights reserved.
//

#import "CommonViewController.h"
#import "CollectionListingTabViewController.h"

@interface CollectionListingViewController : CommonViewController <UIScrollViewDelegate>

@property(nonatomic,strong)CollectionListingTabViewController* myCollectionListingViewController;
@property(nonatomic,strong)CollectionListingTabViewController* followingCollectionListingViewController;

@end
